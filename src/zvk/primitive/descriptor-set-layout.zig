// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const DescriptorSetLayout = struct {
  handle : vk.DescriptorSetLayout,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.DescriptorSetLayoutCreateInfo,
    objectInfo : zvk.primitive.ObjectCreateInfo
  ) !DescriptorSetLayout {
    log.debug("descriptor set layout init: {}", .{objectInfo});
    var self = primitiveAllocator.createDescriptorSetLayout(info);

    if (self.handle == .null_handle) {
      return error.DescriptorSetLayoutConstructionFailed;
    }

    primitiveAllocator.labelObject(
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType = vk.ObjectType.descriptor_set_layout,
        .objectHandle = @bitCast(u64, self.handle),
        .pObjectName = objectInfo.label,
      },
    );

    return self;
  }

  pub fn nullify() DescriptorSetLayout {
    return DescriptorSetLayout {
      .handle = .null_handle,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    self.primitiveAllocator.destroyDescriptorSetLayout(self);
  }
};
