const mtr = @import("../src/mtr/package.zig");
const std = @import("std");

fn compareValues(failStr : anytype, actual : u8, expected : u8,) void {
  _ = std.testing.expect(actual == expected) catch {};
  if (actual != expected) {
    std.log.err("failure '{s}': {} == {}", .{failStr, actual, expected});
  }
}

test "pipeline - UVCoord To Screen" {
  // rasterizes a simple triangle
  // tests the 'rasterize' command

  const moduleFileData align(@alignOf(u32)) = (
    @embedFile("../shaders/clear-screen-uv.spv")
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
        })
      ),
    })
  );

  var testBufferRead : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.hostVisible);
    defer _ = heapRegionAllocator.finish();

    testBufferRead = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = 512*512*4*1, // bytes, rgba, width, height
        .usage = mtr.buffer.Usage{ .transferDst=true },
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      })
    );
  }

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
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      })
    );
  }

  // image view of output color image
  var outputColorImageView = try (
    mtrCtx.createImageView(.{.image = outputColorImage, })
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
  }

  var testBufferReadTape = mtr.command.BufferTape { .buffer = testBufferRead, };
  var outputColorImageTape = (
    mtr.command.ImageTape { .image = outputColorImage, }
  );

  _ = testBufferReadTape;

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
              .accessFlags = .{},
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

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .transfer = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            mtr.command.PipelineBarrier.BufferTapeAction {
              .tape = &testBufferReadTape,
              .accessFlags = .{ .transferWrite = true },
            },
          }
        ),
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            mtr.command.PipelineBarrier.ImageTapeAction {
              .tape = &outputColorImageTape,
              .layout = .transferSrc,
              .accessFlags = .{ .transferRead = true },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.TransferImageToBuffer {
        .imageSrc = outputColorImage,
        .bufferDst = testBufferRead,
        .width = 4, .height = 4,
      },
    );

    // commandBufferRecorder.append(
    //   mtr.command.PipelineBarrier {
    //     .srcStage = .{ .transfer = true },
    //     .dstStage = .{ .host = true },
    //     .bufferTapes = (
    //       &[_] mtr.command.PipelineBarrier.BufferTapeAction {
    //         mtr.command.PipelineBarrier.BufferTapeAction {
    //           .tape = &testBufferReadTape,
    //           .accessFlags = .{ .hostRead = true },
    //         },
    //       }
    //     ),
    //   },
    // );
  }

  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);
}
