const std = @import("std");
const Builder = std.build.Builder;

fn AddShader(
  builder : * std.build.Builder,
  exe : anytype, fileIn : [] const u8, fileOut : [] const u8,
) !void {
  const fullFileIn =
    try std.fs.path.join(
      builder.allocator, &[_][] const u8 { "shaders", fileIn }
    );

  const fullFileOut =
    try std.fs.path.join(
      builder.allocator, &[_][] const u8 { "shaders", fileOut }
    );

  const runCmd =
    builder.addSystemCommand(
      &[_][] const u8 { "glslc", fullFileIn, "-o", fullFileOut }
    );
  exe.step.dependOn(&runCmd.step);
}

pub fn build(builder: * std.build.Builder) !void {

  const supportsOpenCL =  (
    builder.option(
      bool,
      "supportsOpenCL", "if the renderer should support OpenCL"
    )
      orelse false
  );

  const supportsVulkan =  (
    builder.option(
      bool,
      "supportsVulkan", "if the renderer should support Vulkan"
    )
      orelse false
  );

  const options = builder.addOptions();
  options.addOption(bool, "supportsOpenCL", supportsOpenCL);
  options.addOption(bool, "supportsVulkan", supportsVulkan);

  // add test step
  var testStep = builder.step("test", "Run all the tests");
  var tester = builder.addTest("tests/package.zig");
  tester.setMainPkgPath(".");
  tester.addOptions("BuildOptions", options);
  testStep.dependOn(&tester.step);

  if (!supportsOpenCL and !supportsVulkan) {
    std.log.err("must support either OpenCL or Vulkan", .{});
    return;
  }

  const mode = builder.standardReleaseOptions();
  const exe = builder.addExecutable("ztoadz", "src/main.zig");
  exe.setBuildMode(mode);

  exe.linkSystemLibrary("c");

  if (supportsOpenCL)
    exe.linkSystemLibrary("OpenCL");

  exe.addOptions("BuildOptions", options);

  builder.default_step.dependOn(&exe.step);
  exe.install();
}
