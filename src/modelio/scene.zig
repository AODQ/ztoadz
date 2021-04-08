// scene composition:
//
//          Camera
// Scene => Light
//          Node => Mesh
//          Mesh => Submeshes => Buffers, Vertex Descriptor/Layout, Textures
// TODO animation

usingnamespace @import("mesh.zig");

const std = @import("std");

pub const Node = struct {
  meshHandle : usize,
  parent : usize,
};

pub const Buffer = struct {
  memory : std.ArrayList(u8),
};

pub const Scene = struct {
  nodes : std.ArrayList(Node),
  meshes : std.ArrayList(Mesh),
  buffers : std.ArrayList(Buffer),

  pub fn init(allocator : * std.mem.Allocator) Scene {
    return Scene {
      .nodes = std.ArrayList(Node).init(allocator),
      .meshes = std.ArrayList(Mesh).init(allocator),
      .buffers = std.ArrayList(Buffer).init(allocator),
    };
  }

  pub fn deinit(self : @This()) void {
    self.nodes.deinit();

    for (self.meshes.items) |m| { m.deinit(); }
    self.meshes.deinit();

    for (self.buffers.items) |b| { b.memory.deinit(); }
    self.buffers.deinit();
  }
};
