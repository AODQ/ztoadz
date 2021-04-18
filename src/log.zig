
const std    = @import("std");

// --- how to interpret logging levels
//  Crit:
//    Library/Internal error, usually a logical error
//  Err:
//    User error, usually implies that the intended action has failed. Such as
//      an invalid configuration file, or an invalid camera location, etc.
//  Warn:
//    User error, usually recoverable but might have unintended side-effects
//  Info:
//    Normal logging
//  Debug:
//    Extensive logging for developers

pub fn crit(
  comptime format : [] const u8,
  args : anytype,
) void {
  std.log.info("[\x1B[31mcrit\x1B[0m] " ++ format, args);
}

pub fn err(
  comptime format : [] const u8,
  args : anytype,
) void {
  std.log.info("[\x1B[33merr \x1B[0m] " ++ format, args);
}

pub fn warn(
  comptime format : [] const u8,
  args : anytype,
) void {
  std.log.info("[\x1B[36mwarn\x1B[0m] " ++ format, args);
}

pub fn info(
  comptime format : [] const u8,
  args : anytype,
) void {
  std.log.info("[info] " ++ format, args);
}

pub fn debug(
  comptime format : [] const u8,
  args : anytype,
) void {
  std.log.info("[\x1B[32mdebug\x1B[0m] " ++ format, args);
}
