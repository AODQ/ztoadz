pub const context = (
  if (@import("BuildOptions").supportsVulkan)
    @import("context.zig")
  else
    @import("nil.zig")
);
