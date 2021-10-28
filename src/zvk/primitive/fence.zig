// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const Fence = struct {
  handle : vk.Fence,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.FenceCreateInfo,
    objectInfo : zvk.primitive.ObjectCreateInfo,
  ) !Fence {
    log.debug("fence init: {}", .{objectInfo});
    var self = primitiveAllocator.createFence(info);

    if (@bitCast(u64, self.handle) == 0) {
      return error.FenceConstructionFailed;
    }

    primitiveAllocator.labelObject(
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType = vk.ObjectType.fence,
        .objectHandle = @bitCast(u64, self.handle),
        .pObjectName = objectInfo.label,
      },
    );

    return self;
  }

  pub fn nullify() Fence {
    return Fence {
      .handle = .null_handle,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    self.primitiveAllocator.destroyFence(self);
  }

  pub fn getStatus(self : @This()) bool {
    unreachable;
  }

  pub fn wait(self : @This()) anyerror!vk.Result {
    return
      try self.primitiveAllocator.vkd.vkdd.waitForFences(
        self.primitiveAllocator.vkd.device,
        1,
        @ptrCast([*] const vk.Fence, &self.handle),
        vk.TRUE,
        1_000_000_000,
      )
    ;
  }

  pub fn waitTimeout(self : @This(), timeout : u64) anyerror!vk.Result {
    return
      try self.primitiveAllocator.vkd.vkdd.waitForFences(
        self.primitiveAllocator.vkd.device,
        1,
        @ptrCast([*] const vk.Fence, &self.handle),
        vk.TRUE,
        timeout
      )
    ;
  }
};
