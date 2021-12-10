const mtr = @import("package.zig");
const std = @import("std");

// pub const SemaphoreId = u64;

pub const BufferTape = struct {
  buffer : mtr.buffer.Idx,
  offset : usize = 0,
  length : usize = 0, // implied to be entire buffer
  accessFlags : mtr.memory.AccessFlags = .{},
};

// tapes allow you to keep track of the current state while recording commands
pub const ImageTape = struct {
  image : mtr.image.Idx,
  layout : mtr.image.Layout = .uninitialized,
  accessFlags : mtr.memory.AccessFlags = .{},
};

pub const AccessFlags = packed struct {
  shaderRead : bool = false,
  shaderWrite : bool = false,
  uniformRead : bool = false,
  colorAttachmentRead : bool = false,
  colorAttachmentWrite : bool = false,
  transferRead : bool = false,
  transferWrite : bool = false,
  hostRead : bool = false,
  hostWrite : bool = false,
};


// // semaphores map to Vk1.2 timeline semaphores
// pub const Semaphore = struct {
// };
