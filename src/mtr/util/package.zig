pub const json = @import("json.zig");
pub const snapshot = @import("snapshot.zig");
pub const screenshot = @import("screenshot.zig");

const mtr = @import("../package.zig");
const std = @import("std");

pub const MappingError = error {
  OutOfBounds,
  UnknownBufferId,
  InvalidHeapAccess,
};

pub const MappingType = enum {
  Write, Read,

  pub const jsonStringify = mtr.util.json.JsonEnumMixin.jsonStringify;
};

pub const MappedMemoryRange = struct {
  mapping : mtr.util.MappingType, // redundant, this must match Heap visibility
  heapRegion : mtr.heap.RegionIdx,
  offset : u64 = 0, length : u64 = 0, // if length is 0, assume entire buffer
};

pub const MappedMemoryRangeBuffer = struct {
  mapping : mtr.util.MappingType, // redundant, this must match Heap visibility
  buffer : mtr.buffer.Idx,
  offset : u64 = 0, length : u64 = 0, // if length is 0, assume entire buffer
};

pub const MappedMemory = struct {
  ptr : [*] u8,
  mapping : mtr.heap.RegionIdx,
};

pub const MemoryRequirements = struct {
  length : usize,
  alignment : usize,
  typeBits : u32,
};

pub const HeapRegionAllocator = struct {
  visibility : mtr.heap.Visibility,
  suballocations : std.ArrayList(AllocatorInfo),
  trackingOffset : usize,
  mtrCtx : * mtr.Context,

  pub fn init(
    ctx : * mtr.Context,
    visibility : mtr.heap.Visibility,
  ) HeapRegionAllocator {
    return .{
      .visibility = visibility,
      .suballocations = (
        std.ArrayList(AllocatorInfo).init(ctx.primitiveAllocator)
      ),
      .trackingOffset = 0,
      .mtrCtx = ctx,
    };
  }

  pub fn finish(self : * @This()) mtr.heap.RegionIdx {
    if (self.suballocations.items.len == 0) {
      return 0; // TODO return null handle
    }

    var memoryRequirements = (
      std
        .ArrayList(mtr.util.MemoryRequirements)
        .init(self.mtrCtx.primitiveAllocator)
    );
    defer memoryRequirements.deinit();

    for (self.suballocations.items) |suballocation| {
      switch (suballocation) {
        .buffer => |buffer| {
          (memoryRequirements.addOne() catch unreachable).* = (
            buffer.memoryRequirements
          );
        },
        .image => |image| {
          (memoryRequirements.addOne() catch unreachable).* = (
            image.memoryRequirements
          );
        },
      }
    }

    // get the appropiate heap
    const heap : mtr.heap.Idx = (
      self.mtrCtx.createHeapFromMemoryRequirements(
        .{ .visibility = self.visibility },
        memoryRequirements.items,
      ) catch unreachable
    );

    // create a subheap to allocate all these resources under
    const heapRegion : mtr.heap.RegionIdx = (
      self.mtrCtx.constructHeapRegion(.{
        .allocatedHeap = heap,
        .length = self.trackingOffset,
      }) catch unreachable
    );

    for (self.suballocations.items) |suballoc| {
      switch (suballoc) {
        .buffer => |buffer| {
          self.mtrCtx.bindBufferToSubheap(
            buffer.buffer,
            buffer.relativeOffset,
            heapRegion,
          );
        },
        .image => |image| {
          self.mtrCtx.bindImageToSubheap(
            image.image,
            image.relativeOffset,
            heapRegion,
          );
        }
      }
    }

    self.suballocations.deinit();

    return heapRegion;
  }

  pub fn createBuffer(
    self : * @This(),
    ci : mtr.buffer.ConstructInfo
  ) !mtr.buffer.Idx {
    var buffer = try self.mtrCtx.constructBuffer(ci);
    var memoryRequirements = self.mtrCtx.bufferMemoryRequirements(buffer);

    // align this buffer's offset
    self.trackingOffset += (
        (memoryRequirements.alignment - self.trackingOffset)
      % memoryRequirements.alignment
    );
    (try self.suballocations.addOne()).* = .{
      .buffer = .{
        .memoryRequirements = memoryRequirements,
        .relativeOffset = self.trackingOffset,
        .buffer = buffer,
      }
    };
    self.trackingOffset += memoryRequirements.length;

    return buffer;
  }

  pub fn createImage(
    self : * @This(),
    ci : mtr.image.ConstructInfo
  ) !mtr.image.Idx {
    var image = try self.mtrCtx.constructImage(ci);
    var memoryRequirements = self.mtrCtx.imageMemoryRequirements(image);

    // align this image's offset
    self.trackingOffset += (
        (memoryRequirements.alignment - self.trackingOffset)
      % memoryRequirements.alignment
    );
    (try self.suballocations.addOne()).* = .{
      .image = .{
        .memoryRequirements = memoryRequirements,
        .relativeOffset = self.trackingOffset,
        .image = image,
      }
    };
    self.trackingOffset += memoryRequirements.length;

    return image;
  }

  const BufferInfo = struct {
    memoryRequirements : mtr.util.MemoryRequirements,
    relativeOffset : usize,
    buffer : mtr.buffer.Idx,
  };

  const ImageInfo = struct {
    memoryRequirements : mtr.util.MemoryRequirements,
    relativeOffset : usize,
    image : mtr.image.Idx,
  };

  const AllocatorTag = enum {
    buffer, image,
  };

  const AllocatorInfo = union(AllocatorTag) {
    buffer : BufferInfo,
    image : ImageInfo,
  };
};

