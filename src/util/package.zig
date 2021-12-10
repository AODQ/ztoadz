// pub usingnamespace @import("string.zig");

const std = @import("std");

pub fn readFileAlignedU32(
  allocator : * std.mem.Allocator,
  filename : [] const u8,
) !std.ArrayListAligned(u8, @alignOf(u32)) {
  var fileData = std.ArrayListAligned(u8, @alignOf(u32)).init(allocator);

  const file : std.fs.File = (
    try std.fs.cwd().openFile(filename, .{ .read=true })
  );
  defer file.close();

  // lmao wtf
  var fileReader = file.reader();
  while (true) {
    var byte = fileReader.readByte() catch break;
    (try fileData.addOne()).* = byte;
  }

  return fileData;
}
