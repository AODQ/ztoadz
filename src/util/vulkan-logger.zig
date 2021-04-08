const std = @import("std");
const vk = @import("third-party/vulkan.zig");

pub fn PhysicalDevice(
  physicalDeviceProperties : vk.PhysicalDeviceProperties
) void {
  std.log.info(
    \\Physical Device Info ------
    \\  API Version {}
    \\  Driver Version {}
    \\  vendorID {}
    \\  deviceID {}
    \\  deviceType {}
    \\  deviceName {}
    \\  pipelineCacheUUID .. TODO\n
  , .{
      physicalDeviceProperties.apiVersion
    , physicalDeviceProperties.driverVersion
    , physicalDeviceProperties.vendorId
    , physicalDeviceProperties.deviceId
    , physicalDeviceProperties.deviceType
    , physicalDeviceProperties.deviceName
    }
  );

  PhysicalDeviceLimits(physicalDeviceProperties.limits);
  PhysicalDeviceSparseProperties(physicalDeviceProperties.sparseProperties);
}

pub fn PhysicalDevice11(
  properties : vk.PhysicalDeviceVulkan11Properties
) void {
  var pointClipStr =
    std
      .ArrayListSentineled(u8, 0)
      .init(std.testing.allocator, @tagName(properties.pointClippingBehavior))
    catch |err| return
  ;
  defer pointClipStr.deinit();

  _ = std.c.printf(
    \\ ------ vk 1.1 features

    \\   deviceUUID: TODO
    \\   driverUUID: TODO
    \\   deviceLUID: TODO
    \\   deviceNodeMask: %u
    \\   deviceLUIDValid: %u
    \\   subgroupSize: %u
    \\   subgroupSupportedStages: TODO
    \\   subgroupSupportedOperations: TODO
    \\   subgroupQuadOperationsInAllStages: %u
    \\   pointClippingBehavior: %s
    \\   maxMultiviewViewCount: %u
    \\   maxMultiviewInstanceIndex: %u
    \\   protectedNoFault: %u
    \\   maxPerSetDescriptors: %u
    \\   maxMemoryAllocationSize: %lu
    \\
  // , deviceUUID: [UUID_SIZE]u8,
  // , driverUUID: [UUID_SIZE]u8,
  // , deviceLUID: [LUID_SIZE]u8,
  , properties.deviceNodeMask
  , properties.deviceLuidValid
  , properties.subgroupSize
  // , subgroupSupportedStages: ShaderStageFlags align(4),
  // , subgroupSupportedOperations: SubgroupFeatureFlags align(4),
  , properties.subgroupQuadOperationsInAllStages
  , pointClipStr.span().ptr
  , properties.maxMultiviewViewCount
  , properties.maxMultiviewInstanceIndex
  , properties.protectedNoFault
  , properties.maxPerSetDescriptors
  , properties.maxMemoryAllocationSize
  );
}

