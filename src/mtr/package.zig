// monte-toad 'R'
// The library is an abstraction over a CPU-SW-rasterizer, a
// GPU-compute-rasterizer [Vulkan], and a GPU-HW-raytracer [Vulkan]

// The primary purpose is to render, pose & animate models and scenes at high
//   quality, by using cutting-edge and experimental techniques. It could be
//   used for other purposes as well

// The library is composed of render-passes, of which either the description of
// the scene & how to render it is filled out by the user and emitted as a
// series of buffers, or as a description of how to transform some set of
// buffers

// All primitives can optionally have debug labels

//------------------------------------------------------------------------------
// 'diagrams'
//
// -- memory allocation
//
// .--------------------------.  | .------.
// |           HEAP           |  | | HEAP |
// '--------------------------'  | '------'
//        v                v
// .---------------.  | .-------
// |  HEAP REGION  |  | | H.R. |
// '---------------'  | '-------
//       v
// .****************.   .---------.
// | BUFFER | IMAGE | | | SCRATCH |
// '****************'   '---------'

//------------------------------------------------------------------------------
// technical clarification:
// * anything memory-based (such as indices/lengths into ram) will be u64,
// * all allocations in the library are done by heaps, which may live on the
//     host or device. The exception are primitives held by the context,
//     which are stored with std containers and can use the usual zig allocators

// language clarification:
// * host relates to the CPU, device to the GPU (or CPU SW-rasterizer)
// * convention 'offset, length' rather than 'length, offset'
// * 'such that' refers to some declarative statement that must hold true
// * 'for the purpose' refers to some generalization of a statement, where
//     unimportant details are left out for the sake of brevity, often in
//     regards to what the library will do
//------------------------------------------------------------------------------

const std = @import("std");
const log = @import("../log.zig");

pub const HeapBackingMemoryTypeTag = enum {
  cpu,
  gpu
};

pub const HeapBackingMemory = union(HeapBackingMemoryTypeTag) {
  cpu : [] u8,
  gpu : void, // unimplemented
};

// types of indices into a context just for simple type-safety
pub const HeapIdx = u64;
pub const HeapRegionIdx = u64;
pub const BufferIdx = u64;
pub const QueueIdx = u64;
pub const CommandIdx = u64;

// Describes the visibility of the heap between host and device
pub const HeapVisibility = enum {
  deviceOnly,
  hostVisible,
  hostWritable,
};

// Every primitive must be heap-backed, in this every piece of memory
//   in the library is accounted for & can be manually managed by the user.
//   Multiple primitives can be allocated inside a single allocation
pub const Heap = struct {
  underlyingMemory : HeapBackingMemory,
  length : u64,
  visibility : HeapVisibility,
  contextIdx : HeapIdx,
};

// describes in what contexts the buffer may be accessed for both reading &
//   writing
// transfer allows buffers to copy regions of their memory to others
// buffer describes in what context the buffer will be used
//
pub const BufferUsage = packed struct {
  transferSrc : bool = false,
  transferDst : bool = false,
  transferSrcDst : bool = false,

  bufferUniform : bool = false,
  bufferStorage : bool = false,
  bufferAccelerationStructure : bool = false,

  queue : bool = false,
};

// Describes how a queue should interact with other queues when using the
//   buffer. exclusive means the buffer will be used by only one queue at a
//   time, while concurrent implies that there is potential for multiple queues
//   to be using the same buffer at a time (mandating some sort of
//   synchronization)
pub const QueueBufferSharingUsage = enum {
  exclusive,
  concurrent,
};

// Any piece of memory must be allocated under a heap-region. Having an
//   intermediary allocator allows for multiple primitives to be under a single
//   region. The heap region allocation can be overriden by a custom allocator,
//   while memory under the region must be managed manually. In other
//   words, you request memory from a Heap as a HeapRegion, similar to a
//   'malloc', and then fill that region out however you like. Everything above
//   is, by default, automated.
//
// It might make sense to then group allocations like buffers and images
//   together based on their lifetime/usage.
pub const HeapRegion = struct {
  allocatedHeap : HeapIdx,
  offset : u64, length : u64,
  contextIdx : HeapRegionIdx,
};

