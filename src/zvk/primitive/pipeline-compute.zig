// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const ComputePipeline = struct {
  handle : vk.Pipeline,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.ComputePipelineCreateInfo,
    objectInfo : zvk.primitive.ObjectCreateInfo,
  ) !ComputePipeline {
    log.debug("compute pipeline init: {}", .{objectInfo});
    var self = primitiveAllocator.createComputePipeline(info);

    if (self.handle == .null_handle) {
      return error.ComputePipelineConstructionFailed;
    }

    primitiveAllocator.labelObject(
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType = vk.ObjectType.pipeline,
        .objectHandle = @bitCast(u64, self.handle),
        .pObjectName = objectInfo.label,
      },
    );

    return self;
  }

  pub fn nullify() ComputePipeline {
    return ComputePipeline {
      .handle = .null_handle,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    self.primitiveAllocator.destroyComputePipeline(self);
  }
};
