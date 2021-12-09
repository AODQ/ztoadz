const mtr = @import("package.zig");
const std = @import("std");

pub const PoolIdx = u64;
pub const BufferIdx = u64;

pub const ActionType = enum {
  pipelineBarrier,
  transferImageToBuffer,
  transferMemory,
  uploadTexelToImageMemory,
  bindPipeline,
  dispatch,
  bindDescriptorSets,

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
  xOffset : u32 = 0, yOffset : u32 = 0, zOffset : u32 = 0,
  width : u32, height : u32, depth : u32 = 1,
  mipmapLayerBegin : u32 = 0,
  mipmapLayerCount : u32 = 1, // if 0 assume all
  arrayLayerBegin : u32 = 0,
  arrayLayerCount : u32 = 1, // if 0 assume all
  // TODO subregions i guess
};

pub const TransferImage = struct {
  actionType : mtr.command.ActionType = .transferImage,
  imageSrc : mtr.image.Idx,
  imageDst : mtr.image.Idx,
  srcDimX : u64, srcDimY : u64, srcDimZ : u64,
  srcArrayLayer : u64, srcMipmap : u64,

  dstOffX : u64, dstOffY : u64, dstOffZ : u64,
  dstArrayLayer : u64, dstMipmap : u64,

  width : u64, height : u64, depth : u64,
  layers : u64, mipmaps : u64
};

pub const PipelineBarrier = struct {
  actionType : mtr.command.ActionType = .pipelineBarrier,
  srcStage : mtr.pipeline.StageFlags,
  dstStage : mtr.pipeline.StageFlags,
  imageTapes : [] ImageTapeAction = &[_] ImageTapeAction {},
  bufferTapes : [] BufferTapeAction = &[_] BufferTapeAction {},

  pub const ImageTapeAction = struct {
    tape : * ImageTape,
    layout : mtr.image.Layout,
    accessFlags : mtr.AccessFlags,
  };

  pub const BufferTapeAction = struct {
    tape : * BufferTape,
    accessFlags : mtr.AccessFlags,
  };
};

pub const BufferTape = struct {
  buffer : mtr.buffer.Idx,
  offset : usize = 0,
  length : usize = 0, // implied to be entire buffer
  accessFlags : mtr.AccessFlags = .{},
};

// tapes allow you to keep track of the current state while recording commands
pub const ImageTape = struct {
  image : mtr.image.Idx,
  layout : mtr.image.Layout = .uninitialized,
  accessFlags : mtr.AccessFlags = .{},
};

pub const imageRangeEnd : i64 = -1;

// uploads a single texel to image memory, copying it to the entire specified
//   sub-region
pub const UploadTexelToImageMemory = struct {
  // TODO vectors duh
  actionType : mtr.command.ActionType = .uploadTexelToImageMemory,
  imageTape : mtr.command.ImageTape,
  rgba : [4] f32,
  dimXBegin : i64 = 0, dimXEnd : i64 = imageRangeEnd,
  dimYBegin : i64 = 0, dimYEnd : i64 = imageRangeEnd,
  dimZBegin : i64 = 0, dimZEnd : i64 = imageRangeEnd,
  arrayLayerBegin : i64 = 0, arrayLayerEnd : i64 = imageRangeEnd,
  mipmapLevelBegin : i64 = 0, mipmapLevelEnd : i64 = imageRangeEnd,
};

pub const BindPipeline = struct {
  pipeline : mtr.pipeline.ComputeIdx,
};

pub const Dispatch = struct {
  width : u32, height : u32, depth : u32,
};

pub const BindDescriptorSets = struct {
  pipelineLayout : mtr.pipeline.LayoutIdx,
  descriptorSets : [] mtr.descriptor.LayoutIdx,
};

// some amount of action independent of another, such that one complete amount
//   of work can be made between the GPU and CPU. Such as blits, allocations,
//   initiating a render dispatch, etc
// Commands are not unique, and as such are treated as primitives and may
//   not refer to any specific unique index of a queue
pub const Action = union(ActionType) {
  transferMemory : mtr.command.TransferMemory,
  transferImageToBuffer : mtr.command.TransferImageToBuffer,
  pipelineBarrier : mtr.command.PipelineBarrier,
  uploadTexelToImageMemory : mtr.command.UploadTexelToImageMemory,
  bindPipeline : mtr.command.BindPipeline,
  dispatch : mtr.command.Dispatch,
  bindDescriptorSets : mtr.command.BindDescriptorSets,

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
