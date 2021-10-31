const mtr = @import("package.zig");
const std = @import("std");

pub const RenderingContextType = enum {
  softwareRasterizer,
};

pub const RenderingOptimizationLevel = enum {
  Release,
  Debug,
};

const RenderingContextSoftwareRasterizer = struct {
  heapAllocator : * std.mem.Allocator,

  pub fn init(heapAllocator : * std.mem.Allocator) @This() {
    return .{
      .heapAllocator = heapAllocator,
    };
  }

  pub fn deinit(_ : * @This()) void { }

  pub fn allocateHeap(
    self : @This(), ci : mtr.heap.ConstructInfo
  ) !mtr.heap.BackingMemory {
    const memory : [] u8 = try self.heapAllocator.alloc(u8, ci.length);
    return mtr.heap.BackingMemory{ .cpu = memory };
  }

  pub fn deallocateHeap(
    self : @This(), heapBackingMemory : mtr.heap.BackingMemory
  ) void {
    self.heapAllocator.free(heapBackingMemory.cpu);
  }

  pub fn mapMemory(
    _ : @This(),
    context : Context,
    range : mtr.util.MappedMemoryRange,
  ) mtr.MappingError ! [*] u8 {
    var buffer = context.buffers.getPtr(range.buffer);

    if (!buffer) {
      return mtr.MappingError.UnknownBufferId;
    }

    if (
         range.offset < buffer.?.length
      or range.offset+range.length < buffer.?.length
    ) {
      return mtr.MappingError.OutOfBounds;
    }

    // TODO possibly make some assertion that the mapping isn't already mapped

    var heap = context.heaps.getPtr(buffer.?.allocatedHeapRegion);
    std.debug.assert(heap);

    if (heap.?.visibility.deviceOnly) {
      return mtr.MappingError.InvalidHeapAccess;
    }

    return heap.?.underlyingMemory.cpu.ptr + range.offset;
  }

  pub fn unmapMemory(
    _ : @This(),
    _ : Context,
    _ : [*] u8,
  ) void {
    // no-op
    // TODO possibly make some assertion that the mapping is currently mapped
  }

  pub fn getMemoryByBufferIdx(
    _ : @This(), context : Context, bufferIdx : mtr.buffer.Idx
  ) [] u8 {
    var buffer = context.buffers.getPtr(bufferIdx);
    std.debug.assert(buffer != null);

    var heapRegion = context.heapRegions.getPtr(buffer.?.allocatedHeapRegion);
    std.debug.assert(heapRegion != null);

    var heap = context.heaps.getPtr(heapRegion.?.allocatedHeap);
    return (
      heap.?.underlyingMemory.cpu[
        heapRegion.?.offset + buffer.?.offset
        ..
        heapRegion.?.offset + buffer.?.offset + buffer.?.length
      ]
    );
  }

  pub fn getMemoryByImageIdx(
    _ : @This(), context : Context, imageIdx : mtr.image.Idx
  ) [] u8 {
    var image = context.images.getPtr(imageIdx);
    std.debug.assert(image != null);

    var heapRegion = context.heapRegions.getPtr(image.?.allocatedHeapRegion);
    std.debug.assert(heapRegion != null);

    var heap = context.heaps.getPtr(heapRegion.?.allocatedHeap);
    return (
      heap.?.underlyingMemory.cpu[
        heapRegion.?.offset + image.?.offset
        ..
        heapRegion.?.offset + image.?.offset + image.?.getImageLength()
      ]
    );
  }

  pub fn queueFlush(
    self : @This(),
    context : Context,
    queue : * mtr.queue.Primitive,
  ) void {
    for (queue.commandActions.items) |commandAction| {
      switch (commandAction) {
        .uploadMemory => |uploadMemory| {
          var dstMemory = (
            self.getMemoryByBufferIdx(context, uploadMemory.buffer)
          );

          const dstMemoryBegin = uploadMemory.offset;
          const dstMemoryEnd = uploadMemory.offset + uploadMemory.memory.len;

          // TODO ERROR this
          std.debug.assert(dstMemoryBegin < dstMemory.len);
          std.debug.assert(dstMemoryEnd <= dstMemory.len);

          std.mem.copy(
            u8,
            dstMemory[dstMemoryBegin .. dstMemoryEnd],
            uploadMemory.memory,
          );
        },
        .transferMemory => |tm| {
          var dstMemory = self.getMemoryByBufferIdx(context, tm.bufferDst);
          var srcMemory = self.getMemoryByBufferIdx(context, tm.bufferSrc);

          // TODO ERROR THIS
          std.debug.assert(tm.offsetDst < dstMemory.len);
          std.debug.assert(tm.offsetSrc < srcMemory.len);

          std.debug.assert(tm.offsetDst + tm.length <= dstMemory.len);
          std.debug.assert(tm.offsetSrc + tm.length <= srcMemory.len);

          std.mem.copy(
            u8,
            dstMemory[tm.offsetDst .. tm.offsetDst+tm.length],
            srcMemory[tm.offsetSrc .. tm.offsetSrc+tm.length],
          );
        },
        .uploadTexelToImageMemory => |tm| {
          const imageOpt = context.images.getPtr(tm.image);
          std.debug.assert(imageOpt != null);
          const image = imageOpt.?;

          var srcMemory = self.getMemoryByImageIdx(context, tm.image);

          const realDimXEnd = (
            if (tm.dimXEnd == -1) image.width else @intCast(u64, tm.dimXEnd)
          );
          const realDimYEnd = (
            if (tm.dimYEnd == -1) image.height else @intCast(u64, tm.dimYEnd)
          );
          const realDimZEnd = (
            if (tm.dimZEnd == -1) image.depth else @intCast(u64, tm.dimZEnd)
          );
          const realDimArrayLayerEnd = (
            if (tm.arrayLayerEnd == -1)
              image.arrayLayers
            else
              @intCast(u64, tm.arrayLayerEnd)
          );
          const realDimMipmapLevelEnd = (
            if (tm.mipmapLevelEnd == -1)
              image.mipmapLevels
            else
              @intCast(u64, tm.mipmapLevelEnd)
          );

          // TODO ASSERT ERROR
          std.debug.assert(tm.dimXBegin >= 0);
          std.debug.assert(tm.dimXBegin < image.width);
          std.debug.assert(tm.dimXBegin < realDimXEnd);
          std.debug.assert(realDimXEnd <= image.width);

          std.debug.assert(tm.dimYBegin >= 0);
          std.debug.assert(tm.dimYBegin < image.height);
          std.debug.assert(tm.dimYBegin < realDimYEnd);
          std.debug.assert(realDimYEnd <= image.height);

          std.debug.assert(tm.dimZBegin >= 0);
          std.debug.assert(tm.dimZBegin < image.depth);
          std.debug.assert(tm.dimZBegin < realDimZEnd);
          std.debug.assert(realDimZEnd <= image.depth);

          std.debug.assert(tm.arrayLayerBegin >= 0);
          std.debug.assert(tm.arrayLayerBegin < image.arrayLayers);
          std.debug.assert(tm.arrayLayerBegin < realDimArrayLayerEnd);
          std.debug.assert(realDimArrayLayerEnd <= image.arrayLayers);

          std.debug.assert(tm.mipmapLevelBegin >= 0);
          std.debug.assert(tm.mipmapLevelBegin < image.mipmapLevels);
          std.debug.assert(tm.mipmapLevelBegin < realDimMipmapLevelEnd);
          std.debug.assert(realDimMipmapLevelEnd <= image.mipmapLevels);

          const texelLength = image.byteFormat.byteLength();
          const rowLength = texelLength*image.channels.channelLength();
          const colLength = rowLength*image.width;
          const depLength = colLength*image.height;
          const mipmapLength = depLength*image.depth;
          const arrayLength = mipmapLength*image.mipmapLevels; // TODO

          // TODO samples?

          var itArrayLayer = @intCast(u64, tm.arrayLayerBegin);
          while (itArrayLayer < realDimArrayLayerEnd) : (itArrayLayer += 1) {
            var itMipmap = @intCast(u64, tm.mipmapLevelBegin);
            while (itMipmap < realDimMipmapLevelEnd) : (itMipmap += 1) {
              // TODO get dimensions
              var itX = @intCast(u64, tm.dimXBegin);
              while (itX < realDimXEnd) : (itX += 1) {
                var itY = @intCast(u64, tm.dimYBegin);
                while (itY < realDimYEnd) : (itY += 1) {
                  var itZ = @intCast(u64, tm.dimZBegin);
                  while (itZ < realDimZEnd) : (itZ += 1) {
                    var itChannel : u64 = 0;
                    while (itChannel < image.channels.channelLength())
                      : (itChannel += 1)
                    {
                      // TODO bit cast whatever to known underlying type
                      var channel : u8 = @intCast(u8, tm.rgba[itChannel]);

                      srcMemory[
                        arrayLength  * itArrayLayer
                      + mipmapLength * itMipmap // TODO
                      + depLength    * itZ
                      + colLength    * itY
                      + rowLength    * itX
                      + texelLength  * itChannel
                      ] = (
                        channel
                      );
                    }
                  }
                }
              }
            }
          }
        },
        else => {
          std.debug.assert(false);
          // TODO ERROR
        }
      }
    }

    queue.commandActions.clearAndFree();
  }
};

