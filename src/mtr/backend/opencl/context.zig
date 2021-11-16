const mtr = @import("../../package.zig");
const std = @import("std");

const c = @cImport({
  @cDefine("CL_TARGET_OPENCL_VERSION", "300");
  @cInclude("CL/cl.h");
});

// in OpenCL, there is a max of 1 heap,
// mtr.heapRegions are CL buffers, mtr.buffers are CL subbuffers, and
//   mtr.images are CL images constructed from CL subbuffers

fn heapVisibilityToClMemory(visibility : mtr.heap.Visibility) u32 {
  return switch(visibility) {
    .deviceOnly => c.CL_MEM_READ_WRITE | c.CL_MEM_HOST_NO_ACCESS,
    .hostVisible => c.CL_MEM_READ_WRITE | c.CL_MEM_HOST_READ_ONLY,
    .hostWritable => c.CL_MEM_READ_WRITE | c.CL_MEM_HOST_WRITE_ONLY,
  };
}

fn heapVisibilityToClMapping(visibility : mtr.heap.Visibility) u32 {
  return switch(visibility) {
    .deviceOnly => unreachable,
    .hostVisible => c.CL_MAP_READ,
    .hostWritable => c.CL_MAP_WRITE_INVALIDATE_REGION
  };
}

pub const OpenCLError = error {
  invalidCommandQueue,
  invalidContext,
  invalidMemObject,
  invalidValue,
  invalidEventWaitList,
  misalignedSubBufferOffset,
  memCopyOverlap,
  memObjectAllocationFailure,
  outOfResources,
  outOfHostMemory,
  invalidProgram,
  invalidDevice,
  invalidBinary,
  invalidBuildOptions,
  compilerNotAvailable,
  buildProgramFailure,
  invalidOperation,
  invalidKernelName,
  invalidProgramExecutable,
  invalidKernelDefinition,
  invalidKernel,
  invalidKernelArgs,
  invalidWorkDimension,
  invalidGlobalWorkSize,
  invalidGlobalOffset,
  invalidWorkGroupSize,
  invalidWorkItemSize,
  invalidImageSize,
  imageFormatNotSupported,
  illegalReadWriteToBuffer,

  unknown,
};

fn convertOpenCLError(value : c.cl_int) OpenCLError {
  return switch (value) {
    c.CL_INVALID_COMMAND_QUEUE        => OpenCLError.invalidCommandQueue,
    c.CL_INVALID_CONTEXT              => OpenCLError.invalidContext,
    c.CL_INVALID_MEM_OBJECT           => OpenCLError.invalidMemObject,
    c.CL_INVALID_VALUE                => OpenCLError.invalidValue,
    c.CL_INVALID_EVENT_WAIT_LIST      => OpenCLError.invalidEventWaitList,
    c.CL_MISALIGNED_SUB_BUFFER_OFFSET => OpenCLError.misalignedSubBufferOffset,
    c.CL_MEM_COPY_OVERLAP             => OpenCLError.memCopyOverlap,
    c.CL_MEM_OBJECT_ALLOCATION_FAILURE => (
      OpenCLError.memObjectAllocationFailure
    ),
    c.CL_OUT_OF_RESOURCES           => OpenCLError.outOfResources,
    c.CL_OUT_OF_HOST_MEMORY         => OpenCLError.outOfHostMemory,
    c.CL_INVALID_PROGRAM            => OpenCLError.invalidProgram,
    c.CL_INVALID_DEVICE             => OpenCLError.invalidDevice,
    c.CL_INVALID_BINARY             => OpenCLError.invalidBinary,
    c.CL_INVALID_BUILD_OPTIONS      => OpenCLError.invalidBuildOptions,
    c.CL_COMPILER_NOT_AVAILABLE     => OpenCLError.compilerNotAvailable,
    c.CL_BUILD_PROGRAM_FAILURE      => OpenCLError.buildProgramFailure,
    c.CL_INVALID_OPERATION          => OpenCLError.invalidOperation,
    c.CL_INVALID_KERNEL_NAME        => OpenCLError.invalidKernelName,
    c.CL_INVALID_PROGRAM_EXECUTABLE => OpenCLError.invalidProgramExecutable,
    c.CL_INVALID_KERNEL_DEFINITION  => OpenCLError.invalidKernelDefinition,

    c.CL_INVALID_KERNEL             => OpenCLError.invalidKernel,
    c.CL_INVALID_KERNEL_ARGS        => OpenCLError.invalidKernelArgs,
    c.CL_INVALID_WORK_DIMENSION     => OpenCLError.invalidWorkDimension,
    c.CL_INVALID_GLOBAL_WORK_SIZE   => OpenCLError.invalidGlobalWorkSize,
    c.CL_INVALID_GLOBAL_OFFSET      => OpenCLError.invalidGlobalOffset,
    c.CL_INVALID_WORK_GROUP_SIZE    => OpenCLError.invalidWorkGroupSize,
    c.CL_INVALID_WORK_ITEM_SIZE     => OpenCLError.invalidWorkItemSize,
    c.CL_INVALID_IMAGE_SIZE         => OpenCLError.invalidImageSize,
    c.CL_IMAGE_FORMAT_NOT_SUPPORTED => OpenCLError.imageFormatNotSupported,
    -9999                           => OpenCLError.illegalReadWriteToBuffer,

    else                            => OpenCLError.unknown,
  };
}

