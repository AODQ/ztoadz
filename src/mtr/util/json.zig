const mtr = @import("../package.zig");
const std = @import("std");

pub const JsonEnumMixin = struct {
  pub fn jsonStringify(
    self : anytype,
    opt : std.json.StringifyOptions,
    outStream : anytype
  ) @TypeOf(outStream).Error!void {
    _ = opt;
    try outStream.writeByte('"');
    try std.fmt.formatType(self, "'{}'", .{}, outStream, 3);
    try outStream.writeByte('"');
  }
};

// stringifys the struct member of a typed union, such that the output is
//   {"asdf": {..}}
// while also skipping any types
pub fn stringifyTypedUnionMember(
  self : anytype,
  _ : [] const u8, //label
  skippedType : type,
  options : std.json.StringifyOptions,
  outStream : anytype,
) @TypeOf(outStream).Error ! void {
  try outStream.writeAll("{");

  const structInfo = @typeInfo(@TypeOf(self)).Struct;

  comptime var skipWriteComma = true;

  inline for (structInfo.fields) |Field| {

    if (Field.field_type == skippedType) continue;

    if (skipWriteComma) {
      skipWriteComma = false;
    } else {
      try outStream.writeByte(',');
    }

    try mtr.util.json.stringifyVariable(
      Field.name, @field(self, Field.name), options, outStream
    );
  }

  try outStream.writeByte('}');
}

pub fn stringifyHashMap(
  label : [] const u8,
  hashmap : anytype,
  options : std.json.StringifyOptions,
  outStream : anytype,
) @TypeOf(outStream).Error ! void {
  try std.json.stringify(label, options, outStream);
  try outStream.writeByte(':');
  try outStream.writeByte('[');

  var hashmapIterator = hashmap.iterator();
  var firstIteration : usize = 0;
  while (hashmapIterator.next()) |iter| {
    // skip utility parameters since they aren't recordable
    if (iter.key_ptr.* == mtr.Context.utilContextIdx) {
      continue;
    }
    if (firstIteration != 0)
      try outStream.writeByte(',');
    firstIteration += 1;
    try std.json.stringify(iter.value_ptr.*, options, outStream);
  }
  try outStream.writeByte(']');
}

pub fn stringifyVariable(
  label : [] const u8,
  variable : anytype,
  options : std.json.StringifyOptions,
  outStream : anytype,
) @TypeOf(outStream).Error ! void {
  try std.json.stringify(label, options, outStream);
  try outStream.writeByte(':');
  try std.json.stringify(variable, options, outStream);
}
