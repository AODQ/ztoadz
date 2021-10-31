const mtr = @import("package.zig");
const std = @import("std");

pub const MappedMemoryRange = struct {
  buffer : mtr.buffer.Idx,
  offset : u64,
  length : u64,
};

pub const MappedMemory = struct {
  context : mtr.Context,
  range : mtr.util.MappedMemoryRange,
  data : [*] u8,

  pub fn init(
    context : mtr.Context,
    range : mtr.util.MappedMemoryRange,
  ) @This() {
    return .{
      .context = context,
      .range = range,
      .data = (
        context.renderingContext.mapMemory(context, range)
      ),
    };
  }

  pub fn deinit(self : @This()) void {
    self.context.renderingContext.unmapMemory(self.context, self.data);
  }
};
