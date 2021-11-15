const mtr = @import("../package.zig");
const std = @import("std");

// nil context, effectively does nothing, a complete error if this actually is
//   used at runtime

pub const Rasterizer = struct {
  pub fn init(_ : * std.mem.Allocator) ! @This() {
    return error.NoContextAvailable;
  }

  pub fn deinit(_ : * @This()) void {
  }

  pub fn createQueue(
    _ : * @This(),
    _ : mtr.Context,
    _ : mtr.queue.Primitive
  ) void {
  }

  pub fn createHeap(
    _ : * @This(), _ : mtr.Context, _ : mtr.heap.Primitive
  ) void {
  }

  pub fn createHeapRegion(
    _ : * @This(), _ : mtr.Context, _ : mtr.heap.Region
  ) void {
  }

  pub fn createBuffer(
    _ : * @This(), _ : mtr.Context, _ : mtr.buffer.Primitive,
  ) void {
  }

  pub fn createImage(
    _ : * @This(), _ : mtr.Context, _ : mtr.image.Primitive,
  ) void {
  }

  pub fn createCommandPool(
    _ : * @This(),
    _ : mtr.Context,
    _ : mtr.command.Pool,
  ) void {
  }

  pub fn createCommandBuffer(
    _ : * @This(),
    _ : mtr.Context,
    _ : mtr.command.Buffer,
  ) void {
  }

  pub fn beginCommandBufferWriting(
    _ : * @This(), _ : mtr.Context, _ : mtr.command.Buffer,
  ) void {
  }

  pub fn endCommandBufferWriting(_ : * @This(), _ : mtr.Context) void {
  }

  pub fn enqueueToCommandBuffer(
    _ : * @This(),
    _ : mtr.Context,
    _ : mtr.command.Action,
  ) void {
  }

  pub fn submitCommandBufferToQueue(
    _ : * @This(),
    _ : mtr.Context,
    _ : mtr.queue.Primitive,
    _ : mtr.command.Buffer,
  ) void {
  }

  pub fn queueFlush(
    _ : * @This(),
    _ : mtr.Context,
    _ : mtr.queue.Primitive,
  ) void {
  }

  pub fn mapMemory(
    _ : * @This(),
    _ : mtr.Context,
    _ : mtr.util.MappedMemoryRange,
  ) ! mtr.util.MappedMemory {
    return error.NoContextAvailable;
  }

  pub fn unmapMemory(
    _ : * @This(),
    _ : mtr.Context,
    _ : mtr.util.MappedMemory,
  ) void {
  }
};
