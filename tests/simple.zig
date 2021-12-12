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
      debugAllocator.allocator(),
      mtr.RenderingOptimizationLevel.debug,
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

  var testBufferRead : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.hostVisible);
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

  try mtr.util.stageMemoryToBuffer(
    &mtrCtx, .{
      .queue = queue,
      .commandBuffer = commandBufferScratch,
      .bufferDst = testBufferRead,
      .memoryToUpload = &[_] u8 { 128, 242, 172, 100 },
    }
  );

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

// TODO broken example :/
test "image upload - channels" {
  // // tests channels component of 'command.UploadTexelToImageMemory'
  // std.testing.log_level = .debug;

  // var debugAllocator =
  //   std.heap.GeneralPurposeAllocator(
  //     .{
  //       .enable_memory_limit = true,
  //       .safety = true,
  //     }
  //   ){};
  // defer {
  //   const leaked = debugAllocator.deinit();
  //   if (leaked) std.log.info("{s}", .{"leaked memory"});
  // }

  // var mtrCtx = (
  //   mtr.Context.init(
  //     &debugAllocator.allocator,
  //     mtr.RenderingOptimizationLevel.debug,
  //   )
  // );
  // defer mtrCtx.deinit();

  // const queue : mtr.queue.Idx = (
  //   try mtrCtx.constructQueue(.{
  //     .workType = mtr.queue.WorkType{.transfer = true, .render = true},
  //   })
  // );

  // const commandPoolScratch : mtr.command.PoolIdx = (
  //   try mtrCtx.constructCommandPool(.{
  //     .flags = .{ .transient = true, .resetCommandBuffer = true },
  //     .queue = queue,
  //   })
  // );

  // const commandBufferScratch : mtr.command.BufferIdx = (
  //   try mtrCtx.constructCommandBuffer(.{
  //     .commandPool = commandPoolScratch,
  //   })
  // );

  // var testBufferRead : mtr.buffer.Idx = 0;
  // {
  //   var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.hostVisible);
  //   defer _ = heapRegionAllocator.finish();

  //   testBufferRead = try (
  //     heapRegionAllocator.createBuffer(.{
  //       .offset = 0,
  //       .length = 4*4*4*1, // WxH rgba u8
  //       .usage = mtr.buffer.Usage{ .transferDst=true },
  //       .queueSharing = mtr.queue.SharingUsage.exclusive,
  //     })
  //   );
  // }

  // var testImage : mtr.image.Idx = 0;
  // {
  //   var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
  //   defer _ = heapRegionAllocator.finish();

  //   testImage = try (
  //     heapRegionAllocator.createImage(.{
  //       .offset = 0,
  //       .width = 4, .height = 4, .depth = 1,
  //       .samplesPerTexel = mtr.image.Sample.s1,
  //       .arrayLayers = 1,
  //       .mipmapLevels = 1,
  //       .byteFormat = mtr.image.ByteFormat.uint8,
  //       .channels = mtr.image.Channel.RGBA,
  //       .normalized = true,
  //       .queueSharing = mtr.queue.SharingUsage.exclusive,
  //     })
  //   );
  // }

  // var testBufferReadTape = mtr.memory.BufferTape { .buffer = testBufferRead, };
  // var testImageTape = mtr.memory.ImageTape { .image = testImage, };

  // {
  //   var commandBufferRecorder = (
  //     mtrCtx.createCommandBufferRecorder(commandBufferScratch)
  //   );
  //   defer commandBufferRecorder.finish();

  //   commandBufferRecorder.append(
  //     mtr.command.PipelineBarrier {
  //       .srcStage = .{ .begin = true },
  //       .dstStage = .{ .transfer = true },
  //       .imageTapes = (
  //         &[_] mtr.command.PipelineBarrier.ImageTapeAction {
  //           mtr.command.PipelineBarrier.ImageTapeAction {
  //             .tape = &testImageTape,
  //             .layout = .transferDst,
  //             .accessFlags = .{ .transferWrite = true },
  //           },
  //         }
  //       ),
  //     },
  //   );

  //   const rgbaClearValue = [_] f32 { 5.5, 5.75, 0.2, 1.0 };
  //   commandBufferRecorder.append(
  //     mtr.command.UploadTexelToImageMemory {
  //       .imageTape = testImageTape,
  //       .rgba = rgbaClearValue,
  //     },
  //   );

  //   commandBufferRecorder.append(
  //     mtr.command.PipelineBarrier {
  //       .srcStage = .{ .transfer = true },
  //       .dstStage = .{ .transfer = true },
  //       .bufferTapes = (
  //         &[_] mtr.command.PipelineBarrier.BufferTapeAction {
  //           mtr.command.PipelineBarrier.BufferTapeAction {
  //             .tape = &testBufferReadTape,
  //             .accessFlags = .{ .transferWrite = true },
  //           },
  //         }
  //       ),
  //       .imageTapes = (
  //         &[_] mtr.command.PipelineBarrier.ImageTapeAction {
  //           mtr.command.PipelineBarrier.ImageTapeAction {
  //             .tape = &testImageTape,
  //             .layout = .transferSrc,
  //             .accessFlags = .{ .transferRead = true },
  //           },
  //         }
  //       ),
  //     },
  //   );

  //   commandBufferRecorder.append(
  //     mtr.command.TransferImageToBuffer {
  //       .imageSrc = testImage,
  //       .bufferDst = testBufferRead,
  //       .width = 4, .height = 4,
  //     },
  //   );

  //   commandBufferRecorder.append(
  //     mtr.command.PipelineBarrier {
  //       .srcStage = .{ .transfer = true },
  //       .dstStage = .{ .host = true },
  //       .bufferTapes = (
  //         &[_] mtr.command.PipelineBarrier.BufferTapeAction {
  //           mtr.command.PipelineBarrier.BufferTapeAction {
  //             .tape = &testBufferReadTape,
  //             .accessFlags = .{ .hostRead = true },
  //           },
  //         }
  //       ),
  //     },
  //   );
  // }

  // mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  // mtrCtx.queueFlush(queue);

  // {
  //   var mappedMemory = try mtrCtx.mapMemoryBuffer(.{
  //     .mapping = mtr.util.MappingType.Read,
  //     .buffer = testBufferRead,
  //     .offset = 0, .length = 4*4*4*1, // RGBA u8
  //   });
  //   defer mtrCtx.unmapMemory(mappedMemory);

  //   var mappedMemoryU8 = @ptrCast([*] u8, @alignCast(1, mappedMemory.ptr));

  //   var it : usize = 0;
  //   while (it < 4*4*4*1) : (it += 1) {
  //     std.log.info(
  //       "mapped memory {}: {}", .{it, mappedMemoryU8[it]},
  //     );
  //   }
  // }
}