// Any piece of information that exists as an array of elements must be
//   referenced to as a buffer. The buffer describes both where this data
//   lives, as well as describes it as a form of metadata. An array of elements
//   should be contained in an array as large as possible, where allocation
//   and deallocation of the entire array is a valid operation.
pub const Buffer = struct {
  allocatedHeapRegion : HeapRegionIdx,
  offset : u64,
  length : u64,
  usage : BufferUsage,
  queueSharing : QueueBufferSharingUsage,
  contextIdx : BufferIdx,
};

// a view into a buffer
pub const BufferView = struct {
  buffer : BufferIdx,
  offset : u64,
  length : u64,
};

pub const CommandActionType = enum {
  uploadMemory,
  transferMemory,
  invalid,
};

// uploads memory from the host to the device at a specified hostVisible buffer
pub const CommandUploadMemory = struct {
  actionType : CommandActionType = .uploadMemory,
  buffer : BufferIdx,
  offset : u64,
  memory : [] const u8,
};

// transfers memory from one buffer to another. The source and destination
// buffer may be the same
pub const CommandTransferMemory = struct {
  actionType : CommandActionType = .transferMemory,
  bufferSrc : BufferIdx,
  bufferDst : BufferIdx,
  offsetSrc : u64,
  offsetDst : u64,
  length : u64,
};

const CommandAction = union(CommandActionType) {
  uploadMemory : CommandUploadMemory,
  transferMemory : CommandTransferMemory,
  invalid : void,
};

// some amount of action independent of another, such that one complete amount
//   of work can be made between the GPU and CPU. Such as blits, allocations,
//   initiating a render dispatch, etc
// Commands are not unique, and as such are treated as primitives and may
//   not refer to any specific unique index of a queue
pub const Command = struct {
  action : CommandAction,
  commandType : CommandType,
};

// describes the type of work a queue will do, for the purpose that the device
//   can perform more actions concurrently if multiple queues have different
//   workloads
pub const QueueWorkType = packed struct {
  transfer : bool = false,
  compute : bool = false,
  render : bool = false,
};

// Describes some amount of independent work-flow, such that multiple
//   queues can work independently of each other with minimal interaction.
//   commands are buffered into a queue and then acted on when specified
pub const Queue = struct {
  commandActions : std.ArrayList(CommandAction),
  workType : QueueWorkType,
  contextIdx : QueueIdx,
};

//------------------------------------------------------------------------------
//-- constructors --------------------------------------------------------------
//------------------------------------------------------------------------------

pub const HeapConstructInfo = struct {
  visibility : HeapVisibility,
  length : u64,
};

pub const HeapRegionConstructInfo = struct {
  allocatedHeap : HeapIdx,
  length : u64,
};

pub const BufferConstructInfo = struct {
  allocatedHeapRegion : HeapRegionIdx,
  offset : u64, length : u64,
  usage : BufferUsage,
  queueSharing : QueueBufferSharingUsage,
};

pub const QueueConstructInfo = struct {
  workType : QueueWorkType,
};

//------------------------------------------------------------------------------
//-- errors --------------------------------------------------------------------
//------------------------------------------------------------------------------

// Any function that returns an error will do so from an error most likely at
//   the fault of the user. Any errors that can reasonably be expected to come
//   from the internal library on 'good faith', such as incorrect primitive
//   indices, will instead assert in debug builds.
//
// The goal is to allow the user to recover from a reasonable error at
//   run-time, while making the assumption that internal library errors are so
//   significant that the only valid option for an application is to log any
//   useful information and then exit.
//
// This is to prevent the user dealing with the expectation that every internal
//   library error could even be recoverable.
const MappingError = error {
  OutOfBounds,
  UnknownBufferId,
  InvalidHeapAccess,
};

//------------------------------------------------------------------------------
//-- context -------------------------------------------------------------------
//------------------------------------------------------------------------------

pub const RenderingContextType = enum {
  softwareRasterizer,
};

pub const RenderingOptimizationLevel = enum {
  Release,
  Debug,
};

