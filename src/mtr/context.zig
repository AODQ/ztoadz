const mtr = @import("package.zig");
const std = @import("std");
const backend = @import("backend/package.zig");

// All primitives exist inside a 'Context', which is the primary means to
// communicate with monte-toad. While remaining flexible enough to be used in
// a multi-threaded fashion, it allows for all data to be serialized, dumped &
// deserialized, which will allow for extensive unit-testing of the library.
pub const Context = struct {
  heaps : std.AutoHashMap(mtr.heap.Idx, mtr.heap.Primitive),
  heapRegions : std.AutoHashMap(mtr.heap.RegionIdx, mtr.heap.Region),
  queues : std.AutoHashMap(mtr.queue.Idx, mtr.queue.Primitive),
  buffers : std.AutoHashMap(mtr.buffer.Idx, mtr.buffer.Primitive),
  rasterizePipelines : (
    std.AutoHashMap(mtr.pipeline.Idx, mtr.pipeline.RasterizePrimitive)
  ),
  images : std.AutoHashMap(mtr.image.Idx, mtr.image.Primitive),
  commandPools : std.AutoHashMap(mtr.command.Idx, mtr.command.Pool),

  primitiveAllocator : * std.mem.Allocator,

  renderingContext : * backend.RenderingContext,
  optimization : backend.RenderingOptimizationLevel,

  allocIdx : u64, // temporary FIXME

  pub fn init(
    primitiveAllocator : * std.mem.Allocator,
    renderingContext : backend.RenderingContextType,
    optimization : backend.RenderingOptimizationLevel,
  ) @This() {
    const self : @This() = undefined;
    var allocatedRenderingContext = (
      primitiveAllocator.create(backend.RenderingContext)
    ) catch {
      std.debug.panic("could not allocate rendering context", .{});
    };

    var openclContext = (
      try mtr.backend.opencl.context.Rasterizer.init(primitiveAllocator)
    );
    _ = openclContext;

    allocatedRenderingContext.* = (
      backend.RenderingContext.init(primitiveAllocator, renderingContext)
      catch {
        std.log.crit(
          "{s}{}",
          .{"could not create the rendering backend: ", renderingContext}
        );
        unreachable;
      }
    );

    return .{
      .heaps = @TypeOf(self.heaps).init(primitiveAllocator),
      .queues = @TypeOf(self.queues).init(primitiveAllocator),
      .heapRegions = @TypeOf(self.heapRegions).init(primitiveAllocator),
      .buffers = @TypeOf(self.buffers).init(primitiveAllocator),
      .rasterizePipelines = (
        @TypeOf(self.rasterizePipelines).init(primitiveAllocator)
      ),
      .images = @TypeOf(self.images).init(primitiveAllocator),
      .commandPools = @TypeOf(self.commandPools).init(primitiveAllocator),
      .primitiveAllocator = primitiveAllocator,
      .optimization = optimization,
      .renderingContext = allocatedRenderingContext,
      .allocIdx = 0,
    };
  }

  pub fn deinit(self : * @This()) void {

    var queueIterator = self.queues.iterator();
    while (queueIterator.next()) |queue| {
      self.destroyQueue(queue.value_ptr.contextIdx);
    }

    var heapIterator = self.heaps.iterator();
    while (heapIterator.next()) |heap| {
      self.destroyHeap(heap.value_ptr.contextIdx);
    }

    self.heaps.deinit();
    self.heapRegions.deinit();
    self.queues.deinit();
    self.buffers.deinit();
    self.rasterizePipelines.deinit();
    self.images.deinit();
    self.commandPools.deinit();

    switch (self.renderingContext.*) {
      .clRasterizer => (
        self.renderingContext.clRasterizer.deinit()
      ),
    }

    self.primitiveAllocator.destroy(self.renderingContext);
  }

  pub fn constructHeap(
    self : * @This(),
    ci : mtr.heap.ConstructInfo
  ) !mtr.heap.Idx {
    const heap = mtr.heap.Primitive {
      .length = ci.length,
      .visibility = ci.visibility,
      .contextIdx = self.allocIdx,
    };

    self.renderingContext.createHeap(self.*, heap);

    try self.heaps.putNoClobber(self.allocIdx, heap);

    self.allocIdx += 1;

    return heap.contextIdx;
  }

  pub fn destroyHeap(self : * @This(), heapIdx : mtr.heap.Idx) void {
    const heap : ? * mtr.heap.Primitive = self.heaps.getPtr(heapIdx);
    std.debug.assert(heap != null);

    // self.renderingContext.deallocateHeap(heap.?.underlyingMemory);

    _ = self.heaps.remove(heapIdx);
  }

  pub fn destroyQueue(self : * @This(), queueIdx : mtr.queue.Idx) void {
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    std.debug.assert(queue != null);

    _ = self.queues.remove(queueIdx);
  }

  pub fn constructHeapRegion(
    self : * @This(), ci : mtr.heap.RegionConstructInfo
  ) !mtr.heap.RegionIdx {
    var heap = self.heaps.getPtr(ci.allocatedHeap).?;
    const heapRegion = mtr.heap.Region {
      .allocatedHeap = ci.allocatedHeap,
      .offset = 0, // TODO FIX ME with a proper allocator
      .length = ci.length,
      .contextIdx = self.allocIdx,
      .visibility = heap.visibility,
    };

    // TODO assert length/offset of region is less than the allocated heap
    //   length
    // TODO assert NO overlap with other heap regions in debug mode

    self.renderingContext.createHeapRegion(self.*, heapRegion);

    try self.heapRegions.putNoClobber(self.allocIdx, heapRegion);

    self.allocIdx += 1;

    return heapRegion.contextIdx;
  }

  pub fn constructBuffer(
    self : * @This(), ci : mtr.buffer.ConstructInfo
  ) !mtr.buffer.Idx {
    const buffer = mtr.buffer.Primitive {
      .allocatedHeapRegion = ci.allocatedHeapRegion,
      .offset = ci.offset,
      .length = ci.length,
      .usage = ci.usage,
      .queueSharing = ci.queueSharing,
      .contextIdx = self.allocIdx,
    };

    // TODO assert NO overlap with other buffers/images in debug mode

    self.renderingContext.createBuffer(self.*, buffer);

    try self.buffers.putNoClobber(self.allocIdx, buffer);

    self.allocIdx += 1;

    return buffer.contextIdx;
  }

  pub fn constructImage(
    self : * @This(), ci : mtr.image.ConstructInfo
  ) !mtr.image.Idx {
    const image = mtr.image.Primitive {
      .allocatedHeapRegion = ci.allocatedHeapRegion,
      .offset = ci.offset,
      .width = ci.width, .height = ci.height, .depth = ci.depth,
      .samplesPerTexel = ci.samplesPerTexel,
      .arrayLayers = ci.arrayLayers,
      .byteFormat = ci.byteFormat,
      .channels = ci.channels,
      .normalized = ci.normalized,
      .mipmapLevels = ci.mipmapLevels,
      .queueSharing = ci.queueSharing,
      .contextIdx = self.allocIdx,
    };

    self.renderingContext.createImage(self.*, image);

    try self.images.putNoClobber(self.allocIdx, image);
    self.allocIdx += 1;

    return image.contextIdx;
  }

  pub fn getImageByteLength(self : @This(), idx : mtr.image.Idx) u64 {
    const image = self.images.getPtr(idx);
    std.debug.assert(image != null);
    return image.?.getImageLength();
  }

  pub fn constructCommandPool(
    self : * @This(),
    ci : mtr.command.PoolConstructInfo,
  ) !mtr.command.PoolIdx {
    const pool = mtr.command.Pool {
      .flags = ci.flags,
      .contextIdx = self.allocIdx,
    };

    self.renderingContext.createCommandPool(self.*, pool);

    try self.commandPools.putNoClobber(self.allocIdx, pool);

    self.allocIdx += 1;

    return pool.contextIdx;
  }

  pub fn constructCommandBuffer(
    self : * @This(),
    ci : mtr.command.BufferConstructInfo,
  ) !mtr.command.Buffer {
    return self.renderingContext.createCommandBuffer(self.*, ci);
  }

  pub fn constructQueue(
    self : * @This(),
    ci : mtr.queue.ConstructInfo,
  ) !mtr.queue.Idx {
    const queue = mtr.queue.Primitive {
      .workType = ci.workType,
      .contextIdx = self.allocIdx,
    };

    self.renderingContext.createQueue(self.*, queue);

    try self.queues.putNoClobber(self.allocIdx, queue);

    self.allocIdx += 1;

    return queue.contextIdx;
  }

  pub fn beginCommandBufferWriting(
    self : @This(),
    buffer : mtr.command.Buffer,
  ) void {
    self.renderingContext.beginCommandBufferWriting(self, buffer);
  }

  pub fn endCommandBufferWriting(self : @This()) void {
    self.renderingContext.endCommandBufferWriting(self);
  }

  // enques a command to the command buffer
  pub fn enqueueToCommandBuffer(self : @This(), command : anytype) !void {
    var action : mtr.command.Action = undefined;
    if (@TypeOf(command) == mtr.command.MapMemory) {
      action = .{.mapMemory = command};
    } else if (@TypeOf(command) == mtr.command.UnmapMemory) {
      action = .{.unmapMemory = command};
    } else if (@TypeOf(command) == mtr.command.TransferMemory) {
      action = .{.transferMemory = command};
    } else if (@TypeOf(command) == mtr.command.TransferImageToBuffer) {
      action = .{.transferImageToBuffer = command};
    } else if (@TypeOf(command) == mtr.command.UploadTexelToImageMemory) {
      action = .{.uploadTexelToImageMemory = command};
    } else {
      unreachable; // if this hits, probably need to add the command
    }

    self.renderingContext.enqueueToCommandBuffer(self, action);
  }

  pub fn submitCommandBufferToQueue(
    self : @This(),
    queueIdx : mtr.queue.Idx,
    commandBuffer : mtr.command.Buffer,
  ) void {
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    std.debug.assert(queue != null);
    self.renderingContext.submitCommandBufferToQueue(
      self, queue.?.*, commandBuffer
    );
  }

  pub fn queueFlush(self : @This(), queueIdx : mtr.queue.Idx) void {
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    std.debug.assert(queue != null);

    self.renderingContext.queueFlush(self, queue.?.*);
  }

  pub fn mapBufferMemory(
    self : @This(),
    range : mtr.util.MappedMemoryRange,
  ) mtr.util.MappedMemory {
    return mtr.util.MappedMemory.init(self, range);
  }

  pub fn constructPipeline(
    _ : @This(),
    _ : mtr.pipeline.ConstructInfo,
  ) !mtr.primitive.Idx {
    // const pipeline = mtr.pipeline.Primitive {
    //   .layout = ci.layout,
    //   .depthTestEnable = ci.depthTestEnable,
    //   .depthWriteEnable = ci.depthWriteEnable,
    // };

    // try self.pipelines.putNoClobber(self.allocIdx, mtr.buffer.Primitive);

    // self.allocIdx += 1;

    // return buffer.contextIdx;
  }
};
