pub const json = @import("json.zig");
pub const snapshot = @import("snapshot.zig");

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

    std.log.info("tracking offset: {}", .{self.trackingOffset});

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

pub const CommandBufferRecorder = struct {
  commandBuffer : mtr.command.BufferIdx,
  mtrCtx : * mtr.Context,

  pub fn init(
    ctx : * mtr.Context,
    commandBuffer : mtr.command.BufferIdx,
  ) CommandBufferRecorder {
    ctx.beginCommandBufferWriting(commandBuffer);
    return .{
      .mtrCtx = ctx,
      .commandBuffer = commandBuffer,
    };
  }

  pub fn finish(self : @This()) void {
    self.mtrCtx.endCommandBufferWriting(self.commandBuffer);
  }

  pub fn append(
    self : @This(),
    command : anytype,
  ) void {
    self.mtrCtx.enqueueToCommandBuffer(self.commandBuffer, command);
  }
};
