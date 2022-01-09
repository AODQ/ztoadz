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

pub const RendererInfo = struct {
  commandBuffer : mtr.command.BufferIdx,
  preCommandBufferSubmitCallback : ? fn (* mtr.Context) void = null,
  postCommandBufferSubmitCallback : ? fn (* mtr.Context) void = null,
};

// takes a model, modifies MTR to render it, and returns an update
//   callback + command buffer to render everything
pub fn initializeRendererForModel(
  modelPath : [*:0] const u8,
  mtrCtx : * mtr.Context,
  gtcQueue : mtr.queue.Idx,
  commandPoolScratch : mtr.command.PoolIdx,
  descriptorSetPool : mtr.descriptor.PoolIdx,
  resources : BasicResources,
) !void {
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

  var verticesBuffer = std.ArrayList(u8).init(mtrCtx.primitiveAllocator);
  var indicesBuffer = std.ArrayList(u8).init(mtrCtx.primitiveAllocator);
  defer verticesBuffer.deinit();
  defer indicesBuffer.deinit();

  // TODO right now if multiple nodes point to same mesh they get duped

  for (scene.nodes[0 .. scene.nodes_count]) |node| {
    // TODO translation / scale / matrix

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
        try indicesBuffer.appendSlice(
          @ptrCast([*] u8, &idx)[0 .. @sizeOf(usize)]
        );
        // (try indicesBuffer.addOne()).* = idx;
      }

      for (primitive.attributes[0 .. primitive.attributes_count]) |attribute| {
        switch (attribute.type) {
          .position => {
            std.debug.assert(attribute.index == 0);
            const numVertices = (
              modelio.cgltf.cgltf_accessor_unpack_floats(
                attribute.data, null, 0,
              )
            );
            var bufferArray = try (
              verticesBuffer.addManyAsArray(numVertices)
            );
            modelio.cgltf.cgltf_accessor_unpack_floats(
              attribute, bufferArray, numVertices,
            );
            std.log.info("unpacked {} floats", .{attribute});
          },
          else => {},
        }
      }

      // build up indices
      // usize indicesIt = 0;
    }
  }
}
