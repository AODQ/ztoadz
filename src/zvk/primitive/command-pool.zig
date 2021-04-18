// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const CommandPool = struct {
  handle : vk.CommandPool,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.CommandPoolCreateInfo,
    objectInfo : zvk.primitive.ObjectCreateInfo,
  ) !CommandPool {
    log.debug("command pool init: {}", .{objectInfo});
    var self = primitiveAllocator.createCommandPool(info);

    if (@bitCast(u64, self.handle) == 0) {
      return error.CommandPoolConstructionFailed;
    }

    primitiveAllocator.labelObject(
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType = vk.ObjectType.command_pool,
        .objectHandle = @bitCast(u64, self.handle),
        .pObjectName = objectInfo.label,
      },
    );

    return self;
  }

  pub fn nullify() CommandPool {
    return CommandPool {
      .handle = .null_handle,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    self.primitiveAllocator.destroyCommandPool(self);
  }
};
