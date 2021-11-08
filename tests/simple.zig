const mtr = @import("../src/mtr/package.zig");
const std = @import("std");

fn compareValues(failStr : anytype, actual : u8, expected : u8,) void {
  _ = std.testing.expect(actual == expected) catch {};
  if (actual != expected) {
    std.log.err("failure '{s}': {} == {}", .{failStr, actual, expected});
  }
}

test "buffer mapping + transfer" {
  std.testing.log_level = .debug;
  // tests command 'transfer memory'
  var debugAllocator =
    std.heap.GeneralPurposeAllocator(
      .{
        .enable_memory_limit = true,
        .safety = true,
      }
    ){};
  defer {
    const leaked = debugAllocator.deinit();
    if (leaked) std.log.info("{s}", .{"leaked memory"});
  }

  var mtrCtx = (
    mtr.Context.init(
      &debugAllocator.allocator,
      mtr.backend.RenderingContextType.clRasterizer,
      mtr.backend.RenderingOptimizationLevel.Debug,
    )
  );
  defer mtrCtx.deinit();

  const queue : mtr.queue.Idx = (
    try mtrCtx.constructQueue(.{
      .workType = mtr.queue.WorkType{.transfer = true, .render = true},
    })
  );

  const commandPoolScratch : mtr.command.PoolIdx = (
    try mtrCtx.constructCommandPool(.{
      .flags = .{ .transient = true, .resetCommandBuffer = true },
    })
  );

  const commandBufferScratch : mtr.command.BufferIdx = (
    try mtrCtx.constructCommandBuffer(.{
      .commandPool = commandPoolScratch,
    })
  );

  const heapWrite : mtr.heap.Idx = (
    try mtrCtx.constructHeap(.{
      .visibility = mtr.heap.Visibility.hostWritable,
      .length = 1024*1024*50, // 50 MB
    })
  );

  const heapRegionWrite : mtr.heap.RegionIdx = (
    try mtrCtx.constructHeapRegion(.{
      .allocatedHeap = heapWrite,
      .length = @sizeOf(u8)*8 + 8,
    })
  );

  const testBufferWrite : mtr.buffer.Idx = (
    try mtrCtx.constructBuffer(.{
      .allocatedHeapRegion = heapRegionWrite,
      .offset = 0,
      .length = @sizeOf(u8)*4,
      .usage = mtr.buffer.Usage{ },
      .queueSharing = mtr.queue.SharingUsage.exclusive,
    })
  );

  var mappedMemory : ? [*] u8 = null;

  mtrCtx.beginCommandBufferWriting(commandBufferScratch);

    try mtrCtx.enqueueToCommandBuffer(
      mtr.command.MapMemory {
        .buffer = testBufferWrite,
        .mapping = .Write,
        .offset = 0,
        .length = @sizeOf(u8)*4,
        .memory = &mappedMemory
      },
    );

  mtrCtx.endCommandBufferWriting();
  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);

  std.debug.assert(mappedMemory != null);

  mappedMemory.?[0] = 128;
  mappedMemory.?[1] = 242;
  mappedMemory.?[2] = 172;
  mappedMemory.?[3] = 100;

  mtrCtx.beginCommandBufferWriting(commandBufferScratch);

    try mtrCtx.enqueueToCommandBuffer(
      mtr.command.UnmapMemory {
        .buffer = testBufferWrite,
        .memory = mappedMemory.?,
      },
    );

  mtrCtx.endCommandBufferWriting();
  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);

  // -- now construct a readable buffer
  const heapRead : mtr.heap.Idx = (
    try mtrCtx.constructHeap(.{
      .visibility = mtr.heap.Visibility.hostVisible,
      .length = 1024*1024*50, // 50 MB
    })
  );

  const heapRegionRead : mtr.heap.RegionIdx = (
    try mtrCtx.constructHeapRegion(.{
      .allocatedHeap = heapRead,
      .length = @sizeOf(u8)*8 + 8,
    })
  );

  const testBufferRead : mtr.buffer.Idx = (
    try mtrCtx.constructBuffer(.{
      .allocatedHeapRegion = heapRegionRead,
      .offset = 0,
      .length = @sizeOf(u8)*4,
      .usage = mtr.buffer.Usage{ },
      .queueSharing = mtr.queue.SharingUsage.exclusive,
    })
  );

  mtrCtx.beginCommandBufferWriting(commandBufferScratch);

    // now perform a copy
    try mtrCtx.enqueueToCommandBuffer(
      mtr.command.TransferMemory {
        .bufferSrc = testBufferWrite,
        .bufferDst = testBufferRead,
        .offsetSrc = 0,
        .offsetDst = 0,
        .length = @sizeOf(u8)*4,
      },
    );

    mappedMemory = null;
    try mtrCtx.enqueueToCommandBuffer(
      mtr.command.MapMemory {
        .buffer = testBufferRead,
        .mapping = .Read,
        .offset = 0,
        .length = @sizeOf(u8)*4,
        .memory = &mappedMemory
      },
    );

  mtrCtx.endCommandBufferWriting();
  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);
  std.debug.assert(mappedMemory != null);

  try std.testing.expect(mappedMemory.?[0] == 128);
  try std.testing.expect(mappedMemory.?[1] == 242);
  try std.testing.expect(mappedMemory.?[2] == 172);
  try std.testing.expect(mappedMemory.?[3] == 100);

  mtrCtx.beginCommandBufferWriting(commandBufferScratch);
    try mtrCtx.enqueueToCommandBuffer(
      mtr.command.UnmapMemory {
        .buffer = testBufferRead,
        .memory = mappedMemory.?,
      },
    );
  mtrCtx.endCommandBufferWriting();
  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);
}

