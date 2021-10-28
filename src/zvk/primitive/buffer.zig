// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const Buffer = struct {
  handle : vk.Buffer,
  allocation : vk.DeviceMemory,
  size : usize,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.BufferCreateInfo,
    memUsage : vk.MemoryPropertyFlags,
    objectInfo : zvk.primitive.ObjectCreateInfo,
  ) !Buffer {

    log.debug("buffer init: {}", .{objectInfo});

    const self =
      primitiveAllocator.createBuffer(info, memUsage);

    if (self.handle == .null_handle) {
      return error.BufferConstructionFailed;
    }

    primitiveAllocator.labelObject(
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType   = vk.ObjectType.buffer,
        .objectHandle = @bitCast(u64, self.handle),
        .pObjectName  = objectInfo.label,
      },
    );

    primitiveAllocator.labelObject(
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType   = vk.ObjectType.device_memory,
        .objectHandle = @bitCast(u64, self.allocation),
        .pObjectName  = objectInfo.label,
      },
    );

    return self;
  }

  pub fn nullify() Buffer {
    return Buffer {
      .handle = .null_handle,
      .allocation = .null_handle,
      .size = 0,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    if (self.handle != .null_handle)
      self.primitiveAllocator.destroyBuffer(self);
  }

  pub const StagingBufferInfo = struct {
    stagingBuffer : zvk.primitive.Buffer,
    finalBuffer   : zvk.primitive.Buffer,
  };

  pub fn initWithStagingBuffer(
    primitiveAllocator : zvk.primitive.Allocator,
    commandBuffer      : vk.CommandBuffer,
    info               : vk.BufferCreateInfo,
    memUsage           : vk.MemoryPropertyFlags,
    data               : [] const u8,
    objectInfo         : zvk.primitive.ObjectCreateInfo,
  ) !StagingBufferInfo {
    assert(info.size == data.len);

    // buffer that can be easily mapped to CPU
    var stagingBuffer : Buffer =
      try @This().init(
        primitiveAllocator,
        vk.BufferCreateInfo {
          .size = info.size,
          .usage = vk.BufferUsageFlags { .transfer_src_bit = true },
          .flags = vk.BufferCreateFlags {},
          .sharingMode = vk.SharingMode.exclusive,
          .queueFamilyIndexCount = info.queueFamilyIndexCount,
          .pQueueFamilyIndices = info.pQueueFamilyIndices,
        },
        vk.MemoryPropertyFlags {
          .host_visible_bit = true,
          .host_coherent_bit = true
        },
        zvk.primitive.ObjectCreateInfo {
          .label =
            util.StringArena.init(objectInfo.label).concat("-Staging").cStr(),
        },
      );

    const vkd = primitiveAllocator.vkd;

    // -- map & write to memory
    var mappedMemory =
      @ptrCast(
        [*c] u8,
        try vkd.vkdd.mapMemory(
          vkd.device,
          stagingBuffer.allocation,
          0, info.size,
          vk.MemoryMapFlags { },
        ),
      );

    assert(mappedMemory != null);

    std.mem.copy(
      u8,
      @ptrCast([*] u8, mappedMemory)[0 .. info.size],
      @ptrCast([*] const u8, data)[0 .. info.size],
    );

    vkd.vkdd.vkUnmapMemory(vkd.device, stagingBuffer.allocation,);

    // -- create final buffer to be staged
    var finalBufferInfo = info;
    finalBufferInfo.usage =
      vk.BufferUsageFlags.merge(
        finalBufferInfo.usage,
        vk.BufferUsageFlags { .transfer_dst_bit = true, },
      );
    var finalBuffer =
      try zvk.primitive.Buffer.init(
        primitiveAllocator, finalBufferInfo, memUsage, objectInfo
      );

    // -- copy staging buffer device memory to final buffer & return
    var region = vk.BufferCopy {
      .srcOffset = 0,
      .dstOffset = 0,
      .size      = info.size,
    };

    vkd.vkdd.cmdCopyBuffer(
      commandBuffer, stagingBuffer.handle, finalBuffer.handle, 1,
      @ptrCast([*] vk.BufferCopy, &region),
    );

    return StagingBufferInfo {
      .stagingBuffer = stagingBuffer, .finalBuffer = finalBuffer,
    };
  }

  pub fn initWithInitialDataWithOneTimeCommandBuffer(
    primitiveAllocator : zvk.primitive.Allocator,
    commandPool : vk.CommandPool,
    info        : vk.BufferCreateInfo,
    memUsage    : vk.MemoryPropertyFlags,
    data        : [] const u8,
    objectInfo  : zvk.primitive.ObjectCreateInfo,
  ) !zvk.primitive.Buffer {
    assert(data.len != 0);
    assert(info.size != 0);
    std.log.info("data: '{}'\n info: '{}'", .{data.len, info.size});
    assert(info.size == data.len);

    var commandBuffer =
      try zvk.primitive.CommandBuffers.init(
        primitiveAllocator,
        vk.CommandBufferAllocateInfo {
          .pNext = null,
          .commandPool = commandPool,
          .level = vk.CommandBufferLevel.primary,
          .commandBufferCount = 1,
        },
        zvk.primitive.ObjectCreateInfo {
          .label =
            util.StringArena.init(objectInfo.label).concat("-Init").cStr(),
        },
      );
    defer commandBuffer.deinit();

    // -- start record
    var beginInfo = vk.CommandBufferBeginInfo {
      .flags = vk.CommandBufferUsageFlags { .one_time_submit_bit = true },
      .pInheritanceInfo = null,
    };

    const vkd = primitiveAllocator.vkd;

    try vkd.vkdd.beginCommandBuffer(commandBuffer.handles.items[0], beginInfo);

    // copy data
    var stagingBufferInfo =
      try zvk.primitive.Buffer.initWithStagingBuffer(
        primitiveAllocator,
        commandBuffer.handles.items[0],
        info,
        memUsage,
        data,
        objectInfo,
      );

    // -- end record
    _ = vkd.vkdd.vkEndCommandBuffer(commandBuffer.handles.items[0]);

    var submitInfo = vk.SubmitInfo {
      .waitSemaphoreCount = 0,
      .pWaitSemaphores = undefined,
      .pWaitDstStageMask = undefined,
      .commandBufferCount= 1,
      .pCommandBuffers =
        @ptrCast([*] const vk.CommandBuffer, &commandBuffer.handles.items[0]),
      .signalSemaphoreCount = 0,
      .pSignalSemaphores = undefined,
    };

    try vkd.vkdd.queueSubmit(
      vkd.queueGTC.handle,
      1, @ptrCast([*] const vk.SubmitInfo, &submitInfo),
      .null_handle,
    );

    try vkd.vkdd.queueWaitIdle(vkd.queueGTC.handle);

    stagingBufferInfo.stagingBuffer.deinit();

    return stagingBufferInfo.finalBuffer;
  }

  pub fn DeviceAddress(self : @This()) vk.DeviceAddress {
    var info = vk.BufferDeviceAddressInfo {
      .buffer = self.handle,
    };
    const vkd = self.primitiveAllocator.vkd;
    return vkd.vkdd.getBufferDeviceAddress(vkd.device, info);
  }
};
