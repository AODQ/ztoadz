pub const context = (
  if (@import("BuildOptions").supportsOpenCL)
    @import("context.zig")
  else
    @import("../nil.zig")
);
