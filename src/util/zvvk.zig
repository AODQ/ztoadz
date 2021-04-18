// lots of helper functions taken from NVVK NVPro samples

pub usingnamespace @import("ztoadz.zig");

const vk = @import("../third-party/vulkan.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const AllocatorDedicated = struct {

  pub const Buffer = struct {
    buffer : vk.Buffer,
    allocation : vk.DeviceMemory,
    size : usize,
  };

  pub const Image = struct {
    image : vk.Image,
    allocation : vk.DeviceMemory,
  };

  pub const Texture = struct {
    image : vk.Image,
    allocation : vk.DeviceMemory,
    descriptor : vk.DescriptorImageInfo,
  };

  pub const Acceleration = struct {
    accel : vk.AccelerationStructureKHR,
    buffer : Buffer,
  };

  pub const GarbageCollection = struct {
    fence : vk.Fence,
    stagingBuffers : std.ArrayList(Buffer)
  };

  vkd : * VulkanDeviceContext,
  stagingBuffers : std.ArrayList(Buffer),
  garbageBuffers : std.ArrayList(GarbageCollection),
  samplerPool : SamplerPool,
  allocator : * std.mem.Allocator,

  pub fn LabelObject(
    self : @This(),
    info : vk.DebugUtilsObjectNameInfoEXT,
  ) void {
    self.vkd.vkdd.setDebugUtilsObjectNameEXT(self.vkd.device, info)
      catch |err| {
        std.log.warning("Could not label debug object: {}", .{info});
      }
    ;
  }

  pub fn init(
    vkd : * VulkanDeviceContext,
    allocator : * std.mem.Allocator
  ) !@This() {
    return @This() {
      .vkd = vkd,
      .stagingBuffers = std.ArrayList(Buffer).init(allocator),
      .garbageBuffers = std.ArrayList(GarbageCollection).init(allocator),
      .samplerPool = try SamplerPool.init(vkd, allocator),
      .allocator = allocator,
    };
  }

  pub fn deinit(self : * @This()) void {
    self.garbageBuffers.deinit();
    self.samplerPool.deinit();
    self.stagingBuffers.deinit();
  }

  pub fn CreateBuffer(
    self : @This(),
    info : vk.BufferCreateInfo,
    memUsage : vk.MemoryPropertyFlags,
  ) !Buffer {
    var buffer : Buffer = undefined;

    buffer.buffer = try self.vkd.vkdd.createBuffer(self.vkd.device, info, null);
    buffer.size = info.size;

    // -- memory requirements
    var dedicatedReqs = vk.MemoryDedicatedRequirements {
      .prefersDedicatedAllocation = 0,
      .requiresDedicatedAllocation = 0,
    };

    var bufferReqs = vk.BufferMemoryRequirementsInfo2 {
      .buffer = buffer.buffer,
    };

    var memReqs = vk.MemoryRequirements2 {
      .pNext = &dedicatedReqs,
      .memoryRequirements = undefined,
    };

    self.vkd.vkdd.getBufferMemoryRequirements2(
      self.vkd.device, bufferReqs, &memReqs
    );

    // device address
    var memFlagInfo = vk.MemoryAllocateFlagsInfo {
      .flags = vk.MemoryAllocateFlags{},
      .deviceMask = 0
    };

    if (
      info.usage.contains(vk.BufferUsageFlags{.shader_device_address_bit=true})
    ) {
      memFlagInfo.flags = vk.MemoryAllocateFlags { .device_address_bit = true };
    }

    // allocate memory
    var memoryAllocateInfo = vk.MemoryAllocateInfo {
      .pNext = &memFlagInfo,
      .allocationSize = memReqs.memoryRequirements.size,
      .memoryTypeIndex =
        try self.GetMemoryType(
          memReqs.memoryRequirements.memoryTypeBits, memUsage
        ),
    };

    buffer.allocation =
      try self.vkd.vkdd.allocateMemory(
        self.vkd.device, memoryAllocateInfo, null
      );

    self.CheckMemory(buffer.allocation);

    // bind memory to buffer

    try self.vkd.vkdd.bindBufferMemory(
      self.vkd.device, buffer.buffer, buffer.allocation, 0
    );

    return buffer;
  }

  pub fn CreateBufferWithInitialData(
    self : * @This(),
    commandBuffer : vk.CommandBuffer,
    info : vk.BufferCreateInfo,
    memUsage : vk.MemoryPropertyFlags,
    data : [] const u8
  ) !Buffer {

    assert(info.size == data.len);

    // buffer that can be easily mapped to CPU
    var stagingBuffer : Buffer =
      try self.CreateBuffer(
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
      );
    (try self.stagingBuffers.addOne()).* = stagingBuffer;

    // -- map & write to memory
    var mappedMemory =
      @ptrCast(
        [*c] u8,
        try self.vkd.vkdd.mapMemory(
          self.vkd.device,
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

    self.vkd.vkdd.vkUnmapMemory(
      self.vkd.device,
      stagingBuffer.allocation,
    );

    // -- create final buffer to be staged
    var finalBufferInfo = info;
    finalBufferInfo.usage =
      vk.BufferUsageFlags.merge(
        finalBufferInfo.usage,
        vk.BufferUsageFlags { .transfer_dst_bit = true, },
      );
    var finalBuffer : Buffer = try self.CreateBuffer(finalBufferInfo, memUsage);

    // -- copy staging buffer device memory to final buffer & return
    var region = vk.BufferCopy {
      .srcOffset = 0,
      .dstOffset = 0,
      .size      = info.size,
    };

    self.vkd.vkdd.cmdCopyBuffer(
      commandBuffer, stagingBuffer.buffer, finalBuffer.buffer, 1,
      @ptrCast([*] vk.BufferCopy, &region)
    );

    return finalBuffer;
  }

  pub fn CreateBufferWithInitialDataWithOneTimeCommandBuffer(
    self        : * @This(),
    commandPool : vk.CommandPool,
    info        : vk.BufferCreateInfo,
    memUsage    : vk.MemoryPropertyFlags,
    data        : [] const u8,
  ) !Buffer {

    assert(data.len != 0);
    assert(info.size != 0);
    std.log.info("data: '{}'\n info: '{}'", .{data.len, info.size});
    assert(info.size == data.len);

    var commandBuffer =
      try VulkanCommandBuffer.init(
        self.allocator,
        self.vkd,
        vk.CommandBufferAllocateInfo {
          .pNext = null,
          .commandPool = commandPool,
          .level = vk.CommandBufferLevel.primary,
          .commandBufferCount = 1,
        },
      );
    defer commandBuffer.deinit();

    // -- start record
    var beginInfo = vk.CommandBufferBeginInfo {
      .flags = vk.CommandBufferUsageFlags { .one_time_submit_bit = true },
      .pInheritanceInfo = null,
    };

    try self.vkd.vkdd.beginCommandBuffer(
      commandBuffer.buffers.items[0], beginInfo
    );

    // copy data
    var finalBuffer =
      self.CreateBufferWithInitialData(
        commandBuffer.buffers.items[0],
        info,
        memUsage,
        data,
      );

    // -- end record
    _ = self.vkd.vkdd.vkEndCommandBuffer(commandBuffer.buffers.items[0]);

    var submitInfo = vk.SubmitInfo {
      .waitSemaphoreCount = 0,
      .pWaitSemaphores = undefined,
      .pWaitDstStageMask = undefined,
      .commandBufferCount= 1,
      .pCommandBuffers =
        @ptrCast([*] const vk.CommandBuffer, &commandBuffer.buffers.items[0]),
      .signalSemaphoreCount = 0,
      .pSignalSemaphores = undefined,
    };

    try self.vkd.vkdd.queueSubmit(
      self.vkd.queueGTC.handle,
      1, @ptrCast([*] const vk.SubmitInfo, &submitInfo),
      .null_handle,
    );

    try self.vkd.vkdd.queueWaitIdle(self.vkd.queueGTC.handle);

    return finalBuffer;
  }

  pub fn CreateImage(
    self : @This(),
    info : vk.ImageCreateInfo,
    memoryUsage : vk.MemoryPropertyFlags,
  ) !Image {

    // create image
    var resultImage =
      try self.vkd.vkdd.createImage(self.vkd.device, info, null);

    // find memory requirements
    var dedicatedReqs = vk.MemoryDedicatedRequirements {
      .prefersDedicatedAllocation = false,
      .requiredDedicatedAllocation = false,
    };

    var imageReqs = vk.ImageMemoryRequirementsInfo2 {
      .image = resultImage.image,
    };

    var memReqs = vk.MemoryRequirements2 {
      .pNext = &dedicatedReqs,
      .memoryRequirements = undefined,
    };

    try self.vkd.vkdd.vkGetImageMemoryRequirements2(
      self.vkd.device, &bufferReqs, &memReqs
    );


    // allocate memory
    var memoryAllocateInfo = vk.MemoryAllocateInfo {
      .allocationSize = memReqs.memoryRequirements.size,
      .memoryTypeIndex =
        self.GetMemoryType(memReqs.memoryRequirements.memoryTypeBits, memUsage),
    };

    resultImage.allocatoin = AllocateMemory(memoryAllocateInfo);
    self.CheckMemory(resultImage.allocation);

    // bind memory to image
    try self.vkd.vkdd.bindImageMemory(
      self.vkd.device, resultImage.image, resultImage.allocation, 0
    );

    return resultImage;
  }

  pub fn CreateImageFromData(
    self : @This(),
    cmdBuffer : vk.CommandBuffer,
    size : usize,
    data : * const void,
    info : vk.ImageCreateInfo,
    layout : vk.ImageLayout,
    memoryUsage : vk.MemoryPropertyFlags,
  ) !Image {
    var resultImage = self.CreateImage(info, memoryUsage);

    if (!data) {
      CmdBarrierImageLayout(
        commandBuffer, resultImage.image, vk.ImageLayout.undefined_, layout
      );
      return resultImage;
    }


    // -- copy data to staging buffer then to image

    // create staging buffer
    var stagingBuffer =
      try self.CreateBuffer(
        size,
        vk.BufferUsageFlags.transfer_src_bit,
        vk.MemoryPropertyFlags.host_visible_bit
      | vk.MemoryPropertyFlags.host_coherent_bit
      );

    (try self.stagingBuffers.addOne).* = stagingBuffer;

    // copy data to buffer
    var mapped =
      try self.vkd.vkdd.mapMemory(
        self.vkd.device, stagingBuffer.allocation, 0, size, 0, &mapped
      );
    std.c.memcpy(mapped, data, size);
    vk.unmapMemory(self.vkd.device, stagingBuffer.allocation);

    // copy buffer to image
    var subresourceRange = vk.ImageSubresourceRange {
      .aspectMask = vk.ImageAspectFlags.color_bit,
      .baseArrayLayer = 0,
      .baseMipLevel = 0,
      .layerCount = 1,
      .levelCount = info.mipLevels,
    };

    CmdBarrierImageLayoutSubresourceRange(
      commandBuffer, resultImage.image,
      vk.ImageLayout.undefined_, vk.ImageLayout.transfer_dst_optimal,
      subresourceRange
    );

    var bufferCopyRegion = vk.BufferImageCopy {
      .imageSubresources = vk.ImageSubresource {
        .aspectMask = vk.ImageAspectFlags.color_bit,
        .layerCount = 1,
      },
      .imageExtent = info.extent,
    };

    self.vkd.vkdd.cmdCopyBufferToImage(
      commandBuffer, stagingBuffer.buffer, resultImage.image,
      vk.imageLayout.transfer_dst_optimal, layout
    );

    // set final image layout
    CmdBarrierImageLayout(
      commandBuffer, resultImage.image,
      vk.ImageLayout.transfer_dst_optimal, layout
    );

    return resultImage;
  }

  pub fn CreateTexture(
    self : @This(), image : Image, imageViewCreateInfo : vk.ImageViewCreateInfo
  ) !Texture {
    var resultTexture = Texture {
      .image = image.image,
      .allocation = image.allocation,
      .descriptor = vk.DescriptorImageInfo {
        .sampler = .null_handle,
        .imageView = .null_handle,
        .imageLayout = vk.ImageLayout.shader_read_only_optimal,
      },
    };

    assert(imageViewCreateInfo.image == image.image);

    resultTexture.descriptor.imageView =
      try self.vkd.vkdd.createImageView(
        self.vkd.device, imageViewCreateInfo, null
      );

    return resultTexture;
  }

  pub fn CreateTextureWithSampler(
    self : @This(), image : Image,
    imageViewCreateInfo : vk.ImageViewCreateInfo,
    samplerCreateInfo : vk.SamplerCreateInfo,
  ) !Texture {
    var resultTexture = try self.CreateTexture(image, imageViewCreateInfo);

    resultTexture.descriptor.sampler =
      try self.samplerPool.AcquireSampler(samplerCreateInfo)
    ;

    return resultTexture;
  }

  pub fn CreateTextureFromData(
    self : @This(),
    commandBuffer : vk.CommandBuffer,
    size : usize,
    data : * const void,
    info : vk.ImageCreateInfo,
    samplerCreateInfo : vk.SamplerCreateInfo,
    layout : vk.ImageLayout,
    viewType : vk.ImageViewType,
  ) !Texture {
    var image = try self.CreateImage(commandBuffer, size, data, info, layout);

    var viewInfo = vk.ImageViewCreateInfo {
      .image = image.image,
      .format = info.format,
      .viewType = viewType,
      .subresourceRange = vk.ImageSubresourceRange {
        .aspectMask = vk.ImageAspectFlags.color_bit,
        .baseMipLevel = 0,
        .levelCount = vk.REMAINING_MIP_LEVELS,
        .baseArrayLayer = 0,
        .layerCount = vk.REMAINING_ARRAY_LAYERS,
      },
    };

    var resultTexture =
      self.CreateTextureWithSampler(image, viewInfo, samplerCreateInfo);
    resultTexture.descriptor.imageLayout = layout;
    return resultTexture;
  }

  pub fn CreateAcceleration(
    self : @This(),
    accelerationStructureCreateInfo : vk.AccelerationStructureCreateInfoKHR,
  ) !Acceleration {

    var resultAccel : Acceleration = undefined;

    resultAccel.buffer =
      self.CreateBuffer(
        accelerationStructureCreateInfo.size,
        vk.BufferUsageFlags.acceleration_structure_storage_bit_khr
      | vk.BufferUsageFlags.shader_device_address_bit
      );

    accelerationStructureCreateInfo.buffer = resultAccel.buffer.buffer;

    resultAccel.accel =
      self.vkd.vkdd.createAccelerationStructureKHR(
        self.vkd.device,
        accelerationStructureCreateInfo,
        null
      );

    return resultAccel;
  }

  // flush staging buffers, must be done after command buffer is submitted
  pub fn FinalizeAndReleaseStaging(self : @This(), fence : vk.Fence) !void {
    if (self.stagingBuffers.len > 0) {
      (try self.garbageBuffers.addOne()).* = GarbageCollection {
        .fence = fence,
        .stagingBuffers = std.ArrayList(Buffer).init(self.allocator),
      };

      try self.stagingBuffers.resize(0);
    }

    self.CleanGarbage();
  }

  pub fn FinalizeStaging(self : @This()) !void {
    self.FinalizeStaging(.null_handle);
  }

  pub fn DestroyBuffer(self : @This(), buffer : Buffer) void {
    self.vkd.vkdd.destroyBuffer(self.vkd.device, buffer.buffer, null);
    self.vkd.vkdd.freeMemory(self.vkd.device, buffer.allocation, null);
  }

  pub fn DestroyImage(self : @This(), image : Image) void {
    self.vkd.vkdd.destroyImage(self.vkd.device, image.image, null);
    self.vkd.vkdd.freeMemory(self.vkd.device, image.allocation, null);
  }

  pub fn DestroyTexture(self : @This(), texture : Texture) void {
    self.vkd.vkdd.destroyImageView(
      self.vkd.device, texture.descriptor.imageView, null
    );
    self.vkd.vkdd.destroyImage(self.vkd.device, texture.image, null);
    self.vkd.vkdd.freeMemory(self.vkd.device, texture.allocation, null);

    if (texture.descriptor.sampler) {
      self.samplerPool.ReleaseSampler(texture.descriptor.sampler);
    }
  }

  pub fn DestroyAcceleration(self : @This(), accel : Acceleration) void {
    self.vkd.vkdd.destroyAccelerationStructureKHR(
      self.vkd.device, accel.accel, null
    );
    self.DestroyBuffer(accel.buffer);
  }

  pub fn CheckMemory(self : @This(), memory : vk.DeviceMemory) void {
    assert(@enumToInt(memory) != 0);
  }

  pub fn GetMemoryType(
    self : @This(),
    typeBits : u32, properties : vk.MemoryPropertyFlags
  ) error{InvalidPropertyFlags} ! u32 {

    var memProps = &self.vkd.physicalDeviceMemoryProperties;

    var i : u32 = 0;
    while (i < memProps.memoryTypeCount) : (i += 1) {
      if (
        ((typeBits & (@intCast(u32, 1) << @intCast(u5, i))) > 0)
        and memProps.memoryTypes[i].propertyFlags.contains(properties)
      ) {
        return i;
      }
    }

    return error.InvalidPropertyFlags;
  }

  pub fn CleanGarbage(self : @This()) void {
    var i : u32 = 0;
    while (i < self.garbageBuffers.len) {
      var buf = &self.garbageBuffers.items[i];

      var result = vk.Result.success;
      if (buf.fence)
        { result = self.vkd.vkdd.getFenceStates(self.vkd.device, buf.fence); }

      if (result == vk.Result.success) {
        for (buf.stagingBuffers) |s| self.DestroyBuffer(s);
        self.garbageBuffers.orderedRemove(i);
      } else {
        i += 1;
      }
    }
  }
};

// manages unique VkSampler objects. minimizes total number of sample objects
pub const SamplerPool = struct {
  pub const State = struct {
    createInfo : vk.SamplerCreateInfo,
    reduction  : vk.SamplerReductionModeCreateInfo,
    ycbr       : vk.SamplerYcbcrConversionCreateInfo,

    fn Hash(state : State) u64 {
      return std.hash.Crc32.hash(std.mem.asBytes(&state));
    }

    fn Eql(self : State, other : State) bool {
      var a = std.mem.asBytes(&self);
      var b = std.mem.asBytes(&other);

      for (a) |item, idx| {
        if (item != b[idx]) return false;
      }

      return true;
    }
  };

  pub const Chain = struct {
    sType : vk.StructureType,
    pNext : * const Chain,
  };

  pub const Entry = struct {
    sampler : vk.Sampler = .null_handle,
    nextFreeIdx : u32 = ~0,
    refCount : u32 = 0,
    state : State
  };

  vkd : * VulkanDeviceContext,
  freeIdx : u32 = ~@intCast(u32, 0),
  entries : std.ArrayList(Entry),
  stateMap : std.HashMap(State, u32, State.Hash, State.Eql, 80),
  samplerMap : std.AutoHashMap(vk.Sampler, u32),

  pub fn init(
    vkd : * VulkanDeviceContext,
    allocator : * std.mem.Allocator
  ) !@This() {
    var self : @This() = undefined;
    self = @This() {
      .vkd = vkd,
      .entries = std.ArrayList(Entry).init(allocator),
      .stateMap = @TypeOf(self.stateMap).init(allocator),
      .samplerMap = @TypeOf(self.samplerMap).init(allocator),
    };

    return self;
  }

  pub fn deinit(self : * @This()) void {

    for (self.entries.items) |entry, _| {
      if (entry.sampler != .null_handle) {
        self.vkd.vkdd.destroySampler(
          self.vkd.device, entry.sampler, null
        );
      }
    }

    self.entries.deinit();
    self.stateMap.deinit();
    self.samplerMap.deinit();
  }

  pub fn AcquireSampler(
    self : @This(), createInfo : vk.SamplerCreateInfo
  ) !vk.Sampler {
    var state : State = undefined;
    state.createInfo = createInfo;

    var chainExt = @ptrCast(* const Chain, createInfo.pNext);
    while (chainExt) {
      switch (chainExt.sType) {
        .samplerReductionModeCreateInfo => {
          state.reduction =
            @ptrCast(* const vk.SamplerReductionModeCreateInfo, chainExt).*;
        },
        .samplerYcbcrConversionCreateInfo => {
          state.ycbcr =
            @ptrCast(* const vk.SamplerYcbcrConversionCreateInfo, chainExt).*;
        }
      }
      chainExt = chainExt.pNext;
    }

    state.createInfo.pNext = null;
    state.reduction.pNext = null;
    state.ycbr.pNext = null;

    var it = self.stateMap.get(state);
    if (!it) {
      var idx : u32 = 0;
      if (self.freeIdx != ~0) {
        idx = self.freeIdx;
        self.freeIdx = self.entries[idx].nextFreeIdx;
      } else {
        idx = @intCast(u32, self.entries.len);
        try self.entries.addOne();
      }

      var sampler : vk.Sampler =
        try self.vkd.vkdd.createSampler(
          self.vkd.device, createInfo, null, &sampler
        );

      self.entries[idx].refCount = 1;
      self.entries[idx].sampler  = sampler;
      self.entries[idx].refCount = state;

      self.stateMap.put(state, idx);
      self.samplerMap.put(sampler, idx);

      return sampler;
    } else {
      var entry = &self.entries[it.?];
      entry.refCount += 1;
      return entry.sampler;
    }
  }

  pub fn ReleaseSampler(self : @This(), sampler : vk.Sampler) void {
    var it = self.samplerMap.get(sampler);
    if (!it) { return; }

    var idx : u32 = it.?;
    var entry = self.entries.get(idx).?;

    assert(entry.sampler == sampler);
    assert(entry.refCount > 0);

    entry.refCount -= 1;

    if (entry.refCount == 0) {
      self.vkd.vkdd.destroySampler(self.vkd.device, sampler, null);
      entry.sampler = null;
      entry.nextFreeIdx = self.freeIdx;
      self.freeIdx = idx;

      self.stateMap.remove(entry.state);
      self.samplerMap.remove(sampler);
    }
  }
};

// ----

pub fn AccessFlagsForImageLayout(layout : vk.ImageLayout) vk.AccessFlags {
  return
    switch (layout) {
      vk.ImageLayout.preinitialized => vk.AccessFlags.host_write_bit,
      vk.ImageLayout.transfer_dst_optimal => vk.AccessFlags.transfer_write_bit,
      vk.ImageLayout.transfer_src_optimal => vk.AccessFlags.transfer_read_bit,
      vk.ImageLayout.color_attachment_optimal =>
        vk.AccessFlags.color_attachment_bit,
      vk.ImageLayout.depth_stencil_attachment_optimal =>
        vk.AccessFlags.depth_stencil_attachment_write_bit,
      vk.ImageLayout.shader_read_only_optimal => vk.AccessFlags.shader_read_bit,
      else => vk.AccessFlags{},
    };
}

pub fn PipelineStageForImageLayout(
  layout : vk.ImageLayout
) vk.PipelineStageFlags {
  return
    switch (layout) {
      vk.ImageLayout.preinitialized => vk.PipelineStageFlags.host_bit,
      vk.ImageLayout.transfer_dst_optimal => vk.PipelineStageFlags.transfer_bit,
      vk.ImageLayout.transfer_src_optimal => vk.PipelineStageFlags.transfer_bit,
      vk.ImageLayout.color_attachment_optimal =>
        vk.PipelineStageFlags.color_attachment_output_bit,
      vk.ImageLayout.depth_stencil_attachment_optimal =>
        vk.PipelineStageFlags.early_fragment_tests_bit,
      vk.ImageLayout.shader_read_only_optimal =>
        vk.PipelineStageFlags.fragment_shader_bit,
      vk.ImageLayout.undefined_ => vk.PipelineStageFlags.top_of_pipe_bit,
      else => vk.PipelineStageFlags.bottom_of_pipe_bit,
    };
}

pub fn CmdBarrierImageLayoutSubresourceRange(
  vkd : * VulkanDeviceContext,
  commandBuffer : vk.CommandBuffer,
  image : vk.Image,
  oldImageLayout : vk.ImageLayout,
  newImageLayout : vk.ImageLayout,
  subresourceRange : vk.ImageSubresourceRange,
) void {
  var imageMemoryBarrier = vk.ImageMemoryBarrier {
    .oldLayout = oldImageLayout,
    .newLayout = newImageLayout,
    .image     = image,
    .subresourceRange = subresourceRange,
    .srcAccessMask = AccessFlagsForImageLayout(oldImageLayout),
    .dstAccessMask = AccessFlagsForImageLayout(newImageLayout),
    .srcStageMask = PipelineStageForImageLayout(oldImageLayout),
    .dstStageMask = PipelineStageForImageLayout(newImageLayout),
  };

  vkd.vkdd.cmdPipelineBarrier(
    commandBuffer, srcStageMask, dstStageMask, 0, 0, null, 0, null, 1,
    &imageMemoryBarrier
  );
}

pub fn CmdBarrierImageLayout(
  vkd : * VulkanDeviceContext,
  commandBuffer : vk.CommandBuffer,
  image : vk.Image,
  oldImageLayout : vk.ImageLayout,
  newImageLayout : vk.ImageLayout,
  aspectMask : vk.ImageAspectFlags,
) void {

    var subresourceRange = vk.ImageSubresourceRange {
      .aspectMask = aspectMask,
      .levelCount = vk.REMAINING_MIP_LEVELS,
      .layerCount = vk.REMAINING_ARRAY_LAYERS,
      .baseMipLevel = 0,
      .baseArrayLayer = 0,
    };

  CmdBarrierImageLayoutSubresourceRange(
    vkd, commandBuffer, image, oldImageLayout, newImageLayout, subresourceRange
  );
}

// ----


