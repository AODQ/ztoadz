const mtr = @import("package.zig");
const std = @import("std");

pub const Idx = u64;

pub const ConstructInfo = struct {
  allocatedHeapRegion : mtr.heap.RegionIdx,
  offset : u64, length : u64,
  usage : mtr.buffer.Usage,
  queueSharing : mtr.queue.SharingUsage,
};

// describes in what contexts the buffer may be accessed for both reading &
//   writing
// transfer allows buffers to copy regions of their memory to others
// buffer describes in what context the buffer will be used
//
pub const Usage = packed struct {
  transferSrc : bool = false,
  transferDst : bool = false,
  transferSrcDst : bool = false,

  bufferUniform : bool = false,
  bufferStorage : bool = false,
  bufferAccelerationStructure : bool = false,
};

// Any piece of information that exists as an array of elements must be
//   referenced to as a buffer. The buffer describes both where this data
//   lives, as well as describes it as a form of metadata. An array of elements
//   should be contained in an array as large as possible, where allocation
//   and deallocation of the entire array is a valid operation.
pub const Primitive = struct {
  allocatedHeapRegion : mtr.heap.RegionIdx,
  offset : u64,
  length : u64,
  usage : mtr.buffer.Usage,
  queueSharing : mtr.queue.SharingUsage,
  contextIdx : mtr.buffer.Idx,

  pub fn jsonStringify(
    self : @This(),
    options : std.json.StringifyOptions,
    outStream : anytype
  ) @TypeOf(outStream).Error ! void {
    try outStream.writeByte('{');

    const structInfo = @typeInfo(@This()).Struct;

    inline for (structInfo.fields) |Field| {
      try mtr.util.json.stringifyVariable(
        Field.name, @field(self, Field.name), options, outStream
      );
      try outStream.writeByte(',');
    }

    try mtr.Context.dumpBufferToWriter(self.contextIdx, outStream);

    try outStream.writeByte('}');
  }
};

// a view into a buffer
pub const View = struct {
  buffer : mtr.buffer.Idx,
  offset : u64,
  length : u64,
};