pub fn PhysicalDevice12(
  properties : vk.PhysicalDeviceVulkan12Properties
) void {
  var driverId =
    std
      .ArrayListSentineled(u8, 0)
      .init(std.testing.allocator, @tagName(properties.driverId))
    catch |err| return
  ;
  defer driverId.deinit();

  var denormBehaviorIndependence =
    std
      .ArrayListSentineled(u8, 0)
      .init(
        std.testing.allocator
      , @tagName(properties.denormBehaviorIndependence)
      )
    catch |err| return
  ;
  defer denormBehaviorIndependence.deinit();

  var roundingModeIndependence =
    std
      .ArrayListSentineled(u8, 0)
      .init(
        std.testing.allocator
      , @tagName(properties.roundingModeIndependence)
      )
    catch |err| return
  ;
  defer roundingModeIndependence.deinit();

  _ = std.c.printf(
    \\ ------ vk 1.2 features
    \\   driverID: %s
    \\   driverName: %s
    \\   driverInfo: %s
    \\   conformanceVersion: %u.%u.%u.%u
    \\   denormBehaviorIndependence: %s
    \\   roundingModeIndependence: %s
    \\   shaderSignedZeroInfNanPreserveFloat16: %u
    \\   shaderSignedZeroInfNanPreserveFloat32: %u
    \\   shaderSignedZeroInfNanPreserveFloat64: %u
    \\   shaderDenormPreserveFloat16: %u
    \\   shaderDenormPreserveFloat32: %u
    \\   shaderDenormPreserveFloat64: %u
    \\   shaderDenormFlushToZeroFloat16: %u
    \\   shaderDenormFlushToZeroFloat32: %u
    \\   shaderDenormFlushToZeroFloat64: %u
    \\   shaderRoundingModeRTEFloat16: %u
    \\   shaderRoundingModeRTEFloat32: %u
    \\   shaderRoundingModeRTEFloat64: %u
    \\   shaderRoundingModeRTZFloat16: %u
    \\   shaderRoundingModeRTZFloat32: %u
    \\   shaderRoundingModeRTZFloat64: %u
    \\   maxUpdateAfterBindDescriptorsInAllPools: %u
    \\   shaderUniformBufferArrayNonUniformIndexingNative: %u
    \\   shaderSampledImageArrayNonUniformIndexingNative: %u
    \\   shaderStorageBufferArrayNonUniformIndexingNative: %u
    \\   shaderStorageImageArrayNonUniformIndexingNative: %u
    \\   shaderInputAttachmentArrayNonUniformIndexingNative: %u
    \\   robustBufferAccessUpdateAfterBind: %u
    \\   quadDivergentImplicitLod: %u
    \\   maxPerStageDescriptorUpdateAfterBindSamplers: %u
    \\   maxPerStageDescriptorUpdateAfterBindUniformBuffers: %u
    \\   maxPerStageDescriptorUpdateAfterBindStorageBuffers: %u
    \\   maxPerStageDescriptorUpdateAfterBindSampledImages: %u
    \\   maxPerStageDescriptorUpdateAfterBindStorageImages: %u
    \\   maxPerStageDescriptorUpdateAfterBindInputAttachments: %u
    \\   maxPerStageUpdateAfterBindResources: %u
    \\   maxDescriptorSetUpdateAfterBindSamplers: %u
    \\   maxDescriptorSetUpdateAfterBindUniformBuffers: %u
    \\   maxDescriptorSetUpdateAfterBindUniformBuffersDynamic: %u
    \\   maxDescriptorSetUpdateAfterBindStorageBuffers: %u
    \\   maxDescriptorSetUpdateAfterBindStorageBuffersDynamic: %u
    \\   maxDescriptorSetUpdateAfterBindSampledImages: %u
    \\   maxDescriptorSetUpdateAfterBindStorageImages: %u
    \\   maxDescriptorSetUpdateAfterBindInputAttachments: %u
    \\   supportedDepthResolveModes: TODO
    \\   supportedStencilResolveModes: TODO
    \\   independentResolveNone: %u
    \\   independentResolve: %u
    \\   filterMinmaxSingleComponentFormats: %u
    \\   filterMinmaxImageComponentMapping: %u
    \\   maxTimelineSemaphoreValueDifference: %lu
    \\   framebufferIntegerColorSampleCounts: TODO
    \\
  , &driverId.list.items[0]
  , &properties.driverName[0]
  , &properties.driverInfo[0]
  , properties.conformanceVersion.major
  , properties.conformanceVersion.minor
  , properties.conformanceVersion.subminor
  , properties.conformanceVersion.patch
  , &denormBehaviorIndependence.list.items[0]
  , &roundingModeIndependence.list.items[0]
  , properties.shaderSignedZeroInfNanPreserveFloat16
  , properties.shaderSignedZeroInfNanPreserveFloat32
  , properties.shaderSignedZeroInfNanPreserveFloat64
  , properties.shaderDenormPreserveFloat16
  , properties.shaderDenormPreserveFloat32
  , properties.shaderDenormPreserveFloat64
  , properties.shaderDenormFlushToZeroFloat16
  , properties.shaderDenormFlushToZeroFloat32
  , properties.shaderDenormFlushToZeroFloat64
  , properties.shaderRoundingModeRteFloat16
  , properties.shaderRoundingModeRteFloat32
  , properties.shaderRoundingModeRteFloat64
  , properties.shaderRoundingModeRtzFloat16
  , properties.shaderRoundingModeRtzFloat32
  , properties.shaderRoundingModeRtzFloat64
  , properties.maxUpdateAfterBindDescriptorsInAllPools
  , properties.shaderUniformBufferArrayNonUniformIndexingNative
  , properties.shaderSampledImageArrayNonUniformIndexingNative
  , properties.shaderStorageBufferArrayNonUniformIndexingNative
  , properties.shaderStorageImageArrayNonUniformIndexingNative
  , properties.shaderInputAttachmentArrayNonUniformIndexingNative
  , properties.robustBufferAccessUpdateAfterBind
  , properties.quadDivergentImplicitLod
  , properties.maxPerStageDescriptorUpdateAfterBindSamplers
  , properties.maxPerStageDescriptorUpdateAfterBindUniformBuffers
  , properties.maxPerStageDescriptorUpdateAfterBindStorageBuffers
  , properties.maxPerStageDescriptorUpdateAfterBindSampledImages
  , properties.maxPerStageDescriptorUpdateAfterBindStorageImages
  , properties.maxPerStageDescriptorUpdateAfterBindInputAttachments
  , properties.maxPerStageUpdateAfterBindResources
  , properties.maxDescriptorSetUpdateAfterBindSamplers
  , properties.maxDescriptorSetUpdateAfterBindUniformBuffers
  , properties.maxDescriptorSetUpdateAfterBindUniformBuffersDynamic
  , properties.maxDescriptorSetUpdateAfterBindStorageBuffers
  , properties.maxDescriptorSetUpdateAfterBindStorageBuffersDynamic
  , properties.maxDescriptorSetUpdateAfterBindSampledImages
  , properties.maxDescriptorSetUpdateAfterBindStorageImages
  , properties.maxDescriptorSetUpdateAfterBindInputAttachments
  // , properties.supportedDepthResolveModes
  // , properties.supportedStencilResolveModes
  , properties.independentResolveNone
  , properties.independentResolve
  , properties.filterMinmaxSingleComponentFormats
  , properties.filterMinmaxImageComponentMapping
  , properties.maxTimelineSemaphoreValueDifference
  // , properties.framebufferIntegerColorSampleCounts
  );
}

