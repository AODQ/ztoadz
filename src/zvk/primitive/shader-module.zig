// Primary vulkan library

const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");

const assert = std.debug.assert;
const std = @import("std");

pub const ShaderModule = struct {
  handle : vk.ShaderModule,
  primitiveAllocator : zvk.primitive.Allocator,

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    info : vk.ShaderModuleCreateInfo,
    objectInfo : zvk.primitive.ObjectCreateInfo
  ) !ShaderModule {
    log.debug("shader module init: {}", .{objectInfo});
    var self = primitiveAllocator.createShaderModule(info);

    if (self.handle == .null_handle) {
      return error.ShaderModuleConstructionFailed;
    }

    primitiveAllocator.labelObject(
      vk.DebugUtilsObjectNameInfoEXT {
        .objectType = vk.ObjectType.shader_module,
        .objectHandle = @bitCast(u64, self.handle),
        .pObjectName = objectInfo.label,
      },
    );

    return self;
  }

  pub fn nullify() ShaderModule {
    return ShaderModule {
      .handle = .null_handle,
      .primitiveAllocator = undefined,
    };
  }

  pub fn deinit(self : @This()) void {
    self.primitiveAllocator.destroyShaderModule(self);
  }
};
