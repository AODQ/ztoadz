const mtr = @import("../src/mtr/package.zig");

pub fn getBackend() mtr.backend.RenderingContextType {
  if (@import("BuildOptions").supportsOpenCL)
    return .clRasterizer;
  if (@import("BuildOptions").supportsVulkan)
    return .vkRasterizer;
  unreachable;
}
