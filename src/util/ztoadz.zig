//! Module provides vulkan utility for zTOADz

const glfw          = @import("../third-party/glfw.zig");
const vk_dispatcher = @import("../third-party/vulkan-dispatchers.zig");
const vk            = @import("../third-party/vulkan.zig");
const vk_logger     = @import("vulkan-logger.zig");
const config        = @import("config.zig");

const std    = @import("std");
const assert = std.debug.assert;

pub fn zeroInitInPlace(ptr : anytype) void {
  ptr.* = std.mem.zeroInit(std.meta.Child(@TypeOf(ptr)), .{});
}

pub const VulkanDeviceQueues = struct {
  computeIdx : u32 = 0,
  graphicsIdx : u32 = 0,
  presentIdx : u32 = 0,
  transferIdx : u32 = 0,
  gtcIdx : u32 = 0,
};

pub const VulkanDeviceQueue = struct {
  handle : vk.Queue,
  family : u32,

  fn init(vkd : VulkanDeviceContext, family : u32) @This() {
    return .{
      .handle = vkd.vkdd.getDeviceQueue(vkd.device, family, 0)
    , .family = family
    };
  }
};

pub const VulkanCommandPool = struct {
  pool : vk.CommandPool,
  vkd : * const VulkanDeviceContext,

  pub fn init(
    vkd : * const VulkanDeviceContext, createInfo : vk.CommandPoolCreateInfo
  )
    !@This()
  {
    return @This() {
      .pool = try vkd.vkdd.createCommandPool(vkd.device, createInfo, null),
      .vkd = vkd,
    };
  }

  pub fn deinit(self : @This()) void {
    self.vkd.vkdd.destroyCommandPool(self.vkd.device, self.pool, null);
  }
};

pub const VulkanCommandBuffer = struct {
  buffers : std.ArrayList(vk.CommandBuffer),
  commandPool : vk.CommandPool,
  vkd : * const VulkanDeviceContext,

  pub fn init(
    allocator : * std.mem.Allocator,
    vkd : * const VulkanDeviceContext,
    allocateInfo : vk.CommandBufferAllocateInfo,
    label : [*:0] const u8,
  ) !@This() {
    var self = @This() {
      .buffers = std.ArrayList(vk.CommandBuffer).init(allocator),
      .commandPool = allocateInfo.commandPool,
      .vkd = vkd
    };

    try self.buffers.resize(allocateInfo.commandBufferCount);

    try vkd.vkdd.allocateCommandBuffers(
      vkd.device, allocateInfo
    , @ptrCast([*] vk.CommandBuffer, self.buffers.items)
    );

    try self.vkd.vkdd.setDebugUtilsObjectNameEXT(
      self.vkd.device,
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType = vk.ObjectType.command_pool,
        .objectHandle = @bitCast(u64, self.commandPool),
        .pObjectName = label,
      },
    );

    return self;
  }

  pub fn deinit(self : @This()) void {
    self.vkd.vkdd.freeCommandBuffers(
      self.vkd.device, self.commandPool,
      @intCast(u32, self.buffers.items.len),
      self.buffers.items.ptr,
    );

    self.buffers.deinit();
  }
};

