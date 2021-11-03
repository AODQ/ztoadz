const mtr = @import("package.zig");
const std = @import("std");

pub const Idx = u64;
pub const PoolIdx = u64;
pub const BufferIdx = u64;

pub const ActionType = enum {
  mapMemory,
  unmapMemory,
  transferMemory,
  transferImageToBuffer,
  uploadTexelToImageMemory,
  invalid,
};

pub const MappingError = error {
  OutOfBounds,
  UnknownBufferId,
  InvalidHeapAccess,
};

pub const MappingType = enum {
  Write, Read,
};

// uploads memory from the host to the device at a specified hostVisible buffer
// TODO this command should be removed
//      the user needs to upload memory themselves by using memory mappings
pub const MapMemory = struct {
  actionType : mtr.command.ActionType = .mapMemory,
  mapping : MappingType, // redundant, this must match Heap visibility
  buffer : mtr.buffer.Idx,
  offset : u64 = 0, length : u64 = 0, // if length is 0, assume entire buffer
  memory : * ? [*] u8
};

pub const UnmapMemory = struct {
  actionType : mtr.command.ActionType = .unmapMemory,
  buffer : mtr.buffer.Idx,
  memory : [*] u8
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
  mapMemory : mtr.command.MapMemory,
  unmapMemory : mtr.command.UnmapMemory,
  transferMemory : mtr.command.TransferMemory,
  transferImageToBuffer : mtr.command.TransferImageToBuffer,
  uploadTexelToImageMemory : mtr.command.UploadTexelToImageMemory,
  invalid : void,
};

pub const PoolFlag = packed struct {
  transientBit : bool = false,
  resetCommandBuffer : bool = false,
};

pub const PoolConstructInfo = struct {
  // TODO queue family
  flags : mtr.command.PoolFlag,
};

pub const Pool = struct {
  flags : mtr.command.PoolFlag,
  contextIdx : mtr.command.PoolIdx,
};

pub const BufferConstructInfo = struct {
  commandPool : mtr.command.PoolIdx,
  // assume only primary for now
};

pub const Buffer = struct {
  commandPool : mtr.command.PoolIdx,
  id : u64, // implementation detail
};