pub fn PhysicalDeviceMeshShader(
  properties : vk.PhysicalDeviceMeshShaderPropertiesNV
) void {
  _ = std.c.printf(
    \\ ------ mesh shader
    \\   maxDrawMeshTasksCount: %u
    \\   maxTaskWorkGroupInvocations: %u
    \\   maxTaskWorkGroupSize: %u, %u, %u
    \\   maxTaskTotalMemorySize: %u
    \\   maxTaskOutputCount: %u
    \\   maxMeshWorkGroupInvocations: %u
    \\   maxMeshWorkGroupSize: %u, %u, %u
    \\   maxMeshTotalMemorySize: %u
    \\   maxMeshOutputVertices: %u
    \\   maxMeshOutputPrimitives: %u
    \\   maxMeshMultiviewViewCount: %u
    \\   meshOutputPerVertexGranularity: %u
    \\   meshOutputPerPrimitiveGranularity: %u
    \\
  , properties.maxDrawMeshTasksCount
  , properties.maxTaskWorkGroupInvocations
  , properties.maxTaskWorkGroupSize[0]
  , properties.maxTaskWorkGroupSize[1]
  , properties.maxTaskWorkGroupSize[2]
  , properties.maxTaskTotalMemorySize
  , properties.maxTaskOutputCount
  , properties.maxMeshWorkGroupInvocations
  , properties.maxMeshWorkGroupSize[0]
  , properties.maxMeshWorkGroupSize[1]
  , properties.maxMeshWorkGroupSize[2]
  , properties.maxMeshTotalMemorySize
  , properties.maxMeshOutputVertices
  , properties.maxMeshOutputPrimitives
  , properties.maxMeshMultiviewViewCount
  , properties.meshOutputPerVertexGranularity
  , properties.meshOutputPerPrimitiveGranularity
  );
}

