// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const DescriptorPool = struct {
  handle : vk.DescriptorPool,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.DescriptorPoolCreateInfo,
    objectInfo : zvk.primitive.ObjectCreateInfo,
  ) !DescriptorPool {
    log.debug("descriptor pool init: {}", .{objectInfo});
    var self = primitiveAllocator.createDescriptorPool(info);

    if (self.handle == .null_handle) {
      return error.DescriptorPoolConstructionFailed;
    }

    primitiveAllocator.labelObject(
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType = vk.ObjectType.descriptor_pool,
        .objectHandle = @bitCast(u64, self.handle),
        .pObjectName = objectInfo.label,
      },
    );

    return self;
  }

  pub fn nullify() DescriptorPool {
    return DescriptorPool {
      .handle = .null_handle,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    self.primitiveAllocator.destroyDescriptorPool(self);
  }
};