pub const FinalizedCommandBufferTapes = struct {
  bufferTapes : std.AutoHashMap(mtr.buffer.Idx, mtr.memory.BufferTape),
  imageTapes : std.AutoHashMap(mtr.image.Idx, mtr.memory.ImageTape),

  pub fn deinit(self : * @This()) void {
    self.bufferTapes.deinit();
    self.imageTapes.deinit();
  }
};

pub const CommandBufferRecorder = struct {
  commandBuffer : mtr.command.BufferIdx,
  mtrCtx : * mtr.Context,

  bufferTapes : std.AutoHashMap(mtr.buffer.Idx, mtr.memory.BufferTape),
  imageTapes : std.AutoHashMap(mtr.image.Idx, mtr.memory.ImageTape),

  pub const InitParams = struct {
    ctx : * mtr.Context,
    commandBuffer : mtr.command.BufferIdx,
    bufferTapes : [] mtr.memory.BufferTape = &[_] mtr.memory.BufferTape {},
    imageTapes : [] mtr.memory.ImageTape = &[_] mtr.memory.ImageTape {},
    // commandBufferTapes just get copied to buffer/image-tapes at init
    commandBufferTapes : [] mtr.util.FinalizedCommandBufferTapes = (
      &[_] mtr.util.FinalizedCommandBufferTapes {}
    ),
  };

  pub fn init(
    params : InitParams,
  ) !@This() {
    try params.ctx.beginCommandBufferWriting(params.commandBuffer);
    var self = @This() {
      .mtrCtx = params.ctx,
      .commandBuffer = params.commandBuffer,
      .bufferTapes = (
        std
          .AutoHashMap(mtr.buffer.Idx, mtr.memory.BufferTape)
          .init(params.ctx.primitiveAllocator)
      ),
      .imageTapes = (
        std
          .AutoHashMap(mtr.image.Idx, mtr.memory.ImageTape)
          .init(params.ctx.primitiveAllocator)
      ),
    };

    // put in the command buffer tapes first, so they can be overwritten
    for (params.commandBufferTapes) |_, it| {
      var bufferTapeIterator = (
        params.commandBufferTapes[it].bufferTapes.iterator()
      );
      while (bufferTapeIterator.next()) |bufferTapeIter| {
        var bufferTape = bufferTapeIter.value_ptr;
        try self.bufferTapes.put(bufferTape.buffer, bufferTape.*);
      }
      var imageTapeIterator = (
        params.commandBufferTapes[it].imageTapes.iterator()
      );
      while (imageTapeIterator.next()) |imageTapeIter| {
        var imageTape = imageTapeIter.value_ptr;
        try self.imageTapes.put(imageTape.image, imageTape.*);
      }
    }
    for (params.bufferTapes) |bufferTape| {
      var prev = try self.bufferTapes.fetchPut(bufferTape.buffer, bufferTape);
      if (prev != null) {
        std.log.warn("{s}{}", .{"overwriting previous value:", prev});
      }
    }
    for (params.imageTapes) |imageTape| {
      var prev = try self.imageTapes.fetchPut(imageTape.image, imageTape);
      if (prev != null) {
        std.log.warn("{s}{}", .{"overwriting previous value:", prev});
      }
    }

    return self;
  }

  pub fn deinit(self : * @This()) void {
    self.bufferTapes.deinit();
    self.imageTapes.deinit();
  }

  // this will deinitialize self, returning the final image/bufferTapes.
  //   This releases ownership of image/bufferTapes, so you must deallocate
  pub fn finishWithFinalizedTapes(
    self : * @This()
  ) FinalizedCommandBufferTapes {
    self.mtrCtx.endCommandBufferWriting(self.commandBuffer);
    return .{
      .imageTapes = self.imageTapes,
      .bufferTapes = self.bufferTapes,
    };
  }

  pub fn finish(self : * @This()) void {
    self.mtrCtx.endCommandBufferWriting(self.commandBuffer);
    self.deinit();
  }

  pub fn append(
    self : @This(),
    command : anytype,
  ) !void {

    var commandCopy = command;

    // -- apply any actions that require being filled out by context such as
    //    tapes
    if (@TypeOf(command) == mtr.command.PipelineBarrier) {
      // -- insert the image/buffer tapes
      for (command.bufferTapes) |bufferTape, idx| {
        commandCopy.bufferTapes[idx].tape = (
          self.bufferTapes.getPtr(bufferTape.buffer).?
        );
      }

      for (command.imageTapes) |imageTape, idx| {
        commandCopy.imageTapes[idx].tape = (
          self.imageTapes.getPtr(imageTape.image).?
        );
      }
    }

    if (@TypeOf(command) == mtr.command.UploadTexelToImageMemory) {
      commandCopy.imageTape = self.imageTapes.getPtr(command.image).?;
    }

    try self.mtrCtx.enqueueToCommandBuffer(self.commandBuffer, commandCopy);
  }
};

