const mtr = @import("../../package.zig");
const std = @import("std");

const vk = @import("vulkan.zig");

fn heapVisibilityToVkMemory(
  visibility : mtr.heap.Visibility
) vk.MemoryPropertyFlags {
  return switch(visibility) {
    .deviceOnly => .{ .deviceLocalBit = true },
    .hostVisible => .{ .hostVisibleBit = true },
    .hostWritable => .{ .hostCachedBit = true },
  };
}

//fn heapVisibilityToVkMapping(visibility : mtr.heap.Visibility) u32 {
//  return switch(visibility) {
//    .deviceOnly => unreachable,
//    .hostVisible => c.CL_MAP_READ,
//    .hostWritable => c.CL_MAP_WRITE_INVALIDATE_REGION
//  };
//}

//fn assertVkBuild(
//  allocator : * std.mem.Allocator,
//  program : c.cl_program, device : c.cl_device_id, value : c.cl_int
//) void {
//  if (value == 0) {
//    return;
//  }
//
//  // these can't throw exceptions, because any potential errors generated from
//  //   the OpenCL backend should be caught/handled by the MTR backend
//
//  const errorCode = convertOpenCLError(value);
//
//  std.log.err("{s}{}", .{"Internal OpenCL error:", errorCode});
//
//  if (errorCode == OpenCLError.buildProgramFailure) {
//    var length : usize = 0;
//    assertCl(
//      c.clGetProgramBuildInfo(
//        program, device,
//        c.CL_PROGRAM_BUILD_LOG,
//        0, null, &length
//      )
//    );
//    var buildLog : [] u8 = allocator.alloc(u8, length) catch unreachable;
//    std.log.err("err len: {}", .{length});
//    assertCl(
//      c.clGetProgramBuildInfo(
//        program, device,
//        c.CL_PROGRAM_BUILD_LOG,
//        length, @ptrCast(* c_void, &buildLog[0]), null,
//      )
//    );
//    std.log.info("{s}", .{buildLog});
//  }
//
//  unreachable;
//}

pub const CommandBuffer = struct {
  commands : std.ArrayList(mtr.command.Action),

  pub fn init(alloc : * std.mem.Allocator) @This() {
    return .{
      .commands = std.ArrayList(mtr.command.Action).init(alloc),
    };
  }

  pub fn deinit(self : * @This()) void {
    self.commands.deinit();
  }
};

pub const CommandPool = struct {
  buffers : std.AutoHashMap(mtr.buffer.Idx, CommandBuffer),
  allocator : * std.mem.Allocator,

  pub fn init(alloc : * std.mem.Allocator) @This() {
    return .{
      .allocator = alloc,
      .buffers = std.AutoHashMap(mtr.buffer.Idx, CommandBuffer).init(alloc),
    };
  }

  pub fn deinit(self : * @This()) void {
    var bufferIterator = self.buffers.iterator();
    while (bufferIterator.next()) |buffer| {
      buffer.value_ptr.deinit();
    }
    self.buffers.deinit();
  }

  pub fn emplaceCommandBuffer(
    self : * @This(),
    commandBuffer : mtr.command.Buffer,
  ) void {
    self.buffers.putNoClobber(
      commandBuffer.idx, CommandBuffer.init(self.allocator),
    ) catch unreachable;
  }
};

pub const Rasterizer = struct {
  allocator : * std.mem.Allocator,
  // context : c.cl_context,
  // device : c.cl_device_id,

  heapRegions : std.AutoHashMap(mtr.heap.RegionIdx, vk.DeviceMemory),
  buffers : std.AutoHashMap(mtr.buffer.Idx, vk.Buffer),
  // images : std.AutoHashMap(mtr.image.Idx, c.cl_mem),
  // queues : std.AutoHashMap(mtr.queue.Idx, c.cl_command_queue),
  // commandPools : std.AutoHashMap(mtr.command.PoolIdx, CommandPool),

  // TODO i suppose some mapping of thread to buffer instead of this
  // activeWritingBuffer : ? mtr.command.Buffer = null,

  // uploadTexelToImageMemoryProgram : c.cl_program,
  // uploadTexelToImageMemoryKernel : c.cl_kernel,

  pub fn init(allocator : * std.mem.Allocator) ! @This() {
    return @This() {
      .allocator = allocator,
    };
  }

  pub fn deinit(self : * @This()) void {
    _ = self;
  }

  pub fn createQueue(
    self : * @This(),
    context : mtr.Context,
    queue : mtr.queue.Primitive
  ) void {
    _ = self; _ = context; _ = queue;
  }

  pub fn createHeap(
    self : * @This(), context : mtr.Context, heap : mtr.heap.Primitive
  ) void {
    _ = heap;
    _ = self;
    _ = context;
  }

  pub fn createHeapRegion(
    self : * @This(), context : mtr.Context, heapRegion : mtr.heap.Region
  ) void {
    _ = self;
    _ = context;
    _ = heapRegion;
  }

  pub fn createBuffer(
    self : * @This(), context : mtr.Context, buffer : mtr.buffer.Primitive,
  ) void {
    const vkHeapRegion = self.heapRegions.getPtr(buffer.allocatedHeapRegion).?;
    const heapRegion = context.heapRegions.getPtr(buffer.allocatedHeapRegion).?;
    const heap = context.heaps.getPtr(heapRegion.allocatedHeap).?;

    const buffer = (
      vk.createBuffer(
      )
    );
  }

  pub fn createImage(
    self : * @This(), context : mtr.Context, image : mtr.image.Primitive,
  ) void {
    _ = self; _ = context; _ = image;
  }

  pub fn createCommandPool(
    self : * @This(),
    context : mtr.Context,
    commandPool : mtr.command.Pool,
  ) void {
    _ = context;
    _ = self; _ = commandPool;
  }

  pub fn createCommandBuffer(
    self : * @This(),
    context : mtr.Context,
    commandBuffer : mtr.command.Buffer,
  ) void {
    _ = context;
    _ = self; _ = commandBuffer;
  }

  pub fn beginCommandBufferWriting(
    self : * @This(), context : mtr.Context, buffer : mtr.command.Buffer,
  ) void {
    _ = context;
    _ = self; _ = buffer;
  }

  pub fn endCommandBufferWriting(self : * @This(), context : mtr.Context) void {
    _ = context;
    _ = self;
  }

  pub fn enqueueToCommandBuffer(
    self : * @This(),
    context : mtr.Context,
    action : mtr.command.Action,
  ) void {
    _ = context;
    _ = self; _ = action;
  }

  pub fn submitCommandBufferToQueue(
    self : * @This(),
    context : mtr.Context,
    queue : mtr.queue.Primitive,
    commandBuffer : mtr.command.Buffer,
  ) void {
    _ = self; _ = context; _ = queue; _ = commandBuffer;
  }

  pub fn queueFlush(
    self : * @This(),
    context : mtr.Context,
    queue : mtr.queue.Primitive,
  ) void {
    _ = context;
    _ = self; _ = queue;
  }
};
