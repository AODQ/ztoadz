const std = @import("std");
const assert = std.debug.assert;
const c = @import("c.zig");

fn AssertVk(result : c.VkResult) !void {
  switch (result) {
    c.VK_SUCCESS => {},
    else => return error.Unexpected,
  }
}

fn InitializeVulkan(
  allocator : * std.mem.Allocator
, window : * c.GLFWwindow
) !void {
  const appInfo = c.VkApplicationInfo {
    .sType = c.VK_STRUCTURE_TYPE_APPLICATION_INFO
  , .pApplicationName = "zTOADz"
  , .applicationVersion = c.VK_MAKE_VERSION(1, 0, 0)
  , .pEngineName = "nil"
  , .engineVersion = c.VK_MAKE_VERSION(1, 0, 0)
  , .apiVersion = c.VK_API_VERSION_1_0
  , .pNext = null
  };

  var instance : c.VkInstance = null;

  const instanceCreateInfo = c.VkInstanceCreateInfo {
    .sType = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO
  , .flags = 0
  , .pApplicationInfo = &appInfo
  , .enabledLayerCount = 0
  , .ppEnabledLayerNames = null
  , .enabledExtensionCount = 0
  , .ppEnabledExtensionNames = null
  , .pNext = null
  };

  try AssertVk(c.vkCreateInstance(&instanceCreateInfo, null, &instance));
}

pub fn main() !void {
  std.log.info("initializing zTOADz", .{});

  if (c.glfwInit() == 0) { return error.GlfwInitFailed; }
  defer c.glfwTerminate();

  c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);
  c.glfwWindowHint(c.GLFW_RESIZABLE, c.GLFW_TRUE);

  const window =
    c.glfwCreateWindow(800, 600, "ztoadz", null, null)
    orelse return error.GlfwCreateWindowFailed
  ;
  defer c.glfwDestroyWindow(window);

  const allocator = std.heap.c_allocator;
  try InitializeVulkan(allocator, window);

  while (c.glfwWindowShouldClose(window) == 0) {
    c.glfwPollEvents();
  }
}
