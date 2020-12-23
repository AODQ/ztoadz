const std = @import("std");
const path = std.fs.path;
const Builder = std.build.Builder;

pub fn build(builder: * Builder) !void {
  const mode = builder.standardReleaseOptions();
  const exe = builder.addExecutable("ztoadz", "src/main.zig");
  exe.setBuildMode(mode);
  exe.linkSystemLibrary("glfw");
  exe.linkSystemLibrary("vulkan");
  exe.linkSystemLibrary("c");

  builder.default_step.dependOn(&exe.step);
  exe.install();

  const run_step = builder.step("run", "Run app");
  const run_cmd = exe.run();
  run_step.dependOn(&run_cmd.step);
}
