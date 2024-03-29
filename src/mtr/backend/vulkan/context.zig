const mtr = @import("../../package.zig");
const std = @import("std");

const glfw = @import("glfw.zig");
const util = @import("util.zig");
const vkDispatcher = @import("vulkan-dispatchers.zig");
const vk = @import("../../../bindings/vulkan.zig");

fn zeroInitInPlace(ptr : anytype) void {
  ptr.* = std.mem.zeroInit(std.meta.Child(@TypeOf(ptr)), .{});
}

// creates a stack of features, returns the head of the stack
// the head needs to be freed with `freeVkFeatureList`
pub fn enableVkFeatureList(
  features : anytype,
) !?*anyopaque {
  var currentPNext : ?* anyopaque = null;
  switch (@typeInfo(@TypeOf(features))) {
    .Struct => |structType| {
      inline for (structType.fields) |field| {
        var newMember : *@TypeOf(@field(features, field.name)) = (
          @ptrCast(
            *@TypeOf(@field(features, field.name)),
            @alignCast(
              @alignOf(@TypeOf(@field(features, field.name))),
              std.c.malloc(@sizeOf(@TypeOf(@field(features, field.name))))
            ).?
          )
        );
        newMember.* = @field(features, field.name);
        newMember.pNext = currentPNext;
        currentPNext = newMember;
      }
    },
    else => @compileError("unknown"),
  }
  return currentPNext;
}

pub fn freeVkFeatureList(
  featureListHead : ?* anyopaque,
) void {
  var currentPNext : ?* anyopaque = featureListHead;
  while (currentPNext != null) {
    // just assume it's something (doesn't matter) and grab pNext
    var nextPNext = (
      @ptrCast(*vk.PhysicalDeviceFeatures2, @alignCast(8, currentPNext)).pNext
    );
    std.c.free(currentPNext);
    currentPNext = nextPNext;
  }
}

pub fn toImageType(image : mtr.image.Primitive) vk.ImageType {
  if (image.depth > 1)
    return vk.ImageType.@"3D";
  if (image.height > 1)
    return vk.ImageType.@"2D";
  return vk.ImageType.@"1D";
}

pub fn imageToVkFormat(image : mtr.image.Primitive) vk.Format {
  return switch (image.byteFormat) {
    .uint8 => switch (image.channels) {
      .R => vk.Format.r8Uint,
      .RGB => vk.Format.r8g8b8Uint,
      .BGR => vk.Format.b8g8r8Uint,
      .RGBA => vk.Format.r8g8b8a8Uint,
    },
    .uint8Unorm => switch (image.channels) {
      .R => vk.Format.r8Unorm,
      .RGB => vk.Format.r8g8b8Unorm,
      .BGR => vk.Format.b8g8r8Unorm,
      .RGBA => vk.Format.r8g8b8a8Unorm,
    },
    .uint64 => switch (image.channels) {
      .R => vk.Format.r64Uint,
      .RGB => vk.Format.r64g64b64Uint,
      .BGR => unreachable,
      .RGBA => vk.Format.r64g64b64a64Uint,
    },
  };
}

pub fn toSampleCountFlags(image : mtr.image.Primitive) vk.SampleCountFlags {
  return switch (image.samplesPerTexel) {
    .s1 => vk.SampleCountFlags { .@"1bit" = true },
  };
}

pub fn toSharingMode(image : mtr.image.Primitive) vk.SharingMode {
  return switch (image.queueSharing) {
    .exclusive => vk.SharingMode.exclusive,
    .concurrent => vk.SharingMode.concurrent,
  };
}

fn descriptorTypeToVk(descriptorType : mtr.descriptor.Type) vk.DescriptorType {
  return switch (descriptorType) {
    .uniformBuffer => .uniformBuffer,
    .storageBuffer => .storageBuffer,
    .sampler => .sampler,
    .sampledImage => .sampledImage,
    .storageImage => .storageImage,
  };
}

fn viewTypeToVk(viewType : mtr.image.ViewType) vk.ImageViewType {
  return switch (viewType) {
    .d1      => .@"1D",      .d2        => .@"2D", .d3 => .@"3D",
    .d1Array => .@"1DArray", .d2Array   => .@"2DArray",
    .cube    => .cube,       .cubeArray => .cubeArray,
  };
}

fn imageLayoutToVk(layout : mtr.image.Layout) vk.ImageLayout {
  return switch (layout) {
    .uninitialized => .@"undefined",
    .general => .general,
    .transferSrc => .transferSrcOptimal,
    .transferDst => .transferDstOptimal,
    .present => .presentSrcKHR,
  };
}

fn accessFlagsToVk(flags : mtr.memory.AccessFlags) vk.AccessFlags {
  return vk.AccessFlags {
    .shaderReadBit = flags.shaderRead,
    .shaderWriteBit = flags.shaderWrite,
    .uniformReadBit = flags.uniformRead,
    .colorAttachmentReadBit = flags.colorAttachmentRead,
    .colorAttachmentWriteBit = flags.colorAttachmentWrite,
    .transferReadBit = flags.transferDst,
    .transferWriteBit = flags.transferSrc,
    .hostReadBit = flags.hostRead,
    .hostWriteBit = flags.hostWrite,
    .indirectCommandReadBit = flags.indirectCommand,
  };
}

fn stageFlagToVk(flags : mtr.pipeline.StageFlags) vk.PipelineStageFlags {
  return vk.PipelineStageFlags {
    .topOfPipeBit = flags.begin,
    .bottomOfPipeBit = flags.end,
    .computeShaderBit = flags.compute,
    .transferBit = flags.transfer,
    .hostBit = flags.host,
    .drawIndirectBit = flags.indirectDispatch,
  };
}

const VulkanDeviceQueues = struct {
  computeIdx : u32 = 0,
  graphicsIdx : u32 = 0,
  presentIdx : u32 = 0,
  transferIdx : u32 = 0,
  gtcIdx : u32 = 0,
};

const VulkanDeviceQueue = struct {
  handle : vk.Queue,
  familyIndex : u32,

  fn init(vkd : VulkanDeviceContext, familyIndex : u32) @This() {
    return .{
      .handle = vkd.vkdd.getDeviceQueue(vkd.device, familyIndex, 0),
      .familyIndex = familyIndex,
    };
  }
};

/// cast any slice/list/array into C ptr for Vulkan consumption
fn ptrCast(items : anytype) [*] @TypeOf(items[0]) {
  return @ptrCast([*] @TypeOf(items[0]), &items[0]);
}

/// cast any slice/list/array into C ptr for Vulkan consumption
fn ptrConstCast(items : anytype) [*] const @TypeOf(items[0]) {
  return @ptrCast([*] const @TypeOf(items[0]), &items[0]);
}

fn heapVisibilityToVkMemory(
  visibility : mtr.heap.Visibility
) vk.MemoryPropertyFlags {
  return switch(visibility) {
    .deviceOnly => .{ .deviceLocalBit = true },
    .hostVisible => .{ .hostVisibleBit = true },
    .hostWritable => .{ .hostCachedBit = true },
  };
}

//fn heapVisibilityToVkMapping(visibility : mtr.heap.Visibility) u32 {
//  return switch(visibility) {
//    .deviceOnly => unreachable,
//    .hostVisible => c.CL_MAP_READ,
//    .hostWritable => c.CL_MAP_WRITE_INVALIDATE_REGION
//  };
//}

//fn assertVkBuild(
//  allocator : * std.mem.Allocator,
//  program : c.cl_program, device : c.cl_device_id, value : c.cl_int
//) void {
//  if (value == 0) {
//    return;
//  }
//
//  // these can't throw exceptions, because any potential errors generated from
//  //   the OpenCL backend should be caught/handled by the MTR backend
//
//  const errorCode = convertOpenCLError(value);
//
//  std.log.err("{s}{}", .{"Internal OpenCL error:", errorCode});
//
//  if (errorCode == OpenCLError.buildProgramFailure) {
//    var length : usize = 0;
//    assertCl(
//      c.clGetProgramBuildInfo(
//        program, device,
//        c.CL_PROGRAM_BUILD_LOG,
//        0, null, &length
//      )
//    );
//    var buildLog : [] u8 = allocator.alloc(u8, length) catch unreachable;
//    std.log.err("err len: {}", .{length});
//    assertCl(
//      c.clGetProgramBuildInfo(
//        program, device,
//        c.CL_PROGRAM_BUILD_LOG,
//        length, @ptrCast(* anyopaque, &buildLog[0]), null,
//      )
//    );
//    std.log.info("{s}", .{buildLog});
//  }
//
//  unreachable;
//}

fn bufferUsageToVk(usage : mtr.buffer.Usage) vk.BufferUsageFlags {
  return .{
    .transferSrcBit = usage.transferSrc,
    .transferDstBit = usage.transferDst,
    .uniformTexelBufferBit = false,
    .storageTexelBufferBit = false,
    .uniformBufferBit = usage.bufferUniform,
    .storageBufferBit = usage.bufferStorage,
    .indirectBufferBit = usage.bufferIndirect,
  };
}

fn queueSharingUsageToVk(usage : mtr.queue.SharingUsage) vk.SharingMode {
  return switch(usage) {
    .exclusive => vk.SharingMode.exclusive,
    .concurrent => vk.SharingMode.concurrent,
  };
}

const CommandBuffer = struct {
  buffers : std.ArrayList(vk.CommandBuffer),
  commandPool : mtr.command.PoolIdx, // this is necessary for dealloc

  pub fn init(
    commandPool : mtr.command.PoolIdx,
    alloc : std.mem.Allocator,
  ) @This() {
    return @This() {
      .buffers = std.ArrayList(vk.CommandBuffer).init(alloc),
      .commandPool = commandPool,
    };
  }

  pub fn deinit(self : * @This()) void {
    self.buffers.deinit();
  }
};

const Image = struct {
  handle : vk.Image,
  partOfSwapchain : bool,
};

