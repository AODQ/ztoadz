pub const c = @cImport({
  @cDefine("GLFW_INCLUDE_NONE", "");
  @cInclude("GLFW/glfw3.h");
});

// manually import glfw vulkan symbols, as GLFW_INCLUDE_VULKAN does not seem to
// work

const vk = @import("vulkan.zig");

pub extern "c" fn glfwGetInstanceProcAddress(
  instance: vk.Instance, procname: [*:0]const u8
) vk.PfnVoidFunction;
pub extern "c" fn glfwGetPhysicalDevicePresentationSupport(
  instance: vk.Instance, pdev: vk.PhysicalDevice, queuefamily: u32
) c_int;
pub extern "c" fn glfwCreateWindowSurface(
  instance: vk.Instance, window: *c.GLFWwindow,
  allocation_callbacks: ?*const vk.AllocationCallbacks,
  surface: *vk.SurfaceKHR
) vk.Result;
