const log    = @import("../../log.zig");
const util   = @import("../../util/package.zig");
const vk     = @import("../../third-party/vulkan.zig");
const ztoadz = @import("../../util/ztoadz.zig");
const zvk    = @import("../../zvk/package.zig");
const zlm    = @import("../../math/zlm.zig");

const std    = @import("std");

// based off of NVPRo Samples NVVK library

// inputs to build bottom level acceleration structure
// manage lifetime of the buffers referenced by
// vk.AccelerationStructureGeometryKHR within. Must make sure they are still
// valid and not modified when the bottom level accel structure is built or
// updated
pub const BotLvlAccelStructInput = struct  {
  accelStructGeometry :
    std.ArrayList(vk.AccelerationStructureGeometryKHR),
  accelStructBuildRangeInfo :
    std.ArrayList(vk.AccelerationStructureBuildRangeInfoKHR),

  pub fn init(alloc : * std.mem.Allocator) @This() {
    return @This() {
      .accelStructGeometry =
        std.ArrayList(vk.AccelerationStructureGeometryKHR).init(alloc),
      .accelStructBuildRangeInfo =
        std.ArrayList(vk.AccelerationStructureBuildRangeInfoKHR).init(alloc),
    };
  }

  pub fn deinit(self : @This()) void {
    self.accelStructGeometry.deinit();
    self.accelStructBuildRangeInfo.deinit();
  }
};

pub const BotLvlAccelStructEntry = struct {
  input : BotLvlAccelStructInput,
  accelStruct : zvk.primitive.Acceleration,
  flags : vk.BuildAccelerationStructureFlagsKHR =
    vk.BuildAccelerationStructureFlagsKHR .fromInt(0),

  pub fn deinit(self : @This()) void {
    self.input.deinit();
    self.accelStruct.deinit();
  }
};

const BotLvlAccelInstance = struct {
  botLvlAccelStructIdx : u32 = 0, // index of BLAS
  instanceCustomIdx : u32 = 0, // instance index (gl_InstanceCustomIndexEXT)
  hitGroupIdx : u32 = 0, // hit group index in the shader BT
  mask : u32 = 0xFF, // visibility mask & with ray mask
  flags : vk.GeometryInstanceFlagsKHR = vk.GeometryInstanceFlagsKHR {
    .triangle_facing_cull_disable_bit_khr = true,
  },
  transform : zlm.Mat4,
};

const TopLvlAccelStruct = struct {
  accelStruct : zvk.primitive.Acceleration,
  flags : vk.BuildAccelerationStructureFlagsKHR =
    vk.BuildAccelerationStructureFlagsKHR.fromInt(0),

  pub fn deinit(self : @This()) void {
    self.accelStruct.deinit();
  }
};

