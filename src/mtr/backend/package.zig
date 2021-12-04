const mtr = @import("../package.zig");
const std = @import("std");

pub const opencl = @import("opencl/package.zig");
pub const vulkan = @import("vulkan/package.zig");

pub const RenderingContextType = enum {
  clRasterizer,
  vkRasterizer,

  pub const jsonStringify = mtr.util.json.JsonEnumMixin.jsonStringify;
};

pub const RenderingOptimizationLevel = enum {
  Release,
  Debug,

  pub const jsonStringify = mtr.util.json.JsonEnumMixin.jsonStringify;
};

pub const RenderingContext = union(RenderingContextType) {
  clRasterizer : opencl.context.Rasterizer,
  vkRasterizer : vulkan.context.Rasterizer,

  pub fn init(
    alloc : * std.mem.Allocator, rct : RenderingContextType
  ) !@This() {
    return switch(rct) {
      .clRasterizer => .{
        .clRasterizer = try opencl.context.Rasterizer.init(alloc)
      },
      .vkRasterizer => .{
        .vkRasterizer = try vulkan.context.Rasterizer.init(alloc)
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
      ),
      .vkRasterizer => (
        self.vkRasterizer.createHeap(context, primitive)
      )
    }
  }

  pub fn createHeapFromMemoryRequirements(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.heap.Primitive,
    memoryRequirement : [] mtr.util.MemoryRequirements,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createHeapFromMemoryRequirements(
          context, primitive, memoryRequirement,
        )
      ),
      .vkRasterizer => (
        self.vkRasterizer.createHeapFromMemoryRequirements(
          context, primitive, memoryRequirement,
        )
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
      ),
      .vkRasterizer => (
        self.vkRasterizer.createHeapRegion(context, primitive)
      )
    }
  }

  pub fn bindBufferToSubheap(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.buffer.Primitive,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.bindBufferToSubheap(context, primitive)
      ),
      .vkRasterizer => (
        self.vkRasterizer.bindBufferToSubheap(context, primitive)
      )
    }
  }

  pub fn bindImageToSubheap(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.image.Primitive,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.bindImageToSubheap(context, primitive)
      ),
      .vkRasterizer => (
        self.vkRasterizer.bindImageToSubheap(context, primitive)
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
      ),
      .vkRasterizer => (
        self.vkRasterizer.createBuffer(context, primitive)
      )
    }
  }

  pub fn bufferMemoryRequirements(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.buffer.Primitive,
  ) mtr.util.MemoryRequirements {
    return switch (self.*) {
      .clRasterizer => (
          self.clRasterizer.bufferMemoryRequirements(context, primitive)
          ),
      .vkRasterizer => (
        self.vkRasterizer.bufferMemoryRequirements(context, primitive)
      )
    };
  }

  pub fn createImage(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.image.Primitive,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createImage(context, primitive)
      ),
      .vkRasterizer => (
        self.vkRasterizer.createImage(context, primitive)
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
      ),
      .vkRasterizer => (
        self.vkRasterizer.createCommandPool(context, primitive)
      )
    }
  }

  pub fn imageMemoryRequirements(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.image.Primitive,
  ) mtr.util.MemoryRequirements {
    return switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.imageMemoryRequirements(context, primitive)
      ),
      .vkRasterizer => (
        self.vkRasterizer.imageMemoryRequirements(context, primitive)
      )
    };
  }

  pub fn createCommandBuffer(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.command.Buffer,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createCommandBuffer(context, primitive)
      ),
      .vkRasterizer => (
        self.vkRasterizer.createCommandBuffer(context, primitive)
      )
    }
  }

  pub fn beginCommandBufferWriting(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.command.BufferIdx,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.beginCommandBufferWriting(context, primitive)
      ),
      .vkRasterizer => (
        self.vkRasterizer.beginCommandBufferWriting(context, primitive)
      )
    }
  }

  pub fn endCommandBufferWriting(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.command.BufferIdx,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.endCommandBufferWriting(context, primitive)
      ),
      .vkRasterizer => (
        self.vkRasterizer.endCommandBufferWriting(context, primitive)
      ),
    }
  }

  pub fn createShaderModule(
    self : * @This(),
    context : mtr.Context,
    primitive : mtr.shader.Module,
    data : [] u64,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.createShaderModule(context, primitive, data)
      ),
      .vkRasterizer => (
        self.vkRasterizer.createQueue(context, primitive, data)
      )
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
      ),
      .vkRasterizer => (
        self.vkRasterizer.createQueue(context, primitive)
      )
    }
  }

  pub fn enqueueToCommandBuffer(
    self : * @This(),
    context : mtr.Context,
    commandBufferIdx : mtr.command.BufferIdx,
    command : mtr.command.Action,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self
          .clRasterizer
          .enqueueToCommandBuffer(context, commandBufferIdx, command)
      ),
      .vkRasterizer => (
        self
          .vkRasterizer
          .enqueueToCommandBuffer(context, commandBufferIdx, command)
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
      ),
      .vkRasterizer => (
        self.vkRasterizer.submitCommandBufferToQueue(
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
      ),
      .vkRasterizer => (
        self.vkRasterizer.queueFlush(context, queue)
      )
    }
  }

  pub fn mapMemory(
    self : * @This(),
    context : mtr.Context,
    range : mtr.util.MappedMemoryRange,
  ) ! mtr.util.MappedMemory {
    return switch (self.*) {
      .clRasterizer => (
        try self.clRasterizer.mapMemory(context, range)
      ),
      .vkRasterizer => (
        try self.vkRasterizer.mapMemory(context, range)
      )
    };
  }

  pub fn unmapMemory(
    self : * @This(),
    context : mtr.Context,
    memory : mtr.util.MappedMemory,
  ) void {
    switch (self.*) {
      .clRasterizer => (
        self.clRasterizer.unmapMemory(context, memory)
      ),
      .vkRasterizer => (
        self.vkRasterizer.unmapMemory(context, memory)
      )
    }
  }
};
