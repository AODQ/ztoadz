const mtr = @import("../../package.zig");
const std = @import("std");

const glfw = @import("glfw.zig");
const vkDispatcher = @import("vulkan-dispatchers.zig");
const vk = @import("../../../bindings/vulkan.zig");
const context = @import("context.zig");

// TODO maybe at some point surface this thru MTR instead of hiding it,
// but it's such a chore to set up and there really is minimal configuration
// an application would want

pub const VulkanSwapchain = struct {

  capabilities : vk.SurfaceCapabilitiesKHR,
  format : vk.SurfaceFormatKHR,
  presentMode : vk.PresentModeKHR,
  extent : vk.Extent2D,
  swapchain : vk.SwapchainKHR,

  swapImages : std.ArrayList(VulkanSwapchainImage),
  imageIdx : u32,
  nextImageAcquired : vk.Semaphore,

  vkd : * const context.VulkanDeviceContext,

  pub fn reinit(
    allocator : std.mem.Allocator
  , vki : vkDispatcher.VulkanInstanceDispatch
  , surface : vk.SurfaceKHR
  , vkd : * const context.VulkanDeviceContext
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
    const concurrent = vkd.deviceQueue.gtcIdx != vkd.deviceQueue.presentIdx;
    const queueFamilyIndices = [_] u32 {
      vkd.deviceQueue.gtcIdx, vkd.deviceQueue.presentIdx
    };

    // spec states:
    //   After successfully recreating a VkDevice, the same VkSurfaceKHR can be
    //   used to create a new VkSwapchainKHR, provided the previous one was
    //   destroyed
    // Thus the surface component of a swapchain can be reused
    // chap34.html#VkSwapchainCreateInfoKHR

    for (queueFamilyIndices) |qfi| {
      std.debug.assert(
        (try vki.getPhysicalDeviceSurfaceSupportKHR(
          vkd.physicalDevice,
          qfi,
          surface,
        )) == vk.TRUE
      );
    }

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
      , .imageUsage = .{.colorAttachmentBit = true, .transferDstBit = true}
      , .imageSharingMode = if (concurrent) .concurrent else .exclusive
      , .queueFamilyIndexCount = queueFamilyIndices.len
      , .pQueueFamilyIndices = &queueFamilyIndices
      , .preTransform = capabilities.currentTransform
      , .compositeAlpha = .{.opaqueBitKHR = true}
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
    allocator : std.mem.Allocator
  , vki : vkDispatcher.VulkanInstanceDispatch
  , surface : vk.SurfaceKHR
  , vkd : * const context.VulkanDeviceContext
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
    self : * @This(),
    cmdbuf : vk.CommandBuffer,
    vkd : context.VulkanDeviceContext
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
    const waitStage = [_]vk.PipelineStageFlags {.{.topOfPipeBit = true}};
    try vkd.queueSubmit(
      vkd.deviceQueue.gtcIdx
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
    var bestMode = vk.PresentModeKHR.fifoKHR;

    for (presentModes) |mode| {
      if (mode == vk.PresentModeKHR.mailboxKHR) { return mode; }
      if (mode == vk.PresentModeKHR.immediateKHR) { bestMode = mode; }
    }

    return bestMode;
  }

  fn SelectSurfaceFormat(formats: [] vk.SurfaceFormatKHR)
    vk.SurfaceFormatKHR
  {
    if (formats.len == 1 and formats[0].format == vk.Format.@"undefined") {
      return vk.SurfaceFormatKHR {
        .format = vk.Format.b8g8r8a8Unorm
      , .colorSpace = vk.ColorSpaceKHR.srgbNonlinearKHR
      };
    }

    for (formats) |format| {
      if (
        format.format == vk.Format.b8g8r8a8Unorm
        and format.colorSpace == vk.ColorSpaceKHR.srgbNonlinearKHR
      ) {
        return format;
      }
    }

    return formats[0];
  }
};

pub const VulkanSwapchainImage = struct {
  image : vk.Image,
  view : vk.ImageView,
  semaphoreImageAcquired : vk.Semaphore,
  semaphoreRenderFinished : vk.Semaphore,
  fenceFrame : vk.Fence,
  vkd : * const context.VulkanDeviceContext,

  pub fn init(
    vkd : * const context.VulkanDeviceContext,
    image : vk.Image,
    format : vk.Format
  ) !@This() {
    const view =
      try vkd.vkdd.createImageView(
        vkd.device
      , .{
          .flags = .{}
        , .image = image
        , .viewType = .@"2D"
        , .format = format
        , .components = .{
            .r = .identity, .g = .identity, .b = .identity, .a = .identity
          }
        , .subresourceRange = .{
            .aspectMask = .{.colorBit = true}
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
        vkd.device, .{.flags = .{.signaledBit = true}}, null
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

  pub fn WaitForFence(self : @This(), vkd : context.VulkanDeviceContext) !void {
    _ = (
      try vkd.vkdd.waitForFences(
        vkd.device, 1, @ptrCast([*] const vk.Fence, &self.fenceFrame)
      , vk.TRUE, std.math.maxInt(u64)
      )
    );
  }
};
