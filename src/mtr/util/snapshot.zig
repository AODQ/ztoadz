const mtr = @import("../package.zig");
const std = @import("std");

// ----- 1:1 zig - JSON structure -----

const Heap = struct {
  length : u64,
  visibility : mtr.heap.Visibility,
  contextIdx : u64,
};

const HeapRegion = struct {
  allocatedHeap : u64,
  offset : u64, length : u64,
  visibility : mtr.heap.Visibility,
  contextIdx : u64,
};

const QueueWorkType = struct {
  transfer : bool,
  compute : bool,
  render : bool,
};

const Queue = struct {
  workType : QueueWorkType,
  contextIdx : u64,
};

const BufferUsage = struct {
  transferSrc : bool,
  transferDst : bool,
  transferSrcDst : bool,
  bufferUniform : bool,
  bufferStorage : bool,
  bufferAccelerationStructure : bool
};

const Buffer = struct {
  allocatedHeapRegion : u64,
  offset : u64, length : u64,
  usage : BufferUsage,
  queueSharing : mtr.queue.SharingUsage,
  contextIdx : u8,
  underlyingMemory : [] u8,
};

const Image = struct {
  allocatedHeapRegion : u64,
  offset : u64, width : u64, height : u64, depth : u64,
  samplesPerTexel : mtr.image.Sample,
  arrayLayers : u64,
  mipmapLevels : u64,
  byteFormat : mtr.image.ByteFormat,
  usage : BufferUsage,
  queueSharing : mtr.queue.SharingUsage,
  contextIdx : u8,
  underlyingMemory : [] u8,
};

const CommandActionType = enum {
  unmapMemory,
  transferMemory,
  transferImageToBuffer,
  uploadTexelToImageMemory,
};

const CommandAction = union(CommandActionType) {
  transferMemory : CommandTransferMemory,
  transferImageToBuffer : CommandTransferImageToBuffer,
  uploadTexelToImageMemory : CommandUploadTexelToImageMemory,
};

const CommandBuffer = struct {
  commandPool : u64,
  idx : u64,
  commandRecordings : [] CommandAction,
};

const CommandPoolFlags = struct {
  transient : bool,
  resetCommandBuffer : bool,
};

const CommandPool = struct {
  flags : CommandPoolFlags,
  contextIdx : u64,
  commandBuffers : [] CommandBuffer,
};

const SnapshotContext = struct {
  heaps : [] Heap,
  heapRegions : [] HeapRegion,
  queues : [] Queue,
  buffers : [] Buffer,
  images : [] Image,
  commandPools : [] CommandPool,
};

// transfers memory from one buffer to another. The source and destination
// buffer may be the same
const CommandTransferMemory = struct {
  actionType : mtr.command.ActionType,
  bufferSrc : u64,
  bufferDst : u64,
  offsetSrc : u64,
  offsetDst : u64,
  length : u64,
};

const CommandTransferImageToBuffer = struct {
  actionType : mtr.command.ActionType,
  imageSrc : u64,
  bufferDst : u64,
  // TODO subregions i guess
};

const CommandTransferImage = struct {
  actionType : mtr.command.ActionType,
  imageSrc : u64,
  imageDst : u64,
  srcDimX : u64, srcDimY : u64, srcDimZ : u64,
  srcArrayLayer : u64, srcMipmap : u64,

  dstOffX : u64, dstOffY : u64, dstOffZ : u64,
  dstArrayLayer : u64, dstMipmap : u64,

  width : u64, height : u64, depth : u64,
  layers : u64, mipmaps : u64
};

const CommandUploadTexelToImageMemory = struct {
  // TODO vectors duh
  actionType : mtr.command.ActionType,
  image : u64,
  rgba : [4] f32,
  dimXBegin : i64, dimXEnd : i64,
  dimYBegin : i64, dimYEnd : i64,
  dimZBegin : i64, dimZEnd : i64,
  arrayLayerBegin : i64, arrayLayerEnd : i64,
  mipmapLevelBegin : i64, mipmapLevelEnd : i64,
};

// ----- context creation ----