fn assertClBuild(
  allocator : * std.mem.Allocator,
  program : c.cl_program, device : c.cl_device_id, value : c.cl_int
) void {
  if (value == 0) {
    return;
  }

  // these can't throw exceptions, because any potential errors generated from
  //   the OpenCL backend should be caught/handled by the MTR backend

  const errorCode = convertOpenCLError(value);

  std.log.err("{s}{}", .{"Internal OpenCL error:", errorCode});

  if (errorCode == OpenCLError.buildProgramFailure) {
    var length : usize = 0;
    assertCl(
      c.clGetProgramBuildInfo(
        program, device,
        c.CL_PROGRAM_BUILD_LOG,
        0, null, &length
      )
    );
    var buildLog : [] u8 = allocator.alloc(u8, length) catch unreachable;
    std.log.err("err len: {}", .{length});
    assertCl(
      c.clGetProgramBuildInfo(
        program, device,
        c.CL_PROGRAM_BUILD_LOG,
        length, @ptrCast(* c_void, &buildLog[0]), null,
      )
    );
    std.log.info("{s}", .{buildLog});
  }

  unreachable;
}

fn assertCl(value : c.cl_int) void {
  if (value == 0) {
    return;
  }

  std.log.err(
    "{s}{} ({})",
    .{"Internal OpenCL error:", convertOpenCLError(value), value}
  );

  unreachable;
}

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
  commandBuffers : std.AutoHashMap(mtr.command.BufferIdx, CommandBuffer),
  allocator : * std.mem.Allocator,

  pub fn init(alloc : * std.mem.Allocator) @This() {
    return .{
      .allocator = alloc,
      .commandBuffers = (
        std.AutoHashMap(mtr.command.BufferIdx, CommandBuffer).init(alloc)
      ),
    };
  }

  pub fn deinit(self : * @This()) void {
    var commandBufferIterator = self.commandBuffers.iterator();
    while (commandBufferIterator.next()) |commandBuffer| {
      commandBuffer.value_ptr.deinit();
    }
    self.commandBuffers.deinit();
  }

  pub fn emplaceCommandBuffer(
    self : * @This(),
    commandBuffer : mtr.command.Buffer,
  ) void {
    self.commandBuffers.putNoClobber(
      commandBuffer.idx, CommandBuffer.init(self.allocator),
    ) catch unreachable;
  }
};

