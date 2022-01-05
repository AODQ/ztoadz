const mtr = @import("package.zig");
const std = @import("std");

pub const Idx = u64;

pub const ConstructInfo = struct {
  data : [] const u8,
  label : [:0] const u8,
};

pub const Module = struct {
  data  : [] const u8,
  label : [:0] const u8,

  contextIdx : u64,
};
