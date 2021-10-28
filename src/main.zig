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

fn createMtrContext(allocator : * std.mem.Allocator) !mtr.Context {
  var mtrCtx = (
    mtr.Context.init(
      allocator,
      mtr.RenderingContextType.softwareRasterizer,
      mtr.RenderingOptimizationLevel.Debug,
    )
  );

  const heap : mtr.HeapIdx = (
    try mtrCtx.constructHeap(.{
      .visibility = mtr.HeapVisibility.hostVisible,
      .length = 1024*1024*50, // 50 MB
    })
  );

  const queue : mtr.QueueIdx = (
    try mtrCtx.constructQueue(.{
      .workType = mtr.QueueWorkType{.transfer = true, .render = true},
    })
  );

  const heapRegion : mtr.HeapRegionIdx = (
    try mtrCtx.constructHeapRegion(.{
      .allocatedHeap = heap,
      .length = @sizeOf(u8)*8 + 8,
    })
  );

  const testBufferA : mtr.HeapIdx = (
    try mtrCtx.constructBuffer(.{
      .allocatedHeapRegion = heapRegion,
      .offset = 0,
      .length = @sizeOf(u8)*4,
      .usage = mtr.BufferUsage{ },
      .queueSharing = mtr.QueueBufferSharingUsage.exclusive,
    })
  );

  const testBufferB : mtr.HeapIdx = (
    try mtrCtx.constructBuffer(.{
      .allocatedHeapRegion = heapRegion,
      .offset = @sizeOf(u8)*4,
      .length = @sizeOf(u8)*4 + 8,
      .usage = mtr.BufferUsage{ },
      .queueSharing = mtr.QueueBufferSharingUsage.exclusive,
    })
  );

  const someValue = [_] u8 { 128, 242, 182, 100 };

  try mtrCtx.enqueueCommand(
    queue,
    mtr.CommandUploadMemory {
      .buffer = testBufferA,
      .offset = 0,
      .memory = someValue[0..],
    },
  );

  try mtrCtx.enqueueCommand(
    queue,
    mtr.CommandTransferMemory {
      .bufferSrc = testBufferA,
      .bufferDst = testBufferB,
      .offsetSrc = 0,
      .offsetDst = 8,
      .length = @sizeOf(u64),
    },
  );

  // TODO assert bufferB and bufferA value both 12345678

  return mtrCtx;
}

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

  var mtrCtx = try createMtrContext(&debugAllocator.allocator);
  defer mtrCtx.deinit();

  log.info("{s}", .{"Exitting ztoadz safely"});
}
