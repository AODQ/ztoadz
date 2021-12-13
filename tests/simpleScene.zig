const mtr = @import("../src/mtr/package.zig");
const util = @import("../src/util/package.zig");
const modelio = @import("../src/modelio/package.zig");
const std = @import("std");

fn compareValues(failStr : anytype, actual : u8, expected : u8,) void {
  _ = std.testing.expect(actual == expected) catch {};
  if (actual != expected) {
    std.log.err("failure '{s}': {} == {}", .{failStr, actual, expected});
  }
}

const imageWidth = 1024;
const imageHeight = 1024;

test "pipeline - simple scene" {
  // rasterizes a simple scene

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

  var timer = try std.time.Timer.start();

  var mtrCtx = (
    mtr.Context.init(
      debugAllocator.allocator(),
      mtr.RenderingOptimizationLevel.debug,
    )
  );
  defer mtrCtx.deinit();

  std.log.info("created context: {} ms", .{timer.read()/std.time.ns_per_ms});

  timer.reset();

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
      debugAllocator.allocator(),
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

  const postprocModuleFileData = try (
    util.readFileAlignedU32(
      debugAllocator.allocator(),
      "shaders/simple-triangle-postproc.spv"
    )
  );
  defer postprocModuleFileData.deinit();

  const postprocShaderModule = (
    try mtrCtx.createShaderModule(
      mtr.shader.ConstructInfo {
        .data = postprocModuleFileData.items,
      }
    )
  );

  const vertexModuleFileData = try (
    util.readFileAlignedU32(
      debugAllocator.allocator(),
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
        .width = imageWidth, .height = imageHeight, .depth = 1,
        .samplesPerTexel = mtr.image.Sample.s1,
        .arrayLayers = 1,
        .mipmapLevels = 1,
        .byteFormat = mtr.image.ByteFormat.uint8,
        .channels = mtr.image.Channel.RGBA,
        .usage = .{ .transferSrc = true, .storage = true, },
        .normalized = true,
        .queueSharing = .exclusive,
      })
    );
  }

  // image view of output color image
  var outputColorImageView = try (
    mtrCtx.createImageView(.{.image = outputColorImage, })
  );

  var visibilitySurfaceImage : mtr.image.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    visibilitySurfaceImage = try (
      heapRegionAllocator.createImage(.{
        .offset = 0,
        .width = imageWidth, .height = imageHeight, .depth = 1,
        .samplesPerTexel = mtr.image.Sample.s1,
        .arrayLayers = 1,
        .mipmapLevels = 1,
        .byteFormat = mtr.image.ByteFormat.uint64,
        .channels = mtr.image.Channel.R,
        .usage = .{ .storage = true, },
        .normalized = true,
        .queueSharing = .exclusive,
      })
    );
  }

  var visibilitySurfaceImageView = try (
    mtrCtx.createImageView(.{.image = visibilitySurfaceImage, })
  );

  var origins = std.ArrayList(f32).init(debugAllocator.allocator());
  defer origins.deinit();
  {
    var vdl = modelio.mesh.CreateInfo_VertexDescriptorLayout.init();
    vdl.vertexAttributes[
      @enumToInt(modelio.mesh.VertexDescriptorAttributeType.origin)
    ] = .{ .bindingIndex = 0, .underlyingType = .float32_3, };
    _ = vdl;

    var scene = try modelio.loader.DumbSceneLoad(
      debugAllocator.allocator(),
      "models/bunny.mtr"
    );
    errdefer scene.deinit();
    defer scene.deinit();

    // stupid
    for (scene.items) |vtx| {
      (try origins.addOne()).* = vtx;
    }
  }

  std.log.info("origin len: {}", .{origins.items.len});

  // input triangle VAsm
  var inputTriangleVertexAssemblyBuffer  : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    inputTriangleVertexAssemblyBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(f32)*origins.items.len,
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
      std.mem.sliceAsBytes(origins.items)
    )
  });

  // output triangle VAsm
  var inputTriangleVertexIntermediaryBuffer  : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    inputTriangleVertexIntermediaryBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(f32)*origins.items.len,
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

  mtrCtx.queueFlush(queue);

  const numTriangles : u32 = @intCast(u32, origins.items.len/4/3);
  std.log.info("num triangles: {}", .{numTriangles});

  try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
    .queue = queue,
    .commandBuffer = commandBufferScratch,
    .bufferDst = inputTriangleVertexAssemblyMetadataBuffer,
    .memoryToUpload = (
      std.mem.sliceAsBytes(
        &[_] u32 { numTriangles },
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
            .binding = 0,
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

  const descriptorSetLayoutPostprocPerFrame = (
    try mtrCtx.createDescriptorSetLayout(.{
      .pool = descriptorSetPoolPerFrame,
      .frequency = .perFrame,
      .bindings = (
        (&[_] mtr.descriptor.SetLayoutBinding {
          mtr.descriptor.SetLayoutBinding{
            .descriptorType = .storageImage,
            .binding = 0,
          },
          mtr.descriptor.SetLayoutBinding{
            .descriptorType = .storageImage,
            .binding = 1,
          },
        })
      ),
    })
  );

  const postprocPipelineLayout = (
    try mtrCtx.createPipelineLayout(.{
      .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
        descriptorSetLayoutPostprocPerFrame
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

  var computePostprocPipeline = try (
    mtrCtx.createComputePipeline(.{
      .computeFlags = .{},
      .stageFlags = .{},
      .shaderModule = postprocShaderModule,
      .pName = "main",
      .layout = postprocPipelineLayout,
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
        .imageView = visibilitySurfaceImageView,
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

  var descriptorSetPostprocPerFrame = try (
    mtrCtx.createDescriptorSet(.{
      .pool = descriptorSetPoolPerFrame,
      .layout = descriptorSetLayoutPostprocPerFrame,
    })
  );

  { // -- write POSTPROC per-frame descriptors
    var descriptorSetByFrameWriter = (
      mtrCtx.createDescriptorSetWriter( // TODO use struct
        descriptorSetLayoutPostprocPerFrame, // .descriptorSetLayout =
        descriptorSetPostprocPerFrame, // .descriptorSet =
      )
    );
    defer descriptorSetByFrameWriter.finish();

    try descriptorSetByFrameWriter.set(
      .{
        .binding = 0,
        .imageView = visibilitySurfaceImageView,
      },
    );

    try descriptorSetByFrameWriter.set(
      .{
        .binding = 1,
        .imageView = outputColorImageView,
      },
    );
  }

  var outputColorImageTape = (
    mtr.memory.ImageTape { .image = outputColorImage, }
  );

  var visibilitySurfaceImageTape = (
    mtr.memory.ImageTape { .image = visibilitySurfaceImage, }
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
        .width = ((numTriangles+15)/16), .height = 1, .depth = 1,
      }
    );

    // -- fragment

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
            .{
              .tape = &visibilitySurfaceImageTape,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, .shaderRead = true, },
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
        .width = (numTriangles+15)/16,
        .height = 1,
        .depth = 1,
      }
    );

    // -- postproc

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .tape = &visibilitySurfaceImageTape,
              .layout = .general,
              .accessFlags = .{ .shaderRead = true, },
            }, .{
              .tape = &outputColorImageTape,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, },
            }
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = computePostprocPipeline,
      }
    );

    commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = postprocPipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { descriptorSetPostprocPerFrame }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.Dispatch {
        .width = imageWidth/16, .height = imageHeight/8, .depth = 1,
      }
    );
  }

  std.log.info("created pipeline: {} ms", .{timer.read()/std.time.ns_per_ms});
  timer.reset();

  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);

  std.log.info(
    "rendered image, time: {} us",
    .{timer.read()/std.time.ns_per_us}
  );

  timer.reset();

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

  std.log.info(
    "saved image, time: {} ms",
     .{timer.read()/std.time.ns_per_ms}
  );
}
