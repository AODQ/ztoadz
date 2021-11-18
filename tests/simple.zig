const mtr = @import("../src/mtr/package.zig");
const std = @import("std");
const util = @import("util.zig");

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
      util.getBackend(),
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
      .queue = queue,
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
    })
  );

  var testBufferWrite : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(heapWrite);
    defer _ = heapRegionAllocator.finish();

    testBufferWrite = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(u8)*4,
        .usage = mtr.buffer.Usage{ .transferSrc = true },
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      })
    );
  }

  {
    var mappedMemory = try mtrCtx.mapMemoryBuffer(.{
      .mapping = mtr.util.MappingType.Write,
      .buffer = testBufferWrite,
      .offset = 0, .length = @sizeOf(u8)*4,
    });
    defer mtrCtx.unmapMemory(mappedMemory);

    mappedMemory.ptr[0] = 128;
    mappedMemory.ptr[1] = 242;
    mappedMemory.ptr[2] = 172;
    mappedMemory.ptr[3] = 100;
  }

  // -- now construct a readable buffer
  const heapRead : mtr.heap.Idx = (
    try mtrCtx.constructHeap(.{
      .visibility = mtr.heap.Visibility.hostVisible,
    })
  );

  var testBufferRead : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(heapRead);
    defer _ = heapRegionAllocator.finish();

    testBufferRead = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = @sizeOf(u8)*4,
        .usage = mtr.buffer.Usage{ .transferDst=true },
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      })
    );
  }

  {
    var commandBufferRecorder = (
      mtrCtx.createCommandBufferRecorder(commandBufferScratch)
    );
    defer commandBufferRecorder.finish();

    commandBufferRecorder.append(
      mtr.command.TransferMemory {
        .bufferSrc = testBufferWrite,
        .bufferDst = testBufferRead,
        .offsetSrc = 0,
        .offsetDst = 0,
        .length = @sizeOf(u8)*4,
      },
    );
  }

  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);

  {
    var mappedMemory = try mtrCtx.mapMemoryBuffer(.{
      .mapping = mtr.util.MappingType.Read,
      .buffer = testBufferRead,
      .offset = 0, .length = @sizeOf(u8)*4,
    });
    defer mtrCtx.unmapMemory(mappedMemory);

    try std.testing.expect(mappedMemory.ptr[0] == 128);
    try std.testing.expect(mappedMemory.ptr[1] == 242);
    try std.testing.expect(mappedMemory.ptr[2] == 172);
    try std.testing.expect(mappedMemory.ptr[3] == 100);
  }
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
      util.getBackend(),
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
      .queue = queue,
    })
  );

  const commandBufferScratch : mtr.command.BufferIdx = (
    try mtrCtx.constructCommandBuffer(.{
      .commandPool = commandPoolScratch,
    })
  );
  _ = commandBufferScratch;

  const heapRead : mtr.heap.Idx = (
    try mtrCtx.constructHeap(.{
      .visibility = mtr.heap.Visibility.hostVisible,
    })
  );

  var testBufferRead : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(heapRead);
    defer _ = heapRegionAllocator.finish();

    testBufferRead = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = 1, // RGBA 4x4
        .usage = mtr.buffer.Usage{ .transferDst=true },
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      })
    );
  }
  _ = testBufferRead;

  var heapDevice : mtr.heap.Idx = (
    try mtrCtx.constructHeap(.{
      // .visibility = mtr.heap.Visibility.deviceOnly,
      .visibility = mtr.heap.Visibility.hostVisible,
    })
  );

  var testImage : mtr.image.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(heapDevice);
    defer _ = heapRegionAllocator.finish();

    testImage = try (
      heapRegionAllocator.createImage(.{
        .offset = 0,
        .width = 1, .height = 1, .depth = 1,
        .samplesPerTexel = mtr.image.Sample.s1,
        .arrayLayers = 1,
        .mipmapLevels = 1,
        .byteFormat = mtr.image.ByteFormat.uint8,
        .channels = mtr.image.Channel.RGBA,
        .normalized = true,
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      })
    );
  }

  {
    var commandBufferRecorder = (
      mtrCtx.createCommandBufferRecorder(commandBufferScratch)
    );
    defer commandBufferRecorder.finish();

    const rgbaClearValue = [_] f32 { 0.5, 0.75, 0.2, 1.0 };
    commandBufferRecorder.append(
      mtr.command.UploadTexelToImageMemory {
        .image = testImage,
        .rgba = rgbaClearValue,
      },
    );

    commandBufferRecorder.append(
      mtr.command.TransferImageToBuffer {
        .imageSrc = testImage,
        .bufferDst = testBufferRead,
        .width = 1, .height = 1, //TODO FIXME depth?
      },
    );
  }

  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);

  {
    var mappedMemory = try mtrCtx.mapMemoryBuffer(.{
      .mapping = mtr.util.MappingType.Read,
      .buffer = testBufferRead,
      .offset = 0, .length = 1, // RGBA 4x4
    });
    defer mtrCtx.unmapMemory(mappedMemory);

    std.log.info(
      "mapped memory {} {}",
      .{mappedMemory.ptr[0], mappedMemory.ptr[1]});
  }
}

test "pipeline - triangle" {
  // rasterizes a simple triangle
  // tests the 'rasterize' command
}
