const mtr = @import("package.zig");
const std = @import("std");

pub const Idx = u64;

pub const ConstructInfo = struct {
  data : [] u64,
};

pub const Module = struct {
  contextIdx : i32,
  data : [] u64,
};
