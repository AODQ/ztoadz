const mtr = @import("../src/mtr/package.zig");
const std = @import("std");

fn compareValues(failStr : anytype, actual : u8, expected : u8,) void {
  _ = std.testing.expect(actual == expected) catch {};
  if (actual != expected) {
    std.log.err("failure '{s}': {} == {}", .{failStr, actual, expected});
  }
}

test "pipeline - simple graph" {
  // rasterizes a simple graph by setting each pixel to a specific line in a
  // shader storage buffer

  const moduleFileData align(@alignOf(u32)) = (
    @embedFile("../shaders/simple-graph-line.spv")
  );

  std.testing.log_level = .debug;

  var debugAllocator =
    std.heap.GeneralPurposeAllocator(
      .{
        .enable_memory_limit = true,
        .safety = true,
      }
    ){};
  defer {
    const leaked = debugAllocator.deinit();
    if (leaked) std.log.info("{s}", .{"leaked memory"});
  }

  var mtrCtx = (
    mtr.Context.init(
      &debugAllocator.allocator,
      mtr.RenderingOptimizationLevel.debug,
    )
  );
  defer mtrCtx.deinit();

  const queue : mtr.queue.Idx = (
    try mtrCtx.constructQueue(.{
      .workType = mtr.queue.WorkType{.transfer = true, .render = true},
    })
  );

  const commandPoolScratch : mtr.command.PoolIdx = (
    try mtrCtx.constructCommandPool(.{
      .flags = .{ .transient = true, .resetCommandBuffer = true },
      .queue = queue,
    })
  );

  const commandBufferScratch : mtr.command.BufferIdx = (
    try mtrCtx.constructCommandBuffer(.{
      .commandPool = commandPoolScratch,
    })
  );

  // compile error: https://github.com/ziglang/zig/issues/9472
  // const moduleFileDataAsSlice : [] align(@alignOf(u32)) const u8 = (
  //   @alignCast(@alignOf(u32), moduleFileData[0 .. std.mem.len(moduleFileData)])
  // );
  var moduleFileDataAsSlice = (
    std.ArrayListAligned(u8, @alignOf(u32)).init(&debugAllocator.allocator)
  );
  defer moduleFileDataAsSlice.deinit();
  try moduleFileDataAsSlice.resize(std.mem.len(moduleFileData));

  const moduleFileDataAsSliceCp : [] const u8 = (
    moduleFileData[0 .. std.mem.len(moduleFileData)]
  );
  std.mem.copy(u8, moduleFileDataAsSlice.items, moduleFileDataAsSliceCp);

  const shaderModule = (
    try mtrCtx.createShaderModule(
      mtr.shader.ConstructInfo {
        .data = moduleFileDataAsSlice.items,
      }
    )
  );

  _ = commandBufferScratch;

  // create descriptor set

  const outputColorImageBinding : u32 = 0;
  const inputGraphBinding       : u32 = 1;

  const descriptorSetPoolPerFrame = (
    try mtrCtx.createDescriptorSetPool(.{
      .frequency = .perFrame,
      .maxSets = 10,
      .descriptorSizes = .{
        .sampledImage = 10,
        .sampler = 10,
        .storageBuffer = 10,
        .storageImage = 10,
        .uniformBuffer = 10,
      },
    })
  );

  // output color image
  var outputColorImage : mtr.image.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    outputColorImage = try (
      heapRegionAllocator.createImage(.{
        .offset = 0,
        .width = 512, .height = 512, .depth = 1,
        .samplesPerTexel = mtr.image.Sample.s1,
        .arrayLayers = 1,
        .mipmapLevels = 1,
        .byteFormat = mtr.image.ByteFormat.uint8,
        .channels = mtr.image.Channel.RGBA,
        .normalized = true,
        .queueSharing = .exclusive,
      })
    );
  }

  // image view of output color image
  var outputColorImageView = try (
    mtrCtx.createImageView(.{.image = outputColorImage, })
  );

  // input graph
  var inputGraphBuffer : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    inputGraphBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(u32)*512,
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true, .transferDst = true }
        ),
        .queueSharing = .exclusive,
      })
    );
  }

  {
    var inputGraph = std.ArrayList(u32).init(&debugAllocator.allocator);
    defer inputGraph.deinit();
    try inputGraph.resize(512);

    var rnd = std.rand.Xoroshiro128.init(0);

    for (inputGraph.items) |_, idx| {
      inputGraph.items[idx] = rnd.random().int(u32) % 512;
    }
    try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
      .queue = queue,
      .commandBuffer = commandBufferScratch,
      .bufferDst = inputGraphBuffer,
      .memoryToUpload = std.mem.sliceAsBytes(inputGraph.items),
    });

    mtrCtx.queueFlush(queue);
  }

  const descriptorSetLayoutPerFrame = (
    try mtrCtx.createDescriptorSetLayout(.{
      .pool = descriptorSetPoolPerFrame,
      .frequency = .perFrame,
      .bindings = (
        (&[_] mtr.descriptor.SetLayoutBinding {
          mtr.descriptor.SetLayoutBinding{
            .descriptorType = .storageImage,
            .binding = outputColorImageBinding,
          },
          mtr.descriptor.SetLayoutBinding{
            .descriptorType = .storageBuffer,
            .binding = inputGraphBinding,
          },
        })
      ),
    })
  );

  const pipelineLayout = (
    try mtrCtx.createPipelineLayout(.{
      .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
        descriptorSetLayoutPerFrame
      },
    })
  );

  var computePipeline = try (
    mtrCtx.createComputePipeline(.{
      .computeFlags = .{},
      .stageFlags = .{},
      .shaderModule = shaderModule,
      .pName = "main",
      .layout = pipelineLayout,
    })
  );

  var descriptorSetPerFrame = try (
    mtrCtx.createDescriptorSet(.{
      .pool = descriptorSetPoolPerFrame,
      .layout = descriptorSetLayoutPerFrame,
    })
  );

  { // -- write per-frame descriptors
    var descriptorSetByFrameWriter = (
      mtrCtx.createDescriptorSetWriter( // TODO use struct
        descriptorSetLayoutPerFrame, // .descriptorSetLayout =
        descriptorSetPerFrame, // .descriptorSet =
      )
    );
    defer descriptorSetByFrameWriter.finish();

    try descriptorSetByFrameWriter.set(
      .{
        .binding = outputColorImageBinding,
        .imageView = outputColorImageView,
      },
    );

    try descriptorSetByFrameWriter.set(
      .{
        .binding = inputGraphBinding,
        .buffer = inputGraphBuffer,
      },
    );
  }

  var outputColorImageTape = (
    mtr.memory.ImageTape { .image = outputColorImage, }
  );

  {
    var commandBufferRecorder = (
      mtrCtx.createCommandBufferRecorder(commandBufferScratch)
    );
    defer commandBufferRecorder.finish();

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .begin = true },
        .dstStage = .{ .compute = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            mtr.command.PipelineBarrier.ImageTapeAction {
              .tape = &outputColorImageTape,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = computePipeline,
      }
    );

    commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { descriptorSetPerFrame }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.Dispatch {
        .width = 512/16, .height = 512/8, .depth = 1,
      }
    );
  }

  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);

  try mtr.util.screenshot.storeImageToFile(
    &mtrCtx, .{
      .queue = queue,
      .srcStage = .{ .compute = true },
      .commandBuffer = commandBufferScratch,
      .imageToStore = outputColorImage,
      .imageToStoreTape = &outputColorImageTape,
      .filename = "simple-graph.ppm",
    }
  );
}
