const mtr = @import("../package.zig");
const std = @import("std");

pub const opencl = @import("opencl/package.zig");

pub const RenderingContextType = enum {
  clRasterizer,
};

pub const RenderingOptimizationLevel = enum {
  Release,
  Debug,
};

pub const RenderingContext = union(RenderingContextType) {
  clRasterizer : opencl.context.Rasterizer,

  pub fn init(
    alloc : * std.mem.Allocator, rct : RenderingContextType
  ) !@This() {
    return switch(rct) {
      .clRasterizer => .{
        .clRasterizer = try opencl.context.Rasterizer.init(alloc)
      },
    };
  }

  pub fn createHeap(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.heap.Primitive,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createHeap(context, primitive)
      )
    }
  }

  pub fn createHeapRegion(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.heap.Region,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createHeapRegion(context, primitive)
      )
    }
  }

  pub fn createBuffer(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.buffer.Primitive,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createBuffer(context, primitive)
      )
    }
  }

  pub fn createImage(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.image.Primitive,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createImage(context, primitive)
      )
    }
  }

  pub fn createCommandPool(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.command.Pool,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createCommandPool(context, primitive)
      )
    }
  }

  pub fn createCommandBuffer(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.command.BufferConstructInfo,
  ) mtr.command.Buffer {
    return switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createCommandBuffer(context, primitive)
      )
    };
  }

  pub fn beginCommandBufferWriting(
    self : * @This(),
    context : mtr.Context,
    buffer : mtr.command.Buffer
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.beginCommandBufferWriting(context, buffer)
      )
    }
  }

  pub fn endCommandBufferWriting(self : * @This(), context : mtr.Context) void {
    switch (self.*) {
      .clRasterizer => self.clRasterizer.endCommandBufferWriting(context)
    }
  }

  pub fn createQueue(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.queue.Primitive,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createQueue(context, primitive)
      )
    }
  }

  pub fn enqueueToCommandBuffer(
    self : * @This(),
    context : mtr.Context,
    command : mtr.command.Action,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.enqueueToCommandBuffer(context, command)
      )
    }
  }

  pub fn submitCommandBufferToQueue(
    self : * @This(),
    context : mtr.Context,
    queue : mtr.queue.Primitive,
    commandBuffer : mtr.command.Buffer,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.submitCommandBufferToQueue(
          context, queue, commandBuffer
        )
      )
    }
  }

  pub fn queueFlush(
    self : * @This(),
    context : mtr.Context,
    queue : mtr.queue.Primitive,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.queueFlush(context, queue)
      )
    }
  }
};
