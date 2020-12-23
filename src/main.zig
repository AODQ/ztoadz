const std = @import("std");
const assert = std.debug.assert;
const glfw = @import("glfw.zig");
const vk = @import("vulkan.zig");
const ztd = @import("ztoadz.zig");
const zvvk = @import("zvvk.zig");

pub fn main() !void {
  std.log.info("{}", .{"initializing zTOADz"});

  if (glfw.glfwInit() == 0) { return error.GlfwInitFailed; }
  defer glfw.glfwTerminate();

  glfw.glfwWindowHint(glfw.GLFW_CLIENT_API, glfw.GLFW_NO_API);
  glfw.glfwWindowHint(glfw.GLFW_RESIZABLE, glfw.GLFW_TRUE);

  const window =
    glfw.glfwCreateWindow(800, 600, "ztoadz", null, null)
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
    // vk.extension_info.khr_ray_tracing_pipeline.name,
    vk.extension_info.khr_acceleration_structure.name,
    vk.extension_info.khr_ray_query.name,
  };

  //const allocator = std.heap.c_allocator.init(&debugAllocator.allocator);
  //defer allocator.deinit();
  var vkApp =
    ztd.VulkanAppContext.init(
      &debugAllocator.allocator, window, requiredDeviceExtensions[0..]
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
  {
    var bufferSize : vk.DeviceSize =
        vkApp.swapchain.extent.width * vkApp.swapchain.extent.height
      * 3 * @sizeOf(f32)
    ;

    const queueFamilyIndices = [_] u32 {
      vkd.queueGraphics.family
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

  // read back undefined memory
  const data =
    try vkd.vkdd.mapMemory(
      vkd.device, buffer.allocation, 0, vk.WHOLE_SIZE, vk.MemoryMapFlags{}
    );

  const fdata = @ptrCast([*] const f32, @alignCast(4, data));
  _ = std.c.printf(
    "first elements: %f, %f, %f, %f\n", fdata[0], fdata[1], fdata[2], fdata[3]
  );
  vkd.vkdd.unmapMemory(vkd.device, buffer.allocation);

  vkdAllocator.DestroyBuffer(buffer);



  // var commandPool =
  //   try ztd.VulkanCommandPool.init(
  //     vkDevice.*
  //   , vk.CommandPoolCreateInfo {
  //       .pNext = null
  //     , .flags = vk.CommandPoolCreateFlags.fromInt(0)
  //     , .queueFamilyIndex = vkDevice.queueGraphics.family
  //     }
  //   );
  // defer commandPool.deinit(vkDevice.*);

  // var commandBuffers =
  //   ztd.VulkanCommandBuffer.init(
  //     &debugAllocator.allocator
  //   , vkDevice.*
  //   , vk.CommandBufferAllocateInfo {
  //       .pNext = null
  //     , .commandPool = commandPool.pool
  //     , .level = vk.CommandBufferLevel.primary
  //     , .commandBufferCount = 3
  //     }
  //   );
  // defer commandBuffers.deinit(vkDevice.*);

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
    glfw.glfwPollEvents();
  // }

  std.log.info("{}", .{"Exitting ztoadz!"});
}
