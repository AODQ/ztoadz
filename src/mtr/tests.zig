const log = @import("log.zig");
const mtr = @import("package.zig");
const std = @import("std");

test "buffer transfer" {

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

  var mtrCtx = (
    mtr.Context.init(
      &debugAllocator.allocator,
      mtr.context.RenderingContextType.softwareRasterizer,
      mtr.context.RenderingOptimizationLevel.Debug,
    )
  );
  defer mtrCtx.deinit();

  const heap : mtr.heap.Idx = (
    try mtrCtx.constructHeap(.{
      .visibility = mtr.heap.Visibility.hostVisible,
      .length = 1024*1024*50, // 50 MB
    })
  );

  const queue : mtr.queue.Idx = (
    try mtrCtx.constructQueue(.{
      .workType = mtr.queue.WorkType{.transfer = true, .render = true},
    })
  );

  const heapRegion : mtr.heap.RegionIdx = (
    try mtrCtx.constructHeapRegion(.{
      .allocatedHeap = heap,
      .length = @sizeOf(u8)*8 + 8,
    })
  );

  const testBufferA : mtr.buffer.Idx = (
    try mtrCtx.constructBuffer(.{
      .allocatedHeapRegion = heapRegion,
      .offset = 0,
      .length = @sizeOf(u8)*4,
      .usage = mtr.buffer.Usage{ },
      .queueSharing = mtr.queue.SharingUsage.exclusive,
    })
  );

  const testBufferB : mtr.buffer.Idx = (
    try mtrCtx.constructBuffer(.{
      .allocatedHeapRegion = heapRegion,
      .offset = @sizeOf(u8)*4,
      .length = @sizeOf(u8)*4 + 8,
      .usage = mtr.buffer.Usage{ },
      .queueSharing = mtr.queue.SharingUsage.exclusive,
    })
  );

  const someValue = [_] u8 { 128, 242, 182, 100 };

  try mtrCtx.enqueueCommand(
    queue,
    mtr.command.UploadMemory {
      .buffer = testBufferA,
      .offset = 0,
      .memory = someValue[0..],
    },
  );

  try mtrCtx.enqueueCommand(
    queue,
    mtr.command.TransferMemory {
      .bufferSrc = testBufferA,
      .bufferDst = testBufferB,
      .offsetSrc = 0,
      .offsetDst = 8,
      .length = @sizeOf(u8)*4,
    },
  );

  mtrCtx.queueFlush(queue);

  // assert bufferB and bufferA values are accurate
  // this only works in SW context
  const bufferAMemory = (
    mtrCtx
      .renderingContext.softwareRasterizer
      .getMemoryByBufferIdx(mtrCtx, testBufferA)
  );
  const bufferBMemory = (
    mtrCtx
      .renderingContext.softwareRasterizer
      .getMemoryByBufferIdx(mtrCtx, testBufferB)
  );

  std.debug.assert(
        bufferAMemory[0] == 128
    and bufferAMemory[1] == 242
    and bufferAMemory[2] == 182
    and bufferAMemory[3] == 100
  );

  std.debug.assert(
        bufferBMemory[8+0] == 128
    and bufferBMemory[8+1] == 242
    and bufferBMemory[8+2] == 182
    and bufferBMemory[8+3] == 100
  );
}

fn testImageUpload(
  mtrCtx : * mtr.Context,
  queue : mtr.queue.Idx,
  ci : mtr.image.ConstructInfo,
) void {
  const testImage = mtrCtx.constructImage(ci)
    catch unreachable;

  const rgbaClearValue = [_] u32 { 128, 242, 182, 100 };

  mtrCtx.enqueueCommand(
    queue,
    mtr.command.UploadTexelToImageMemory {
      .image = testImage,
      .rgba = rgbaClearValue,
    },
  ) catch unreachable;

  mtrCtx.queueFlush(queue);

  const imageMemory = (
    mtrCtx
      .renderingContext.softwareRasterizer
      .getMemoryByImageIdx(mtrCtx.*, testImage)
  );

  for (imageMemory) |m, it| {
    if (m == rgbaClearValue[it%ci.channels.channelLength()]) {
      continue;
    }

    log.err(
      "have {}, expected {} [test {}]",
      .{m, rgbaClearValue[it%ci.channels.channelLength()], ci}
    );
    unreachable;
  }
}

test "image upload - channels" {

  std.testing.log_level = .debug;

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

  var mtrCtx = (
    mtr.Context.init(
      &debugAllocator.allocator,
      mtr.context.RenderingContextType.softwareRasterizer,
      mtr.context.RenderingOptimizationLevel.Debug,
    )
  );
  defer mtrCtx.deinit();

  const heap : mtr.heap.Idx = (
    try mtrCtx.constructHeap(.{
      .visibility = mtr.heap.Visibility.hostVisible,
      .length = 1024*1024*50, // 50 MB
    })
  );

  const queue : mtr.queue.Idx = (
    try mtrCtx.constructQueue(.{
      .workType = mtr.queue.WorkType{.transfer = true, .render = true},
    })
  );

  const heapRegion : mtr.heap.RegionIdx = (
    try mtrCtx.constructHeapRegion(.{
      .allocatedHeap = heap,
      .length = @sizeOf(u8)*32*32,
    })
  );

  const channels = [_] mtr.image.Channel {
    mtr.image.Channel.R, mtr.image.Channel.RGB, mtr.image.Channel.RGBA
  };

  const widths  = [_] u64 { 1, 2, 4 };
  const heights = [_] u64 { 1, 2, 4 };
  // const depths  = [_] u64 { 1, 2, 4, 8, 16, 32, 128, };

  for (widths) |width| {
  for (heights) |height| {
  for (channels) |channel| {
    testImageUpload(
      &mtrCtx,
      queue,
      .{
        .allocatedHeapRegion = heapRegion,
        .offset = 0,
        .width = width, .height = height, .depth = 1,
        .samplesPerTexel = mtr.image.Sample.s1,
        .arrayLayers = 1,
        .mipmapLevels = 1,
        .byteFormat = mtr.image.ByteFormat.uint8,
        .channels = channel,
        .normalized = true,
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      },
    );
  }}}
}