pub fn PhysicalDeviceSparseProperties(
  sparseProperties : vk.PhysicalDeviceSparseProperties
) void {
  _ = std.c.printf(
    \\ ------ sparse properties
    \\   residencyStandard2DBlockShape: %u
    \\   residencyStandard2DMultisampleBlockShape: %u
    \\   residencyStandard3DBlockShape: %u
    \\   residencyAlignedMipSize: %u
    \\   residencyNonResidentStrict: %u
    \\
  , sparseProperties.residencyStandard2DBlockShape
  , sparseProperties.residencyStandard2DMultisampleBlockShape
  , sparseProperties.residencyStandard3DBlockShape
  , sparseProperties.residencyAlignedMipSize
  , sparseProperties.residencyNonResidentStrict
  );
}

pub fn QueueFamilyProperties(
  self : vk.QueueFamilyProperties, it : usize
) void {
  _ = std.c.printf(
    \\ ------ queue family properties #%lu
    \\  graphics %u
    \\  compute %u
    \\  transfer %u
    \\  sparseBinding %u
    \\  queueCount %u
    \\  timestampValidBits %u
    \\  minImageTransferGranularity %u, %u, %u
    \\
  , it
  , self.queueFlags.contains(.{.graphics_bit = true})
  , self.queueFlags.contains(.{.compute_bit = true})
  , self.queueFlags.contains(.{.transfer_bit = true})
  , self.queueFlags.contains(.{.sparse_binding_bit = true})
  , self.queueCount
  , self.timestampValidBits
  , self.minImageTransferGranularity.width
  , self.minImageTransferGranularity.height
  , self.minImageTransferGranularity.depth
  );
}

