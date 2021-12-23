const mtr = @import("package.zig");
const std = @import("std");

pub const SwapchainId = u64;

// encapsulates swapchain & window
pub const Swapchain = struct {
  queue : mtr.queue.Idx,
  extent : [2] u32,
  oldSwapchain : SwapchainId = 0,
  // TODO present mode (right now its just immediate lol)

  contextIdx : mtr.window.SwapchainId = 0,
};
