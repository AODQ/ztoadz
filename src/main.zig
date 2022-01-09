const mtr = @import("mtr/package.zig");
const util = @import("util/package.zig");
const modelio = @import("../src/modelio/package.zig");
const std = @import("std");

const glfw = @import("mtr/backend/vulkan/glfw.zig");

fn compareValues(failStr : anytype, actual : u8, expected : u8,) void {
  _ = std.testing.expect(actual == expected) catch {};
  if (actual != expected) {
    std.log.err("failure '{s}': {} == {}", .{failStr, actual, expected});
  }
}

const imageWidth = 1024;
const imageHeight = 1024;

const tileWidth = 16;
const tileHeight = 16;

const useMultiDispatchIndirect : bool = true;

pub const log_level = std.log.Level.info;

pub fn printTime(prepend : [] const u8, timer : std.time.Timer) void {
  const time = timer.read();
  const sec = time/std.time.ns_per_s;
  const ms = time/std.time.ns_per_ms - (sec*1000);
  const us = time/std.time.ns_per_us - (time/std.time.ns_per_ms*1000);
  std.log.info("{s}: {} s {} ms {} us", .{prepend, sec, ms, us});
}

// pub fn dumbTextureRead(alloc : std.mem.Allocator) !std.ArrayList(u8) {
//   var texels = std.ArrayList(u8).init(alloc);
//   errdefer texels.deinit();

//   const file = try (
//     std.fs.cwd().openFile("models/rock-moss/diffuse8k.ppm", .{ .read = true })
//   );
//   defer file.close();

//   var lineBuffer : [2049] u8 = undefined;

//   // first parse ppm header

//   // remove P6\n
//   _ = try file.readAll(lineBuffer[0..3]);

//   // get width/height
//   var widthBuffer = [4*3] u8 { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, };
//   var heightBuffer = [4*3] u8 { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, };

//   var widthBufferLen : usize = 0;
//   while (true) {
//     _ = try file.readAll(lineBuffer[0..1]);
//     if (lineBuffer[0] == ' ') break;
//     widthBuffer[widthBufferLen] = lineBuffer[0];
//     widthBufferLen += 1;
//   }

//   var heightBufferLen  : usize= 0;
//   while (true) {
//     _ = try file.readAll(lineBuffer[0..1]);
//     if (lineBuffer[0] == '\n') break;
//     heightBuffer[heightBufferLen] = lineBuffer[0];
//     heightBufferLen += 1;
//   }

//   std.log.info("width: {s} height: {s}", .{widthBuffer, heightBuffer});

//   // remove 255\n and start parsing
//   _ = try file.readAll(lineBuffer[0..3]);
//   _ = try file.readAll(lineBuffer[0..1]);

//   while (true) {
//     const bytes = try file.readAll(lineBuffer[0..]);

//     if (bytes == 0) break;
//     var byteIt : usize = 0;
//     while (byteIt < bytes) : (byteIt += 3) {
//       try texels.appendSlice(lineBuffer[byteIt..byteIt+3]);
//       try texels.append(255);
//     }
//   }

//   return texels;
// }

// pipelines:
// mesh -> microrast -> tiledrast -> material

pub const BasicPipeline = struct {
  module : mtr.shader.Idx,
  descriptorSetLayout : mtr.descriptor.LayoutIdx,
  descriptorSet : mtr.descriptor.SetIdx,
  pipelineLayout : mtr.pipeline.LayoutIdx,
  pipeline : mtr.pipeline.ComputeIdx,
};

pub const BasicResources = struct {
  outputColorImage : mtr.image.Idx,
  outputColorImageView : mtr.image.ViewIdx,

  testTextureImage : mtr.image.Idx,
  testTextureImageView : mtr.image.ViewIdx,

  visibilitySurfaceImage : mtr.image.Idx,
  visibilitySurfaceImageView : mtr.image.ViewIdx,

  inputAttributeAssemblyBuffer : mtr.buffer.Idx,
  inputAttributeAssemblyMetadataBuffer : mtr.buffer.Idx,

  intermediaryAttributeAssemblyBuffer : mtr.buffer.Idx,

  microRastEmitTriangleIDsBuffer : mtr.buffer.Idx,
  microRastEmitMetadataBuffer : mtr.buffer.Idx,
  microRastEmitMetadataClearingBuffer : mtr.buffer.Idx,

  tiledRastEmitTriangleIDsBuffer : mtr.buffer.Idx,
  tiledRastDispatchBuffer : mtr.buffer.Idx,
  tiledRastDispatchClearingBuffer : mtr.buffer.Idx,
};

pub const BasicScene = struct {
  numTrianglesInScene : u32,
  numFloatsInScene : u32,
  minBounds : [3] f32 = [3] f32 {9999, 9999, 9999},
  maxBounds : [3] f32 = [3] f32 {-9999, -9999, -9999},
  cameraOrigin : [3] f32,
  cameraTarget : [3] f32,
};

pub const BasicSwapchain = struct {
  swapchain : mtr.window.SwapchainId,
  images : std.ArrayList(mtr.image.Idx),
  // imageViews : std.ArrayList(mtr.image.ViewIdx),
  currentImageIndex : u32,

  imageAvailableSemaphore : mtr.memory.SemaphoreId,
  renderFinishedSemaphore : mtr.memory.SemaphoreId,

  pub fn deinit(self : * @This()) void {
    self.images.deinit();
    // self.imageViews.deinit();
  }
};

fn createBasicSwapchain(
  mtrCtx : * mtr.context.Context,
  queue : mtr.queue.Idx,
) !BasicSwapchain {
  var basicSwapchain = BasicSwapchain {
    .swapchain = try (
      mtrCtx.createSwapchain(.{
          .queue = queue,
          .extent = [2] u32 { imageWidth, imageHeight },
      },)
    ),
    .images = std.ArrayList(mtr.image.Idx).init(mtrCtx.primitiveAllocator),
    //.imageViews = (
    // std.ArrayList(mtr.image.Idx).init(mtrCtx.primitiveAllocator)
    //),
    .currentImageIndex = 0,
    .imageAvailableSemaphore = (
      try mtrCtx.createSemaphore(.{ .label = "image-available" })
    ),
    .renderFinishedSemaphore = (
      try mtrCtx.createSemaphore(.{ .label = "render-finished" })
    ),
  };

  try basicSwapchain.images.resize(
    @intCast(usize, try mtrCtx.swapchainImageCount(basicSwapchain.swapchain))
  );
  try mtrCtx.swapchainImages(
    basicSwapchain.swapchain, basicSwapchain.images.items
  );

  // try basicSwapchain.imageViews.resize(basicSwapchain.images.items.len);
  // for (basicSwapchain.images.items) |image, idx| {
  //   std.log.info("creating image view for {}", .{image});
  //   basicSwapchain.imageViews.items[idx] = try (
  //     mtrCtx.createImageView(.{.image = image})
  //   );
  // }

  return basicSwapchain;
}

