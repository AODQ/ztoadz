const mtr = @import("mtr/package.zig");
const util = @import("util/package.zig");
const modelio = @import("../src/modelio/package.zig");
const std = @import("std");

fn compareValues(failStr : anytype, actual : u8, expected : u8,) void {
  _ = std.testing.expect(actual == expected) catch {};
  if (actual != expected) {
    std.log.err("failure '{s}': {} == {}", .{failStr, actual, expected});
  }
}

const imageWidth = 2048;
const imageHeight = 2048;

const tileWidth = 16;
const tileHeight = 16;

const useMultiDispatchIndirect : bool = true;

pub const log_level = std.log.Level.debug;

pub fn printTime(prepend : [] const u8, timer : std.time.Timer) void {
  const time = timer.read();
  const sec = time/std.time.ns_per_s;
  const ms = time/std.time.ns_per_ms - (sec*1000);
  const us = time/std.time.ns_per_us - (time/std.time.ns_per_ms*1000);
  std.log.info("{s}: {} s {} ms {} us", .{prepend, sec, ms, us});
}

pub fn dumbTextureRead(alloc : std.mem.Allocator) !std.ArrayList(u8) {
  var texels = std.ArrayList(u8).init(alloc);
  errdefer texels.deinit();

  const file = try (
    std.fs.cwd().openFile("models/ah/ah.ppm", .{ .read = true })
  );
  defer file.close();

  var lineBuffer = [3] u8 { 0, 0, 0, };

  // first parse ppm header

  // remove P6\n
  _ = try file.readAll(lineBuffer[0..3]);

  // get width/height
  var widthBuffer = [4*3] u8 { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, };
  var heightBuffer = [4*3] u8 { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, };

  var widthBufferLen : usize = 0;
  while (true) {
    _ = try file.readAll(lineBuffer[0..1]);
    if (lineBuffer[0] == ' ') break;
    widthBuffer[widthBufferLen] = lineBuffer[0];
    widthBufferLen += 1;
  }

  var heightBufferLen  : usize= 0;
  while (true) {
    _ = try file.readAll(lineBuffer[0..1]);
    if (lineBuffer[0] == '\n') break;
    heightBuffer[heightBufferLen] = lineBuffer[0];
    heightBufferLen += 1;
  }

  std.log.info("width: {s} height: {s}", .{widthBuffer, heightBuffer});

  // remove 255\n and start parsing
  _ = try file.readAll(lineBuffer[0..3]);
  _ = try file.readAll(lineBuffer[0..1]);

  while (true) {
    const bytes = try file.readAll(lineBuffer[0..]);

    if (bytes == 0) break;
    try texels.appendSlice(lineBuffer[0..bytes]);
    try texels.append(255);
  }

  return texels;
}

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
  outputColorImageTape : mtr.memory.ImageTape,

  testTextureImage : mtr.image.Idx,
  testTextureImageView : mtr.image.ViewIdx,
  testTextureImageTape : mtr.memory.ImageTape,

  visibilitySurfaceImage : mtr.image.Idx,
  visibilitySurfaceImageView : mtr.image.ViewIdx,
  visibilitySurfaceImageTape : mtr.memory.ImageTape,

  inputAttributeAssemblyBuffer : mtr.buffer.Idx,
  inputAttributeAssemblyMetadataBuffer : mtr.buffer.Idx,

  intermediaryAttributeAssemblyBuffer : mtr.buffer.Idx,
  intermediaryAttributeAssemblyTape : mtr.memory.BufferTape,

  microRastEmitTriangleIDsBuffer : mtr.buffer.Idx,
  microRastEmitTriangleIDsTape : mtr.memory.BufferTape,
  microRastEmitMetadataBuffer : mtr.buffer.Idx,
  microRastEmitMetadataTape : mtr.memory.BufferTape,

  tiledRastEmitTriangleIDsBuffer : mtr.buffer.Idx,
  tiledRastEmitTriangleIDsTape : mtr.memory.BufferTape,

  tiledRastDispatchBuffer : mtr.buffer.Idx,
  tiledRastDispatchTape : mtr.memory.BufferTape,
};