fn testImageUpload(
  mtrCtx : * mtr.Context,
  queue : mtr.queue.Idx,
  commandBuffer : mtr.command.BufferIdx,
  bufferRead : mtr.buffer.Idx,
  ci : mtr.image.ConstructInfo,
) void {
  const testImage = mtrCtx.constructImage(ci)
    catch unreachable;

  const rgbaClearValue = [_] f32 { 0.5, 0.75, 0.2, 1.0 };


  var mappedMemory : ? [*] u8 = null;
  {
    mtrCtx.beginCommandBufferWriting(commandBuffer);
    defer mtrCtx.endCommandBufferWriting();

    mtrCtx.enqueueToCommandBuffer(
      mtr.command.UploadTexelToImageMemory {
        .image = testImage,
        .rgba = rgbaClearValue,
      },
    ) catch unreachable;

    mtrCtx.enqueueToCommandBuffer(
      mtr.command.TransferImageToBuffer {
        .imageSrc = testImage,
        .bufferDst = bufferRead,
      },
    ) catch unreachable;
  }

  mtrCtx.submitCommandBufferToQueue(queue, commandBuffer);
  mtrCtx.queueFlush(queue);

  {
    mtrCtx.beginCommandBufferWriting(commandBuffer);
    defer mtrCtx.endCommandBufferWriting();

    mtrCtx.enqueueToCommandBuffer(
      mtr.command.MapMemory {
        .buffer = bufferRead,
        .mapping = .Read,
        .offset = 0,
        .length = 12,
        .memory = &mappedMemory
      },
    ) catch unreachable;
  }

  mtrCtx.submitCommandBufferToQueue(queue, commandBuffer);
  mtrCtx.queueFlush(queue);

  std.debug.assert(mappedMemory != null);

  compareValues("0", mappedMemory.?[0], 127);
  compareValues("1", mappedMemory.?[1], @floatToInt(u8, 255.0*0.75));
  compareValues("2", mappedMemory.?[2], @floatToInt(u8, 255.0*0.2));
  compareValues("3", mappedMemory.?[3], 255);
}

test "image upload - channels" {
  // tests channels component of 'command.UploadTexelToImageMemory'
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
    if (leaked) std.log.info("{s}", .{"leaked memory"});
  }

  var mtrCtx = (
    mtr.Context.init(
      &debugAllocator.allocator,
      mtr.backend.RenderingContextType.clRasterizer,
      mtr.backend.RenderingOptimizationLevel.Debug,
    )
  );
  defer mtrCtx.deinit();

  const queue : mtr.queue.Idx = (
    try mtrCtx.constructQueue(.{
      .workType = mtr.queue.WorkType{.transfer = true, .render = true},
    })
  );

  const commandPoolScratch : mtr.command.PoolIdx = (
    try mtrCtx.constructCommandPool(.{
      .flags = .{ .transient = true, .resetCommandBuffer = true },
    })
  );

  const commandBufferScratch : mtr.command.BufferIdx = (
    try mtrCtx.constructCommandBuffer(.{
      .commandPool = commandPoolScratch,
    })
  );

  const heap : mtr.heap.Idx = (
    try mtrCtx.constructHeap(.{
      .visibility = mtr.heap.Visibility.hostVisible,
      .length = 1024*1024*50, // 50 MB
    })
  );

  const heapRegion : mtr.heap.RegionIdx = (
    try mtrCtx.constructHeapRegion(.{
      .allocatedHeap = heap,
      .length = @sizeOf(u8)*32*32,
    })
  );

  const testBufferRead : mtr.buffer.Idx = (
    try mtrCtx.constructBuffer(.{
      .allocatedHeapRegion = heapRegion,
      .offset = 0,
      .length = 12,
      .usage = mtr.buffer.Usage{ },
      .queueSharing = mtr.queue.SharingUsage.exclusive,
    })
  );

  const heapImage : mtr.heap.Idx = (
    try mtrCtx.constructHeap(.{
      .visibility = mtr.heap.Visibility.deviceOnly,
      .length = 1024*1024*50, // 50 MB
    })
  );

  const heapRegionImage : mtr.heap.RegionIdx = (
    try mtrCtx.constructHeapRegion(.{
      .allocatedHeap = heapImage,
      .length = @sizeOf(u8)*32*32,
    })
  );

  // const widths  = [_] u64 { 1, 2, 4 };
  // const heights = [_] u64 { 1, 2, 4 };
  // const depths  = [_] u64 { 1, 2, 4, 8, 16, 32, 128, };
  const widths  = [_] u64 { 4 };
  const heights = [_] u64 { 4 };
  const channels = [_] mtr.image.Channel {
    // mtr.image.Channel.R, mtr.image.Channel.RGB, mtr.image.Channel.RGBA
    mtr.image.Channel.RGBA
  };


  for (widths) |width| {
  for (heights) |height| {
  for (channels) |channel| {
    testImageUpload(
      &mtrCtx,
      queue,
      commandBufferScratch,
      testBufferRead,
      .{
        .allocatedHeapRegion = heapRegionImage,
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

test "pipeline - triangle" {
  // rasterizes a simple triangle
  // tests the 'rasterize' command
}
