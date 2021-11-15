const mtr = @import("package.zig");
const std = @import("std");

pub const Idx = u64;
pub const PoolIdx = u64;
pub const BufferIdx = u64;

pub const ActionType = enum {
  transferMemory,
  transferImageToBuffer,
  uploadTexelToImageMemory,

  pub const jsonStringify = mtr.util.json.JsonEnumMixin.jsonStringify;
};

// transfers memory from one buffer to another. The source and destination
// buffer may be the same
pub const TransferMemory = struct {
  actionType : mtr.command.ActionType = .transferMemory,
  bufferSrc : mtr.buffer.Idx,
  bufferDst : mtr.buffer.Idx,
  offsetSrc : u64,
  offsetDst : u64,
  length : u64,
};

pub const TransferImageToBuffer = struct {
  actionType : mtr.command.ActionType = .transferImageToBuffer,
  imageSrc : mtr.image.Idx,
  bufferDst : mtr.buffer.Idx,
  // TODO subregions i guess
};

pub const TransferImage = struct {
  actionType : mtr.command.ActionType = .transferImage,
  imageSrc : mtr.image.Idx,
  imageDst : mtr.image.Idx,
  srcDimX : u64, srcDimY : u64, srcDimZ : u64,
  srcArrayLayer : u64, srcMipmap : u64,

  dstDimX : u64, dstDimY : u64, dstDimZ : u64,
  dstArrayLayer : u64, dstMipmap : u64,

  width : u64, height : u64, depth : u64,
  layers : u64, mipmaps : u64
};

pub const imageRangeEnd : i64 = -1;

// uploads a single texel to image memory, copying it to the entire specified
//   sub-region
pub const UploadTexelToImageMemory = struct {
  // TODO vectors duh
  actionType : mtr.command.ActionType = .uploadTexelToImageMemory,
  image : mtr.image.Idx,
  rgba : [4] f32,
  dimXBegin : i64 = 0, dimXEnd : i64 = imageRangeEnd,
  dimYBegin : i64 = 0, dimYEnd : i64 = imageRangeEnd,
  dimZBegin : i64 = 0, dimZEnd : i64 = imageRangeEnd,
  arrayLayerBegin : i64 = 0, arrayLayerEnd : i64 = imageRangeEnd,
  mipmapLevelBegin : i64 = 0, mipmapLevelEnd : i64 = imageRangeEnd,
};

// some amount of action independent of another, such that one complete amount
//   of work can be made between the GPU and CPU. Such as blits, allocations,
//   initiating a render dispatch, etc
// Commands are not unique, and as such are treated as primitives and may
//   not refer to any specific unique index of a queue
pub const Action = union(ActionType) {
  transferMemory : mtr.command.TransferMemory,
  transferImageToBuffer : mtr.command.TransferImageToBuffer,
  uploadTexelToImageMemory : mtr.command.UploadTexelToImageMemory,

  // pub fn jsonStringify(
  //   self : @This(),
  //   options : std.json.StringifyOptions,
  //   outStream : anytype
  // ) @TypeOf(outStream).Error ! void {
  //   try outStream.writeByte('{');

  //   const unionInfo = @typeInfo(@This()).Union;

  //   inline for (unionInfo.fields) |field| {
  //     if (self == @field(unionInfo.tag_type.?, field.name)) {
  //       try std.json.stringify("has", options, outStream);
  //     }
  //     else {
  //       try std.json.stringify("not has", options, outStream);
  //     }
  //   }

  //   // try mtr.Context.dumpBufferToWriter(self.contextIdx, outStream);

  //   try outStream.writeByte('}');
  // }
};

pub const PoolFlag = packed struct {
  transient : bool = false,
  resetCommandBuffer : bool = false,
};

pub const PoolConstructInfo = struct {
  flags : mtr.command.PoolFlag,
  queue : mtr.queue.Idx,
};

pub const Pool = struct {
  flags : mtr.command.PoolFlag,
  commandBuffers : std.AutoHashMap(mtr.buffer.Idx, mtr.command.Buffer),
  queue : mtr.queue.Idx,
  contextIdx : mtr.command.PoolIdx,

  pub fn deinit(self : * @This()) void {
    var bufIter = self.commandBuffers.iterator();
    while (bufIter.next()) |buffer| {
      buffer.value_ptr.deinit();
    }
    self.commandBuffers.deinit();
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

    try mtr.util.json.stringifyVariable(
      "queue", self.queue, options, outStream
    );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyVariable(
      "flags", self.flags, options, outStream
    );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyVariable(
      "contextIdx", self.contextIdx, options, outStream
    );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyHashMap(
      "commandBuffers", self.commandBuffers, options, outStream
    );

    try outStream.writeByte('}');
  }
};

pub const BufferConstructInfo = struct {
  commandPool : mtr.command.PoolIdx,
  // assume only primary for now
};

pub const Buffer = struct {
  commandPool : mtr.command.PoolIdx,
  commandRecordings : std.ArrayList(mtr.command.Action),
  idx : u64,

  pub fn init(alloc : * std.mem.Allocator) @This() {
    // TODO this should only be enabled in debug builds
    return .{
      .commandRecordings = std.ArrayList(mtr.command.Action).init(alloc),
    };
  }

  pub fn deinit(self : * @This()) void {
    self.commandRecordings.deinit();
  }

  pub fn jsonStringify(
    self : @This(),
    options : std.json.StringifyOptions,
    outStream : anytype
  ) @TypeOf(outStream).Error ! void {
    try outStream.writeByte('{');

    try mtr.util.json.stringifyVariable(
      "commandPool", self.commandPool, options, outStream
    );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyVariable(
      "idx", self.idx, options, outStream
    );
    try outStream.writeByte(',');
    try mtr.util.json.stringifyVariable(
      "commandRecordings", self.commandRecordings.items, options, outStream
    );

    try outStream.writeByte('}');
  }
};
