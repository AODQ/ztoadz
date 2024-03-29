const mtr = @import("../../mtr/package.zig");
const std = @import("std");

// simple screenshotting utility

pub const StoreImageToFileParams = struct {
  queue : mtr.queue.Idx,
  srcStage : mtr.pipeline.StageFlags,
  commandBuffer : mtr.command.BufferIdx,
  imageToStore : mtr.image.Idx,
  imageToStoreLayout : mtr.image.Layout,
  imageToStoreAccessFlags : mtr.memory.AccessFlags,
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
        .label = "save-image-mappping",
        .length = mtImage.getImageByteLength(),
        .usage = mtr.buffer.Usage { .transferDst = true },
        .queueSharing = .exclusive,
      })
    );
  }
  // defer mtrCtx.destroyHeapRegion(bufferToStoreImageHeapRegionAllocation);

  {
    var commandBufferRecorder = (
      try mtr.util.CommandBufferRecorder.init(.{
        .ctx = mtrCtx,
        .commandBuffer = params.commandBuffer,
        .imageTapes = &[_] mtr.memory.ImageTape {
          .{
            .image = params.imageToStore,
            .layout = params.imageToStoreLayout,
            .accessFlags = params.imageToStoreAccessFlags,
          }
        },
      })
    );
    defer commandBufferRecorder.finish();

    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = params.srcStage,
        .dstStage = .{ .transfer = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            mtr.command.PipelineBarrier.ImageTapeAction {
              .image = params.imageToStore,
              .layout = .transferSrc,
              .accessFlags = .{ .transferDst = true },
            },
          }
        ),
      },
    );

    try commandBufferRecorder.append(
      mtr.command.TransferImageToBuffer {
        .imageSrc = params.imageToStore,
        .bufferDst = bufferToStoreImage,
        .width = mtImage.width, .height = mtImage.height,
      }
    );

    try commandBufferRecorder.append(
      mtr.command.PipelineBarrier {
        .srcStage = .{ .transfer = true },
        .dstStage = .{ .end = true },
        .imageTapes = (
          &[_] mtr.command.PipelineBarrier.ImageTapeAction {
            mtr.command.PipelineBarrier.ImageTapeAction {
              .image = params.imageToStore,
              .layout = .general,
              .accessFlags = .{ },
            },
          }
        ),
      },
    );
  }

  try mtrCtx.submitCommandBufferToQueue(
    params.queue, params.commandBuffer, .{}
  );
  // TODO replace with fence
  try mtrCtx.queueFlush(params.queue);

  {
    var mappedMemory = try mtrCtx.mapMemoryBuffer(.{
      .mapping = mtr.util.MappingType.Read,
      .buffer = bufferToStoreImage,
      .offset = 0,
      .length = mtImage.getImageByteLength()
    });

    // TODO for now only support RGBA u8
    var rgbaMemory = @ptrCast([*] const u8, @alignCast(1, mappedMemory.ptr));

    const file = try std.fs.cwd().createFile(params.filename, .{ });
    defer file.close();
    try std.fmt.format(
      file.writer(),
      "P7\nWIDTH {}\nHEIGHT {}\nMAXVAL {}\nTUPLTYPE RGB_ALPHA\nENDHDR\n",
      .{mtImage.width, mtImage.height, 255}
    );
    _ = try file.write(rgbaMemory[0..mtImage.getImageByteLength()]);
  }
}