pub fn main() !void {
  // rasterizes a simple scene

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

  // -- create MTR context -----------------------------------------------------

  var timer = try std.time.Timer.start();

  var mtrCtx = (
    mtr.Context.init(.{
      .allocator = debugAllocator.allocator(),
      .optimization = mtr.RenderingOptimizationLevel.debug,
      .width = imageWidth,
      .height = imageHeight,
    })
  );
  defer mtrCtx.deinit();

  printTime("created context", timer);

  timer.reset();

  const queue : mtr.queue.Idx = (
    try mtrCtx.constructQueue(.{
      .workType = mtr.queue.WorkType{
        .transfer = true, .render = true, .compute=true
      },
    })
  );

  const commandPoolScratch : mtr.command.PoolIdx = (
    try mtrCtx.constructCommandPool(.{
      .flags = .{ .transient = true, .resetCommandBuffer = true },
      .label = "scratch",
      .queue = queue,
    })
  );

  const commandBufferScratch : mtr.command.BufferIdx = (
    try mtrCtx.createCommandBuffer(.{
      .commandPool = commandPoolScratch,
      .label = "scratch",
    })
  );

  // create descriptor set
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
      .label = "per-frame",
    })
  );

  var basicSwapchain = try createBasicSwapchain(&mtrCtx, queue);
  defer basicSwapchain.deinit();

  // -- create resources -------------------------------------------------------
  var resources : BasicResources = undefined;

  { // output color image
    {
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.outputColorImage = try (
        heapRegionAllocator.createImage(.{
          .offset = 0,
          .label = "output-color-image",
          .width = imageWidth, .height = imageHeight, .depth = 1,
          .samplesPerTexel = mtr.image.Sample.s1,
          .arrayLayers = 1,
          .mipmapLevels = 1,
          .byteFormat = mtr.image.ByteFormat.uint8Unorm,
          .channels = mtr.image.Channel.RGBA,
          .usage = .{
            .transferSrc = true, .transferDst = true, .storage = true,
          },
          .normalized = true,
          .queueSharing = .exclusive,
        })
      );
    }

    resources.outputColorImageView = try (
      mtrCtx.createImageView(.{
        .label = "output-color-image-view",
        .image = resources.outputColorImage,
      })
    );
  }

  { // test texture image
    { // texture create
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.testTextureImage = try (
        heapRegionAllocator.createImage(.{
          .offset = 0,
          .label = "test-diffuse-texture",
          .width = 1024, .height = 1024, .depth = 1,
          .samplesPerTexel = mtr.image.Sample.s1,
          .arrayLayers = 1,
          .mipmapLevels = 1,
          .byteFormat = mtr.image.ByteFormat.uint8,
          .channels = mtr.image.Channel.RGBA,
          .usage = .{ .transferDst = true, .storage = true, },
          .normalized = true,
          .queueSharing = .exclusive,
        })
      );
    }

    resources.testTextureImageView = try (
      mtrCtx.createImageView(.{
        .label = "test-diffuse-texture-view",
        .image = resources.testTextureImage,
      })
    );

    // { // memory upload
    //   var textureTexels = try dumbTextureRead(debugAllocator.allocator());
    //   defer textureTexels.deinit();

    //   std.log.info("texels to copy: {}", .{textureTexels.items.len});
    //   try mtr.util.stageMemoryToImage(&mtrCtx, .{
    //     .queue = queue,
    //     .commandBuffer = commandBufferScratch,
    //     .imageDst = resources.testTextureImage,
    //     .imageDstLayout = .uninitialized,
    //     .imageDstAccessFlags = .{ },
    //     .memoryToUpload = textureTexels.items,
    //   });

    //   try mtrCtx.queueFlush(queue);
    // }
  }

  { // visibility surface
    {
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.visibilitySurfaceImage = try (
        heapRegionAllocator.createImage(.{
          .offset = 0,
          .label = "visibility-surface",
          .width = imageWidth, .height = imageHeight, .depth = 1,
          .samplesPerTexel = mtr.image.Sample.s1,
          .arrayLayers = 1,
          .mipmapLevels = 1,
          .byteFormat = mtr.image.ByteFormat.uint64,
          .channels = mtr.image.Channel.R,
          .usage = .{ .storage = true, .transferDst = true, },
          .normalized = true,
          .queueSharing = .exclusive,
        })
      );
    }

    resources.visibilitySurfaceImageView = try (
      mtrCtx.createImageView(.{
        .label = "visibility-surface-view",
        .image = resources.visibilitySurfaceImage,
      })
    );
  }

  var sceneMetadata : BasicScene = undefined;

  { // input attribute assembly buffer

    {
      var scene = try modelio.loadScene("models/crown/scene.gltf");
      defer modelio.freeScene(scene);

      std.log.info("scene: {}", .{scene.*});
    }

    if (true)
      return;

    var origins = std.ArrayList(f32).init(debugAllocator.allocator());
    defer origins.deinit();

    { // load scene
      {
        var vdl = modelio.mesh.CreateInfo_VertexDescriptorLayout.init();
        vdl.vertexAttributes[
          @enumToInt(modelio.mesh.VertexDescriptorAttributeType.origin)
        ] = .{ .bindingIndex = 0, .underlyingType = .float32_3, };
        _ = vdl;

        var modelFileBuffer : [1024] u8 = undefined;
        var modelFile : [] const u8 = (
          try std.fs.cwd().readFile("default-scene.csv", modelFileBuffer[0..])
        );
        modelFile = std.mem.trimRight(u8, modelFile, "\n");

        std.log.info("will load '{s}'", .{modelFile});
        var scene = try modelio.loader.DumbSceneLoad(
          debugAllocator.allocator(),
          modelFile
          //"models/lpshead/head.mtr"
        );
        errdefer scene.deinit();
        defer scene.deinit();

        // stupid
        for (scene.items) |vtx, it| {
          (try origins.addOne()).* = vtx;
          sceneMetadata.maxBounds[it%3] = (
            std.math.max(sceneMetadata.maxBounds[it%3], vtx)
          );
          sceneMetadata.minBounds[it%3] = (
            std.math.min(sceneMetadata.minBounds[it%3], vtx)
          );
        }
      }
      sceneMetadata.numTrianglesInScene = @intCast(u32, origins.items.len/8/3);
      sceneMetadata.numFloatsInScene    = @intCast(u32, origins.items.len);
    }

    { // create buffer
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.inputAttributeAssemblyBuffer = try (
        heapRegionAllocator.createBuffer(.{
          .label = "input-attribute-assembly",
          .offset = 0,
          .length = @sizeOf(f32)*sceneMetadata.numFloatsInScene,
          .usage = (
            mtr.buffer.Usage { .bufferStorage = true, .transferDst = true }
          ),
          .queueSharing = .exclusive,
        })
      );
    }

    { // load & upload resources
      try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
        .queue = queue,
        .commandBuffer = commandBufferScratch,
        .bufferDst = resources.inputAttributeAssemblyBuffer,
        .memoryToUpload = (
          std.mem.sliceAsBytes(origins.items)
        )
      });
      try mtrCtx.queueFlush(queue);
    }
  }

  { // input attribute assembly metadata buffer
    { // create buffer
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.inputAttributeAssemblyMetadataBuffer = try (
        heapRegionAllocator.createBuffer(.{
          .label = "input-attribute-assembly-metadata",
          .offset = 0,
          .length = @sizeOf(u32)*1 + @sizeOf(f32)*6,
          .usage = (
            mtr.buffer.Usage { .bufferStorage = true, .transferDst = true }
          ),
          .queueSharing = .exclusive,
        })
      );
    }

    { // upload
      const cameraOrigin = [3] f32 {
        0.5, 0.2, sceneMetadata.maxBounds[2]*1.5
      };
      const cameraTarget = [3] f32 { 0.0, 0.0, 0.0 };
      sceneMetadata.cameraOrigin = cameraOrigin;
      sceneMetadata.cameraTarget = cameraTarget;

      try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
        .queue = queue,
        .commandBuffer = commandBufferScratch,
        .bufferDst = resources.inputAttributeAssemblyMetadataBuffer,
        .memoryToUpload = (
          std.mem.sliceAsBytes(
            &[_] u32 {
              sceneMetadata.numTrianglesInScene,
              @bitCast(u32, cameraOrigin[0]),
              @bitCast(u32, cameraOrigin[1]),
              @bitCast(u32, cameraOrigin[2]),
              @bitCast(u32, cameraTarget[0]),
              @bitCast(u32, cameraTarget[1]),
              @bitCast(u32, cameraTarget[2]),
            },
          )
        ),
      });

      try mtrCtx.queueFlush(queue);
    }
  }

  std.log.info("scene metadata: {}", .{sceneMetadata});

  { // create intermediary attribute assembly buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    resources.intermediaryAttributeAssemblyBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .label = "intermediary-attribute-assembly",
        .offset = 0,
        .length = @sizeOf(f32)*sceneMetadata.numFloatsInScene,
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true }
        ),
        .queueSharing = .exclusive,
      })
    );
  }

  { // create microrasterizer emit triangles ID buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    resources.microRastEmitTriangleIDsBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .label = "microrasterizer-emit-triangles-ID",
        .offset = 0,
        .length = @sizeOf(u64)*sceneMetadata.numFloatsInScene,
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true }
        ),
        .queueSharing = .exclusive,
      })
    );
  }

  { // create microrasterizer emit metadata buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    resources.microRastEmitMetadataBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .label = "microrasterizer-emit-metadata",
        .offset = 0,
        .length = @sizeOf(u64),
        .usage = (
          mtr.buffer.Usage {
            .transferDst = true,
            .transferSrc = true,
            .bufferStorage = true
          }
        ),
        .queueSharing = .exclusive,
      })
    );
  }

  { // create microrasterizer emit metadata staging buffer
    {
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.microRastEmitMetadataClearingBuffer = try (
        heapRegionAllocator.createBuffer(.{
          .label = "microrasterizer-emit-metadata-staging",
          .offset = 0,
          .length = @sizeOf(u64),
          .usage = (
            mtr.buffer.Usage {
              .transferSrc = true, .transferDst = true, .bufferStorage = true,
            }
          ),
          .queueSharing = .exclusive,
        })
      );
    }

    { // clear to 0
      try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
        .queue = queue,
        .commandBuffer = commandBufferScratch,
        .bufferDst = resources.microRastEmitMetadataClearingBuffer,
        .memoryToUpload = &[_] u8 { 0, 0, 0, 0, },
      });
    }
    try mtrCtx.queueFlush(queue);
  }

  { // create tiled rasterizer emit triangle IDs buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    resources.tiledRastEmitTriangleIDsBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .label = "tiled-rasterizer-emit-triangle-IDs",
        .offset = 0,
        .length = @sizeOf(u64)*tileWidth*tileHeight*64_000, // ~32 MB
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true, }
        ),
        .queueSharing = .exclusive,
      })
    );
  }

  { // create tiled rasterizer dispatch buffer
    {
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.tiledRastDispatchBuffer = try (
        heapRegionAllocator.createBuffer(.{
          .label = "tiled-rasterizer-dispatch",
          .offset = 0,
          .length = @sizeOf(u32)*4*16*16,
          .usage = mtr.buffer.Usage {
            .bufferStorage = true,
            .bufferIndirect = true,
            .transferDst = true,
          },
          .queueSharing = .exclusive,
        })
      );
    }
  }

  { // create tiled rasterizer dispatch staging buffer
    {
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.tiledRastDispatchClearingBuffer = try (
        heapRegionAllocator.createBuffer(.{
          .label = "tiled-rasterizer-dispatch-staging",
          .offset = 0,
          .length = @sizeOf(u32)*4*16*16,
          .usage = mtr.buffer.Usage {
            .transferDst = true,
            .transferSrc = true,
          },
          .queueSharing = .exclusive,
        })
      );
    }

    { // clear the tiled rasterizer dispatch buffer <X, Y, Tris, Tris>
      var dispatches : [16*16*4] u32 = undefined;
      var it : u32 = 0;
      while (it < 16*16) : (it += 1) {
        dispatches[it*4+0] = 1; dispatches[it*4+1] = 1;
        dispatches[it*4+2] = 1; dispatches[it*4+3] = 1;
      }

      try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
        .queue = queue,
        .commandBuffer = commandBufferScratch,
        .bufferDst = resources.tiledRastDispatchClearingBuffer,
        .memoryToUpload = std.mem.sliceAsBytes(dispatches[0..]),
      });
    }
    try mtrCtx.queueFlush(queue);
  }

  // -- create pipelines -------------------------------------------------------
  var meshPipeline : BasicPipeline = undefined;
  // fixme defer deinit etc
  {
    const meshModuleFileData = try (
      util.readFileAlignedU32(
        debugAllocator.allocator(),
        "shaders/simple-triangle-mesh.spv"
      )
    );
    defer meshModuleFileData.deinit();

    meshPipeline.module = (
      try mtrCtx.createShaderModule(
        mtr.shader.ConstructInfo {
          .label = "simple-triangle-mesh",
          .data = meshModuleFileData.items,
        }
      )
    );

    const inputAttributeAssemblyBinding : u32 = 0;
    const inputAttributeAssemblyMetadataBinding : u32 = 1;
    const intermediaryAttributeAssemblyBinding : u32 = 2;
    const microRastEmitTriangleIDsBinding : u32 = 3;
    const microRastEmitMetadataBinding : u32 = 4;
    const tiledRastEmitTriangleIDsBinding : u32 = 5;
    const tiledRastDispatchBinding : u32 = 7;

    meshPipeline.descriptorSetLayout = (
      try mtrCtx.createDescriptorSetLayout(.{
        .label = "mesh-descriptor-set-layout",
        .pool = descriptorSetPoolPerFrame,
        .frequency = .perFrame,
        .bindings = (
          (&[_] mtr.descriptor.SetLayoutBinding {
            mtr.descriptor.SetLayoutBinding {
              .descriptorType = .storageBuffer,
              .binding = inputAttributeAssemblyBinding,
            },
            mtr.descriptor.SetLayoutBinding {
              .descriptorType = .storageBuffer,
              .binding = inputAttributeAssemblyMetadataBinding,
            },
            mtr.descriptor.SetLayoutBinding {
              .descriptorType = .storageBuffer,
              .binding = intermediaryAttributeAssemblyBinding,
            },
            mtr.descriptor.SetLayoutBinding {
              .descriptorType = .storageBuffer,
              .binding = microRastEmitTriangleIDsBinding,
            },
            mtr.descriptor.SetLayoutBinding {
              .descriptorType = .storageBuffer,
              .binding = microRastEmitMetadataBinding,
            },
            mtr.descriptor.SetLayoutBinding {
              .descriptorType = .storageBuffer,
              .binding = tiledRastEmitTriangleIDsBinding,
            },
            mtr.descriptor.SetLayoutBinding {
              .descriptorType = .storageBuffer,
              .binding = tiledRastDispatchBinding,
            },
          })
        ),
      })
    );

    meshPipeline.pipelineLayout = (
      try mtrCtx.createPipelineLayout(.{
        .label = "mesh-pipeline-layout",
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          meshPipeline.descriptorSetLayout,
        },
      })
    );

    meshPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .label = "mesh-pipeline",
        .shaderModule = meshPipeline.module,
        .entryFnLabel = "main",
        .layout = meshPipeline.pipelineLayout,
      })
    );

    meshPipeline.descriptorSet = try (
      mtrCtx.createDescriptorSet(.{
        .pool = descriptorSetPoolPerFrame,
        .layout = meshPipeline.descriptorSetLayout,
      })
    );

    { // -- write MESH descriptors
      var descriptorSetByFrameWriter = (
        mtrCtx.createDescriptorSetWriter( // TODO use struct
          meshPipeline.descriptorSetLayout, // .descriptorSetLayout =
          meshPipeline.descriptorSet, // .descriptorSet =
        )
      );
      defer descriptorSetByFrameWriter.finish();

      try descriptorSetByFrameWriter.setBySlice(
        & [_] mtr.descriptor.SetWriter.Binding {
          .{
            .binding = inputAttributeAssemblyBinding,
            .buffer = resources.inputAttributeAssemblyBuffer,
          }, .{
            .binding = inputAttributeAssemblyMetadataBinding,
            .buffer = resources.inputAttributeAssemblyMetadataBuffer,
          }, .{
            .binding = intermediaryAttributeAssemblyBinding,
            .buffer = resources.intermediaryAttributeAssemblyBuffer,
          }, .{
            .binding = microRastEmitTriangleIDsBinding,
            .buffer = resources.microRastEmitTriangleIDsBuffer,
          }, .{
            .binding = microRastEmitMetadataBinding,
            .buffer = resources.microRastEmitMetadataBuffer,
          }, .{
            .binding = tiledRastEmitTriangleIDsBinding,
            .buffer = resources.tiledRastEmitTriangleIDsBuffer,
          }, .{
            .binding = tiledRastDispatchBinding,
            .buffer = resources.tiledRastDispatchBuffer,
          },
        }
      );
    }
  }

  var microRastPipeline : BasicPipeline = undefined;
  // fixme defer deinit etc
  {
    const microRastModuleFileData = try (
      util.readFileAlignedU32(
        debugAllocator.allocator(),
        "shaders/simple-triangle-microrast-visibility.spv"
      )
    );
    defer microRastModuleFileData.deinit();

    microRastPipeline.module = (
      try mtrCtx.createShaderModule(
        mtr.shader.ConstructInfo {
          .label = "micro-rasterizer",
          .data = microRastModuleFileData.items,
        }
      )
    );

    const visibilitySurfaceImageBinding : u32 = 0;
    const intermediaryAttributeAssemblyBinding : u32 = 1;
    const microRastEmitTriangleIDsBinding : u32 = 2;
    const microRastEmitMetadataBinding : u32 = 3;

    microRastPipeline.descriptorSetLayout = (
      try mtrCtx.createDescriptorSetLayout(.{
        .label = "micro-rasterizer-descriptor-set",
        .pool = descriptorSetPoolPerFrame,
        .frequency = .perFrame,
        .bindings = (
          (&[_] mtr.descriptor.SetLayoutBinding {
            mtr.descriptor.SetLayoutBinding{
              .binding = visibilitySurfaceImageBinding,
              .descriptorType = .storageImage,
            },
            mtr.descriptor.SetLayoutBinding{
              .binding = intermediaryAttributeAssemblyBinding,
              .descriptorType = .storageBuffer,
            },
            mtr.descriptor.SetLayoutBinding{
              .binding = microRastEmitTriangleIDsBinding,
              .descriptorType = .storageBuffer,
            },
            mtr.descriptor.SetLayoutBinding{
              .binding = microRastEmitMetadataBinding,
              .descriptorType = .storageBuffer,
            },
          })
        ),
      })
    );

    microRastPipeline.pipelineLayout = (
      try mtrCtx.createPipelineLayout(.{
        .label = "micro-rasterizer-layout",
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          microRastPipeline.descriptorSetLayout
        },
      })
    );

    microRastPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .label = "micro-rasterizer",
        .shaderModule = microRastPipeline.module,
        .entryFnLabel = "main",
        .layout = microRastPipeline.pipelineLayout,
      })
    );

    microRastPipeline.descriptorSet= try (
      mtrCtx.createDescriptorSet(.{
        .pool = descriptorSetPoolPerFrame,
        .layout = microRastPipeline.descriptorSetLayout,
      })
    );

    { // -- write MICRORASTERIZER descriptors
      var descriptorSetByFrameWriter = (
        mtrCtx.createDescriptorSetWriter( // TODO use struct
          microRastPipeline.descriptorSetLayout,
          microRastPipeline.descriptorSet
        )
      );
      defer descriptorSetByFrameWriter.finish();

      try descriptorSetByFrameWriter.set(
        .{
          .binding = visibilitySurfaceImageBinding,
          .imageView = resources.visibilitySurfaceImageView,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = intermediaryAttributeAssemblyBinding,
          .buffer = resources.intermediaryAttributeAssemblyBuffer,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = microRastEmitTriangleIDsBinding,
          .buffer = resources.microRastEmitTriangleIDsBuffer,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = microRastEmitMetadataBinding,
          .buffer = resources.microRastEmitMetadataBuffer,
        },
      );
    }
  }

  var tiledIndirectDivisionPipeline : BasicPipeline = undefined;
  // fixme defer deinit etc
  {
    const tiledIndirectDivisionModuleFileData = try (
      util.readFileAlignedU32(
        debugAllocator.allocator(),
        "shaders/simple-triangle-tiled-indirect-division.spv",
      )
    );
    defer tiledIndirectDivisionModuleFileData.deinit();

    tiledIndirectDivisionPipeline.module = (
      try mtrCtx.createShaderModule(
        mtr.shader.ConstructInfo {
          .label = "tiled-indirect-division",
          .data = tiledIndirectDivisionModuleFileData.items,
        }
      )
    );

    const tiledRastDispatchBinding : u32 = 0;

    tiledIndirectDivisionPipeline.descriptorSetLayout = (
      try mtrCtx.createDescriptorSetLayout(.{
        .label = "tiled-indirect-division",
        .pool = descriptorSetPoolPerFrame,
        .frequency = .perFrame,
        .bindings = (
          (&[_] mtr.descriptor.SetLayoutBinding {
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageBuffer,
              .binding = tiledRastDispatchBinding,
            },
          })
        ),
      })
    );

    tiledIndirectDivisionPipeline.pipelineLayout = (
      try mtrCtx.createPipelineLayout(.{
        .label = "tiled-indirect-division",
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          tiledIndirectDivisionPipeline.descriptorSetLayout
        },
      })
    );

    tiledIndirectDivisionPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .label = "tiled-indirect-division",
        .shaderModule = tiledIndirectDivisionPipeline.module,
        .entryFnLabel = "main",
        .layout = tiledIndirectDivisionPipeline.pipelineLayout,
      })
    );

    tiledIndirectDivisionPipeline.descriptorSet = try(
      mtrCtx.createDescriptorSet(.{
        .pool = descriptorSetPoolPerFrame,
        .layout = tiledIndirectDivisionPipeline.descriptorSetLayout,
      })
    );

    { // -- write tiledRAST descriptors
      var descriptorSetByFrameWriter = (
        mtrCtx.createDescriptorSetWriter( // TODO use struct
          tiledIndirectDivisionPipeline.descriptorSetLayout,
          tiledIndirectDivisionPipeline.descriptorSet,
        )
      );
      defer descriptorSetByFrameWriter.finish();

      try descriptorSetByFrameWriter.set(
        .{
          .binding = tiledRastDispatchBinding,
          .buffer = resources.tiledRastDispatchBuffer,
        },
      );
    }
  }

  var tiledRastPipeline : BasicPipeline = undefined;
  // fixme defer deinit etc
  {
    const tiledRastModuleFileData = try (
      util.readFileAlignedU32(
        debugAllocator.allocator(),
        "shaders/simple-triangle-tiled-visibility.spv"
      )
    );
    defer tiledRastModuleFileData.deinit();

    tiledRastPipeline.module = (
      try mtrCtx.createShaderModule(
        mtr.shader.ConstructInfo {
          .label = "tiled-rasterizer",
          .data = tiledRastModuleFileData.items,
        }
      )
    );

    const visibilitySurfaceImageBinding : u32 = 0;
    const intermediaryAttributeAssemblyBinding : u32 = 1;
    const tiledRastEmitTriangleIDsBinding : u32 = 2;
    const tiledRastDispatchBinding : u32 = 4;

    tiledRastPipeline.descriptorSetLayout = (
      try mtrCtx.createDescriptorSetLayout(.{
        .label = "tiled-rasterizer",
        .pool = descriptorSetPoolPerFrame,
        .frequency = .perFrame,
        .bindings = (
          (&[_] mtr.descriptor.SetLayoutBinding {
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageImage,
              .binding = visibilitySurfaceImageBinding,
            },
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageBuffer,
              .binding = intermediaryAttributeAssemblyBinding,
            },
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageBuffer,
              .binding = tiledRastEmitTriangleIDsBinding,
            },
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageBuffer,
              .binding = tiledRastDispatchBinding,
            },
          })
        ),
      })
    );

    tiledRastPipeline.pipelineLayout = (
      try mtrCtx.createPipelineLayout(.{
        .label = "tiled-rasterizer",
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          tiledRastPipeline.descriptorSetLayout
        },
        .pushConstantRange = @sizeOf(u32),
      })
    );


    tiledRastPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .label = "tiled-rasterizer",
        .shaderModule = tiledRastPipeline.module,
        .entryFnLabel = "main",
        .layout = tiledRastPipeline.pipelineLayout,
      })
    );


    tiledRastPipeline.descriptorSet = try(
      mtrCtx.createDescriptorSet(.{
        .pool = descriptorSetPoolPerFrame,
        .layout = tiledRastPipeline.descriptorSetLayout,
      })
    );

    { // -- write tiledRAST descriptors
      var descriptorSetByFrameWriter = (
        mtrCtx.createDescriptorSetWriter( // TODO use struct
          tiledRastPipeline.descriptorSetLayout, // .descriptorSetLayout =
          tiledRastPipeline.descriptorSet, // .descriptorSet =
        )
      );
      defer descriptorSetByFrameWriter.finish();

      try descriptorSetByFrameWriter.set(
        .{
          .binding = visibilitySurfaceImageBinding,
          .imageView = resources.visibilitySurfaceImageView,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = intermediaryAttributeAssemblyBinding,
          .buffer = resources.intermediaryAttributeAssemblyBuffer,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = tiledRastEmitTriangleIDsBinding,
          .buffer = resources.tiledRastEmitTriangleIDsBuffer,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = tiledRastDispatchBinding,
          .buffer = resources.tiledRastDispatchBuffer,
        },
      );
    }
  }

  var materialPipeline : BasicPipeline = undefined;
  // fixme defer deinit etc
  {
    const materialModuleFileData = try (
      util.readFileAlignedU32(
        debugAllocator.allocator(),
        "shaders/simple-triangle-material.spv"
      )
    );
    defer materialModuleFileData.deinit();

    materialPipeline.module = (
      try mtrCtx.createShaderModule(
        mtr.shader.ConstructInfo {
          .label = "material",
          .data = materialModuleFileData.items,
        }
      )
    );

    const visibilitySurfaceImageBinding : u32 = 0;
    const outputColorImageBinding : u32 = 1;
    const intermediaryAttributeAssemblyBinding : u32 = 2;
    const inputAttributeAssemblyMetadataBinding : u32 = 3;
    // material related i suppose
    const inputDiffuseImageBinding : u32 = 4;

    materialPipeline.descriptorSetLayout = (
      try mtrCtx.createDescriptorSetLayout(.{
        .label = "material",
        .pool = descriptorSetPoolPerFrame,
        .frequency = .perFrame,
        .bindings = (
          (&[_] mtr.descriptor.SetLayoutBinding {
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageImage,
              .binding = visibilitySurfaceImageBinding,
            },
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageImage,
              .binding = outputColorImageBinding,
            },
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageBuffer,
              .binding = intermediaryAttributeAssemblyBinding,
            },
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageBuffer,
              .binding = inputAttributeAssemblyMetadataBinding,
            },
            mtr.descriptor.SetLayoutBinding{
              .descriptorType = .storageImage,
              .binding = inputDiffuseImageBinding,
            },
          })
        ),
      })
    );

    materialPipeline.pipelineLayout = (
      try mtrCtx.createPipelineLayout(.{
        .label = "material",
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          materialPipeline.descriptorSetLayout
        },
      })
    );


    materialPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .label = "material",
        .shaderModule = materialPipeline.module,
        .entryFnLabel = "main",
        .layout = materialPipeline.pipelineLayout,
      })
    );


    materialPipeline.descriptorSet = try(
      mtrCtx.createDescriptorSet(.{
        .pool = descriptorSetPoolPerFrame,
        .layout = materialPipeline.descriptorSetLayout,
      })
    );

    { // -- write MATERIAL descriptors
      var descriptorSetByFrameWriter = (
        mtrCtx.createDescriptorSetWriter( // TODO use struct
          materialPipeline.descriptorSetLayout, // .descriptorSetLayout =
          materialPipeline.descriptorSet, // .descriptorSet =
        )
      );
      defer descriptorSetByFrameWriter.finish();

      try descriptorSetByFrameWriter.set(
        .{
          .binding = visibilitySurfaceImageBinding,
          .imageView = resources.visibilitySurfaceImageView,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = outputColorImageBinding,
          .imageView = resources.outputColorImageView,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = intermediaryAttributeAssemblyBinding,
          .buffer = resources.intermediaryAttributeAssemblyBuffer,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = inputAttributeAssemblyMetadataBinding,
          .buffer = resources.inputAttributeAssemblyMetadataBuffer,
        },
      );
      try descriptorSetByFrameWriter.set(
        .{
          .binding = inputDiffuseImageBinding,
          .imageView = resources.testTextureImageView,
        },
      );
    }
  }

  _ = materialPipeline;
  _ = tiledRastPipeline;
  _ = meshPipeline;
  _ = microRastPipeline;
  _ = tiledIndirectDivisionPipeline;

  // INITIAL LAYOUTS -> [loop] { CLEAR, RENDER, PRESENT }

  // -- record/perform commands [ INITIAL LAYOUTS ] ----------------------------
  // set the initial layouts/access for buffers/images, which is what
  //   CLEAR will expect
  var initialLayoutTapes : mtr.util.FinalizedCommandBufferTapes = undefined;
  defer initialLayoutTapes.deinit();
  {
    const initialLayoutCommandBuffer : mtr.command.BufferIdx = (
      try mtrCtx.createCommandBuffer(.{
        .commandPool = commandPoolScratch,
        .label = "initial layout",
      })
    );

    // record commands
    {
      var imageTapes = try std.BoundedArray(mtr.memory.ImageTape, 8).init(0);
      try imageTapes.appendSlice(
        &[_] mtr.memory.ImageTape {
          .{
            .image = resources.visibilitySurfaceImage,
            .layout = .uninitialized,
            .accessFlags = .{},
          }, .{
            .image = resources.outputColorImage,
            .layout = .uninitialized,
            .accessFlags = .{ },
          }, .{
            .image = resources.testTextureImage,
            .layout = .uninitialized,
            .accessFlags = .{},
          }
        }
      );
      for (basicSwapchain.images.items) |image| {
        try imageTapes.append(.{
          .image = image,
          .layout = .uninitialized,
          .accessFlags = .{},
        });
      }
      var commandBufferRecorder = (
        try mtr.util.CommandBufferRecorder.init(.{
          .ctx = &mtrCtx,
          .commandBuffer = initialLayoutCommandBuffer,
          .imageTapes = imageTapes.slice()
        })
      );

      // prepare swapchain to be copied into
      for (basicSwapchain.images.items) |image| {
        try commandBufferRecorder.append(
          mtr.command.PipelineBarrier {
            .srcStage = .{ .begin = true },
            .dstStage = .{ .end = true },
            .imageTapes = (
              &[_] mtr.command.PipelineBarrier.ImageTapeAction {
                .{
                  .image = image,
                  .layout = .present,
                  .accessFlags = .{ },
                },
              }
            ),
          },
        );
      }

      defer initialLayoutTapes = (
        commandBufferRecorder.finishWithFinalizedTapes()
      );

      try commandBufferRecorder.append(
        mtr.command.PipelineBarrier {
          .srcStage = .{ .begin = true },
          .dstStage = .{ .end = true },
          .imageTapes = (
            &[_] mtr.command.PipelineBarrier.ImageTapeAction {
              .{
                .image = resources.visibilitySurfaceImage,
                .layout = .general,
                .accessFlags = .{},
              },
              .{
                .image = resources.outputColorImage,
                .layout = .general,
                .accessFlags = .{},
              },
              .{
                .image = resources.testTextureImage,
                .layout = .general,
                .accessFlags = .{},
              },
            }
          ),
        },
      );
    }

    // submit
    try mtrCtx.submitCommandBufferToQueue(
      queue, initialLayoutCommandBuffer, .{}
    );

    try mtrCtx.queueFlush(queue);
  }

  // -- record commands [ CLEAR ] ----------------------------------------------
  // clear the contents necessary to render the frame
  const renderClearPerFrameCommandBuffer : mtr.command.BufferIdx = (
    try mtrCtx.createCommandBuffer(.{
      .commandPool = commandPoolScratch,
      .label = "render clear",
    })
  );
  var renderClearPerFrameTapes : mtr.util.FinalizedCommandBufferTapes = (
    undefined
  );
  defer renderClearPerFrameTapes.deinit();
  {
    var commandBufferRecorder = (
      try mtr.util.CommandBufferRecorder.init(.{
        .ctx = &mtrCtx,
        .commandBuffer = renderClearPerFrameCommandBuffer,
        .commandBufferTapes = &[_] mtr.util.FinalizedCommandBufferTapes {
          initialLayoutTapes,
        },
        .bufferTapes = &[_] mtr.memory.BufferTape {
          .{ .buffer = resources.microRastEmitMetadataBuffer, },
          .{ .buffer = resources.microRastEmitTriangleIDsBuffer, },
          .{ .buffer = resources.intermediaryAttributeAssemblyBuffer, },
          .{ .buffer = resources.tiledRastEmitTriangleIDsBuffer, },
          .{ .buffer = resources.tiledRastDispatchBuffer, },
        },
      })
    );
    defer renderClearPerFrameTapes = (
      commandBufferRecorder.finishWithFinalizedTapes()
    );

    // -- what to clear:
    // * microRastEmitMetadataBuffer
    // * tiledRastDispatchBuffer
    // * visibilitySurfaceImage
    // * outputColorImage
    // the rest don't need clearing because either, they will be overwritten,
    //   or previous frame information stored won't be referenced, ei an array

    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .begin = true },
        .dstStage = .{ .transfer = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .image = resources.visibilitySurfaceImage,
              .layout = .transferDst,
              .accessFlags = .{ .transferDst = true, },
            },
            .{
              .image = resources.outputColorImage,
              .layout = .transferDst,
              .accessFlags = .{ .transferDst = true, },
            },
          }
        ),
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .buffer = resources.microRastEmitMetadataBuffer,
              .accessFlags = .{ .transferDst = true, },
            }, .{
              .buffer = resources.tiledRastDispatchBuffer,
              .accessFlags = .{ .transferDst = true, },
            },
          }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.TransferMemory {
        .bufferSrc = resources.microRastEmitMetadataClearingBuffer,
        .bufferDst = resources.microRastEmitMetadataBuffer,
        .offsetSrc = 0, .offsetDst = 0, .length = @sizeOf(u64),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.TransferMemory {
        .bufferSrc = resources.tiledRastDispatchClearingBuffer,
        .bufferDst = resources.tiledRastDispatchBuffer,
        .offsetSrc = 0, .offsetDst = 0,
        .length = @sizeOf(u32)*4*16*16,
      },
    );

    try commandBufferRecorder.append(
      mtr.command.UploadTexelToImageMemory {
        .image = resources.visibilitySurfaceImage,
        .rgba = [4] f32 { 0.0, 0.0, 0.0, 0.0, },
      },
    );

    try commandBufferRecorder.append(
      mtr.command.UploadTexelToImageMemory {
        .image = resources.outputColorImage,
        .rgba = [4] f32 { 0.0, 0.0, 0.0, 0.0, },
      },
    );

    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .transfer = true },
        .dstStage = .{ .end = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .image = resources.visibilitySurfaceImage,
              .layout = .general,
              .accessFlags = .{},
            }, .{
              .image = resources.outputColorImage,
              .layout = .general,
              .accessFlags = .{},
            },
          }
        ),
      },
    );
  }

  // -- record commands [ PER FRAME ]-------------------------------------------
  const renderPerFrameCommandBuffer : mtr.command.BufferIdx = (
    try mtrCtx.createCommandBuffer(.{
      .commandPool = commandPoolScratch,
      .label = "render-per-frame",
    })
  );
  var renderPerFrameTapes : mtr.util.FinalizedCommandBufferTapes = undefined;
  defer renderPerFrameTapes.deinit();
  {
    var commandBufferRecorder = (
      try mtr.util.CommandBufferRecorder.init(.{
        .ctx = &mtrCtx,
        .commandBuffer = renderPerFrameCommandBuffer,
        .commandBufferTapes = &[_] mtr.util.FinalizedCommandBufferTapes {
          renderClearPerFrameTapes,
        },
        .bufferTapes = &[_] mtr.memory.BufferTape {
          .{ .buffer = resources.microRastEmitMetadataBuffer, },
          .{ .buffer = resources.microRastEmitTriangleIDsBuffer, },
          .{ .buffer = resources.intermediaryAttributeAssemblyBuffer, },
          .{ .buffer = resources.tiledRastEmitTriangleIDsBuffer, },
          .{ .buffer = resources.tiledRastDispatchBuffer, },
        },
        .imageTapes = &[_] mtr.memory.ImageTape {
            .{
              .image = resources.visibilitySurfaceImage,
              .layout = .general,
              .accessFlags = .{ .shaderRead = true, },
            }, .{
              .image = resources.outputColorImage,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, },
            }, .{
              .image = resources.testTextureImage,
              .layout = .general,
              .accessFlags = .{ .shaderRead = true, },
            }
        },
      })
    );
    defer renderPerFrameTapes = (
      commandBufferRecorder.finishWithFinalizedTapes()
    );

    // -- MESH pipeline --
    std.log.info("-----  MESH PIPELINE  -----", .{});

    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .begin = true },
        .dstStage = .{ .compute = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .buffer = resources.microRastEmitMetadataBuffer,
              .accessFlags = .{ .shaderWrite = true, .shaderRead = true },
            }, .{
              .buffer = resources.microRastEmitTriangleIDsBuffer,
              .accessFlags = .{ .shaderWrite = true },
            }, .{
              .buffer = resources.intermediaryAttributeAssemblyBuffer,
              .accessFlags = .{ .shaderWrite = true },
            }, .{
              .buffer = resources.tiledRastEmitTriangleIDsBuffer,
              .accessFlags = .{ .shaderWrite = true, },
            }, .{
              .buffer = resources.tiledRastDispatchBuffer,
              .accessFlags = .{ .shaderRead = true, .shaderWrite = true, },
            },
          }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = meshPipeline.pipeline,
      }
    );

    try commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = meshPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { meshPipeline.descriptorSet }
        ),
      }
    );

    try commandBufferRecorder.append(
      mtr.command.Dispatch {
        .width = ((sceneMetadata.numTrianglesInScene+15)/16),
        .height = 1, .depth = 1,
      }
    );

    // -- MICRORAST pipeline --
    std.log.info("-----  MICRO PIPELINE  -----", .{});

    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .image = resources.visibilitySurfaceImage,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, .shaderRead = true, },
            },
          }
        ),
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .buffer = resources.microRastEmitTriangleIDsBuffer,
              .accessFlags = .{ .shaderRead = true },
            }, .{
              .buffer = resources.microRastEmitMetadataBuffer,
              .accessFlags = .{ .shaderRead = true },
            }, .{
              .buffer = resources.intermediaryAttributeAssemblyBuffer,
              .accessFlags = .{ .shaderRead = true },
            },
          }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = microRastPipeline.pipeline,
      }
    );

    try commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = microRastPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { microRastPipeline.descriptorSet }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.Dispatch {
        .width = (sceneMetadata.numTrianglesInScene+15)/16,
        .height = 1,
        .depth = 1,
      }
    );

    // -- TILED DIVISION pipeline ---
    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .buffer = resources.tiledRastDispatchBuffer,
              .accessFlags = .{ .shaderRead = true, .shaderWrite = true, },
            },
          }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = tiledIndirectDivisionPipeline.pipeline,
      }
    );

    try commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = tiledIndirectDivisionPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx {
            tiledIndirectDivisionPipeline.descriptorSet
          }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.Dispatch { .width = 1, .height = 1, .depth = 1 },
    );

    // -- TILED pipeline --
    std.log.info("-----  TILED PIPELINE  -----", .{});

    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .image = resources.visibilitySurfaceImage,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, .shaderRead = true, },
            }
          }
        ),
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .buffer = resources.tiledRastEmitTriangleIDsBuffer,
              .accessFlags = .{ .shaderRead = true, },
            }
          }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .indirectDispatch = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .buffer = resources.tiledRastDispatchBuffer,
              .accessFlags = .{ .shaderRead = true, .indirectCommand = true, },
            },
          }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = tiledRastPipeline.pipeline,
      }
    );

    try commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = tiledRastPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { tiledRastPipeline.descriptorSet }
        ),
      },
    );

    if (!useMultiDispatchIndirect) {
      try commandBufferRecorder.append(
        mtr.command.Dispatch {
          .width = 16,
          .height = 16,
          .depth = 8, // TODO compute
        },
      );
    } else {
      var indirectIt : u32 = 0;
      while (indirectIt < 16*16) : (indirectIt += 1) {
        // TODO it might be possible to allow multi indirect dispatch command
        //      on MTR side as long as certain constraints on pushconstants can
        //      be made
        try commandBufferRecorder.append(
          mtr.command.PushConstants {
            .pipelineLayout = tiledRastPipeline.pipelineLayout,
            .memory = std.mem.sliceAsBytes(&[_] u32 { indirectIt, }),
          },
        );

        try commandBufferRecorder.append(
          mtr.command.DispatchIndirect {
            .buffer = resources.tiledRastDispatchBuffer,
            .offset = indirectIt*@sizeOf(u32)*4,
          },
        );
      }
    }

    // -- MATERIAL
    std.log.info("-----  MATERIAL PIPELINE  -----", .{});

    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .image = resources.visibilitySurfaceImage,
              .layout = .general,
              .accessFlags = .{ .shaderRead = true, },
            }, .{
              .image = resources.outputColorImage,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, },
            }, .{
              .image = resources.testTextureImage,
              .layout = .general,
              .accessFlags = .{ .shaderRead = true, },
            }
          }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = materialPipeline.pipeline,
      }
    );

    try commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = materialPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { materialPipeline.descriptorSet }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.Dispatch {
        .width = imageWidth/16, .height = imageHeight/8, .depth = 1,
      }
    );

    // final layout transitions
    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .end = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .image = resources.visibilitySurfaceImage,
              .layout = .general,
              .accessFlags = .{ },
            },
            .{
              .image = resources.testTextureImage,
              .layout = .general,
              .accessFlags = .{ },
            },
            .{
              .image = resources.outputColorImage,
              .layout = .general,
              .accessFlags = .{ },
            },
          }
        ),
      },
    );
  }

  { // -- submit/save results & exit -------------------------------------------
    printTime("created pipeline", timer);
    timer.reset();

    { // upload temp matrix
      const cameraOrigin = [3] f32 {
        std.math.sin(@floatCast(f32, 0.0))*sceneMetadata.maxBounds[2]*3.5,
        0.2,
        std.math.cos(@floatCast(f32, 0.0))*sceneMetadata.maxBounds[2]*3.5
        + (4.0+std.math.sin(@floatCast(f32, 0.5))*6.0)
      };
      sceneMetadata.cameraOrigin = cameraOrigin;
      const cameraTarget = [3] f32 { 0.0, 0.0, 0.0 };
      sceneMetadata.cameraTarget = cameraTarget;

      try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
        .queue = queue,
        .commandBuffer = commandBufferScratch,
        .bufferDst = resources.inputAttributeAssemblyMetadataBuffer,
        .memoryToUpload = (
          std.mem.sliceAsBytes(
            &[_] u32 {
              sceneMetadata.numTrianglesInScene,
              @bitCast(u32, cameraOrigin[0]),
              @bitCast(u32, cameraOrigin[1]),
              @bitCast(u32, cameraOrigin[2]),
              @bitCast(u32, cameraTarget[0]),
              @bitCast(u32, cameraTarget[1]),
              @bitCast(u32, cameraTarget[2]),
            },
          )
        ),
      });

      try mtrCtx.queueFlush(queue);
    }

    try mtrCtx.submitCommandBufferToQueue(
      queue, renderClearPerFrameCommandBuffer, .{}
    );

    try mtrCtx.submitCommandBufferToQueue(
      queue, renderPerFrameCommandBuffer, .{}
    );

    try mtrCtx.queueFlush(queue);

    printTime("rendered image", timer);

    timer.reset();

    try mtr.util.screenshot.storeImageToFile(
      &mtrCtx, .{
        .queue = queue,
        .srcStage = .{ .compute = true },
        .commandBuffer = commandBufferScratch,
        .imageToStore = resources.outputColorImage,
        .imageToStoreLayout = .general,
        .imageToStoreAccessFlags = .{ .shaderWrite=true, },
        .filename = "simple-triangle.ppm",
      }
    );

    printTime("saved image", timer);
  }


  var frameCount : u32 = 0;

  var mouseTotal = [2] f32 { 0, 0 };
  var cameraOrigin = [3] f32 { 0, 0, 0 };
  var prevMousePos = [2] f64 { -1.0, -1.0 };

  var mouseTotalMiddle = [2] f32 { 0, 0 };

  std.log.info("{s}", .{"now displaying to screen"});
  while (!mtrCtx.shouldWindowClose()) {
    timer.reset();
    mtrCtx.pollEvents();

    // input
    {
      var xpos : f64 = undefined;
      var ypos : f64 = undefined;
      glfw.c.glfwGetCursorPos(
        mtrCtx.glfwWindow,
        &xpos,
        &ypos
      );

      var deltaX : f32 = 0.0;
      var deltaY : f32 = 0.0;

      deltaX = @floatCast(f32, prevMousePos[0] - xpos)/imageWidth;
      deltaY = @floatCast(f32, prevMousePos[1] - ypos)/imageHeight;

      prevMousePos[0] = xpos;
      prevMousePos[1] = ypos;

      if (
        glfw.c.glfwGetMouseButton(
          mtrCtx.glfwWindow, glfw.c.GLFW_MOUSE_BUTTON_MIDDLE
        ) > 0
      ) {
        mouseTotalMiddle[0] -= deltaX*sceneMetadata.maxBounds[0]*0.2;
        mouseTotalMiddle[1] += deltaY*sceneMetadata.maxBounds[1]*0.2;
      }

      if (
        glfw.c.glfwGetMouseButton(
          mtrCtx.glfwWindow, glfw.c.GLFW_MOUSE_BUTTON_LEFT
        ) > 0
      ) {
        mouseTotal[0] += deltaX;
      }

      if (
        glfw.c.glfwGetMouseButton(
          mtrCtx.glfwWindow, glfw.c.GLFW_MOUSE_BUTTON_RIGHT
        ) > 0
      ) {
        mouseTotal[1] -= deltaY;
      }

      sceneMetadata.cameraTarget[0] = mouseTotalMiddle[0];
      sceneMetadata.cameraTarget[1] = mouseTotalMiddle[1];

      var dist : f32 = 0.5+mouseTotal[1]*sceneMetadata.maxBounds[2]*0.035;

      cameraOrigin = [3] f32 {
        (
          std.math.sin(mouseTotal[0])*sceneMetadata.maxBounds[2]*dist
          + mouseTotalMiddle[0]
        ),
        mouseTotalMiddle[1],
        std.math.cos(mouseTotal[0])*sceneMetadata.maxBounds[2]*dist,
      };
    }

    basicSwapchain.currentImageIndex = (
      try mtrCtx.swapchainAcquireNextImage(
        basicSwapchain.swapchain,
        basicSwapchain.imageAvailableSemaphore,
        null,
      )
    );

    const currentSwapchainIdx = basicSwapchain.currentImageIndex;

    try mtrCtx.submitCommandBufferToQueue(
      queue, renderClearPerFrameCommandBuffer, .{}
    );

    try mtrCtx.submitCommandBufferToQueue(
      queue, renderPerFrameCommandBuffer, .{}
    );

    // TODO use a host writable uniform buffer maybe
    { // upload
      sceneMetadata.cameraOrigin = cameraOrigin;

      try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
        .queue = queue,
        .commandBuffer = commandBufferScratch,
        .bufferDst = resources.inputAttributeAssemblyMetadataBuffer,
        .memoryToUpload = (
          std.mem.sliceAsBytes(
            &[_] u32 {
              sceneMetadata.numTrianglesInScene,
              @bitCast(u32, cameraOrigin[0]),
              @bitCast(u32, cameraOrigin[1]),
              @bitCast(u32, cameraOrigin[2]),
              @bitCast(u32, sceneMetadata.cameraTarget[0]),
              @bitCast(u32, sceneMetadata.cameraTarget[1]),
              @bitCast(u32, sceneMetadata.cameraTarget[2]),
            },
          )
        ),
      });

      try mtrCtx.queueFlush(queue);
    }

    {
      var commandBufferRecorder = (
        try mtr.util.CommandBufferRecorder.init(.{
          .ctx = &mtrCtx,
          .commandBuffer = commandBufferScratch,
          .commandBufferTapes = &[_] mtr.util.FinalizedCommandBufferTapes {
            renderClearPerFrameTapes,
            renderPerFrameTapes,
          },
        })
      );
      defer commandBufferRecorder.finish();

      // prepare swapchain to be copied into
      try commandBufferRecorder.append(
        mtr.command.PipelineBarrier {
          .srcStage = .{ .begin = true },
          .dstStage = .{ .transfer = true },
          .imageTapes = (
            &[_] mtr.command.PipelineBarrier.ImageTapeAction {
              .{
                .image = basicSwapchain.images.items[currentSwapchainIdx],
                .layout = .transferDst,
                .accessFlags = .{ },
              }, .{
                .image = resources.outputColorImage,
                .layout = .transferSrc,
                .accessFlags = .{ },
              },
            }
          ),
        },
      );

      // copy image into swapchain
      try commandBufferRecorder.append(
        mtr.command.TransferImageToImage {
          .imageSrc = resources.outputColorImage,
          .imageDst = basicSwapchain.images.items[currentSwapchainIdx],
          .width = imageWidth,
          .height = imageHeight,
        },
      );

      // prepare swapchain for presentation
      try commandBufferRecorder.append(
        mtr.command.PipelineBarrier {
          .srcStage = .{ .transfer = true },
          .dstStage = .{ .end = true },
          .imageTapes = (
            &[_] mtr.command.PipelineBarrier.ImageTapeAction {
              .{
                .image = basicSwapchain.images.items[currentSwapchainIdx],
                .layout = .present,
                .accessFlags = .{ },
              }, .{
                .image = resources.outputColorImage,
                .layout = .general,
                .accessFlags = .{ },
              },
            }
          ),
        },
      );
    }

    try mtrCtx.submitCommandBufferToQueue(
      queue,
      commandBufferScratch,
      .{
        .waitSemaphores = (
          &[_] mtr.memory.WaitSemaphoreSynchronization {
            .{
              .semaphore = basicSwapchain.imageAvailableSemaphore,
              .stage = .{.transfer = true,},
            },
          }
        ),
        .signalSemaphores = (
          &[_] mtr.memory.SemaphoreId {
            basicSwapchain.renderFinishedSemaphore,
          }
        ),
      },
    );

    try mtrCtx.queuePresent(.{
      .queue = queue,
      .swapchain = basicSwapchain.swapchain,
      .imageIndex = currentSwapchainIdx,
      .waitSemaphores = (
        &[_] mtr.memory.SemaphoreId { basicSwapchain.renderFinishedSemaphore }
      ),
    });

    try mtrCtx.queueFlush(queue);

    if (frameCount == 500) {
      frameCount = 0;
      printTime("frame ms", timer);
    }
    frameCount += 1;
  }

  try mtrCtx.queueFlush(queue);

  std.log.info("exitting application", .{});
}
