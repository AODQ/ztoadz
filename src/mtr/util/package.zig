pub const json = @import("json.zig");
pub const snapshot = @import("snapshot.zig");

const mtr = @import("../package.zig");

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

pub const MappedMemory = struct {
  ptr : [*] u8,
  mapping : mtr.heap.RegionIdx,
};
