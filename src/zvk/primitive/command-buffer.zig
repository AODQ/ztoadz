// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const CommandBuffers = struct {
  handles : std.ArrayList(vk.CommandBuffer),
  commandPool : vk.CommandPool,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.CommandBufferAllocateInfo,
    objectInfo : zvk.primitive.ObjectCreateInfo,
  ) !CommandBuffers {
    log.debug("command buffers init: {}", .{objectInfo});
    var self = primitiveAllocator.createCommandBuffers(info);

    if (@bitCast(u64, self.commandPool) == 0) {
      return error.CommandBufferConstructionFailed;
    }

    for (self.handles.items) |buf| {
      primitiveAllocator.labelObject(
        vk.DebugUtilsObjectNameInfoEXT {
          .objectType = vk.ObjectType.command_buffer,
          .objectHandle = @bitCast(u64, buf),
          .pObjectName = objectInfo.label,
        },
      );
    }

    return self;
  }

  pub fn nullify() CommandBuffers {
    return CommandBuffers {
      .handles = undefined,
      .commandPool = .null_handle,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    self.primitiveAllocator.destroyCommandBuffers(self);
  }
};
