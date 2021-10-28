const std = @import("std");
pub const specializeOn = @import("zlm-generic.zig").specializeOn;

pub fn toRadians(deg : anytype) @TypeOf(deg) {
  return std.math.pi * deg / 180.0;
}

pub fn toDegrees(rad : anytype) @TypeOf(rad) {
  return 180.0 * rad / std.math.pi;
}

usingnamespace specializeOn(f32);