/// graphics context for a device backing the current application
pub const VulkanDeviceContext = struct {

  physicalDevice : vk.PhysicalDevice,
  device : vk.Device,
  vkdd : vkDispatcher.VulkanDeviceDispatch,
  physicalDeviceProperties : vk.PhysicalDeviceProperties,
  physicalDeviceProperties11 : vk.PhysicalDeviceVulkan11Properties,
  physicalDeviceProperties12 : vk.PhysicalDeviceVulkan12Properties,
  physicalDevicePropertiesMeshShader : vk.PhysicalDeviceMeshShaderPropertiesNV,
  physicalDeviceMemoryProperties : vk.PhysicalDeviceMemoryProperties,
  physicalDeviceMemoryBudgetProperties : (
    vk.PhysicalDeviceMemoryBudgetPropertiesEXT
  ),
  queueFamilyProperties : std.ArrayList(vk.QueueFamilyProperties),

  deviceQueue : VulkanDeviceQueues,

  pub fn init(
    allocator : std.mem.Allocator
  , vki : vkDispatcher.VulkanInstanceDispatch
  , physicalDevice : vk.PhysicalDevice
  , deviceExtensions : [] const [*:0] const u8
  ) !@This() {
    var self : @This() = undefined;
    self.physicalDevice = physicalDevice;

    // get physical device properties
    self.physicalDeviceProperties = (
      vki.getPhysicalDeviceProperties(self.physicalDevice)
    );

    // get physical device properties
    var physicalDeviceProperties2 = vk.PhysicalDeviceProperties2 {
      .pNext = &self.physicalDeviceProperties11,
      .properties = undefined,
    };

    zeroInitInPlace(&self.physicalDeviceProperties11);
    zeroInitInPlace(&self.physicalDeviceProperties12);
    zeroInitInPlace(&self.physicalDevicePropertiesMeshShader);
    // TODO this didn't work, have to manually set sType
    self.physicalDeviceProperties11.sType = (
      vk.StructureType.physicalDeviceVulkan11Properties
    );
    self.physicalDeviceProperties12.sType = (
      vk.StructureType.physicalDeviceVulkan12Properties
    );
    self.physicalDevicePropertiesMeshShader.sType = (
      vk.StructureType.physicalDeviceMeshShaderPropertiesNV
    );

    self.physicalDeviceProperties11.pNext = &self.physicalDeviceProperties12;
    self.physicalDeviceProperties12.pNext = (
      &self.physicalDevicePropertiesMeshShader
    );
    self.physicalDevicePropertiesMeshShader.pNext = null;

    vki.getPhysicalDeviceProperties2(
      self.physicalDevice, &physicalDeviceProperties2
    );

    self.physicalDeviceProperties = physicalDeviceProperties2.properties;

    // log physical device properties
    // vk_logger.PhysicalDevice(self.physicalDeviceProperties);
    // vk_logger.PhysicalDevice11(self.physicalDeviceProperties11);
    // vk_logger.PhysicalDevice12(self.physicalDeviceProperties12);
    // vk_logger.PhysicalDeviceMeshShader(
      // self.physicalDevicePropertiesMeshShader);

    { // get device memory properties
      var physicalDeviceMemoryProperties : vk.PhysicalDeviceMemoryProperties2 =
        undefined
      ;
      zeroInitInPlace(&self.physicalDeviceMemoryBudgetProperties);

      physicalDeviceMemoryProperties.sType = (
        vk.StructureType.physicalDeviceMemoryProperties2
      );

      self.physicalDeviceMemoryBudgetProperties.sType = (
        vk.StructureType.physicalDeviceMemoryBudgetPropertiesEXT
      );

      self.physicalDeviceMemoryBudgetProperties.pNext = null;
      physicalDeviceMemoryProperties.pNext = (
        &self.physicalDeviceMemoryBudgetProperties
      );

      vki.getPhysicalDeviceMemoryProperties2(
        self.physicalDevice, &physicalDeviceMemoryProperties
      );

      self.physicalDeviceMemoryProperties = (
        physicalDeviceMemoryProperties.memoryProperties
      );
    }

    // get queue family properties
    var queueFamilyPropertyLen : u32 = 0;
    vki.getPhysicalDeviceQueueFamilyProperties(
      self.physicalDevice, &queueFamilyPropertyLen, null
    );

    self.queueFamilyProperties =
      @TypeOf(self.queueFamilyProperties).init(allocator);
    errdefer self.queueFamilyProperties.deinit();

    try self.queueFamilyProperties.resize(queueFamilyPropertyLen);

    vki.getPhysicalDeviceQueueFamilyProperties(
      self.physicalDevice
    , &queueFamilyPropertyLen
    , self.queueFamilyProperties.items.ptr
    );

    // log queue family properties and record the device queue indices
    self.deviceQueue = VulkanDeviceQueues {};
    for (self.queueFamilyProperties.items) |properties, i| {
      const familyIndex = @intCast(u32, i);

      // vk_logger.QueueFamilyProperties(properties, i);

      if (properties.queueFlags.contains(.{.graphicsBit = true})) {
        self.deviceQueue.graphicsIdx = familyIndex;
      }

      if (properties.queueFlags.contains(.{.computeBit = true})) {
        self.deviceQueue.computeIdx = familyIndex;
      }

      // TODO check for getPhysicalDeviceSurfaceSupportKHR
      // if (properties.queueFlags.contains(.{.graphicsBit = true})) {
      //   (try self.deviceQueue.presentIndices.addOne()).* = family;
      // }

      if (properties.queueFlags.contains(.{.transferBit = true})) {
        self.deviceQueue.transferIdx = familyIndex;
      }

      if (
        properties.queueFlags.contains(
          .{.transferBit = true, .computeBit = true, .graphicsBit = true})
      ) {
        self.deviceQueue.gtcIdx = familyIndex;
      }
    }

    // initialize logical device
    const priority = [_]f32 { 1.0 };
    var deviceQueueCreateInfo = [_]vk.DeviceQueueCreateInfo {
      .{
        .flags = .{}
      , .queueFamilyIndex = self.deviceQueue.gtcIdx
      , .queueCount = 1
      , .pQueuePriorities = &priority
      }
    , .{
        .flags = .{}
      , .queueFamilyIndex = self.deviceQueue.computeIdx
      , .queueCount = 1
      , .pQueuePriorities = &priority
      }
    };

    var enabledFeatureList = try (
      enableVkFeatureList(
        .{
          vk.PhysicalDeviceFeatures2 {
            .features = .{
              .shaderFloat64 = vk.TRUE,
              .shaderInt64 = vk.TRUE,
              .shaderInt16 = vk.TRUE,
            }
          },
          vk.PhysicalDevice8BitStorageFeatures {
            .storageBuffer8BitAccess = vk.TRUE,
            .uniformAndStorageBuffer8BitAccess = vk.TRUE,
          },
          vk.PhysicalDeviceShaderImageAtomicInt64FeaturesEXT {
            .shaderImageInt64Atomics = vk.TRUE,
            .sparseImageInt64Atomics = vk.TRUE,
          },
          vk.PhysicalDeviceShaderAtomicInt64Features {
            .shaderBufferInt64Atomics = vk.TRUE,
            .shaderSharedInt64Atomics = vk.TRUE,
          },
        },
      )
    );
    defer freeVkFeatureList(enabledFeatureList);

    self.device = try (
      vki.createDevice(
        self.physicalDevice, .{
          .flags = .{},
          .pNext = enabledFeatureList,
          .queueCreateInfoCount = deviceQueueCreateInfo.len,
          .pQueueCreateInfos = &deviceQueueCreateInfo,
          .enabledLayerCount = 0,
          .ppEnabledLayerNames = undefined,
          .enabledExtensionCount = @intCast(u32, deviceExtensions.len),
          .ppEnabledExtensionNames = deviceExtensions.ptr,
            // @ptrCast([*] const [*:0] const u8, deviceExtensions.items[0])
          .pEnabledFeatures = null,
        },
        null
      )
    );

    self.vkdd = try (
      vkDispatcher.VulkanDeviceDispatch.load(
        self.device, vki.dispatch.vkGetDeviceProcAddr
      )
    );

    errdefer self.vkdd.destroyDevice(self.device, null);

    return self;
  }

  pub fn deinit(self : @This()) void {
    self.vkdd.destroyDevice(self.device, null);
    self.queueFamilyProperties.deinit();
  }
};

fn constructInstance(
  vkb : vkDispatcher.VulkanBaseDispatch,
  allocator : std.mem.Allocator,
  instanceCreatePNext : * const anyopaque,
) !vk.Instance {
  const appInfo = vk.ApplicationInfo {
    .pApplicationName = "zTOADz",
    .applicationVersion = vk.makeApiVersion(1, 0, 0, 0),
    .pEngineName = "MTR",
    .engineVersion = vk.makeApiVersion(1, 0, 0, 0),
    .apiVersion = vk.API_VERSION_1_2,
    .pNext = null,
  };

  var glfwExtensionLength : u32 = 0;
  const glfwExtensions = (
    glfw.c.glfwGetRequiredInstanceExtensions(&glfwExtensionLength)
  );

  var instanceExtensions = (
    std.ArrayList([*:0] const u8).init(allocator)
  );
  defer instanceExtensions.deinit();

  { // copy GLFW extensions
    var extI : u32 = 0;
    while (extI < glfwExtensionLength) : (extI += 1) {
      (try instanceExtensions.addOne()).* = glfwExtensions[extI];
    }
  }

  // add our own extensions
  (try instanceExtensions.addOne()).* = (
    vk.extension_info.extDebugUtils.name
  );

  // -- create instance
  var layers = [_][*:0] const u8 {
    "VK_LAYER_KHRONOS_validation",
  };

  const instanceCreateInfo = vk.InstanceCreateInfo {
    .flags = vk.InstanceCreateFlags.fromInt(0),
    .pApplicationInfo = &appInfo,
    .enabledLayerCount = 1,
    .ppEnabledLayerNames = @ptrCast([*] const [*:0] const u8, &layers),
    .enabledExtensionCount = @intCast(u32, instanceExtensions.items.len),
    .ppEnabledExtensionNames = (
      @ptrCast([*] const [*:0] const u8, instanceExtensions.items)
    ),
    .pNext = @ptrCast(* const anyopaque, instanceCreatePNext),
  };

  return try vkb.createInstance(instanceCreateInfo, null);
}

fn constructDevices(
  allocator : std.mem.Allocator
, vki : vkDispatcher.VulkanInstanceDispatch
, instance : vk.Instance
, deviceExtensions : [] const [*:0] const u8
) !std.ArrayList(VulkanDeviceContext) {
  var devices = std.ArrayList(VulkanDeviceContext).init(allocator);

  var deviceLen : u32 = undefined;
  _ = try vki.enumeratePhysicalDevices(instance, &deviceLen, null);

  const physicalDevices = try allocator.alloc(vk.PhysicalDevice, deviceLen);
  defer allocator.free(physicalDevices);

  _ = try (
    vki.enumeratePhysicalDevices(
      instance, &deviceLen, physicalDevices.ptr
    )
  );

  physicalDeviceLbl: for (physicalDevices) |physicalDevice, it| {
    // TODO check if the device is suitable for this application

    var extensions = std.ArrayList(vk.ExtensionProperties).init(allocator);
    defer extensions.deinit();

    var extensionLen : u32 = undefined;
    _ = try (
      vki.enumerateDeviceExtensionProperties(
        physicalDevice, null, &extensionLen, null
      )
    );

    try extensions.resize(extensionLen);
    _ = try (
      vki.enumerateDeviceExtensionProperties(
        physicalDevice, null, &extensionLen, extensions.items.ptr
      )
    );

    for (deviceExtensions) |extReq| {
      var exists = false;
      for (extensions.items) |ext| {
        if (
          std.cstr.cmp(
            @ptrCast([*:0] const u8, &ext.extensionName[0]), extReq
          ) == 0
        ) {
          exists = true;
          break;
        }
      }

      if (!exists) {
        std.log.info(
          "device ID {} doesn't support extension '{s}'",
          .{it, extReq}
        );
        continue :physicalDeviceLbl;
      }
    }

    std.log.info("found suitable device ID {}", .{it});
    (try devices.addOne()).* = try (
      VulkanDeviceContext.init(
        allocator, vki, physicalDevice, deviceExtensions,
      )
    );
  }

  return devices;
}

pub const Heap = struct {
  memoryType : vk.MemoryType,
  memoryTypeIndex : usize, // idx for physicalDeviceMemoryProperties.memoryTypes
};

