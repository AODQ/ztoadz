const mtr = @import("../../mtr/package.zig");
const std = @import("std");

// simple screenshotting utility

pub const StoreImageToFileParams = struct {
  queue : mtr.queue.Idx,
  srcStage : mtr.pipeline.StageFlags,
  commandBuffer : mtr.command.BufferIdx,
  imageToStore : mtr.image.Idx,
  imageToStoreTape : * mtr.memory.ImageTape,
  filename : [] const u8,
};

pub fn storeImageToFile(
  mtrCtx : * mtr.Context,
  params : StoreImageToFileParams,
) !void {

  var mtImage = mtrCtx.images.get(params.imageToStore).?;

  if (
       mtImage.depth > 1
    or mtImage.samplesPerTexel != .s1
    or mtImage.arrayLayers > 1
  ) {
    return error.InvalidImageFormat;
  }

  // create buffer to store image
  var bufferToStoreImage : mtr.buffer.Idx = 0;
  // defer mtrCtx.destroyBuffer(bufferToStoreImage);
  var bufferToStoreImageHeapRegion : mtr.heap.RegionIdx = 0;
  {
    var heapRegionAllocator = mtrCtx.createHeapRegionAllocator(.hostVisible);
    defer bufferToStoreImageHeapRegion = heapRegionAllocator.finish();

    bufferToStoreImage = try (
      heapRegionAllocator.createBuffer(.{
        .offset = 0,
        .length = mtImage.getImageByteLength(),
        .usage = mtr.buffer.Usage { .transferDst = true },
        .queueSharing = .exclusive,
      })
    );
  }
  // defer mtrCtx.destroyHeapRegion(bufferToStoreImageHeapRegionAllocation);

  {
    var commandBufferRecorder = (
      mtrCtx.createCommandBufferRecorder(params.commandBuffer)
    );
    defer commandBufferRecorder.finish();

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = params.srcStage,
        .dstStage = .{ .transfer = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            mtr.command.PipelineBarrier.ImageTapeAction {
              .tape = params.imageToStoreTape,
              .layout = .transferSrc,
              .accessFlags = .{ .transferRead = true },
            },
          }
        ),
      },
    );

    commandBufferRecorder.append(
      mtr.command.TransferImageToBuffer {
        .imageSrc = params.imageToStore,
        .bufferDst = bufferToStoreImage,
        .width = mtImage.width, .height = mtImage.height,
      }
    );

    commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .transfer = true },
        .dstStage = .{ .host = true },
      },
    );
  }

  mtrCtx.submitCommandBufferToQueue(params.queue, params.commandBuffer);
  // TODO replace with fence
  mtrCtx.queueFlush(params.queue);

  {
    var mappedMemory = try mtrCtx.mapMemoryBuffer(.{
      .mapping = mtr.util.MappingType.Read,
      .buffer = bufferToStoreImage,
      .offset = 0,
      .length = mtImage.getImageByteLength()
    });


    // TODO for now only support RGBA u8
    var rgbaMemory = @ptrCast([*] u8, @alignCast(1, mappedMemory.ptr));

    const file = try std.fs.cwd().createFile(params.filename, .{ });
    defer file.close();
    var rgbaIt : usize = 0;
    // _ = try file.write("P3\n{}
    try std.fmt.format(
      file.writer(), "P3\n{} {}\n{}\n", .{mtImage.width, mtImage.height, 255}
    );
    while (rgbaIt < mtImage.getImageByteLength()) : (rgbaIt += 1) {
      if (rgbaIt > 0 and (rgbaIt+1) % 4 == 0 and mtImage.channels == .RGBA) {
        continue;
      }

      var b : [8] u8 = undefined;
      const printedBuffer = (
        try std.fmt.bufPrint(&b, "{} ", .{@intCast(u32, rgbaMemory[rgbaIt])})
      );
      _ = try file.write(printedBuffer);
    }
  }
}
