// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const GarbageCollection = struct {
  fence : vk.Fence,
  stagingBuffers : std.ArrayList(zvk.primitive.Buffer),
};

pub const AllocatorDedicated = struct {

  vkd : * ztoadz.VulkanDeviceContext,
  gc : GarbageCollection,
  allocator : * std.mem.Allocator,

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

  pub fn CheckMemory(self : @This(), memory : vk.DeviceMemory) void {
    assert(@enumToInt(memory) != 0);
  }

  pub fn createBuffer(
    data : * c_void,
    info : vk.BufferCreateInfo,
    memUsage : vk.MemoryPropertyFlags,
  ) zvk.primitive.Buffer {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    var underlyingBuffer =
      self.vkd.vkdd.createBuffer(self.vkd.device, info, null)
      catch |err| {
        log.crit("Could not create buffer: {}", .{err});
        return zvk.primitive.Buffer.nullify();
      };

    var buffer = zvk.primitive.Buffer {
      .allocation         = undefined,
      .handle             = underlyingBuffer,
      .size               = info.size,
      .primitiveAllocator = undefined,
    };

    // -- memory requirements
    var dedicatedReqs = vk.MemoryDedicatedRequirements {
      .prefersDedicatedAllocation = 0,
      .requiresDedicatedAllocation = 0,
    };

    var bufferReqs = vk.BufferMemoryRequirementsInfo2 {
      .buffer = buffer.handle,
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
      info.usage.contains(
        vk.BufferUsageFlags { .shader_device_address_bit = true }
      )
    ) {
      memFlagInfo.flags = vk.MemoryAllocateFlags {
        .device_address_bit = true
      };
    }

    // allocate memory
    var memoryAllocateInfo = vk.MemoryAllocateInfo {
      .pNext = &memFlagInfo,
      .allocationSize = memReqs.memoryRequirements.size,
      .memoryTypeIndex =
        self.GetMemoryType(
          memReqs.memoryRequirements.memoryTypeBits, memUsage
        ) catch |err| {
          log.crit("Could not get memory type: {}", .{err});
          return zvk.primitive.Buffer.nullify();
        },
    };

    buffer.allocation =
      self.vkd.vkdd.allocateMemory(
        self.vkd.device, memoryAllocateInfo, null
      ) catch |err| {
        log.crit("Could not alloc memory: {}", .{err});
        return zvk.primitive.Buffer.nullify();
      };

    self.CheckMemory(buffer.allocation);

    // bind memory to buffer

    self.vkd.vkdd.bindBufferMemory(
      self.vkd.device, buffer.handle, buffer.allocation, 0
    ) catch |err| {
      log.crit("Could not bind buffer memory: {}", .{err});
      return zvk.primitive.Buffer.nullify();
    };

    return buffer;
  }

  pub fn destroyBuffer(data : * c_void, buffer : zvk.primitive.Buffer) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    self.vkd.vkdd.destroyBuffer(self.vkd.device, buffer.handle, null);
    self.vkd.vkdd.freeMemory(self.vkd.device, buffer.allocation, null);
  }

  pub fn createFence(
    data : * c_void,
    info : vk.FenceCreateInfo,
  ) zvk.primitive.Fence {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    var fence : zvk.primitive.Fence = undefined;
    fence.handle =
      self.vkd.vkdd.createFence(self.vkd.device, info, null)
        catch |err| {
          log.crit("Could not create fence: {}", .{err});
          return zvk.primitive.Fence.nullify();
        }
    ;

     return fence;
  }

  pub fn destroyFence(data : * c_void, fence : zvk.primitive.Fence,) void
  {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    self.vkd.vkdd.destroyFence(self.vkd.device, fence.handle, null);
  }

  pub fn createShaderModule(
    data : * c_void,
    info : vk.ShaderModuleCreateInfo,
  ) zvk.primitive.ShaderModule {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    const module =
      self.vkd.vkdd.createShaderModule(self.vkd.device, info, null)
      catch |err| {
        log.crit("Could not create shader module: {}", .{err});
        return zvk.primitive.ShaderModule.nullify();
      };
    return zvk.primitive.ShaderModule {
      .handle = module,
      .primitiveAllocator = undefined,
    };
  }

  pub fn destroyShaderModule(
    data : * c_void,
    module : zvk.primitive.ShaderModule,
  ) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    self.vkd.vkdd.destroyShaderModule(self.vkd.device, module.handle, null);
  }

  pub fn createDescriptorSetLayout(
    data : * c_void,
    info : vk.DescriptorSetLayoutCreateInfo,
  ) zvk.primitive.DescriptorSetLayout {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    const module =
      self.vkd.vkdd.createDescriptorSetLayout(self.vkd.device, info, null)
      catch |err| {
        log.crit("Could not create descriptorSetLayouts: {}", .{err});
        return zvk.primitive.DescriptorSetLayout.nullify();
      };
    return zvk.primitive.DescriptorSetLayout {
      .handle = module,
      .primitiveAllocator = undefined,
    };
  }

  pub fn destroyDescriptorSetLayout(
    data : * c_void,
    module : zvk.primitive.DescriptorSetLayout,
  ) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    self.vkd.vkdd.destroyDescriptorSetLayout(
      self.vkd.device, module.handle, null,
    );
  }

  pub fn createDescriptorPool(
    data : * c_void,
    info : vk.DescriptorPoolCreateInfo,
  ) zvk.primitive.DescriptorPool {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    const module =
      self.vkd.vkdd.createDescriptorPool(self.vkd.device, info, null)
      catch |err| {
        log.crit("Could not create descriptorPool: {}", .{err});
        return zvk.primitive.DescriptorPool.nullify();
      };
    return zvk.primitive.DescriptorPool {
      .handle = module,
      .primitiveAllocator = undefined,
    };
  }

  pub fn destroyDescriptorPool(
    data : * c_void,
    module : zvk.primitive.DescriptorPool,
  ) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    self.vkd.vkdd.destroyDescriptorPool(
      self.vkd.device, module.handle, null,
    );
  }

  pub fn createDescriptorSets(
    data : * c_void,
    info : vk.DescriptorSetAllocateInfo,
  ) zvk.primitive.DescriptorSets {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    var sets = zvk.primitive.DescriptorSets.nullify();
    sets.descriptorPool = info.descriptorPool;
    sets.handles = @TypeOf(sets.handles).init(self.allocator);

    sets.handles.resize(info.descriptorSetCount)
      catch |err| {
        log.crit("Could not create descriptor sets", .{});
        return zvk.primitive.DescriptorSets.nullify();
      };

    self.vkd.vkdd.allocateDescriptorSets(
      self.vkd.device, info, ztoadz.PtrCast(sets.handles.items)
    ) catch |err| {
        log.crit("Could not create descriptor sets: {}", .{err});
        return zvk.primitive.DescriptorSets.nullify();
    };

    return sets;
  }

  pub fn destroyDescriptorSets(
    data : * c_void,
    sets : zvk.primitive.DescriptorSets,
  ) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    self.vkd.vkdd.freeDescriptorSets(
      self.vkd.device,
      sets.descriptorPool,
      @intCast(u32, sets.handles.items.len),
      ztoadz.PtrCast(sets.handles.items),
    ) catch |err| {
      log.crit("Could not free descriptor sets", .{});
    };

    sets.handles.deinit();
  }

  pub fn createPipelineLayout(
    data : * c_void,
    info : vk.PipelineLayoutCreateInfo,
  ) zvk.primitive.PipelineLayout {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    const pipelineLayout =
      self.vkd.vkdd.createPipelineLayout(self.vkd.device, info, null)
      catch |err| {
        log.crit("Could not create pipeline layout: {}", .{err});
        return zvk.primitive.PipelineLayout.nullify();
      };
    return zvk.primitive.PipelineLayout {
      .handle = pipelineLayout,
      .primitiveAllocator = undefined,
    };
  }

  pub fn destroyPipelineLayout(
    data : * c_void,
    pipelineLayout : zvk.primitive.PipelineLayout,
  ) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    self.vkd.vkdd.destroyPipelineLayout(
      self.vkd.device,
      pipelineLayout.handle,
      null,
    );
  }

  pub fn createComputePipeline(
    data : * c_void,
    info : vk.ComputePipelineCreateInfo,
  ) zvk.primitive.ComputePipeline {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    var pipeline : vk.Pipeline = undefined;
    _ =
      self.vkd.vkdd.createComputePipelines(
        self.vkd.device,
        .null_handle, // pipeline cache
        1,
        @ptrCast(
          [*] const vk.ComputePipelineCreateInfo, &info
        ),
        null,
        @ptrCast([*] vk.Pipeline, &pipeline)
      )
      catch |err| {
        log.crit("Could not create compute pipeline: {}", .{err});
        return zvk.primitive.ComputePipeline.nullify();
      }
    ;

    return zvk.primitive.ComputePipeline {
      .handle = pipeline,
      .primitiveAllocator = undefined,
    };
  }

  pub fn destroyComputePipeline(
    data : * c_void,
    pipeline : zvk.primitive.ComputePipeline,
  ) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    self.vkd.vkdd.destroyPipeline(
      self.vkd.device,
      pipeline.handle,
      null,
    );
  }

  pub fn createCommandPool(
    data : * c_void,
    info : vk.CommandPoolCreateInfo,
  ) zvk.primitive.CommandPool {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    const commandPool =
      self.vkd.vkdd.createCommandPool(self.vkd.device, info, null)
      catch |err| {
        log.crit("Could not create command pool: {}", .{err});
        return zvk.primitive.CommandPool.nullify();
      };
    return zvk.primitive.CommandPool {
      .handle = commandPool,
      .primitiveAllocator = undefined,
    };
  }

  pub fn destroyCommandPool(
    data : * c_void,
    commandPool : zvk.primitive.CommandPool,
  ) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    self.vkd.vkdd.destroyCommandPool(
      self.vkd.device,
      commandPool.handle,
      null,
    );
  }

  pub fn createCommandBuffers(
    data : * c_void,
    info : vk.CommandBufferAllocateInfo,
  ) zvk.primitive.CommandBuffers {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    var cmdBuf = zvk.primitive.CommandBuffers.nullify();
    cmdBuf.commandPool = info.commandPool;
    cmdBuf.handles = @TypeOf(cmdBuf.handles).init(self.allocator);

    cmdBuf.handles.resize(info.commandBufferCount)
      catch |err| {
        log.crit("Could not create command pool", .{});
        return zvk.primitive.CommandBuffers.nullify();
      };

    self.vkd.vkdd.allocateCommandBuffers(
      self.vkd.device, info, ztoadz.PtrCast(cmdBuf.handles.items)
    ) catch |err| {
        log.crit("Could not create command pool: {}", .{err});
        return zvk.primitive.CommandBuffers.nullify();
    };

    return cmdBuf;
  }

  pub fn destroyCommandBuffers(
    data : * c_void,
    cmdBuf : zvk.primitive.CommandBuffers,
  ) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));

    self.vkd.vkdd.freeCommandBuffers(
      self.vkd.device,
      cmdBuf.commandPool,
      @intCast(u32, cmdBuf.handles.items.len),
      ztoadz.PtrCast(cmdBuf.handles.items),
    );

    cmdBuf.handles.deinit();
  }

  pub fn labelObject(
    data : * c_void,
    info : vk.DebugUtilsObjectNameInfoEXT,
  ) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    self.vkd.vkdd.setDebugUtilsObjectNameEXT(self.vkd.device, info)
      catch |err| {
        log.warn("Could not label debug object: {}", .{info});
      }
    ;
  }

  pub fn deinit(data : * c_void) void {
    var self = @ptrCast(* AllocatorDedicated, @alignCast(8, data));
    for (self.gc.stagingBuffers.items) |s| s.deinit();
    self.gc.stagingBuffers.deinit();
    self.allocator.destroy(self);
  }


  // Returns specialized Allocator
  pub fn init(
    vkd : * ztoadz.VulkanDeviceContext,
    allocator : * std.mem.Allocator,
  ) !zvk.primitive.Allocator {
    var selfPtr = try allocator.create(@This());
    selfPtr.* = @This() {
      .vkd = vkd,
      .gc = zvk.primitive.GarbageCollection {
        .fence = undefined,
        .stagingBuffers = std.ArrayList(zvk.primitive.Buffer).init(allocator),
      },
      .allocator = allocator,
    };

    return zvk.primitive.Allocator {
      .data = @ptrCast(* c_void, selfPtr),
      .vkd = vkd,
      .fnCreateBuffer               = createBuffer,
      .fnDestroyBuffer              = destroyBuffer,
      .fnCreateFence                = createFence,
      .fnDestroyFence               = destroyFence,
      .fnCreateShaderModule         = createShaderModule,
      .fnDestroyShaderModule        = destroyShaderModule,
      .fnCreateDescriptorSetLayout  = createDescriptorSetLayout,
      .fnDestroyDescriptorSetLayout = destroyDescriptorSetLayout,
      .fnCreateDescriptorPool       = createDescriptorPool,
      .fnDestroyDescriptorPool      = destroyDescriptorPool,
      .fnCreateDescriptorSets       = createDescriptorSets,
      .fnDestroyDescriptorSets      = destroyDescriptorSets,
      .fnCreatePipelineLayout       = createPipelineLayout,
      .fnDestroyPipelineLayout      = destroyPipelineLayout,
      .fnCreateComputePipeline      = createComputePipeline,
      .fnDestroyComputePipeline     = destroyComputePipeline,
      .fnCreateCommandPool          = createCommandPool,
      .fnDestroyCommandPool         = destroyCommandPool,
      .fnCreateCommandBuffers       = createCommandBuffers,
      .fnDestroyCommandBuffers      = destroyCommandBuffers,
      .fnLabelObject                = labelObject,
      .fnDeinit                     = deinit,
    };
  }
};