pub const Rasterizer = struct {
  allocator : std.mem.Allocator,
  // context : c.cl_context,
  // device : c.cl_device_id,

  glfwSurface : vk.SurfaceKHR,

  heaps : std.AutoHashMap(mtr.heap.RegionIdx, Heap),
  heapRegions : std.AutoHashMap(mtr.heap.RegionIdx, vk.DeviceMemory),
  buffers : std.AutoHashMap(mtr.buffer.Idx, vk.Buffer),
  images : std.AutoHashMap(mtr.image.Idx, Image),
  imageViews : std.AutoHashMap(mtr.image.Idx, vk.ImageView),
  shaderModules : std.AutoHashMap(mtr.shader.Idx, vk.ShaderModule),
  descriptorSetLayouts : (
    std.AutoHashMap(mtr.descriptor.LayoutIdx, vk.DescriptorSetLayout)
  ),
  descriptorSetPools : (
    std.AutoHashMap(mtr.descriptor.PoolIdx, vk.DescriptorPool)
  ),
  descriptorSets : (
    std.AutoHashMap(mtr.descriptor.SetIdx, vk.DescriptorSet)
  ),
  computePipelines : std.AutoHashMap(mtr.pipeline.ComputeIdx, vk.Pipeline),
  semaphores : std.AutoHashMap(mtr.memory.SemaphoreId, vk.Semaphore),
  fences : std.AutoHashMap(mtr.memory.FenceId, vk.Fence),
  swapchains : std.AutoHashMap(mtr.window.SwapchainId, vk.SwapchainKHR),
  pipelineLayouts : std.AutoHashMap(mtr.pipeline.LayoutIdx, vk.PipelineLayout),
  queues : std.AutoHashMap(mtr.queue.Idx, VulkanDeviceQueue),
  commandPools : std.AutoHashMap(mtr.command.PoolIdx, vk.CommandPool),
  commandBuffers : std.AutoHashMap(mtr.command.PoolIdx, CommandBuffer),

  vkb : vkDispatcher.VulkanBaseDispatch,
  instance : vk.Instance,
  vki : vkDispatcher.VulkanInstanceDispatch,
  devices : std.ArrayList(VulkanDeviceContext),
  vkd : * VulkanDeviceContext, // pointer to device in arraylist
  glfwWindow : * glfw.c.GLFWwindow,

  pub fn labelObject(
    self : * @This(),
    label : [:0] const u8,
    object : anytype,
  ) !void {
    try self.vkd.vkdd.setDebugUtilsObjectNameEXT(
      self.vkd.device,
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType = util.getObjectType(object),
        .objectHandle = @bitCast(u64, object),
        .pObjectName = label,
      },
    );
  }

  pub fn init(info : mtr.context.Context.CreateInfo) ! @This() {
    const requiredDeviceExtensions = [_][*:0] const u8 {
      vk.extension_info.khrSwapchain.name,
      vk.extension_info.khrDeferredHostOperations.name,
      vk.extension_info.khrCopyCommands2.name,
      vk.extension_info.khr8BitStorage.name,
      vk.extension_info.khr16BitStorage.name,
      vk.extension_info.khrShaderAtomicInt64.name,
      vk.extension_info.extShaderImageAtomicInt64.name,
      // vk.extension_info.khrRayTracingPipeline,
      // vk.extension_info.khrAccelerationStructure.name,
      // vk.extension_info.khrRayQuery.name,
      // vk.extension_info.khrShaderNonSemanticInfo.name,
    };

    const validationFeaturesEnabled = [_] vk.ValidationFeatureEnableEXT {
      // .gpuAssistedEXT,
      // .gpuAssistedReserveBindingSlotEXT,
      .debugPrintfEXT,
      // .bestPracticesEXT,
      //.synchronizationValidationEXT
    };

    const validationFeatures = vk.ValidationFeaturesEXT {
      .enabledValidationFeatureCount = validationFeaturesEnabled.len,
      .pEnabledValidationFeatures = ptrConstCast(validationFeaturesEnabled),
      .disabledValidationFeatureCount = 0,
      .pDisabledValidationFeatures = undefined,
    };

    // then initial vk dispatch loaders

    var vkb = try (
      vkDispatcher.VulkanBaseDispatch.load(glfw.glfwGetInstanceProcAddress)
    );
    var instance = (
      try constructInstance(vkb, info.allocator, &validationFeatures)
    );
    var vki = try (
      vkDispatcher.VulkanInstanceDispatch.load(
        instance, glfw.glfwGetInstanceProcAddress,
      )
    );
    var devices = try (
      constructDevices(
        info.allocator,
        vki,
        instance,
        requiredDeviceExtensions[0..],
      )
    );

    var surface : vk.SurfaceKHR = undefined;
    std.debug.assert(
      glfw.glfwCreateWindowSurface(instance, info.glfwWindow.?, null, &surface)
      == .success
    );

    var self = @This() {
      .glfwSurface = surface,
      .allocator = info.allocator,
      .heaps = std.AutoHashMap(mtr.heap.RegionIdx, Heap).init(info.allocator),
      .heapRegions = (
        std
          .AutoHashMap(mtr.heap.RegionIdx, vk.DeviceMemory)
          .init(info.allocator)
      ),
      .buffers = (
        std.AutoHashMap(mtr.heap.RegionIdx, vk.Buffer).init(info.allocator)
      ),
      .images = std.AutoHashMap(mtr.image.Idx, Image).init(info.allocator),
      .imageViews = (
        std.AutoHashMap(mtr.image.ViewIdx, vk.ImageView).init(info.allocator)
      ),
      .shaderModules = (
        std.AutoHashMap(mtr.shader.Idx, vk.ShaderModule).init(info.allocator)
      ),
      .queues = (
        std.AutoHashMap(mtr.queue.Idx, VulkanDeviceQueue).init(info.allocator)
      ),
      .descriptorSetLayouts = (
        std
          .AutoHashMap(mtr.descriptor.LayoutIdx, vk.DescriptorSetLayout)
          .init(info.allocator)
      ),
      .descriptorSetPools = (
        std
          .AutoHashMap(mtr.descriptor.PoolIdx, vk.DescriptorPool)
          .init(info.allocator)
      ),
      .descriptorSets = (
        std
          .AutoHashMap(mtr.descriptor.SetIdx, vk.DescriptorSet)
          .init(info.allocator)
      ),
      .computePipelines = (
        std
          .AutoHashMap(mtr.pipeline.ComputeIdx, vk.Pipeline)
          .init(info.allocator)
      ),
      .pipelineLayouts = (
        std
          .AutoHashMap(mtr.pipeline.LayoutIdx, vk.PipelineLayout)
          .init(info.allocator)
      ),
      .commandPools = (
        std
          .AutoHashMap(mtr.command.PoolIdx, vk.CommandPool)
          .init(info.allocator)
      ),
      .commandBuffers = (
        std
          .AutoHashMap(mtr.command.PoolIdx, CommandBuffer)
          .init(info.allocator)
      ),
      .semaphores = (
        std
          .AutoHashMap(mtr.memory.SemaphoreId, vk.Semaphore)
          .init(info.allocator)
      ),
      .fences = (
        std.AutoHashMap(mtr.memory.FenceId, vk.Fence).init(info.allocator)
      ),
      .swapchains = (
        std
          .AutoHashMap(mtr.window.SwapchainId, vk.SwapchainKHR)
          .init(info.allocator)
      ),
      .vkb = vkb,
      .instance = instance,
      .devices = devices,
      .vki = vki,
      .vkd = &devices.items[devices.items.len-1], // TODO device picker
      .glfwWindow = info.glfwWindow.?,
    };

    errdefer self.vki.destroyinstance(self.instance, null);
    errdefer {
      for (self.devices.items) |device| device.deinit();
      self.devices.deinit();
    }

    return self;
  }

  pub fn deinit(self : * @This()) void {

    var semaphoreIter = self.semaphores.iterator();
    while (semaphoreIter.next()) |semaphore| {
      self.vkd.vkdd.destroySemaphore(
        self.vkd.device,
        semaphore.value_ptr.*,
        null
      );
    }

    var fenceIter = self.fences.iterator();
    while (fenceIter.next()) |fence| {
      self.vkd.vkdd.destroyFence(
        self.vkd.device,
        fence.value_ptr.*,
        null
      );
    }

    var swapchainIter = self.swapchains.iterator();
    while (swapchainIter.next()) |swapchain| {
      self.vkd.vkdd.destroySwapchainKHR(
        self.vkd.device,
        swapchain.value_ptr.*,
        null
      );
    }

    var shaderModuleIter = self.shaderModules.iterator();
    while (shaderModuleIter.next()) |shaderModule| {
      self.vkd.vkdd.destroyShaderModule(
        self.vkd.device,
        shaderModule.value_ptr.*,
        null
      );
    }

    var descriptorSetLayoutIter = self.descriptorSetLayouts.iterator();
    while (descriptorSetLayoutIter.next()) |descriptorSetLayout| {
      self.vkd.vkdd.destroyDescriptorSetLayout(
        self.vkd.device,
        descriptorSetLayout.value_ptr.*,
        null
      );
    }

    var descriptorSetPoolIter = self.descriptorSetPools.iterator();
    while (descriptorSetPoolIter.next()) |descriptorSetPool| {
      self.vkd.vkdd.destroyDescriptorPool(
        self.vkd.device,
        descriptorSetPool.value_ptr.*,
        null
      );
    }

    // TODO to dealloc this need to know the allocated pool
    // maybe from mtr context
    // var descriptorSetIter = self.descriptorSets.iterator();
    // while (descriptorSetIter.next()) |descriptorSet| {
    //   self.vkd.vkdd.freeDescriptorSets(
    //     self.vkd.device,
    //     descriptorSetPool.value_ptr.*,
    //     null
    //   );
    // }

    var imageViewIter = self.imageViews.iterator();
    while (imageViewIter.next()) |imageView| {
      self.vkd.vkdd.destroyImageView(
        self.vkd.device,
        imageView.value_ptr.*,
        null
      );
    }

    var imageIter = self.images.iterator();
    while (imageIter.next()) |image| {
      if (image.value_ptr.*.partOfSwapchain) {
        continue;
      }
      self.vkd.vkdd.destroyImage(
        self.vkd.device,
        image.value_ptr.*.handle,
        null
      );
    }

    var computePipelineIter = self.computePipelines.iterator();
    while (computePipelineIter.next()) |computePipeline| {
      self.vkd.vkdd.destroyPipeline(
        self.vkd.device,
        computePipeline.value_ptr.*,
        null
      );
    }

    var pipelineLayoutIter = self.pipelineLayouts.iterator();
    while (pipelineLayoutIter.next()) |pipelineLayout| {
      self.vkd.vkdd.destroyPipelineLayout(
        self.vkd.device,
        pipelineLayout.value_ptr.*,
        null
      );
    }

    var bufferIter = self.buffers.iterator();
    while (bufferIter.next()) |buffer| {
      self.vkd.vkdd.destroyBuffer(self.vkd.device, buffer.value_ptr.*, null);
    }

    var subheapIter = self.heapRegions.iterator();
    while (subheapIter.next()) |subheap| {
      self.vkd.vkdd.freeMemory(self.vkd.device, subheap.value_ptr.*, null);
    }

    var commandBufferIter = self.commandBuffers.iterator();
    while (commandBufferIter.next()) |commandBufferIterNext| {
      var commandBuffer = commandBufferIterNext.value_ptr;
      var commandPool = self.commandPools.get(commandBuffer.commandPool).?;
      self.vkd.vkdd.freeCommandBuffers(
        self.vkd.device,
        commandPool,
        @intCast(u32, commandBuffer.buffers.items.len),
        @ptrCast([*] const vk.CommandBuffer, commandBuffer.buffers.items.ptr),
      );
      commandBuffer.deinit();
    }

    var commandPoolIter = self.commandPools.iterator();
    while (commandPoolIter.next()) |commandPool| {
      self.vkd.vkdd.destroyCommandPool(
        self.vkd.device,
        commandPool.value_ptr.*,
        null,
      );
    }

    // -- deinit devices
    for (self.devices.items) |device| device.deinit();
    self.devices.deinit();

    // -- deinit instance
    if (self.glfwSurface != .null_handle) {
      self.vki.destroySurfaceKHR(self.instance, self.glfwSurface, null);
    }

    if (self.instance != .null_handle) {
      self.vki.destroyInstance(self.instance, null);
    }

    glfw.c.glfwDestroyWindow(self.glfwWindow);

    glfw.c.glfwTerminate();

    // destroy local memory
    self.semaphores.deinit();
    self.fences.deinit();
    self.swapchains.deinit();
    self.heaps.deinit();
    self.shaderModules.deinit();
    self.descriptorSetLayouts.deinit();
    self.descriptorSetPools.deinit();
    self.descriptorSets.deinit();
    self.heapRegions.deinit();
    self.buffers.deinit();
    self.images.deinit();
    self.imageViews.deinit();
    self.queues.deinit();
    self.commandPools.deinit();
    self.pipelineLayouts.deinit();
    self.computePipelines.deinit();
    self.commandBuffers.deinit();
  }

  pub fn createShaderModule(
    self : * @This(),
    _ : mtr.Context,
    shaderModule : mtr.shader.Module,
  ) !void {
    const vkShaderModule = (
      self.vkd.vkdd.createShaderModule(
        self.vkd.device,
        vk.ShaderModuleCreateInfo {
          .flags = .{},
          .codeSize = shaderModule.data.len,
          .pCode = (
            @ptrCast(
              [*] const u32,
              @alignCast(@alignOf(u32), shaderModule.data.ptr)
            )
          ),
        },
        null,
      )
      catch |err| {
        std.log.err("{s}{}", .{"could not create shader module: ", err});
        return;
      }
    );

    try self.labelObject(shaderModule.label, vkShaderModule);

    try self.shaderModules.putNoClobber(shaderModule.contextIdx, vkShaderModule);
  }

  pub fn createDescriptorSet(
    self : * @This(),
    _ : mtr.Context,
    descriptorSet : mtr.descriptor.Set,
  ) !void {
    // allocate descriptor set TODO should allocate elsewhere
    var vkDescriptorSet : vk.DescriptorSet = undefined;
    try self.vkd.vkdd.allocateDescriptorSets(
      self.vkd.device,
      .{
        .descriptorPool = self.descriptorSetPools.get(descriptorSet.pool).?,
        .descriptorSetCount = 1,
        .pSetLayouts = (
          @ptrCast(
            [*] const vk.DescriptorSetLayout,
            self.descriptorSetLayouts.getPtr(descriptorSet.layout).?
          )
        ),
      },
      @ptrCast([*] vk.DescriptorSet, &vkDescriptorSet),
    );

    try self.descriptorSets.putNoClobber(
      descriptorSet.contextIdx, vkDescriptorSet
    );
  }

  pub fn createDescriptorSetLayout(
    self : * @This(),
    context : mtr.Context,
    setLayout : mtr.descriptor.SetLayout,
  ) !void {

    var layoutBindings = (
      std
        .ArrayList(vk.DescriptorSetLayoutBinding)
        .init(context.primitiveAllocator)
    );
    defer layoutBindings.deinit();

    var setLayoutIterator = setLayout.bindingIdxToLayoutBinding.iterator();
    while (setLayoutIterator.next()) |setLayoutBinding| {
      const binding = setLayoutBinding.value_ptr;
      (try layoutBindings.addOne()).* = .{
        .binding = binding.binding,
        .descriptorType = descriptorTypeToVk(binding.descriptorType),
        .descriptorCount = binding.count,
        .stageFlags = .{ .computeBit = true },
        .pImmutableSamplers = null,
      };
    }

    const vkDescriptorSetLayout = (
      try self.vkd.vkdd.createDescriptorSetLayout(
        self.vkd.device,
        .{
          .flags = .{
            .updateAfterBindPoolBit = (setLayout.frequency == .perDraw),
          },
          .bindingCount = @intCast(u32, layoutBindings.items.len),
          .pBindings = layoutBindings.items.ptr,
        },
        null,
      )
    );

    try self.labelObject(setLayout.label, vkDescriptorSetLayout);

    try self.descriptorSetLayouts.putNoClobber(
      setLayout.contextIdx,
      vkDescriptorSetLayout
    );
  }

  pub fn createDescriptorSetPool(
    self : * @This(),
    context : mtr.Context,
    descriptorSetPool : mtr.descriptor.SetPool,
  ) !void {
    var descriptorSetSizes = (
      std.ArrayList(vk.DescriptorPoolSize).init(context.primitiveAllocator)
    );
    defer descriptorSetSizes.deinit();

    // fill descriptor set sizes
    if (descriptorSetPool.descriptorSizes.sampler > 0) {
      (try descriptorSetSizes.addOne()).* = (
        vk.DescriptorPoolSize {
          .@"type" = vk.DescriptorType.sampler,
          .descriptorCount = descriptorSetPool.descriptorSizes.sampler,
        }
      );
    }

    if (descriptorSetPool.descriptorSizes.storageImage > 0) {
      (try descriptorSetSizes.addOne()).* = (
        vk.DescriptorPoolSize {
          .@"type" = vk.DescriptorType.storageImage,
          .descriptorCount = descriptorSetPool.descriptorSizes.storageImage,
        }
      );
    }

    if (descriptorSetPool.descriptorSizes.storageBuffer > 0) {
      (try descriptorSetSizes.addOne()).* = (
        vk.DescriptorPoolSize {
          .@"type" = vk.DescriptorType.storageBuffer,
          .descriptorCount = descriptorSetPool.descriptorSizes.storageBuffer,
        }
      );
    }

    if (descriptorSetPool.descriptorSizes.sampledImage > 0) {
      (try descriptorSetSizes.addOne()).* = (
        vk.DescriptorPoolSize {
          .@"type" = vk.DescriptorType.sampledImage,
          .descriptorCount = descriptorSetPool.descriptorSizes.sampledImage,
        }
      );
    }

    if (descriptorSetPool.descriptorSizes.uniformBuffer > 0) {
      (try descriptorSetSizes.addOne()).* = (
        vk.DescriptorPoolSize {
          .@"type" = vk.DescriptorType.uniformBuffer,
          .descriptorCount = descriptorSetPool.descriptorSizes.uniformBuffer,
        }
      );
    }

    // create descriptor set pool

    var vkDescriptorSetPool = (
      try self.vkd.vkdd.createDescriptorPool(
        self.vkd.device,
        vk.DescriptorPoolCreateInfo {
          .flags = .{
            .updateAfterBindBit = descriptorSetPool.frequency == .perDraw,
            .freeDescriptorSetBit = descriptorSetPool.frequency == .perDraw,
          },
          .maxSets = descriptorSetPool.maxSets,
          .poolSizeCount = @intCast(u32, descriptorSetSizes.items.len),
          .pPoolSizes = descriptorSetSizes.items.ptr,
        },
        null,
      )
    );

    try self.labelObject(descriptorSetPool.label, vkDescriptorSetPool);

    try self.descriptorSetPools.putNoClobber(
      descriptorSetPool.contextIdx,
      vkDescriptorSetPool
    );
  }

  pub fn createQueue(
    self : * @This(),
    _ : mtr.Context,
    queue : mtr.queue.Primitive
  ) !void {
    var numQueues = (
        @intCast(i32, @boolToInt(queue.workType.transfer))
      + @intCast(i32, @boolToInt(queue.workType.render))
      + @intCast(i32, @boolToInt(queue.workType.compute))
    );
    var vdq : ? VulkanDeviceQueue = null;
    // TODO rework this
    if (numQueues > 1) {
      vdq = VulkanDeviceQueue.init(self.vkd.*, self.vkd.deviceQueue.gtcIdx);
    }
    else if (queue.workType.compute) {
      vdq = VulkanDeviceQueue.init(self.vkd.*, self.vkd.deviceQueue.computeIdx);
    }
    else if (queue.workType.render) {
      vdq = (
        VulkanDeviceQueue.init(self.vkd.*, self.vkd.deviceQueue.graphicsIdx)
      );
    }
    else if (queue.workType.transfer) {
      vdq = (
        VulkanDeviceQueue.init(self.vkd.*, self.vkd.deviceQueue.transferIdx)
      );
    }
    // TODO vdq can't be null here bc MTR
    try self.queues.putNoClobber(queue.contextIdx, vdq.?);
  }

  pub fn createHeapFromMemoryRequirements(
    self : * @This(),
    context : mtr.Context,
    heap : mtr.heap.Primitive,
    memoryRequirements : [] mtr.util.MemoryRequirements
  ) !void {
    var memProps = &self.vkd.physicalDeviceMemoryProperties;

    // grab all of the potential heaps we can use
    var validHeaps = std.ArrayList(Heap).init(context.primitiveAllocator);
    defer validHeaps.deinit();

    // get device local heap and host visible bit
    var memoryTypeIt : usize = 0;
    memoryType:
    while (memoryTypeIt < memProps.memoryTypeCount) : (memoryTypeIt += 1)
    {
      // check if the property flags match the heap's visibility
      if (
        !memProps.memoryTypes[memoryTypeIt].propertyFlags.contains(
          vk.MemoryPropertyFlags {
            .deviceLocalBit = (heap.visibility == .deviceOnly),
            .hostVisibleBit = (
                  heap.visibility == .hostVisible
              or  heap.visibility == .hostWritable
            ),
          },
        )
      ) {
        continue;
      }

      // iterate thru memory requirements and check they all exist
      for (memoryRequirements) |memoryRequirement| {
        const typeModifier = (@intCast(u32, 1) << @intCast(u5, memoryTypeIt));
        if ((memoryRequirement.typeBits & typeModifier) == 0) {
          continue :memoryType;
        }
      }

      var newHeap = Heap {
        .memoryType = memProps.memoryTypes[memoryTypeIt],
        .memoryTypeIndex = memoryTypeIt,
      };

      (try validHeaps.addOne()).* = newHeap;
    }

    std.debug.assert(validHeaps.items.len > 0);

    // TODO maybe better selection from memory lengths?
    var newHeap = validHeaps.items[0];

    try self.heaps.putNoClobber(heap.contextIdx, newHeap);
  }

  // BELOW needs to be REMOVED
  pub fn createHeap(
    self : * @This(), _ : mtr.Context, heap : mtr.heap.Primitive
  ) !void {
    var memProps = &self.vkd.physicalDeviceMemoryProperties;

    // grab all of the potential heaps we can use

    // TODO change this to use Heap
    var deviceLocalHeap : ? Heap = null;
    var hostVisibleHeap : ? Heap = null;

    // get device local heap and host visible bit
    // TODO this is pretty poor
    var memoryTypeIt : u32 = 0;
    while (memoryTypeIt < memProps.memoryTypeCount) : (memoryTypeIt += 1) {
      if (
        memProps.memoryTypes[memoryTypeIt].propertyFlags.contains(
          vk.MemoryPropertyFlags { .deviceLocalBit = true },
        )
      ) {
        deviceLocalHeap = Heap {
          .memoryType = memProps.memoryTypes[memoryTypeIt],
          .memoryTypeIndex = memoryTypeIt,
        };
      }

      if (
        memProps.memoryTypes[memoryTypeIt].propertyFlags.contains(
          vk.MemoryPropertyFlags {
            .hostVisibleBit = true,
            .hostCachedBit = true
          },
        )
      ) {
        hostVisibleHeap = Heap {
          .memoryType = memProps.memoryTypes[memoryTypeIt],
          .memoryTypeIndex = memoryTypeIt,
        };
      }
    }

    // in this case MTR is failing to even get the proper heaps
    std.debug.assert(deviceLocalHeap != null and hostVisibleHeap != null);

    // select the proper heap from the best named heaps
    var newHeap : ? Heap = null;
    switch (heap.visibility) {
      .deviceOnly   => newHeap = deviceLocalHeap,
      .hostVisible  => newHeap = hostVisibleHeap,
      .hostWritable => newHeap = hostVisibleHeap,
    }

    try self.heaps.putNoClobber(heap.contextIdx, newHeap.?);
  }

  pub fn createHeapRegion(
    self : * @This(), _ : mtr.Context, heapRegion : mtr.heap.Region
  ) !void {
    var heap = self.heaps.get(heapRegion.allocatedHeap).?;
    std.debug.assert(heapRegion.length > 0);
    var deviceMemory = try (
      self.vkd.vkdd.allocateMemory(
        self.vkd.device,
        vk.MemoryAllocateInfo {
          .allocationSize = heapRegion.length,
          .memoryTypeIndex = @intCast(u32, heap.memoryTypeIndex),
        },
        null
      )
    );
    try self.heapRegions.putNoClobber(heapRegion.contextIdx, deviceMemory);
  }

  pub fn bindBufferToSubheap(
    self : * @This(),
    _ : mtr.Context,
    buffer : mtr.buffer.Primitive,
  ) void {
    var vkBuffer = self.buffers.get(buffer.contextIdx).?;
    var vkDeviceMemory = self.heapRegions.get(buffer.allocatedHeapRegion).?;
    self.vkd.vkdd.bindBufferMemory(
      self.vkd.device, vkBuffer, vkDeviceMemory, buffer.offset
    ) catch |err| {
      std.log.err("Could not bind buffer memory {}", .{err});
    };
  }

  pub fn createBuffer(
    self : * @This(),
    _ : mtr.Context,
    buffer : mtr.buffer.Primitive,
  ) !void {
    const vkBufferCI = vk.BufferCreateInfo {
      .flags = .{ },
      .size = buffer.length,
      .usage = bufferUsageToVk(buffer.usage),
      .sharingMode = queueSharingUsageToVk(buffer.queueSharing),
      .queueFamilyIndexCount = 0,
      .pQueueFamilyIndices = undefined, // TODO pull from queueSharing union
    };

    const vkBuffer = try (
      self.vkd.vkdd.createBuffer(self.vkd.device, vkBufferCI, null)
    );

    try self.labelObject(buffer.label, vkBuffer);

    try self.buffers.putNoClobber(buffer.contextIdx, vkBuffer);
  }

  pub fn bufferMemoryRequirements(
    self : * @This(),
    _ : mtr.Context,
    buffer : mtr.buffer.Primitive,
  ) mtr.util.MemoryRequirements {
    var vkBuffer = self.buffers.get(buffer.contextIdx).?;
    var memoryRequirement = vk.MemoryRequirements2 {
      .memoryRequirements = undefined,
    };

    self.vkd.vkdd.getBufferMemoryRequirements2(
      self.vkd.device,
      .{ .buffer = vkBuffer },
      &memoryRequirement,
    );
    return .{
      .alignment = memoryRequirement.memoryRequirements.alignment,
      .length = memoryRequirement.memoryRequirements.size,
      .typeBits = memoryRequirement.memoryRequirements.memoryTypeBits,
    };
  }

  pub fn bindImageToSubheap(
    self : * @This(),
    _ : mtr.Context,
    image : mtr.image.Primitive,
  ) void {
    var vkImage = self.images.get(image.contextIdx).?.handle;
    var vkDeviceMemory = self.heapRegions.get(image.allocatedHeapRegion).?;
    self.vkd.vkdd.bindImageMemory(
      self.vkd.device,
      vkImage,
      vkDeviceMemory,
      image.offset
    ) catch |err| {
      std.log.err("Could not bind buffer memory {}", .{err});
    };
  }

  pub fn imageMemoryRequirements(
    self : * @This(),
    _ : mtr.Context,
    image : mtr.image.Primitive,
  ) mtr.util.MemoryRequirements {
    var vkImage = self.images.get(image.contextIdx).?.handle;
    var memoryRequirement = vk.MemoryRequirements2 {
      .memoryRequirements = undefined,
    };

    self.vkd.vkdd.getImageMemoryRequirements2(
      self.vkd.device,
      .{ .image = vkImage },
      &memoryRequirement,
    );

    return .{
      .alignment = memoryRequirement.memoryRequirements.alignment,
      .length = memoryRequirement.memoryRequirements.size,
      .typeBits = memoryRequirement.memoryRequirements.memoryTypeBits,
    };
  }

  pub fn createImage(
    self : * @This(),
    _ : mtr.Context,
    image : mtr.image.Primitive,
  ) !void {
    var vkImage = try (
      self.vkd.vkdd.createImage(
        self.vkd.device,
        vk.ImageCreateInfo {
          .flags = vk.ImageCreateFlags {
            .subsampledBitEXT = image.samplesPerTexel != .s1,
          },
          .imageType = toImageType(image),
          .format = imageToVkFormat(image),
          .extent = vk.Extent3D {
            .width = @intCast(u32, image.width),
            .height = @intCast(u32, image.height),
            .depth = @intCast(u32, image.depth),
          },
          .mipLevels = @intCast(u32, image.mipmapLevels),
          .arrayLayers = @intCast(u32, image.arrayLayers),
          .samples = toSampleCountFlags(image),
          .tiling = vk.ImageTiling.optimal,
          .usage = vk.ImageUsageFlags {
            .transferSrcBit = image.usage.transferSrc,
            .transferDstBit = image.usage.transferDst,
            .sampledBit = image.usage.sampled,
            .storageBit = image.usage.storage,
          },
          .sharingMode = toSharingMode(image),
          .queueFamilyIndexCount = 0,
          .pQueueFamilyIndices = undefined, // TODO pull from queueSharing union
          .initialLayout = vk.ImageLayout.@"undefined",
        },
        null,
      )
    );

    try self.labelObject(image.label, vkImage);

    try self.images.putNoClobber(
      image.contextIdx,
      Image { .handle = vkImage, .partOfSwapchain = false, },
    );
  }

  pub fn createImageView(
    self : * @This(),
    context : mtr.Context,
    imageView : mtr.image.View,
  ) !void {
    const mtImage = context.images.get(imageView.image).?;

    const vkImageView = (
      try self.vkd.vkdd.createImageView(
        self.vkd.device,
        .{
          .flags = .{ },
          .image = self.images.get(imageView.image).?.handle,
          .viewType = viewTypeToVk(imageView.viewType),
          .format = imageToVkFormat(mtImage),
          .components = .{ .r = .r, .g = .g, .b = .b, .a = .a, },
          .subresourceRange = .{
            .aspectMask = .{ .colorBit = true },
            .baseMipLevel = imageView.mipmapLayerBegin,
            .levelCount = imageView.mipmapLayerCount,
            .baseArrayLayer = imageView.arrayLayerBegin,
            .layerCount = imageView.arrayLayerCount,
          },
        },
        null
      )
    );

    try self.labelObject(imageView.label, vkImageView);

    try self.imageViews.putNoClobber(
      imageView.contextIdx,
      vkImageView,
    );
  }

  pub fn createCommandPool(
    self : * @This(),
    _ : mtr.Context,
    commandPool : mtr.command.Pool,
  ) !void {
    var vkQueue = self.queues.getPtr(commandPool.queue).?;
    var vkCommandPool = try (
      self.vkd.vkdd.createCommandPool(
        self.vkd.device,
        vk.CommandPoolCreateInfo {
          .flags = vk.CommandPoolCreateFlags {
            .transientBit = commandPool.flags.transient,
            .resetCommandBufferBit = commandPool.flags.resetCommandBuffer,
          },
          .queueFamilyIndex = vkQueue.familyIndex,
        },
        null,
      )
    );

    try self.labelObject(commandPool.label, vkCommandPool);

    try self.commandPools.putNoClobber(commandPool.contextIdx, vkCommandPool);
  }

  pub fn createCommandBuffer(
    self : * @This(),
    _ : mtr.Context,
    mtrCommandBuffer : mtr.command.Buffer,
  ) !void {
    var vkCommandPool = self.commandPools.get(mtrCommandBuffer.commandPool).?;
    var newCommandBuffer = (
      CommandBuffer.init(mtrCommandBuffer.commandPool, self.allocator)
    );
    try newCommandBuffer.buffers.resize(1);

    try self.vkd.vkdd.allocateCommandBuffers(
      self.vkd.device,
      vk.CommandBufferAllocateInfo {
        .commandPool = vkCommandPool,
        .level = vk.CommandBufferLevel.primary,
        .commandBufferCount = 1,
      },
      @ptrCast([*] vk.CommandBuffer, newCommandBuffer.buffers.items.ptr)
    );

    for (newCommandBuffer.buffers.items) |cmdBuf| {
      try self.labelObject(mtrCommandBuffer.label, cmdBuf);
    }

    try self.commandBuffers.putNoClobber(
      mtrCommandBuffer.idx, newCommandBuffer
    );
  }

  pub fn beginCommandBufferWriting(
    self : * @This(),
    _ : mtr.Context,
    commandBufferIdx : mtr.command.BufferIdx,
  ) !void {
    var vkCommandBuffer = self.commandBuffers.getPtr(commandBufferIdx).?;

    try self.vkd.vkdd.beginCommandBuffer(
      vkCommandBuffer.buffers.items[0],
      vk.CommandBufferBeginInfo {
        .flags = vk.CommandBufferUsageFlags { .oneTimeSubmitBit = false },
        .pInheritanceInfo = null,
      },
    );
  }

  pub fn endCommandBufferWriting(
    self : * @This(),
    _ : mtr.Context,
    commandBufferIdx : mtr.command.BufferIdx,
  ) void {
    var commandBuffer = (
      self.commandBuffers.get(commandBufferIdx).?.buffers.items[0]
    );
    self.vkd.vkdd.endCommandBuffer(commandBuffer) catch unreachable;
  }

  pub fn enqueueToCommandBuffer(
    self : * @This(),
    context : mtr.Context,
    commandBufferIdx : mtr.command.BufferIdx,
    command : mtr.command.Action,
  ) !void {
    var commandBuffer = (
      self.commandBuffers.getPtr(commandBufferIdx).?
    );
    var vkCommandBuffer = commandBuffer.buffers.items[0];
    var commandPool = context.commandPools.getPtr(commandBuffer.commandPool).?;
    var vkQueue = self.queues.get(commandPool.queue).?;
    switch (command) {
      .transferMemory => |action| {
        var vkBufferSrc = self.buffers.get(action.bufferSrc).?;
        var vkBufferDst = self.buffers.get(action.bufferDst).?;
        self.vkd.vkdd.cmdCopyBuffer2KHR(
          vkCommandBuffer,
          vk.CopyBufferInfo2KHR {
            .srcBuffer = vkBufferSrc,
            .dstBuffer = vkBufferDst,
            .regionCount = 1,
            .pRegions = @ptrCast(
              [*] const vk.BufferCopy2KHR,
              &vk.BufferCopy2KHR {
                .srcOffset = action.offsetSrc,
                .dstOffset = action.offsetDst,
                .size = action.length,
              }
            ),
          },
        );
      },
      .transferBufferToImage => |action| {
        var vkImageDst = self.images.getPtr(action.imageDst).?;
        var vkBufferSrc = self.buffers.get(action.bufferSrc).?;

        const subresourceRange = (
          vk.ImageSubresourceRange {
            .aspectMask = .{ .colorBit = true },
            .baseMipLevel = action.mipmapLayerBegin,
            .levelCount = action.mipmapLayerCount,
            .baseArrayLayer = action.arrayLayerBegin,
            .layerCount = action.arrayLayerCount,
          }
        );

        const imageExtent = vk.Extent3D {
          .width = action.width, .height = action.height, .depth = action.depth,
        };

        const imageOffset = vk.Offset3D {
          .x = @intCast(i32, action.xOffset),
          .y = @intCast(i32, action.yOffset),
          .z = @intCast(i32, action.zOffset),
        };

        self.vkd.vkdd.cmdCopyBufferToImage2KHR(
          vkCommandBuffer,
          vk.CopyBufferToImageInfo2KHR {
            .srcBuffer = vkBufferSrc,
            .dstImage = vkImageDst.handle,
            .dstImageLayout = vk.ImageLayout.transferDstOptimal,
            .regionCount = 1,
            .pRegions = @ptrCast(
              [*] const vk.BufferImageCopy2KHR,
              &vk.BufferImageCopy2KHR {
                .bufferOffset = 0,
                .bufferRowLength = 0, // tightly packed
                .bufferImageHeight = 0, // tightly packed
                .imageSubresource = vk.ImageSubresourceLayers {
                  .aspectMask = subresourceRange.aspectMask,
                  .mipLevel = subresourceRange.baseMipLevel,
                  .baseArrayLayer = subresourceRange.baseArrayLayer,
                  .layerCount = subresourceRange.layerCount,
                },
                .imageOffset = imageOffset,
                .imageExtent = imageExtent,
              },
            ),
          },
        );
      },
      .transferImageToBuffer => |action| {
        var vkImageSrc = self.images.getPtr(action.imageSrc).?;
        var vkBufferDst = self.buffers.get(action.bufferDst).?;

        const subresourceRange = (
          vk.ImageSubresourceRange {
            .aspectMask = .{ .colorBit = true },
            .baseMipLevel = action.mipmapLayerBegin,
            .levelCount = action.mipmapLayerCount,
            .baseArrayLayer = action.arrayLayerBegin,
            .layerCount = action.arrayLayerCount,
          }
        );

        const imageExtent = vk.Extent3D {
          .width = action.width, .height = action.height, .depth = action.depth
        };
        const imageOffset = vk.Offset3D {
          .x = @intCast(i32, action.xOffset),
          .y = @intCast(i32, action.yOffset),
          .z = @intCast(i32, action.zOffset),
        };

        // // TODO var bufferOffset
        // const imageCopyRegionByteLength = (
        //     srcImage.byteFormat.byteLength()
        //   * srcImage.channels.channelLength()
        //   * (action.width-action.xOffset)
        //   * (action.height-action.yOffset)
        //   * (action.depth-action.zOffset)
        // );

        self.vkd.vkdd.cmdCopyImageToBuffer2KHR(
          vkCommandBuffer,
          vk.CopyImageToBufferInfo2KHR {
            .srcImage = vkImageSrc.handle,
            .srcImageLayout = vk.ImageLayout.transferSrcOptimal,
            .dstBuffer = vkBufferDst,
            .regionCount = 1,
            .pRegions = @ptrCast(
              [*] const vk.BufferImageCopy2KHR,
              &vk.BufferImageCopy2KHR {
                .bufferOffset = 0, // TODO
                .bufferRowLength = 0, // tightly packed
                .bufferImageHeight = 0, // tightly packed
                .imageSubresource = vk.ImageSubresourceLayers {
                  .aspectMask = subresourceRange.aspectMask,
                  .mipLevel = subresourceRange.baseMipLevel,
                  .baseArrayLayer = subresourceRange.baseArrayLayer,
                  .layerCount = subresourceRange.layerCount,
                },
                .imageOffset = imageOffset,
                .imageExtent = imageExtent,
              }
            ),
          },
        );
      },
      .transferImageToImage => |action| {
        var vkImageSrc = self.images.getPtr(action.imageSrc).?;
        var vkImageDst = self.images.getPtr(action.imageDst).?;

        self.vkd.vkdd.cmdBlitImage2KHR(
          vkCommandBuffer,
          vk.BlitImageInfo2KHR {
            .srcImage = vkImageSrc.handle,
            .srcImageLayout = vk.ImageLayout.transferSrcOptimal,
            .dstImage = vkImageDst.handle,
            .dstImageLayout = vk.ImageLayout.transferDstOptimal,
            .regionCount = 1,
            .filter = .nearest,
            .pRegions = @ptrCast(
              [*] const vk.ImageBlit2KHR,
              &vk.ImageBlit2KHR {
                .srcSubresource = vk.ImageSubresourceLayers {
                  .aspectMask = .{ .colorBit = true },
                  .mipLevel = action.srcMipmapLayer,
                  .baseArrayLayer = action.srcArrayLayerBegin,
                  .layerCount = action.arrayLayerCount,
                },
                .dstSubresource = vk.ImageSubresourceLayers {
                  .aspectMask = .{ .colorBit = true },
                  .mipLevel = action.dstMipmapLayer,
                  .baseArrayLayer = action.dstArrayLayerBegin,
                  .layerCount = action.arrayLayerCount,
                },
                .srcOffsets = (
                  [2] vk.Offset3D {
                    vk.Offset3D {
                      .x = @intCast(i32, action.srcXOffset),
                      .y = @intCast(i32, action.srcYOffset),
                      .z = @intCast(i32, action.srcZOffset),
                    },
                    vk.Offset3D {
                      .x = @intCast(i32, action.srcXOffset+action.width),
                      .y = @intCast(i32, action.srcYOffset+action.height),
                      .z = @intCast(i32, action.srcZOffset+action.depth),
                    },
                  }
                ),
                .dstOffsets = (
                  [2] vk.Offset3D {
                    vk.Offset3D {
                      .x = @intCast(i32, action.dstXOffset),
                      .y = @intCast(i32, action.dstYOffset),
                      .z = @intCast(i32, action.dstZOffset),
                    },
                    vk.Offset3D {
                      .x = @intCast(i32, action.dstXOffset+action.width),
                      .y = @intCast(i32, action.dstYOffset+action.height),
                      .z = @intCast(i32, action.dstZOffset+action.depth),
                    },
                  }
                ),
              }
            ),
          },
        );
      },
      .pipelineBarrier => |action| {
        // -- create & copy over image memory barriers
        var imageMemoryBarriers = (
          std.ArrayList(vk.ImageMemoryBarrier).init(self.allocator)
        );
        defer imageMemoryBarriers.deinit();
        try imageMemoryBarriers.resize(action.imageTapes.len);

        for (action.imageTapes) |imageTape, idx| {
          // predict the subresource range, construct the image memory barrier
          //   from the tape
          const image = context.images.get(imageTape.tape.?.image).?;
          const subresourceRange = (
            vk.ImageSubresourceRange {
              .aspectMask = .{ .colorBit = true },
              .baseMipLevel = 0,
              .levelCount = @intCast(u32, image.mipmapLevels),
              .baseArrayLayer = 0,
              .layerCount = @intCast(u32, image.arrayLayers),
            }
          );

          var imageMemoryBarrier = vk.ImageMemoryBarrier {
            .oldLayout = imageLayoutToVk(imageTape.tape.?.layout),
            .newLayout = imageLayoutToVk(imageTape.layout),
            .image = self.images.get(imageTape.tape.?.image).?.handle,
            .subresourceRange = subresourceRange,
            .srcAccessMask = accessFlagsToVk(imageTape.tape.?.accessFlags),
            .dstAccessMask = accessFlagsToVk(imageTape.accessFlags),
            .srcQueueFamilyIndex = vkQueue.familyIndex,
            .dstQueueFamilyIndex = vkQueue.familyIndex,
          };
          imageMemoryBarriers.items[idx] = imageMemoryBarrier;

          // record changes to the tape
          imageTape.tape.?.*.layout = imageTape.layout;
          imageTape.tape.?.*.accessFlags = imageTape.accessFlags;
        }

        // -- create & copy over buffer memory barriers
        var bufferMemoryBarriers = (
          std.ArrayList(vk.BufferMemoryBarrier).init(self.allocator)
        );
        defer bufferMemoryBarriers.deinit();
        try bufferMemoryBarriers.resize(action.bufferTapes.len);

        for (action.bufferTapes) |bufferTape, idx| {
          const bufferSize = (
            if (bufferTape.tape.?.length == 0) (
              context.buffers.get(bufferTape.tape.?.buffer).?.length
            ) else (
              bufferTape.tape.?.length
            )
          );
          var bufferMemoryBarrier = vk.BufferMemoryBarrier {
            .srcAccessMask = accessFlagsToVk(bufferTape.tape.?.accessFlags),
            .dstAccessMask = accessFlagsToVk(bufferTape.accessFlags),
            .srcQueueFamilyIndex = vkQueue.familyIndex,
            .dstQueueFamilyIndex = vkQueue.familyIndex,
            .buffer = self.buffers.get(bufferTape.tape.?.buffer).?,
            .offset = bufferTape.tape.?.offset,
            .size = bufferSize,
          };
          bufferMemoryBarriers.items[idx] = bufferMemoryBarrier;

          // record changes to the tape
          bufferTape.tape.?.*.accessFlags = bufferTape.accessFlags;
        }

        // -- set up pipeline barrier
        self.vkd.vkdd.cmdPipelineBarrier(
          vkCommandBuffer,
          stageFlagToVk(action.srcStage),
          stageFlagToVk(action.dstStage),
          vk.DependencyFlags { },
          0, undefined, // memory barriers
          @intCast(u32, bufferMemoryBarriers.items.len),
          bufferMemoryBarriers.items.ptr,
          @intCast(u32, imageMemoryBarriers.items.len),
          imageMemoryBarriers.items.ptr,
        );
      },
      .uploadTexelToImageMemory => |action| {
        var vkImage = self.images.get(action.imageTape.?.image).?;
        const subresourceRange = (
          vk.ImageSubresourceRange {
            .aspectMask = .{ .colorBit = true },
            .baseMipLevel = 0,
            .levelCount = 1,
            .baseArrayLayer = 0,
            .layerCount = 1,
          }
        );
        self.vkd.vkdd.cmdClearColorImage(
          vkCommandBuffer,
          vkImage.handle,
          imageLayoutToVk(action.imageTape.?.layout),
          vk.ClearColorValue { .float32 = action.rgba },
          1,
          @ptrCast([*] const vk.ImageSubresourceRange, &subresourceRange),
        );
      },
      .bindPipeline => |action| {
        self.vkd.vkdd.cmdBindPipeline(
          vkCommandBuffer,
          vk.PipelineBindPoint.compute,
          self.computePipelines.get(action.pipeline).?,
        );
      },
      .bindDescriptorSets => |action| {
        self.vkd.vkdd.cmdBindDescriptorSets(
          vkCommandBuffer,
          vk.PipelineBindPoint.compute,
          self.pipelineLayouts.get(action.pipelineLayout).?,
          0,
          1,
          @ptrCast(
            [*] const vk.DescriptorSet,
            &self.descriptorSets.get(action.descriptorSets[0])
          ),
          0, undefined,
        );
      },
      .dispatch => |action| {
        self.vkd.vkdd.cmdDispatch(
          vkCommandBuffer,
          action.width, action.height, action.depth,
        );
      },
      .dispatchIndirect => |action| {
        const vkBuffer = self.buffers.get(action.buffer).?;
        self.vkd.vkdd.cmdDispatchIndirect(
          vkCommandBuffer,
          vkBuffer,
          @intCast(u32, action.offset),
        );
      },
      .pushConstants => |action| {
        const vkPipelineLayout = (
          self.pipelineLayouts.get(action.pipelineLayout).?
        );
        self.vkd.vkdd.cmdPushConstants(
          vkCommandBuffer,
          vkPipelineLayout,
          .{ .computeBit = true, },
          0,
          @intCast(u32, action.memory.len),
          @ptrCast(* const anyopaque, action.memory.ptr),
        );
      },
    }
  }

  pub fn submitCommandBufferToQueue(
    self : * @This(),
    mtrCtx : mtr.Context,
    queue : mtr.queue.Primitive,
    commandBuffer : mtr.command.Buffer,
    sync : mtr.memory.CommandBufferSynchronization,
  ) !void {
    var vkQueue = self.queues.get(queue.contextIdx).?;
    var vkCommandBuffer = self.commandBuffers.getPtr(commandBuffer.idx).?;

    // -- map wait semaphores/stages to VK
    var vkWaitSemaphores = (
      std.ArrayList(vk.Semaphore).init(mtrCtx.primitiveAllocator)
    );
    defer vkWaitSemaphores.deinit();
    try vkWaitSemaphores.resize(sync.waitSemaphores.len);
    var vkWaitStages = (
      std.ArrayList(vk.PipelineStageFlags).init(mtrCtx.primitiveAllocator)
    );
    defer vkWaitStages.deinit();
    try vkWaitStages.resize(sync.waitSemaphores.len);
    for (sync.waitSemaphores) |wait, idx| {
      vkWaitSemaphores.items[idx] = self.semaphores.get(wait.semaphore).?;
      vkWaitStages.items[idx] = stageFlagToVk(wait.stage);
    }

    var vkWaitSemaphoresPtr : [*] const vk.Semaphore = undefined;
    if (vkWaitSemaphores.items.len > 0) {
      vkWaitSemaphoresPtr = (
        @ptrCast([*] const vk.Semaphore, vkWaitSemaphores.items.ptr)
      );
    }

    var vkWaitStagePtr : [*] const vk.PipelineStageFlags = undefined;
    if (vkWaitStages.items.len > 0) {
      vkWaitStagePtr = (
        @ptrCast([*] const vk.PipelineStageFlags, vkWaitStages.items.ptr)
      );
    }

    // -- map signal semaphores to VK
    var vkSignalSemaphores = (
      std.ArrayList(vk.Semaphore).init(mtrCtx.primitiveAllocator)
    );
    defer vkSignalSemaphores.deinit();
    try vkSignalSemaphores.resize(sync.signalSemaphores.len);
    for (sync.signalSemaphores) |signalSemaphore, idx| {
      vkSignalSemaphores.items[idx] = self.semaphores.get(signalSemaphore).?;
    }

    var vkSignalSemaphoresPtr : [*] const vk.Semaphore = undefined;
    if (vkSignalSemaphores.items.len > 0) {
      vkSignalSemaphoresPtr = (
        @ptrCast([*] const vk.Semaphore, vkSignalSemaphores.items.ptr)
      );
    }

    try self.vkd.vkdd.queueSubmit(
      vkQueue.handle,
      1,
      @ptrCast(
        [*] const vk.SubmitInfo,
        & vk.SubmitInfo {
          .waitSemaphoreCount = @intCast(u32, vkWaitSemaphores.items.len),
          .pWaitSemaphores = vkWaitSemaphoresPtr,
          .pWaitDstStageMask = vkWaitStagePtr,
          .commandBufferCount = 1,
          .pCommandBuffers = (
            @ptrCast(
              [*] const vk.CommandBuffer,
              vkCommandBuffer.buffers.items.ptr
            )
          ),
          .signalSemaphoreCount = @intCast(u32, vkSignalSemaphores.items.len),
          .pSignalSemaphores = vkSignalSemaphoresPtr,
        }
      ),
      .null_handle,
    );
  }

  pub fn deviceWaitIdle(
    self : * @This()
  ) !void {
    try self.vkd.vkdd.deviceWaitIdle(self.vkd.device);
  }

  pub fn queueFlush(
    self : * @This(),
    _ : mtr.Context,
    queue : mtr.queue.Primitive,
  ) !void {
    var vkQueue = self.queues.get(queue.contextIdx).?;
    try self.vkd.vkdd.queueWaitIdle(
      vkQueue.handle
    );

    // DEBUG
    try self.vkd.vkdd.deviceWaitIdle(self.vkd.device);
  }

  pub fn mapMemory(
    self : @This(),
    context : mtr.Context,
    memory : mtr.util.MappedMemoryRange,
  ) ! mtr.util.MappedMemory {
    var vkHeapRegion = self.heapRegions.getPtr(memory.heapRegion).?;
    var heapRegion = context.heapRegions.getPtr(memory.heapRegion).?;

    const ptr = try self.vkd.vkdd.mapMemory(
      self.vkd.device,
      vkHeapRegion.*,
      memory.offset,
      (if (memory.length == 0) heapRegion.length else memory.length),
      .{},
    );
    std.debug.assert(ptr != null);

    return mtr.util.MappedMemory {
      .ptr = @ptrCast([*] u8, ptr.?), .mapping = memory.heapRegion,
    };
  }

  pub fn unmapMemory(
    self : * @This(),
    _ : mtr.Context,
    memory : mtr.util.MappedMemory
  ) void {
    var vkHeapRegion = self.heapRegions.getPtr(memory.mapping).?;
    self.vkd.vkdd.unmapMemory(self.vkd.device, vkHeapRegion.*);
  }

  pub fn writeDescriptorSet(
    self : * @This(),
    context : mtr.Context,
    writer : mtr.descriptor.SetWriter,
  ) !void {
    const vkDescriptorSet = self.descriptorSets.get(writer.destinationSet).?;

    var descriptorWrites = (
      std.ArrayList(vk.WriteDescriptorSet).init(self.allocator)
    );
    defer descriptorWrites.deinit();
    try descriptorWrites.resize(writer.writes.items.len);

    var descriptorImageWrites = (
      std.ArrayList(vk.DescriptorImageInfo).init(self.allocator)
    );
    defer descriptorImageWrites.deinit();
    var descriptorBufferWrites = (
      std.ArrayList(vk.DescriptorBufferInfo).init(self.allocator)
    );
    defer descriptorBufferWrites.deinit();

    for (writer.writes.items) |descriptorWrite, idx| {
      var descriptorImageInfo : ? * vk.DescriptorImageInfo = null;
      var descriptorBufferInfo : ? * vk.DescriptorBufferInfo = null;

      // TODO allow multiple items

      if (descriptorWrite.imageView != null) {
        var vkDescriptorImageView = (
          self.imageViews.get(descriptorWrite.imageView.?).?
        );
        (try descriptorImageWrites.addOne()).* = .{
          .imageView = vkDescriptorImageView,
          .imageLayout = .general,
          .sampler = .null_handle, // TODO
        };
        descriptorImageInfo = (
          &descriptorImageWrites.items[descriptorImageWrites.items.len-1]
        );
      }

      if (descriptorWrite.buffer != null) {
        var mtDescriptorBuffer = (
          context.buffers.getPtr(descriptorWrite.buffer.?).?
        );
        var vkDescriptorBuffer = (
          self.buffers.get(descriptorWrite.buffer.?).?
        );
        (try descriptorBufferWrites.addOne()).* = .{
          .buffer = vkDescriptorBuffer,
          .offset = descriptorWrite.bufferOffset,
          .range = (
            if (descriptorWrite.bufferLength == 0) (
              mtDescriptorBuffer.length
            ) else (
              descriptorWrite.bufferLength
            )
          ),
        };
        descriptorBufferInfo = (
          &descriptorBufferWrites.items[descriptorBufferWrites.items.len-1]
        );
      }

      const binding = (
        writer.layout.bindingIdxToLayoutBinding.get(descriptorWrite.binding).?
      );

      descriptorWrites.items[idx] = vk.WriteDescriptorSet {
        .dstSet = vkDescriptorSet,
        .dstBinding = binding.binding,
        .dstArrayElement = 0,
        .descriptorCount = binding.count,
        .descriptorType = descriptorTypeToVk(binding.descriptorType),
        .pImageInfo = (
          if (descriptorImageInfo == null) (
            undefined
          ) else (
            @ptrCast([*] const vk.DescriptorImageInfo, descriptorImageInfo.?)
          )
        ),
        .pBufferInfo = (
          if (descriptorBufferInfo == null) (
            undefined
          ) else (
            @ptrCast([*] const vk.DescriptorBufferInfo, descriptorBufferInfo.?)
          )
        ),
        .pTexelBufferView = undefined,
      };
    }

    self.vkd.vkdd.updateDescriptorSets(
      self.vkd.device,
      @intCast(u32, descriptorWrites.items.len),
      descriptorWrites.items.ptr,
      0,
      undefined,
    );
  }

  pub fn createPipelineLayout(
    self : * @This(),
    context : mtr.Context,
    pipelineLayout : mtr.pipeline.Layout,
  ) !void {
    var descriptorSetLayouts = (
      std.ArrayList(vk.DescriptorSetLayout).init(context.primitiveAllocator)
    );
    defer descriptorSetLayouts.deinit();
    try descriptorSetLayouts.resize(pipelineLayout.descriptorSetLayouts.len);

    for (pipelineLayout.descriptorSetLayouts) |descriptorSetLayout, idx| {
      descriptorSetLayouts.items[idx] = (
        self.descriptorSetLayouts.get(descriptorSetLayout).?
      );
    }

    var pushConstantRange = vk.PushConstantRange {
      .stageFlags = .{ .computeBit = true },
      .offset = 0,
      .size = pipelineLayout.pushConstantRange,
    };

    const vkPipelineLayout = try (
      self.vkd.vkdd.createPipelineLayout(
        self.vkd.device,
        .{
          .flags = .{},
          .setLayoutCount = @intCast(u32, descriptorSetLayouts.items.len),
          .pSetLayouts = descriptorSetLayouts.items.ptr,
          .pushConstantRangeCount = std.math.min(1, pushConstantRange.size),
          .pPushConstantRanges = (
            @ptrCast([*] const vk.PushConstantRange, &pushConstantRange)
          ),
        },
        null
      )
    );

    try self.labelObject(pipelineLayout.label, vkPipelineLayout);

    try self.pipelineLayouts.putNoClobber(
      pipelineLayout.contextIdx,
      vkPipelineLayout
    );
  }

  pub fn createComputePipeline(
    self : * @This(),
    _ : mtr.Context,
    computePipeline : mtr.pipeline.Compute,
  ) !void {
    var vkComputePipeline : vk.Pipeline = .null_handle;

    const pipelineCreateInfo = vk.ComputePipelineCreateInfo {
      .flags = .{},
      .stage = .{
        .flags = .{},
        .stage = .{ .computeBit = true },
        .module = self.shaderModules.get(computePipeline.shaderModule).?,
        .pName = computePipeline.entryFnLabel,
        .pSpecializationInfo = null,
      },
      .layout = self.pipelineLayouts.get(computePipeline.layout).?,
      .basePipelineHandle = .null_handle,
      .basePipelineIndex = 0,
    };

    _ = try self.vkd.vkdd.createComputePipelines(
      self.vkd.device,
      .null_handle,
      1,
      @ptrCast([*] const vk.ComputePipelineCreateInfo, &pipelineCreateInfo),
      null,
      @ptrCast([*] vk.Pipeline, &vkComputePipeline),
    );

    try self.labelObject(computePipeline.label, vkComputePipeline);

    try self.computePipelines.putNoClobber(
      computePipeline.contextIdx,
      vkComputePipeline
    );
  }

  pub fn createSemaphore(
    self : * @This(),
    _ : mtr.Context,
    semaphore : mtr.memory.Semaphore
  ) !void {
    var vkSemaphore : vk.Semaphore = try (
      self.vkd.vkdd.createSemaphore(
        self.vkd.device,
        .{ .flags = .{}, },
        null,
      )
    );

    try self.labelObject(semaphore.label, vkSemaphore);

    try self.semaphores.putNoClobber(semaphore.contextIdx, vkSemaphore);
  }

  pub fn createFence(
    self : * @This(),
    _ : mtr.Context,
    fence : mtr.memory.Fence
  ) !void {
    var vkFence : vk.Fence = try (
      self.vkd.vkdd.createFence(
        self.vkd.device,
        .{ .flags = fence.signaled, },
        null,
      )
    );

    try self.labelObject(fence.label, vkFence);

    try self.fences.putNoClobber(fence.contextIdx, vkFence);
  }

  pub fn createSwapchain(
    self : * @This(),
    _ : mtr.Context,
    mtrSwapchain : mtr.window.Swapchain,
  ) !void {
    const vkQueue = self.queues.getPtr(mtrSwapchain.queue).?;
    var vkOldSwapchain = self.swapchains.get(mtrSwapchain.oldSwapchain);

    // TODO get this properly
    var surfaceFormat = vk.SurfaceFormatKHR {
      .format = vk.Format.b8g8r8a8Unorm,
      .colorSpace = vk.ColorSpaceKHR.srgbNonlinearKHR,
    };

    const concurrent = (
      self.vkd.deviceQueue.gtcIdx != self.vkd.deviceQueue.presentIdx
    );

    std.debug.assert(
      (
        try self.vki.getPhysicalDeviceSurfaceSupportKHR(
          self.vkd.physicalDevice,
          vkQueue.familyIndex,
          self.glfwSurface
        )
      ) == vk.TRUE
    );

    const surfaceCapabilities = try (
      self.vki.getPhysicalDeviceSurfaceCapabilitiesKHR(
        self.vkd.physicalDevice,
        self.glfwSurface,
      )
    );

    // fix the extent to capabilities of the surface
    var actualImageExtent = vk.Extent2D {
      .width = mtrSwapchain.extent[0],
      .height = mtrSwapchain.extent[1],
    };

    actualImageExtent.width = (
      std.math.clamp(
        actualImageExtent.width,
        surfaceCapabilities.minImageExtent.width,
        surfaceCapabilities.maxImageExtent.width,
      )
    );

    actualImageExtent.height = (
      std.math.clamp(
        actualImageExtent.height,
        surfaceCapabilities.minImageExtent.height,
        surfaceCapabilities.maxImageExtent.height,
      )
    );

    var vkSwapchain = try self.vkd.vkdd.createSwapchainKHR(
      self.vkd.device,
      .{
        .flags = .{},
        .surface = self.glfwSurface,
        .minImageCount = surfaceCapabilities.minImageCount,
        .imageFormat = surfaceFormat.format,
        .imageColorSpace = surfaceFormat.colorSpace,
        .imageExtent = actualImageExtent,
        .imageArrayLayers = 1,
        .imageUsage = .{ .transferDstBit = true,  },
        .imageSharingMode = if (concurrent) (.concurrent) else (.exclusive),
        .queueFamilyIndexCount = 1,
        .pQueueFamilyIndices = @ptrCast([*] const u32, &vkQueue.familyIndex),
        .preTransform = .{ .identityBitKHR = true, },
        .compositeAlpha = .{ .opaqueBitKHR = true },
        .presentMode = .immediateKHR,
        .clipped = vk.TRUE,
        .oldSwapchain = (
          if (vkOldSwapchain != null) (vkOldSwapchain.?) else (.null_handle)
        ),
      },
      null,
    );

    try self.swapchains.putNoClobber(mtrSwapchain.contextIdx, vkSwapchain);
  }

  pub fn swapchainImageCount(
    self : * @This(),
    _ : mtr.Context,
    swapchainId : mtr.window.SwapchainId,
  ) !u32 {
    const vkSwapchain = self.swapchains.get(swapchainId).?;
    var swapchainImagesCount : u32 = 0;
    _ = try self.vkd.vkdd.getSwapchainImagesKHR(
      self.vkd.device,
      vkSwapchain,
      &swapchainImagesCount,
      null
    );
    return swapchainImagesCount;
  }

  pub fn swapchainImages(
    self : * @This(),
    mtrCtx : * mtr.Context,
    swapchainId : mtr.window.SwapchainId,
    images : [] mtr.image.Idx,
  ) !void {
    // TODO i think we have to map vulkan image IDs to mtr IDs to prevent
    //      duplicates if this function is called multiple times
    const vkSwapchain = self.swapchains.get(swapchainId).?;
    var vkImages = std.ArrayList(vk.Image).init(mtrCtx.primitiveAllocator);
    try vkImages.resize(images.len);
    defer vkImages.deinit();

    var swapchainImagesCount = @intCast(u32, images.len);

    _ = try self.vkd.vkdd.getSwapchainImagesKHR(
      self.vkd.device,
      vkSwapchain,
      &swapchainImagesCount,
      @ptrCast([*] vk.Image, vkImages.items.ptr),
    );

    for (vkImages.items) |vkImage, it| {
      // update our internals to track these images, though they can't be
      // deallocated on our side
      // TODO fill out information for MTR if possible (maybe from swapchain)
      const prevIdx = mtrCtx.allocIdx;
      mtrCtx.allocIdx += 1;
      try mtrCtx.images.putNoClobber(
        prevIdx,
        mtr.image.Primitive {
          .allocatedHeapRegion = 0,
          .label = "swapchain-image-N",
          .offset = 0,
          .width = 0, .height = 0, .depth = 0,
          .samplesPerTexel = .s1,
          .arrayLayers = 1,
          .mipmapLevels = 1,
          .byteFormat = .uint8Unorm,
          .channels = .BGR,
          .usage = .{ .transferDst = true },
          .normalized = true,
          .queueSharing = .exclusive,
          .contextIdx = prevIdx,
        }
      );

      try self.images.putNoClobber(
        prevIdx,
        Image { .handle = vkImage, .partOfSwapchain = true },
      );

      try self.labelObject("swapchain-image-N", vkImage);

      images[it] = prevIdx;
    }
  }

  pub fn swapchainAcquireNextImage(
    self : * @This(),
    _ : mtr.Context,
    swapchainId : mtr.window.SwapchainId,
    semaphoreId : ? mtr.memory.SemaphoreId,
    fenceId     : ? mtr.memory.FenceId,
  ) !u32 {
    const vkSwapchain = self.swapchains.get(swapchainId).?;
    var vkSemaphore : vk.Semaphore = .null_handle;
    var vkFence     : vk.Fence    = .null_handle;

    if (semaphoreId != null) {
      vkSemaphore = self.semaphores.get(semaphoreId.?).?;
    }

    if (fenceId != null) {
      vkFence = self.fences.get(fenceId.?).?;
    }

    return (
      try self.vkd.vkdd.acquireNextImageKHR(
        self.vkd.device,
        vkSwapchain,
        1<<32, // ~4 seconds
        vkSemaphore,
        vkFence,
      )
    ).imageIndex;
  }

  pub fn queuePresent(
    self : * @This(),
    mtrCtx : mtr.Context,
    presentInfo : mtr.queue.PresentInfo,
  ) !void {
    const vkQueue = self.queues.getPtr(presentInfo.queue).?;
    const vkSwapchain = self.swapchains.get(presentInfo.swapchain).?;

    var vkWaitSemaphores = (
      std.ArrayList(vk.Semaphore).init(mtrCtx.primitiveAllocator)
    );
    defer vkWaitSemaphores.deinit();
    try vkWaitSemaphores.resize(presentInfo.waitSemaphores.len);
    for (presentInfo.waitSemaphores) |waitSemaphore, idx| {
      vkWaitSemaphores.items[idx] = self.semaphores.get(waitSemaphore).?;
    }

    var vkWaitSemaphoresPtr : [*] const vk.Semaphore = undefined;
    if (vkWaitSemaphores.items.len > 0) {
      vkWaitSemaphoresPtr = (
        @ptrCast([*] const vk.Semaphore, vkWaitSemaphores.items.ptr)
      );
    }

    _ = try self.vkd.vkdd.queuePresentKHR(
      vkQueue.handle,
      vk.PresentInfoKHR {
        .waitSemaphoreCount = @intCast(u32, vkWaitSemaphores.items.len),
        .pWaitSemaphores = vkWaitSemaphoresPtr,
        .swapchainCount = 1,
        .pSwapchains = @ptrCast([*] const vk.SwapchainKHR, &vkSwapchain),
        .pImageIndices = @ptrCast([*] const u32, &presentInfo.imageIndex),
        .pResults = null,
      },
    );
  }


  // TODO maybe I should pull GLFW out bc this shouldn't be here

  pub fn shouldWindowClose(self : *@This()) bool {
    return glfw.c.glfwWindowShouldClose(self.glfwWindow) > 0;
  }

  pub fn pollEvents(_ : * @This()) void {
    glfw.c.glfwPollEvents();
  }

  // -- utils ------------------------------------------------------------------
  pub fn createHeapRegionAllocator(
    self : * @This(),
    visibility : mtr.heap.Visibility,
  ) mtr.util.HeapRegionAllocator {
    return mtr.util.HeapRegionAllocator.init(self, visibility);
  }
};