pub const BasicScene = struct {
  numTrianglesInScene : u32,
  numFloatsInScene : u32,
  minBounds : [3] f32 = [3] f32 {9999, 9999, 9999},
  maxBounds : [3] f32 = [3] f32 {-9999, -9999, -9999},
};

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
    mtr.Context.init(
      debugAllocator.allocator(),
      mtr.RenderingOptimizationLevel.debug,
    )
  );
  defer mtrCtx.deinit();

  printTime("created context", timer);

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
    })
  );

  // -- create resources -------------------------------------------------------
  var resources : BasicResources = undefined;

  { // output color image
    {
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.outputColorImage = try (
        heapRegionAllocator.createImage(.{
          .offset = 0,
          .label = "output color image",
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

    resources.outputColorImageView = try (
      mtrCtx.createImageView(.{.image = resources.outputColorImage, })
    );

    resources.outputColorImageTape = (
      mtr.memory.ImageTape { .image = resources.outputColorImage, }
    );
  }

  { // test texture image
    { // texture create
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.testTextureImage = try (
        heapRegionAllocator.createImage(.{
          .offset = 0,
          .label = "test diffuse texture",
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
      mtrCtx.createImageView(.{.image = resources.testTextureImage, })
    );

    resources.testTextureImageTape = (
      mtr.memory.ImageTape { .image = resources.testTextureImage, }
    );

    { // memory upload
      var textureTexels = try dumbTextureRead(debugAllocator.allocator());
      defer textureTexels.deinit();

      std.log.info("texels to copy: {}", .{textureTexels.items.len});
      try mtr.util.stageMemoryToImage(&mtrCtx, .{
        .queue = queue,
        .commandBuffer = commandBufferScratch,
        .imageDst = resources.testTextureImage,
        .imageTape = &resources.testTextureImageTape,
        .memoryToUpload = textureTexels.items,
      });

      mtrCtx.queueFlush(queue);
    }
  }

  { // visibility surface
    {
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.visibilitySurfaceImage = try (
        heapRegionAllocator.createImage(.{
          .offset = 0,
          .label = "visibility surface",
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

    resources.visibilitySurfaceImageView = try (
      mtrCtx.createImageView(.{.image = resources.visibilitySurfaceImage, })
    );

    resources.visibilitySurfaceImageTape = (
      mtr.memory.ImageTape { .image = resources.visibilitySurfaceImage, }
    );
  }

  var sceneMetadata : BasicScene = undefined;

  { // input attribute assembly buffer

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
      mtrCtx.queueFlush(queue);
    }
  }

  { // input attribute assembly metadata buffer
    { // create buffer
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.inputAttributeAssemblyMetadataBuffer = try (
        heapRegionAllocator.createBuffer(.{
          .offset = 0,
          .length = @sizeOf(u32)*1 + @sizeOf(f32)*3,
          .usage = (
            mtr.buffer.Usage { .bufferStorage = true, .transferDst = true }
          ),
          .queueSharing = .exclusive,
        })
      );
    }

    { // upload
      const cameraOrigin = [3] f32 {
        0.0, 0.0, sceneMetadata.maxBounds[2]*1.2
      };

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
            },
          )
        ),
      });

      mtrCtx.queueFlush(queue);
    }
  }

  std.log.info("scene metadata: {}", .{sceneMetadata});

  { // create intermediary attribute assembly buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    resources.intermediaryAttributeAssemblyBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(f32)*sceneMetadata.numFloatsInScene,
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true }
        ),
        .queueSharing = .exclusive,
      })
    );

    resources.intermediaryAttributeAssemblyTape = (
      mtr.memory.BufferTape {
        .buffer = resources.intermediaryAttributeAssemblyBuffer,
      }
    );
  }

  { // create microrasterizer emit triangles ID buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    resources.microRastEmitTriangleIDsBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(u64)*sceneMetadata.numFloatsInScene,
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true }
        ),
        .queueSharing = .exclusive,
      })
    );

    resources.microRastEmitTriangleIDsTape = (
      mtr.memory.BufferTape {
        .buffer = resources.microRastEmitTriangleIDsBuffer,
      }
    );
  }

  { // create microrasterizer emit metadata buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    resources.microRastEmitMetadataBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(u64),
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true }
        ),
        .queueSharing = .exclusive,
      })
    );

    resources.microRastEmitMetadataTape = (
      mtr.memory.BufferTape {
        .buffer = resources.microRastEmitMetadataBuffer,
      }
    );
  }

  { // create tiled rasterizer emit triangle IDs buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    resources.tiledRastEmitTriangleIDsBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(u64)*tileWidth*tileHeight*64_000, // ~32 MB
        .usage = (
          mtr.buffer.Usage { .bufferStorage = true, }
        ),
        .queueSharing = .exclusive,
      })
    );

    resources.tiledRastEmitTriangleIDsTape = (
      mtr.memory.BufferTape {
        .buffer = resources.tiledRastEmitTriangleIDsBuffer,
      }
    );
  }

  { // create tiled rasterizer dispatch buffer
    {
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      resources.tiledRastDispatchBuffer = try (
        heapRegionAllocator.createBuffer(.{
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

      resources.tiledRastDispatchTape = (
        mtr.memory.BufferTape {
          .buffer = resources.tiledRastDispatchBuffer,
        }
      );
    }

    { // upload
      var dispatches = std.ArrayList(u32).init(debugAllocator.allocator());
      defer dispatches.deinit();
      var it : u32 = 0;
      while (it < 16*16) : (it += 1) {
        try dispatches.appendSlice(&[_] u32 { 1, 1, 0, 0 });
      }

      try mtr.util.stageMemoryToBuffer(&mtrCtx, .{
        .queue = queue,
        .commandBuffer = commandBufferScratch,
        .bufferDst = resources.tiledRastDispatchBuffer,
        .memoryToUpload = std.mem.sliceAsBytes(dispatches.items),
      });

      mtrCtx.queueFlush(queue);
    }
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
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          meshPipeline.descriptorSetLayout,
        },
      })
    );

    meshPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .shaderModule = meshPipeline.module,
        .pName = "main",
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
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          microRastPipeline.descriptorSetLayout
        },
      })
    );

    microRastPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .shaderModule = microRastPipeline.module,
        .pName = "main",
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
          .data = tiledIndirectDivisionModuleFileData.items,
        }
      )
    );

    const tiledRastDispatchBinding : u32 = 0;

    tiledIndirectDivisionPipeline.descriptorSetLayout = (
      try mtrCtx.createDescriptorSetLayout(.{
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
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          tiledIndirectDivisionPipeline.descriptorSetLayout
        },
      })
    );


    tiledIndirectDivisionPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .shaderModule = tiledIndirectDivisionPipeline.module,
        .pName = "main",
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
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          tiledRastPipeline.descriptorSetLayout
        },
        .pushConstantRange = @sizeOf(u32),
      })
    );


    tiledRastPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .shaderModule = tiledRastPipeline.module,
        .pName = "main",
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
        .descriptorSetLayouts = &[_] mtr.descriptor.LayoutIdx {
          materialPipeline.descriptorSetLayout
        },
      })
    );


    materialPipeline.pipeline = try (
      mtrCtx.createComputePipeline(.{
        .shaderModule = materialPipeline.module,
        .pName = "main",
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

  // -- record commands --------------------------------------------------------
  {
    var commandBufferRecorder = (
      mtrCtx.createCommandBufferRecorder(commandBufferScratch)
    );
    defer commandBufferRecorder.finish();

    // -- MESH pipeline --
    std.log.info("-----  MESH PIPELINE  -----", .{});

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .begin = true },
        .dstStage = .{ .compute = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .tape = &resources.microRastEmitMetadataTape,
              .accessFlags = .{ .shaderWrite = true, .shaderRead = true },
            }, .{
              .tape = &resources.microRastEmitTriangleIDsTape,
              .accessFlags = .{ .shaderWrite = true },
            }, .{
              .tape = &resources.intermediaryAttributeAssemblyTape,
              .accessFlags = .{ .shaderWrite = true },
            }, .{
              .tape = &resources.tiledRastEmitTriangleIDsTape,
              .accessFlags = .{ .shaderWrite = true, },
            }, .{
              .tape = &resources.tiledRastDispatchTape,
              .accessFlags = .{ .shaderRead = true, .shaderWrite = true, },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = meshPipeline.pipeline,
      }
    );

    commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = meshPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { meshPipeline.descriptorSet }
        ),
      }
    );

    commandBufferRecorder.append(
      mtr.command.Dispatch {
        .width = ((sceneMetadata.numTrianglesInScene+15)/16),
        .height = 1, .depth = 1,
      }
    );

    // -- MICRORAST pipeline --
    std.log.info("-----  MICRO PIPELINE  -----", .{});

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .tape = &resources.visibilitySurfaceImageTape,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, .shaderRead = true, },
            },
          }
        ),
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .tape = &resources.microRastEmitTriangleIDsTape,
              .accessFlags = .{ .shaderRead = true },
            }, .{
              .tape = &resources.microRastEmitMetadataTape,
              .accessFlags = .{ .shaderRead = true },
            }, .{
              .tape = &resources.intermediaryAttributeAssemblyTape,
              .accessFlags = .{ .shaderRead = true },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = microRastPipeline.pipeline,
      }
    );

    commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = microRastPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { microRastPipeline.descriptorSet }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.Dispatch {
        .width = (sceneMetadata.numTrianglesInScene+15)/16,
        .height = 1,
        .depth = 1,
      }
    );

    // -- TILED DIVISION pipeline ---
    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .tape = &resources.tiledRastDispatchTape,
              .accessFlags = .{ .shaderRead = true, .shaderWrite = true, },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = tiledIndirectDivisionPipeline.pipeline,
      }
    );

    commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = tiledIndirectDivisionPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx {
            tiledIndirectDivisionPipeline.descriptorSet
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.Dispatch { .width = 1, .height = 1, .depth = 1 },
    );

    // -- TILED pipeline --
    std.log.info("-----  TILED PIPELINE  -----", .{});

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .tape = &resources.visibilitySurfaceImageTape,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, .shaderRead = true, },
            }
          }
        ),
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            .{
              .tape = &resources.tiledRastEmitTriangleIDsTape,
              .accessFlags = .{ .shaderRead = true, },
            }, .{
              .tape = &resources.tiledRastDispatchTape,
              .accessFlags = .{ .shaderRead = true, .indirectCommand = true, },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = tiledRastPipeline.pipeline,
      }
    );

    commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = tiledRastPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { tiledRastPipeline.descriptorSet }
        ),
      },
    );

    if (!useMultiDispatchIndirect) {
      commandBufferRecorder.append(
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
        commandBufferRecorder.append(
          mtr.command.PushConstants {
            .pipelineLayout = tiledRastPipeline.pipelineLayout,
            .memory = std.mem.sliceAsBytes(&[_] u32 { indirectIt, }),
          },
        );

        commandBufferRecorder.append(
          mtr.command.DispatchIndirect {
            .buffer = resources.tiledRastDispatchBuffer,
            .offset = indirectIt*@sizeOf(u32)*4,
          },
        );
      }
    }

    // -- MATERIAL
    std.log.info("-----  MATERIAL PIPELINE  -----", .{});

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .compute = true },
        .dstStage = .{ .compute = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .tape = &resources.visibilitySurfaceImageTape,
              .layout = .general,
              .accessFlags = .{ .shaderRead = true, },
            }, .{
              .tape = &resources.outputColorImageTape,
              .layout = .general,
              .accessFlags = .{ .shaderWrite = true, },
            }, .{
              .tape = &resources.testTextureImageTape,
              .layout = .general,
              .accessFlags = .{ .shaderRead = true, },
            }
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.BindPipeline {
        .pipeline = materialPipeline.pipeline,
      }
    );

    commandBufferRecorder.append(
      mtr.command.BindDescriptorSets {
        .pipelineLayout = materialPipeline.pipelineLayout,
        .descriptorSets = (
          &[_] mtr.descriptor.LayoutIdx { materialPipeline.descriptorSet }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.Dispatch {
        .width = imageWidth/16, .height = imageHeight/8, .depth = 1,
      }
    );
  }

  // -- submit/save results & exit ---------------------------------------------

  printTime("created pipeline", timer);
  timer.reset();

  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);

  printTime("rendered image", timer);

  timer.reset();

  try mtr.util.screenshot.storeImageToFile(
    &mtrCtx, .{
      .queue = queue,
      .srcStage = .{ .compute = true },
      .commandBuffer = commandBufferScratch,
      .imageToStore = resources.outputColorImage,
      .imageToStoreTape = &resources.outputColorImageTape,
      .filename = "simple-triangle.ppm",
    }
  );

  printTime("saved image", timer);
}
