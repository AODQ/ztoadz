// const vk  = @import("../third-party/vulkan.zig");

const std = @import("std");

// Mesh contains submeshes; each mesh requires a different draw call
//   most probably necessary for a different set of data (such as animation or
//   texture)

// Each submesh has a vertex descriptor layout, which describes how the
//   vertices that compose the submesh should be bound to the program. You
//   request what the format of the descriptor looks like in your shader, and
//   the loader will convert your data to the requested format, allocating
//   buffers as necessary.

// Thus you could request to have an Origin Uint32_3 bound to set 0 and Color
//   Float32_3 bound to set 1

pub const VertexDescriptorAttributeType = enum {
  origin,
  color,
  normal,

  uvCoord0,
  uvCoord1,

  length,

  pub const length : usize =
    @enumToInt(VertexDescriptorAttributeType.length);
};

pub const VertexDescriptorUnderlyingType = enum {
  float32, float32_2, float32_3, float32_4,

  uint8,   uint8_2,   uint8_3,   uint8_4,
  uint16,  uint16_2,  uint16_3,  uint16_4,
  uint32,  uint32_2,  uint32_3,  uint32_4,

  int8,   int8_2,   int8_3,   int8_4,
  int16,  int16_2,  int16_3,  int16_4,
  int32,  int32_2,  int32_3,  int32_4,

  Invalid
};

pub const CreateInfo_VertexDescriptorAttribute = struct {
  bindingIndex : u32,
  underlyingType : VertexDescriptorUnderlyingType, // Invalid disables attribute
};

pub const CreateInfo_VertexDescriptorLayout = struct {
  vertexAttributes :
    [@enumToInt(VertexDescriptorAttributeType.length)]
      CreateInfo_VertexDescriptorAttribute,

  pub fn init() CreateInfo_VertexDescriptorLayout {
    var layout : CreateInfo_VertexDescriptorLayout = undefined;
    for (layout.vertexAttributes) |_, i| {
      layout.vertexAttributes[i].underlyingType =
        VertexDescriptorUnderlyingType.Invalid;
    }
    return layout;
  }
};

pub const BufferSubregion = struct {
  offset : usize,
  length : usize,
};

pub const VertexDescriptorAttribute = struct {
  bindingIndex : u32,
  underlyingType : VertexDescriptorUnderlyingType, // Invalid disables attribute
  bufferSubregion : BufferSubregion,
  bufferHandle : usize
};

pub const VertexDescriptorLayout = struct {
  vertexAttributes :
    [@enumToInt(VertexDescriptorAttributeType.length)]
      VertexDescriptorAttribute,
};

pub const Submesh = struct {
  vertexDescriptorLayout : VertexDescriptorLayout,
  elementBufferSubregion : BufferSubregion,
  elementBufferHandle    : usize,
  // elementBufferType      : vk.IndexType,
  drawElements           : u32,
};

pub const Mesh = struct {
  submeshes : std.ArrayList(Submesh),

  pub fn init(allocator : std.mem.Allocator) Mesh {
    return Mesh {
      .submeshes = std.ArrayList(Submesh).init(allocator),
    };
  }

  pub fn deinit(self : @This()) void {
    self.submeshes.deinit();
  }
};
