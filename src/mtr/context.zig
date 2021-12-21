const mtr = @import("package.zig");
const std = @import("std");

const backend = @import("backend/vulkan/package.zig");

// All primitives exist inside a 'Context', which is the primary means to
// communicate with monte-toad. While remaining flexible enough to be used in
// a multi-threaded fashion, it allows for all data to be serialized, dumped &
// deserialized, which will allow for extensive unit-testing of the library.
pub const Context = struct {
  heaps : std.AutoHashMap(mtr.heap.Idx, mtr.heap.Primitive),
  heapRegions : std.AutoHashMap(mtr.heap.RegionIdx, mtr.heap.Region),
  queues : std.AutoHashMap(mtr.queue.Idx, mtr.queue.Primitive),
  buffers : std.AutoHashMap(mtr.buffer.Idx, mtr.buffer.Primitive),
  images : std.AutoHashMap(mtr.image.Idx, mtr.image.Primitive),
  imageViews : std.AutoHashMap(mtr.image.ViewIdx, mtr.image.View),
  shaderModules : std.AutoHashMap(mtr.shader.Idx, mtr.shader.Module),
  descriptorSetPools : (
    std.AutoHashMap(
      mtr.descriptor.PoolIdx,
      mtr.descriptor.SetPool
    )
  ),
  descriptorSets : (
    std.AutoHashMap(
      mtr.descriptor.SetIdx,
      mtr.descriptor.Set
    )
  ),
  descriptorSetLayouts : (
    std.AutoHashMap(mtr.descriptor.LayoutIdx, mtr.descriptor.SetLayout,)
  ),
  computePipelines : (
    std.AutoHashMap(mtr.pipeline.ComputeIdx, mtr.pipeline.Compute)
  ),
  pipelineLayouts : (
    std.AutoHashMap(mtr.pipeline.LayoutIdx, mtr.pipeline.Layout)
  ),
  commandPools : std.AutoHashMap(mtr.command.PoolIdx, mtr.command.Pool),
  commandBufferIdToPoolId : (
    std.AutoHashMap(mtr.command.BufferIdx, mtr.command.PoolIdx)
  ),

  primitiveAllocator : std.mem.Allocator,

  rasterizer : * backend.context.Rasterizer,
  optimization : mtr.RenderingOptimizationLevel,

  allocIdx : u64, // temporary FIXME

  // this is a weird 'hack', where we gauruntee only one context can be writing
  // to JSON at a time, and in that way, buffers, images, commandbuffers, etc
  // can call back to context to have their data be filled out, without having
  // to store a context pointer
  var jsonWritingContext : ? * Context = null;
  pub const utilContextIdx : u64 = 0;

  pub fn init(
    primitiveAllocator : std.mem.Allocator,
    optimization : mtr.RenderingOptimizationLevel,
  ) @This() {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var allocatedRasterizer = (
      primitiveAllocator.create(backend.context.Rasterizer)
    ) catch {
      std.debug.panic("could not allocate rendering context", .{});
    };

    allocatedRasterizer .* = (
      backend.context.Rasterizer.init(primitiveAllocator)
      catch |err| {
        std.log.err(
          "{s} ({s})",
          .{
            "could not create the rendering backend: ",
            err,
          }
        );
        unreachable;
      }
    );

    var self : @This() = undefined;
    self = .{
      .heaps = @TypeOf(self.heaps).init(primitiveAllocator),
      .queues = @TypeOf(self.queues).init(primitiveAllocator),
      .heapRegions = @TypeOf(self.heapRegions).init(primitiveAllocator),
      .buffers = @TypeOf(self.buffers).init(primitiveAllocator),
      .images = @TypeOf(self.images).init(primitiveAllocator),
      .imageViews = @TypeOf(self.imageViews).init(primitiveAllocator),
      .descriptorSetPools = (
        @TypeOf(self.descriptorSetPools).init(primitiveAllocator)
      ),
      .descriptorSets = (
        @TypeOf(self.descriptorSets).init(primitiveAllocator)
      ),
      .descriptorSetLayouts = (
        @TypeOf(self.descriptorSetLayouts).init(primitiveAllocator)
      ),
      .shaderModules = @TypeOf(self.shaderModules).init(primitiveAllocator),
      .computePipelines = (
        @TypeOf(self.computePipelines).init(primitiveAllocator)
      ),
      .pipelineLayouts = @TypeOf(self.pipelineLayouts).init(primitiveAllocator),
      .commandPools = @TypeOf(self.commandPools).init(primitiveAllocator),
      .primitiveAllocator = primitiveAllocator,
      .optimization = optimization,
      .rasterizer = allocatedRasterizer,
      .allocIdx = 100, // the first 100 indices are reserved for utility
      .commandBufferIdToPoolId = (
        std
          .AutoHashMap(mtr.command.BufferIdx, mtr.command.PoolIdx)
          .init(primitiveAllocator)
      )
    };

    return self;
  }

  pub fn initFromSnapshot(
    jsonSnapshot : [] const u8,
    primitiveAllocator : std.mem.Allocator,
    rasterizer : backend.context.Rasterizer,
    optimization : mtr.RenderingOptimizationLevel,
  ) !@This() {
    // it's just a standard initialization, but we parse initial startup
    //     information from the snapshot
    var self = @This().init(primitiveAllocator, rasterizer, optimization);
    errdefer self.deinit();
    try mtr.util.snapshot.loadContextFromSnapshot(&self, jsonSnapshot);
    return self;
  }

  pub fn deinit(self : * @This()) void {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    self.rasterizer.deviceWaitIdle();

    var queueIterator = self.queues.iterator();
    while (queueIterator.next()) |queue| {
      self.destroyQueue(queue.value_ptr.contextIdx);
    }

    var heapIterator = self.heaps.iterator();
    while (heapIterator.next()) |heap| {
      self.destroyHeap(heap.value_ptr.contextIdx);
    }

    var commandPoolIter = self.commandPools.iterator();
    while (commandPoolIter.next()) |cmdPool| {
      cmdPool.value_ptr.deinit();
    }

    var descriptorSetLayoutIter = self.descriptorSetLayouts.iterator();
    while (descriptorSetLayoutIter.next()) |descriptorSetLayout| {
      descriptorSetLayout.value_ptr.deinit();
    }

    self.buffers.deinit();
    self.commandBufferIdToPoolId.deinit();
    self.commandPools.deinit();
    self.computePipelines.deinit();
    self.pipelineLayouts.deinit();
    self.descriptorSets.deinit();
    self.descriptorSetLayouts.deinit();
    self.descriptorSetPools.deinit();
    self.heapRegions.deinit();
    self.heaps.deinit();
    self.images.deinit();
    self.imageViews.deinit();
    self.queues.deinit();
    self.shaderModules.deinit();

    self.rasterizer.deinit();

    self.primitiveAllocator.destroy(self.rasterizer);
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
    _ = imageIdx;
    _ = writer;
    // std.debug.assert(@This().jsonWritingContext != null);
    // var self : * @This() = @This().jsonWritingContext.?;

    // const image = self.images.getPtr(imageIdx);
    // std.debug.assert(image != null);

    // // TODO , I just assume that the image will fit inside the buffer
    // {
    //   self.beginCommandBufferWriting(self.utilCommandBuffer);
    //   defer self.endCommandBufferWriting(self.utilCommandBuffer);

    //   self.enqueueToCommandBuffer(
    //     self.utilCommandBuffer,
    //     mtr.command.TransferImageToBuffer {
    //       .imageSrc = imageIdx,
    //       .bufferDst = self.utilBufferRead.contextIdx,
    //     },
    //   ) catch unreachable;
    // }

    // self.submitCommandBufferToQueue(
    //   self.utilQueue.contextIdx,
    //   self.utilCommandBuffer
    // );
    // self.queueFlush(self.utilQueue.contextIdx);

    // var mappedMemory : ? [*] u8 = null;
    // {
    //   self.beginCommandBufferWriting(self.utilCommandBuffer);
    //   defer self.endCommandBufferWriting(self.utilCommandBuffer);

    //   self.enqueueToCommandBuffer(
    //     self.utilCommandBuffer,
    //     mtr.command.MapMemory {
    //       .buffer = self.utilBufferRead.contextIdx,
    //       .mapping = .Read,
    //       .offset = 0,
    //       .length = image.?.getImageByteLength(),
    //       .memory = &mappedMemory,
    //     },
    //   ) catch unreachable;
    // }
    // self.submitCommandBufferToQueue(
    //   self.utilQueue.contextIdx,
    //   self.utilCommandBuffer
    // );
    // self.queueFlush(self.utilQueue.contextIdx);
    // std.debug.assert(mappedMemory != null);

    // try mtr.util.json.stringifyVariable(
    //   "underlyingMemory",
    //   mappedMemory.?[0 .. image.?.getImageByteLength()],
    //   .{}, writer,
    // );
  }

  // dumps the buffer binary
  pub fn dumpBufferToWriter(
    bufferIdx : mtr.buffer.Idx,
    writer : anytype
  ) @TypeOf(writer).Error !void {
    _ = bufferIdx;
    _ = writer;
    // std.debug.assert(@This().jsonWritingContext != null);
    // var self : * @This() = @This().jsonWritingContext.?;

    // const buffer = self.buffers.getPtr(bufferIdx);
    // std.debug.assert(buffer != null);

    // // TODO , I just assume that the src buffer will fit inside the dst buffer
    // {
    //   self.beginCommandBufferWriting(self.utilCommandBuffer);
    //   defer self.endCommandBufferWriting(self.utilCommandBuffer);

    //   self.enqueueToCommandBuffer(
    //     self.utilCommandBuffer,
    //     mtr.command.TransferMemory {
    //       .bufferSrc = bufferIdx,
    //       .bufferDst = self.utilBufferRead.contextIdx,
    //       .offsetSrc = 0, .offsetDst = 0,
    //       .length = buffer.?.length,
    //     },
    //   ) catch unreachable;
    // }

    // self.submitCommandBufferToQueue(
    //   self.utilQueue.contextIdx,
    //   self.utilCommandBuffer
    // );
    // self.queueFlush(self.utilQueue.contextIdx);

    // var mappedMemory : ? [*] u8 = null;
    // {
    //   self.beginCommandBufferWriting(self.utilCommandBuffer);
    //   defer self.endCommandBufferWriting(self.utilCommandBuffer);

    //   self.enqueueToCommandBuffer(
    //     self.utilCommandBuffer,
    //     mtr.command.MapMemory {
    //       .buffer = self.utilBufferRead.contextIdx,
    //       .mapping = .Read,
    //       .offset = 0,
    //       .length = buffer.?.length,
    //       .memory = &mappedMemory,
    //     },
    //   ) catch unreachable;
    // }
    // self.submitCommandBufferToQueue(
    //   self.utilQueue.contextIdx,
    //   self.utilCommandBuffer
    // );
    // self.queueFlush(self.utilQueue.contextIdx);
    // std.debug.assert(mappedMemory != null);

    // try mtr.util.json.stringifyVariable(
    //   "underlyingMemory",
    //   mappedMemory.?[0 .. buffer.?.length],
    //   .{}, writer,
    // );
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
    // try mtr.util.json.stringifyVariable("rasterizer", ...);

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
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const heap = mtr.heap.Primitive {
      .visibility = ci.visibility,
      .contextIdx = idx,
    };

    self.rasterizer.createHeap(self.*, heap);

    try self.heaps.putNoClobber(idx, heap);

    return heap.contextIdx;
  }

  pub fn constructHeap(
    self : * @This(),
    ci : mtr.heap.ConstructInfo,
  ) !mtr.heap.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructHeapWithId(ci, prevIdx);
  }

  pub fn createHeapFromMemoryRequirements(
    self : * @This(),
    ci : mtr.heap.ConstructInfo,
    memoryRequirements : [] mtr.util.MemoryRequirements,
  ) !mtr.heap.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const idx = self.allocIdx;
    self.allocIdx += 1;
    const heap = mtr.heap.Primitive {
      .visibility = ci.visibility,
      .contextIdx = idx,
    };

    self.rasterizer.createHeapFromMemoryRequirements(
      self.*, heap, memoryRequirements,
    );

    try self.heaps.putNoClobber(idx, heap);

    return heap.contextIdx;
  }

  pub fn constructHeapRegionWithId(
    self : * @This(),
    ci : mtr.heap.RegionConstructInfo,
    idx : mtr.heap.RegionIdx,
  ) !mtr.heap.RegionIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
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

    self.rasterizer.createHeapRegion(self.*, heapRegion);

    try self.heapRegions.putNoClobber(idx, heapRegion);

    return heapRegion.contextIdx;
  }

  pub fn constructHeapRegion(
    self : * @This(), ci : mtr.heap.RegionConstructInfo
  ) !mtr.heap.RegionIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
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
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var buffer = self.buffers.getPtr(bufferIdx).?;
    // TODO assert allocated heap region is null
    std.debug.assert(buffer.allocatedHeapRegion == 0);
    std.debug.assert(self.heapRegions.getPtr(heapRegion) != null);
    buffer.allocatedHeapRegion = heapRegion;
    buffer.offset = offset;
    self.rasterizer.bindBufferToSubheap(self.*, buffer.*);
  }

  pub fn bindImageToSubheap(
    self : * @This(),
    imageIdx : mtr.image.Idx,
    offset : usize,
    heapRegion : mtr.heap.RegionIdx,
  ) void {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var image = self.images.getPtr(imageIdx).?;
    // TODO assert allocated heap region is null
    std.debug.assert(image.allocatedHeapRegion == 0);
    std.debug.assert(self.heapRegions.getPtr(heapRegion) != null);
    image.allocatedHeapRegion = heapRegion;
    image.offset = offset;
    self.rasterizer.bindImageToSubheap(self.*, image.*);
  }

  pub fn constructBufferWithId(
    self : * @This(),
    ci : mtr.buffer.ConstructInfo,
    idx : mtr.buffer.Idx,
  ) !mtr.buffer.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const buffer = mtr.buffer.Primitive {
      .allocatedHeapRegion = 0, // TODO use null handle i guess
      .offset = ci.offset,
      .length = ci.length,
      .usage = ci.usage,
      .queueSharing = ci.queueSharing,
      .contextIdx = idx,
    };

    // TODO assert NO overlap with other buffers/images in debug mode

    self.rasterizer.createBuffer(self.*, buffer);

    try self.buffers.putNoClobber(idx, buffer);

    return buffer.contextIdx;
  }

  pub fn constructBuffer(
    self : * @This(), ci : mtr.buffer.ConstructInfo
  ) !mtr.buffer.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructBufferWithId(ci, prevIdx);
  }

  pub fn bufferMemoryRequirements(
    self : * @This(),
    bufferIdx : mtr.buffer.Idx,
  ) mtr.util.MemoryRequirements {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const buffer = self.buffers.get(bufferIdx).?;
    return self.rasterizer.bufferMemoryRequirements(self.*, buffer);
  }

  pub fn constructImageWithId(
    self : * @This(),
    ci : mtr.image.ConstructInfo,
    idx : mtr.image.Idx,
  ) !mtr.image.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const image = mtr.image.Primitive {
      .allocatedHeapRegion = 0, // TODO
      .label = ci.label,
      .offset = ci.offset,
      .width = ci.width, .height = ci.height, .depth = ci.depth,
      .samplesPerTexel = ci.samplesPerTexel,
      .arrayLayers = ci.arrayLayers,
      .byteFormat = ci.byteFormat,
      .channels = ci.channels,
      .usage = ci.usage,
      .normalized = ci.normalized,
      .mipmapLevels = ci.mipmapLevels,
      .queueSharing = ci.queueSharing,
      .contextIdx = idx,
    };

    self.rasterizer.createImage(self.*, image);

    try self.images.putNoClobber(idx, image);

    return image.contextIdx;
  }

  pub fn constructImage(
    self : * @This(), ci : mtr.image.ConstructInfo,
  ) !mtr.image.Idx {
    std.log.debug("{s}{s} ({s})", .{"mtr -- ", @src().fn_name, ci.label});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructImageWithId(ci, prevIdx);
  }

  pub fn createImageViewWithId(
    self : * @This(),
    ci : mtr.image.ViewCreateInfo,
    idx : mtr.image.ViewIdx,
  ) !mtr.image.ViewIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const imageView = mtr.image.View {
      .image = ci.image,
      .viewType = ci.viewType,
      .mipmapLayerBegin = ci.mipmapLayerBegin,
      .mipmapLayerCount = ci.mipmapLayerCount,
      .arrayLayerBegin = ci.arrayLayerBegin,
      .arrayLayerCount = ci.arrayLayerCount,
      .contextIdx = idx,
    };

    try self.rasterizer.createImageView(self.*, imageView);

    try self.imageViews.putNoClobber(idx, imageView);

    return imageView.contextIdx;
  }

  pub fn createImageView(
    self : * @This(), ci : mtr.image.ViewCreateInfo,
  ) !mtr.image.ViewIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.createImageViewWithId(ci, prevIdx);
  }

  pub fn imageMemoryRequirements(
    self : * @This(),
    imageIdx : mtr.image.Idx,
  ) mtr.util.MemoryRequirements {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const image = self.images.get(imageIdx).?;
    return self.rasterizer.imageMemoryRequirements(self.*, image);
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
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const pool = mtr.command.Pool {
      .flags = ci.flags,
      .queue = ci.queue,
      .commandBuffers = (
        std.AutoHashMap(mtr.command.BufferIdx, mtr.command.Buffer)
          .init(self.primitiveAllocator)
      ),
      .contextIdx = idx,
    };

    self.rasterizer.createCommandPool(self.*, pool);

    try self.commandPools.putNoClobber(idx, pool);

    return pool.contextIdx;
  }

  pub fn constructCommandPool(
    self : * @This(),
    ci : mtr.command.PoolConstructInfo,
  ) !mtr.command.PoolIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructCommandPoolWithId(ci, prevIdx);
  }

  fn constructCommandBufferWithId(
    self : * @This(),
    ci : mtr.command.BufferConstructInfo,
    id : u64,
  ) !mtr.command.BufferIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var commandBuffer = mtr.command.Buffer {
      .commandPool = ci.commandPool,
      .commandRecordings = (
        std.ArrayList(mtr.command.Action).init(self.primitiveAllocator)
      ),
      .idx = id,
    };

    self.rasterizer.createCommandBuffer(self.*, commandBuffer);

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
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructCommandBufferWithId(ci, prevIdx);
  }

  pub fn constructQueueWithId(
    self : * @This(),
    ci : mtr.queue.ConstructInfo,
    idx : mtr.queue.Idx,
  ) !mtr.queue.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const queue = mtr.queue.Primitive {
      .workType = ci.workType,
      .contextIdx = idx,
    };

    self.rasterizer.createQueue(self.*, queue);

    try self.queues.putNoClobber(idx, queue);

    return queue.contextIdx;
  }

  pub fn constructQueue(
    self : * @This(),
    ci : mtr.queue.ConstructInfo,
  ) !mtr.queue.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.constructQueueWithId(ci, prevIdx);
  }

  // ----- destroy primitives -----

  pub fn destroyHeap(self : * @This(), heapIdx : mtr.heap.Idx) void {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const heap : ? * mtr.heap.Primitive = self.heaps.getPtr(heapIdx);
    std.debug.assert(heap != null);

    // self.rasterizer.deallocateHeap(heap.?.underlyingMemory);

    _ = self.heaps.remove(heapIdx);
  }

  pub fn destroyQueue(self : * @This(), queueIdx : mtr.queue.Idx) void {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
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
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const commandPair = self.getCommandBufferFromId(commandBufferIdx);
    var commandPool = commandPair.pool;
    var commandBuffer = commandPair.buffer;

    self.rasterizer.beginCommandBufferWriting(self.*, commandBufferIdx);

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
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    self.rasterizer.endCommandBufferWriting(self.*, commandBuffer);
  }

  // enqueues a command to the command buffer
  pub fn enqueueToCommandBuffer(
    self : @This(),
    commandBufferIdx : mtr.command.BufferIdx,
    command : anytype,
  ) void {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var action : mtr.command.Action = undefined;
    if (@TypeOf(command) == mtr.command.TransferMemory) {
      action = .{.transferMemory = command};
    } else if (@TypeOf(command) == mtr.command.TransferImageToBuffer) {
      action = .{.transferImageToBuffer = command};
    } else if (@TypeOf(command) == mtr.command.PipelineBarrier) {
      action = .{.pipelineBarrier = command};
    } else if (@TypeOf(command) == mtr.command.UploadTexelToImageMemory) {
      action = .{.uploadTexelToImageMemory = command};
    } else if (@TypeOf(command) == mtr.command.BindPipeline) {
      action = .{.bindPipeline = command};
    } else if (@TypeOf(command) == mtr.command.Dispatch) {
      action = .{.dispatch = command};
    } else if (@TypeOf(command) == mtr.command.DispatchIndirect) {
      action = .{.dispatchIndirect = command};
    } else if (@TypeOf(command) == mtr.command.BindDescriptorSets) {
      action = .{.bindDescriptorSets = command};
    } else if (@TypeOf(command) == mtr.command.PushConstants) {
      action = .{.pushConstants = command};
    } else if (@TypeOf(command) == mtr.command.TransferBufferToImage) {
      action = .{.transferBufferToImage = command};
    } else {
      unreachable; // if this hits, probably need to add the command
    }

    const commandPair = self.getCommandBufferFromId(commandBufferIdx);
    (commandPair.buffer.commandRecordings.addOne()
      catch unreachable
    ).* = action;

    self
      .rasterizer
      .enqueueToCommandBuffer(self, commandBufferIdx, action);
  }

  pub fn submitCommandBufferToQueue(
    self : @This(),
    queueIdx : mtr.queue.Idx,
    commandBufferIdx : mtr.command.BufferIdx,
  ) void {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    var commandBuffer = self.getCommandBufferFromId(commandBufferIdx).buffer;

    std.debug.assert(queue != null);

    self.rasterizer.submitCommandBufferToQueue(
      self, queue.?.*, commandBuffer.*,
    );
  }

  pub fn queueFlush(self : @This(), queueIdx : mtr.queue.Idx) void {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    std.debug.assert(queue != null);

    self.rasterizer.queueFlush(self, queue.?.*);
  }

  pub fn mapMemory(
    self : @This(),
    range : mtr.util.MappedMemoryRange,
  ) ! mtr.util.MappedMemory {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
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
    return self.rasterizer.mapMemory(self, range);
  }

  pub fn mapMemoryBuffer(
    self : @This(),
    range : mtr.util.MappedMemoryRangeBuffer,
  ) ! mtr.util.MappedMemory {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
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
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    return self.rasterizer.unmapMemory(self, memory);
  }

  pub fn constructPipeline(
    _ : @This(),
    _ : mtr.pipeline.ConstructInfo,
  ) !mtr.primitive.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    // const pipeline = mtr.pipeline.Primitive {
    //   .layout = ci.layout,
    //   .depthTestEnable = ci.depthTestEnable,
    //   .depthWriteEnable = ci.depthWriteEnable,
    // };

    // try self.pipelines.putNoClobber(self.allocIdx, mtr.buffer.Primitive);

    // self.allocIdx += 1;

    // return buffer.contextIdx;
  }

  pub fn createShaderModuleWithId(
    self : * @This(),
    ci : mtr.shader.ConstructInfo,
    idx : mtr.shader.Idx,
  ) !mtr.shader.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const shaderModule = mtr.shader.Module {
      .data = ci.data,
      .contextIdx = idx,
    };
    // TODO assert NO overlap

    try self.rasterizer.createShaderModule(self.*, shaderModule);

    // try self.shaderModules.putNoClobber(idx, shaderModule);

    return shaderModule.contextIdx;
  }

  pub fn createShaderModule(
    self : * @This(), ci : mtr.shader.ConstructInfo
  ) !mtr.shader.Idx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.createShaderModuleWithId(ci, prevIdx);
  }

  pub fn createDescriptorSetPoolWithId(
    self : *@This(),
    ci : mtr.descriptor.SetPoolCreateInfo,
    id : u64,
  ) !mtr.descriptor.PoolIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const descriptorSetPool = mtr.descriptor.SetPool {
      .frequency = ci.frequency,
      .maxSets = ci.maxSets,
      .descriptorSizes = ci.descriptorSizes,
      .contextIdx = id,
    };
    try self.descriptorSetPools.putNoClobber(id, descriptorSetPool);
    try self.rasterizer.createDescriptorSetPool(self.*, descriptorSetPool);

    return id;
  }

  pub fn createDescriptorSetPool(
    self : * @This(),
    ci : mtr.descriptor.SetPoolCreateInfo,
  ) !mtr.descriptor.PoolIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.createDescriptorSetPoolWithId(ci, prevIdx);
  }

  pub fn createDescriptorSetWithId(
    self : * @This(),
    ci : mtr.descriptor.Set,
    id : u64
  ) !mtr.descriptor.SetIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var descriptorSet = ci;
    descriptorSet.contextIdx = id;
    try self.descriptorSets.putNoClobber(id, descriptorSet);
    try self.rasterizer.createDescriptorSet(self.*, descriptorSet);

    return id;
  }

  pub fn createDescriptorSet(
    self : * @This(),
    ci : mtr.descriptor.Set,
  ) !mtr.descriptor.SetIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.createDescriptorSetWithId(ci, prevIdx);
  }

  pub fn createDescriptorSetLayoutWithId(
    self : *@This(),
    ci : mtr.descriptor.SetLayoutConstructInfo,
    id : u64
  ) !mtr.descriptor.LayoutIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const setLayout = (
      mtr.descriptor.SetLayout.init(self.primitiveAllocator, ci, id)
    );

    try self.descriptorSetLayouts.putNoClobber(id, setLayout);
    try self.rasterizer.createDescriptorSetLayout(self.*, setLayout);

    return id;
  }

  pub fn createDescriptorSetLayout(
    self : * @This(),
    ci : mtr.descriptor.SetLayoutConstructInfo,
  ) !mtr.descriptor.LayoutIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.createDescriptorSetLayoutWithId(ci, prevIdx);
  }

  pub fn createDescriptorSetWriter(
    self : * @This(),
    layout : mtr.descriptor.LayoutIdx,
    destinationSet : mtr.descriptor.SetIdx,
  ) mtr.descriptor.SetWriter {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const mtLayout = self.descriptorSetLayouts.get(layout).?;
    return mtr.descriptor.SetWriter.init(self, mtLayout, destinationSet);
  }

  pub fn createPipelineLayoutWithId(
    self : * @This(),
    ci : mtr.pipeline.Layout,
    idx : mtr.pipeline.LayoutIdx,
  ) !mtr.pipeline.LayoutIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var pipelineLayout = ci;
    pipelineLayout.contextIdx = idx;
    try self.rasterizer.createPipelineLayout(self.*, pipelineLayout);
    try self.pipelineLayouts.putNoClobber(idx, pipelineLayout);
    return idx;
  }

  pub fn createPipelineLayout(
    self : * @This(),
    ci : mtr.pipeline.Layout,
  ) !mtr.pipeline.LayoutIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.createPipelineLayoutWithId(ci, prevIdx);
  }

  pub fn createComputePipelineWithId(
    self : * @This(),
    ci : mtr.pipeline.Compute,
    idx : mtr.pipeline.ComputeIdx,
  ) !mtr.pipeline.ComputeIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    var pipeline = ci;
    pipeline.contextIdx = idx;
    try self.rasterizer.createComputePipeline(self.*, pipeline);
    try self.computePipelines.putNoClobber(idx, pipeline);
    return idx;
  }

  pub fn createComputePipeline(
    self : * @This(),
    ci : mtr.pipeline.Compute,
  ) !mtr.pipeline.ComputeIdx {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    const prevIdx = self.allocIdx;
    self.allocIdx += 1;
    return self.createComputePipelineWithId(ci, prevIdx);
  }

  // -- utils ------------------------------------------------------------------
  pub fn createHeapRegionAllocator(
    self : * @This(),
    visibility : mtr.heap.Visibility,
  ) mtr.util.HeapRegionAllocator {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    return mtr.util.HeapRegionAllocator.init(self, visibility);
  }

  pub fn createCommandBufferRecorder(
    self : * @This(),
    commandBuffer : mtr.command.BufferIdx,
  ) mtr.util.CommandBufferRecorder {
    std.log.debug("{s}{s}", .{"mtr -- ", @src().fn_name});
    return mtr.util.CommandBufferRecorder.init(self, commandBuffer);
  }
};
