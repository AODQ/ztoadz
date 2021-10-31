const mtr = @import("package.zig");
const std = @import("std");

pub const RegionIdx = u64;
pub const Idx = u64;

pub const ConstructInfo = struct {
  visibility : mtr.heap.Visibility,
  length : u64,
};

pub const RegionConstructInfo = struct {
  allocatedHeap : mtr.heap.Idx,
  length : u64,
};

pub const BackingMemoryTypeTag = enum {
  cpu,
  gpu
};

pub const BackingMemory = union(mtr.heap.BackingMemoryTypeTag) {
  cpu : [] u8,
  gpu : void, // unimplemented
};

// Describes the visibility of the heap between host and device
pub const Visibility = enum {
  deviceOnly,
  hostVisible,
  hostWritable,
};

// Every primitive must be heap-backed, in this every piece of memory
//   in the library is accounted for & can be manually managed by the user.
//   Multiple primitives can be allocated inside a single allocation
pub const Primitive = struct {
  underlyingMemory : mtr.heap.BackingMemory,
  length : u64,
  visibility : mtr.heap.Visibility,
  contextIdx : mtr.heap.Idx,
};

// Any piece of memory must be allocated under a heap-region. Having an
//   intermediary allocator allows for multiple primitives to be under a single
//   region. The heap region allocation can be overriden by a custom allocator,
//   while memory under the region must be managed manually. In other
//   words, you request memory from a Heap as a HeapRegion, similar to a
//   'malloc', and then fill that region out however you like. Everything above
//   is, by default, automated.
//
// It might make sense to then group allocations like buffers and images
//   together based on their lifetime/usage.
pub const Region = struct {
  allocatedHeap : mtr.heap.Idx,
  offset : u64, length : u64,
  contextIdx : mtr.heap.RegionIdx,
};
