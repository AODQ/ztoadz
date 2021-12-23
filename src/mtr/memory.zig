const mtr = @import("package.zig");
const std = @import("std");

pub const SemaphoreId = u64;
pub const FenceId = u64;

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
  indirectCommand : bool = false,
};

pub const Semaphore = struct {
  contextIdx : SemaphoreId,
};

pub const Fence = struct {
  signaled : bool = false,

  contextIdx : FenceId = 0,
};

pub const WaitSemaphoreSynchronization = struct {
  semaphore : mtr.memory.SemaphoreId,
  stage : mtr.pipeline.StageFlags,
};

pub const CommandBufferSynchronization = struct {
  waitSemaphores : [] WaitSemaphoreSynchronization = (
    &[_] WaitSemaphoreSynchronization {}
  ),
  signalSemaphores : [] mtr.memory.SemaphoreId = &[_] mtr.memory.SemaphoreId {},
};