// fills in snapshot related info, which does not include the
//   primitiveAllocator or the renderingContext
pub fn loadContextFromSnapshot(
  mtrCtx : * mtr.Context,
  jsonSnapshot : [] const u8,
) !void {
  _ = mtrCtx ; _ = jsonSnapshot ;
  // var tokenStream = std.json.TokenStream.init(jsonSnapshot);
  // var allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  // defer allocator.deinit();
  // @setEvalBranchQuota(100000000);
  // const parsedSnapshot = try (
  //   std.json.parse(
  //     SnapshotContext, &tokenStream, .{.allocator = &allocator.allocator}
  //   )
  // );


  // // re-create context

  // for (parsedSnapshot.heaps) |heap| {
  //   _ = try mtrCtx.constructHeapWithId(
  //     .{
  //       .visibility = heap.visibility,
  //       .length = heap.length
  //     },
  //     heap.contextIdx,
  //   );
  //   mtrCtx.allocIdx = std.math.max(mtrCtx.allocIdx, heap.contextIdx);
  // }

  // for (parsedSnapshot.heapRegions) |heapRegion| {
  //   _ = try mtrCtx.constructHeapRegionWithId(
  //     .{
  //       .allocatedHeap = heapRegion.allocatedHeap,
  //       // .offset = heapRegion.offset, this might not ever matter
  //       .length = heapRegion.length,
  //       // .visibility = heapRegion.visibility
  //     },
  //     heapRegion.contextIdx,
  //   );
  //   mtrCtx.allocIdx = std.math.max(mtrCtx.allocIdx, heapRegion.contextIdx);
  // }

  // for (parsedSnapshot.buffers) |buffer| {
  //   var newBuffer = try mtrCtx.constructBufferWithId(
  //     .{
  //       .allocatedHeapRegion = buffer.allocatedHeapRegion,
  //       .offset = buffer.offset, .length = buffer.length,
  //       .usage = .{
  //         .transferSrc = buffer.usage.transferSrc,
  //         .transferDst = buffer.usage.transferDst,
  //         .transferSrcDst = buffer.usage.transferSrcDst,
  //         .bufferUniform = buffer.usage.bufferUniform,
  //         .bufferStorage = buffer.usage.bufferStorage,
  //         .bufferAccelerationStructure = (
  //           buffer.usage.bufferAccelerationStructure
  //         ),
  //       },
  //       .queueSharing = buffer.queueSharing,
  //     },
  //     buffer.contextIdx,
  //   );
  //   mtrCtx.allocIdx = std.math.max(mtrCtx.allocIdx, buffer.contextIdx);

  //   // -- put data back into the buffer

  //   // map ptr & copy json data to it
  //   // TODO this has to be looped over 10MBs
  //   var mappedMemory : ? [*] u8 = null;
  //   {
  //     mtrCtx.beginCommandBufferWriting(mtrCtx.utilCommandBuffer);
  //     defer mtrCtx.endCommandBufferWriting();

  //     try mtrCtx.enqueueToCommandBuffer(
  //       mtr.command.MapMemory {
  //         .buffer = mtrCtx.utilBufferWrite.contextIdx,
  //         .mapping = .Write,
  //         .offset = 0,
  //         .length = buffer.underlyingMemory.len,
  //         .memory = &mappedMemory,
  //       },
  //     );
  //   }
  //   mtrCtx.submitCommandBufferToQueue(
  //     mtrCtx.utilQueue.contextIdx,
  //     mtrCtx.utilCommandBuffer,
  //   );
  //   mtrCtx.queueFlush(mtrCtx.utilQueue.contextIdx);
  //   std.debug.assert(mappedMemory != null);

  //   std.mem.copy(
  //     u8,
  //     mappedMemory.?[0 .. buffer.underlyingMemory.len],
  //     buffer.underlyingMemory
  //   );

  //   // copy buffer
  //   {
  //     mtrCtx.beginCommandBufferWriting(mtrCtx.utilCommandBuffer);
  //     defer mtrCtx.endCommandBufferWriting();

  //     try mtrCtx.enqueueToCommandBuffer(
  //       mtr.command.UnmapMemory {
  //         .buffer = mtrCtx.utilBufferWrite.contextIdx,
  //         .memory = mappedMemory.?,
  //       },
  //     );
  //     try mtrCtx.enqueueToCommandBuffer(
  //       mtr.command.TransferMemory {
  //         .bufferSrc = mtrCtx.utilBufferWrite.contextIdx,
  //         .bufferDst = newBuffer,
  //         .offsetSrc = 0,
  //         .offsetDst = 0,
  //         .length = buffer.underlyingMemory.len,
  //       },
  //     );
  //   }
  // }

  // // for (parsedSnapshot.queues) |queue| {
  // //   _ = try mtrCtx.constructQueueWithId(
  // //     .{
  // //       // .workType = queue.workType, TODO
  // //     },
  // //     queue.contextIdx,
  // //   );
  // //   mtrCtx.allocIdx = std.math.max(mtrCtx.allocIdx, queue.contextIdx);
  // // }

  // // for (parsedSnapshot.queues) |queue| {
  // //   _ = try mtrCtx.constructQueueWithId(
  // //     .{
  // //       .workType = queue.workType,
  // //     },
  // //     queue.contextIdx,
  // //   );
  // //   mtrCtx.allocIdx = std.math.max(mtrCtx.allocIdx, queue.contextIdx);
  // // }
}
