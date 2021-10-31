const mtr = @import("package.zig");
const std = @import("std");

pub const Idx = u64;

pub const ActionType = enum {
  uploadMemory,
  transferMemory,
  uploadTexelToImageMemory,
  invalid,
};

pub const MappingError = error {
  OutOfBounds,
  UnknownBufferId,
  InvalidHeapAccess,
};

// uploads memory from the host to the device at a specified hostVisible buffer
pub const UploadMemory = struct {
  actionType : mtr.command.ActionType = .uploadMemory,
  buffer : mtr.buffer.Idx,
  offset : u64,
  memory : [] const u8,
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
  rgba : [4] u32,
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
  uploadMemory : mtr.command.UploadMemory,
  transferMemory : mtr.command.TransferMemory,
  uploadTexelToImageMemory : mtr.command.UploadTexelToImageMemory,
  invalid : void,
};
