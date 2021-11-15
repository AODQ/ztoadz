const mtr = @import("package.zig");
const std = @import("std");
pub usingnamespace @import("package.zig");

pub const Idx = u64;

pub const ConstructInfo = struct {
  workType : mtr.queue.WorkType,
};
// Describes how a queue should interact with other queues when using the
//   buffer. exclusive means the buffer will be used by only one queue at a
//   time, while concurrent implies that there is potential for multiple queues
//   to be using the same buffer at a time (mandating some sort of
//   synchronization)
// TODO if the buffer is SharingModeConcurrent, this *needs* to be a tagged
//   union where the queues that will use this buffer are stuffed into a list
//   otherwise we can't tell Vk backend which queues are used in
//   VkBufferCreateInfo
pub const SharingUsage = enum {
  exclusive,
  concurrent,

  pub const jsonStringify = mtr.util.json.JsonEnumMixin.jsonStringify;
};

// describes the type of work a queue will do, for the purpose that the device
//   can perform more actions concurrently if multiple queues have different
//   workloads
pub const WorkType = packed struct {
  transfer : bool = false,
  compute : bool = false,
  render : bool = false,
};

// Describes some amount of independent work-flow, such that multiple
//   queues can work independently of each other with minimal interaction.
//   commands are buffered into a queue and then acted on when specified
pub const Primitive = struct {
  workType : mtr.queue.WorkType,
  contextIdx : mtr.queue.Idx,
};
