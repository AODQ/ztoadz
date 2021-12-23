const mtr = @import("package.zig");
const std = @import("std");

// pipelines describe how to commit some compute or rasterize workload to the
//   user

pub const ComputeIdx = u64;
pub const LayoutIdx = u64;

pub const Layout = struct {
  descriptorSetLayouts : [] const mtr.descriptor.LayoutIdx,
  pushConstantRange : u32 = 0,

  contextIdx : LayoutIdx = 0,
};

pub const Compute = struct {
  shaderModule : mtr.shader.Idx,
  pName : [*:0] const u8,
  layout : mtr.pipeline.LayoutIdx,

  contextIdx : LayoutIdx = 0,
};

pub const RasterizePrimitive = struct {
  layout : mtr.pipeline.Layout,
  depthTestEnable : bool,
  depthWriteEnable : bool,
};

pub const StageFlags = packed struct {
  begin : bool = false,
  compute : bool = false,
  transfer : bool = false,
  host : bool = false,
  end : bool = false,
};
