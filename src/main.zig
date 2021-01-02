const std = @import("std");
const assert = std.debug.assert;
const glfw = @import("glfw.zig");
const vk = @import("vulkan.zig");
const ztd = @import("ztoadz.zig");
const zvvk = @import("zvvk.zig");

const workgroupWidth = 16;
const workgroupHeight = 16;

const img = @import("img.zig");
pub fn main() !void {
  std.log.info("{}", .{"initializing zTOADz"});

  // {
  //   var imageData : [128*128*3] f32 = undefined;

  //   for (imageData) |_, it| {
  //     const x = (it/3) % 128; const y = (it/3) / 128;
  //     const p = it % 3;
  //     imageData[it] =
  //       switch (p) {
  //         0 => @intToFloat(f32, x) / 128.0,
  //         1 => @intToFloat(f32, y) / 128.0,
  //         2 => 0.5,
  //         else => 0.0,
  //       };
  //   }

  //   try img.WriteImage(imageData[0..], img.ImageType.rgb, "test.ppm", 128, 128);
  // }

  if (glfw.glfwInit() == 0) { return error.GlfwInitFailed; }
  defer glfw.glfwTerminate();

  // glfw.glfwWindowHint(glfw.GLFW_CLIENT_API, glfw.GLFW_NO_API);
  // glfw.glfwWindowHint(glfw.GLFW_RESIZABLE, glfw.GLFW_TRUE);

  const window =
    glfw.glfwCreateWindow(640, 480, "ztoadz", null, null)
    orelse return error.GlfwCreateWindowFailed
  ;
  defer glfw.glfwDestroyWindow(window);

  var debugAllocator =
    std.heap.GeneralPurposeAllocator(
      .{ .enable_memory_limit = true }
    ){};

  defer std.testing.expect(!debugAllocator.deinit());

  const requiredDeviceExtensions = [_][*:0] const u8 {
    vk.extension_info.khr_swapchain.name,
    vk.extension_info.khr_deferred_host_operations.name,
    vk.extension_info.khr_ray_tracing_pipeline.name,
    vk.extension_info.khr_acceleration_structure.name,
    vk.extension_info.khr_ray_query.name,
    vk.extension_info.khr_shader_non_semantic_info.name,
  };

  var validationFeatureEnable = [_] vk.ValidationFeatureEnableEXT {
    .debug_printf_ext,
    .best_practices_ext,
    .synchronization_validation_ext,
  };

  var validationFeatures = vk.ValidationFeaturesEXT {
    .enabledValidationFeatureCount = validationFeatureEnable.len,
    .pEnabledValidationFeatures = ztd.PtrConstCast(validationFeatureEnable),
    .disabledValidationFeatureCount = 0,
    .pDisabledValidationFeatures = undefined,
  };

  var vkApp =
    ztd.VulkanAppContext.init(
      &debugAllocator.allocator, requiredDeviceExtensions[0..],
      @ptrCast(* const c_void, &validationFeatures),
    )
    catch |err| {
      std.log.crit(
        "{}{}", .{"Could not initialize vulkan application context: ", err}
      );
      return;
    }
  ;
  defer vkApp.deinit();

  var vkd = &vkApp.devices.items[0];

  // create allocator
  var vkdAllocator =
    try zvvk.AllocatorDedicated.init(vkd, &debugAllocator.allocator)
  ;
  defer vkdAllocator.deinit();


  // create buffer
  var buffer : zvvk.AllocatorDedicated.Buffer = undefined;
  var bufferSize : vk.DeviceSize =
      640 * 480
    * 3 * @sizeOf(f32)
  ;

  {
    const queueFamilyIndices = [_] u32 {
      vkd.queueGTC.family
    };

    var bufferCreateInfo = vk.BufferCreateInfo {
      .flags = vk.BufferCreateFlags{},
      .size = bufferSize,
      .usage = vk.BufferUsageFlags {
        .storage_buffer_bit = true,
        .transfer_dst_bit = true,
      },
      .sharingMode = vk.SharingMode.exclusive,
      .queueFamilyIndexCount = queueFamilyIndices.len,
      .pQueueFamilyIndices = &queueFamilyIndices,
    };

    var memoryProperties = vk.MemoryPropertyFlags {
    };

    buffer =
      try vkdAllocator.CreateBuffer(
        bufferCreateInfo,
        vk.MemoryPropertyFlags {
          .host_visible_bit = true,
          .host_cached_bit = true,
          .host_coherent_bit = true,
        },
      );
  }

  defer vkdAllocator.DestroyBuffer(buffer);

  // -- create shader pipeline
  var raytraceModule : vk.ShaderModule = .null_handle;
  { // shader module
    // const file =
    //   try std.fs.cwd().openFile(
    //     "/home/toad/repo/dtoadq/ztoadz/shaders/raytrace.spv",
    //     // "~/repo/dtoadq/ztoadz/shaders/raytrace.spv",
    //     .{ .read = true },
    //   );
    // defer file.close();

    // const fileContents =
    //   try file.reader().readAllAlloc(&debugAllocator.allocator, 1024*1024*20);
    // defer debugAllocator.allocator.free(fileContents);
    const fileContents align(@alignOf(u32)) =
      @embedFile("../shaders/raytrace.spv").*;

    var shaderModuleCreateInfo = vk.ShaderModuleCreateInfo {
      .codeSize = fileContents.len,
      .pCode = std.mem.bytesAsSlice(u32, &fileContents).ptr,
      .flags = .{},
    };

    raytraceModule =
      try vkd.vkdd.createShaderModule(
        vkd.device, shaderModuleCreateInfo, null
      );
  }
  defer vkd.vkdd.destroyShaderModule(vkd.device, raytraceModule, null);

  // -- descriptor set
  const layoutBindings = [_] vk.DescriptorSetLayoutBinding {
    vk.DescriptorSetLayoutBinding {
      .binding = 0,
      .descriptorType = vk.DescriptorType.storage_buffer,
      .descriptorCount = 1,
      .stageFlags = vk.ShaderStageFlags { .compute_bit = true },
      .pImmutableSamplers = null,
    },
  };

  var raytraceDescriptorSetLayout : vk.DescriptorSetLayout = .null_handle;
  {
    const bindingFlagInfo = vk.DescriptorSetLayoutBindingFlagsCreateInfo {
      .bindingCount = @intCast(u32, 0),
      .pBindingFlags = undefined,
    };

    const layoutInfo = vk.DescriptorSetLayoutCreateInfo {
      .pNext = &bindingFlagInfo,
      .bindingCount = 1,
      .pBindings = ztd.PtrConstCast(layoutBindings),
      .flags = vk.DescriptorSetLayoutCreateFlags { },
    };

    raytraceDescriptorSetLayout =
      try vkd.vkdd.createDescriptorSetLayout(
        vkd.device,
        layoutInfo,
        null
      );
  }
  defer vkd.vkdd.destroyDescriptorSetLayout(
    vkd.device, raytraceDescriptorSetLayout, null
  );

  var raytraceDescriptorPool : vk.DescriptorPool = .null_handle;
  {
    var poolSizes =
      std.ArrayList(vk.DescriptorPoolSize).init(&debugAllocator.allocator);
    defer poolSizes.deinit();

    const maxSets : u32 = 1;

    // -- add pool sizes
    for (layoutBindings) |binding| {
      var found : bool = false;

      for (poolSizes.items) |pool, it| {
        if (pool.type == binding.descriptorType) {
          poolSizes.items[it].descriptorCount +=
            binding.descriptorCount * maxSets;
          found = true;
          break;
        }
      }

      if (!found) {
        const poolSize = vk.DescriptorPoolSize {
          .type = binding.descriptorType,
          .descriptorCount = binding.descriptorCount * maxSets,
        };

        (try poolSizes.addOne()).* = poolSize;
      }
    }

    // -- create pool
    const descriptorPool = vk.DescriptorPoolCreateInfo {
      .maxSets = maxSets,
      .poolSizeCount = @intCast(u32, poolSizes.items.len),
      .pPoolSizes = @ptrCast([*] const vk.DescriptorPoolSize, poolSizes.items),
      .flags = vk.DescriptorPoolCreateFlags { .free_descriptor_set_bit = true },
    };

    raytraceDescriptorPool =
       try vkd.vkdd.createDescriptorPool(vkd.device, descriptorPool, null);
  }

  defer
    vkd.vkdd.destroyDescriptorPool(vkd.device, raytraceDescriptorPool, null)
  ;

  // allocate descriptor sets
  var descriptorSets =
    std.ArrayList(vk.DescriptorSet).init(&debugAllocator.allocator);
  defer {
    vkd.vkdd.freeDescriptorSets(
      vkd.device,
      raytraceDescriptorPool,
      @intCast(u32, descriptorSets.items.len),
      ztd.PtrCast(descriptorSets.items),
    )
      catch |err| {}
    ;
    descriptorSets.deinit();
  }

  {
    try descriptorSets.resize(1);


    var descriptorSetLayouts =
      std.ArrayList(vk.DescriptorSetLayout).init(&debugAllocator.allocator);
    defer descriptorSetLayouts.deinit();

    try descriptorSetLayouts.resize(1);
    for (descriptorSetLayouts.items) |_, it| {
      descriptorSetLayouts.items[it] = raytraceDescriptorSetLayout;
    }

    var descriptorSetAllocate = vk.DescriptorSetAllocateInfo {
      .descriptorPool = raytraceDescriptorPool,
      .descriptorSetCount = 1,
      .pSetLayouts = ztd.PtrCast(descriptorSetLayouts.items),
    };

    try vkd.vkdd.allocateDescriptorSets(
      vkd.device, descriptorSetAllocate, ztd.PtrCast(descriptorSets.items)
    );
  }

  // write descriptor
  var descriptorBufferInfo = [_] vk.DescriptorBufferInfo {
    .{
      .buffer = buffer.buffer,
      .offset = 0,
      .range = bufferSize,
    },
  };

  var writeDescriptor = [_] vk.WriteDescriptorSet {
    .{
      .dstSet = descriptorSets.items[0],
      .dstBinding = 0,
      .dstArrayElement = 0,
      .descriptorType = vk.DescriptorType.storage_buffer,
      .descriptorCount = 1,
      .pImageInfo = undefined,
      .pBufferInfo = ztd.PtrConstCast(descriptorBufferInfo),
      .pTexelBufferView = undefined,
    },
  };

  vkd.vkdd.updateDescriptorSets(
    vkd.device,
    1, ztd.PtrConstCast(writeDescriptor),
    0, undefined,
  );

  var pipelineLayout : vk.PipelineLayout = .null_handle;
  {
    var info = vk.PipelineLayoutCreateInfo {
      .setLayoutCount = 1,
      .pSetLayouts =
        @ptrCast(
          [*] const vk.DescriptorSetLayout, &raytraceDescriptorSetLayout
        ),
      .pushConstantRangeCount = 0,
      .pPushConstantRanges = undefined,
      .flags = .{},
    };

    pipelineLayout = try vkd.vkdd.createPipelineLayout(vkd.device, info, null);
  }
  defer vkd.vkdd.destroyPipelineLayout(vkd.device, pipelineLayout, null);

  var raytracePipeline : vk.Pipeline = .null_handle;
  {
    var computePipelineCreateInfo = vk.ComputePipelineCreateInfo {
      .flags = .{},
      .stage = .{
        .stage = .{ .compute_bit = true },
        .pSpecializationInfo = null,
        .module = raytraceModule,
        .pName = "main",
        .flags = .{},
      },
      .layout = pipelineLayout,
      .basePipelineHandle = .null_handle,
      .basePipelineIndex = 0,
    };

    _ = try vkd.vkdd.createComputePipelines(
      vkd.device,
      .null_handle, // pipeline cache
      1,
      @ptrCast(
        [*] const vk.ComputePipelineCreateInfo, &computePipelineCreateInfo
      ),
      null,
      @ptrCast([*] vk.Pipeline, &raytracePipeline),
    );
  }
  defer vkd.vkdd.destroyPipeline(vkd.device, raytracePipeline, null);

  // -- create command pool & buffer

  var commandPool =
    try ztd.VulkanCommandPool.init(
      vkd,
      vk.CommandPoolCreateInfo {
        .pNext = null,
        .flags = vk.CommandPoolCreateFlags.fromInt(0),
        .queueFamilyIndex = vkd.queueGTC.family,
      },
    );
  defer commandPool.deinit();

  var commandBuffers =
    try ztd.VulkanCommandBuffer.init(
      &debugAllocator.allocator,
      vkd,
      vk.CommandBufferAllocateInfo {
        .pNext = null,
        .commandPool = commandPool.pool,
        .level = vk.CommandBufferLevel.primary,
        .commandBufferCount = 1,
      },
    );
  defer commandBuffers.deinit();

  // record
  var beginInfo = vk.CommandBufferBeginInfo {
    .flags = vk.CommandBufferUsageFlags { .one_time_submit_bit = true },
    .pInheritanceInfo = null,
  };

  try vkd.vkdd.beginCommandBuffer(commandBuffers.buffers.items[0], beginInfo);

  vkd.vkdd.cmdBindPipeline(
    commandBuffers.buffers.items[0],
    vk.PipelineBindPoint.compute, raytracePipeline,
  );

  vkd.vkdd.cmdBindDescriptorSets(
    commandBuffers.buffers.items[0],
    vk.PipelineBindPoint.compute,
    pipelineLayout,
    0, // first set
    1, ztd.PtrConstCast(descriptorSets.items),
    0, undefined
  );

  vkd.vkdd.cmdDispatch(
    commandBuffers.buffers.items[0],
    (640 + 32 - 1) / 16,
    (480 + 32 - 1) / 8,
    1
  );

  // var fillValue : f32 = 0.275;

  // vkd.vkdd.cmdFillBuffer(
  //   commandBuffers.buffers.items[0],
  //   buffer.buffer,
  //   0, buffer.size,
  //   // 45
  //   @ptrCast(* u32, &fillValue).*
  // );

  // barrier
  var memoryBarrier = vk.MemoryBarrier {
    .srcAccessMask = vk.AccessFlags { .shader_write_bit = true },
    .dstAccessMask = vk.AccessFlags { .host_read_bit  = true },
  };

  vkd.vkdd.cmdPipelineBarrier(
    commandBuffers.buffers.items[0],
    vk.PipelineStageFlags { .compute_shader_bit = true }, // src
    vk.PipelineStageFlags { .host_bit    = true }, // dst
    vk.DependencyFlags { },
    1, @ptrCast([*] const vk.MemoryBarrier, &memoryBarrier),
    0, undefined, 0, undefined
  );

  try vkd.vkdd.endCommandBuffer(commandBuffers.buffers.items[0]);

  var submitInfo = vk.SubmitInfo {
    .waitSemaphoreCount = 0,
    .pWaitSemaphores = undefined,
    .pWaitDstStageMask = undefined,
    .commandBufferCount = 1,
    .pCommandBuffers =
      @ptrCast([*]const vk.CommandBuffer, &commandBuffers.buffers.items[0]),
    .signalSemaphoreCount = 0,
    .pSignalSemaphores = undefined,
  };

  try vkd.vkdd.queueSubmit(
    vkd.queueGTC.handle,
    1, @ptrCast([*] const vk.SubmitInfo, &submitInfo),
    .null_handle,
  );

  try vkd.vkdd.queueWaitIdle(vkd.queueGTC.handle);

  // read back undefined memory
  const data =
    try vkd.vkdd.mapMemory(
      vkd.device, buffer.allocation, 0, vk.WHOLE_SIZE, vk.MemoryMapFlags{}
    );

  std.log.info("{}", .{"Saving file"});
  const fdata = @ptrCast([*] const f32, @alignCast(4, data));
  try img.WriteImage(fdata[0..640*480*3], img.ImageType.rgb, "test.ppm", 640, 480);
  vkd.vkdd.unmapMemory(vkd.device, buffer.allocation);

  // vk.RenderPass renderpass =
  //   vkDevice.vkdd.createRenderPass2(
  //     vkDevice.device
  //   , vk.RenderPassCreateInfo2 {
  //       .pNext = null
  //     , .flags = vk.RenderPassCreateFlags.fromInt(0)
  //     , .attachmentCount = 1
  //     , .pAttachments = ..
  //     , .subpassCount = 1
  //     }
  //   );

  // while (glfw.glfwWindowShouldClose(window) == 0) {
    // glfw.glfwPollEvents();
  // }

  std.log.info("{}", .{"Exitting ztoadz!"});
}