const RenderingContextSoftwareRasterizer = struct {
  debugAllocator : std.heap.GeneralPurposeAllocator(
    .{.enable_memory_limit = true, .safety = true}
  ),
  releaseAllocator : std.heap.GeneralPurposeAllocator(.{}),
  heapAllocator : * std.mem.Allocator,

  pub fn init(optimization : RenderingOptimizationLevel) @This() {
    const isDebug = optimization == .Debug;

    var self : @This() = undefined;

    if (optimization == .Debug) {
      self.debugAllocator = @TypeOf(self.debugAllocator){};
      self.heapAllocator = &self.debugAllocator.allocator;
    } else {
      self.releaseAllocator = @TypeOf(self.releaseAllocator){};
      self.heapAllocator = &self.releaseAllocator.allocator;
    }

    // let's do a sanity test that the allocator works
    if (isDebug) {
      const bytes =
        self.heapAllocator.allocator.alloc(u8, 8)
        catch unreachable
      ;
      defer self.debugAllocator.allocator.free(bytes);
    }

    return self;
  }

  pub fn deinit(self : * @This()) void {
    if (self.debugAllocator.deinit()) {
      log.info("{s}", .{"memory leak in debug allocator"});
    }
    if (self.releaseAllocator.deinit()) {
      log.info("{s}", .{"memory leak in release allocator"});
    }
  }

  pub fn allocateHeap(
    self : @This(), ci : HeapConstructInfo
  ) !HeapBackingMemory {
    const memory : [] u8 = try self.heapAllocator.alloc(u8, ci.length);
    return HeapBackingMemory{ .cpu = memory };
  }

  pub fn mapMemory(
    self : @This(),
    context : Context,
    range : MappedMemoryRange,
  ) MappingError ! [*] u8 {
    var buffer = context.buffers.getPtr(range.buffer);

    if (!buffer) {
      return MappingError.UnknownBufferId;
    }

    if (
         range.offset < buffer.?.length
      or range.offset+range.length < buffer.?.length
    ) {
      return MappingError.OutOfBounds;
    }

    // TODO possibly make some assertion that the mapping isn't already mapped

    var heap = context.heaps.getPtr(buffer.?.allocatedHeapRegion);
    assert(heap); // internal library error if buffer points to nonvalid heap

    if (heap.?.visibility.deviceOnly) {
      return MappingError.InvalidHeapAccess;
    }

    return heap.?.underlyingMemory.cpu.ptr + range.offset;
  }

  pub fn unmapMemory(
    self : @This(),
    context : Context,
    ptr : [*] u8,
  ) void {
    // no-op
    // TODO possibly make some assertion that the mapping is currently mapped
  }
};

pub const RenderingContext = union(RenderingContextType) {
  softwareRasterizer : RenderingContextSoftwareRasterizer,

  pub fn mapMemory(
    self : * @This(),
    context : Context,
    range : MappedMemoryRange,
  ) [*] u8 {
    return switch (self.*) {
      RenderingContextSoftwareRasterizer => (
        self.softwareRasterizer.mapMemory(context, range)
      )
    };
  }

  pub fn unmapMemory(
    self : * @This(),
    context : Context,
    ptr : [*] u8
  ) void {
    return switch (self.*) {
      RenderingContextSoftwareRasterizer => (
        self.softwareRasterizer.unmapMemory(context, ptr)
      )
    };
  }
};

pub const MappedMemoryRange = struct {
  buffer : BufferIdx,
  offset : u64,
  length : u64,
};

pub const MappedMemory = struct {
  context : Context,
  range : MappedMemoryRange,
  data : [*] u8,

  pub fn init(
    context : Context,
    range : MappedMemoryRange,
  ) @This() {
    return .{
      .context = context,
      .range = range,
      .data = (
        context.renderingContext.mapMemory(context, range)
      ),
    };
  }

  pub fn deinit(self : @This()) void {
    context.renderingContext.unmapMemory(context, data);
  }
};