pub const VulkanSwapchainImage = struct {
  image : vk.Image,
  view : vk.ImageView,
  semaphoreImageAcquired : vk.Semaphore,
  semaphoreRenderFinished : vk.Semaphore,
  fenceFrame : vk.Fence,
  vkd : * const VulkanDeviceContext,

  pub fn init(
    vkd : * const VulkanDeviceContext, image : vk.Image, format : vk.Format
  ) !@This() {
    const view =
      try vkd.vkdd.createImageView(
        vkd.device
      , .{
          .flags = .{}
        , .image = image
        , .viewType = .i2d
        , .format = format
        , .components = .{
            .r = .identity, .g = .identity, .b = .identity, .a = .identity
          }
        , .subresourceRange = .{
            .aspectMask = .{.color_bit = true}
          , .baseMipLevel = 0
          , .levelCount = 1
          , .baseArrayLayer = 0
          , .layerCount = 1
          }
        }
      , null
      );
    errdefer vkd.vkdd.destroyImageView(vkd.device, view, null);

    const semaphoreImageAcquired =
      try vkd.vkdd.createSemaphore(vkd.device, .{.flags = .{}}, null);

    errdefer
      vkd.vkdd.destroySemaphore(
        vkd.device, semaphoreImageAcquired, null
      );

    const semaphoreRenderFinished =
      try vkd.vkdd.createSemaphore(vkd.device, .{.flags = .{}}, null);

    errdefer
      vkd.vkdd.destroySemaphore(
        vkd.device, semaphoreRenderFinished, null
      );

    const fenceFrame =
      try vkd.vkdd.createFence(
        vkd.device, .{.flags = .{.signaled_bit = true}}, null
      );
    errdefer vkd.vkdd.destroyFence(vkd.device, fenceFrame, null);

    return VulkanSwapchainImage {
      .image = image
    , .view = view
    , .semaphoreImageAcquired = semaphoreImageAcquired
    , .semaphoreRenderFinished = semaphoreRenderFinished
    , .fenceFrame = fenceFrame
    , .vkd = vkd
    };
  }

  pub fn deinit(self : @This()) void {
    if (self.semaphoreImageAcquired != .null_handle)
      self.vkd.vkdd.destroySemaphore(
        self.vkd.device, self.semaphoreImageAcquired, null
      );

    if (self.semaphoreRenderFinished != .null_handle)
      self.vkd.vkdd.destroySemaphore(
        self.vkd.device, self.semaphoreRenderFinished, null
      );

    if (self.fenceFrame != .null_handle)
      self.vkd.vkdd.destroyFence(
        self.vkd.device, self.fenceFrame, null
      );

    self.vkd.vkdd.destroyImageView(self.vkd.device, self.view, null);
  }

  pub fn WaitForFence(self : @This(), vkd : VulkanDeviceContext) !void {
    _ =
      try vkd.vkdd.waitForFences(
        vkd.device, 1, @ptrCast([*] const vk.Fence, &self.fenceFrame)
      , vk.TRUE, std.math.maxInt(u64)
      );
  }
};

