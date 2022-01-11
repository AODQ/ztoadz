const mtr = @import("mtr/package.zig");
const util = @import("util/package.zig");
const modelio = @import("../src/modelio/package.zig");
const std = @import("std");

const glfw = @import("mtr/backend/vulkan/glfw.zig");

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

// contains information necessary to render the node
pub const NodeRenderable = struct {
  indexBuffer : mtr.buffer.Idx,
  originBuffer : mtr.buffer.Idx,
  materialBuffer : mtr.buffer.Idx,
  metadataBuffer : mtr.buffer.Idx,
  commandBuffer : mtr.command.BufferIdx,
};

// takes a model, modifies MTR to render it, and returns an update
//   callback + command buffer to render everything
pub fn initializeRendererForModel(
  modelPath : [*:0] const u8,
  mtrCtx : * mtr.Context,
  gtcQueue : mtr.queue.Idx,
  commandPoolScratch : mtr.command.PoolIdx,
  commandBufferScratch : mtr.command.BufferIdx,
  descriptorSetPool : mtr.descriptor.PoolIdx,
  resources : BasicResources,
  previousCommandBufferTapes : [] mtr.util.FinalizedCommandBufferTapes,
) !std.ArrayList(NodeRenderable) {
  _ = gtcQueue;
  _ = commandPoolScratch;
  _ = descriptorSetPool;
  _ = resources;

  var scene = (
    try modelio.loadScene(modelPath)
  );
  defer modelio.freeScene(scene);

  // CONCEPT ;
  // want to have everything merged into a single set of buffers
  // thus vertices and indices are going to conform to only one single format

  // TODO right now if multiple nodes point to same mesh they get duped

  var nodeRenderables = (
    std.ArrayList(NodeRenderable).init(mtrCtx.primitiveAllocator)
  );

  for (scene.nodes[0 .. scene.nodes_count]) |node| {
    // TODO translation / scale / matrix

    var originBuffer = std.ArrayList(f32).init(mtrCtx.primitiveAllocator);
    var materialBuffer = std.ArrayList(f32).init(mtrCtx.primitiveAllocator);
    var indexBuffer = std.ArrayList(u32).init(mtrCtx.primitiveAllocator);
    defer originBuffer.deinit();
    defer materialBuffer.deinit();
    defer indexBuffer.deinit();

    if (node.mesh == null) {
      std.log.warn("{s}", .{"node has no mesh"});
      continue;
    }
    var mesh = node.mesh.?;
    if (mesh.primitives_count == 0) {
      std.log.warn(
        "{s}", .{ "mesh with no primitives encountered" },
      );
      continue;
    }

    for (mesh.primitives[0 .. mesh.primitives_count]) |primitive| {
      if (primitive.type != .triangles) {
        std.log.err(
          "{s}{}",
          .{"no support for primitive type: ", primitive.type}
        );
        continue;
      }

      std.log.info("{s}", .{"computing primitive"});

      var indices = primitive.indices;

      var indexIt : usize = 0;
      while (indexIt < indices.count) : (indexIt += 1) {
        var idx = modelio.cgltf.cgltf_accessor_read_index(indices, indexIt);
        (try indexBuffer.addOne()).* = @intCast(u32, idx);
      }

      for (primitive.attributes[0 .. primitive.attributes_count]) |attribute| {
        switch (attribute.type) {
          .position => {
            std.debug.assert(attribute.index == 0);
            // const bufferPtrHandle = (
            //   @ptrToInt(attribute.data.buffer_view.buffer)
            // );
            // std.log.info("buffer ptr handle: {}", .{bufferPtrHandle});
            const numFloats = (
              modelio.cgltf.cgltf_accessor_unpack_floats(
                attribute.data, null, 0,
              )
            );
            try originBuffer.resize(numFloats * @sizeOf(f32));
            var originBufferSlice = (
              originBuffer.items[
                originBuffer.items.len - (numFloats*@sizeOf(f32)) ..
              ]
            );
            _ = modelio.cgltf.cgltf_accessor_unpack_floats(
              attribute.data, @ptrCast([*] f32, originBufferSlice), numFloats,
            );
            std.log.info("unpacked {} floats", .{numFloats});
          },
          else => {},
        }
      }
    }

    var nodeRenderable : NodeRenderable = undefined;

    { // origin attribute buffer
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      nodeRenderable.originBuffer = try (
        heapRegionAllocator.createBuffer(.{
          .label = "input-origin-attributes",
          .offset = 0,
          .length = @sizeOf(f32)*originBuffer.items.len,
          .usage = mtr.buffer.Usage {
            .bufferStorage = true, .transferDst = true,
          },
          .queueSharing = .exclusive,
        })
      );
    }

    { // upload original attribute buffer
      try mtr.util.stageMemoryToBuffer(mtrCtx, .{
        .queue = gtcQueue,
        .commandBuffer = commandBufferScratch,
        .bufferDst = nodeRenderable.originBuffer,
        .memoryToUpload = std.mem.sliceAsBytes(originBuffer.items),
      });
      try mtrCtx.queueFlush(gtcQueue);
    }

    { // indices buffer
      var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
      defer _ = heapRegionAllocator.finish();

      nodeRenderable.indexBuffer = try (
        heapRegionAllocator.createBuffer(.{
          .label = "input-indices",
          .offset = 0,
          .length = @sizeOf(u32)*indexBuffer.items.len,
          .usage = mtr.buffer.Usage {
            .bufferStorage = true, .transferDst = true,
          },
          .queueSharing = .exclusive,
        })
      );
    }

    { // upload indices buffer
      try mtr.util.stageMemoryToBuffer(mtrCtx, .{
        .queue = gtcQueue,
        .commandBuffer = commandBufferScratch,
        .bufferDst = nodeRenderable.indexBuffer,
        .memoryToUpload = std.mem.sliceAsBytes(indexBuffer.items),
      });
      try mtrCtx.queueFlush(gtcQueue);
    }

    // command buffer
    nodeRenderable.commandBuffer = (.{
        .commandPool = commandPoolScratch,
        .label = "node",
        .commandBufferTapes = previousCommandBufferTapes,
      }
    );

    {
      var commandBufferRecorder = (
        try mtr.util.CommandBufferRecorder.init(.{
          .ctx = &mtrCtx,
          .commandBuffer = nodeRenderable.commandBuffer,
          .imageTapes = 
        })
      );
    }
  }

  return nodeRenderables;
}