pub const Rasterizer = struct {
  allocator : * std.mem.Allocator,
  context : c.cl_context,
  device : c.cl_device_id,

  heapRegions : std.AutoHashMap(mtr.heap.RegionIdx, c.cl_mem),
  buffers : std.AutoHashMap(mtr.buffer.Idx, c.cl_mem),
  images : std.AutoHashMap(mtr.image.Idx, c.cl_mem),
  queues : std.AutoHashMap(mtr.queue.Idx, c.cl_command_queue),
  commandPools : std.AutoHashMap(mtr.command.PoolIdx, CommandPool),

  // TODO i suppose some mapping of thread to buffer instead of this
  activeWritingBuffer : ? mtr.command.Buffer = null,

  uploadTexelToImageMemoryProgram : c.cl_program,
  uploadTexelToImageMemoryKernel : c.cl_kernel,

  pub fn init(allocator : * std.mem.Allocator) ! @This() {

    var self : @This() = .{
      .allocator = allocator,
      .context = undefined,
      .device = undefined,
      .queues = (
        std.AutoHashMap(mtr.queue.Idx, c.cl_command_queue).init(allocator)
      ),
      .commandPools = (
        std.AutoHashMap(mtr.command.PoolIdx, CommandPool).init(allocator)
      ),
      .heapRegions = (
        std.AutoHashMap(mtr.heap.RegionIdx, c.cl_mem).init(allocator)
      ),
      .images = (
        std.AutoHashMap(mtr.image.Idx, c.cl_mem).init(allocator)
      ),
      .buffers = (
        std.AutoHashMap(mtr.buffer.Idx, c.cl_mem).init(allocator)
      ),
      .uploadTexelToImageMemoryKernel = undefined,
      .uploadTexelToImageMemoryProgram = undefined,
    };

    var numPlatforms : c.cl_uint = 0;
    var status = c.clGetPlatformIDs(0, null, &numPlatforms);

    // TODO these should be thrown
    std.debug.assert(status == 0);
    std.debug.assert(numPlatforms == 1);

    var platformId : c.cl_platform_id = undefined;
    assertCl(
      c.clGetPlatformIDs(1, &platformId, null)
    );

    _ = (
      c.clGetDeviceIDs(platformId, c.CL_DEVICE_TYPE_GPU, 1, &self.device, null)
    );

    var err : c.cl_int = 0;
    self.context = c.clCreateContext(null, 1, &self.device, null, null, &err);
    assertCl(err);

    var programStr = (
      \\ __kernel void uploadTexelToImageMemory(
      \\   __global uchar * image,
      \\   float4 texelValue,
      \\   uint width,
      \\   uint height,
      \\   uint depth
      \\ ) {
      \\   size_t globalId = get_global_linear_id();
      \\   uint y = globalId % height;
      \\   uint z = globalId / height;
      \\   // the kernel fills out an entire row
      \\   for (uint x = 0; x < width; ++ x) {
      \\     image[(z*(width*height) + y*width + x)*4 + 0] = (
      \\       (uchar)(texelValue.x * 255.0f)
      \\     );
      \\     image[(z*(width*height) + y*width + x)*4 + 1] = (
      \\       (uchar)(texelValue.y * 255.0f)
      \\     );
      \\     image[(z*(width*height) + y*width + x)*4 + 2] = (
      \\       (uchar)(texelValue.z * 255.0f)
      \\     );
      \\     image[(z*(width*height) + y*width + x)*4 + 3] = (
      \\       (uchar)(texelValue.w * 255.0f)
      \\     );
      \\   }
      \\ }
    );

    var programStrAsC : [*c] const u8 = programStr;

    // create uploadTexelToImageMemoryProgram
    self.uploadTexelToImageMemoryProgram = (
      c.clCreateProgramWithSource(
        self.context,
        1, &programStrAsC, null,
        &err
      )
    );
    assertCl(err);

    assertClBuild(
      self.allocator,
      self.uploadTexelToImageMemoryProgram,
      self.device,
      c.clBuildProgram(
        self.uploadTexelToImageMemoryProgram, 1, &self.device, null, null, null
      )
    );

    self.uploadTexelToImageMemoryKernel = (
      c.clCreateKernel(
        self.uploadTexelToImageMemoryProgram,
        "uploadTexelToImageMemory",
        &err
      )
    );
    assertCl(err);

    return self;
  }

  pub fn deinit(self : * @This()) void {

    var heapRegionIterator = self.heapRegions.iterator();
    while (heapRegionIterator.next()) |heapRegion| {
      assertCl(c.clReleaseMemObject(heapRegion.value_ptr.*));
    }

    var bufferIterator = self.buffers.iterator();
    while (bufferIterator.next()) |buffer| {
      assertCl(c.clReleaseMemObject(buffer.value_ptr.*));
    }

    var imageIterator = self.images.iterator();
    while (imageIterator.next()) |image| {
      assertCl(c.clReleaseMemObject(image.value_ptr.*));
    }

    var queueIterator = self.queues.iterator();
    while (queueIterator.next()) |queue| {
      assertCl(c.clReleaseCommandQueue(queue.value_ptr.*));
    }

    var commandPoolIterator = self.commandPools.iterator();
    while (commandPoolIterator.next()) |commandPool| {
      commandPool.value_ptr.deinit();
    }

    self.buffers.deinit();
    self.heapRegions.deinit();
    self.images.deinit();
    self.commandPools.deinit();
    self.queues.deinit();
    assertCl(c.clReleaseContext(self.context));
  }

  pub fn createQueue(
    self : * @This(),
    context : mtr.Context,
    queue : mtr.queue.Primitive
  ) void {
    _ = context;
    var clQueue = c.clCreateCommandQueue(self.context, self.device, 0, null);

    self.queues.putNoClobber(queue.contextIdx, clQueue) catch unreachable;
  }

  pub fn createHeap(
    self : * @This(), context : mtr.Context, heap : mtr.heap.Primitive
  ) void {
    // there are no heaps in OpenCL, so we effectively ignore this, except
    // to keep track of total memory consumption (to ensure the user doesn't
    // go over), and to keep track of heap visibilities
    _ = heap;
    _ = self;
    _ = context;
  }

  pub fn createHeapRegion(
    self : * @This(), context : mtr.Context, heapRegion : mtr.heap.Region
  ) void {
    const heap = context.heaps.getPtr(heapRegion.allocatedHeap).?;
    var err : c_int = 0;
    const buffer = (
      c.clCreateBuffer(
        self.context,
        heapVisibilityToClMemory(heap.visibility),
        heapRegion.length,
        null,
        &err
      )
    );
    assertCl(err);

    self.heapRegions.putNoClobber(heapRegion.contextIdx, buffer)
      catch unreachable
    ;
  }

  pub fn createBuffer(
    self : * @This(), context : mtr.Context, buffer : mtr.buffer.Primitive,
  ) void {
    const clHeapRegion = self.heapRegions.getPtr(buffer.allocatedHeapRegion).?;
    const heapRegion = context.heapRegions.getPtr(buffer.allocatedHeapRegion).?;
    const heap = context.heaps.getPtr(heapRegion.allocatedHeap).?;

    const bufferCreateInfo = c.cl_buffer_region {
      .origin = buffer.offset,
      .size = buffer.length,
    };

    var err : c_int = 0;
    const subbuffer = (
      c.clCreateSubBuffer(
        clHeapRegion.*,
        heapVisibilityToClMemory(heap.visibility),
        c.CL_BUFFER_CREATE_TYPE_REGION,
        &bufferCreateInfo,
        &err,
      )
    );
    assertCl(err);

    self.buffers.putNoClobber(buffer.contextIdx, subbuffer) catch unreachable;
  }

  pub fn createImage(
    self : * @This(), context : mtr.Context, image : mtr.image.Primitive,
  ) void {
    const clHeapRegion = self.heapRegions.getPtr(image.allocatedHeapRegion).?;
    const heapRegion = context.heapRegions.getPtr(image.allocatedHeapRegion).?;
    const heap = context.heaps.getPtr(heapRegion.allocatedHeap).?;

    const bufferCreateInfo = c.cl_buffer_region {
      .origin = image.offset,
      .size = image.getImageByteLength(),
    };

    var err : c_int = 0;
    const subbuffer = (
      c.clCreateSubBuffer(
        clHeapRegion.*,
        heapVisibilityToClMemory(heap.visibility),
        c.CL_BUFFER_CREATE_TYPE_REGION,
        &bufferCreateInfo,
        &err,
      )
    );
    assertCl(err);

    self.images.putNoClobber(image.contextIdx, subbuffer) catch unreachable;
  }

  pub fn createCommandPool(
    self : * @This(),
    context : mtr.Context,
    commandPool : mtr.command.Pool,
  ) void {
    _ = context;
    self.commandPools.putNoClobber(
      commandPool.contextIdx, CommandPool.init(self.allocator)
    )
      catch unreachable;
  }

  pub fn createCommandBuffer(
    self : * @This(),
    context : mtr.Context,
    commandBuffer : mtr.command.Buffer,
  ) void {
    _ = context;

    return (
      self
        .commandPools
        .getPtr(commandBuffer.commandPool).?
        .emplaceCommandBuffer(commandBuffer)
    );
  }

  pub fn beginCommandBufferWriting(
    _ : * @This(),
    _ : mtr.Context,
    _ : mtr.command.BufferIdx,
  ) void {
    // std.debug.assert(self.activeWritingBuffer == null);

    // var commandPool = context.commandPools.getPtr(commandBuffer.commandPool).?;
    // var clCommandPool = self.commandPools.getPtr(commandBuffer.commandPool).?;
    // var clBuffer = clCommandPool.commandBuffers.getPtr(commandBuffer.idx).?;

    // if (commandPool.flags.resetCommandBuffer == true) {
    //   clBuffer.commands.clearAndFree(); // TODO maybe try invalidation
    // }

    // self.activeWritingBuffer = commandBuffer;
  }

  pub fn endCommandBufferWriting(
    self : * @This(),
    context : mtr.Context,
    _ : mtr.command.BufferIdx,
  ) void {
    _ = context;
    std.debug.assert(self.activeWritingBuffer != null);
    self.activeWritingBuffer = null;
  }

  pub fn enqueueToCommandBuffer(
    self : * @This(),
    _ : mtr.Context,
    action : mtr.command.Action,
  ) void {
    std.debug.assert(self.activeWritingBuffer != null);

    var clCommandPool = (
      self.commandPools.getPtr(self.activeWritingBuffer.?.commandPool).?
    );
    var clBuffer = (
      clCommandPool.commandBuffers.getPtr(self.activeWritingBuffer.?.idx).?
    );

    var result = clBuffer.commands.addOne() catch unreachable;
    result.* = action;
  }

  pub fn submitCommandBufferToQueue(
    self : * @This(),
    context : mtr.Context,
    queue : mtr.queue.Primitive,
    commandBuffer : mtr.command.Buffer,
  ) void {
    var clCommandPool = self.commandPools.getPtr(commandBuffer.commandPool).?;
    var clCommandBuffer = (
      clCommandPool.commandBuffers.getPtr(commandBuffer.idx).?
    );
    var clQueue = self.queues.getPtr(queue.contextIdx).?;

    for (clCommandBuffer.commands.items) |commandAction| {
      switch (commandAction) {
        .transferMemory => |action| {
          var clDstBuffer = self.buffers.getPtr(action.bufferDst).?;
          var clSrcBuffer = self.buffers.getPtr(action.bufferSrc).?;
          var err = (
            c.clEnqueueCopyBuffer(
              clQueue.*,
              clSrcBuffer.*,
              clDstBuffer.*,
              action.offsetSrc,
              action.offsetDst,
              action.length,
              0, null, // events
              null // event out
            )
          );
          assertCl(err);
        },
        .transferImageToBuffer => |action| {
          var dstBuffer = context.buffers.getPtr(action.bufferDst).?;
          var srcImage = context.images.getPtr(action.imageSrc).?;
          var clDstBuffer = self.buffers.getPtr(action.bufferDst).?;
          var clSrcImage = self.images.getPtr(action.imageSrc).?;
          var err = (
            c.clEnqueueCopyBuffer(
              clQueue.*,
              clSrcImage.*,
              clDstBuffer.*,
              0,
              0,
              // TODO below is a hack
              std.math.min(dstBuffer.length, srcImage.getImageByteLength()),
              0, null, // events
              null // event out
            )
          );
          assertCl(err);
        },
        .uploadTexelToImageMemory => |action| {
          var image = context.images.getPtr(action.image).?;
          var clImage : c.cl_mem = self.images.get(action.image).?;
          assertCl(
            c.clSetKernelArg(
              self.uploadTexelToImageMemoryKernel,
              0, @sizeOf(c.cl_mem), &clImage,
            )
          );
          assertCl(
            c.clSetKernelArg(
              self.uploadTexelToImageMemoryKernel,
              1, @sizeOf(f32)*4, &action.rgba[0],
            )
          );
          assertCl(
            c.clSetKernelArg(
              self.uploadTexelToImageMemoryKernel,
              2, @sizeOf(u32), &image.width,
            )
          );
          assertCl(
            c.clSetKernelArg(
              self.uploadTexelToImageMemoryKernel,
              3, @sizeOf(u32), &image.height,
            )
          );
          assertCl(
            c.clSetKernelArg(
              self.uploadTexelToImageMemoryKernel,
              4, @sizeOf(u32), &image.depth,
            )
          );

          var globalLength : u64 = image.width*image.height*image.depth;
          var localLength  : u64 = 64;
          _ = localLength;
          assertCl(
            c.clEnqueueNDRangeKernel(
              clQueue.*,
              self.uploadTexelToImageMemoryKernel,
              1, // work dimensions
              null, // work offset
              &globalLength, // work size
              null, // local length
              0, null, null, // events
            )
          );
        },
      }
    }
  }

  pub fn queueFlush(
    self : * @This(),
    context : mtr.Context,
    queue : mtr.queue.Primitive,
  ) void {
    _ = context;
    var clQueue = self.queues.getPtr(queue.contextIdx).?;
    assertCl(c.clFlush(clQueue.*));
  }

  pub fn mapMemory(
    self : * @This(),
    context : mtr.Context,
    memory : mtr.util.MappedMemoryRange,
  ) ! mtr.util.MappedMemory {
    var clHeapRegion = self.heapRegions.getPtr(memory.heapRegion).?;
    var clQueue = self.queues.getPtr(mtr.Context.utilContextIdx).?;
    var heapRegion = context.heapRegions.getPtr(memory.heapRegion).?;

    var err : c_int = 0;
    var ptr : ? * c_void = (
      c.clEnqueueMapBuffer(
        clQueue.*,
        clHeapRegion.*,
        c.CL_FALSE,
        heapVisibilityToClMapping(heapRegion.visibility),
        memory.offset,
        (if (memory.length == 0) heapRegion.length else memory.length),
        0, // num events in wait list
        null, // event wait list
        null, // returned event hadnle
        &err,
      )
    );
    assertCl(err);

    assertCl(c.clFlush(clQueue.*));
    std.time.sleep(0); // weird that I have to do this

    return mtr.util.MappedMemory {
      .ptr = @ptrCast([*] u8, ptr.?), .mapping = memory.heapRegion
    };
  }

  pub fn unmapMemory(
    self : @This(),
    _ : mtr.Context,
    memory : mtr.util.MappedMemory
  ) void {
    var clHeapRegion = self.heapRegions.getPtr(memory.mapping).?;
    var clQueue = self.queues.getPtr(mtr.Context.utilContextIdx).?;
    var err = (
      c.clEnqueueUnmapMemObject(
        clQueue.*,
        clHeapRegion.*,
        memory.ptr,
        0, null, // events
        null // event out
      )
    );
    assertCl(err);
    assertCl(c.clFlush(clQueue.*));
  }
};
