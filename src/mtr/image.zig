const mtr = @import("package.zig");
const std = @import("std");

pub const Idx = u64;

pub const ConstructInfo = struct {
  offset : u64, // TODO change for buffer/image 'offset' -> 'offsetIntoHeap'
  width : u64, height : u64, depth : u64,
  samplesPerTexel : mtr.image.Sample,
  arrayLayers : u64,
  mipmapLevels : u64,
  byteFormat : mtr.image.ByteFormat,
  channels : mtr.image.Channel,
  normalized : bool = true,
  queueSharing : mtr.queue.SharingUsage,
};

pub const Sample = enum {
  s1,
  // s2, s4, s8, s16, s32, s64

  pub fn sampleLength(self : @This()) u64 {
    return switch(self) {
      .s1 => 1,
      // .s2 => 2, .s4 => 4, .s8 => 8, .s16 => 16, .s32 => 32, .s64 => 64
    };
  }

  pub const jsonStringify = mtr.util.json.JsonEnumMixin.jsonStringify;
};

pub const Channel = enum {
  R, RGB, RGBA,

  pub fn channelLength(self : @This()) u64 {
    return switch(self) {
      .R => 1, .RGB => 3, .RGBA => 4,
    };
  }

  pub const jsonStringify = mtr.util.json.JsonEnumMixin.jsonStringify;
};

pub const ByteFormat = enum {
  uint8,
  // uint16, uint32, float32

  pub const jsonStringify = mtr.util.json.JsonEnumMixin.jsonStringify;

  pub fn byteLength(self : @This()) u64 {
    return switch(self) {
      .uint8 => 1,
      // uint16 => 2, uint32 => 4, float32 => 4,
    };
  }
};

pub const Primitive = struct {
  allocatedHeapRegion : mtr.heap.RegionIdx,
  offset : u64, // TODO change for buffer/image 'offset' -> 'offsetIntoHeap'
  width : u64, height : u64, depth : u64,
  samplesPerTexel : mtr.image.Sample,
  arrayLayers : u64,
  mipmapLevels : u64,
  byteFormat : mtr.image.ByteFormat,
  channels : mtr.image.Channel,
  normalized : bool,
  queueSharing : mtr.queue.SharingUsage,
  contextIdx : mtr.image.Idx,
  // TODO maybe usage flags? (transfer src/dst)

  pub fn getImageByteLength(self : @This()) u64 {
    return (
        self.width * self.height * self.depth
      * self.arrayLayers * self.mipmapLevels
      * self.samplesPerTexel.sampleLength()
      * self.byteFormat.byteLength()
      * self.channels.channelLength()
    );
  }

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

    try mtr.Context.dumpImageToWriter(self.contextIdx, outStream);

    try outStream.writeByte('}');
  }
};
