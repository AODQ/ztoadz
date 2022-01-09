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
  descriptorSetPool : mtr.descriptorSet.PoolIdx,
  resources : BasicResources,
) void {
  var scene = (
    try modelio.loadScene("models/rock-moss/rock_moss_set_02_8k.gltf")
  );
  defer modelio.freeScene(scene);

  var verticesBuffer = std.ArrayList(u8).init(mtrCtx.primitiveAllocator);
  var indicesBuffer = std.ArrayList(u8).init(mtrCtx.primitiveAllocator);
  defer verticesBuffer.deinit();
  defer indicesBuffer.deinit();

  for (scene.nodes[0 .. scene.nodes_count]) |node| {
    // TODO translation / scale / matrix

    for (node.primitives[0 .. node.primitives_count]) |primitive| {
      if (primitive.type != .triangles) {
        std.log.err(
          "{s}{}",
          .{"no support for primitive type: ", primitive.type}
        );
        continue;
      }

      usize indicesIt = 0;
    }
  }
}
