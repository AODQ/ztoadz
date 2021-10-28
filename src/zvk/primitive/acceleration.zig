// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const Acceleration = struct {
  handle : vk.AccelerationStructureKHR,
  buffer : zvk.primitive.Buffer,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.AccelerationStructureCreateInfoKHR,
    queueIndex : u32,
    objectInfo : zvk.primitive.ObjectCreateInfo,
  ) !Acceleration {

    var self : @This() = undefined;

    self.primitiveAllocator = primitiveAllocator;

    self.buffer =
      try zvk.primitive.Buffer.init(
        primitiveAllocator,
        vk.BufferCreateInfo {
          .flags = vk.BufferCreateFlags {},
          .size = info.size,
          .usage = vk.BufferUsageFlags {
            .acceleration_structure_storage_bit_khr = true,
            .shader_device_address_bit = true,
          },
          .sharingMode = vk.SharingMode.exclusive,
          .queueFamilyIndexCount = 1,
          .pQueueFamilyIndices = @ptrCast([*] const u32, &queueIndex),
        },
        vk.MemoryPropertyFlags { },
        zvk.primitive.ObjectCreateInfo {
          .label =
            util.StringArena.init(objectInfo.label).concat("-Buffer").cStr(),
        },
      )
    ;

    var infoWithBuffer = info;
    infoWithBuffer.buffer = self.buffer.handle;

    self.handle = 
      try primitiveAllocator.vkd.vkdd.createAccelerationStructureKHR(
        primitiveAllocator.vkd.device,
        infoWithBuffer,
        null
      )
    ;

    return self;
  }

  pub fn nullify() Acceleration {
    return Acceleration {
      .primitiveAllocator = undefined,
      .handle = .null_handle,
      .buffer = zvk.primitive.Buffer.nullify(),
    };
  }

  pub fn deinit(self : @This()) void {
    if (self.handle != .null_handle) {
      self.primitiveAllocator.vkd.vkdd.destroyAccelerationStructureKHR(
        self.primitiveAllocator.vkd.device,
        self.handle,
        null,
      );
    }

    self.buffer.deinit();
  }
};
