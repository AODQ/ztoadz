const glfw    = @import("third-party/glfw.zig");
const img     = @import("io/img.zig");
const log     = @import("log.zig");
const modelio = @import("modelio/package.zig");
const util    = @import("util/package.zig");
const vk      = @import("third-party/vulkan.zig");
const ztd     = @import("util/ztoadz.zig");
const zvk     = @import("zvk/package.zig");
const zvvk    = @import("util/zvvk.zig");
const mtr     = @import("mtr/package.zig");

const std    = @import("std");
const assert = std.debug.assert;

pub fn main() !void {
  log.info("{s}", .{"initializing zTOADz"});

  // -- setup allocators

  var debugAllocator =
    std.heap.GeneralPurposeAllocator(
      .{
        .enable_memory_limit = true,
        .safety = true,
      }
    ){};
  defer {
    const leaked = debugAllocator.deinit();
    if (leaked) log.info("{s}", .{"leaked memory"});
  }

  util.StringArena.arenaAllocator =
    std.heap.ArenaAllocator.init(&debugAllocator.allocator)
  ;

  // -- initialize glfw / vulkan context
  // if (glfw.glfwInit() == 0) { return error.GlfwInitFailed; }
  // defer glfw.glfwTerminate();

  log.info("{s}", .{"Exitting ztoadz safely"});
}
