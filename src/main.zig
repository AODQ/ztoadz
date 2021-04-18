
const glfw    = @import("third-party/glfw.zig");
const img     = @import("io/img.zig");
const log     = @import("log.zig");
const modelio = @import("modelio/package.zig");
const util    = @import("util/package.zig");
const vk      = @import("third-party/vulkan.zig");
const ztd     = @import("util/ztoadz.zig");
const zvk     = @import("zvk/package.zig");
const zvvk    = @import("util/zvvk.zig");

const std    = @import("std");
const assert = std.debug.assert;

const workgroupWidth = 16;
const workgroupHeight = 8;



// fn CreateB

pub fn main() !void {
  log.info("{}", .{"initializing zTOADz"});

  // -- setup allocators

  var debugAllocator =
    std.heap.GeneralPurposeAllocator(
      .{
        .enable_memory_limit = true,
        .safety = true,
      }
    ){};

  util.StringArena.arenaAllocator =
    std.heap.ArenaAllocator.init(&debugAllocator.allocator)
  ;

  // -- initialize glfw / vulkan context


  if (glfw.glfwInit() == 0) { return error.GlfwInitFailed; }
  defer glfw.glfwTerminate();

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
      log.crit(
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

  var vkAllocator =
    try zvk.primitive.AllocatorDedicated.init(vkd, &debugAllocator.allocator);
  defer vkAllocator.deinit();

  // create buffer
  var buffer = zvk.primitive.Buffer.nullify();
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
      try zvk.primitive.Buffer.init(
        vkAllocator,
        bufferCreateInfo,
        vk.MemoryPropertyFlags {
          .host_visible_bit = true,
          .host_cached_bit = true,
          .host_coherent_bit = true,
        },
        zvk.primitive.ObjectCreateInfo {
          .label = "WriteImage",
        },
      );
  }
  defer buffer.deinit();

  // -- create shader pipeline
  var raytraceModule = zvk.primitive.ShaderModule.nullify();
  defer raytraceModule.deinit();
  { // shader module
    const fileContents align(@alignOf(u32)) =
      @embedFile("../shaders/raytrace.spv").*;

    var shaderModuleCreateInfo = vk.ShaderModuleCreateInfo {
      .codeSize = fileContents.len,
      .pCode = std.mem.bytesAsSlice(u32, &fileContents).ptr,
      .flags = .{},
    };

    raytraceModule =
      try zvk.primitive.ShaderModule.init(
        vkAllocator,
        shaderModuleCreateInfo,
        zvk.primitive.ObjectCreateInfo {
          .label = "RaytraceModule",
        },
      );
  }

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

  var raytraceDescriptorSetLayout = zvk.primitive.DescriptorSetLayout.nullify();
  defer raytraceDescriptorSetLayout.deinit();
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
      try zvk.primitive.DescriptorSetLayout.init(
        vkAllocator,
        layoutInfo,
        zvk.primitive.ObjectCreateInfo {
          .label = "RaytraceDescriptorSetLayout"
        },
      );
  }

  var raytraceDescriptorPool = zvk.primitive.DescriptorPool.nullify();
  defer raytraceDescriptorPool.deinit();
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
    const descriptorPoolInfo = vk.DescriptorPoolCreateInfo {
      .maxSets = maxSets,
      .poolSizeCount = @intCast(u32, poolSizes.items.len),
      .pPoolSizes = @ptrCast([*] const vk.DescriptorPoolSize, poolSizes.items),
      .flags = vk.DescriptorPoolCreateFlags { .free_descriptor_set_bit = true },
    };

    raytraceDescriptorPool =
      try zvk.primitive.DescriptorPool.init(
        vkAllocator,
        descriptorPoolInfo,
        zvk.primitive.ObjectCreateInfo {
          .label = "RaytraceDescriptorPool",
        },
      );
  }

  // allocate descriptor sets
  var descriptorSets = zvk.primitive.DescriptorSets.nullify();
  defer descriptorSets.deinit();

  {
    var descriptorSetLayouts =
      std.ArrayList(vk.DescriptorSetLayout).init(&debugAllocator.allocator);
    defer descriptorSetLayouts.deinit();

    try descriptorSetLayouts.resize(1);
    for (descriptorSetLayouts.items) |_, it| {
      descriptorSetLayouts.items[it] = raytraceDescriptorSetLayout.handle;
    }

    var descriptorSetAllocate = vk.DescriptorSetAllocateInfo {
      .descriptorPool = raytraceDescriptorPool.handle,
      .descriptorSetCount = @intCast(u32, descriptorSetLayouts.items.len),
      .pSetLayouts = ztd.PtrCast(descriptorSetLayouts.items),
    };

    descriptorSets =
      try zvk.primitive.DescriptorSets.init(
        vkAllocator,
        descriptorSetAllocate,
        zvk.primitive.ObjectCreateInfo {
          .label = "RaytraceDescriptorSet",
        },
      );
  }

  // write descriptor
  var descriptorBufferInfo = [_] vk.DescriptorBufferInfo {
    .{
      .buffer = buffer.handle,
      .offset = 0,
      .range = bufferSize,
    },
  };

  var writeDescriptor = [_] vk.WriteDescriptorSet {
    .{
      .dstSet = descriptorSets.handles.items[0],
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

  var pipelineLayout = zvk.primitive.PipelineLayout.nullify();
  defer pipelineLayout.deinit();
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

    pipelineLayout =
      try zvk.primitive.PipelineLayout.init(
        vkAllocator,
        info,
        zvk.primitive.ObjectCreateInfo {
          .label = "RaytracePipelineLayout",
        },
      );
  }

  var raytracePipeline =
    try zvk.primitive.ComputePipeline.init(
      vkAllocator,
      vk.ComputePipelineCreateInfo {
        .flags = .{},
        .stage = .{
          .stage = .{ .compute_bit = true },
          .pSpecializationInfo = null,
          .module = raytraceModule.handle,
          .pName = "main",
          .flags = .{},
        },
        .layout = pipelineLayout.handle,
        .basePipelineHandle = .null_handle,
        .basePipelineIndex = 0,
      },
      zvk.primitive.ObjectCreateInfo {
        .label = "RaytraceComputePipeline",
      },
    );
  defer raytracePipeline.deinit();

  // -- create command pool & buffer
  var commandPool =
    try zvk.primitive.CommandPool.init(
      vkAllocator,
      vk.CommandPoolCreateInfo {
        .pNext = null,
        .flags = vk.CommandPoolCreateFlags.fromInt(0),
        .queueFamilyIndex = vkd.queueGTC.family,
      },
      zvk.primitive.ObjectCreateInfo {
        .label = "RaytraceCommandPool",
      },
    );
  defer commandPool.deinit();

  var commandBuffers =
    try zvk.primitive.CommandBuffers.init(
      vkAllocator,
      vk.CommandBufferAllocateInfo {
        .pNext = null,
        .commandPool = commandPool.handle,
        .level = vk.CommandBufferLevel.primary,
        .commandBufferCount = 1,
      },
      zvk.primitive.ObjectCreateInfo {
        .label = "RaytraceCommandBuffer",
      },
    );
  defer commandBuffers.deinit();

  // load scene
  var scene : modelio.Scene = undefined;
  defer scene.deinit();
  {
    var descriptorLayout = modelio.CreateInfo_VertexDescriptorLayout.init();

    descriptorLayout
      .vertexAttributes[
        @enumToInt(modelio.VertexDescriptorAttributeType.origin)
      ]
      .bindingIndex = 0
    ;

    descriptorLayout
      .vertexAttributes[
        @enumToInt(modelio.VertexDescriptorAttributeType.origin)
      ]
      .underlyingType = modelio.VertexDescriptorUnderlyingType.float32_3
    ;

    scene =
      try modelio.LoadScene(
        &debugAllocator.allocator, "resources/bunny.obj", descriptorLayout
      );
  }

  var bufferVertexOrigin = zvk.primitive.Buffer.nullify();
  var bufferIndex = zvk.primitive.Buffer.nullify();
  defer bufferVertexOrigin.deinit();
  defer bufferIndex.deinit();
  { // -- load model buffers

    var submesh = scene.meshes.items[0].submeshes.items[0];

    var attributeOrigin =
      submesh
        .vertexDescriptorLayout
        .vertexAttributes[
          @enumToInt(modelio.VertexDescriptorAttributeType.origin)
        ];

    const queueFamilyIndices = [_] u32 {
      vkd.queueGTC.family
    };

    bufferVertexOrigin =
      try zvk.primitive.Buffer.initWithInitialDataWithOneTimeCommandBuffer(
        vkAllocator,
        commandPool.handle,
        vk.BufferCreateInfo {
          .flags = vk.BufferCreateFlags {},
          .size = attributeOrigin.bufferSubregion.length,
          .usage = vk.BufferUsageFlags {
            .shader_device_address_bit                            = true,
            .storage_buffer_bit                                   = true,
            .acceleration_structure_build_input_read_only_bit_khr = true
          },
          .sharingMode = vk.SharingMode.exclusive,
          .queueFamilyIndexCount = queueFamilyIndices.len,
          .pQueueFamilyIndices = &queueFamilyIndices,
        },
        vk.MemoryPropertyFlags {},
        scene.buffers.items[1].memory.items,
        zvk.primitive.ObjectCreateInfo { .label = "VertexOrigin", },
      );

    bufferIndex =
      try zvk.primitive.Buffer.initWithInitialDataWithOneTimeCommandBuffer(
        vkAllocator,
        commandPool.handle,
        vk.BufferCreateInfo {
          .flags = vk.BufferCreateFlags {},
          .size = submesh.elementBufferSubregion.length,
          .usage = vk.BufferUsageFlags {
            .shader_device_address_bit                            = true,
            .storage_buffer_bit                                   = true,
            .acceleration_structure_build_input_read_only_bit_khr = true
          },
          .sharingMode = vk.SharingMode.exclusive,
          .queueFamilyIndexCount = queueFamilyIndices.len,
          .pQueueFamilyIndices = &queueFamilyIndices,
        },
        vk.MemoryPropertyFlags {},
        scene.buffers.items[0].memory.items,
        zvk.primitive.ObjectCreateInfo { .label = "IndexOrigin", },
      );
  }

  // -- being render


  // record
  var beginInfo = vk.CommandBufferBeginInfo {
    .flags = vk.CommandBufferUsageFlags { .one_time_submit_bit = true },
    .pInheritanceInfo = null,
  };

  try vkd.vkdd.beginCommandBuffer(commandBuffers.handles.items[0], beginInfo);

  vkd.vkdd.cmdBindPipeline(
    commandBuffers.handles.items[0],
    vk.PipelineBindPoint.compute, raytracePipeline.handle,
  );

  vkd.vkdd.cmdBindDescriptorSets(
    commandBuffers.handles.items[0],
    vk.PipelineBindPoint.compute,
    pipelineLayout.handle,
    0, // first set
    1, ztd.PtrConstCast(descriptorSets.handles.items),
    0, undefined
  );

  vkd.vkdd.cmdDispatch(
    commandBuffers.handles.items[0],
    (640 + workgroupWidth  - 1) / workgroupWidth,
    (480 + workgroupHeight - 1) / workgroupHeight,
    1
  );

  // barrier
  var memoryBarrier = vk.MemoryBarrier {
    .srcAccessMask = vk.AccessFlags { .shader_write_bit = true },
    .dstAccessMask = vk.AccessFlags { .host_read_bit  = true },
  };

  vkd.vkdd.cmdPipelineBarrier(
    commandBuffers.handles.items[0],
    vk.PipelineStageFlags { .compute_shader_bit = true }, // src
    vk.PipelineStageFlags { .host_bit    = true }, // dst
    vk.DependencyFlags { },
    1, @ptrCast([*] const vk.MemoryBarrier, &memoryBarrier),
    0, undefined, 0, undefined
  );

  try vkd.vkdd.endCommandBuffer(commandBuffers.handles.items[0]);

  var submitInfo = vk.SubmitInfo {
    .waitSemaphoreCount = 0,
    .pWaitSemaphores = undefined,
    .pWaitDstStageMask = undefined,
    .commandBufferCount = 1,
    .pCommandBuffers =
      @ptrCast([*]const vk.CommandBuffer, &commandBuffers.handles.items[0]),
    .signalSemaphoreCount = 0,
    .pSignalSemaphores = undefined,
  };

  try vkd.vkdd.queueSubmit(
    vkd.queueGTC.handle,
    1, @ptrCast([*] const vk.SubmitInfo, &submitInfo),
    .null_handle,
  );

  try vkd.vkdd.queueWaitIdle(vkd.queueGTC.handle);

  // read back memory
  const data =
    try vkd.vkdd.mapMemory(
      vkd.device, buffer.allocation, 0, vk.WHOLE_SIZE, vk.MemoryMapFlags{}
    );

  std.log.info("{}", .{"Saving file"});
  const fdata = @ptrCast([*] const f32, @alignCast(4, data));
  try img.WriteImage(fdata[0..640*480*3], img.ImageType.rgb, "test.ppm", 640, 480);
  vkd.vkdd.unmapMemory(vkd.device, buffer.allocation);

  util.StringArena.freeArena();

  log.info("{}", .{"Exitting ztoadz safely"});
}