pub const StageMemoryToImageParams = struct {
  queue : mtr.queue.Idx,
  commandBuffer : mtr.command.BufferIdx,
  imageDst : mtr.image.Idx,
  imageDstLayout : mtr.image.Layout,
  imageDstAccessFlags : mtr.memory.AccessFlags,
  memoryToUpload : [] const u8,
};

pub fn stageMemoryToImage(
  mtrCtx : * mtr.Context,
  params : StageMemoryToImageParams,
) !void {
  var stagingBuffer : mtr.buffer.Idx = 0;
  var heapRegion : mtr.heap.RegionIdx = 0;
  // defer mtrCtx.destroyBuffer(stagingBuffer);
  // defer mtrCtx.destroyHeapRegion(heapRegion);
  { // -- create staging buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.hostWritable);
    defer heapRegion = heapRegionAllocator.finish();

    stagingBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .label = "staging-memory-to-image",
        .offset = 0,
        .length = @sizeOf(u8)*params.memoryToUpload.len,
        .usage = mtr.buffer.Usage{ .transferSrc = true },
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      })
    );
  }

  std.log.info("will copy {} bytes", .{params.memoryToUpload.len});

  { // -- copy data
    var mappedMemory = try mtrCtx.mapMemoryBuffer(.{
      .mapping = mtr.util.MappingType.Write,
      .buffer = stagingBuffer,
      .offset = 0, .length = @sizeOf(u8)*params.memoryToUpload.len,
    });
    defer mtrCtx.unmapMemory(mappedMemory);

    std.mem.copy(
      u8,
      mappedMemory.ptr[0..params.memoryToUpload.len],
      params.memoryToUpload
    );
  }

  {
    var commandBufferRecorder = (
      try mtr.util.CommandBufferRecorder.init(.{
        .ctx = mtrCtx,
        .commandBuffer = params.commandBuffer,
        .imageTapes = &[_] mtr.memory.ImageTape {
          .{
            .image = params.imageDst,
            .layout = params.imageDstLayout,
            .accessFlags = params.imageDstAccessFlags,
          }
        }
      })
    );
    defer commandBufferRecorder.finish();

    // transition image into transfer
    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .host = true },
        .dstStage = .{ .transfer = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .image = params.imageDst,
              .layout = .transferDst,
              .accessFlags = .{ .transferSrc = true, },
            },
          }
        ),
      },
    );

    // stage the copy TODO proper width/height
    try commandBufferRecorder.append(
      mtr.command.TransferBufferToImage {
        .bufferSrc = stagingBuffer,
        .imageDst = params.imageDst,
        .xOffset = 0, .yOffset = 0, .zOffset = 0,
        .width = 1024, .height = 1024, .depth = 1,
      }
    );

    // put the image back into general layout
    // TODO we probably want to set the layout to what it was before, but in
    // case of uninitialized set it to general
    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .transfer = true },
        .dstStage = .{ .end = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            .{
              .image = params.imageDst,
              .layout = .general,
              .accessFlags = .{ },
            },
          }
        ),
      },
    );
  }

  try mtrCtx.submitCommandBufferToQueue(
    params.queue, params.commandBuffer, .{}
  );
}

