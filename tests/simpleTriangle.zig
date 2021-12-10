const mtr = @import("../src/mtr/package.zig");
const util = @import("../src/util/package.zig");
const std = @import("std");

fn compareValues(failStr : anytype, actual : u8, expected : u8,) void {
  _ = std.testing.expect(actual == expected) catch {};
  if (actual != expected) {
    std.log.err("failure '{s}': {} == {}", .{failStr, actual, expected});
  }
}

test "pipeline - simple triangle" {
  // rasterizes a simple triangle

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

  const fragmentModuleFileData = try (
    util.readFileAlignedU32(
      &debugAllocator.allocator,
      "shaders/simple-triangle-frag.spv"
    )
  );
  defer fragmentModuleFileData.deinit();

  const fragmentShaderModule = (
    try mtrCtx.createShaderModule(
      mtr.shader.ConstructInfo {
        .data = fragmentModuleFileData.items,
      }
    )
  );

  const vertexModuleFileData = try (
    util.readFileAlignedU32(
      &debugAllocator.allocator,
      "shaders/simple-triangle-vert.spv"
    )
  );
  defer vertexModuleFileData.deinit();

  const vertexShaderModule = (
    try mtrCtx.createShaderModule(
      mtr.shader.ConstructInfo {
        .data = vertexModuleFileData.items,
      }
    )
  );

  // create descriptor set

  const outputColorImageBinding : u32 = 0;
  const inputTriangleVertexAssemblyBinding : u32 = 0;
  const inputTriangleVertexIntermediaryBinding : u32 = 1;
  const inputTriangleVertexAssemblyMetadataBinding : u32 = 2;

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

  // input triangle VAsm
  var inputTriangleVertexAssemblyBuffer  : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    inputTriangleVertexAssemblyBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(f32)*4*3 * 12, // cube
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true, .transferDst = true }
        ),
        .queueSharing = .exclusive,
      })
    );
  }

  // output triangle VAsm
  var inputTriangleVertexIntermediaryBuffer  : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    inputTriangleVertexIntermediaryBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(f32)*4*3 * 12, // cube
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true }
        ),
        .queueSharing = .exclusive,
      })
    );
  }

  // output triangle VAsm metadata
  var inputTriangleVertexAssemblyMetadataBuffer  : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    inputTriangleVertexAssemblyMetadataBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(u32)*1,
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true, .transferDst = true }
        ),
        .queueSharing = .exclusive,
      })
    );
  }

  try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
    .queue = queue,
    .commandBuffer = commandBufferScratch,
    .bufferDst = inputTriangleVertexAssemblyBuffer,
    .memoryToUpload = (
      std.mem.sliceAsBytes(
        &[_] f32 {
          -1.0,-1.0,-1.0, 1.0,
          -1.0,-1.0, 1.0, 1.0,
          -1.0, 1.0, 1.0, 1.0,

          1.0, 1.0,-1.0, 1.0,
          -1.0,-1.0,-1.0, 1.0,
          -1.0, 1.0,-1.0, 1.0,

          1.0,-1.0, 1.0, 1.0,
          -1.0,-1.0,-1.0, 1.0,
           1.0,-1.0,-1.0, 1.0,

           1.0, 1.0,-1.0, 1.0,
           1.0,-1.0,-1.0, 1.0,
           -1.0,-1.0,-1.0, 1.0,

          -1.0,-1.0,-1.0, 1.0,
          -1.0, 1.0, 1.0, 1.0,
          -1.0, 1.0,-1.0, 1.0,

          1.0,-1.0, 1.0, 1.0,
          -1.0,-1.0, 1.0, 1.0,
          -1.0,-1.0,-1.0, 1.0,

          -1.0, 1.0, 1.0, 1.0,
          -1.0,-1.0, 1.0, 1.0,
           1.0,-1.0, 1.0, 1.0,

           1.0, 1.0, 1.0, 1.0,
           1.0,-1.0,-1.0, 1.0,
           1.0, 1.0,-1.0, 1.0,

           1.0,-1.0,-1.0, 1.0,
           1.0, 1.0, 1.0, 1.0,
           1.0,-1.0, 1.0, 1.0,

           1.0, 1.0, 1.0, 1.0,
           1.0, 1.0,-1.0, 1.0,
           -1.0, 1.0,-1.0, 1.0,

           1.0, 1.0, 1.0, 1.0,
           -1.0, 1.0,-1.0, 1.0,
          -1.0, 1.0, 1.0, 1.0,

          1.0, 1.0, 1.0, 1.0,
          -1.0, 1.0, 1.0, 1.0,
          1.0,-1.0, 1.0, 1.0,
        }
      )
    ),
  });

  mtrCtx.queueFlush(queue);

  try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
    .queue = queue,
    .commandBuffer = commandBufferScratch,
    .bufferDst = inputTriangleVertexAssemblyMetadataBuffer,
    .memoryToUpload = (
      std.mem.sliceAsBytes(
        &[_] u32 { 12 },
      )
    ),
  });

  mtrCtx.queueFlush(queue);

  const descriptorSetLayoutFragmentPerFrame = (
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
            .binding = inputTriangleVertexIntermediaryBinding,
          },
          mtr.descriptor.SetLayoutBinding{
            .descriptorType = .storageBuffer,
            .binding = inputTriangleVertexAssemblyMetadataBinding,
          },
        })
      ),
    })
  );

  const fragmentPipelineLayout = (
    try mtrCtx.createPipelineLayout(.{
      .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
        descriptorSetLayoutFragmentPerFrame
      },
    })
  );

  const descriptorSetLayoutVertexPerFrame = (
    try mtrCtx.createDescriptorSetLayout(.{
      .pool = descriptorSetPoolPerFrame,
      .frequency = .perFrame,
      .bindings = (
        (&[_] mtr.descriptor.SetLayoutBinding {
          mtr.descriptor.SetLayoutBinding{
            .descriptorType = .storageBuffer,
            .binding = inputTriangleVertexAssemblyBinding,
          },
          mtr.descriptor.SetLayoutBinding{
            .descriptorType = .storageBuffer,
            .binding = inputTriangleVertexIntermediaryBinding,
          },
          mtr.descriptor.SetLayoutBinding{
            .descriptorType = .storageBuffer,
            .binding = inputTriangleVertexAssemblyMetadataBinding,
          },
        })
      ),
    })
  );

  const vertexPipelineLayout = (
    try mtrCtx.createPipelineLayout(.{
      .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
        descriptorSetLayoutVertexPerFrame
      },
    })
  );

  var computeFragmentPipeline = try (
    mtrCtx.createComputePipeline(.{
      .computeFlags = .{},
      .stageFlags = .{},
      .shaderModule = fragmentShaderModule,
      .pName = "main",
      .layout = fragmentPipelineLayout,
    })
  );

  var computeVertexPipeline = try (
    mtrCtx.createComputePipeline(.{
      .computeFlags = .{},
      .stageFlags = .{},
      .shaderModule = vertexShaderModule,
      .pName = "main",
      .layout = vertexPipelineLayout,
    })
  );

  var descriptorSetFragmentPerFrame = try (
    mtrCtx.createDescriptorSet(.{
      .pool = descriptorSetPoolPerFrame,
      .layout = descriptorSetLayoutFragmentPerFrame,
    })
  );

  { // -- write FRAGMENT per-frame descriptors
    var descriptorSetByFrameWriter = (
      mtrCtx.createDescriptorSetWriter( // TODO use struct
        descriptorSetLayoutFragmentPerFrame, // .descriptorSetLayout =
        descriptorSetFragmentPerFrame, // .descriptorSet =
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
        .binding = inputTriangleVertexIntermediaryBinding,
        .buffer = inputTriangleVertexIntermediaryBuffer,
      },
    );

    try descriptorSetByFrameWriter.set(
      .{
        .binding = inputTriangleVertexAssemblyMetadataBinding,
        .buffer = inputTriangleVertexAssemblyMetadataBuffer,
      },
    );
  }

  var descriptorSetVertexPerFrame = try (
    mtrCtx.createDescriptorSet(.{
      .pool = descriptorSetPoolPerFrame,
      .layout = descriptorSetLayoutVertexPerFrame,
    })
  );

  { // -- write VERTEX per-frame descriptors
    var descriptorSetByFrameWriter = (
      mtrCtx.createDescriptorSetWriter( // TODO use struct
        descriptorSetLayoutVertexPerFrame, // .descriptorSetLayout =
        descriptorSetVertexPerFrame, // .descriptorSet =
      )
    );
    defer descriptorSetByFrameWriter.finish();

    try descriptorSetByFrameWriter.set(
      .{
        .binding = inputTriangleVertexAssemblyBinding,
        .buffer = inputTriangleVertexAssemblyBuffer,
      },
    );
    try descriptorSetByFrameWriter.set(
      .{
        .binding = inputTriangleVertexIntermediaryBinding,
        .buffer = inputTriangleVertexIntermediaryBuffer,
      },
    );
    try descriptorSetByFrameWriter.set(
      .{
        .binding = inputTriangleVertexAssemblyMetadataBinding,
        .buffer = inputTriangleVertexAssemblyMetadataBuffer,
      },
    );
  }

  var outputColorImageTape = (
    mtr.memory.ImageTape { .image = outputColorImage, }
  );

  var intermediaryBufferTape = (
    mtr.memory.BufferTape { .buffer = inputTriangleVertexIntermediaryBuffer, }
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
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .tape = &intermediaryBufferTape,
              .accessFlags = .{.shaderWrite = true}
            }
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = computeVertexPipeline,
      }
    );

    commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = vertexPipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { descriptorSetVertexPerFrame }
        ),
      }
    );

    commandBufferRecorder.append(
      mtr.command.Dispatch {
        .width = ((12+15)/16), .height = 1, .depth = 1,
      }
    );

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .tape = &intermediaryBufferTape,
              .accessFlags = .{.shaderRead = true}
            }
          }
        ),
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
        .pipeline = computeFragmentPipeline,
      }
    );

    commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = fragmentPipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { descriptorSetFragmentPerFrame }
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
      .filename = "simple-triangle.ppm",
    }
  );
}
