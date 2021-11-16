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
  commandPools : std.AutoHashMap(mtr.command.PoolIdx, mtr.command.Pool),
  commandBufferIdToPoolId : (
    std.AutoHashMap(mtr.command.BufferIdx, mtr.command.PoolIdx)
  ),

  primitiveAllocator : * std.mem.Allocator,

  renderingContext : * backend.RenderingContext,
  optimization : backend.RenderingOptimizationLevel,

  // anything util* doesn't need to be recorded, it effectively exists just to
  //   provide underlying implementation details
  // TODO this should be indices
  utilQueue : mtr.queue.Primitive,
  utilHeapRead : mtr.heap.Primitive,
  utilHeapRegionRead : mtr.heap.Region,
  utilHeapWrite : mtr.heap.Primitive,
  utilHeapRegionWrite : mtr.heap.Region,
  utilCommandPool : mtr.command.Pool,
  utilCommandBuffer : mtr.command.BufferIdx,
  utilBufferRead : mtr.buffer.Primitive,
  utilBufferWrite : mtr.buffer.Primitive,

  allocIdx : u64, // temporary FIXME

  // this is a weird 'hack', where we gauruntee only one context can be writing
  // to JSON at a time, and in that way, buffers, images, commandbuffers, etc
  // can call back to context to have their data be filled out, without having
  // to store a context pointer
  var jsonWritingContext : ? * Context = null;
  pub const utilContextIdx : u64 = 0;

  pub fn init(
    primitiveAllocator : * std.mem.Allocator,
    renderingContext : backend.RenderingContextType,
    optimization : backend.RenderingOptimizationLevel,
  ) @This() {
    var allocatedRenderingContext = (
      primitiveAllocator.create(backend.RenderingContext)
    ) catch {
      std.debug.panic("could not allocate rendering context", .{});
    };

    allocatedRenderingContext.* = (
      backend.RenderingContext.init(primitiveAllocator, renderingContext)
      catch |err| {
        std.log.crit(
          "{s}{} ({s})",
          .{
            "could not create the rendering backend: ",
            renderingContext,
            err,
          }
        );
        unreachable;
      }
    );

    // -- create util info

    var utilQueue = mtr.queue.Primitive {
      .workType = .{.transfer = true},
      .contextIdx = utilContextIdx,
    };

    var utilCommandPool = mtr.command.Pool {
      .flags = .{ .transient = true, .resetCommandBuffer = true },
      .queue = utilContextIdx,
      .commandBuffers = (
        std.AutoHashMap(mtr.buffer.Idx, mtr.command.Buffer)
          .init(primitiveAllocator)
      ),
      .contextIdx = utilContextIdx,
    };

    var utilHeapRead = mtr.heap.Primitive {
      .visibility = mtr.heap.Visibility.hostVisible,
      .contextIdx = utilContextIdx,
    };

    var utilHeapRegionRead = mtr.heap.Region {
      .allocatedHeap = utilContextIdx,
      .offset = 0, .length = 1024*1024*50, // 10 mb
      .visibility = mtr.heap.Visibility.hostVisible,
      .contextIdx = utilContextIdx,
    };

    var utilBufferRead = mtr.buffer.Primitive {
      .allocatedHeapRegion = 0,
      .offset = 0, .length = 1024*1024*50, // 10 mb transfers
      .usage = .{ .transferDst = true, },
      .queueSharing = mtr.queue.SharingUsage.exclusive,
      .contextIdx = utilContextIdx,
    };

    var utilHeapWrite = mtr.heap.Primitive {
      .visibility = mtr.heap.Visibility.hostWritable,
      .contextIdx = utilContextIdx+1,
    };

    var utilHeapRegionWrite = mtr.heap.Region {
      .allocatedHeap = utilContextIdx+1,
      .offset = 0, .length = 1024*1024*50, // 10 mb
      .visibility = mtr.heap.Visibility.hostWritable,
      .contextIdx = utilContextIdx+1,
    };

    var utilBufferWrite = mtr.buffer.Primitive {
      .allocatedHeapRegion = 0,
      .offset = 0, .length = 1024*1024*50, // 10 mb transfers
      .usage = .{ .transferSrc = true, },
      .queueSharing = mtr.queue.SharingUsage.exclusive,
      .contextIdx = utilContextIdx+1,
    };

    // TODO the buffers need to bind to subheap

    var self : @This() = undefined;
    self = .{
      .utilQueue = utilQueue,
      .utilHeapRead = utilHeapRead,
      .utilHeapRegionRead = utilHeapRegionRead,
      .utilBufferRead = utilBufferRead,
      .utilHeapWrite = utilHeapWrite,
      .utilHeapRegionWrite = utilHeapRegionWrite,
      .utilBufferWrite = utilBufferWrite,
      .utilCommandPool = utilCommandPool,
      .utilCommandBuffer = undefined,
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
      .allocIdx = 100, // the first 100 indices are reserved for utility
      .commandBufferIdToPoolId = (
        std
          .AutoHashMap(mtr.command.BufferIdx, mtr.command.PoolIdx)
          .init(primitiveAllocator)
      )
    };

    self.queues.putNoClobber(utilContextIdx, self.utilQueue)
      catch unreachable;
    self.commandPools.putNoClobber(utilContextIdx, self.utilCommandPool)
      catch unreachable;
    self.heaps.putNoClobber(utilContextIdx, self.utilHeapRead)
      catch unreachable;
    self.heapRegions.putNoClobber(utilContextIdx, self.utilHeapRegionRead)
      catch unreachable;
    self.buffers.putNoClobber(utilContextIdx, self.utilBufferRead)
      catch unreachable;
    self.heaps.putNoClobber(utilContextIdx+1, self.utilHeapWrite)
      catch unreachable;
    self.heapRegions.putNoClobber(utilContextIdx+1, self.utilHeapRegionWrite)
      catch unreachable;
    self.buffers.putNoClobber(utilContextIdx+1, self.utilBufferWrite)
      catch unreachable;

    self.renderingContext.createQueue(self, self.utilQueue);
    self.renderingContext.createCommandPool(self, self.utilCommandPool);
    self.utilCommandBuffer = (
      self.constructCommandBufferWithId(
        .{ .commandPool = utilContextIdx, },
        utilContextIdx,
      ) catch unreachable
    );
    self.renderingContext.createHeap(self, self.utilHeapRead);
    self.renderingContext.createHeapRegion(self, self.utilHeapRegionRead);
    self.renderingContext.createBuffer(self, self.utilBufferRead);
    self.renderingContext.createHeap(self, self.utilHeapWrite);
    self.renderingContext.createHeapRegion(self, self.utilHeapRegionWrite);
    self.renderingContext.createBuffer(self, self.utilBufferWrite);

    return self;
  }

  pub fn initFromSnapshot(
    jsonSnapshot : [] const u8,
    primitiveAllocator : * std.mem.Allocator,
    renderingContext : backend.RenderingContextType,
    optimization : backend.RenderingOptimizationLevel,
  ) !@This() {
    // it's just a standard initialization, but we parse initial startup
    //     information from the snapshot
    var self = @This().init(primitiveAllocator, renderingContext, optimization);
    errdefer self.deinit();
    try mtr.util.snapshot.loadContextFromSnapshot(&self, jsonSnapshot);
    return self;
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

    var commandPoolIter = self.commandPools.iterator();
    while (commandPoolIter .next()) |cmdPool| {
      cmdPool.value_ptr.deinit();
    }
    self.commandPools.deinit();

    // TODO why do I need to deinit this, shouldn't the above handle it?
    self.utilCommandPool.commandBuffers.deinit();

    self.heaps.deinit();
    self.heapRegions.deinit();
    self.queues.deinit();
    self.buffers.deinit();
    self.rasterizePipelines.deinit();
    self.images.deinit();
    self.commandBufferIdToPoolId.deinit();

    switch (self.renderingContext.*) {
      .clRasterizer => (
        self.renderingContext.clRasterizer.deinit()
      ),
      .vkRasterizer => (
        self.renderingContext.vkRasterizer.deinit()
      ),
    }

    self.primitiveAllocator.destroy(self.renderingContext);
  }

  pub fn dumpToWriter(
    self : @This(), writer : anytype
  ) @TypeOf(writer).Error !void {

    std.json.stringify(self, .{}, writer)
      catch |err| std.log.err("failed to dump MTR context: {}", .{err});
  }

  pub fn dumpToStdin(self : @This()) void {
    var string = std.ArrayList(u8).init(self.primitiveAllocator);
    defer string.deinit();

    self.dumpToWriter(string.writer())
      catch |err| std.log.err("failed to dump MTR context: {}", .{err});

    std.log.info("{s}", .{string.items});
  }

  // dumps the image binary
  pub fn dumpImageToWriter(
    imageIdx : mtr.image.Idx,
    writer : anytype
  ) @TypeOf(writer).Error !void {
    std.debug.assert(@This().jsonWritingContext != null);
    var self : * @This() = @This().jsonWritingContext.?;

    const image = self.images.getPtr(imageIdx);
    std.debug.assert(image != null);

    // TODO , I just assume that the image will fit inside the buffer
    {
      self.beginCommandBufferWriting(self.utilCommandBuffer);
      defer self.endCommandBufferWriting(self.utilCommandBuffer);

      self.enqueueToCommandBuffer(
        self.utilCommandBuffer,
        mtr.command.TransferImageToBuffer {
          .imageSrc = imageIdx,
          .bufferDst = self.utilBufferRead.contextIdx,
        },
      ) catch unreachable;
    }

    self.submitCommandBufferToQueue(
      self.utilQueue.contextIdx,
      self.utilCommandBuffer
    );
    self.queueFlush(self.utilQueue.contextIdx);

    var mappedMemory : ? [*] u8 = null;
    {
      self.beginCommandBufferWriting(self.utilCommandBuffer);
      defer self.endCommandBufferWriting(self.utilCommandBuffer);

      self.enqueueToCommandBuffer(
        self.utilCommandBuffer,
        mtr.command.MapMemory {
          .buffer = self.utilBufferRead.contextIdx,
          .mapping = .Read,
          .offset = 0,
          .length = image.?.getImageByteLength(),
          .memory = &mappedMemory,
        },
      ) catch unreachable;
    }
    self.submitCommandBufferToQueue(
      self.utilQueue.contextIdx,
      self.utilCommandBuffer
    );
    self.queueFlush(self.utilQueue.contextIdx);
    std.debug.assert(mappedMemory != null);

    try mtr.util.json.stringifyVariable(
      "underlyingMemory",
      mappedMemory.?[0 .. image.?.getImageByteLength()],
      .{}, writer,
    );
  }

  // dumps the buffer binary
  pub fn dumpBufferToWriter(
    bufferIdx : mtr.buffer.Idx,
    writer : anytype
  ) @TypeOf(writer).Error !void {
    std.debug.assert(@This().jsonWritingContext != null);
    var self : * @This() = @This().jsonWritingContext.?;

    const buffer = self.buffers.getPtr(bufferIdx);
    std.debug.assert(buffer != null);

    // TODO , I just assume that the src buffer will fit inside the dst buffer
    {
      self.beginCommandBufferWriting(self.utilCommandBuffer);
      defer self.endCommandBufferWriting(self.utilCommandBuffer);

      self.enqueueToCommandBuffer(
        self.utilCommandBuffer,
        mtr.command.TransferMemory {
          .bufferSrc = bufferIdx,
          .bufferDst = self.utilBufferRead.contextIdx,
          .offsetSrc = 0, .offsetDst = 0,
          .length = buffer.?.length,
        },
      ) catch unreachable;
    }

    self.submitCommandBufferToQueue(
      self.utilQueue.contextIdx,
      self.utilCommandBuffer
    );
    self.queueFlush(self.utilQueue.contextIdx);

    var mappedMemory : ? [*] u8 = null;
    {
      self.beginCommandBufferWriting(self.utilCommandBuffer);
      defer self.endCommandBufferWriting(self.utilCommandBuffer);

      self.enqueueToCommandBuffer(
        self.utilCommandBuffer,
        mtr.command.MapMemory {
          .buffer = self.utilBufferRead.contextIdx,
          .mapping = .Read,
          .offset = 0,
          .length = buffer.?.length,
          .memory = &mappedMemory,
        },
      ) catch unreachable;
    }
    self.submitCommandBufferToQueue(
      self.utilQueue.contextIdx,
      self.utilCommandBuffer
    );
    self.queueFlush(self.utilQueue.contextIdx);
    std.debug.assert(mappedMemory != null);

    try mtr.util.json.stringifyVariable(
      "underlyingMemory",
      mappedMemory.?[0 .. buffer.?.length],
      .{}, writer,
    );
  }

  pub fn jsonStringify(
    self : @This(),
    options : std.json.StringifyOptions,
    outStream : anytype
  ) @TypeOf(outStream).Error ! void {
    try outStream.writeByte('{');

    var childOpt = options;
    if (childOpt.whitespace) |*childWhite| {
      childWhite.indent_level += 1;
    }

    // temporarily have jsonWritingContext point to `self` stored on the stack,
    //   so that modifications to debug/util can be made
    // TODO if i split out to util/debug, then would want to just copy that
    //   portion
    var selfCopy = self;
    @This().jsonWritingContext = &selfCopy;
    defer @This().jsonWritingContext = null;

    // obviously, can not stringify an allocator
 
    // possibly the backend might want to serialize some data too, but it
    // should be avoided if possible
    // try mtr.util.json.stringifyVariable("renderingContext", ...);

    try mtr.util.json.stringifyHashMap(
      "heaps", self.heaps, options, outStream,
    );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyHashMap(
      "heapRegions", self.heapRegions, options, outStream,
    );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyHashMap(
      "queues", self.queues, options, outStream,
    );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyHashMap(
      "buffers", self.buffers, options, outStream,
    );
    // try outStream.writeByte(',');
    // try mtr.util.json.stringifyHashMap(
    //   "rasterizePipelines", self.rasterizePipelines, options, outStream,
    // );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyHashMap(
      "images", self.images, options, outStream,
    );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyHashMap(
      "commandPools", self.commandPools, options, outStream,
    );

    try outStream.writeByte('}');
  }

  // ----- construct -----

  pub fn constructHeapWithId(
    self : * @This(),
    ci : mtr.heap.ConstructInfo,
    idx : mtr.heap.Idx,
  ) !mtr.heap.Idx {
    const heap = mtr.heap.Primitive {
      .visibility = ci.visibility,
      .contextIdx = idx,
    };

    self.renderingContext.createHeap(self.*, heap);

    try self.heaps.putNoClobber(idx, heap);

    return heap.contextIdx;
  }

  pub fn constructHeap(
    self : * @This(),
    ci : mtr.heap.ConstructInfo,
  ) !mtr.heap.Idx {
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructHeapWithId(ci, prevIdx);
  }

  pub fn constructHeapRegionWithId(
    self : * @This(),
    ci : mtr.heap.RegionConstructInfo,
    idx : mtr.heap.RegionIdx,
  ) !mtr.heap.RegionIdx {
    var heap = self.heaps.getPtr(ci.allocatedHeap).?;
    const heapRegion = mtr.heap.Region {
      .allocatedHeap = ci.allocatedHeap,
      .offset = 0, // TODO FIX ME with a proper allocator
      .length = ci.length,
      .contextIdx = idx,
      .visibility = heap.visibility,
    };

    // TODO assert length/offset of region is less than the allocated heap
    //   length
    // TODO assert NO overlap with other heap regions in debug mode

    self.renderingContext.createHeapRegion(self.*, heapRegion);

    try self.heapRegions.putNoClobber(idx, heapRegion);

    return heapRegion.contextIdx;
  }

  pub fn constructHeapRegion(
    self : * @This(), ci : mtr.heap.RegionConstructInfo
  ) !mtr.heap.RegionIdx {
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructHeapRegionWithId(ci, prevIdx);
  }

  pub fn bindBufferToSubheap(
    self : * @This(),
    bufferIdx : mtr.buffer.Idx,
    offset : usize,
    heapRegion : mtr.heap.RegionIdx,
  ) void {
    var buffer = self.buffers.getPtr(bufferIdx).?;
    // TODO assert allocated heap region is null
    std.debug.assert(buffer.allocatedHeapRegion == 0);
    std.debug.assert(self.heapRegions.getPtr(heapRegion) != null);
    buffer.allocatedHeapRegion = heapRegion;
    buffer.offset = offset;
    self.renderingContext.bindBufferToSubheap(self.*, buffer.*);
  }

  pub fn constructBufferWithId(
    self : * @This(),
    ci : mtr.buffer.ConstructInfo,
    idx : mtr.buffer.Idx,
  ) !mtr.buffer.Idx {
    const buffer = mtr.buffer.Primitive {
      .allocatedHeapRegion = 0, // TODO use null handle i guess
      .offset = ci.offset,
      .length = ci.length,
      .usage = ci.usage,
      .queueSharing = ci.queueSharing,
      .contextIdx = idx,
    };

    // TODO assert NO overlap with other buffers/images in debug mode

    self.renderingContext.createBuffer(self.*, buffer);

    try self.buffers.putNoClobber(idx, buffer);

    return buffer.contextIdx;
  }

  pub fn constructBuffer(
    self : * @This(), ci : mtr.buffer.ConstructInfo
  ) !mtr.buffer.Idx {
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructBufferWithId(ci, prevIdx);
  }

  pub fn bufferMemoryRequirements(
    self : * @This(),
    bufferIdx : mtr.buffer.Idx,
  ) mtr.util.MemoryRequirements {
    const buffer = self.buffers.get(bufferIdx).?;
    return self.renderingContext.bufferMemoryRequirements(self.*, buffer);
  }

  pub fn constructImageWithId(
    self : * @This(),
    ci : mtr.image.ConstructInfo,
    idx : mtr.image.Idx,
  ) !mtr.image.Idx {
    const image = mtr.image.Primitive {
      .allocatedHeapRegion = 0, // TODO
      .offset = ci.offset,
      .width = ci.width, .height = ci.height, .depth = ci.depth,
      .samplesPerTexel = ci.samplesPerTexel,
      .arrayLayers = ci.arrayLayers,
      .byteFormat = ci.byteFormat,
      .channels = ci.channels,
      .normalized = ci.normalized,
      .mipmapLevels = ci.mipmapLevels,
      .queueSharing = ci.queueSharing,
      .contextIdx = idx,
    };

    self.renderingContext.createImage(self.*, image);

    try self.images.putNoClobber(idx, image);

    return image.contextIdx;
  }

  pub fn constructImage(
    self : * @This(), ci : mtr.image.ConstructInfo
  ) !mtr.image.Idx {
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructImageWithId(ci, prevIdx);
  }

  pub fn getImageByteLength(self : @This(), idx : mtr.image.Idx) u64 {
    const image = self.images.getPtr(idx);
    std.debug.assert(image != null);
    return image.?.getImageByteLength();
  }

  pub fn constructCommandPoolWithId(
    self : * @This(),
    ci : mtr.command.PoolConstructInfo,
    idx : mtr.command.PoolIdx,
  ) !mtr.command.PoolIdx {
    const pool = mtr.command.Pool {
      .flags = ci.flags,
      .queue = ci.queue,
      .commandBuffers = (
        std.AutoHashMap(mtr.command.BufferIdx, mtr.command.Buffer)
          .init(self.primitiveAllocator)
      ),
      .contextIdx = idx,
    };

    self.renderingContext.createCommandPool(self.*, pool);

    try self.commandPools.putNoClobber(idx, pool);

    return pool.contextIdx;
  }

  pub fn constructCommandPool(
    self : * @This(),
    ci : mtr.command.PoolConstructInfo,
  ) !mtr.command.PoolIdx {
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructCommandPoolWithId(ci, prevIdx);
  }

  fn constructCommandBufferWithId(
    self : * @This(),
    ci : mtr.command.BufferConstructInfo,
    id : u64,
  ) !mtr.command.BufferIdx {
    var commandBuffer = mtr.command.Buffer {
      .commandPool = ci.commandPool,
      .commandRecordings = (
        std.ArrayList(mtr.command.Action).init(self.primitiveAllocator)
      ),
      .idx = id,
    };

    self.renderingContext.createCommandBuffer(self.*, commandBuffer);

    var commandPool = self.commandPools.getPtr(commandBuffer.commandPool).?;
    try (
      commandPool.commandBuffers.putNoClobber(commandBuffer.idx, commandBuffer)
    );
    try (
      self.commandBufferIdToPoolId.putNoClobber(
        commandBuffer.idx,
        commandPool.contextIdx,
      )
    );

    return id;
  }

  pub fn constructCommandBuffer(
    self : * @This(),
    ci : mtr.command.BufferConstructInfo,
  ) !mtr.command.BufferIdx {
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructCommandBufferWithId(ci, prevIdx);
  }

  pub fn constructQueueWithId(
    self : * @This(),
    ci : mtr.queue.ConstructInfo,
    idx : mtr.queue.Idx,
  ) !mtr.queue.Idx {
    const queue = mtr.queue.Primitive {
      .workType = ci.workType,
      .contextIdx = idx,
    };

    self.renderingContext.createQueue(self.*, queue);

    try self.queues.putNoClobber(idx, queue);

    return queue.contextIdx;
  }

  pub fn constructQueue(
    self : * @This(),
    ci : mtr.queue.ConstructInfo,
  ) !mtr.queue.Idx {
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructQueueWithId(ci, prevIdx);
  }

  // ----- destroy primitives -----

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

  // ----- command buffer -----

  const CommandBufferPair = struct {
    pool : * mtr.command.Pool,
    buffer : * mtr.command.Buffer,
  };

  fn getCommandBufferFromId(
    self : @This(),
    commandBufferIdx : mtr.command.BufferIdx
  ) CommandBufferPair {
    var poolId = self.commandBufferIdToPoolId.getPtr(commandBufferIdx).?.*;
    var pool = self.commandPools.getPtr(poolId).?;
    var buffer = pool.commandBuffers.getPtr(commandBufferIdx).?;
    return .{ .pool = pool, .buffer = buffer };
  }

  pub fn beginCommandBufferWriting(
    self : * @This(),
    commandBufferIdx : mtr.command.BufferIdx,
  ) void {
    const commandPair = self.getCommandBufferFromId(commandBufferIdx);
    var commandPool = commandPair.pool;
    var commandBuffer = commandPair.buffer;

    self.renderingContext.beginCommandBufferWriting(self.*, commandBufferIdx);

    if (
          !commandPool.flags.resetCommandBuffer
      and commandBuffer.commandRecordings.items.len > 0
    ) {
      std.debug.assert(false); // throw error properly TODO
    }

    if (commandPool.flags.transient) {
      commandBuffer.commandRecordings.clearRetainingCapacity();
    } else {
      commandBuffer.commandRecordings.clearAndFree();
    }
  }

  pub fn endCommandBufferWriting(
    self : * @This(),
    commandBuffer : mtr.command.BufferIdx,
  ) void {
    self.renderingContext.endCommandBufferWriting(self.*, commandBuffer);
  }

  // enqueues a command to the command buffer
  pub fn enqueueToCommandBuffer(
    self : @This(),
    commandBufferIdx : mtr.command.BufferIdx,
    command : anytype,
  ) void {
    var action : mtr.command.Action = undefined;
    if (@TypeOf(command) == mtr.command.TransferMemory) {
      action = .{.transferMemory = command};
    } else if (@TypeOf(command) == mtr.command.TransferImageToBuffer) {
      action = .{.transferImageToBuffer = command};
    } else if (@TypeOf(command) == mtr.command.UploadTexelToImageMemory) {
      action = .{.uploadTexelToImageMemory = command};
    } else {
      unreachable; // if this hits, probably need to add the command
    }

    const commandPair = self.getCommandBufferFromId(commandBufferIdx);
    (commandPair.buffer.commandRecordings.addOne()
      catch unreachable
    ).* = action;

    self
      .renderingContext
      .enqueueToCommandBuffer(self, commandBufferIdx, action);
  }

  pub fn submitCommandBufferToQueue(
    self : @This(),
    queueIdx : mtr.queue.Idx,
    commandBufferIdx : mtr.command.BufferIdx,
  ) void {
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    var commandBuffer = self.getCommandBufferFromId(commandBufferIdx).buffer;

    std.debug.assert(queue != null);

    self.renderingContext.submitCommandBufferToQueue(
      self, queue.?.*, commandBuffer.*,
    );
  }

  pub fn queueFlush(self : @This(), queueIdx : mtr.queue.Idx) void {
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    std.debug.assert(queue != null);

    self.renderingContext.queueFlush(self, queue.?.*);
  }

  pub fn mapMemory(
    self : @This(),
    range : mtr.util.MappedMemoryRange,
  ) ! mtr.util.MappedMemory {
    // std.debug.assert( TODO
    //   (
    //         heapRegion.visibility == .hostVisible
    //     and memory.mapping == .Read
    //   )
    //   or (
    //         heapRegion.visibility == .hostWritable
    //     and memory.mapping == .Write
    //   )
    // );
    return self.renderingContext.mapMemory(self, range);
  }

  pub fn mapMemoryBuffer(
    self : @This(),
    range : mtr.util.MappedMemoryRangeBuffer,
  ) ! mtr.util.MappedMemory {
    var buffer = self.buffers.get(range.buffer).?;
    // offset into the subheap with the buffer's offset
    return self.mapMemory(.{
      .mapping = range.mapping,
      .heapRegion = buffer.allocatedHeapRegion,
      .offset = buffer.offset + range.offset,
      .length = range.length,
    });
  }

  pub fn unmapMemory(
    self : @This(),
    memory : mtr.util.MappedMemory,
  ) void {
    return self.renderingContext.unmapMemory(self, memory);
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

  // -- utils ------------------------------------------------------------------
  pub fn createHeapRegionAllocator(
    self : * @This(),
    heap : mtr.heap.Idx,
  ) mtr.util.HeapRegionAllocator {
    return mtr.util.HeapRegionAllocator.init(self, heap);
  }

  pub fn createCommandBufferRecorder(
    self : * @This(),
    commandBuffer : mtr.command.BufferIdx,
  ) mtr.util.CommandBufferRecorder {
    return mtr.util.CommandBufferRecorder.init(self, commandBuffer);
  }
};