pub const VulkanSwapchain = struct {

  capabilities : vk.SurfaceCapabilitiesKHR,
  format : vk.SurfaceFormatKHR,
  presentMode : vk.PresentModeKHR,
  extent : vk.Extent2D,
  swapchain : vk.SwapchainKHR,

  swapImages : std.ArrayList(VulkanSwapchainImage),
  imageIdx : u32,
  nextImageAcquired : vk.Semaphore,

  vkd : * const VulkanDeviceContext,

  pub fn reinit(
    allocator : * std.mem.Allocator
  , vki : vk_dispatcher.VulkanInstanceDispatch
  , surface : vk.SurfaceKHR
  , vkd : * const VulkanDeviceContext
  , extent : vk.Extent2D
  , oldSwapchainHandle : vk.SwapchainKHR
  ) !@This() {

    // query swapchain support
    var capabilities =
      try vki.getPhysicalDeviceSurfaceCapabilitiesKHR(
        vkd.physicalDevice, surface
      );

    // query swapchain format
    var surfaceFormat : vk.SurfaceFormatKHR = undefined;
    {
      var formats = std.ArrayList(vk.SurfaceFormatKHR).init(allocator);
      defer formats.deinit();

      var formatLen : u32 = 0;
      _ = try vki.getPhysicalDeviceSurfaceFormatsKHR(
        vkd.physicalDevice, surface, &formatLen, null
      );
      try formats.resize(formatLen);
      _ = try vki.getPhysicalDeviceSurfaceFormatsKHR(
        vkd.physicalDevice, surface, &formatLen, formats.items.ptr
      );

      surfaceFormat = SelectSurfaceFormat(formats.items);
    }

    // query present mode
    var presentMode : vk.PresentModeKHR = undefined;
    {
      var presentModes = std.ArrayList(vk.PresentModeKHR).init(allocator);
      defer presentModes.deinit();

      var presentModeLen : u32 = 0;
      _ = try vki.getPhysicalDeviceSurfacePresentModesKHR(
        vkd.physicalDevice, surface, &presentModeLen, null
      );
      try presentModes.resize(presentModeLen);
      _ = try vki.getPhysicalDeviceSurfacePresentModesKHR(
        vkd.physicalDevice, surface, &presentModeLen, presentModes.items.ptr
      );

      presentMode = SelectPresentMode(presentModes.items);
    }

    // select extent within system constraints
    var actualExtent = SelectSwapExtent(capabilities, extent);

    // select number of swapchain images
    var imageCount : u32 = capabilities.minImageCount + 1;
    if (
      capabilities.maxImageCount > 0
      and imageCount > capabilities.maxImageCount
    ) {
      imageCount = capabilities.maxImageCount;
    }

    //
    const concurrent = vkd.queueGTC.family != vkd.queuePresent.family;
    const queueFamilyIndices = [_] u32 {
      vkd.queueGTC.family, vkd.queuePresent.family
    };

    // spec states:
    //   After successfully recreating a VkDevice, the same VkSurfaceKHR can be
    //   used to create a new VkSwapchainKHR, provided the previous one was
    //   destroyed
    // Thus the surface component of a swapchain can be reused
    // chap34.html#VkSwapchainCreateInfoKHR

    const handle = try vkd.vkdd.createSwapchainKHR(
      vkd.device
    , .{
        .flags = .{}
      , .surface = surface
      , .minImageCount = imageCount
      , .imageFormat = surfaceFormat.format
      , .imageColorSpace = surfaceFormat.colorSpace
      , .imageExtent = actualExtent
      , .imageArrayLayers = 1
      , .imageUsage = .{.color_attachment_bit = true, .transfer_dst_bit = true}
      , .imageSharingMode = if (concurrent) .concurrent else .exclusive
      , .queueFamilyIndexCount = queueFamilyIndices.len
      , .pQueueFamilyIndices = &queueFamilyIndices
      , .preTransform = capabilities.currentTransform
      , .compositeAlpha = .{.opaque_bit_khr = true}
      , .presentMode = presentMode
      , .clipped = vk.TRUE
      , .oldSwapchain = oldSwapchainHandle
      }
    , null
    );

    if (oldSwapchainHandle != .null_handle) {
      vkd.vkdd.destroySwapchainKHR(vkd.device, oldSwapchainHandle, null);
    }

    var swapImages = std.ArrayList(VulkanSwapchainImage).init(allocator);
    errdefer swapImages.deinit();

    { // init swapchain images
      var count : u32 = 0;
      _ = try vkd.vkdd.getSwapchainImagesKHR(vkd.device, handle, &count, null);
      const images = try allocator.alloc(vk.Image, count);
      defer allocator.free(images);
      _ = try vkd.vkdd.getSwapchainImagesKHR(
        vkd.device, handle, &count, images.ptr
      );

      try swapImages.resize(count);

      var i : usize = 0;
      errdefer for (swapImages.items[0 .. i]) |si| si.deinit();

      for (images) |image| {
        swapImages.items[i] =
          try VulkanSwapchainImage.init(vkd, image, surfaceFormat.format);
        i += 1;
      }
    }

    var nextImageAcquired =
      try vkd.vkdd.createSemaphore(vkd.device, .{.flags = .{}}, null);
    errdefer vkd.vkdd.destroySemaphore(vkd.device, nextImageAcquired, null);

    var imageResult = 
      try vkd.vkdd.acquireNextImageKHR(
        vkd.device, handle, std.math.maxInt(u64)
      , nextImageAcquired, .null_handle
      );

    if (imageResult.result != .success) return error.ImageAcquireFailed;

    // swap semaphore for image acquired
    std.mem.swap(
      vk.Semaphore
    , &swapImages.items[imageResult.imageIndex].semaphoreImageAcquired
    , &nextImageAcquired
    );

    return @This() {
      .capabilities = capabilities
    , .format = surfaceFormat
    , .presentMode = presentMode
    , .extent = actualExtent
    , .swapchain = handle
    , .swapImages = swapImages
    , .imageIdx = imageResult.imageIndex
    , .nextImageAcquired = nextImageAcquired
    , .vkd = vkd
    };
  }

  pub fn init(
    allocator : * std.mem.Allocator
  , vki : vk_dispatcher.VulkanInstanceDispatch
  , surface : vk.SurfaceKHR
  , vkd : * const VulkanDeviceContext
  , extent : vk.Extent2D
  ) !@This() {
    return try reinit(allocator, vki, surface, vkd, extent, .null_handle);
  }

  pub fn deinit(self : @This()) void {
    self.vkd.vkdd.destroySwapchainKHR(self.vkd.device, self.swapchain, null);
    for (self.swapImages.items) |swapImage| swapImage.deinit();
    self.swapImages.deinit();

    self.vkd.vkdd.destroySemaphore(
      self.vkd.device, self.nextImageAcquired, null
    );
  }

  pub fn CurrentImage(self : @This()) vk.Image {
    return self.swapImages[self.imageIdx].image;
  }

  pub fn CurrentSwapImage(self : @This()) * const VulkanSwapchainImage {
    return &self.swapImages[self.imageIdx];
  }

  pub const PresentState = enum {
    optimal, suboptimal
  };

  pub fn PerformSwap(
    self : * @This(), cmdbuf : vk.CommandBuffer, vkd : VulkanDeviceContext
  ) !PresentState
  {
    // wait for / reset fence of acquired image
    //
    const current = self.CurrentSwapImage();
    try current.WaitForFence(vkd);
    try vkd.vkdd.resetFences(
      vkd.device, 1, @ptrCast([*] const vk.Fence, &current.fenceFrame)
    );

    // submit command buffer
    const waitStage = [_]vk.PipelineStageFlags {.{.top_of_pipe_bit = true}};
    try vkd.queueSubmit(
      vkd.queueGTC.handle
    , 1
    , &[_]vk.SubmitInfo {.{
        .waitSemaphoreCount = 1
      , .pWaitSemaphores =
          @ptrCast([*] const vk.Semaphore, &current.semaphoreImageAcquired)
      , .pWaitDstStageMask = &waitStage
      , .commandBufferCount = 1
      , .pCommandBuffers = @ptrCast([*] const vk.CommandBuffer, &cmdbuf)
      , .signalSemaphoreCount = 1
      , .pSignalSemaphores =
          @ptrCast([*] const vk.Semaphore, &current.semaphoreRenderFinished)
      }}
    , current.fenceFrame
    );

    // present frame
    _ = try vkd.vkdd.queuePresentKHR(
      vkd.vkdd.queuePresent.handle
    , vk.PresentInfoKHR {
        .waitSemaphoreCount = 1
      , .pWaitSemaphores = @ptrCast(
          [*] const vk.Semaphore, &current.semaphoreRenderFinished
        )
      , .swapchainCount = 1
      , .pSwapchains = @ptrCast([*] const vk.SwapchainKHR, &self.swapchain)
      , .pImageIndices = @ptrCast([*] const u32, &self.imageIdx)
      , .pResults = null
      }
    );

    // acquire next frame
    const result = vkd.vkdd.acquireNextImageKHR(
      vkd.device
    , self.swapchain
    , std.math.maxInt(u64)
    , self.nextImageAcquired
    , .null_handle
    );

    std.mem.swap(
      vk.Semaphore
    , &self.swapImages[result.imageIndex], &self.nextImageAcquired
    );

    return switch(result.result) {
      .success => .optimal
    , .suboptimal_khr => .suboptimal
    , else => unreachable
    };
  }

  fn SelectSwapExtent(
    capabilities : vk.SurfaceCapabilitiesKHR
  , requestedExtent : vk.Extent2D
  )
    vk.Extent2D
  {
    if (capabilities.currentExtent.width != std.math.maxInt(u32)) {
      return capabilities.currentExtent;
    }
    var actualExtent = requestedExtent;

    actualExtent.width =
      std.math.clamp(
        actualExtent.width
      , capabilities.minImageExtent.width
      , capabilities.maxImageExtent.width
      );

    actualExtent.height =
      std.math.clamp(
        actualExtent.height
      , capabilities.minImageExtent.height
      , capabilities.maxImageExtent.height
      );

    return actualExtent;
  }

  fn SelectPresentMode(presentModes : [] vk.PresentModeKHR)
    vk.PresentModeKHR
  {
    var bestMode = vk.PresentModeKHR.fifo_khr;

    for (presentModes) |mode| {
      if (mode == vk.PresentModeKHR.mailbox_khr) { return mode; }
      if (mode == vk.PresentModeKHR.immediate_khr) { bestMode = mode; }
    }

    return bestMode;
  }

  fn SelectSurfaceFormat(formats: [] vk.SurfaceFormatKHR)
    vk.SurfaceFormatKHR
  {
    if (formats.len == 1 and formats[0].format == vk.Format.undefined_) {
      return vk.SurfaceFormatKHR {
        .format = vk.Format.b8g8r8a8_unorm
      , .colorSpace = vk.ColorSpaceKHR.srgb_nonlinear_khr
      };
    }

    for (formats) |format| {
      if (
        format.format == vk.Format.b8g8r8a8_unorm
        and format.colorSpace == vk.ColorSpaceKHR.srgb_nonlinear_khr
      ) {
        return format;
      }
    }

    return formats[0];
  }
};