pub const StageMemoryToBufferParams = struct {
  queue : mtr.queue.Idx,
  commandBuffer : mtr.command.BufferIdx,
  bufferDst : mtr.buffer.Idx,
  memoryToUpload : [] const u8,
};

// This creates a staging buffer, then records memory staging with given
//   command buffer & immediately submits it to the provided queue.
// This is useful for simple resource loading, but for things in-flight
//   it's probably faster to use a compute shader and/or buffer copies
pub fn stageMemoryToBuffer(
  mtrCtx : * mtr.Context,
  params : StageMemoryToBufferParams,
) !void {
  var stagingBuffer : mtr.buffer.Idx = 0;
  var heapRegion : mtr.heap.RegionIdx = 0;
  // defer mtrCtx.destroyBuffer(stagingBuffer);
  // defer mtrCtx.destroyHeapRegion(heapRegion);
  { // -- create staging buffer
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.hostWritable);
    defer heapRegion = heapRegionAllocator.finish();

    stagingBuffer = try (
      heapRegionAllocator.createBuffer(.{
        .label = "staging-buffer-memory-to-buffer",
        .offset = 0,
        .length = @sizeOf(u8)*params.memoryToUpload.len,
        .usage = mtr.buffer.Usage{ .transferSrc = true },
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      })
    );
  }

  { // -- copy data
    var mappedMemory = try mtrCtx.mapMemoryBuffer(.{
      .mapping = mtr.util.MappingType.Write,
      .buffer = stagingBuffer,
      .offset = 0, .length = @sizeOf(u8)*params.memoryToUpload.len,
    });
    defer mtrCtx.unmapMemory(mappedMemory);

    std.mem.copy(
      u8,
      mappedMemory.ptr[0..params.memoryToUpload.len],
      params.memoryToUpload
    );
  }

  {
    var commandBufferRecorder = (
      try mtr.util.CommandBufferRecorder.init(.{
        .ctx = mtrCtx,
        .commandBuffer = params.commandBuffer,
      })
    );
    defer commandBufferRecorder.finish();

    try commandBufferRecorder.append(
      mtr.command.TransferMemory {
        .bufferSrc = stagingBuffer,
        .bufferDst = params.bufferDst,
        .offsetSrc = 0,
        .offsetDst = 0,
        .length = @sizeOf(u8)*params.memoryToUpload.len,
      },
    );
  }

  try mtrCtx.submitCommandBufferToQueue(
    params.queue, params.commandBuffer, .{}
  );
}
