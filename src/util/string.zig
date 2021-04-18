const std = @import("std");

/// Arena-based string such that temporary strings that need to be passed to
///   C-ABI functions can be easily generated
pub const StringArena = struct {

  str : std.ArrayList(u8),

  pub var arenaAllocator : std.heap.ArenaAllocator = undefined;

  pub fn init(
    str : [:0] const u8,
  ) StringArena {
    var self : StringArena = undefined;
    self.str = std.ArrayList(u8).init(std.heap.c_allocator);

    self.str.resize(str.len)
      catch |s| {
        std.debug.panic("alloc error: {}", .{s});
      };

    for (str) |char, it| { self.str.items[it] = char; }

    return self;
  }

  pub fn concat(self : * @This(), str : [:0] const u8) StringArena
  {
    var originalLen : usize = self.str.items.len;

    // if original string has a '\0', have to overwrite it
    if (self.str.items[self.str.items.len-1] == 0) {
      originalLen -= 1;
    }

    self.str.resize(originalLen + str.len)
      catch |s| {
        std.debug.panic("alloc error: {}", .{s});
      };

    for (str) |char, it| {
      self.str.items[originalLen + it] = char;
    }
    return self.*;
  }

  pub fn cStr(self : * @This()) [:0] const u8 {
    if (self.str.items[self.str.items.len - 1] != 0) {
      var endChar =
        self.str.addOne()
        catch |s| {
          std.debug.panic("alloc error: {}", .{s});
        };
      endChar.* = 0;
    }
    return self.str.items[0..self.str.items.len-1 : 0];
  }

  pub fn deinit(self : @This()) void
  {
    self.str.deinit();
  }

  pub fn freeArena() void
  {
    arenaAllocator.deinit();
  }
};