pub fn PhysicalDeviceLimits(
  limits : vk.PhysicalDeviceLimits
) void {
  _ = std.c.printf(
    \\ ------ device limits
    \\   maxImageDimension1D: %u
    \\   maxImageDimension2D: %u
    \\   maxImageDimension3D: %u
    \\   maxImageDimensionCube: %u
    \\   maxImageArrayLayers: %u
    \\   maxTexelBufferElements: %u
    \\   maxUniformBufferRange: %u
    \\   maxStorageBufferRange: %u
    \\   maxPushConstantsSize: %u
    \\   maxMemoryAllocationCount: %u
    \\   maxSamplerAllocationCount: %u
    \\   bufferImageGranularity: %lu
    \\   sparseAddressSpaceSize: %lu
    \\   maxBoundDescriptorSets: %u
    \\   maxPerStageDescriptorSamplers: %u
    \\   maxPerStageDescriptorUniformBuffers: %u
    \\   maxPerStageDescriptorStorageBuffers: %u
    \\   maxPerStageDescriptorSampledImages: %u
    \\   maxPerStageDescriptorStorageImages: %u
    \\   maxPerStageDescriptorInputAttachments: %u
    \\   maxPerStageResources: %u
    \\   maxDescriptorSetSamplers: %u
    \\   maxDescriptorSetUniformBuffers: %u
    \\   maxDescriptorSetUniformBuffersDynamic: %u
    \\   maxDescriptorSetStorageBuffers: %u
    \\   maxDescriptorSetStorageBuffersDynamic: %u
    \\   maxDescriptorSetSampledImages: %u
    \\   maxDescriptorSetStorageImages: %u
    \\   maxDescriptorSetInputAttachments: %u
    \\   maxVertexInputAttributes: %u
    \\   maxVertexInputBindings: %u
    \\   maxVertexInputAttributeOffset: %u
    \\   maxVertexInputBindingStride: %u
    \\   maxVertexOutputComponents %u
    \\   maxTessellationGenerationLevel %u
    \\   maxTessellationPatchSize %u
    \\   maxTessellationControlPerVertexInputComponents %u
    \\   maxTessellationControlPerVertexOutputComponents %u
    \\   maxTessellationControlPerPatchOutputComponents %u
    \\   maxTessellationControlTotalOutputComponents %u
    \\   maxTessellationEvaluationInputComponents %u
    \\   maxTessellationEvaluationOutputComponents %u
    \\   maxGeometryShaderInvocations %u
    \\   maxGeometryInputComponents %u
    \\   maxGeometryOutputComponents %u
    \\   maxGeometryOutputVertices %u
    \\   maxGeometryTotalOutputComponents %u
    \\   maxFragmentInputComponents %u
    \\   maxFragmentOutputAttachments %u
    \\   maxFragmentDualSrcAttachments %u
    \\   maxFragmentCombinedOutputResources %u
    \\   maxComputeSharedMemorySize %u
    \\   maxComputeWorkGroupCount %u, %u, %u
    \\   maxComputeWorkGroupInvocations %u
    \\   maxComputeWorkGroupSize %u, %u, %u
    \\   subPixelPrecisionBits %u
    \\   subTexelPrecisionBits %u
    \\   mipmapPrecisionBits %u
    \\   maxDrawIndexedIndexValue %u
    \\   maxDrawIndirectCount %u
    \\   maxSamplerLodBias %u
    \\   maxSamplerAnisotropy %u
    \\   maxViewports %u
    \\   maxViewportDimensions %u, %u
    \\   viewportBoundsRange %.2f, %.2f
    \\   viewportSubPixelBits %u
    \\   minMemoryMapAlignment %lu
    \\   minTexelBufferOffsetAlignment %lu
    \\   minUniformBufferOffsetAlignment %lu
    \\   minStorageBufferOffsetAlignment %lu
    \\   minTexelOffset %d
    \\   maxTexelOffset %u
    \\   minTexelGatherOffset %d
    \\   maxTexelGatherOffset %u
    \\   minInterpolationOffset %f
    \\   maxInterpolationOffset %f
    \\   subPixelInterpolationOffsetBits %u
    \\   maxFramebufferWidth %u
    \\   maxFramebufferHeight %u
    \\   maxFramebufferLayers %u
    \\   framebufferColorSampleCounts TODO
    \\   framebufferDepthSampleCounts TODO
    \\   framebufferStencilSampleCounts TODO
    \\   framebufferNoAttachmentsSampleCounts TODO
    \\   maxColorAttachments %u
    \\   sampledImageColorSampleCounts TODO
    \\   sampledImageIntegerSampleCounts TODO
    \\   sampledImageDepthSampleCounts TODO
    \\   sampledImageStencilSampleCounts TODO
    \\   storageImageSampleCounts %u
    \\   maxSampleMaskWords %u
    \\   timestampComputeAndGraphics %u
    \\   timestampPeriod %f
    \\   maxClipDistances %u
    \\   maxCullDistances %u
    \\   maxCombinedClipAndCullDistances %u
    \\   discreteQueuePriorities %u
    \\   pointSizeRange %f, %f
    \\   lineWidthRange %f, %f
    \\   pointSizeGranularity %f
    \\   lineWidthGranularity %f
    \\   strictLines %d
    \\   standardSampleLocations %d
    \\   optimalBufferCopyOffsetAlignment %lu
    \\   optimalBufferCopyRowPitchAlignment %lu
    \\   nonCoherentAtomSize %lu
    \\
  , limits.maxImageDimension1D
  , limits.maxImageDimension2D
  , limits.maxImageDimension3D
  , limits.maxImageDimensionCube
  , limits.maxImageArrayLayers
  , limits.maxTexelBufferElements
  , limits.maxUniformBufferRange
  , limits.maxStorageBufferRange
  , limits.maxPushConstantsSize
  , limits.maxMemoryAllocationCount
  , limits.maxSamplerAllocationCount
  , limits.bufferImageGranularity
  , limits.sparseAddressSpaceSize
  , limits.maxBoundDescriptorSets
  , limits.maxPerStageDescriptorSamplers
  , limits.maxPerStageDescriptorUniformBuffers
  , limits.maxPerStageDescriptorStorageBuffers
  , limits.maxPerStageDescriptorSampledImages
  , limits.maxPerStageDescriptorStorageImages
  , limits.maxPerStageDescriptorInputAttachments
  , limits.maxPerStageResources
  , limits.maxDescriptorSetSamplers
  , limits.maxDescriptorSetUniformBuffers
  , limits.maxDescriptorSetUniformBuffersDynamic
  , limits.maxDescriptorSetStorageBuffers
  , limits.maxDescriptorSetStorageBuffersDynamic
  , limits.maxDescriptorSetSampledImages
  , limits.maxDescriptorSetStorageImages
  , limits.maxDescriptorSetInputAttachments
  , limits.maxVertexInputAttributes
  , limits.maxVertexInputBindings
  , limits.maxVertexInputAttributeOffset
  , limits.maxVertexInputBindingStride
  , limits.maxVertexOutputComponents
  , limits.maxTessellationGenerationLevel
  , limits.maxTessellationPatchSize
  , limits.maxTessellationControlPerVertexInputComponents
  , limits.maxTessellationControlPerVertexOutputComponents
  , limits.maxTessellationControlPerPatchOutputComponents
  , limits.maxTessellationControlTotalOutputComponents
  , limits.maxTessellationEvaluationInputComponents
  , limits.maxTessellationEvaluationOutputComponents
  , limits.maxGeometryShaderInvocations
  , limits.maxGeometryInputComponents
  , limits.maxGeometryOutputComponents
  , limits.maxGeometryOutputVertices
  , limits.maxGeometryTotalOutputComponents
  , limits.maxFragmentInputComponents
  , limits.maxFragmentOutputAttachments
  , limits.maxFragmentDualSrcAttachments
  , limits.maxFragmentCombinedOutputResources
  , limits.maxComputeSharedMemorySize
  , limits.maxComputeWorkGroupCount[0]
  , limits.maxComputeWorkGroupCount[1]
  , limits.maxComputeWorkGroupCount[2]
  , limits.maxComputeWorkGroupInvocations
  , limits.maxComputeWorkGroupSize[0]
  , limits.maxComputeWorkGroupSize[1]
  , limits.maxComputeWorkGroupSize[2]
  , limits.subPixelPrecisionBits
  , limits.subTexelPrecisionBits
  , limits.mipmapPrecisionBits
  , limits.maxDrawIndexedIndexValue
  , limits.maxDrawIndirectCount
  , limits.maxSamplerLodBias
  , limits.maxSamplerAnisotropy
  , limits.maxViewports
  , limits.maxViewportDimensions[0]
  , limits.maxViewportDimensions[1]
  , limits.viewportBoundsRange[0]
  , limits.viewportBoundsRange[1]
  , limits.viewportSubPixelBits
  , limits.minMemoryMapAlignment
  , limits.minTexelBufferOffsetAlignment
  , limits.minUniformBufferOffsetAlignment
  , limits.minStorageBufferOffsetAlignment
  , limits.minTexelOffset
  , limits.maxTexelOffset
  , limits.minTexelGatherOffset
  , limits.maxTexelGatherOffset
  , limits.minInterpolationOffset
  , limits.maxInterpolationOffset
  , limits.subPixelInterpolationOffsetBits
  , limits.maxFramebufferWidth
  , limits.maxFramebufferHeight
  , limits.maxFramebufferLayers
  , limits.maxColorAttachments
  , limits.maxSampleMaskWords
  , limits.timestampComputeAndGraphics
  , limits.timestampPeriod
  , limits.maxClipDistances
  , limits.maxCullDistances
  , limits.maxCombinedClipAndCullDistances
  , limits.discreteQueuePriorities
  , limits.pointSizeRange[0]
  , limits.pointSizeRange[1]
  , limits.lineWidthRange[0]
  , limits.lineWidthRange[1]
  , limits.pointSizeGranularity
  , limits.lineWidthGranularity
  , limits.strictLines
  , limits.standardSampleLocations
  , limits.optimalBufferCopyOffsetAlignment
  , limits.optimalBufferCopyRowPitchAlignment
  , limits.nonCoherentAtomSize
  );
}
