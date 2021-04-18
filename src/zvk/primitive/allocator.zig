// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const ObjectCreateInfo = struct  {
  label : [:0] const u8,
};

pub const Allocator = struct {

  data : * c_void,
  vkd : * ztoadz.VulkanDeviceContext,

  fnCreateBuffer : fn(
    data : * c_void, vk.BufferCreateInfo, vk.MemoryPropertyFlags
  ) zvk.primitive.Buffer,
  fnDestroyBuffer : fn(data : * c_void, zvk.primitive.Buffer) void,

  fnCreateShaderModule : fn(
    data : * c_void, vk.ShaderModuleCreateInfo,
  ) zvk.primitive.ShaderModule,

  fnDestroyShaderModule : fn(
    data : * c_void, zvk.primitive.ShaderModule,
  ) void,

  fnCreateDescriptorSetLayout : fn(
    data : * c_void, vk.DescriptorSetLayoutCreateInfo,
  ) zvk.primitive.DescriptorSetLayout,

  fnDestroyDescriptorSetLayout : fn(
    data : * c_void, zvk.primitive.DescriptorSetLayout,
  ) void,

  fnCreateDescriptorPool : fn(
    data : * c_void, vk.DescriptorPoolCreateInfo,
  ) zvk.primitive.DescriptorPool,

  fnDestroyDescriptorPool : fn(
    data : * c_void, zvk.primitive.DescriptorPool,
  ) void,

  fnCreateDescriptorSets : fn(
    data : * c_void, vk.DescriptorSetAllocateInfo,
  ) zvk.primitive.DescriptorSets,

  fnDestroyDescriptorSets : fn(
    data : * c_void, zvk.primitive.DescriptorSets,
  ) void,

  fnCreatePipelineLayout : fn(
    data : * c_void, vk.PipelineLayoutCreateInfo,
  ) zvk.primitive.PipelineLayout,

  fnDestroyPipelineLayout : fn(
    data : * c_void, zvk.primitive.PipelineLayout,
  ) void,

  fnCreateComputePipeline : fn(
    data : * c_void, vk.ComputePipelineCreateInfo,
  ) zvk.primitive.ComputePipeline,

  fnDestroyComputePipeline : fn(
    data : * c_void, zvk.primitive.ComputePipeline,
  ) void,

  fnCreateCommandPool : fn(
    data : * c_void, vk.CommandPoolCreateInfo,
  ) zvk.primitive.CommandPool,

  fnDestroyCommandPool : fn(
    data : * c_void, zvk.primitive.CommandPool,
  ) void,

  fnCreateCommandBuffers : fn(
    data : * c_void, vk.CommandBufferAllocateInfo,
  ) zvk.primitive.CommandBuffers,

  fnDestroyCommandBuffers : fn(
    data : * c_void, zvk.primitive.CommandBuffers,
  ) void,

  fnLabelObject : fn(data : * c_void, vk.DebugUtilsObjectNameInfoEXT) void,
  fnDeinit : fn(data: * c_void) void,

  pub fn deinit(self : @This()) void {
    self.fnDeinit(self.data);
  }

  pub fn createBuffer(
    self : @This(),
    info : vk.BufferCreateInfo,
    flags : vk.MemoryPropertyFlags,
  ) zvk.primitive.Buffer {
    var ret = self.fnCreateBuffer(self.data, info, flags);
    ret.primitiveAllocator = self;
    return ret;
  }

  pub fn destroyBuffer(self : @This(), buffer : zvk.primitive.Buffer) void {
    return self.fnDestroyBuffer(self.data, buffer);
  }

  pub fn createShaderModule(
    self : @This(), info : vk.ShaderModuleCreateInfo,
  ) zvk.primitive.ShaderModule {
    var ret = self.fnCreateShaderModule(self.data, info);
    ret.primitiveAllocator = self;
    return ret;
  }

  pub fn destroyShaderModule(
    self : @This(), module : zvk.primitive.ShaderModule
  ) void {
    return self.fnDestroyShaderModule(self.data, module);
  }

  pub fn createDescriptorSetLayout(
    self : @This(), info : vk.DescriptorSetLayoutCreateInfo,
  ) zvk.primitive.DescriptorSetLayout {
    var ret = self.fnCreateDescriptorSetLayout(self.data, info);
    ret.primitiveAllocator = self;
    return ret;
  }

  pub fn destroyDescriptorSetLayout(
    self : @This(), module : zvk.primitive.DescriptorSetLayout
  ) void {
    return self.fnDestroyDescriptorSetLayout(self.data, module);
  }

  pub fn createDescriptorPool(
    self : @This(), info : vk.DescriptorPoolCreateInfo,
  ) zvk.primitive.DescriptorPool {
    var ret = self.fnCreateDescriptorPool(self.data, info);
    ret.primitiveAllocator = self;
    return ret;
  }

  pub fn destroyDescriptorPool(
    self : @This(), module : zvk.primitive.DescriptorPool
  ) void {
    return self.fnDestroyDescriptorPool(self.data, module);
  }

  pub fn createDescriptorSets(
    self : @This(),
    info : vk.DescriptorSetAllocateInfo,
  ) zvk.primitive.DescriptorSets {
    var ret = self.fnCreateDescriptorSets(self.data, info);
    ret.primitiveAllocator = self;
    return ret;
  }

  pub fn destroyDescriptorSets(
    self : @This(), module : zvk.primitive.DescriptorSets
  ) void {
    return self.fnDestroyDescriptorSets(self.data, module);
  }

  pub fn createPipelineLayout(
    self : @This(),
    info : vk.PipelineLayoutCreateInfo,
  ) zvk.primitive.PipelineLayout {
    var ret = self.fnCreatePipelineLayout(self.data, info);
    ret.primitiveAllocator = self;
    return ret;
  }

  pub fn destroyPipelineLayout(
    self : @This(), module : zvk.primitive.PipelineLayout
  ) void {
    return self.fnDestroyPipelineLayout(self.data, module);
  }

  pub fn createComputePipeline(
    self : @This(),
    info : vk.ComputePipelineCreateInfo,
  ) zvk.primitive.ComputePipeline {
    var ret = self.fnCreateComputePipeline(self.data, info);
    ret.primitiveAllocator = self;
    return ret;
  }

  pub fn destroyComputePipeline(
    self : @This(), module : zvk.primitive.ComputePipeline
  ) void {
    return self.fnDestroyComputePipeline(self.data, module);
  }

  pub fn createCommandPool(
    self : @This(),
    info : vk.CommandPoolCreateInfo,
  ) zvk.primitive.CommandPool {
    var ret = self.fnCreateCommandPool(self.data, info);
    ret.primitiveAllocator = self;
    return ret;
  }

  pub fn destroyCommandPool(
    self : @This(), module : zvk.primitive.CommandPool
  ) void {
    return self.fnDestroyCommandPool(self.data, module);
  }

  pub fn createCommandBuffers(
    self : @This(),
    info : vk.CommandBufferAllocateInfo,
  ) zvk.primitive.CommandBuffers {
    var ret = self.fnCreateCommandBuffers(self.data, info);
    ret.primitiveAllocator = self;
    return ret;
  }

  pub fn destroyCommandBuffers(
    self : @This(), module : zvk.primitive.CommandBuffers
  ) void {
    return self.fnDestroyCommandBuffers(self.data, module);
  }

  pub fn labelObject(
    self : @This(), info : vk.DebugUtilsObjectNameInfoEXT
  ) void {
    return self.fnLabelObject(self.data, info);
  }
};
