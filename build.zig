const std = @import("std");
const Builder = std.build.Builder;

fn addShader(
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
      &[_][] const u8 {
        "glslc", "--target-env=vulkan1.2", fullFileIn, "-o", fullFileOut
      }
    );
  exe.step.dependOn(&runCmd.step);
}

pub fn build(builder: * std.build.Builder) !void {

  // add test step
  var testStep = builder.step("test", "Run all the tests");
  var tester = builder.addTest("tests/package.zig");
  tester.linkSystemLibrary("c");
  tester.linkSystemLibrary("glfw");
  tester.linkSystemLibrary("vulkan");
  tester.setMainPkgPath(".");

  testStep.dependOn(&tester.step);

  try addShader(
    builder, tester,
    "simple-triangle-vert.comp", "simple-triangle-vert.spv"
  );

  try addShader(
    builder, tester,
    "simple-triangle-frag.comp", "simple-triangle-frag.spv"
  );

  try addShader(
    builder, tester,
    "simple-triangle-postproc.comp", "simple-triangle-postproc.spv"
  );

  // const mode = builder.standardReleaseOptions();
  // const exe = builder.addExecutable("ztoadz", "src/main.zig");

  // builder.addSystemCommand(
  //   &[_] [] u8 { &[_] u8 { "cd shaders/" }, "./recompile-shaders.sh" }
  // );
  // exe.setBuildMode(mode);

  // exe.linkSystemLibrary("c");

  // exe.linkSystemLibrary("glfw");
  // exe.linkSystemLibrary("vulkan");

  // builder.default_step.dependOn(&exe.step);
  // exe.install();
}