pub const Builder = struct {

  primitiveAllocator : zvk.primitive.Allocator,
  memoryAllocator : * std.mem.Allocator,
  queueIndex : u32,
  queue : vk.Queue,
  botLvlAccelStruct : std.ArrayList(BotLvlAccelStructEntry),
  topLvlAccelStruct : TopLvlAccelStruct,
  instanceBuffer : zvk.primitive.Buffer, // contains matrices & BLAS ids

  pub fn init(
    primitiveAllocator : zvk.primitive.Allocator,
    memoryAllocator : * std.mem.Allocator,
    queueIndex : u32,
    queue : vk.Queue,
  ) @This() {
    return @This() {
      .primitiveAllocator = primitiveAllocator,
      .memoryAllocator = memoryAllocator,
      .queueIndex = queueIndex,
      .queue = queue,
      .botLvlAccelStruct =
        std.ArrayList(BotLvlAccelStructEntry)
          .init(memoryAllocator),
      .topLvlAccelStruct = TopLvlAccelStruct {
        .accelStruct =  zvk.primitive.Acceleration.nullify(),
      },
      .instanceBuffer = zvk.primitive.Buffer.nullify(),
    };
  }

  pub fn deinit(self : * @This()) void {
    for (self.*.botLvlAccelStruct.items) |as|
      as.deinit();
    self.*.botLvlAccelStruct.deinit();
    self.*.topLvlAccelStruct.deinit();
    self.*.instanceBuffer.deinit();
  }

  pub fn topLevelAccelerationStructure(self : @This())
    vk.AccelerationStructureKHR
  {
    return self.topLvlAccelStruct;
  }

  // create all blas from vector of inputs
  //   * one BLAS per inptu vector entry
  //   * as many BLAS as input size
  //   * the resulting BLAS are stored in member BLAS, and can be referenced by
  //     idx
  // for flags use vk.BuildAccelerationStructureFlagsKHR.preferFastTraceBitKHR
  pub fn buildBottomLevelAccelStruct(
    self : * @This(),
    input : [] const BotLvlAccelStructInput,
    flags : vk.BuildAccelerationStructureFlagsKHR,
  ) anyerror!void {

    for (input) |inp| {
      (try self.*.botLvlAccelStruct.addOne()).* = BotLvlAccelStructEntry {
        .input = inp,
        .accelStruct = undefined,
      };
    }

    var buildInfo =
      std.ArrayList(vk.AccelerationStructureBuildGeometryInfoKHR)
        .init(self.*.memoryAllocator)
    ;
    defer buildInfo.deinit();

    for (input) |inp, idx| {
      (try buildInfo.addOne()).* =
        vk.AccelerationStructureBuildGeometryInfoKHR {
          .flags = flags,
          .geometryCount =
            @intCast(
              u32,
              self.*
                .botLvlAccelStruct.items[idx]
                .input.accelStructGeometry.items.len
            ),
          .pGeometries =
            self.*
              .botLvlAccelStruct.items[idx]
              .input.accelStructGeometry.items.ptr
            ,
          .mode = vk.BuildAccelerationStructureModeKHR.build_khr,
          .type = vk.AccelerationStructureTypeKHR.bottom_level_khr,
          .srcAccelerationStructure = .null_handle,
          .dstAccelerationStructure = .null_handle,
          .ppGeometries = null,
          .scratchData = vk.DeviceOrHostAddressKHR { .deviceAddress = 0, },
        }
      ;
    }

    var maxScratch : vk.DeviceSize = 0;
    var originalSizes =
      std.ArrayList(vk.DeviceSize).init(self.*.memoryAllocator)
    ;
    defer originalSizes.deinit();
    try originalSizes.resize(self.*.botLvlAccelStruct.items.len);

    for (originalSizes.items) |_, idx| {
      // query both size of finished acceleration structure and amount of
      // scratch memory needed (both written to sizeInfo). The
      // `vkGetAccelerationStructureBuildSizesKHR` function computes worst case
      // memory reqs based on user reported max # of primitives.

      var blas = &self.*.botLvlAccelStruct.items[idx];

      var maxPrimCount =
        std.ArrayList(u32).init(self.*.memoryAllocator);
      defer maxPrimCount.deinit();

      try
        maxPrimCount.resize(blas.*.input.accelStructBuildRangeInfo.items.len)
      ;

      for (maxPrimCount.items) |_, offsetIdx| {
        maxPrimCount.items[offsetIdx] =
          blas.*.input.accelStructBuildRangeInfo.items[offsetIdx].primitiveCount
        ;
      }

      var sizeInfo : vk.AccelerationStructureBuildSizesInfoKHR = undefined;

      sizeInfo.sType =
        vk.StructureType.acceleration_structure_build_sizes_info_khr
      ;
      self.*.primitiveAllocator.vkd.vkdd.getAccelerationStructureBuildSizesKHR(
        self.*.primitiveAllocator.vkd.device,
        vk.AccelerationStructureBuildTypeKHR.device_khr,
        buildInfo.items[idx],
        maxPrimCount.items.ptr,
        &sizeInfo,
      );

      // actual allocation of buffer & accel struct. This relies on
      // createInfo.offset == 0 and fills in createInfo.buffer w/ buffer
      // allocated to store BLAS. Underling vkCreateAccelerationStructureKHR
      // consumes buffer value
      blas.*.accelStruct =
        try zvk.primitive.Acceleration.init(
          self.*.primitiveAllocator,
          vk.AccelerationStructureCreateInfoKHR {
            .size = sizeInfo.accelerationStructureSize,
            .createFlags = vk.AccelerationStructureCreateFlagsKHR.fromInt(0),
            .buffer = .null_handle,
            .offset = 0,
            .type = vk.AccelerationStructureTypeKHR.bottom_level_khr,
            .deviceAddress = 0,
          },
          self.*.queueIndex,
          zvk.primitive.ObjectCreateInfo {
            .label = "BLAS",
          },
        );

      // set where build lands
      buildInfo.items[idx].dstAccelerationStructure =
        blas.*.accelStruct.handle
      ;

      // keep info
      blas.*.flags = flags;
      maxScratch =
        if (maxScratch > sizeInfo.buildScratchSize)
          (maxScratch)
        else
          (sizeInfo.buildScratchSize)
      ;

      originalSizes.items[idx] = sizeInfo.accelerationStructureSize;
    }

    // allocate stratch buffers holding temporary data of accel struct builder
    var scratchBuffer =
      try zvk.primitive.Buffer.init(
        self.*.primitiveAllocator,
        vk.BufferCreateInfo {
          .flags = vk.BufferCreateFlags {},
          .size = maxScratch,
          .usage =
            vk.BufferUsageFlags {
              .shader_device_address_bit = true,
              .storage_buffer_bit = true,
            },
          .sharingMode = vk.SharingMode.exclusive,
          .queueFamilyIndexCount = 1,
          .pQueueFamilyIndices = @ptrCast([*] const u32, &self.*.queueIndex),
        },
        vk.MemoryPropertyFlags { },
        zvk.primitive.ObjectCreateInfo {
          .label = "BLAS SCRATCH",
        },
      )
    ;
    defer scratchBuffer.deinit();

    const scratchAddress =
      self.*.primitiveAllocator.vkd.vkdd.getBufferDeviceAddress(
        self.*.primitiveAllocator.vkd.device,
        vk.BufferDeviceAddressInfo {
          .buffer = scratchBuffer.handle,
        },
      );

    var doCompaction =
      flags.contains(
        vk.BuildAccelerationStructureFlagsKHR {
          .allow_compaction_bit_khr = true,
        },
      )
    ;

    // allocate query pool for storing size for every BLAS compaction
    var queryPool =
      try self.*.primitiveAllocator.vkd.vkdd.createQueryPool(
        self.*.primitiveAllocator.vkd.device,
        vk.QueryPoolCreateInfo {
          .queryCount = @intCast(u32, self.*.botLvlAccelStruct.items.len),
          .queryType = vk.QueryType.acceleration_structure_compacted_size_khr,
          .flags = vk.QueryPoolCreateFlags.fromInt(0),
          .pipelineStatistics = vk.QueryPipelineStatisticFlags.fromInt(0),
        },
        null,
      );
    defer
      self.*.primitiveAllocator.vkd.vkdd.destroyQueryPool(
        self.*.primitiveAllocator.vkd.device,
        queryPool,
        null
      )
    ;

    self.*.primitiveAllocator.vkd.vkdd.resetQueryPool(
      self.*.primitiveAllocator.vkd.device,
      queryPool,
      0,
      @intCast(u32, self.*.botLvlAccelStruct.items.len),
    );

    // allocate command pool for queue of given queue index. To avoid timeout,
    // record and submit one command buffer per acceleratoin structure build
    var commandPool =
      try zvk.primitive.CommandPool.init(
        self.*.primitiveAllocator,
        vk.CommandPoolCreateInfo {
          .pNext = null,
          .flags = vk.CommandPoolCreateFlags.fromInt(0),
          .queueFamilyIndex = self.*.queueIndex,
        },
        zvk.primitive.ObjectCreateInfo { .label = "BLAS-cmdpool", },
      )
    ;
    defer commandPool.deinit();

    var commandBuffers =
      try zvk.primitive.CommandBuffers.init(
        self.*.primitiveAllocator,
        vk.CommandBufferAllocateInfo {
          .pNext = null,
          .commandPool = commandPool.handle,
          .level = vk.CommandBufferLevel.primary,
          .commandBufferCount =
            @intCast(u32, self.*.botLvlAccelStruct.items.len),
        },
        zvk.primitive.ObjectCreateInfo {
          .label = "BLAS-cmdbuffers",
        },
      )
    ;
    defer commandBuffers.deinit();

    for (self.*.botLvlAccelStruct.items) |blas, blasIdx| {

      var commandBuffer = commandBuffers.handles.items[blasIdx];

      // all builds use same scratch buffer
      buildInfo.items[blasIdx].scratchData.deviceAddress = scratchAddress;

      // convert user vector of offsets to vector of pointer to offset
      // this defines which subsection of the vertex/index arrays wil lbe built
      // into the BLAS
      var buildOffsets =
        std.ArrayList(* const vk.AccelerationStructureBuildRangeInfoKHR)
          .init(self.*.memoryAllocator)
      ;
      defer buildOffsets.deinit();

      try buildOffsets.resize(blas.input.accelStructBuildRangeInfo.items.len);
      for (buildOffsets.items) |_, idx| {
        buildOffsets.items[idx] =
          &blas.input.accelStructBuildRangeInfo.items[idx];
      }

      try
        self.*.primitiveAllocator.vkd.vkdd.beginCommandBuffer(
          commandBuffer,
          vk.CommandBufferBeginInfo {
            .flags =
              vk.CommandBufferUsageFlags {
                .one_time_submit_bit = true
              },
            .pInheritanceInfo = null,
          }
        )
      ;

      // build accel structure
      self.*.primitiveAllocator.vkd.vkdd.cmdBuildAccelerationStructuresKHR(
        commandBuffer,
        1,
        @ptrCast(
          [*] const vk.AccelerationStructureBuildGeometryInfoKHR,
          &buildInfo.items[blasIdx]
        ),
        buildOffsets.items.ptr,
      );

      log.info("item {}", .{buildInfo.items[blasIdx]});

      // since scratch buffer is reused across builds, need abarrier to ensure
      // one build is finished before starting next one
      var barrier = vk.MemoryBarrier {
        .srcAccessMask =
          vk.AccessFlags { .acceleration_structure_write_bit_khr = true },
        .dstAccessMask =
          vk.AccessFlags { .acceleration_structure_read_bit_khr = true },
      };

      self.*.primitiveAllocator.vkd.vkdd.cmdPipelineBarrier(
        commandBuffer,
        vk.PipelineStageFlags { .acceleration_structure_build_bit_khr = true },
        vk.PipelineStageFlags { .acceleration_structure_build_bit_khr = true },
        vk.DependencyFlags { },
        1, @ptrCast([*] const vk.MemoryBarrier, &barrier),
        0, undefined,
        0, undefined,
      );

      // if (doCompaction) {
      //   self.*
      //     .primitiveAllocator.vkd.vkdd
      //     .cmdWriteAccelerationStructuresPropertiesKHR(
      //       commandBuffer,
      //       1,
      //       @ptrCast(
      //         [*] const vk.AccelerationStructureKHR,
      //         &blas.accelStruct.handle
      //       ),
      //       vk.QueryType.acceleration_structure_compacted_size_khr,
      //       queryPool, @intCast(u32, blasIdx),
      //     );
      // }

      try self.*.primitiveAllocator.vkd.vkdd.endCommandBuffer(commandBuffer);

    } // -- for self.botLvlAccelStruct.items

    var submitInfo = vk.SubmitInfo {
      .waitSemaphoreCount = 0,
      .pWaitSemaphores = undefined,
      .pWaitDstStageMask = undefined,
      .commandBufferCount = @intCast(u32, commandBuffers.handles.items.len),
      .pCommandBuffers =
        @ptrCast([*] const vk.CommandBuffer, &commandBuffers.handles.items[0]),
      .signalSemaphoreCount = 0,
      .pSignalSemaphores = undefined,
    };

    var fence =
      try zvk.primitive.Fence.init(
        self.primitiveAllocator,
        vk.FenceCreateInfo {
          .flags = vk.FenceCreateFlags {},
        },
        zvk.primitive.ObjectCreateInfo { .label = "blas-submit" },
      );
    defer fence.deinit();

    try self.*.primitiveAllocator.vkd.vkdd.queueSubmit(
      self.*.queue,
      1, @ptrCast([*] const vk.SubmitInfo, &submitInfo),
      fence.handle,
    );

    while (@enumToInt(try fence.wait()) != @enumToInt(vk.Result.success)) {
      log.debug("{}", .{"waiting for fence to finish"});
    }

    try self.primitiveAllocator.vkd.vkdd.queueWaitIdle(self.queue,);

    // compact all BLAS
    if (doCompaction) {
      // TODO
    }
  }

  // create top level acceleration structure from vector of instance
  pub fn buildTopLevelAccelStruct(
    self : * @This(),
    instances : [] const BotLvlAccelInstance,
    flags : vk.BuildAccelerationStructureFlagsKHR,
    update : bool,
  ) void {

//     log.debug("build submit");

//     var commandPool =
//       try zvk.primitive.CommandPool.init(
//         self.*.primitiveAllocator,
//         vk.CommandPoolCreateInfo {
//           .pNext = null,
//           .flags = vk.CommandPoolCreateFlags.fromInt(0),
//           .queueFamilyIndex = self.*.queueIndex,
//         },
//         zvk.primitive.ObjectCreateInfo { .label = "BLAS-cmdpool", },
//       );
//     defer commandPool.deinit();

//     self.*.topLvlAccelStruct.flags = flags;

//     // convert arra yof instances to array of vulkan instances
//     var geometryInstances =
//       std.ArrayList(vk.AccelerationStructureInstanceKHR)
//         .init(self.*.memoryAllocator)
//     ;
//     defer geometryInstances.deinit();
//     try geometryInstances.resize(instances.len);
//     for (instances) |inst, idx|
//       geometryInstances[idx] = self.*.instanceToVkGeometryInstanceKHR(inst);

//     // create buffer holding instance data (matrices++) for use by the
//     // acceleration structure builder
//     const instanceDescsSizeInBytes =
//       instances.len * @sizeOf(vk.AccelerationStructureInstanceKHR)
//     ;

//     // allocate instance buffer & copy its contents from host to device memory
//     if (update)
//       self.*.instanceBuffer.deinit();

//     self.*.instanceBuffer =
//       try zvk.primitive.Buffer.initWithInitialDataWithOneTimeCommandBuffer(
//         self.*.primitiveAllocator,
//         commandPool,
//         vk.BufferCreateInfo {
//           .size =
//             (
//               geometryInstances.items.len
//             * @sizeOf(vk.AccelerationStructureInstanceKHR)
//             ),
//           .usage = vk.BufferUsageFlags { .shaderDeviceAddressBit = true, },
//           .flags = vk.BufferCreateFlags {},
//           .sharingMode = vk.SharingMode.exclusive,
//           .queueFamilyIndexCount = 1,
//           .pQueueFamilyIndices = &self.*.queueIndex,
//         },
//         vk.MemoryPropertyFlags { },
//         @ptrCast([] const u8, geometryInstances.items.ptr),
//         zvk.primitive.ObjectCreateInfo { .label = "TLAS-instance-buffer" },
//       )
//     ;

//     const instanceBufferDeviceAddressInfo =
//       vk.BufferDeviceAddressInfo { .buffer = self.*.instanceBuffer.handle };

//     const instanceBufferDeviceAddress =
//       self.*.primitiveAllocator.vkd.vkdd.getBufferDeviceAddress(
//         self.*.primitiveAllocator.vkd.device,
//         &instanceBufferDeviceAddressInfo,
//       );

//     const barrier =
//       vk.MemoryBarrier {
//         .srcAccessMask = vk.AccessFlags { .transferWriteBit = true },
//         .dstAccessMask =
//           vk.AccessFlags { .accelerationStructureWriteBitKHR = true },
//       }
//     ;

//     self.*.primitiveAllocator.vkd.vkdd.cmdPipelineBarrier(
//       commandBuffers.handles.items[0],
//       vk.PipelineStageFlags { .transferBit = true }, // src
//       vk.PipelineStageFlags { .accelerationStructureBuildBitKHR = true },
//       0, 1, &barrier, 0, null, 0, null
//     );

//     // -------------------------------------------------------------------------

//     // create vk.AccelerationStructureGeometryInstancesDataKHR
//     // wraps device poitner to above uploaded instances
//     const instancesVk = vk.AccelerationStructureGeometryInstancesDataKHR {
//       .arrayOfPointers = vk.FALSE,
//       .data = vk.DeviceOrHostAddressConstKHR {
//         .deviceAddress = instanceBufferDeviceAddress,
//       },
//     };

//     // put into an AccelerationStructureGeometryKHR, needs to put instances
//     // struct in a union and label it as instance data
//     var topLvlAccelStructGeometry =
//       vk.AccelerationStructureGeometryKHR {
//         .geometryType = vk.GeometryTypeKHR { .instances = true, },
//         .geometry = vk.AccelerationStructureGeometryDataKHR{
//           .instances = instancesVk,
//         },
//         .flags = GeometryFlagsKHR.fromInt(0),
//       }
//     ;

//     // find sizes
//     const buildInfo =
//       vk.AccelerationStructureBuildGeometryInfoKHR {
//         .flags = flags,
//         .geometryCount = 1,
//         .pGeometries = &topLvlAccelStructGeometry,
//         .mode =
//           if (update)
//             (vk.BuildAccelerationStructureModeKHR.update)
//           else
//             (vk.BuildAccelerationStructureModeKHR.build)
//           ,
//         .type = vk.AccelerationStructureTypeKHR.topLevel,
//         .srcAccelerationStructure = vk.null_handle,
//       }
//     ;

//     const instancesCount : u32 = @intCast(u32, instances.len);
//     const sizeInfo : vk.AccelerationStructureBuildSizesInfoKHR = undefined;
//     sizeInfo.sType = .acceleration_structure_build_sizes_info_khr;
//     sizeInfo.pNext = null;

//     self.*.primitiveAllocator.vkd.vkdd.getAccelerationStructureBuildSizesKHR(
//       self.*.primitiveAllocator.vkd.device,
//       vk.AccelerationStructureBuildTypeKHR.device_khr,
//       &buildInfo,
//       &instancesCount,
//       &sizeInfo
//     );

//     // create top level acceleration structure
//     if (!update) {
//       topLvlAccelStruct.accelStruct =
//         try zvk.primitive.Acceleration.init(
//           self.*.primitiveAllocator,
//           vk.AccelerationStructureCreateInfoKHR {
//             .type = vk.accelerationStructureType.topLevelKHR,
//             .size = sizeInfo.accelerationStructureSize,
//           },
//           zvk.primitive.ObjectCreateInfo {
//             .label = "TLAS",
//           },
//         )
//       ;
//     }

//     // allocate scratch memory
//     var scratchBuffer =
//       try zvk.primitive.Buffer.init(
//         self.*.primitiveAllocator,
//         vk.BufferCreateInfo {
//           .flags = vk.BufferCreateFlags {},
//           .size = sizeInfo.buildScratchSize,
//           .usage =
//             vk.BufferUsageFlags {
//               .shaderDeviceAddressBit = true,
//               .storageBufferBit = true,
//             },
//           .sharingMode = vk.SharingMode.exclusive,
//           .queueFamilyIndexCount = 1,
//           .queueFamilyIndices = &self.*.queueIndex,
//         },
//         vk.MemoryPropertyFlags { },
//         zvk.primitive.objectCreateInfo {
//           .label = "TLAS SCRATCH",
//         },
//       )
//     ;
//     defer scratchBuffer.deinit();

//     bufferInfo.buffer = scratchBuffer.handle;
//     const scratchAddress =
//       self.*.primitiveAllocator.vkd.vkdd.getBufferDeviceAddress(
//         self.*.vkd.device,
//         &bufferInfo,
//       )
//     ;

//     // update build information
//     buildInfo.srcAccelerationStructure =
//       if (update)
//         self.*.topLvlAccelStruct.accelStruct.handle
//       else
//         .null_handle
//     ;
//     buildInfo.dstAccelerationStructure = self.*.topLevel.accelStruct.handle;
//     buildInfo.scratchData.deviceAddress = scratchAddress;

//     // build offsets info: n instances
//     // build TLAS
//     self.*.primitiveAllocator.vkd.vkdd.cmdBuildAccelerationStructuresKHR(
//       commandBuffers.handles.items[0],
//       1, &buildInfo,
//       vk.AccelerationStructureBuildRangeInfoKHR {
//         .primitiveCount = instances.len,
//         .primitiveOffset = 0,
//         .firstVertex = 0,
//         .transformOffset = 0,
//       }
//     );

//     // submit
//     var fence =
//       zvk.Fence.init(
//         self.primitiveAllocator,
//         vk.FenceCreateInfo {
//           .flags = vk.FenceCreateFlags {},
//         },
//         zvk.ObjectCreateInfo { .label = "blas-submit" },
//       );
//     defer fence.deinit();
//     var submitInfo = vk.SubmitInfo {
//       .waitSemaphoreCount = 0,
//       .pWaitSemaphores = undefined,
//       .pWaitDstStageMask = undefined,
//       .commandBufferCount = commandBuffers.handles.items.len,
//       .pCommandBuffers =
//         @ptrCast([*]const vk.CommandBuffer, &commandBuffers.handles.items[0]),
//       .signalSemaphoreCount = 0,
//       .pSignalSemaphores = undefined,
//     };

//     log.debug("queue submit");
//     try self.*.primitiveAllocator.vkd.vkdd.queueSubmit(
//       self.queue,
//       1, @ptrCast([*] const vk.SubmitInfo, &submitInfo),
//       fence.handle,
//     );

//     log.debug("queue fence wait");
//     fence.wait();

//     log.debug("queue wait idle");
//     try self.primitiveAllocator.vkd.vkdd.queueWaitIdle(
//       self.queue,
//     );
//     log.debug("wait fin");
  }

  pub fn updateBotLvlAccelStruct(self : * @This(), botLvlAccelStructIdx : u32)
    void
  {
    // var blas = &self.*.botLvlAccelStruct.items[botLvlAccelStructIdx];

    // // prepare buildi information, acceleration is filled later
    // const buildInfo =
    //   vk.AccelerationStructureBuildGeometryInfoKHR {
    //     .flags = blas.*.flags,
    //     .geometryCount =
    //       @intCast(u32, blas.*.input.accelStructGeometry.items.len)
    //     ,
    //     .pGeometies = blas.*.input.accelStructGeometry.items.ptr,
    //     .mode = vk.buildAccelerationStructureMode.update_khr,
    //     .type = vk.accelerationStructureType.bottom_level_khr,
    //     .srcAccelerationStructure = blas.accelStruct.handle, // updates
    //     .dstAccelerationStructure = blas.accelStruct.handle,
    //   }
    // ;

    // // find size to build on device
    // for (maxPrimCount) |_, offsetIdx| {
    //   maxPrimCount[offsetIdx] =
    //     blas.*.input.accelStructBuildRangeInfo[offsetIdx].items.len
    //   ;
    // }

    // var maxPrimCount =
    //   std.ArrayList(u32).init(self.*.memoryAllocator);
    // defer maxPrimCount.deinit();

    //   try
    //     maxPrimCount.resize(blas.*.input.accelStructBuildRangeInfo.items.len)
    //   ;

    // var sizeInfo : vk.accelerationStructureBuildSizesInfoKHR = undefined;

    // sizeInfo.sType = vk.structureType.accelerationStructureBuildSizesInfoKHR;
    // self.*.vkd.vkdd.getAccelerationStructureBuildSizesKHR(
    //   self.*.vkd.device,
    //   vk.accelerationStructure.buildTypeDeviceKHR,
    //   buildInfo.items[idx],
    //   maxPrimCount.items.ptr,
    //   &sizeInfo
    // );

    // var scratchBuffer =
    //   try zvk.primitive.Buffer.init(
    //     self.*.primitiveAllocator,
    //     vk.BufferCreateInfo {
    //       .flags = vk.BufferCreateFlags {},
    //       .size = sizeInfo.buildScratchSize,
    //       .usage =
    //         vk.BufferUsageFlags {
    //           .shaderDeviceAddressBit = true,
    //           .storageBufferBit = true,
    //         },
    //       .sharingMode = vk.SharingMode.exclusive,
    //       .queueFamilyIndexCount = 1,
    //       .queueFamilyIndices = &self.*.queueIndex,
    //     },
    //     vk.MemoryPropertyFlags { },
    //     zvk.primitive.objectCreateInfo {
    //       .label = "BLAS SCRATCH",
    //     },
    //   )
    // ;

    // buildInfo.scratchData.deviceAddress =
    //   self.*.primitiveAllocator.vkd.vkdd.getBufferDeviceAddress(
    //     self.*.vkd.device,
    //     vk.BufferDeviceAddressInfo {
    //       .buffer = scratchBuffer.handle,
    //     },
    //   )
    // ;

    // var buildOffsets =
    //   std.ArrayList(* const vk.AccelerationStructureBuildRangeInfoKHR)
    //     .init(self.*.memoryAllocator)
    // ;
    // defer buildOffsets.deinit();

    // try buildOffsets.resize(blas.*.input.accelStructBuildRangeInfo.items.len);
    // for (buildOffsets) |_, idx|
    //   buildOffsets[idx] = blas.*.input.accelStructBuildRangeInfo[idx];

    // // update instance buffer on device side & build TLAS
    // var commandPool =
    //   try zvk.primitive.CommandPool.init(
    //     self.*.primitiveAllocator,
    //     vk.CommandPoolCreateInfo {
    //       .pNext = null,
    //       .flags = vk.CommandPoolCreateFlags.fromInt(0),
    //       .queueFamilyIndex = self.*.queueIndex,
    //     },
    //     zvk.primitive.ObjectCreateInfo { .label = "TLAS-cmdpool", },
    //   );
    // defer commandPool.deinit();

    // var commandBuffers :
    //   zvk.primitive.CommandBuffers.init(
    //     self.*.primitiveAllocator,
    //     vk.CommandBufferAllocateInfo {
    //       .pNext = null,
    //       .commandPool = commandPool.handle,
    //       .level = vk.CommandBufferLevel.primary,
    //       .commandBufferCount = self.*.botLvlAccelStruct.items.len,
    //     },
    //     zvk.primitive.ObjectCreateInfo {
    //       .label = "TLAS-cmdbuffers",
    //     },
    //   );
    // defer commandBuffers.deinit();


    // // update acceleration structure. vk.TRUE parameter to trigger update, and
    // // existing BLAS being passed & updated in-place
    // self.primitiveAllocator.vkd.vkdd.cmdBuildAccelerationStructuresKHR(
    //   commandBuffers.handles.items[0],
    //   1, &buildInfo, buildOffset.items.ptr,
    // );

    // // submit
    // var submitInfo = vk.SubmitInfo {
    //   .waitSemaphoreCount = 0,
    //   .pWaitSemaphores = undefined,
    //   .pWaitDstStageMask = undefined,
    //   .commandBufferCount = commandBuffers.handles.items.len,
    //   .pCommandBuffers =
    //     @ptrCast([*]const vk.CommandBuffer, &commandBuffers.handles.items[0]),
    //   .signalSemaphoreCount = 0,
    //   .pSignalSemaphores = undefined,
    // };

    // try self.*.primitiveAllocator.vkd.vkdd.queueSubmit(
    //   self.*.queue,
    //   1, @ptrCast([*] const vk.SubmitInfo, &submitInfo),
    //   .null_handle,
    // );

    // try self.*.primitiveAllocator.vkd.vkdd.queueWaitIdle(self.queue);
  }
};
