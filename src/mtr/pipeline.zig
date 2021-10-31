const mtr = @import("package.zig");
const std = @import("std");

// pipelines describe how to commit some compute or rasterize workload to the
//   user

pub const Idx = u64;

pub const Layout = struct {
  descriptors : std.AutoHashMap(u64, mtr.descriptor.Type),
  pushConstants : std.ArrayList(mtr.descriptor.PushConstantRange),

  pub fn init(a : * std.mem.Allocator) void {
    return .{
      .descriptors = std.AutoHashMap(u64, mtr.descriptor.Type).init(a),
      .pushConstants = std.ArrayList(mtr.descriptor.PushConstantRange).init(a),
    };
  }

  pub fn deinit(self : @This()) {
    self.descriptors.deinit();
    self.pushConstants.deinit();
  }
};

pub const ConstructInfo = struct {
  layout : mtr.pipeline.Layout,

  depthTestEnable : bool,
  depthWriteEnable : bool,

  // TODO winding order, idk
};


pub const RasterizePrimitive {
  layout : Layout,
  depthTestEnable : bool,
  depthWriteEnable : bool,
};
