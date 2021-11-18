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
};

pub const HeapRegionAllocator = struct {
  heap : mtr.heap.Idx,
  suballocations : std.ArrayList(AllocatorInfo),
  trackingOffset : usize,
  mtrCtx : * mtr.Context,

  pub fn init(ctx : * mtr.Context, heap : mtr.heap.Idx) HeapRegionAllocator {
    return .{
      .heap = heap,
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

    // create a subheap to allocate all these resources under
    const heapRegion : mtr.heap.RegionIdx = (
      self.mtrCtx.constructHeapRegion(.{
        .allocatedHeap = self.heap,
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
        .image => |_| {
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
        .buffer = buffer,
        .relativeOffset = self.trackingOffset,
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
        .image = image,
        .relativeOffset = self.trackingOffset,
      }
    };
    self.trackingOffset += memoryRequirements.length;

    return image;
  }

  const BufferInfo = struct {
    buffer : mtr.buffer.Idx,
    relativeOffset : usize,
  };

  const ImageInfo = struct {
    image : mtr.image.Idx,
    relativeOffset : usize,
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
