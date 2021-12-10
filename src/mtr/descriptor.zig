const mtr = @import("package.zig");
const std = @import("std");

pub const Idx = u64;
pub const SetIdx = u64;
pub const PoolIdx = u64;
pub const LayoutIdx = u64;

pub const Type = enum {
  uniformBuffer,
  storageBuffer,
  sampler,
  sampledImage,
  storageImage,

  pub const jsonStringify = mtr.util.json.JsonEnumMixin.jsonStringify;
};

pub const PushConstantRange = struct {
  offset : u32,
  length : u32, // must be a multiple of 4
};

pub const Frequency = enum {
  perFrame,
  perDraw,
};

pub const Set = struct {
  pool : mtr.descriptor.PoolIdx,
  layout : mtr.descriptor.LayoutIdx,

  contextIdx : mtr.descriptor.SetIdx = 0,
};

pub const SetPoolSizes = struct {
  sampler : u32,
  sampledImage : u32,
  storageImage : u32,
  storageBuffer : u32,
  uniformBuffer : u32,
};

pub const SetPoolCreateInfo = struct {
  frequency : Frequency,
  maxSets : u32,
  descriptorSizes : SetPoolSizes,
};

pub const SetPool = struct {
  frequency : Frequency,
  maxSets : u32,
  descriptorSizes : SetPoolSizes,
  contextIdx : mtr.descriptor.PoolIdx,
};

pub const SetLayoutBinding = struct {
  binding : u32,
  descriptorType : Type,
  count : u32 = 1,
};

pub const SetLayoutConstructInfo = struct {
  frequency : mtr.descriptor.Frequency,
  bindings : [] const SetLayoutBinding,
  pool : PoolIdx,
};

pub const SetLayout = struct {
  bindings : (
    std.AutoHashMap(Type, std.ArrayList(SetLayoutBinding))
  ),
  bindingIdxToLayoutBinding : (
    std.AutoHashMap(u32, SetLayoutBinding)
  ),
  frequency : Frequency,
  pool : PoolIdx,

  contextIdx : LayoutIdx,

  pub fn init(
    alloc : * std.mem.Allocator,
    ci : SetLayoutConstructInfo,
    contextIdx : LayoutIdx,
  ) @This() {
    var self = @This() {
      .bindings = (
        std.AutoHashMap(
          Type, std.ArrayList(SetLayoutBinding)
        ).init(alloc)
      ),
      .bindingIdxToLayoutBinding = (
        std.AutoHashMap(u32, SetLayoutBinding).init(alloc)
      ),
      .frequency = ci.frequency,
      .pool = ci.pool,
      .contextIdx = contextIdx,
    };

    // filters into appropiate array
    for (ci.bindings) |binding| {
      var bindingArray = self.bindings.getPtr(binding.descriptorType);
      if (bindingArray == null) {
        self.bindings.putNoClobber(
          binding.descriptorType,
          std.ArrayList(SetLayoutBinding).init(alloc)
        ) catch unreachable;
        bindingArray = self.bindings.getPtr(binding.descriptorType);
      }

      (bindingArray.?.addOne() catch unreachable).* = binding;

      std.debug.assert(
        self.bindingIdxToLayoutBinding.get(binding.binding) == null
      );

      self.bindingIdxToLayoutBinding.putNoClobber(binding.binding, binding)
        catch {
        std.log.err(
          "binding {} is being used multiple times",
          .{binding.binding}
        );
      };
    }

    return self;
  }

  pub fn deinit(self : * @This()) void {
    var bindingIter = self.bindings.iterator();
    while (bindingIter.next()) |binding| {
      binding.value_ptr.deinit();
    }
    self.bindingIdxToLayoutBinding.deinit();
    self.bindings.deinit();
  }
};

pub const SetWriter = struct {
  context : * mtr.Context,
  layout : SetLayout,
  destinationSet : SetIdx,

  writes : std.ArrayList(Binding),

  pub fn init(
    ctx : * mtr.Context,
    layout : SetLayout,
    destinationSet : SetIdx,
  ) @This() {
    return . {
      .context = ctx,
      .layout = layout,
      .destinationSet = destinationSet,
      .writes = std.ArrayList(Binding).init(ctx.primitiveAllocator),
    };
  }

  pub const Binding = struct {
    binding : u32,
    imageView : ? mtr.image.ViewIdx = null,
    buffer : ? mtr.buffer.Idx = null,
    bufferOffset : u32 = 0,
    bufferLength : u32 = 0,
  };

  pub fn set(self : * @This(), binding : Binding) !void {
    (try self.writes.addOne()).* = binding;
    // const uBind = try layout.bindingIdxToLayoutBinding.get(binding.binding);
  }

  pub fn finish(self : * @This()) void {
    self.context.rasterizer.writeDescriptorSet(self.context.*, self.*)
      catch |err| {
        std.log.err("failed to finish writing binding: {}", .{err});
      };
    self.writes.deinit();
  }
};
