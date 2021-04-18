// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const DescriptorSets = struct {
  handles : std.ArrayList(vk.DescriptorSet),
  descriptorPool : vk.DescriptorPool,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.DescriptorSetAllocateInfo,
    objectInfo : zvk.primitive.ObjectCreateInfo,
  ) !DescriptorSets {
    log.debug("descriptor sets init: {}", .{objectInfo});
    var self = primitiveAllocator.createDescriptorSets(info);

    if (@bitCast(u64, self.descriptorPool) == 0) {
      return error.DescriptorSetConstructionFailed;
    }

    for (self.handles.items) |set| {
      primitiveAllocator.labelObject(
        vk.DebugUtilsObjectNameInfoEXT {
          .objectType = vk.ObjectType.descriptor_set,
          .objectHandle = @bitCast(u64, set),
          .pObjectName = objectInfo.label,
        },
      );
    }

    return self;
  }

  pub fn nullify() DescriptorSets {
    return DescriptorSets {
      .handles = undefined,
      .descriptorPool = undefined,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    self.primitiveAllocator.destroyDescriptorSets(self);
  }
};
