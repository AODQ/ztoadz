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

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

// to import use
// const mtr = @import("package.zig");

pub const backend    = @import("backend/package.zig");

pub const buffer     = @import("buffer.zig");
pub const command    = @import("commands.zig");
pub const context    = @import("context.zig");
pub const descriptor = @import("descriptor.zig");
pub const heap       = @import("heap.zig");
pub const image      = @import("image.zig");
pub const pipeline   = @import("pipeline.zig");
pub const queue      = @import("queue.zig");
pub const shader     = @import("shader.zig");
pub const util       = @import("util/package.zig");

pub const Context = context.Context;

pub const AccessFlags = packed struct {
  shaderRead : bool = false,
  shaderWrite : bool = false,
  uniformRead : bool = false,
  colorAttachmentRead : bool = false,
  colorAttachmentWrite : bool = false,
  transferRead : bool = false,
  transferWrite : bool = false,
  hostRead : bool = false,
  hostWrite : bool = false,
};