/// graphics context for a device backing the current application
pub const VulkanDeviceContext = struct {

  physicalDevice : vk.PhysicalDevice,
  device : vk.Device,
  vkdd : vk_dispatcher.VulkanDeviceDispatch,
  physicalDeviceProperties : vk.PhysicalDeviceProperties,
  physicalDeviceProperties11 : vk.PhysicalDeviceVulkan11Properties,
  physicalDeviceProperties12 : vk.PhysicalDeviceVulkan12Properties,
  physicalDevicePropertiesMeshShader : vk.PhysicalDeviceMeshShaderPropertiesNV,
  physicalDeviceMemoryProperties : vk.PhysicalDeviceMemoryProperties,
  physicalDeviceMemoryBudgetProperties :
    vk.PhysicalDeviceMemoryBudgetPropertiesEXT,
  queueFamilyProperties : std.ArrayList(vk.QueueFamilyProperties),

  deviceQueue : VulkanDeviceQueues,
  // queueGraphics : VulkanDeviceQueue,
  queuePresent : VulkanDeviceQueue,
  queueGTC : VulkanDeviceQueue,

  pub fn init(
    allocator : * std.mem.Allocator
  , vki : vk_dispatcher.VulkanInstanceDispatch
  , physicalDevice : vk.PhysicalDevice
  , deviceExtensions : [] const [*:0] const u8
  ) !@This() {
    var self : @This() = undefined;
    self.physicalDevice = physicalDevice;

    // get physical device properties
    vki.vkGetPhysicalDeviceProperties(
      self.physicalDevice, &self.physicalDeviceProperties
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
    self.physicalDeviceProperties11.sType =
      vk.StructureType.physical_device_vulkan_1_1_properties;
    self.physicalDeviceProperties12.sType =
      vk.StructureType.physical_device_vulkan_1_2_properties;
    self.physicalDevicePropertiesMeshShader.sType =
      vk.StructureType.physical_device_mesh_shader_properties_nv;

    self.physicalDeviceProperties11.pNext = &self.physicalDeviceProperties12;
    self.physicalDeviceProperties12.pNext =
      &self.physicalDevicePropertiesMeshShader;
    self.physicalDevicePropertiesMeshShader.pNext = null;

    vki.vkGetPhysicalDeviceProperties2(
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

      physicalDeviceMemoryProperties.sType =
        vk.StructureType.physical_device_memory_properties_2
      ;

      self.physicalDeviceMemoryBudgetProperties.sType =
        vk.StructureType.physical_device_memory_budget_properties_ext
      ;

      self.physicalDeviceMemoryBudgetProperties.pNext = null;
      physicalDeviceMemoryProperties.pNext =
        &self.physicalDeviceMemoryBudgetProperties
      ;

      vki.vkGetPhysicalDeviceMemoryProperties2(
        self.physicalDevice, &physicalDeviceMemoryProperties
      );

      self.physicalDeviceMemoryProperties =
        physicalDeviceMemoryProperties.memoryProperties;
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

    vki.vkGetPhysicalDeviceQueueFamilyProperties(
      self.physicalDevice
    , &queueFamilyPropertyLen
    , self.queueFamilyProperties.items.ptr
    );

    // log queue family properties and record the device queue indices
    self.deviceQueue = VulkanDeviceQueues {};
    for (self.queueFamilyProperties.items) |properties, i| {
      const family = @intCast(u32, i);

      // vk_logger.QueueFamilyProperties(properties, i);

      if (properties.queueFlags.contains(.{.graphics_bit = true})) {
        self.deviceQueue.graphicsIdx = family;
      }

      if (properties.queueFlags.contains(.{.compute_bit = true})) {
        self.deviceQueue.computeIdx = family;
      }

      // TODO check for getPhysicalDeviceSurfaceSupportKHR
      // if (properties.queueFlags.contains(.{.graphics_bit = true})) {
      //   (try self.deviceQueue.presentIndices.addOne()).* = family;
      // }

      if (properties.queueFlags.contains(.{.transfer_bit = true})) {
        self.deviceQueue.transferIdx = family;
      }

      if (
        properties.queueFlags.contains(
          .{.transfer_bit = true, .compute_bit = true, .graphics_bit = true})
      ) {
        self.deviceQueue.gtcIdx = family;
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
    // , .{
    //     .flags = .{}
    //   , .queueFamilyIndex = self.deviceQueue.transferIdx
    //   , .queueCount = 1
    //   , .pQueuePriorities = &priority
    //   }
    };

    const queueCount = 3;

    var featureBufferDeviceAddress :
      vk.PhysicalDeviceBufferDeviceAddressFeatures = undefined;

    var features = vk.PhysicalDeviceFeatures2 {
      .pNext = &featureBufferDeviceAddress,
      .features = undefined,
    };

    zeroInitInPlace(&featureBufferDeviceAddress);
    zeroInitInPlace(&features.features);

    featureBufferDeviceAddress.sType =
      .physical_device_buffer_device_address_features;

    vki.getPhysicalDeviceFeatures2(
      self.physicalDevice,
      &features
    );
    assert(featureBufferDeviceAddress.bufferDeviceAddress == vk.TRUE);
    zeroInitInPlace(&features.features);

    featureBufferDeviceAddress.bufferDeviceAddress              = vk.TRUE;
    featureBufferDeviceAddress.bufferDeviceAddressMultiDevice   = vk.FALSE;
    featureBufferDeviceAddress.bufferDeviceAddressCaptureReplay = vk.FALSE;

    self.device = try vki.createDevice(
      self.physicalDevice
    , .{
        .flags = .{},
        .pNext = &features,
        .queueCreateInfoCount = deviceQueueCreateInfo.len,
        .pQueueCreateInfos = &deviceQueueCreateInfo,
        .enabledLayerCount = 0,
        .ppEnabledLayerNames = undefined,
        .enabledExtensionCount = @intCast(u32, deviceExtensions.len),
        .ppEnabledExtensionNames = deviceExtensions.ptr,
          // @ptrCast([*] const [*:0] const u8, deviceExtensions.items[0])
        .pEnabledFeatures = null,
      }
    , null
    );

    self.vkdd = try
      vk_dispatcher.VulkanDeviceDispatch.load(
        self.device, vki.vkGetDeviceProcAddr
      );

    errdefer self.vkdd.destroyDevice(self.device, null);

    // self.queueGraphics =
    //   VulkanDeviceQueue.init(self, self.deviceQueue.graphicsIdx);

    self.queueGTC =
      VulkanDeviceQueue.init(self, self.deviceQueue.gtcIdx);

    self.queuePresent =
      VulkanDeviceQueue.init(self, self.deviceQueue.presentIdx);

    return self;
  }

  pub fn deinit(self : @This()) void {
    std.log.info("Destroying device...\n", .{});
    self.vkdd.destroyDevice(self.device, null);
    self.queueFamilyProperties.deinit();
  }
};

/// graphics context for the application; supports multiple devices, multiple
/// threads, etc
pub const VulkanAppContext = struct {

  instance : vk.Instance,
  vkb : vk_dispatcher.VulkanBaseDispatch,
  vki : vk_dispatcher.VulkanInstanceDispatch,
  devices : std.ArrayList(VulkanDeviceContext),
  // surface : vk.SurfaceKHR,
  // swapchain : VulkanSwapchain, // owned by first device

  pub fn init(
    allocator : * std.mem.Allocator,
    // window : * glfw.GLFWwindow,
    deviceExtensions : [] const [*:0] const u8,
    instanceCreatePNext : * const c_void
  )
    !@This()
  {
    const vkb = try
      vk_dispatcher.VulkanBaseDispatch.load(glfw.glfwGetInstanceProcAddress);
    const instance =
      try @This().ConstructInstance(vkb, allocator, instanceCreatePNext);
    const vki =
      try vk_dispatcher.VulkanInstanceDispatch.load(
        instance, glfw.glfwGetInstanceProcAddress
      );
    errdefer vki.destroyInstance(instance, null);
    const devices =
      try ConstructDevices(allocator, vki, instance, deviceExtensions);
    errdefer {
      for (devices.items) |device| device.deinit();
      devices.deinit();
    }

    // for now, the window surface is owned by the first device
    // var surface : vk.SurfaceKHR = undefined;
    // if (
    //   glfw.glfwCreateWindowSurface(
    //     instance, window, null, &surface
    //   ) != .success
    // ) {
    //   return error.FailedToCreateWindowSurface;
    // }

    // errdefer vki.destroySurfaceKHR(instance, surface, null);

    // const swapchain =
    //   try VulkanSwapchain.init(
    //     allocator, vki, surface, &devices.items[0]
    //   , .{ .width = 800, .height = 600}
    //   );
    // errdefer swapchain.deinit();

    return VulkanAppContext {
      .instance = instance
    , .vkb = vkb
    , .vki = vki
    , .devices = devices
    // , .surface = surface
    // , .swapchain = swapchain
    };
  }

  pub fn deinit(self : @This()) void {
    // -- deinit device-related info
    // self.swapchain.deinit();

    // -- deinit devices
    std.log.info("Deiniting device {}", .{self.devices.items});
    for (self.devices.items) |device| device.deinit();
    self.devices.deinit();

    // -- deinit instance
    // if (self.surface != .null_handle)
    //   self.vki.destroySurfaceKHR(self.instance, self.surface, null);

    if (self.instance != .null_handle)
      self.vki.destroyInstance(self.instance, null);
  }

  fn ConstructInstance(
    vkb : vk_dispatcher.VulkanBaseDispatch, allocator : * std.mem.Allocator,
    instanceCreatePNext : * const c_void
  ) !vk.Instance {
    const appInfo = vk.ApplicationInfo {
      .pApplicationName = "zTOADz"
    , .applicationVersion = vk.makeVersion(1, 0, 0)
    , .pEngineName = "zTOADz"
    , .engineVersion = vk.makeVersion(1, 0, 0)
    , .apiVersion = vk.API_VERSION_1_2
    , .pNext = null
    };

    const validatedFeatures = [_] vk.ValidationFeatureEnableEXT {
      vk.ValidationFeatureEnableEXT.gpu_assisted_ext
    , vk.ValidationFeatureEnableEXT.gpu_assisted_reserve_binding_slot_ext
    , vk.ValidationFeatureEnableEXT.best_practices_ext
    , vk.ValidationFeatureEnableEXT.debug_printf_ext
    // , vk.ValidationFeatureEnableEXT.synchronization_validation_ext
    };

    var validationFeatures = vk.ValidationFeaturesEXT {
      .enabledValidationFeatureCount = validatedFeatures.len
    , .pEnabledValidationFeatures = &validatedFeatures
    , .disabledValidationFeatureCount = 0
    , .pDisabledValidationFeatures = undefined
    , .pNext = null
    };

    var glfwExtensionLength : u32 = 0;
    const glfwExtensions =
      glfw.glfwGetRequiredInstanceExtensions(&glfwExtensionLength);

    var instanceExtensions = std.ArrayList([*:0] const u8).init(allocator);
    defer instanceExtensions.deinit();

    // copy GLFW extensions
    {
      var extI : u32 = 0;
      while (extI < glfwExtensionLength) : (extI += 1) {
        (try instanceExtensions.addOne()).* = glfwExtensions[extI];
      }
    }

    // add our own extensions
    const debugReportInstanceExt : [*:0] const u8 = "VK_EXT_debug_utils";
    (try instanceExtensions.addOne()).* = debugReportInstanceExt;


    // -- create instance
    var instance : vk.Instance = undefined;

    var layers = [_][*:0] const u8 {
      "VK_LAYER_KHRONOS_validation",
    };

    const instanceCreateInfo = vk.InstanceCreateInfo {
      .flags = vk.InstanceCreateFlags.fromInt(0),
      .pApplicationInfo = &appInfo,
      .enabledLayerCount = 1,
      .ppEnabledLayerNames = @ptrCast([*] const [*:0] const u8, &layers),
      .enabledExtensionCount = @intCast(u32, instanceExtensions.items.len),
      .ppEnabledExtensionNames =
        @ptrCast([*] const [*:0] const u8, instanceExtensions.items),
      .pNext = @ptrCast(* const c_void, instanceCreatePNext),
    };

    return try vkb.createInstance(instanceCreateInfo, null);
  }

  fn ConstructDevices(
    allocator : * std.mem.Allocator
  , vki : vk_dispatcher.VulkanInstanceDispatch
  , instance : vk.Instance
  , deviceExtensions : [] const [*:0] const u8
  )
    !std.ArrayList(VulkanDeviceContext)
  {
    var devices = std.ArrayList(VulkanDeviceContext).init(allocator);

    var deviceLen : u32 = undefined;
    _ = try vki.enumeratePhysicalDevices(instance, &deviceLen, null);

    const physicalDevices = try allocator.alloc(vk.PhysicalDevice, deviceLen);
    defer allocator.free(physicalDevices);

    _ = try
      vki.enumeratePhysicalDevices(
        instance, &deviceLen, physicalDevices.ptr
      );

    try devices.resize(deviceLen);
    for (physicalDevices) |physicalDevice, it| {
      // TODO check if the device is suitable for this application

      var extensions = std.ArrayList(vk.ExtensionProperties).init(allocator);
      defer extensions.deinit();

      var extensionLen : u32 = undefined;
      _ = try vki.enumerateDeviceExtensionProperties(
        physicalDevice, null, &extensionLen, null
      );

      try extensions.resize(extensionLen);
      _ = try vki.enumerateDeviceExtensionProperties(
        physicalDevice, null, &extensionLen, extensions.items.ptr
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
          _ = std.c.printf(
            "ERROR: req extension '%s' doesn't exist!\n", extReq
          );
        }
      }

      devices.items[it] = try
        VulkanDeviceContext.init(
          allocator, vki, physicalDevice, deviceExtensions
        );
    }

    return devices;
  }
};

/// cast any slice/list/array into C ptr for Vulkan consumption
pub fn PtrCast(items : anytype) [*] @TypeOf(items[0]) {
  return @ptrCast([*] @TypeOf(items[0]), &items[0]);
}

/// cast any slice/list/array into C ptr for Vulkan consumption
pub fn PtrConstCast(items : anytype) [*] const @TypeOf(items[0]) {
  return @ptrCast([*] const @TypeOf(items[0]), &items[0]);
}
