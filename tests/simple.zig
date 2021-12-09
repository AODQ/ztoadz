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

  var testBufferWrite : mtr.buffer.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.hostWritable);
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
        .length = 4*4*4*4, // bytes, rgba, width, height
        .usage = mtr.buffer.Usage{ .transferDst=true },
        .queueSharing = mtr.queue.SharingUsage.exclusive,
      })
    );
  }

  var testImage : mtr.image.Idx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.deviceOnly);
    defer _ = heapRegionAllocator.finish();

    testImage = try (
      heapRegionAllocator.createImage(.{
        .offset = 0,
        .width = 4, .height = 4, .depth = 1,
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

  var testBufferReadTape = mtr.command.BufferTape { .buffer = testBufferRead, };
  var testImageTape = mtr.command.ImageTape { .image = testImage, };

  {
    var commandBufferRecorder = (
      mtrCtx.createCommandBufferRecorder(commandBufferScratch)
    );
    defer commandBufferRecorder.finish();

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .begin = true },
        .dstStage = .{ .transfer = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            mtr.command.PipelineBarrier.ImageTapeAction {
              .tape = &testImageTape,
              .layout = .transferDst,
              .accessFlags = .{ .transferWrite = true },
            },
          }
        ),
      },
    );

    const rgbaClearValue = [_] f32 { 0.5, 0.75, 0.2, 1.0 };
    commandBufferRecorder.append(
      mtr.command.UploadTexelToImageMemory {
        .imageTape = testImageTape,
        .rgba = rgbaClearValue,
      },
    );

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .transfer = true },
        .dstStage = .{ .transfer = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            mtr.command.PipelineBarrier.ImageTapeAction {
              .tape = &testImageTape,
              .layout = .transferDst,
              .accessFlags = .{ .transferWrite = true },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .transfer = true },
        .dstStage = .{ .transfer = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            mtr.command.PipelineBarrier.BufferTapeAction {
              .tape = &testBufferReadTape,
              .accessFlags = .{ .transferWrite = true },
            },
          }
        ),
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            mtr.command.PipelineBarrier.ImageTapeAction {
              .tape = &testImageTape,
              .layout = .transferSrc,
              .accessFlags = .{ .transferRead = true },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.TransferImageToBuffer {
        .imageSrc = testImage,
        .bufferDst = testBufferRead,
        .width = 4, .height = 4,
      },
    );

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .transfer = true },
        .dstStage = .{ .transfer = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            mtr.command.PipelineBarrier.BufferTapeAction {
              .tape = &testBufferReadTape,
              .accessFlags = .{ .transferWrite = true },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .transfer = true },
        .dstStage = .{ .host = true },
        .bufferTapes = (
          &[_] mtr.command.PipelineBarrier.BufferTapeAction {
            mtr.command.PipelineBarrier.BufferTapeAction {
              .tape = &testBufferReadTape,
              .accessFlags = .{ .hostRead = true },
            },
          }
        ),
      },
    );
  }

  mtrCtx.submitCommandBufferToQueue(queue, commandBufferScratch);
  mtrCtx.queueFlush(queue);

  {
    var mappedMemory = try mtrCtx.mapMemoryBuffer(.{
      .mapping = mtr.util.MappingType.Read,
      .buffer = testBufferRead,
      .offset = 0, .length = 4*4*4*4, // RGBA 4x4
    });
    defer mtrCtx.unmapMemory(mappedMemory);

    var mappedMemoryF32 = @ptrCast([*] f32, @alignCast(4, mappedMemory.ptr));

    std.log.info(
      "mapped memory {} {}",
      .{mappedMemoryF32[0], mappedMemoryF32[1]});
  }
}

// const vertexBinding : u32 = 0;
// const descriptorSetLayoutPerDraw = (
//   mtrCtx.createDescriptorSetLayout(
//     .perDraw,
//     .{
//       .{
//         .descriptorType = .storageBuffer,
//         .binding = vertexBinding,
//       },
//     },
//   )
// );

// { // -- write per-draw descriptors
//   const descriptorSetByDrawWriter = (
//     mtrCtx.createDescriptorSetWriter(descriptorSetLayoutPerDraw,)
//   );
//   defer descriptorSetByDrawWriter.finish();

//   try descriptorSetByDrawWriter.set(
//     .{
//       .binding = vertexBinding,
//       .buffer = triangleOriginBuffer,
//     },
//   );
// }
