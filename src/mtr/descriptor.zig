const mtr = @import("package.zig");
const std = @import("std");

pub const Idx = u64;

pub const Type = enum {
  uniformBuffer,
  storageBuffer,
  sampler,
  image,
};

pub const PushConstantRange = struct {
  offset : u32,
  length : u32, // must be a multiple of 4
};
