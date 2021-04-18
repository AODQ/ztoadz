// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const PipelineLayout = struct {
  handle : vk.PipelineLayout,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.PipelineLayoutCreateInfo,
    objectInfo : zvk.primitive.ObjectCreateInfo,
  ) !PipelineLayout {
    log.debug("pipeline layout init: {}", .{objectInfo});
    var self = primitiveAllocator.createPipelineLayout(info);

    if (self.handle == .null_handle) {
      return error.PipelineLayoutConstructionFailed;
    }

    primitiveAllocator.labelObject(
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType = vk.ObjectType.pipeline_layout,
        .objectHandle = @bitCast(u64, self.handle),
        .pObjectName = objectInfo.label,
      },
    );

    return self;
  }

  pub fn nullify() PipelineLayout {
    return PipelineLayout {
      .handle = .null_handle,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    self.primitiveAllocator.destroyPipelineLayout(self);
  }
};
