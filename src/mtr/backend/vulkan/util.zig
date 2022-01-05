const vk = @import("../../../bindings/vulkan.zig");
const std = @import("std");

pub fn getObjectType(object : anytype) vk.ObjectType {
  const typeLabel = @typeName(@TypeOf(object));

  if (std.mem.eql(u8, typeLabel, "Instance")) {
    return .instance;
  }
  else if (std.mem.eql(u8, typeLabel, "PhysicalDevice")) {
    return .physicalDevice;
  }
  else if (std.mem.eql(u8, typeLabel, "Device")) {
    return .device;
  }
  else if (std.mem.eql(u8, typeLabel, "Queue")) {
    return .queue;
  }
  else if (std.mem.eql(u8, typeLabel, "Semaphore")) {
    return .semaphore;
  }
  else if (std.mem.eql(u8, typeLabel, "CommandBuffer")) {
    return .commandBuffer;
  }
  else if (std.mem.eql(u8, typeLabel, "Fence")) {
    return .fence;
  }
  else if (std.mem.eql(u8, typeLabel, "DeviceMemory")) {
    return .deviceMemory;
  }
  else if (std.mem.eql(u8, typeLabel, "Buffer")) {
    return .buffer;
  }
  else if (std.mem.eql(u8, typeLabel, "Image")) {
    return .image;
  }
  else if (std.mem.eql(u8, typeLabel, "Event")) {
    return .event;
  }
  else if (std.mem.eql(u8, typeLabel, "QueryPool")) {
    return .queryPool;
  }
  else if (std.mem.eql(u8, typeLabel, "BufferView")) {
    return .bufferView;
  }
  else if (std.mem.eql(u8, typeLabel, "ImageView")) {
    return .imageView;
  }
  else if (std.mem.eql(u8, typeLabel, "ShaderModule")) {
    return .shaderModule;
  }
  else if (std.mem.eql(u8, typeLabel, "PipelineCache")) {
    return .pipelineCache;
  }
  else if (std.mem.eql(u8, typeLabel, "PipelineLayout")) {
    return .pipelineLayout;
  }
  else if (std.mem.eql(u8, typeLabel, "RenderPass")) {
    return .renderPass;
  }
  else if (std.mem.eql(u8, typeLabel, "Pipeline")) {
    return .pipeline;
  }
  else if (std.mem.eql(u8, typeLabel, "DescriptorSetLayout")) {
    return .descriptorSetLayout;
  }
  else if (std.mem.eql(u8, typeLabel, "Sampler")) {
    return .sampler;
  }
  else if (std.mem.eql(u8, typeLabel, "DescriptorPool")) {
    return .descriptorPool;
  }
  else if (std.mem.eql(u8, typeLabel, "DescriptorSet")) {
    return .descriptorSet;
  }
  else if (std.mem.eql(u8, typeLabel, "Framebuffer")) {
    return .framebuffer;
  }
  else if (std.mem.eql(u8, typeLabel, "CommandPool")) {
    return .commandPool;
  }
  else if (std.mem.eql(u8, typeLabel, "SamplerYcbcrConversion")) {
    return .samplerYcbcrConversion;
  }
  else if (std.mem.eql(u8, typeLabel, "DescriptorUpdateTemplate")) {
    return .descriptorUpdateTemplate;
  }
  else if (std.mem.eql(u8, typeLabel, "SurfaceKHR")) {
    return .surfaceKHR;
  }
  else if (std.mem.eql(u8, typeLabel, "SwapchainKHR")) {
    return .swapchainKHR;
  }
  else if (std.mem.eql(u8, typeLabel, "DisplayKHR")) {
    return .displayKHR;
  }
  else if (std.mem.eql(u8, typeLabel, "DisplayModeKHR")) {
    return .displayModeKHR;
  }
  else if (std.mem.eql(u8, typeLabel, "DebugReportCallbackEXT")) {
    return .debugReportCallbackEXT;
  }
  else if (std.mem.eql(u8, typeLabel, "VideoSessionKHR")) {
    return .videoSessionKHR;
  }
  else if (std.mem.eql(u8, typeLabel, "VideoSessionParametersKHR")) {
    return .videoSessionParametersKHR;
  }
  else if (std.mem.eql(u8, typeLabel, "CuModuleNVX")) {
    return .cuModuleNVX;
  }
  else if (std.mem.eql(u8, typeLabel, "CuFunctionNVX")) {
    return .cuFunctionNVX;
  }
  else if (std.mem.eql(u8, typeLabel, "DebugUtilsMessengerEXT")) {
    return .debugUtilsMessengerEXT;
  }
  else if (std.mem.eql(u8, typeLabel, "AccelerationStructureKHR")) {
    return .accelerationStructureKHR;
  }
  else if (std.mem.eql(u8, typeLabel, "ValidationCacheEXT")) {
    return .validationCacheEXT;
  }
  else if (std.mem.eql(u8, typeLabel, "AccelerationStructureNV")) {
    return .accelerationStructureNV;
  }
  else if (std.mem.eql(u8, typeLabel, "PerformanceConfigurationINTEL")) {
    return .performanceConfigurationINTEL;
  }
  else if (std.mem.eql(u8, typeLabel, "DeferredOperationKHR")) {
    return .deferredOperationKHR;
  }
  else if (std.mem.eql(u8, typeLabel, "IndirectCommandsLayoutNV")) {
    return .indirectCommandsLayoutNV;
  }
  else if (std.mem.eql(u8, typeLabel, "PrivateDataSlotEXT")) {
    return .privateDataSlotEXT;
  }
  else if (std.mem.eql(u8, typeLabel, "BufferCollectionFUCHSIA")) {
    return .bufferCollectionFUCHSIA;
  }

  unreachable;
}