pub const RenderingContext = union(RenderingContextType) {
  softwareRasterizer : RenderingContextSoftwareRasterizer,

  pub fn mapMemory(
    self : * @This(),
    context : Context,
    range : mtr.util.MappedMemoryRange,
  ) [*] u8 {
    return switch (self.*) {
      .softwareRasterizer => (
        self.softwareRasterizer.mapMemory(context, range)
      )
    };
  }

  pub fn unmapMemory(
    self : * @This(),
    context : Context,
    ptr : [*] u8
  ) void {
    return switch (self.*) {
      .softwareRasterizer => (
        self.softwareRasterizer.unmapMemory(context, ptr)
      )
    };
  }

  pub fn deallocateHeap(
    self : * @This(),
    heapBackingMemory : mtr.heap.BackingMemory,
  ) void {
    switch (self.*) {
      .softwareRasterizer => (
        self.softwareRasterizer.deallocateHeap(heapBackingMemory)
      )
    }
  }

  pub fn queueFlush(
    self : @This(),
    context : Context,
    queue : * mtr.queue.Primitive,
  ) void {
    switch (self) {
      .softwareRasterizer => (
        self.softwareRasterizer.queueFlush(context, queue)
      )
    }
  }
};

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

  primitiveAllocator : * std.mem.Allocator,

  renderingContext : * RenderingContext,
  optimization : RenderingOptimizationLevel,

  allocIdx : u64, // temporary FIXME

  pub fn init(
    primitiveAllocator : * std.mem.Allocator,
    renderingContext : RenderingContextType,
    optimization : RenderingOptimizationLevel,
  ) @This() {
    const self : @This() = undefined;
    var allocatedRenderingContext = (
      primitiveAllocator.create(RenderingContext)
    ) catch {
      std.debug.panic("could not allocate rendering context", .{});
    };

    allocatedRenderingContext.* = (
      switch (renderingContext) {
        .softwareRasterizer => (.{
          .softwareRasterizer = (
            RenderingContextSoftwareRasterizer.init(primitiveAllocator)
          ),
        }),
      }
    );

    return .{
      .heaps = @TypeOf(self.heaps).init(primitiveAllocator),
      .queues = @TypeOf(self.queues).init(primitiveAllocator),
      .heapRegions = @TypeOf(self.heapRegions).init(primitiveAllocator),
      .buffers = @TypeOf(self.buffers).init(primitiveAllocator),
      .images = @TypeOf(self.images).init(primitiveAllocator),
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
    self.images.deinit();
    self.primitiveAllocator.destroy(self.renderingContext);
    switch (self.renderingContext.*) {
      .softwareRasterizer => (
        self.renderingContext.softwareRasterizer.deinit()
      ),
    }
  }

  pub fn constructHeap(
    self : * @This(),
    ci : mtr.heap.ConstructInfo
  ) !mtr.heap.Idx {
    const heap = mtr.heap.Primitive {
      .underlyingMemory = (
        switch (self.renderingContext.*) {
          .softwareRasterizer => (
            try self.renderingContext.softwareRasterizer.allocateHeap(ci)
          )
        }
      ),
      .length = ci.length,
      .visibility = ci.visibility,
      .contextIdx = self.allocIdx,
    };

    try self.heaps.putNoClobber(self.allocIdx, heap);

    self.allocIdx += 1;

    return heap.contextIdx;
  }

  pub fn destroyHeap(self : * @This(), heapIdx : mtr.heap.Idx) void {
    const heap : ? * mtr.heap.Primitive = self.heaps.getPtr(heapIdx);
    std.debug.assert(heap != null);

    self.renderingContext.deallocateHeap(heap.?.underlyingMemory);

    _ = self.heaps.remove(heapIdx);
  }

  pub fn destroyQueue(self : * @This(), queueIdx : mtr.queue.Idx) void {
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    std.debug.assert(queue != null);

    queue.?.commandActions.deinit();

    _ = self.queues.remove(queueIdx);
  }

  pub fn constructHeapRegion(
    self : * @This(), ci : mtr.heap.RegionConstructInfo
  ) !mtr.heap.RegionIdx {
    const heapRegion = mtr.heap.Region {
      .allocatedHeap = ci.allocatedHeap,
      .offset = 0, // TODO FIX ME with a proper allocator
      .length = ci.length,
      .contextIdx = self.allocIdx,
    };

    // TODO assert length/offset of region is less than the allocated heap
    //   length
    // TODO assert NO overlap with other heap regions in debug mode

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

    try self.images.putNoClobber(self.allocIdx, image);
    self.allocIdx += 1;

    return image.contextIdx;
  }

  pub fn getImageByteLength(self : @This(), idx : mtr.image.Idx) u64 {
    const image = self.images.getPtr(idx);
    std.debug.assert(image != null);
    return image.?.getImageLength();
  }

  pub fn constructQueue(
    self : * @This(),
    ci : mtr.queue.ConstructInfo,
  ) !mtr.queue.Idx {
    const queue = mtr.queue.Primitive {
      .commandActions = (
        std.ArrayList(mtr.command.Action).init(self.primitiveAllocator)
      ),
      .workType = ci.workType,
      .contextIdx = self.allocIdx,
    };

    try self.queues.putNoClobber(self.allocIdx, queue);

    self.allocIdx += 1;

    return queue.contextIdx;
  }

  pub fn enqueueCommand(
    self : * @This(), queueIdx : mtr.queue.Idx, command : anytype
  ) !void {
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    std.debug.assert(queue != null);
    if (@TypeOf(command) == mtr.command.UploadMemory) {
      try queue.?.commandActions.append(.{.uploadMemory = command});
    } else if (@TypeOf(command) == mtr.command.TransferMemory) {
      try queue.?.commandActions.append(.{.transferMemory = command});
    } else if (@TypeOf(command) == mtr.command.UploadTexelToImageMemory) {
      try queue.?.commandActions.append(.{.uploadTexelToImageMemory = command});
    } else {
      unreachable; // if this hits, probably need to add the command
    }
  }

  pub fn queueFlush(self : @This(), queueIdx : mtr.queue.Idx) void {
    var queue : ? * mtr.queue.Primitive = self.queues.getPtr(queueIdx);
    std.debug.assert(queue != null);

    self.renderingContext.queueFlush(self, queue.?);
  }

  pub fn mapBufferMemory(
    self : @This(),
    range : mtr.util.MappedMemoryRange,
  ) mtr.util.MappedMemory {
    return mtr.util.MappedMemory.init(self, range);
  }
};
