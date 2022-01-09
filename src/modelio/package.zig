//pub const mesh = @import("mesh.zig");
//pub const scene = @import("scene.zig");
//pub const loader = @import("loader.zig");

pub const cgltf = @import("cgltf.zig");

// struct ModelScene {
//   meshes: []
// };

fn parseCgltfError(result : cgltf.Result) !void {
  switch (result) {
    .data_too_short => return error.data_too_short,
    .unknown_format => return error.unknown_format,
    .invalid_json => return error.invalid_json,
    .invalid_gltf => return error.invalid_gltf,
    .invalid_options => return error.invalid_options,
    .file_not_found => return error.file_not_found,
    .io_error => return error.io_error,
    .out_of_memory => return error.out_of_memory,
    .legacy_gltf => return error.legacy_gltf,
    else => {},
  }
}

pub fn loadScene(
  path : [*:0] const u8,
) !* cgltf.Data {
  var dataPtr : * cgltf.Data = undefined;
  var option = cgltf.Option {
    .type = .invalid,
    .json_token_count = 0,
    .memory = .{ .alloc = null, .free = null, .user_data = null, },
    .file = .{ .read = null, .release = null, .user_data = null, },
  };
  try parseCgltfError(cgltf.cgltf_parse_file(&option, path, &dataPtr));
  try parseCgltfError(cgltf.cgltf_load_buffers(&option, dataPtr, path));

  return dataPtr;
}

pub fn freeScene(data : * cgltf.Data) void {
  cgltf.cgltf_free(data);
}
