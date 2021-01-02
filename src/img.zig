const std = @import("std");

pub const ImageType = enum {
  rgb, rgba
};

pub fn WriteImage(
  imageData : [] const f32,
  imageType : ImageType,
  filename : [] const u8,
  width : u32, height : u32,
) !void {
  const file = try std.fs.cwd().createFile(filename, .{ .read = true },);
  defer file.close();

  const allocator = std.heap.page_allocator;

  const elementLen : usize =
    switch (imageType) { ImageType.rgb => 3, ImageType.rgba => 4 }
  ;
  const imageLen = imageData.len / elementLen;

  const fileMemory = try allocator.alloc(u8, imageLen*3*@sizeOf(u8));
  defer allocator.free(fileMemory);

  try file.writer().print("{}{} {}{}", .{"P6\n", width, height, "\n255\n"});

  for (fileMemory) |_, it| {
    var elemOffset : usize = 0;
    if (imageType == ImageType.rgba) {
      elemOffset = it / 4;
    }

    fileMemory[it] =
      @floatToInt(
        u8, std.math.clamp(imageData[it + elemOffset] * 255.0, 0.0, 255.0)
      );
  }

  try file.writeAll(fileMemory);
}
