const mtr = @import("../src/mtr/package.zig");
const std = @import("std");
const util = @import("util.zig");

fn compareValues(failStr : anytype, actual : u8, expected : u8,) void {
  _ = std.testing.expect(actual == expected) catch {};
  if (actual != expected) {
    std.log.err("failure '{s}': {} == {}", .{failStr, actual, expected});
  }
}

test "snapshot - buffer" {
  std.testing.log_level = .debug;

  var snapshot = (
  \\  {
  \\    "heaps": [
  \\      {
  \\        "length": 52428800,
  \\        "visibility": "hostWritable",
  \\        "contextIdx": 103
  \\      },
  \\      {
  \\        "length": 52428800,
  \\        "visibility": "hostVisible",
  \\        "contextIdx": 106
  \\      }
  \\    ],
  \\    "heapRegions": [
  \\      {
  \\        "allocatedHeap": 106,
  \\        "offset": 0,
  \\        "length": 16,
  \\        "visibility": "hostVisible",
  \\        "contextIdx": 107
  \\      },
  \\      {
  \\        "allocatedHeap": 103,
  \\        "offset": 0,
  \\        "length": 16,
  \\        "visibility": "hostWritable",
  \\        "contextIdx": 104
  \\      }
  \\    ],
  \\    "queues": [
  \\      {
  \\        "workType": {
  \\          "transfer": true,
  \\          "compute": false,
  \\          "render": true
  \\        },
  \\        "contextIdx": 100
  \\      }
  \\    ],
  \\    "buffers": [
  \\      {
  \\        "allocatedHeapRegion": 107,
  \\        "offset": 0,
  \\        "length": 4,
  \\        "usage": {
  \\          "transferSrc": false,
  \\          "transferDst": false,
  \\          "transferSrcDst": false,
  \\          "bufferUniform": false,
  \\          "bufferStorage": false,
  \\          "bufferAccelerationStructure": false
  \\        },
  \\        "queueSharing": "exclusive",
  \\        "contextIdx": 108,
  \\        "underlyingMemory": "\u0000\u0000\u0000\u0000"
  \\      },
  \\      {
  \\        "allocatedHeapRegion": 104,
  \\        "offset": 0,
  \\        "length": 4,
  \\        "usage": {
  \\          "transferSrc": false,
  \\          "transferDst": false,
  \\          "transferSrcDst": false,
  \\          "bufferUniform": false,
  \\          "bufferStorage": false,
  \\          "bufferAccelerationStructure": false
  \\        },
  \\        "queueSharing": "exclusive",
  \\        "contextIdx": 105,
  \\        "underlyingMemory": [
  \\          128,
  \\          242,
  \\          172,
  \\          100
  \\        ]
  \\      }
  \\    ],
  \\    "images": [],
  \\    "commandPools": [
  \\      {
  \\        "flags": {
  \\          "transient": true,
  \\          "resetCommandBuffer": true
  \\        },
  \\        "contextIdx": 101,
  \\        "commandBuffers": [
  \\          {
  \\            "commandPool": 101,
  \\            "idx": 102,
  \\            "commandRecordings": [
  \\              {
  \\                "actionType": "transferMemory",
  \\                "bufferSrc": 105,
  \\                "bufferDst": 108,
  \\                "offsetSrc": 0,
  \\                "offsetDst": 0,
  \\                "length": 4
  \\              },
  \\              {
  \\                "actionType": "mapMemory",
  \\                "mapping": "Read",
  \\                "buffer": 108,
  \\                "offset": 0,
  \\                "length": 4
  \\              }
  \\            ]
  \\          }
  \\        ]
  \\      }
  \\    ]
  \\  }
  );

  std.log.info("running the test", .{});

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

  var mtrCtx =
    try mtr.Context.initFromSnapshot(
      snapshot,
      &debugAllocator.allocator,
      util.getBackend(),
      mtr.backend.RenderingOptimizationLevel.Debug,
    )
  ;
  defer mtrCtx.deinit();
}