// All primitives exist inside a 'Context', which is the primary means to
// communicate with monte-toad. While remaining flexible enough to be used in
// a multi-threaded fashion, it allows for all data to be serialized, dumped &
// deserialized, which will allow for extensive unit-testing of the library.
pub const Context = struct {
  heaps : std.AutoHashMap(HeapIdx, Heap),
  heapRegions : std.AutoHashMap(HeapRegionIdx, HeapRegion),
  queues : std.AutoHashMap(QueueIdx, Queue),
  buffers : std.AutoHashMap(BufferIdx, Buffer),

  primitiveAllocator : * std.mem.Allocator,

  renderingContext : * RenderingContext,
  optimization : RenderingOptimizationLevel,

  allocIdx : u64, // temporary FIXME

  pub fn init(
    primitiveAllocator : * std.mem.Allocator,
    renderingContext : RenderingContextType,
    optimization : RenderingOptimizationLevel,
  ) @This() {
    const self : @This() = undefined;
    var allocatedRenderingContext = (
      primitiveAllocator.create(RenderingContext)
    ) catch {
      std.debug.panic("could not allocate rendering context", .{});
    };

    allocatedRenderingContext.* = (
      switch (renderingContext) {
        .softwareRasterizer => (.{
          .softwareRasterizer = (
            RenderingContextSoftwareRasterizer.init(optimization)
          ),
        }),
      }
    );

    return .{
      .heaps = @TypeOf(self.heaps).init(primitiveAllocator),
      .queues = @TypeOf(self.queues).init(primitiveAllocator),
      .heapRegions = @TypeOf(self.heapRegions).init(primitiveAllocator),
      .buffers = @TypeOf(self.buffers).init(primitiveAllocator),
      .primitiveAllocator = primitiveAllocator,
      .optimization = optimization,
      .renderingContext = allocatedRenderingContext,
      .allocIdx = 0,
    };
  }

  pub fn deinit(self : * @This()) void {
    self.heaps.deinit();
    self.queues.deinit();
    self.heapRegions.deinit();
    self.buffers.deinit();
    switch (self.renderingContext.*) {
      .softwareRasterizer => (
        self.renderingContext.softwareRasterizer.deinit()
      ),
    }
  }

  pub fn constructHeap(self : * @This(), ci : HeapConstructInfo) !HeapIdx {
    const heap = Heap {
      .underlyingMemory = (
        switch (self.renderingContext.*) {
          .softwareRasterizer => (
            try self.renderingContext.softwareRasterizer.allocateHeap(ci)
          )
        }
      ),
      .length = ci.length,
      .visibility = ci.visibility,
      .contextIdx = self.allocIdx,
    };

    try self.heaps.putNoClobber(self.allocIdx, heap);

    self.allocIdx += 1;

    return heap.contextIdx;
  }

  pub fn constructHeapRegion(
    self : * @This(), ci : HeapRegionConstructInfo
  ) !HeapRegionIdx {
    const heapRegion = HeapRegion {
      .allocatedHeap = ci.allocatedHeap,
      .offset = 0, // TODO FIX ME with a proper allocator
      .length = ci.length,
      .contextIdx = self.allocIdx,
    };

    // TODO assert length/offset of region is less than the allocated heap
    //   length
    // TODO assert NO overlap with other heap regions in debug mode

    try self.heapRegions.putNoClobber(self.allocIdx, heapRegion);

    self.allocIdx += 1;

    return heapRegion.contextIdx;
  }

  pub fn constructBuffer(
    self : * @This(), ci : BufferConstructInfo
  ) !BufferIdx {
    const buffer = Buffer {
      .allocatedHeapRegion = ci.allocatedHeapRegion,
      .offset = ci.offset,
      .length = ci.length,
      .usage = ci.usage,
      .queueSharing = ci.queueSharing,
      .contextIdx = self.allocIdx,
    };

    // TODO assert NO overlap with other buffers/images in debug mode

    try self.buffers.putNoClobber(self.allocIdx, buffer);

    self.allocIdx += 1;

    return buffer.contextIdx;
  }

  pub fn constructQueue(self : * @This(), ci : QueueConstructInfo) !QueueIdx {
    const queue = Queue {
      .commandActions = (
        std.ArrayList(CommandAction).init(self.primitiveAllocator)
      ),
      .workType = ci.workType,
      .contextIdx = self.allocIdx,
    };

    try self.queues.putNoClobber(self.allocIdx, queue);

    self.allocIdx += 1;

    return queue.contextIdx;
  }

  pub fn enqueueCommand(
    self : * @This(), queueIdx : QueueIdx, command : anytype
  ) !void {
    var queue : ? Queue = self.queues.get(queueIdx);
    std.debug.assert(queue != null);
    if (@TypeOf(command) == CommandUploadMemory) {
      try queue.?.commandActions.append(.{.uploadMemory = command});
    } else if (@TypeOf(command) == CommandTransferMemory) {
      try queue.?.commandActions.append(.{.transferMemory = command});
    }
  }

  pub fn queueFlush(self : @This(), queueIdx : QueueIdx) void {
    var queue : ? Queue = self.queues.get(queueIdx);
    std.debug.assert(queue);
    // TODO flush out the buffer
  }

  pub fn mapBufferMemory(
    self : @This(),
    range : MappedMemoryRange,
  ) MappedMemory {
    return MappedMemory.init(self, range);
  }
};
