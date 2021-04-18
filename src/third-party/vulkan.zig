//
// Copyright (c) 2015-2020 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0 OR MIT
//

// This file is generated from the Khronos Vulkan XML API registry

const std = @import("std");
const builtin = @import("builtin");
const root = @import("root");
pub const vulkan_call_conv: builtin.CallingConvention = if (builtin.os.tag == .windows and builtin.os.arch == .i386)
    .Stdcall
else if (builtin.abi == .android and (builtin.cpu.arch.isARM() or builtin.cpu.arch.isThumb()) and builtin.Target.arm.featureSetHas(builtin.cpu.features, .has_v7) and builtin.cpu.arch.ptrBitWidth() == 32)
    // On Android 32-bit ARM targets, Vulkan functions use the "hardfloat"
    // calling convention, i.e. float parameters are passed in registers. This
    // is true even if the rest of the application passes floats on the stack,
    // as it does by default when compiling for the armeabi-v7a NDK ABI.
    .AAPCSVFP
else
    .C;
pub fn FlagsMixin(comptime FlagsType: type) type {
    return struct {
        pub const IntType = Flags;
        pub fn toInt(self: FlagsType) IntType {
            return @bitCast(IntType, self);
        }
        pub fn fromInt(flags: IntType) FlagsType {
            return @bitCast(FlagsType, flags);
        }
        pub fn merge(lhs: FlagsType, rhs: FlagsType) FlagsType {
            return fromInt(toInt(lhs) | toInt(rhs));
        }
        pub fn intersect(lhs: FlagsType, rhs: FlagsType) FlagsType {
            return fromInt(toInt(lhs) & toInt(rhs));
        }
        pub fn complement(self: FlagsType) FlagsType {
            return fromInt(~toInt(lhs));
        }
        pub fn subtract(lhs: FlagsType, rhs: FlagsType) FlagsType {
            return fromInt(toInt(lhs) & toInt(rhs.complement()));
        }
        pub fn contains(lhs: FlagsType, rhs: FlagsType) bool {
            return toInt(intersect(lhs, rhs)) == toInt(rhs);
        }
    };
}
pub fn makeVersion(major: u10, minor: u10, patch: u12) u32 {
    return (@as(u32, major) << 22) | (@as(u32, minor) << 12) | patch;
}
pub fn versionMajor(version: u32) u10 {
    return @truncate(u10, version >> 22);
}
pub fn versionMinor(version: u32) u10 {
    return @truncate(u10, version >> 12);
}
pub fn versionPatch(version: u32) u12 {
    return @truncate(u12, version);
}
pub const MAX_PHYSICAL_DEVICE_NAME_SIZE = 256;
pub const UUID_SIZE = 16;
pub const LUID_SIZE = 8;
pub const LUID_SIZE_KHR = LUID_SIZE;
pub const MAX_EXTENSION_NAME_SIZE = 256;
pub const MAX_DESCRIPTION_SIZE = 256;
pub const MAX_MEMORY_TYPES = 32;
pub const MAX_MEMORY_HEAPS = 16;
pub const LOD_CLAMP_NONE = @as(f32, 1000.0);
pub const REMAINING_MIP_LEVELS = ~@as(u32, 0);
pub const REMAINING_ARRAY_LAYERS = ~@as(u32, 0);
pub const WHOLE_SIZE = ~@as(u64, 0);
pub const ATTACHMENT_UNUSED = ~@as(u32, 0);
pub const TRUE = 1;
pub const FALSE = 0;
pub const QUEUE_FAMILY_IGNORED = ~@as(u32, 0);
pub const QUEUE_FAMILY_EXTERNAL = ~@as(u32, 0) - 1;
pub const QUEUE_FAMILY_EXTERNAL_KHR = QUEUE_FAMILY_EXTERNAL;
pub const QUEUE_FAMILY_FOREIGN_EXT = ~@as(u32, 0) - 2;
pub const SUBPASS_EXTERNAL = ~@as(u32, 0);
pub const MAX_DEVICE_GROUP_SIZE = 32;
pub const MAX_DEVICE_GROUP_SIZE_KHR = MAX_DEVICE_GROUP_SIZE;
pub const MAX_DRIVER_NAME_SIZE = 256;
pub const MAX_DRIVER_NAME_SIZE_KHR = MAX_DRIVER_NAME_SIZE;
pub const MAX_DRIVER_INFO_SIZE = 256;
pub const MAX_DRIVER_INFO_SIZE_KHR = MAX_DRIVER_INFO_SIZE;
pub const SHADER_UNUSED_KHR = ~@as(u32, 0);
pub const SHADER_UNUSED_NV = SHADER_UNUSED_KHR;
pub const API_VERSION_1_0 = makeVersion(1, 0, 0);
pub const API_VERSION_1_1 = makeVersion(1, 1, 0);
pub const API_VERSION_1_2 = makeVersion(1, 2, 0);
pub const HEADER_VERSION = 163;
pub const HEADER_VERSION_COMPLETE = makeVersion(1, 2, HEADER_VERSION);
pub const Display = if (@hasDecl(root, "Display")) root.Display else opaque {};
pub const VisualID = if (@hasDecl(root, "VisualID")) root.VisualID else c_uint;
pub const Window = if (@hasDecl(root, "Window")) root.Window else c_ulong;
pub const RROutput = if (@hasDecl(root, "RROutput")) root.RROutput else c_ulong;
pub const wl_display = if (@hasDecl(root, "wl_display")) root.wl_display else opaque {};
pub const wl_surface = if (@hasDecl(root, "wl_surface")) root.wl_surface else opaque {};
pub const HINSTANCE = if (@hasDecl(root, "HINSTANCE")) root.HINSTANCE else std.os.HINSTANCE;
pub const HWND = if (@hasDecl(root, "HWND")) root.HWND else *opaque {};
pub const HMONITOR = if (@hasDecl(root, "HMONITOR")) root.HMONITOR else *opaque {};
pub const HANDLE = if (@hasDecl(root, "HANDLE")) root.HANDLE else std.os.HANDLE;
pub const SECURITY_ATTRIBUTES = if (@hasDecl(root, "SECURITY_ATTRIBUTES")) root.SECURITY_ATTRIBUTES else std.os.SECURITY_ATTRIBUTES;
pub const DWORD = if (@hasDecl(root, "DWORD")) root.DWORD else std.os.DWORD;
pub const LPCWSTR = if (@hasDecl(root, "LPCWSTR")) root.LPCWSTR else std.os.LPCWSTR;
pub const xcb_connection_t = if (@hasDecl(root, "xcb_connection_t")) root.xcb_connection_t else opaque {};
pub const xcb_visualid_t = if (@hasDecl(root, "xcb_visualid_t")) root.xcb_visualid_t else u32;
pub const xcb_window_t = if (@hasDecl(root, "xcb_window_t")) root.xcb_window_t else u32;
pub const IDirectFB = if (@hasDecl(root, "IDirectFB")) root.IDirectFB else @compileError("Missing type definition of 'IDirectFB'");
pub const IDirectFBSurface = if (@hasDecl(root, "IDirectFBSurface")) root.IDirectFBSurface else @compileError("Missing type definition of 'IDirectFBSurface'");
pub const zx_handle_t = if (@hasDecl(root, "zx_handle_t")) root.zx_handle_t else u32;
pub const GgpStreamDescriptor = if (@hasDecl(root, "GgpStreamDescriptor")) root.GgpStreamDescriptor else @compileError("Missing type definition of 'GgpStreamDescriptor'");
pub const GgpFrameToken = if (@hasDecl(root, "GgpFrameToken")) root.GgpFrameToken else @compileError("Missing type definition of 'GgpFrameToken'");
pub const ANativeWindow = opaque {};
pub const AHardwareBuffer = opaque {};
pub const CAMetalLayer = opaque {};
pub const SampleMask = u32;
pub const Bool32 = u32;
pub const Flags = u32;
pub const DeviceSize = u64;
pub const DeviceAddress = u64;
pub const QueryPoolCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(QueryPoolCreateFlags);
};
pub const PipelineLayoutCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineLayoutCreateFlags);
};
pub const PipelineDepthStencilStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineDepthStencilStateCreateFlags);
};
pub const PipelineDynamicStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineDynamicStateCreateFlags);
};
pub const PipelineColorBlendStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineColorBlendStateCreateFlags);
};
pub const PipelineMultisampleStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineMultisampleStateCreateFlags);
};
pub const PipelineRasterizationStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineRasterizationStateCreateFlags);
};
pub const PipelineViewportStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineViewportStateCreateFlags);
};
pub const PipelineTessellationStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineTessellationStateCreateFlags);
};
pub const PipelineInputAssemblyStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineInputAssemblyStateCreateFlags);
};
pub const PipelineVertexInputStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineVertexInputStateCreateFlags);
};
pub const BufferViewCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(BufferViewCreateFlags);
};
pub const InstanceCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(InstanceCreateFlags);
};
pub const DeviceCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DeviceCreateFlags);
};
pub const SemaphoreCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(SemaphoreCreateFlags);
};
pub const EventCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(EventCreateFlags);
};
pub const MemoryMapFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(MemoryMapFlags);
};
pub const DescriptorPoolResetFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DescriptorPoolResetFlags);
};
pub const GeometryFlagsNV = GeometryFlagsKHR;
pub const GeometryInstanceFlagsNV = GeometryInstanceFlagsKHR;
pub const BuildAccelerationStructureFlagsNV = BuildAccelerationStructureFlagsKHR;
pub const DescriptorUpdateTemplateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DescriptorUpdateTemplateCreateFlags);
};
pub const DescriptorUpdateTemplateCreateFlagsKHR = DescriptorUpdateTemplateCreateFlags;
pub const SemaphoreWaitFlagsKHR = SemaphoreWaitFlags;
pub const DisplayModeCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DisplayModeCreateFlagsKHR);
};
pub const DisplaySurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DisplaySurfaceCreateFlagsKHR);
};
pub const AndroidSurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(AndroidSurfaceCreateFlagsKHR);
};
pub const ViSurfaceCreateFlagsNN = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ViSurfaceCreateFlagsNN);
};
pub const WaylandSurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(WaylandSurfaceCreateFlagsKHR);
};
pub const Win32SurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(Win32SurfaceCreateFlagsKHR);
};
pub const XlibSurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(XlibSurfaceCreateFlagsKHR);
};
pub const XcbSurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(XcbSurfaceCreateFlagsKHR);
};
pub const DirectFBSurfaceCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DirectFBSurfaceCreateFlagsEXT);
};
pub const IOSSurfaceCreateFlagsMVK = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(IOSSurfaceCreateFlagsMVK);
};
pub const MacOSSurfaceCreateFlagsMVK = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(MacOSSurfaceCreateFlagsMVK);
};
pub const MetalSurfaceCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(MetalSurfaceCreateFlagsEXT);
};
pub const ImagePipeSurfaceCreateFlagsFUCHSIA = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ImagePipeSurfaceCreateFlagsFUCHSIA);
};
pub const StreamDescriptorSurfaceCreateFlagsGGP = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(StreamDescriptorSurfaceCreateFlagsGGP);
};
pub const HeadlessSurfaceCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(HeadlessSurfaceCreateFlagsEXT);
};
pub const PeerMemoryFeatureFlagsKHR = PeerMemoryFeatureFlags;
pub const MemoryAllocateFlagsKHR = MemoryAllocateFlags;
pub const CommandPoolTrimFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(CommandPoolTrimFlags);
};
pub const CommandPoolTrimFlagsKHR = CommandPoolTrimFlags;
pub const ExternalMemoryHandleTypeFlagsKHR = ExternalMemoryHandleTypeFlags;
pub const ExternalMemoryFeatureFlagsKHR = ExternalMemoryFeatureFlags;
pub const ExternalSemaphoreHandleTypeFlagsKHR = ExternalSemaphoreHandleTypeFlags;
pub const ExternalSemaphoreFeatureFlagsKHR = ExternalSemaphoreFeatureFlags;
pub const SemaphoreImportFlagsKHR = SemaphoreImportFlags;
pub const ExternalFenceHandleTypeFlagsKHR = ExternalFenceHandleTypeFlags;
pub const ExternalFenceFeatureFlagsKHR = ExternalFenceFeatureFlags;
pub const FenceImportFlagsKHR = FenceImportFlags;
pub const PipelineViewportSwizzleStateCreateFlagsNV = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineViewportSwizzleStateCreateFlagsNV);
};
pub const PipelineDiscardRectangleStateCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineDiscardRectangleStateCreateFlagsEXT);
};
pub const PipelineCoverageToColorStateCreateFlagsNV = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineCoverageToColorStateCreateFlagsNV);
};
pub const PipelineCoverageModulationStateCreateFlagsNV = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineCoverageModulationStateCreateFlagsNV);
};
pub const PipelineCoverageReductionStateCreateFlagsNV = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineCoverageReductionStateCreateFlagsNV);
};
pub const ValidationCacheCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ValidationCacheCreateFlagsEXT);
};
pub const DebugUtilsMessengerCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DebugUtilsMessengerCreateFlagsEXT);
};
pub const DebugUtilsMessengerCallbackDataFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DebugUtilsMessengerCallbackDataFlagsEXT);
};
pub const DeviceMemoryReportFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DeviceMemoryReportFlagsEXT);
};
pub const PipelineRasterizationConservativeStateCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineRasterizationConservativeStateCreateFlagsEXT);
};
pub const DescriptorBindingFlagsEXT = DescriptorBindingFlags;
pub const ResolveModeFlagsKHR = ResolveModeFlags;
pub const PipelineRasterizationStateStreamCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineRasterizationStateStreamCreateFlagsEXT);
};
pub const PipelineRasterizationDepthClipStateCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineRasterizationDepthClipStateCreateFlagsEXT);
};
pub const Instance = extern enum(usize) { null_handle = 0, _ };
pub const PhysicalDevice = extern enum(usize) { null_handle = 0, _ };
pub const Device = extern enum(usize) { null_handle = 0, _ };
pub const Queue = extern enum(usize) { null_handle = 0, _ };
pub const CommandBuffer = extern enum(usize) { null_handle = 0, _ };
pub const DeviceMemory = extern enum(u64) { null_handle = 0, _ };
pub const CommandPool = extern enum(u64) { null_handle = 0, _ };
pub const Buffer = extern enum(u64) { null_handle = 0, _ };
pub const BufferView = extern enum(u64) { null_handle = 0, _ };
pub const Image = extern enum(u64) { null_handle = 0, _ };
pub const ImageView = extern enum(u64) { null_handle = 0, _ };
pub const ShaderModule = extern enum(u64) { null_handle = 0, _ };
pub const Pipeline = extern enum(u64) { null_handle = 0, _ };
pub const PipelineLayout = extern enum(u64) { null_handle = 0, _ };
pub const Sampler = extern enum(u64) { null_handle = 0, _ };
pub const DescriptorSet = extern enum(u64) { null_handle = 0, _ };
pub const DescriptorSetLayout = extern enum(u64) { null_handle = 0, _ };
pub const DescriptorPool = extern enum(u64) { null_handle = 0, _ };
pub const Fence = extern enum(u64) { null_handle = 0, _ };
pub const Semaphore = extern enum(u64) { null_handle = 0, _ };
pub const Event = extern enum(u64) { null_handle = 0, _ };
pub const QueryPool = extern enum(u64) { null_handle = 0, _ };
pub const Framebuffer = extern enum(u64) { null_handle = 0, _ };
pub const RenderPass = extern enum(u64) { null_handle = 0, _ };
pub const PipelineCache = extern enum(u64) { null_handle = 0, _ };
pub const IndirectCommandsLayoutNV = extern enum(u64) { null_handle = 0, _ };
pub const DescriptorUpdateTemplate = extern enum(u64) { null_handle = 0, _ };
pub const DescriptorUpdateTemplateKHR = DescriptorUpdateTemplate;
pub const SamplerYcbcrConversion = extern enum(u64) { null_handle = 0, _ };
pub const SamplerYcbcrConversionKHR = SamplerYcbcrConversion;
pub const ValidationCacheEXT = extern enum(u64) { null_handle = 0, _ };
pub const AccelerationStructureKHR = extern enum(u64) { null_handle = 0, _ };
pub const AccelerationStructureNV = extern enum(u64) { null_handle = 0, _ };
pub const PerformanceConfigurationINTEL = extern enum(u64) { null_handle = 0, _ };
pub const DeferredOperationKHR = extern enum(u64) { null_handle = 0, _ };
pub const PrivateDataSlotEXT = extern enum(u64) { null_handle = 0, _ };
pub const DisplayKHR = extern enum(u64) { null_handle = 0, _ };
pub const DisplayModeKHR = extern enum(u64) { null_handle = 0, _ };
pub const SurfaceKHR = extern enum(u64) { null_handle = 0, _ };
pub const SwapchainKHR = extern enum(u64) { null_handle = 0, _ };
pub const DebugReportCallbackEXT = extern enum(u64) { null_handle = 0, _ };
pub const DebugUtilsMessengerEXT = extern enum(u64) { null_handle = 0, _ };
pub const DescriptorUpdateTemplateTypeKHR = DescriptorUpdateTemplateType;
pub const PointClippingBehaviorKHR = PointClippingBehavior;
pub const SemaphoreTypeKHR = SemaphoreType;
pub const CopyAccelerationStructureModeNV = CopyAccelerationStructureModeKHR;
pub const AccelerationStructureTypeNV = AccelerationStructureTypeKHR;
pub const GeometryTypeNV = GeometryTypeKHR;
pub const RayTracingShaderGroupTypeNV = RayTracingShaderGroupTypeKHR;
pub const TessellationDomainOriginKHR = TessellationDomainOrigin;
pub const SamplerYcbcrModelConversionKHR = SamplerYcbcrModelConversion;
pub const SamplerYcbcrRangeKHR = SamplerYcbcrRange;
pub const ChromaLocationKHR = ChromaLocation;
pub const SamplerReductionModeEXT = SamplerReductionMode;
pub const ShaderFloatControlsIndependenceKHR = ShaderFloatControlsIndependence;
pub const DriverIdKHR = DriverId;
pub const PfnInternalAllocationNotification = ?fn (
    p_user_data: *c_void,
    size: usize,
    allocation_type: InternalAllocationType,
    allocation_scope: SystemAllocationScope,
) callconv(vulkan_call_conv) void;
pub const PfnInternalFreeNotification = ?fn (
    p_user_data: *c_void,
    size: usize,
    allocation_type: InternalAllocationType,
    allocation_scope: SystemAllocationScope,
) callconv(vulkan_call_conv) void;
pub const PfnReallocationFunction = ?fn (
    p_user_data: *c_void,
    p_original: *c_void,
    size: usize,
    alignment: usize,
    allocation_scope: SystemAllocationScope,
) callconv(vulkan_call_conv) *c_void;
pub const PfnAllocationFunction = ?fn (
    p_user_data: *c_void,
    size: usize,
    alignment: usize,
    allocation_scope: SystemAllocationScope,
) callconv(vulkan_call_conv) *c_void;
pub const PfnFreeFunction = ?fn (
    p_user_data: *c_void,
    p_memory: *c_void,
) callconv(vulkan_call_conv) void;
pub const PfnVoidFunction = ?fn () callconv(vulkan_call_conv) void;
pub const PfnDebugReportCallbackEXT = ?fn (
    flags: DebugReportFlagsEXT.IntType,
    object_type: DebugReportObjectTypeEXT,
    object: u64,
    location: usize,
    message_code: i32,
    p_layer_prefix: *const u8,
    p_message: *const u8,
    p_user_data: *c_void,
) callconv(vulkan_call_conv) Bool32;
pub const PfnDebugUtilsMessengerCallbackEXT = ?fn (
    message_severity: DebugUtilsMessageSeverityFlagsEXT.IntType,
    message_types: DebugUtilsMessageTypeFlagsEXT.IntType,
    p_callback_data: *const DebugUtilsMessengerCallbackDataEXT,
    p_user_data: *c_void,
) callconv(vulkan_call_conv) Bool32;
pub const PfnDeviceMemoryReportCallbackEXT = ?fn (
    p_callback_data: *const DeviceMemoryReportCallbackDataEXT,
    p_user_data: *c_void,
) callconv(vulkan_call_conv) void;
pub const BaseOutStructure = extern struct {
    sType: StructureType,
    pNext: ?*BaseOutStructure = null,
};
pub const BaseInStructure = extern struct {
    sType: StructureType,
    pNext: ?*const BaseInStructure = null,
};
pub const Offset2D = extern struct {
    x: i32,
    y: i32,
};
pub const Offset3D = extern struct {
    x: i32,
    y: i32,
    z: i32,
};
pub const Extent2D = extern struct {
    width: u32,
    height: u32,
};
pub const Extent3D = extern struct {
    width: u32,
    height: u32,
    depth: u32,
};
pub const Viewport = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
    minDepth: f32,
    maxDepth: f32,
};
pub const Rect2D = extern struct {
    offset: Offset2D,
    extent: Extent2D,
};
pub const ClearRect = extern struct {
    rect: Rect2D,
    baseArrayLayer: u32,
    layerCount: u32,
};
pub const ComponentMapping = extern struct {
    r: ComponentSwizzle,
    g: ComponentSwizzle,
    b: ComponentSwizzle,
    a: ComponentSwizzle,
};
pub const PhysicalDeviceProperties = extern struct {
    apiVersion: u32,
    driverVersion: u32,
    vendorId: u32,
    deviceId: u32,
    deviceType: PhysicalDeviceType,
    deviceName: [MAX_PHYSICAL_DEVICE_NAME_SIZE]u8,
    pipelineCacheUuid: [UUID_SIZE]u8,
    limits: PhysicalDeviceLimits,
    sparseProperties: PhysicalDeviceSparseProperties,
};
pub const ExtensionProperties = extern struct {
    extensionName: [MAX_EXTENSION_NAME_SIZE]u8,
    specVersion: u32,
};
pub const LayerProperties = extern struct {
    layerName: [MAX_EXTENSION_NAME_SIZE]u8,
    specVersion: u32,
    implementationVersion: u32,
    description: [MAX_DESCRIPTION_SIZE]u8,
};
pub const ApplicationInfo = extern struct {
    sType: StructureType = .application_info,
    pNext: ?*const c_void = null,
    pApplicationName: ?[*:0]const u8,
    applicationVersion: u32,
    pEngineName: ?[*:0]const u8,
    engineVersion: u32,
    apiVersion: u32,
};
pub const AllocationCallbacks = extern struct {
    pUserData: ?*c_void,
    pfnAllocation: PfnAllocationFunction,
    pfnReallocation: PfnReallocationFunction,
    pfnFree: PfnFreeFunction,
    pfnInternalAllocation: PfnInternalAllocationNotification,
    pfnInternalFree: PfnInternalFreeNotification,
};
pub const DeviceQueueCreateInfo = extern struct {
    sType: StructureType = .device_queue_create_info,
    pNext: ?*const c_void = null,
    flags: DeviceQueueCreateFlags,
    queueFamilyIndex: u32,
    queueCount: u32,
    pQueuePriorities: [*]const f32,
};
pub const DeviceCreateInfo = extern struct {
    sType: StructureType = .device_create_info,
    pNext: ?*const c_void = null,
    flags: DeviceCreateFlags,
    queueCreateInfoCount: u32,
    pQueueCreateInfos: [*]const DeviceQueueCreateInfo,
    enabledLayerCount: u32,
    ppEnabledLayerNames: [*]const [*:0]const u8,
    enabledExtensionCount: u32,
    ppEnabledExtensionNames: [*]const [*:0]const u8,
    pEnabledFeatures: ?*const PhysicalDeviceFeatures,
};
pub const InstanceCreateInfo = extern struct {
    sType: StructureType = .instance_create_info,
    pNext: ?*const c_void = null,
    flags: InstanceCreateFlags,
    pApplicationInfo: ?*const ApplicationInfo,
    enabledLayerCount: u32,
    ppEnabledLayerNames: [*]const [*:0]const u8,
    enabledExtensionCount: u32,
    ppEnabledExtensionNames: [*]const [*:0]const u8,
};
pub const QueueFamilyProperties = extern struct {
    queueFlags: QueueFlags,
    queueCount: u32,
    timestampValidBits: u32,
    minImageTransferGranularity: Extent3D,
};
pub const PhysicalDeviceMemoryProperties = extern struct {
    memoryTypeCount: u32,
    memoryTypes: [MAX_MEMORY_TYPES]MemoryType,
    memoryHeapCount: u32,
    memoryHeaps: [MAX_MEMORY_HEAPS]MemoryHeap,
};
pub const MemoryAllocateInfo = extern struct {
    sType: StructureType = .memory_allocate_info,
    pNext: ?*const c_void = null,
    allocationSize: DeviceSize,
    memoryTypeIndex: u32,
};
pub const MemoryRequirements = extern struct {
    size: DeviceSize,
    alignment: DeviceSize,
    memoryTypeBits: u32,
};
pub const SparseImageFormatProperties = extern struct {
    aspectMask: ImageAspectFlags,
    imageGranularity: Extent3D,
    flags: SparseImageFormatFlags,
};
pub const SparseImageMemoryRequirements = extern struct {
    formatProperties: SparseImageFormatProperties,
    imageMipTailFirstLod: u32,
    imageMipTailSize: DeviceSize,
    imageMipTailOffset: DeviceSize,
    imageMipTailStride: DeviceSize,
};
pub const MemoryType = extern struct {
    propertyFlags: MemoryPropertyFlags,
    heapIndex: u32,
};
pub const MemoryHeap = extern struct {
    size: DeviceSize,
    flags: MemoryHeapFlags,
};
pub const MappedMemoryRange = extern struct {
    sType: StructureType = .mapped_memory_range,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
    offset: DeviceSize,
    size: DeviceSize,
};
pub const FormatProperties = extern struct {
    linearTilingFeatures: FormatFeatureFlags,
    optimalTilingFeatures: FormatFeatureFlags,
    bufferFeatures: FormatFeatureFlags,
};
pub const ImageFormatProperties = extern struct {
    maxExtent: Extent3D,
    maxMipLevels: u32,
    maxArrayLayers: u32,
    sampleCounts: SampleCountFlags,
    maxResourceSize: DeviceSize,
};
pub const DescriptorBufferInfo = extern struct {
    buffer: Buffer,
    offset: DeviceSize,
    range: DeviceSize,
};
pub const DescriptorImageInfo = extern struct {
    sampler: Sampler,
    imageView: ImageView,
    imageLayout: ImageLayout,
};
pub const WriteDescriptorSet = extern struct {
    sType: StructureType = .write_descriptor_set,
    pNext: ?*const c_void = null,
    dstSet: DescriptorSet,
    dstBinding: u32,
    dstArrayElement: u32,
    descriptorCount: u32,
    descriptorType: DescriptorType,
    pImageInfo: [*]const DescriptorImageInfo,
    pBufferInfo: [*]const DescriptorBufferInfo,
    pTexelBufferView: [*]const BufferView,
};
pub const CopyDescriptorSet = extern struct {
    sType: StructureType = .copy_descriptor_set,
    pNext: ?*const c_void = null,
    srcSet: DescriptorSet,
    srcBinding: u32,
    srcArrayElement: u32,
    dstSet: DescriptorSet,
    dstBinding: u32,
    dstArrayElement: u32,
    descriptorCount: u32,
};
pub const BufferCreateInfo = extern struct {
    sType: StructureType = .buffer_create_info,
    pNext: ?*const c_void = null,
    flags: BufferCreateFlags,
    size: DeviceSize,
    usage: BufferUsageFlags,
    sharingMode: SharingMode,
    queueFamilyIndexCount: u32,
    pQueueFamilyIndices: [*]const u32,
};
pub const BufferViewCreateInfo = extern struct {
    sType: StructureType = .buffer_view_create_info,
    pNext: ?*const c_void = null,
    flags: BufferViewCreateFlags,
    buffer: Buffer,
    format: Format,
    offset: DeviceSize,
    range: DeviceSize,
};
pub const ImageSubresource = extern struct {
    aspectMask: ImageAspectFlags,
    mipLevel: u32,
    arrayLayer: u32,
};
pub const ImageSubresourceLayers = extern struct {
    aspectMask: ImageAspectFlags,
    mipLevel: u32,
    baseArrayLayer: u32,
    layerCount: u32,
};
pub const ImageSubresourceRange = extern struct {
    aspectMask: ImageAspectFlags,
    baseMipLevel: u32,
    levelCount: u32,
    baseArrayLayer: u32,
    layerCount: u32,
};
pub const MemoryBarrier = extern struct {
    sType: StructureType = .memory_barrier,
    pNext: ?*const c_void = null,
    srcAccessMask: AccessFlags,
    dstAccessMask: AccessFlags,
};
pub const BufferMemoryBarrier = extern struct {
    sType: StructureType = .buffer_memory_barrier,
    pNext: ?*const c_void = null,
    srcAccessMask: AccessFlags,
    dstAccessMask: AccessFlags,
    srcQueueFamilyIndex: u32,
    dstQueueFamilyIndex: u32,
    buffer: Buffer,
    offset: DeviceSize,
    size: DeviceSize,
};
pub const ImageMemoryBarrier = extern struct {
    sType: StructureType = .image_memory_barrier,
    pNext: ?*const c_void = null,
    srcAccessMask: AccessFlags,
    dstAccessMask: AccessFlags,
    oldLayout: ImageLayout,
    newLayout: ImageLayout,
    srcQueueFamilyIndex: u32,
    dstQueueFamilyIndex: u32,
    image: Image,
    subresourceRange: ImageSubresourceRange,
};
pub const ImageCreateInfo = extern struct {
    sType: StructureType = .image_create_info,
    pNext: ?*const c_void = null,
    flags: ImageCreateFlags,
    imageType: ImageType,
    format: Format,
    extent: Extent3D,
    mipLevels: u32,
    arrayLayers: u32,
    samples: SampleCountFlags,
    tiling: ImageTiling,
    usage: ImageUsageFlags,
    sharingMode: SharingMode,
    queueFamilyIndexCount: u32,
    pQueueFamilyIndices: [*]const u32,
    initialLayout: ImageLayout,
};
pub const SubresourceLayout = extern struct {
    offset: DeviceSize,
    size: DeviceSize,
    rowPitch: DeviceSize,
    arrayPitch: DeviceSize,
    depthPitch: DeviceSize,
};
pub const ImageViewCreateInfo = extern struct {
    sType: StructureType = .image_view_create_info,
    pNext: ?*const c_void = null,
    flags: ImageViewCreateFlags,
    image: Image,
    viewType: ImageViewType,
    format: Format,
    components: ComponentMapping,
    subresourceRange: ImageSubresourceRange,
};
pub const BufferCopy = extern struct {
    srcOffset: DeviceSize,
    dstOffset: DeviceSize,
    size: DeviceSize,
};
pub const SparseMemoryBind = extern struct {
    resourceOffset: DeviceSize,
    size: DeviceSize,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
    flags: SparseMemoryBindFlags,
};
pub const SparseImageMemoryBind = extern struct {
    subresource: ImageSubresource,
    offset: Offset3D,
    extent: Extent3D,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
    flags: SparseMemoryBindFlags,
};
pub const SparseBufferMemoryBindInfo = extern struct {
    buffer: Buffer,
    bindCount: u32,
    pBinds: [*]const SparseMemoryBind,
};
pub const SparseImageOpaqueMemoryBindInfo = extern struct {
    image: Image,
    bindCount: u32,
    pBinds: [*]const SparseMemoryBind,
};
pub const SparseImageMemoryBindInfo = extern struct {
    image: Image,
    bindCount: u32,
    pBinds: [*]const SparseImageMemoryBind,
};
pub const BindSparseInfo = extern struct {
    sType: StructureType = .bind_sparse_info,
    pNext: ?*const c_void = null,
    waitSemaphoreCount: u32,
    pWaitSemaphores: [*]const Semaphore,
    bufferBindCount: u32,
    pBufferBinds: [*]const SparseBufferMemoryBindInfo,
    imageOpaqueBindCount: u32,
    pImageOpaqueBinds: [*]const SparseImageOpaqueMemoryBindInfo,
    imageBindCount: u32,
    pImageBinds: [*]const SparseImageMemoryBindInfo,
    signalSemaphoreCount: u32,
    pSignalSemaphores: [*]const Semaphore,
};
pub const ImageCopy = extern struct {
    srcSubresource: ImageSubresourceLayers,
    srcOffset: Offset3D,
    dstSubresource: ImageSubresourceLayers,
    dstOffset: Offset3D,
    extent: Extent3D,
};
pub const ImageBlit = extern struct {
    srcSubresource: ImageSubresourceLayers,
    srcOffsets: [2]Offset3D,
    dstSubresource: ImageSubresourceLayers,
    dstOffsets: [2]Offset3D,
};
pub const BufferImageCopy = extern struct {
    bufferOffset: DeviceSize,
    bufferRowLength: u32,
    bufferImageHeight: u32,
    imageSubresource: ImageSubresourceLayers,
    imageOffset: Offset3D,
    imageExtent: Extent3D,
};
pub const ImageResolve = extern struct {
    srcSubresource: ImageSubresourceLayers,
    srcOffset: Offset3D,
    dstSubresource: ImageSubresourceLayers,
    dstOffset: Offset3D,
    extent: Extent3D,
};
pub const ShaderModuleCreateInfo = extern struct {
    sType: StructureType = .shader_module_create_info,
    pNext: ?*const c_void = null,
    flags: ShaderModuleCreateFlags,
    codeSize: usize,
    pCode: [*]const u32,
};
pub const DescriptorSetLayoutBinding = extern struct {
    binding: u32,
    descriptorType: DescriptorType,
    descriptorCount: u32,
    stageFlags: ShaderStageFlags,
    pImmutableSamplers: ?[*]const Sampler,
};
pub const DescriptorSetLayoutCreateInfo = extern struct {
    sType: StructureType = .descriptor_set_layout_create_info,
    pNext: ?*const c_void = null,
    flags: DescriptorSetLayoutCreateFlags,
    bindingCount: u32,
    pBindings: [*]const DescriptorSetLayoutBinding,
};
pub const DescriptorPoolSize = extern struct {
    type: DescriptorType,
    descriptorCount: u32,
};
pub const DescriptorPoolCreateInfo = extern struct {
    sType: StructureType = .descriptor_pool_create_info,
    pNext: ?*const c_void = null,
    flags: DescriptorPoolCreateFlags,
    maxSets: u32,
    poolSizeCount: u32,
    pPoolSizes: [*]const DescriptorPoolSize,
};
pub const DescriptorSetAllocateInfo = extern struct {
    sType: StructureType = .descriptor_set_allocate_info,
    pNext: ?*const c_void = null,
    descriptorPool: DescriptorPool,
    descriptorSetCount: u32,
    pSetLayouts: [*]const DescriptorSetLayout,
};
pub const SpecializationMapEntry = extern struct {
    constantId: u32,
    offset: u32,
    size: usize,
};
pub const SpecializationInfo = extern struct {
    mapEntryCount: u32,
    pMapEntries: [*]const SpecializationMapEntry,
    dataSize: usize,
    pData: *const c_void,
};
pub const PipelineShaderStageCreateInfo = extern struct {
    sType: StructureType = .pipeline_shader_stage_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineShaderStageCreateFlags,
    stage: ShaderStageFlags,
    module: ShaderModule,
    pName: [*:0]const u8,
    pSpecializationInfo: ?*const SpecializationInfo,
};
pub const ComputePipelineCreateInfo = extern struct {
    sType: StructureType = .compute_pipeline_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineCreateFlags,
    stage: PipelineShaderStageCreateInfo,
    layout: PipelineLayout,
    basePipelineHandle: Pipeline,
    basePipelineIndex: i32,
};
pub const VertexInputBindingDescription = extern struct {
    binding: u32,
    stride: u32,
    inputRate: VertexInputRate,
};
pub const VertexInputAttributeDescription = extern struct {
    location: u32,
    binding: u32,
    format: Format,
    offset: u32,
};
pub const PipelineVertexInputStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_vertex_input_state_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineVertexInputStateCreateFlags,
    vertexBindingDescriptionCount: u32,
    pVertexBindingDescriptions: [*]const VertexInputBindingDescription,
    vertexAttributeDescriptionCount: u32,
    pVertexAttributeDescriptions: [*]const VertexInputAttributeDescription,
};
pub const PipelineInputAssemblyStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_input_assembly_state_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineInputAssemblyStateCreateFlags,
    topology: PrimitiveTopology,
    primitiveRestartEnable: Bool32,
};
pub const PipelineTessellationStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_tessellation_state_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineTessellationStateCreateFlags,
    patchControlPoints: u32,
};
pub const PipelineViewportStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_viewport_state_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineViewportStateCreateFlags,
    viewportCount: u32,
    pViewports: ?[*]const Viewport,
    scissorCount: u32,
    pScissors: ?[*]const Rect2D,
};
pub const PipelineRasterizationStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_rasterization_state_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineRasterizationStateCreateFlags,
    depthClampEnable: Bool32,
    rasterizerDiscardEnable: Bool32,
    polygonMode: PolygonMode,
    cullMode: CullModeFlags,
    frontFace: FrontFace,
    depthBiasEnable: Bool32,
    depthBiasConstantFactor: f32,
    depthBiasClamp: f32,
    depthBiasSlopeFactor: f32,
    lineWidth: f32,
};
pub const PipelineMultisampleStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_multisample_state_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineMultisampleStateCreateFlags,
    rasterizationSamples: SampleCountFlags,
    sampleShadingEnable: Bool32,
    minSampleShading: f32,
    pSampleMask: ?[*]const SampleMask,
    alphaToCoverageEnable: Bool32,
    alphaToOneEnable: Bool32,
};
pub const PipelineColorBlendAttachmentState = extern struct {
    blendEnable: Bool32,
    srcColorBlendFactor: BlendFactor,
    dstColorBlendFactor: BlendFactor,
    colorBlendOp: BlendOp,
    srcAlphaBlendFactor: BlendFactor,
    dstAlphaBlendFactor: BlendFactor,
    alphaBlendOp: BlendOp,
    colorWriteMask: ColorComponentFlags,
};
pub const PipelineColorBlendStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_color_blend_state_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineColorBlendStateCreateFlags,
    logicOpEnable: Bool32,
    logicOp: LogicOp,
    attachmentCount: u32,
    pAttachments: [*]const PipelineColorBlendAttachmentState,
    blendConstants: [4]f32,
};
pub const PipelineDynamicStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_dynamic_state_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineDynamicStateCreateFlags,
    dynamicStateCount: u32,
    pDynamicStates: [*]const DynamicState,
};
pub const StencilOpState = extern struct {
    failOp: StencilOp,
    passOp: StencilOp,
    depthFailOp: StencilOp,
    compareOp: CompareOp,
    compareMask: u32,
    writeMask: u32,
    reference: u32,
};
pub const PipelineDepthStencilStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_depth_stencil_state_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineDepthStencilStateCreateFlags,
    depthTestEnable: Bool32,
    depthWriteEnable: Bool32,
    depthCompareOp: CompareOp,
    depthBoundsTestEnable: Bool32,
    stencilTestEnable: Bool32,
    front: StencilOpState,
    back: StencilOpState,
    minDepthBounds: f32,
    maxDepthBounds: f32,
};
pub const GraphicsPipelineCreateInfo = extern struct {
    sType: StructureType = .graphics_pipeline_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineCreateFlags,
    stageCount: u32,
    pStages: [*]const PipelineShaderStageCreateInfo,
    pVertexInputState: ?*const PipelineVertexInputStateCreateInfo,
    pInputAssemblyState: ?*const PipelineInputAssemblyStateCreateInfo,
    pTessellationState: ?*const PipelineTessellationStateCreateInfo,
    pViewportState: ?*const PipelineViewportStateCreateInfo,
    pRasterizationState: *const PipelineRasterizationStateCreateInfo,
    pMultisampleState: ?*const PipelineMultisampleStateCreateInfo,
    pDepthStencilState: ?*const PipelineDepthStencilStateCreateInfo,
    pColorBlendState: ?*const PipelineColorBlendStateCreateInfo,
    pDynamicState: ?*const PipelineDynamicStateCreateInfo,
    layout: PipelineLayout,
    renderPass: RenderPass,
    subpass: u32,
    basePipelineHandle: Pipeline,
    basePipelineIndex: i32,
};
pub const PipelineCacheCreateInfo = extern struct {
    sType: StructureType = .pipeline_cache_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineCacheCreateFlags,
    initialDataSize: usize,
    pInitialData: *const c_void,
};
pub const PushConstantRange = extern struct {
    stageFlags: ShaderStageFlags,
    offset: u32,
    size: u32,
};
pub const PipelineLayoutCreateInfo = extern struct {
    sType: StructureType = .pipeline_layout_create_info,
    pNext: ?*const c_void = null,
    flags: PipelineLayoutCreateFlags,
    setLayoutCount: u32,
    pSetLayouts: [*]const DescriptorSetLayout,
    pushConstantRangeCount: u32,
    pPushConstantRanges: [*]const PushConstantRange,
};
pub const SamplerCreateInfo = extern struct {
    sType: StructureType = .sampler_create_info,
    pNext: ?*const c_void = null,
    flags: SamplerCreateFlags,
    magFilter: Filter,
    minFilter: Filter,
    mipmapMode: SamplerMipmapMode,
    addressModeU: SamplerAddressMode,
    addressModeV: SamplerAddressMode,
    addressModeW: SamplerAddressMode,
    mipLodBias: f32,
    anisotropyEnable: Bool32,
    maxAnisotropy: f32,
    compareEnable: Bool32,
    compareOp: CompareOp,
    minLod: f32,
    maxLod: f32,
    borderColor: BorderColor,
    unnormalizedCoordinates: Bool32,
};
pub const CommandPoolCreateInfo = extern struct {
    sType: StructureType = .command_pool_create_info,
    pNext: ?*const c_void = null,
    flags: CommandPoolCreateFlags,
    queueFamilyIndex: u32,
};
pub const CommandBufferAllocateInfo = extern struct {
    sType: StructureType = .command_buffer_allocate_info,
    pNext: ?*const c_void = null,
    commandPool: CommandPool,
    level: CommandBufferLevel,
    commandBufferCount: u32,
};
pub const CommandBufferInheritanceInfo = extern struct {
    sType: StructureType = .command_buffer_inheritance_info,
    pNext: ?*const c_void = null,
    renderPass: RenderPass,
    subpass: u32,
    framebuffer: Framebuffer,
    occlusionQueryEnable: Bool32,
    queryFlags: QueryControlFlags,
    pipelineStatistics: QueryPipelineStatisticFlags,
};
pub const CommandBufferBeginInfo = extern struct {
    sType: StructureType = .command_buffer_begin_info,
    pNext: ?*const c_void = null,
    flags: CommandBufferUsageFlags,
    pInheritanceInfo: ?*const CommandBufferInheritanceInfo,
};
pub const RenderPassBeginInfo = extern struct {
    sType: StructureType = .render_pass_begin_info,
    pNext: ?*const c_void = null,
    renderPass: RenderPass,
    framebuffer: Framebuffer,
    renderArea: Rect2D,
    clearValueCount: u32,
    pClearValues: [*]const ClearValue,
};
pub const ClearColorValue = extern union {
    float32: [4]f32,
    int32: [4]i32,
    uint32: [4]u32,
};
pub const ClearDepthStencilValue = extern struct {
    depth: f32,
    stencil: u32,
};
pub const ClearValue = extern union {
    color: ClearColorValue,
    depthStencil: ClearDepthStencilValue,
};
pub const ClearAttachment = extern struct {
    aspectMask: ImageAspectFlags,
    colorAttachment: u32,
    clearValue: ClearValue,
};
pub const AttachmentDescription = extern struct {
    flags: AttachmentDescriptionFlags,
    format: Format,
    samples: SampleCountFlags,
    loadOp: AttachmentLoadOp,
    storeOp: AttachmentStoreOp,
    stencilLoadOp: AttachmentLoadOp,
    stencilStoreOp: AttachmentStoreOp,
    initialLayout: ImageLayout,
    finalLayout: ImageLayout,
};
pub const AttachmentReference = extern struct {
    attachment: u32,
    layout: ImageLayout,
};
pub const SubpassDescription = extern struct {
    flags: SubpassDescriptionFlags,
    pipelineBindPoint: PipelineBindPoint,
    inputAttachmentCount: u32,
    pInputAttachments: [*]const AttachmentReference,
    colorAttachmentCount: u32,
    pColorAttachments: [*]const AttachmentReference,
    pResolveAttachments: ?[*]const AttachmentReference,
    pDepthStencilAttachment: ?*const AttachmentReference,
    preserveAttachmentCount: u32,
    pPreserveAttachments: [*]const u32,
};
pub const SubpassDependency = extern struct {
    srcSubpass: u32,
    dstSubpass: u32,
    srcStageMask: PipelineStageFlags,
    dstStageMask: PipelineStageFlags,
    srcAccessMask: AccessFlags,
    dstAccessMask: AccessFlags,
    dependencyFlags: DependencyFlags,
};
pub const RenderPassCreateInfo = extern struct {
    sType: StructureType = .render_pass_create_info,
    pNext: ?*const c_void = null,
    flags: RenderPassCreateFlags,
    attachmentCount: u32,
    pAttachments: [*]const AttachmentDescription,
    subpassCount: u32,
    pSubpasses: [*]const SubpassDescription,
    dependencyCount: u32,
    pDependencies: [*]const SubpassDependency,
};
pub const EventCreateInfo = extern struct {
    sType: StructureType = .event_create_info,
    pNext: ?*const c_void = null,
    flags: EventCreateFlags,
};
pub const FenceCreateInfo = extern struct {
    sType: StructureType = .fence_create_info,
    pNext: ?*const c_void = null,
    flags: FenceCreateFlags,
};
pub const PhysicalDeviceFeatures = extern struct {
    robustBufferAccess: Bool32,
    fullDrawIndexUint32: Bool32,
    imageCubeArray: Bool32,
    independentBlend: Bool32,
    geometryShader: Bool32,
    tessellationShader: Bool32,
    sampleRateShading: Bool32,
    dualSrcBlend: Bool32,
    logicOp: Bool32,
    multiDrawIndirect: Bool32,
    drawIndirectFirstInstance: Bool32,
    depthClamp: Bool32,
    depthBiasClamp: Bool32,
    fillModeNonSolid: Bool32,
    depthBounds: Bool32,
    wideLines: Bool32,
    largePoints: Bool32,
    alphaToOne: Bool32,
    multiViewport: Bool32,
    samplerAnisotropy: Bool32,
    textureCompressionEtc2: Bool32,
    textureCompressionAstcLdr: Bool32,
    textureCompressionBc: Bool32,
    occlusionQueryPrecise: Bool32,
    pipelineStatisticsQuery: Bool32,
    vertexPipelineStoresAndAtomics: Bool32,
    fragmentStoresAndAtomics: Bool32,
    shaderTessellationAndGeometryPointSize: Bool32,
    shaderImageGatherExtended: Bool32,
    shaderStorageImageExtendedFormats: Bool32,
    shaderStorageImageMultisample: Bool32,
    shaderStorageImageReadWithoutFormat: Bool32,
    shaderStorageImageWriteWithoutFormat: Bool32,
    shaderUniformBufferArrayDynamicIndexing: Bool32,
    shaderSampledImageArrayDynamicIndexing: Bool32,
    shaderStorageBufferArrayDynamicIndexing: Bool32,
    shaderStorageImageArrayDynamicIndexing: Bool32,
    shaderClipDistance: Bool32,
    shaderCullDistance: Bool32,
    shaderFloat64: Bool32,
    shaderInt64: Bool32,
    shaderInt16: Bool32,
    shaderResourceResidency: Bool32,
    shaderResourceMinLod: Bool32,
    sparseBinding: Bool32,
    sparseResidencyBuffer: Bool32,
    sparseResidencyImage2D: Bool32,
    sparseResidencyImage3D: Bool32,
    sparseResidency2Samples: Bool32,
    sparseResidency4Samples: Bool32,
    sparseResidency8Samples: Bool32,
    sparseResidency16Samples: Bool32,
    sparseResidencyAliased: Bool32,
    variableMultisampleRate: Bool32,
    inheritedQueries: Bool32,
};
pub const PhysicalDeviceSparseProperties = extern struct {
    residencyStandard2DBlockShape: Bool32,
    residencyStandard2DMultisampleBlockShape: Bool32,
    residencyStandard3DBlockShape: Bool32,
    residencyAlignedMipSize: Bool32,
    residencyNonResidentStrict: Bool32,
};
pub const PhysicalDeviceLimits = extern struct {
    maxImageDimension1D: u32,
    maxImageDimension2D: u32,
    maxImageDimension3D: u32,
    maxImageDimensionCube: u32,
    maxImageArrayLayers: u32,
    maxTexelBufferElements: u32,
    maxUniformBufferRange: u32,
    maxStorageBufferRange: u32,
    maxPushConstantsSize: u32,
    maxMemoryAllocationCount: u32,
    maxSamplerAllocationCount: u32,
    bufferImageGranularity: DeviceSize,
    sparseAddressSpaceSize: DeviceSize,
    maxBoundDescriptorSets: u32,
    maxPerStageDescriptorSamplers: u32,
    maxPerStageDescriptorUniformBuffers: u32,
    maxPerStageDescriptorStorageBuffers: u32,
    maxPerStageDescriptorSampledImages: u32,
    maxPerStageDescriptorStorageImages: u32,
    maxPerStageDescriptorInputAttachments: u32,
    maxPerStageResources: u32,
    maxDescriptorSetSamplers: u32,
    maxDescriptorSetUniformBuffers: u32,
    maxDescriptorSetUniformBuffersDynamic: u32,
    maxDescriptorSetStorageBuffers: u32,
    maxDescriptorSetStorageBuffersDynamic: u32,
    maxDescriptorSetSampledImages: u32,
    maxDescriptorSetStorageImages: u32,
    maxDescriptorSetInputAttachments: u32,
    maxVertexInputAttributes: u32,
    maxVertexInputBindings: u32,
    maxVertexInputAttributeOffset: u32,
    maxVertexInputBindingStride: u32,
    maxVertexOutputComponents: u32,
    maxTessellationGenerationLevel: u32,
    maxTessellationPatchSize: u32,
    maxTessellationControlPerVertexInputComponents: u32,
    maxTessellationControlPerVertexOutputComponents: u32,
    maxTessellationControlPerPatchOutputComponents: u32,
    maxTessellationControlTotalOutputComponents: u32,
    maxTessellationEvaluationInputComponents: u32,
    maxTessellationEvaluationOutputComponents: u32,
    maxGeometryShaderInvocations: u32,
    maxGeometryInputComponents: u32,
    maxGeometryOutputComponents: u32,
    maxGeometryOutputVertices: u32,
    maxGeometryTotalOutputComponents: u32,
    maxFragmentInputComponents: u32,
    maxFragmentOutputAttachments: u32,
    maxFragmentDualSrcAttachments: u32,
    maxFragmentCombinedOutputResources: u32,
    maxComputeSharedMemorySize: u32,
    maxComputeWorkGroupCount: [3]u32,
    maxComputeWorkGroupInvocations: u32,
    maxComputeWorkGroupSize: [3]u32,
    subPixelPrecisionBits: u32,
    subTexelPrecisionBits: u32,
    mipmapPrecisionBits: u32,
    maxDrawIndexedIndexValue: u32,
    maxDrawIndirectCount: u32,
    maxSamplerLodBias: f32,
    maxSamplerAnisotropy: f32,
    maxViewports: u32,
    maxViewportDimensions: [2]u32,
    viewportBoundsRange: [2]f32,
    viewportSubPixelBits: u32,
    minMemoryMapAlignment: usize,
    minTexelBufferOffsetAlignment: DeviceSize,
    minUniformBufferOffsetAlignment: DeviceSize,
    minStorageBufferOffsetAlignment: DeviceSize,
    minTexelOffset: i32,
    maxTexelOffset: u32,
    minTexelGatherOffset: i32,
    maxTexelGatherOffset: u32,
    minInterpolationOffset: f32,
    maxInterpolationOffset: f32,
    subPixelInterpolationOffsetBits: u32,
    maxFramebufferWidth: u32,
    maxFramebufferHeight: u32,
    maxFramebufferLayers: u32,
    framebufferColorSampleCounts: SampleCountFlags,
    framebufferDepthSampleCounts: SampleCountFlags,
    framebufferStencilSampleCounts: SampleCountFlags,
    framebufferNoAttachmentsSampleCounts: SampleCountFlags,
    maxColorAttachments: u32,
    sampledImageColorSampleCounts: SampleCountFlags,
    sampledImageIntegerSampleCounts: SampleCountFlags,
    sampledImageDepthSampleCounts: SampleCountFlags,
    sampledImageStencilSampleCounts: SampleCountFlags,
    storageImageSampleCounts: SampleCountFlags,
    maxSampleMaskWords: u32,
    timestampComputeAndGraphics: Bool32,
    timestampPeriod: f32,
    maxClipDistances: u32,
    maxCullDistances: u32,
    maxCombinedClipAndCullDistances: u32,
    discreteQueuePriorities: u32,
    pointSizeRange: [2]f32,
    lineWidthRange: [2]f32,
    pointSizeGranularity: f32,
    lineWidthGranularity: f32,
    strictLines: Bool32,
    standardSampleLocations: Bool32,
    optimalBufferCopyOffsetAlignment: DeviceSize,
    optimalBufferCopyRowPitchAlignment: DeviceSize,
    nonCoherentAtomSize: DeviceSize,
};
pub const SemaphoreCreateInfo = extern struct {
    sType: StructureType = .semaphore_create_info,
    pNext: ?*const c_void = null,
    flags: SemaphoreCreateFlags,
};
pub const QueryPoolCreateInfo = extern struct {
    sType: StructureType = .query_pool_create_info,
    pNext: ?*const c_void = null,
    flags: QueryPoolCreateFlags,
    queryType: QueryType,
    queryCount: u32,
    pipelineStatistics: QueryPipelineStatisticFlags,
};
pub const FramebufferCreateInfo = extern struct {
    sType: StructureType = .framebuffer_create_info,
    pNext: ?*const c_void = null,
    flags: FramebufferCreateFlags,
    renderPass: RenderPass,
    attachmentCount: u32,
    pAttachments: [*]const ImageView,
    width: u32,
    height: u32,
    layers: u32,
};
pub const DrawIndirectCommand = extern struct {
    vertexCount: u32,
    instanceCount: u32,
    firstVertex: u32,
    firstInstance: u32,
};
pub const DrawIndexedIndirectCommand = extern struct {
    indexCount: u32,
    instanceCount: u32,
    firstIndex: u32,
    vertexOffset: i32,
    firstInstance: u32,
};
pub const DispatchIndirectCommand = extern struct {
    x: u32,
    y: u32,
    z: u32,
};
pub const SubmitInfo = extern struct {
    sType: StructureType = .submit_info,
    pNext: ?*const c_void = null,
    waitSemaphoreCount: u32,
    pWaitSemaphores: [*]const Semaphore,
    pWaitDstStageMask: [*]const PipelineStageFlags,
    commandBufferCount: u32,
    pCommandBuffers: [*]const CommandBuffer,
    signalSemaphoreCount: u32,
    pSignalSemaphores: [*]const Semaphore,
};
pub const DisplayPropertiesKHR = extern struct {
    display: DisplayKHR,
    displayName: [*:0]const u8,
    physicalDimensions: Extent2D,
    physicalResolution: Extent2D,
    supportedTransforms: SurfaceTransformFlagsKHR,
    planeReorderPossible: Bool32,
    persistentContent: Bool32,
};
pub const DisplayPlanePropertiesKHR = extern struct {
    currentDisplay: DisplayKHR,
    currentStackIndex: u32,
};
pub const DisplayModeParametersKHR = extern struct {
    visibleRegion: Extent2D,
    refreshRate: u32,
};
pub const DisplayModePropertiesKHR = extern struct {
    displayMode: DisplayModeKHR,
    parameters: DisplayModeParametersKHR,
};
pub const DisplayModeCreateInfoKHR = extern struct {
    sType: StructureType = .display_mode_create_info_khr,
    pNext: ?*const c_void = null,
    flags: DisplayModeCreateFlagsKHR,
    parameters: DisplayModeParametersKHR,
};
pub const DisplayPlaneCapabilitiesKHR = extern struct {
    supportedAlpha: DisplayPlaneAlphaFlagsKHR,
    minSrcPosition: Offset2D,
    maxSrcPosition: Offset2D,
    minSrcExtent: Extent2D,
    maxSrcExtent: Extent2D,
    minDstPosition: Offset2D,
    maxDstPosition: Offset2D,
    minDstExtent: Extent2D,
    maxDstExtent: Extent2D,
};
pub const DisplaySurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .display_surface_create_info_khr,
    pNext: ?*const c_void = null,
    flags: DisplaySurfaceCreateFlagsKHR,
    displayMode: DisplayModeKHR,
    planeIndex: u32,
    planeStackIndex: u32,
    transform: SurfaceTransformFlagsKHR,
    globalAlpha: f32,
    alphaMode: DisplayPlaneAlphaFlagsKHR,
    imageExtent: Extent2D,
};
pub const DisplayPresentInfoKHR = extern struct {
    sType: StructureType = .display_present_info_khr,
    pNext: ?*const c_void = null,
    srcRect: Rect2D,
    dstRect: Rect2D,
    persistent: Bool32,
};
pub const SurfaceCapabilitiesKHR = extern struct {
    minImageCount: u32,
    maxImageCount: u32,
    currentExtent: Extent2D,
    minImageExtent: Extent2D,
    maxImageExtent: Extent2D,
    maxImageArrayLayers: u32,
    supportedTransforms: SurfaceTransformFlagsKHR,
    currentTransform: SurfaceTransformFlagsKHR,
    supportedCompositeAlpha: CompositeAlphaFlagsKHR,
    supportedUsageFlags: ImageUsageFlags,
};
pub const AndroidSurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .android_surface_create_info_khr,
    pNext: ?*const c_void = null,
    flags: AndroidSurfaceCreateFlagsKHR,
    window: *ANativeWindow,
};
pub const ViSurfaceCreateInfoNN = extern struct {
    sType: StructureType = .vi_surface_create_info_nn,
    pNext: ?*const c_void = null,
    flags: ViSurfaceCreateFlagsNN,
    window: *c_void,
};
pub const WaylandSurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .wayland_surface_create_info_khr,
    pNext: ?*const c_void = null,
    flags: WaylandSurfaceCreateFlagsKHR,
    display: *wl_display,
    surface: *wl_surface,
};
pub const Win32SurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .win32_surface_create_info_khr,
    pNext: ?*const c_void = null,
    flags: Win32SurfaceCreateFlagsKHR,
    hinstance: HINSTANCE,
    hwnd: HWND,
};
pub const XlibSurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .xlib_surface_create_info_khr,
    pNext: ?*const c_void = null,
    flags: XlibSurfaceCreateFlagsKHR,
    dpy: *Display,
    window: Window,
};
pub const XcbSurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .xcb_surface_create_info_khr,
    pNext: ?*const c_void = null,
    flags: XcbSurfaceCreateFlagsKHR,
    connection: *xcb_connection_t,
    window: xcb_window_t,
};
pub const DirectFBSurfaceCreateInfoEXT = extern struct {
    sType: StructureType = .directfb_surface_create_info_ext,
    pNext: ?*const c_void = null,
    flags: DirectFBSurfaceCreateFlagsEXT,
    dfb: *IDirectFB,
    surface: *IDirectFBSurface,
};
pub const ImagePipeSurfaceCreateInfoFUCHSIA = extern struct {
    sType: StructureType = .imagepipe_surface_create_info_fuchsia,
    pNext: ?*const c_void = null,
    flags: ImagePipeSurfaceCreateFlagsFUCHSIA,
    imagePipeHandle: zx_handle_t,
};
pub const StreamDescriptorSurfaceCreateInfoGGP = extern struct {
    sType: StructureType = .stream_descriptor_surface_create_info_ggp,
    pNext: ?*const c_void = null,
    flags: StreamDescriptorSurfaceCreateFlagsGGP,
    streamDescriptor: GgpStreamDescriptor,
};
pub const SurfaceFormatKHR = extern struct {
    format: Format,
    colorSpace: ColorSpaceKHR,
};
pub const SwapchainCreateInfoKHR = extern struct {
    sType: StructureType = .swapchain_create_info_khr,
    pNext: ?*const c_void = null,
    flags: SwapchainCreateFlagsKHR,
    surface: SurfaceKHR,
    minImageCount: u32,
    imageFormat: Format,
    imageColorSpace: ColorSpaceKHR,
    imageExtent: Extent2D,
    imageArrayLayers: u32,
    imageUsage: ImageUsageFlags,
    imageSharingMode: SharingMode,
    queueFamilyIndexCount: u32,
    pQueueFamilyIndices: [*]const u32,
    preTransform: SurfaceTransformFlagsKHR,
    compositeAlpha: CompositeAlphaFlagsKHR,
    presentMode: PresentModeKHR,
    clipped: Bool32,
    oldSwapchain: SwapchainKHR,
};
pub const PresentInfoKHR = extern struct {
    sType: StructureType = .present_info_khr,
    pNext: ?*const c_void = null,
    waitSemaphoreCount: u32,
    pWaitSemaphores: [*]const Semaphore,
    swapchainCount: u32,
    pSwapchains: [*]const SwapchainKHR,
    pImageIndices: [*]const u32,
    pResults: ?[*]Result,
};
pub const DebugReportCallbackCreateInfoEXT = extern struct {
    sType: StructureType = .debug_report_callback_create_info_ext,
    pNext: ?*const c_void = null,
    flags: DebugReportFlagsEXT,
    pfnCallback: PfnDebugReportCallbackEXT,
    pUserData: ?*c_void,
};
pub const ValidationFlagsEXT = extern struct {
    sType: StructureType = .validation_flags_ext,
    pNext: ?*const c_void = null,
    disabledValidationCheckCount: u32,
    pDisabledValidationChecks: [*]const ValidationCheckEXT,
};
pub const ValidationFeaturesEXT = extern struct {
    sType: StructureType = .validation_features_ext,
    pNext: ?*const c_void = null,
    enabledValidationFeatureCount: u32,
    pEnabledValidationFeatures: [*]const ValidationFeatureEnableEXT,
    disabledValidationFeatureCount: u32,
    pDisabledValidationFeatures: [*]const ValidationFeatureDisableEXT,
};
pub const PipelineRasterizationStateRasterizationOrderAMD = extern struct {
    sType: StructureType = .pipeline_rasterization_state_rasterization_order_amd,
    pNext: ?*const c_void = null,
    rasterizationOrder: RasterizationOrderAMD,
};
pub const DebugMarkerObjectNameInfoEXT = extern struct {
    sType: StructureType = .debug_marker_object_name_info_ext,
    pNext: ?*const c_void = null,
    objectType: DebugReportObjectTypeEXT,
    object: u64,
    pObjectName: [*:0]const u8,
};
pub const DebugMarkerObjectTagInfoEXT = extern struct {
    sType: StructureType = .debug_marker_object_tag_info_ext,
    pNext: ?*const c_void = null,
    objectType: DebugReportObjectTypeEXT,
    object: u64,
    tagName: u64,
    tagSize: usize,
    pTag: *const c_void,
};
pub const DebugMarkerMarkerInfoEXT = extern struct {
    sType: StructureType = .debug_marker_marker_info_ext,
    pNext: ?*const c_void = null,
    pMarkerName: [*:0]const u8,
    color: [4]f32,
};
pub const DedicatedAllocationImageCreateInfoNV = extern struct {
    sType: StructureType = .dedicated_allocation_image_create_info_nv,
    pNext: ?*const c_void = null,
    dedicatedAllocation: Bool32,
};
pub const DedicatedAllocationBufferCreateInfoNV = extern struct {
    sType: StructureType = .dedicated_allocation_buffer_create_info_nv,
    pNext: ?*const c_void = null,
    dedicatedAllocation: Bool32,
};
pub const DedicatedAllocationMemoryAllocateInfoNV = extern struct {
    sType: StructureType = .dedicated_allocation_memory_allocate_info_nv,
    pNext: ?*const c_void = null,
    image: Image,
    buffer: Buffer,
};
pub const ExternalImageFormatPropertiesNV = extern struct {
    imageFormatProperties: ImageFormatProperties,
    externalMemoryFeatures: ExternalMemoryFeatureFlagsNV,
    exportFromImportedHandleTypes: ExternalMemoryHandleTypeFlagsNV,
    compatibleHandleTypes: ExternalMemoryHandleTypeFlagsNV,
};
pub const ExternalMemoryImageCreateInfoNV = extern struct {
    sType: StructureType = .external_memory_image_create_info_nv,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlagsNV,
};
pub const ExportMemoryAllocateInfoNV = extern struct {
    sType: StructureType = .export_memory_allocate_info_nv,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlagsNV,
};
pub const ImportMemoryWin32HandleInfoNV = extern struct {
    sType: StructureType = .import_memory_win32_handle_info_nv,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlagsNV,
    handle: HANDLE,
};
pub const ExportMemoryWin32HandleInfoNV = extern struct {
    sType: StructureType = .export_memory_win32_handle_info_nv,
    pNext: ?*const c_void = null,
    pAttributes: ?*const SECURITY_ATTRIBUTES,
    dwAccess: DWORD,
};
pub const Win32KeyedMutexAcquireReleaseInfoNV = extern struct {
    sType: StructureType = .win32_keyed_mutex_acquire_release_info_nv,
    pNext: ?*const c_void = null,
    acquireCount: u32,
    pAcquireSyncs: [*]const DeviceMemory,
    pAcquireKeys: [*]const u64,
    pAcquireTimeoutMilliseconds: [*]const u32,
    releaseCount: u32,
    pReleaseSyncs: [*]const DeviceMemory,
    pReleaseKeys: [*]const u64,
};
pub const PhysicalDeviceDeviceGeneratedCommandsFeaturesNV = extern struct {
    sType: StructureType = .physical_device_device_generated_commands_features_nv,
    pNext: ?*c_void = null,
    deviceGeneratedCommands: Bool32,
};
pub const DevicePrivateDataCreateInfoEXT = extern struct {
    sType: StructureType = .device_private_data_create_info_ext,
    pNext: ?*const c_void = null,
    privateDataSlotRequestCount: u32,
};
pub const PrivateDataSlotCreateInfoEXT = extern struct {
    sType: StructureType = .private_data_slot_create_info_ext,
    pNext: ?*const c_void = null,
    flags: PrivateDataSlotCreateFlagsEXT,
};
pub const PhysicalDevicePrivateDataFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_private_data_features_ext,
    pNext: ?*c_void = null,
    privateData: Bool32,
};
pub const PhysicalDeviceDeviceGeneratedCommandsPropertiesNV = extern struct {
    sType: StructureType = .physical_device_device_generated_commands_properties_nv,
    pNext: ?*c_void = null,
    maxGraphicsShaderGroupCount: u32,
    maxIndirectSequenceCount: u32,
    maxIndirectCommandsTokenCount: u32,
    maxIndirectCommandsStreamCount: u32,
    maxIndirectCommandsTokenOffset: u32,
    maxIndirectCommandsStreamStride: u32,
    minSequencesCountBufferOffsetAlignment: u32,
    minSequencesIndexBufferOffsetAlignment: u32,
    minIndirectCommandsBufferOffsetAlignment: u32,
};
pub const GraphicsShaderGroupCreateInfoNV = extern struct {
    sType: StructureType = .graphics_shader_group_create_info_nv,
    pNext: ?*const c_void = null,
    stageCount: u32,
    pStages: [*]const PipelineShaderStageCreateInfo,
    pVertexInputState: ?*const PipelineVertexInputStateCreateInfo,
    pTessellationState: ?*const PipelineTessellationStateCreateInfo,
};
pub const GraphicsPipelineShaderGroupsCreateInfoNV = extern struct {
    sType: StructureType = .graphics_pipeline_shader_groups_create_info_nv,
    pNext: ?*const c_void = null,
    groupCount: u32,
    pGroups: [*]const GraphicsShaderGroupCreateInfoNV,
    pipelineCount: u32,
    pPipelines: [*]const Pipeline,
};
pub const BindShaderGroupIndirectCommandNV = extern struct {
    groupIndex: u32,
};
pub const BindIndexBufferIndirectCommandNV = extern struct {
    bufferAddress: DeviceAddress,
    size: u32,
    indexType: IndexType,
};
pub const BindVertexBufferIndirectCommandNV = extern struct {
    bufferAddress: DeviceAddress,
    size: u32,
    stride: u32,
};
pub const SetStateFlagsIndirectCommandNV = extern struct {
    data: u32,
};
pub const IndirectCommandsStreamNV = extern struct {
    buffer: Buffer,
    offset: DeviceSize,
};
pub const IndirectCommandsLayoutTokenNV = extern struct {
    sType: StructureType = .indirect_commands_layout_token_nv,
    pNext: ?*const c_void = null,
    tokenType: IndirectCommandsTokenTypeNV,
    stream: u32,
    offset: u32,
    vertexBindingUnit: u32,
    vertexDynamicStride: Bool32,
    pushconstantPipelineLayout: PipelineLayout,
    pushconstantShaderStageFlags: ShaderStageFlags,
    pushconstantOffset: u32,
    pushconstantSize: u32,
    indirectStateFlags: IndirectStateFlagsNV,
    indexTypeCount: u32,
    pIndexTypes: [*]const IndexType,
    pIndexTypeValues: [*]const u32,
};
pub const IndirectCommandsLayoutCreateInfoNV = extern struct {
    sType: StructureType = .indirect_commands_layout_create_info_nv,
    pNext: ?*const c_void = null,
    flags: IndirectCommandsLayoutUsageFlagsNV,
    pipelineBindPoint: PipelineBindPoint,
    tokenCount: u32,
    pTokens: [*]const IndirectCommandsLayoutTokenNV,
    streamCount: u32,
    pStreamStrides: [*]const u32,
};
pub const GeneratedCommandsInfoNV = extern struct {
    sType: StructureType = .generated_commands_info_nv,
    pNext: ?*const c_void = null,
    pipelineBindPoint: PipelineBindPoint,
    pipeline: Pipeline,
    indirectCommandsLayout: IndirectCommandsLayoutNV,
    streamCount: u32,
    pStreams: [*]const IndirectCommandsStreamNV,
    sequencesCount: u32,
    preprocessBuffer: Buffer,
    preprocessOffset: DeviceSize,
    preprocessSize: DeviceSize,
    sequencesCountBuffer: Buffer,
    sequencesCountOffset: DeviceSize,
    sequencesIndexBuffer: Buffer,
    sequencesIndexOffset: DeviceSize,
};
pub const GeneratedCommandsMemoryRequirementsInfoNV = extern struct {
    sType: StructureType = .generated_commands_memory_requirements_info_nv,
    pNext: ?*const c_void = null,
    pipelineBindPoint: PipelineBindPoint,
    pipeline: Pipeline,
    indirectCommandsLayout: IndirectCommandsLayoutNV,
    maxSequencesCount: u32,
};
pub const PhysicalDeviceFeatures2 = extern struct {
    sType: StructureType = .physical_device_features_2,
    pNext: ?*c_void = null,
    features: PhysicalDeviceFeatures,
};
pub const PhysicalDeviceFeatures2KHR = PhysicalDeviceFeatures2;
pub const PhysicalDeviceProperties2 = extern struct {
    sType: StructureType = .physical_device_properties_2,
    pNext: ?*c_void = null,
    properties: PhysicalDeviceProperties,
};
pub const PhysicalDeviceProperties2KHR = PhysicalDeviceProperties2;
pub const FormatProperties2 = extern struct {
    sType: StructureType = .format_properties_2,
    pNext: ?*c_void = null,
    formatProperties: FormatProperties,
};
pub const FormatProperties2KHR = FormatProperties2;
pub const ImageFormatProperties2 = extern struct {
    sType: StructureType = .image_format_properties_2,
    pNext: ?*c_void = null,
    imageFormatProperties: ImageFormatProperties,
};
pub const ImageFormatProperties2KHR = ImageFormatProperties2;
pub const PhysicalDeviceImageFormatInfo2 = extern struct {
    sType: StructureType = .physical_device_image_format_info_2,
    pNext: ?*const c_void = null,
    format: Format,
    type: ImageType,
    tiling: ImageTiling,
    usage: ImageUsageFlags,
    flags: ImageCreateFlags,
};
pub const PhysicalDeviceImageFormatInfo2KHR = PhysicalDeviceImageFormatInfo2;
pub const QueueFamilyProperties2 = extern struct {
    sType: StructureType = .queue_family_properties_2,
    pNext: ?*c_void = null,
    queueFamilyProperties: QueueFamilyProperties,
};
pub const QueueFamilyProperties2KHR = QueueFamilyProperties2;
pub const PhysicalDeviceMemoryProperties2 = extern struct {
    sType: StructureType = .physical_device_memory_properties_2,
    pNext: ?*c_void = null,
    memoryProperties: PhysicalDeviceMemoryProperties,
};
pub const PhysicalDeviceMemoryProperties2KHR = PhysicalDeviceMemoryProperties2;
pub const SparseImageFormatProperties2 = extern struct {
    sType: StructureType = .sparse_image_format_properties_2,
    pNext: ?*c_void = null,
    properties: SparseImageFormatProperties,
};
pub const SparseImageFormatProperties2KHR = SparseImageFormatProperties2;
pub const PhysicalDeviceSparseImageFormatInfo2 = extern struct {
    sType: StructureType = .physical_device_sparse_image_format_info_2,
    pNext: ?*const c_void = null,
    format: Format,
    type: ImageType,
    samples: SampleCountFlags,
    usage: ImageUsageFlags,
    tiling: ImageTiling,
};
pub const PhysicalDeviceSparseImageFormatInfo2KHR = PhysicalDeviceSparseImageFormatInfo2;
pub const PhysicalDevicePushDescriptorPropertiesKHR = extern struct {
    sType: StructureType = .physical_device_push_descriptor_properties_khr,
    pNext: ?*c_void = null,
    maxPushDescriptors: u32,
};
pub const ConformanceVersion = extern struct {
    major: u8,
    minor: u8,
    subminor: u8,
    patch: u8,
};
pub const ConformanceVersionKHR = ConformanceVersion;
pub const PhysicalDeviceDriverProperties = extern struct {
    sType: StructureType = .physical_device_driver_properties,
    pNext: ?*c_void = null,
    driverId: DriverId,
    driverName: [MAX_DRIVER_NAME_SIZE]u8,
    driverInfo: [MAX_DRIVER_INFO_SIZE]u8,
    conformanceVersion: ConformanceVersion,
};
pub const PhysicalDeviceDriverPropertiesKHR = PhysicalDeviceDriverProperties;
pub const PresentRegionsKHR = extern struct {
    sType: StructureType = .present_regions_khr,
    pNext: ?*const c_void = null,
    swapchainCount: u32,
    pRegions: ?[*]const PresentRegionKHR,
};
pub const PresentRegionKHR = extern struct {
    rectangleCount: u32,
    pRectangles: ?[*]const RectLayerKHR,
};
pub const RectLayerKHR = extern struct {
    offset: Offset2D,
    extent: Extent2D,
    layer: u32,
};
pub const PhysicalDeviceVariablePointersFeatures = extern struct {
    sType: StructureType = .physical_device_variable_pointers_features,
    pNext: ?*c_void = null,
    variablePointersStorageBuffer: Bool32,
    variablePointers: Bool32,
};
pub const PhysicalDeviceVariablePointersFeaturesKHR = PhysicalDeviceVariablePointersFeatures;
pub const PhysicalDeviceVariablePointerFeaturesKHR = PhysicalDeviceVariablePointersFeatures;
pub const PhysicalDeviceVariablePointerFeatures = PhysicalDeviceVariablePointersFeatures;
pub const ExternalMemoryProperties = extern struct {
    externalMemoryFeatures: ExternalMemoryFeatureFlags,
    exportFromImportedHandleTypes: ExternalMemoryHandleTypeFlags,
    compatibleHandleTypes: ExternalMemoryHandleTypeFlags,
};
pub const ExternalMemoryPropertiesKHR = ExternalMemoryProperties;
pub const PhysicalDeviceExternalImageFormatInfo = extern struct {
    sType: StructureType = .physical_device_external_image_format_info,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const PhysicalDeviceExternalImageFormatInfoKHR = PhysicalDeviceExternalImageFormatInfo;
pub const ExternalImageFormatProperties = extern struct {
    sType: StructureType = .external_image_format_properties,
    pNext: ?*c_void = null,
    externalMemoryProperties: ExternalMemoryProperties,
};
pub const ExternalImageFormatPropertiesKHR = ExternalImageFormatProperties;
pub const PhysicalDeviceExternalBufferInfo = extern struct {
    sType: StructureType = .physical_device_external_buffer_info,
    pNext: ?*const c_void = null,
    flags: BufferCreateFlags,
    usage: BufferUsageFlags,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const PhysicalDeviceExternalBufferInfoKHR = PhysicalDeviceExternalBufferInfo;
pub const ExternalBufferProperties = extern struct {
    sType: StructureType = .external_buffer_properties,
    pNext: ?*c_void = null,
    externalMemoryProperties: ExternalMemoryProperties,
};
pub const ExternalBufferPropertiesKHR = ExternalBufferProperties;
pub const PhysicalDeviceIDProperties = extern struct {
    sType: StructureType = .physical_device_id_properties,
    pNext: ?*c_void = null,
    deviceUuid: [UUID_SIZE]u8,
    driverUuid: [UUID_SIZE]u8,
    deviceLuid: [LUID_SIZE]u8,
    deviceNodeMask: u32,
    deviceLuidValid: Bool32,
};
pub const PhysicalDeviceIDPropertiesKHR = PhysicalDeviceIDProperties;
pub const ExternalMemoryImageCreateInfo = extern struct {
    sType: StructureType = .external_memory_image_create_info,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlags,
};
pub const ExternalMemoryImageCreateInfoKHR = ExternalMemoryImageCreateInfo;
pub const ExternalMemoryBufferCreateInfo = extern struct {
    sType: StructureType = .external_memory_buffer_create_info,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlags,
};
pub const ExternalMemoryBufferCreateInfoKHR = ExternalMemoryBufferCreateInfo;
pub const ExportMemoryAllocateInfo = extern struct {
    sType: StructureType = .export_memory_allocate_info,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlags,
};
pub const ExportMemoryAllocateInfoKHR = ExportMemoryAllocateInfo;
pub const ImportMemoryWin32HandleInfoKHR = extern struct {
    sType: StructureType = .import_memory_win32_handle_info_khr,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlags,
    handle: HANDLE,
    name: LPCWSTR,
};
pub const ExportMemoryWin32HandleInfoKHR = extern struct {
    sType: StructureType = .export_memory_win32_handle_info_khr,
    pNext: ?*const c_void = null,
    pAttributes: ?*const SECURITY_ATTRIBUTES,
    dwAccess: DWORD,
    name: LPCWSTR,
};
pub const MemoryWin32HandlePropertiesKHR = extern struct {
    sType: StructureType = .memory_win32_handle_properties_khr,
    pNext: ?*c_void = null,
    memoryTypeBits: u32,
};
pub const MemoryGetWin32HandleInfoKHR = extern struct {
    sType: StructureType = .memory_get_win32_handle_info_khr,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const ImportMemoryFdInfoKHR = extern struct {
    sType: StructureType = .import_memory_fd_info_khr,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlags,
    fd: c_int,
};
pub const MemoryFdPropertiesKHR = extern struct {
    sType: StructureType = .memory_fd_properties_khr,
    pNext: ?*c_void = null,
    memoryTypeBits: u32,
};
pub const MemoryGetFdInfoKHR = extern struct {
    sType: StructureType = .memory_get_fd_info_khr,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const Win32KeyedMutexAcquireReleaseInfoKHR = extern struct {
    sType: StructureType = .win32_keyed_mutex_acquire_release_info_khr,
    pNext: ?*const c_void = null,
    acquireCount: u32,
    pAcquireSyncs: [*]const DeviceMemory,
    pAcquireKeys: [*]const u64,
    pAcquireTimeouts: [*]const u32,
    releaseCount: u32,
    pReleaseSyncs: [*]const DeviceMemory,
    pReleaseKeys: [*]const u64,
};
pub const PhysicalDeviceExternalSemaphoreInfo = extern struct {
    sType: StructureType = .physical_device_external_semaphore_info,
    pNext: ?*const c_void = null,
    handleType: ExternalSemaphoreHandleTypeFlags,
};
pub const PhysicalDeviceExternalSemaphoreInfoKHR = PhysicalDeviceExternalSemaphoreInfo;
pub const ExternalSemaphoreProperties = extern struct {
    sType: StructureType = .external_semaphore_properties,
    pNext: ?*c_void = null,
    exportFromImportedHandleTypes: ExternalSemaphoreHandleTypeFlags,
    compatibleHandleTypes: ExternalSemaphoreHandleTypeFlags,
    externalSemaphoreFeatures: ExternalSemaphoreFeatureFlags,
};
pub const ExternalSemaphorePropertiesKHR = ExternalSemaphoreProperties;
pub const ExportSemaphoreCreateInfo = extern struct {
    sType: StructureType = .export_semaphore_create_info,
    pNext: ?*const c_void = null,
    handleTypes: ExternalSemaphoreHandleTypeFlags,
};
pub const ExportSemaphoreCreateInfoKHR = ExportSemaphoreCreateInfo;
pub const ImportSemaphoreWin32HandleInfoKHR = extern struct {
    sType: StructureType = .import_semaphore_win32_handle_info_khr,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    flags: SemaphoreImportFlags,
    handleType: ExternalSemaphoreHandleTypeFlags,
    handle: HANDLE,
    name: LPCWSTR,
};
pub const ExportSemaphoreWin32HandleInfoKHR = extern struct {
    sType: StructureType = .export_semaphore_win32_handle_info_khr,
    pNext: ?*const c_void = null,
    pAttributes: ?*const SECURITY_ATTRIBUTES,
    dwAccess: DWORD,
    name: LPCWSTR,
};
pub const D3D12FenceSubmitInfoKHR = extern struct {
    sType: StructureType = .d3d12_fence_submit_info_khr,
    pNext: ?*const c_void = null,
    waitSemaphoreValuesCount: u32,
    pWaitSemaphoreValues: ?[*]const u64,
    signalSemaphoreValuesCount: u32,
    pSignalSemaphoreValues: ?[*]const u64,
};
pub const SemaphoreGetWin32HandleInfoKHR = extern struct {
    sType: StructureType = .semaphore_get_win32_handle_info_khr,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    handleType: ExternalSemaphoreHandleTypeFlags,
};
pub const ImportSemaphoreFdInfoKHR = extern struct {
    sType: StructureType = .import_semaphore_fd_info_khr,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    flags: SemaphoreImportFlags,
    handleType: ExternalSemaphoreHandleTypeFlags,
    fd: c_int,
};
pub const SemaphoreGetFdInfoKHR = extern struct {
    sType: StructureType = .semaphore_get_fd_info_khr,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    handleType: ExternalSemaphoreHandleTypeFlags,
};
pub const PhysicalDeviceExternalFenceInfo = extern struct {
    sType: StructureType = .physical_device_external_fence_info,
    pNext: ?*const c_void = null,
    handleType: ExternalFenceHandleTypeFlags,
};
pub const PhysicalDeviceExternalFenceInfoKHR = PhysicalDeviceExternalFenceInfo;
pub const ExternalFenceProperties = extern struct {
    sType: StructureType = .external_fence_properties,
    pNext: ?*c_void = null,
    exportFromImportedHandleTypes: ExternalFenceHandleTypeFlags,
    compatibleHandleTypes: ExternalFenceHandleTypeFlags,
    externalFenceFeatures: ExternalFenceFeatureFlags,
};
pub const ExternalFencePropertiesKHR = ExternalFenceProperties;
pub const ExportFenceCreateInfo = extern struct {
    sType: StructureType = .export_fence_create_info,
    pNext: ?*const c_void = null,
    handleTypes: ExternalFenceHandleTypeFlags,
};
pub const ExportFenceCreateInfoKHR = ExportFenceCreateInfo;
pub const ImportFenceWin32HandleInfoKHR = extern struct {
    sType: StructureType = .import_fence_win32_handle_info_khr,
    pNext: ?*const c_void = null,
    fence: Fence,
    flags: FenceImportFlags,
    handleType: ExternalFenceHandleTypeFlags,
    handle: HANDLE,
    name: LPCWSTR,
};
pub const ExportFenceWin32HandleInfoKHR = extern struct {
    sType: StructureType = .export_fence_win32_handle_info_khr,
    pNext: ?*const c_void = null,
    pAttributes: ?*const SECURITY_ATTRIBUTES,
    dwAccess: DWORD,
    name: LPCWSTR,
};
pub const FenceGetWin32HandleInfoKHR = extern struct {
    sType: StructureType = .fence_get_win32_handle_info_khr,
    pNext: ?*const c_void = null,
    fence: Fence,
    handleType: ExternalFenceHandleTypeFlags,
};
pub const ImportFenceFdInfoKHR = extern struct {
    sType: StructureType = .import_fence_fd_info_khr,
    pNext: ?*const c_void = null,
    fence: Fence,
    flags: FenceImportFlags,
    handleType: ExternalFenceHandleTypeFlags,
    fd: c_int,
};
pub const FenceGetFdInfoKHR = extern struct {
    sType: StructureType = .fence_get_fd_info_khr,
    pNext: ?*const c_void = null,
    fence: Fence,
    handleType: ExternalFenceHandleTypeFlags,
};
pub const PhysicalDeviceMultiviewFeatures = extern struct {
    sType: StructureType = .physical_device_multiview_features,
    pNext: ?*c_void = null,
    multiview: Bool32,
    multiviewGeometryShader: Bool32,
    multiviewTessellationShader: Bool32,
};
pub const PhysicalDeviceMultiviewFeaturesKHR = PhysicalDeviceMultiviewFeatures;
pub const PhysicalDeviceMultiviewProperties = extern struct {
    sType: StructureType = .physical_device_multiview_properties,
    pNext: ?*c_void = null,
    maxMultiviewViewCount: u32,
    maxMultiviewInstanceIndex: u32,
};
pub const PhysicalDeviceMultiviewPropertiesKHR = PhysicalDeviceMultiviewProperties;
pub const RenderPassMultiviewCreateInfo = extern struct {
    sType: StructureType = .render_pass_multiview_create_info,
    pNext: ?*const c_void = null,
    subpassCount: u32,
    pViewMasks: [*]const u32,
    dependencyCount: u32,
    pViewOffsets: [*]const i32,
    correlationMaskCount: u32,
    pCorrelationMasks: [*]const u32,
};
pub const RenderPassMultiviewCreateInfoKHR = RenderPassMultiviewCreateInfo;
pub const SurfaceCapabilities2EXT = extern struct {
    sType: StructureType = .surface_capabilities_2_ext,
    pNext: ?*c_void = null,
    minImageCount: u32,
    maxImageCount: u32,
    currentExtent: Extent2D,
    minImageExtent: Extent2D,
    maxImageExtent: Extent2D,
    maxImageArrayLayers: u32,
    supportedTransforms: SurfaceTransformFlagsKHR,
    currentTransform: SurfaceTransformFlagsKHR,
    supportedCompositeAlpha: CompositeAlphaFlagsKHR,
    supportedUsageFlags: ImageUsageFlags,
    supportedSurfaceCounters: SurfaceCounterFlagsEXT,
};
pub const DisplayPowerInfoEXT = extern struct {
    sType: StructureType = .display_power_info_ext,
    pNext: ?*const c_void = null,
    powerState: DisplayPowerStateEXT,
};
pub const DeviceEventInfoEXT = extern struct {
    sType: StructureType = .device_event_info_ext,
    pNext: ?*const c_void = null,
    deviceEvent: DeviceEventTypeEXT,
};
pub const DisplayEventInfoEXT = extern struct {
    sType: StructureType = .display_event_info_ext,
    pNext: ?*const c_void = null,
    displayEvent: DisplayEventTypeEXT,
};
pub const SwapchainCounterCreateInfoEXT = extern struct {
    sType: StructureType = .swapchain_counter_create_info_ext,
    pNext: ?*const c_void = null,
    surfaceCounters: SurfaceCounterFlagsEXT,
};
pub const PhysicalDeviceGroupProperties = extern struct {
    sType: StructureType = .physical_device_group_properties,
    pNext: ?*c_void = null,
    physicalDeviceCount: u32,
    physicalDevices: [MAX_DEVICE_GROUP_SIZE]PhysicalDevice,
    subsetAllocation: Bool32,
};
pub const PhysicalDeviceGroupPropertiesKHR = PhysicalDeviceGroupProperties;
pub const MemoryAllocateFlagsInfo = extern struct {
    sType: StructureType = .memory_allocate_flags_info,
    pNext: ?*const c_void = null,
    flags: MemoryAllocateFlags,
    deviceMask: u32,
};
pub const MemoryAllocateFlagsInfoKHR = MemoryAllocateFlagsInfo;
pub const BindBufferMemoryInfo = extern struct {
    sType: StructureType = .bind_buffer_memory_info,
    pNext: ?*const c_void = null,
    buffer: Buffer,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
};
pub const BindBufferMemoryInfoKHR = BindBufferMemoryInfo;
pub const BindBufferMemoryDeviceGroupInfo = extern struct {
    sType: StructureType = .bind_buffer_memory_device_group_info,
    pNext: ?*const c_void = null,
    deviceIndexCount: u32,
    pDeviceIndices: [*]const u32,
};
pub const BindBufferMemoryDeviceGroupInfoKHR = BindBufferMemoryDeviceGroupInfo;
pub const BindImageMemoryInfo = extern struct {
    sType: StructureType = .bind_image_memory_info,
    pNext: ?*const c_void = null,
    image: Image,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
};
pub const BindImageMemoryInfoKHR = BindImageMemoryInfo;
pub const BindImageMemoryDeviceGroupInfo = extern struct {
    sType: StructureType = .bind_image_memory_device_group_info,
    pNext: ?*const c_void = null,
    deviceIndexCount: u32,
    pDeviceIndices: [*]const u32,
    splitInstanceBindRegionCount: u32,
    pSplitInstanceBindRegions: [*]const Rect2D,
};
pub const BindImageMemoryDeviceGroupInfoKHR = BindImageMemoryDeviceGroupInfo;
pub const DeviceGroupRenderPassBeginInfo = extern struct {
    sType: StructureType = .device_group_render_pass_begin_info,
    pNext: ?*const c_void = null,
    deviceMask: u32,
    deviceRenderAreaCount: u32,
    pDeviceRenderAreas: [*]const Rect2D,
};
pub const DeviceGroupRenderPassBeginInfoKHR = DeviceGroupRenderPassBeginInfo;
pub const DeviceGroupCommandBufferBeginInfo = extern struct {
    sType: StructureType = .device_group_command_buffer_begin_info,
    pNext: ?*const c_void = null,
    deviceMask: u32,
};
pub const DeviceGroupCommandBufferBeginInfoKHR = DeviceGroupCommandBufferBeginInfo;
pub const DeviceGroupSubmitInfo = extern struct {
    sType: StructureType = .device_group_submit_info,
    pNext: ?*const c_void = null,
    waitSemaphoreCount: u32,
    pWaitSemaphoreDeviceIndices: [*]const u32,
    commandBufferCount: u32,
    pCommandBufferDeviceMasks: [*]const u32,
    signalSemaphoreCount: u32,
    pSignalSemaphoreDeviceIndices: [*]const u32,
};
pub const DeviceGroupSubmitInfoKHR = DeviceGroupSubmitInfo;
pub const DeviceGroupBindSparseInfo = extern struct {
    sType: StructureType = .device_group_bind_sparse_info,
    pNext: ?*const c_void = null,
    resourceDeviceIndex: u32,
    memoryDeviceIndex: u32,
};
pub const DeviceGroupBindSparseInfoKHR = DeviceGroupBindSparseInfo;
pub const DeviceGroupPresentCapabilitiesKHR = extern struct {
    sType: StructureType = .device_group_present_capabilities_khr,
    pNext: ?*const c_void = null,
    presentMask: [MAX_DEVICE_GROUP_SIZE]u32,
    modes: DeviceGroupPresentModeFlagsKHR,
};
pub const ImageSwapchainCreateInfoKHR = extern struct {
    sType: StructureType = .image_swapchain_create_info_khr,
    pNext: ?*const c_void = null,
    swapchain: SwapchainKHR,
};
pub const BindImageMemorySwapchainInfoKHR = extern struct {
    sType: StructureType = .bind_image_memory_swapchain_info_khr,
    pNext: ?*const c_void = null,
    swapchain: SwapchainKHR,
    imageIndex: u32,
};
pub const AcquireNextImageInfoKHR = extern struct {
    sType: StructureType = .acquire_next_image_info_khr,
    pNext: ?*const c_void = null,
    swapchain: SwapchainKHR,
    timeout: u64,
    semaphore: Semaphore,
    fence: Fence,
    deviceMask: u32,
};
pub const DeviceGroupPresentInfoKHR = extern struct {
    sType: StructureType = .device_group_present_info_khr,
    pNext: ?*const c_void = null,
    swapchainCount: u32,
    pDeviceMasks: [*]const u32,
    mode: DeviceGroupPresentModeFlagsKHR,
};
pub const DeviceGroupDeviceCreateInfo = extern struct {
    sType: StructureType = .device_group_device_create_info,
    pNext: ?*const c_void = null,
    physicalDeviceCount: u32,
    pPhysicalDevices: [*]const PhysicalDevice,
};
pub const DeviceGroupDeviceCreateInfoKHR = DeviceGroupDeviceCreateInfo;
pub const DeviceGroupSwapchainCreateInfoKHR = extern struct {
    sType: StructureType = .device_group_swapchain_create_info_khr,
    pNext: ?*const c_void = null,
    modes: DeviceGroupPresentModeFlagsKHR,
};
pub const DescriptorUpdateTemplateEntry = extern struct {
    dstBinding: u32,
    dstArrayElement: u32,
    descriptorCount: u32,
    descriptorType: DescriptorType,
    offset: usize,
    stride: usize,
};
pub const DescriptorUpdateTemplateEntryKHR = DescriptorUpdateTemplateEntry;
pub const DescriptorUpdateTemplateCreateInfo = extern struct {
    sType: StructureType = .descriptor_update_template_create_info,
    pNext: ?*const c_void = null,
    flags: DescriptorUpdateTemplateCreateFlags,
    descriptorUpdateEntryCount: u32,
    pDescriptorUpdateEntries: [*]const DescriptorUpdateTemplateEntry,
    templateType: DescriptorUpdateTemplateType,
    descriptorSetLayout: DescriptorSetLayout,
    pipelineBindPoint: PipelineBindPoint,
    pipelineLayout: PipelineLayout,
    set: u32,
};
pub const DescriptorUpdateTemplateCreateInfoKHR = DescriptorUpdateTemplateCreateInfo;
pub const XYColorEXT = extern struct {
    x: f32,
    y: f32,
};
pub const HdrMetadataEXT = extern struct {
    sType: StructureType = .hdr_metadata_ext,
    pNext: ?*const c_void = null,
    displayPrimaryRed: XYColorEXT,
    displayPrimaryGreen: XYColorEXT,
    displayPrimaryBlue: XYColorEXT,
    whitePoint: XYColorEXT,
    maxLuminance: f32,
    minLuminance: f32,
    maxContentLightLevel: f32,
    maxFrameAverageLightLevel: f32,
};
pub const DisplayNativeHdrSurfaceCapabilitiesAMD = extern struct {
    sType: StructureType = .display_native_hdr_surface_capabilities_amd,
    pNext: ?*c_void = null,
    localDimmingSupport: Bool32,
};
pub const SwapchainDisplayNativeHdrCreateInfoAMD = extern struct {
    sType: StructureType = .swapchain_display_native_hdr_create_info_amd,
    pNext: ?*const c_void = null,
    localDimmingEnable: Bool32,
};
pub const RefreshCycleDurationGOOGLE = extern struct {
    refreshDuration: u64,
};
pub const PastPresentationTimingGOOGLE = extern struct {
    presentId: u32,
    desiredPresentTime: u64,
    actualPresentTime: u64,
    earliestPresentTime: u64,
    presentMargin: u64,
};
pub const PresentTimesInfoGOOGLE = extern struct {
    sType: StructureType = .present_times_info_google,
    pNext: ?*const c_void = null,
    swapchainCount: u32,
    pTimes: ?[*]const PresentTimeGOOGLE,
};
pub const PresentTimeGOOGLE = extern struct {
    presentId: u32,
    desiredPresentTime: u64,
};
pub const IOSSurfaceCreateInfoMVK = extern struct {
    sType: StructureType = .ios_surface_create_info_mvk,
    pNext: ?*const c_void = null,
    flags: IOSSurfaceCreateFlagsMVK,
    pView: *const c_void,
};
pub const MacOSSurfaceCreateInfoMVK = extern struct {
    sType: StructureType = .macos_surface_create_info_mvk,
    pNext: ?*const c_void = null,
    flags: MacOSSurfaceCreateFlagsMVK,
    pView: *const c_void,
};
pub const MetalSurfaceCreateInfoEXT = extern struct {
    sType: StructureType = .metal_surface_create_info_ext,
    pNext: ?*const c_void = null,
    flags: MetalSurfaceCreateFlagsEXT,
    pLayer: *const CAMetalLayer,
};
pub const ViewportWScalingNV = extern struct {
    xcoeff: f32,
    ycoeff: f32,
};
pub const PipelineViewportWScalingStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_viewport_w_scaling_state_create_info_nv,
    pNext: ?*const c_void = null,
    viewportWScalingEnable: Bool32,
    viewportCount: u32,
    pViewportWScalings: ?[*]const ViewportWScalingNV,
};
pub const ViewportSwizzleNV = extern struct {
    x: ViewportCoordinateSwizzleNV,
    y: ViewportCoordinateSwizzleNV,
    z: ViewportCoordinateSwizzleNV,
    w: ViewportCoordinateSwizzleNV,
};
pub const PipelineViewportSwizzleStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_viewport_swizzle_state_create_info_nv,
    pNext: ?*const c_void = null,
    flags: PipelineViewportSwizzleStateCreateFlagsNV,
    viewportCount: u32,
    pViewportSwizzles: [*]const ViewportSwizzleNV,
};
pub const PhysicalDeviceDiscardRectanglePropertiesEXT = extern struct {
    sType: StructureType = .physical_device_discard_rectangle_properties_ext,
    pNext: ?*c_void = null,
    maxDiscardRectangles: u32,
};
pub const PipelineDiscardRectangleStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_discard_rectangle_state_create_info_ext,
    pNext: ?*const c_void = null,
    flags: PipelineDiscardRectangleStateCreateFlagsEXT,
    discardRectangleMode: DiscardRectangleModeEXT,
    discardRectangleCount: u32,
    pDiscardRectangles: [*]const Rect2D,
};
pub const PhysicalDeviceMultiviewPerViewAttributesPropertiesNVX = extern struct {
    sType: StructureType = .physical_device_multiview_per_view_attributes_properties_nvx,
    pNext: ?*c_void = null,
    perViewPositionAllComponents: Bool32,
};
pub const InputAttachmentAspectReference = extern struct {
    subpass: u32,
    inputAttachmentIndex: u32,
    aspectMask: ImageAspectFlags,
};
pub const InputAttachmentAspectReferenceKHR = InputAttachmentAspectReference;
pub const RenderPassInputAttachmentAspectCreateInfo = extern struct {
    sType: StructureType = .render_pass_input_attachment_aspect_create_info,
    pNext: ?*const c_void = null,
    aspectReferenceCount: u32,
    pAspectReferences: [*]const InputAttachmentAspectReference,
};
pub const RenderPassInputAttachmentAspectCreateInfoKHR = RenderPassInputAttachmentAspectCreateInfo;
pub const PhysicalDeviceSurfaceInfo2KHR = extern struct {
    sType: StructureType = .physical_device_surface_info_2_khr,
    pNext: ?*const c_void = null,
    surface: SurfaceKHR,
};
pub const SurfaceCapabilities2KHR = extern struct {
    sType: StructureType = .surface_capabilities_2_khr,
    pNext: ?*c_void = null,
    surfaceCapabilities: SurfaceCapabilitiesKHR,
};
pub const SurfaceFormat2KHR = extern struct {
    sType: StructureType = .surface_format_2_khr,
    pNext: ?*c_void = null,
    surfaceFormat: SurfaceFormatKHR,
};
pub const DisplayProperties2KHR = extern struct {
    sType: StructureType = .display_properties_2_khr,
    pNext: ?*c_void = null,
    displayProperties: DisplayPropertiesKHR,
};
pub const DisplayPlaneProperties2KHR = extern struct {
    sType: StructureType = .display_plane_properties_2_khr,
    pNext: ?*c_void = null,
    displayPlaneProperties: DisplayPlanePropertiesKHR,
};
pub const DisplayModeProperties2KHR = extern struct {
    sType: StructureType = .display_mode_properties_2_khr,
    pNext: ?*c_void = null,
    displayModeProperties: DisplayModePropertiesKHR,
};
pub const DisplayPlaneInfo2KHR = extern struct {
    sType: StructureType = .display_plane_info_2_khr,
    pNext: ?*const c_void = null,
    mode: DisplayModeKHR,
    planeIndex: u32,
};
pub const DisplayPlaneCapabilities2KHR = extern struct {
    sType: StructureType = .display_plane_capabilities_2_khr,
    pNext: ?*c_void = null,
    capabilities: DisplayPlaneCapabilitiesKHR,
};
pub const SharedPresentSurfaceCapabilitiesKHR = extern struct {
    sType: StructureType = .shared_present_surface_capabilities_khr,
    pNext: ?*c_void = null,
    sharedPresentSupportedUsageFlags: ImageUsageFlags,
};
pub const PhysicalDevice16BitStorageFeatures = extern struct {
    sType: StructureType = .physical_device_16bit_storage_features,
    pNext: ?*c_void = null,
    storageBuffer16BitAccess: Bool32,
    uniformAndStorageBuffer16BitAccess: Bool32,
    storagePushConstant16: Bool32,
    storageInputOutput16: Bool32,
};
pub const PhysicalDevice16BitStorageFeaturesKHR = PhysicalDevice16BitStorageFeatures;
pub const PhysicalDeviceSubgroupProperties = extern struct {
    sType: StructureType = .physical_device_subgroup_properties,
    pNext: ?*c_void = null,
    subgroupSize: u32,
    supportedStages: ShaderStageFlags,
    supportedOperations: SubgroupFeatureFlags,
    quadOperationsInAllStages: Bool32,
};
pub const PhysicalDeviceShaderSubgroupExtendedTypesFeatures = extern struct {
    sType: StructureType = .physical_device_shader_subgroup_extended_types_features,
    pNext: ?*c_void = null,
    shaderSubgroupExtendedTypes: Bool32,
};
pub const PhysicalDeviceShaderSubgroupExtendedTypesFeaturesKHR = PhysicalDeviceShaderSubgroupExtendedTypesFeatures;
pub const BufferMemoryRequirementsInfo2 = extern struct {
    sType: StructureType = .buffer_memory_requirements_info_2,
    pNext: ?*const c_void = null,
    buffer: Buffer,
};
pub const BufferMemoryRequirementsInfo2KHR = BufferMemoryRequirementsInfo2;
pub const ImageMemoryRequirementsInfo2 = extern struct {
    sType: StructureType = .image_memory_requirements_info_2,
    pNext: ?*const c_void = null,
    image: Image,
};
pub const ImageMemoryRequirementsInfo2KHR = ImageMemoryRequirementsInfo2;
pub const ImageSparseMemoryRequirementsInfo2 = extern struct {
    sType: StructureType = .image_sparse_memory_requirements_info_2,
    pNext: ?*const c_void = null,
    image: Image,
};
pub const ImageSparseMemoryRequirementsInfo2KHR = ImageSparseMemoryRequirementsInfo2;
pub const MemoryRequirements2 = extern struct {
    sType: StructureType = .memory_requirements_2,
    pNext: ?*c_void = null,
    memoryRequirements: MemoryRequirements,
};
pub const MemoryRequirements2KHR = MemoryRequirements2;
pub const SparseImageMemoryRequirements2 = extern struct {
    sType: StructureType = .sparse_image_memory_requirements_2,
    pNext: ?*c_void = null,
    memoryRequirements: SparseImageMemoryRequirements,
};
pub const SparseImageMemoryRequirements2KHR = SparseImageMemoryRequirements2;
pub const PhysicalDevicePointClippingProperties = extern struct {
    sType: StructureType = .physical_device_point_clipping_properties,
    pNext: ?*c_void = null,
    pointClippingBehavior: PointClippingBehavior,
};
pub const PhysicalDevicePointClippingPropertiesKHR = PhysicalDevicePointClippingProperties;
pub const MemoryDedicatedRequirements = extern struct {
    sType: StructureType = .memory_dedicated_requirements,
    pNext: ?*c_void = null,
    prefersDedicatedAllocation: Bool32,
    requiresDedicatedAllocation: Bool32,
};
pub const MemoryDedicatedRequirementsKHR = MemoryDedicatedRequirements;
pub const MemoryDedicatedAllocateInfo = extern struct {
    sType: StructureType = .memory_dedicated_allocate_info,
    pNext: ?*const c_void = null,
    image: Image,
    buffer: Buffer,
};
pub const MemoryDedicatedAllocateInfoKHR = MemoryDedicatedAllocateInfo;
pub const ImageViewUsageCreateInfo = extern struct {
    sType: StructureType = .image_view_usage_create_info,
    pNext: ?*const c_void = null,
    usage: ImageUsageFlags,
};
pub const ImageViewUsageCreateInfoKHR = ImageViewUsageCreateInfo;
pub const PipelineTessellationDomainOriginStateCreateInfo = extern struct {
    sType: StructureType = .pipeline_tessellation_domain_origin_state_create_info,
    pNext: ?*const c_void = null,
    domainOrigin: TessellationDomainOrigin,
};
pub const PipelineTessellationDomainOriginStateCreateInfoKHR = PipelineTessellationDomainOriginStateCreateInfo;
pub const SamplerYcbcrConversionInfo = extern struct {
    sType: StructureType = .sampler_ycbcr_conversion_info,
    pNext: ?*const c_void = null,
    conversion: SamplerYcbcrConversion,
};
pub const SamplerYcbcrConversionInfoKHR = SamplerYcbcrConversionInfo;
pub const SamplerYcbcrConversionCreateInfo = extern struct {
    sType: StructureType = .sampler_ycbcr_conversion_create_info,
    pNext: ?*const c_void = null,
    format: Format,
    ycbcrModel: SamplerYcbcrModelConversion,
    ycbcrRange: SamplerYcbcrRange,
    components: ComponentMapping,
    xChromaOffset: ChromaLocation,
    yChromaOffset: ChromaLocation,
    chromaFilter: Filter,
    forceExplicitReconstruction: Bool32,
};
pub const SamplerYcbcrConversionCreateInfoKHR = SamplerYcbcrConversionCreateInfo;
pub const BindImagePlaneMemoryInfo = extern struct {
    sType: StructureType = .bind_image_plane_memory_info,
    pNext: ?*const c_void = null,
    planeAspect: ImageAspectFlags,
};
pub const BindImagePlaneMemoryInfoKHR = BindImagePlaneMemoryInfo;
pub const ImagePlaneMemoryRequirementsInfo = extern struct {
    sType: StructureType = .image_plane_memory_requirements_info,
    pNext: ?*const c_void = null,
    planeAspect: ImageAspectFlags,
};
pub const ImagePlaneMemoryRequirementsInfoKHR = ImagePlaneMemoryRequirementsInfo;
pub const PhysicalDeviceSamplerYcbcrConversionFeatures = extern struct {
    sType: StructureType = .physical_device_sampler_ycbcr_conversion_features,
    pNext: ?*c_void = null,
    samplerYcbcrConversion: Bool32,
};
pub const PhysicalDeviceSamplerYcbcrConversionFeaturesKHR = PhysicalDeviceSamplerYcbcrConversionFeatures;
pub const SamplerYcbcrConversionImageFormatProperties = extern struct {
    sType: StructureType = .sampler_ycbcr_conversion_image_format_properties,
    pNext: ?*c_void = null,
    combinedImageSamplerDescriptorCount: u32,
};
pub const SamplerYcbcrConversionImageFormatPropertiesKHR = SamplerYcbcrConversionImageFormatProperties;
pub const TextureLODGatherFormatPropertiesAMD = extern struct {
    sType: StructureType = .texture_lod_gather_format_properties_amd,
    pNext: ?*c_void = null,
    supportsTextureGatherLodBiasAMD: Bool32,
};
pub const ConditionalRenderingBeginInfoEXT = extern struct {
    sType: StructureType = .conditional_rendering_begin_info_ext,
    pNext: ?*const c_void = null,
    buffer: Buffer,
    offset: DeviceSize,
    flags: ConditionalRenderingFlagsEXT,
};
pub const ProtectedSubmitInfo = extern struct {
    sType: StructureType = .protected_submit_info,
    pNext: ?*const c_void = null,
    protectedSubmit: Bool32,
};
pub const PhysicalDeviceProtectedMemoryFeatures = extern struct {
    sType: StructureType = .physical_device_protected_memory_features,
    pNext: ?*c_void = null,
    protectedMemory: Bool32,
};
pub const PhysicalDeviceProtectedMemoryProperties = extern struct {
    sType: StructureType = .physical_device_protected_memory_properties,
    pNext: ?*c_void = null,
    protectedNoFault: Bool32,
};
pub const DeviceQueueInfo2 = extern struct {
    sType: StructureType = .device_queue_info_2,
    pNext: ?*const c_void = null,
    flags: DeviceQueueCreateFlags,
    queueFamilyIndex: u32,
    queueIndex: u32,
};
pub const PipelineCoverageToColorStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_coverage_to_color_state_create_info_nv,
    pNext: ?*const c_void = null,
    flags: PipelineCoverageToColorStateCreateFlagsNV,
    coverageToColorEnable: Bool32,
    coverageToColorLocation: u32,
};
pub const PhysicalDeviceSamplerFilterMinmaxProperties = extern struct {
    sType: StructureType = .physical_device_sampler_filter_minmax_properties,
    pNext: ?*c_void = null,
    filterMinmaxSingleComponentFormats: Bool32,
    filterMinmaxImageComponentMapping: Bool32,
};
pub const PhysicalDeviceSamplerFilterMinmaxPropertiesEXT = PhysicalDeviceSamplerFilterMinmaxProperties;
pub const SampleLocationEXT = extern struct {
    x: f32,
    y: f32,
};
pub const SampleLocationsInfoEXT = extern struct {
    sType: StructureType = .sample_locations_info_ext,
    pNext: ?*const c_void = null,
    sampleLocationsPerPixel: SampleCountFlags,
    sampleLocationGridSize: Extent2D,
    sampleLocationsCount: u32,
    pSampleLocations: [*]const SampleLocationEXT,
};
pub const AttachmentSampleLocationsEXT = extern struct {
    attachmentIndex: u32,
    sampleLocationsInfo: SampleLocationsInfoEXT,
};
pub const SubpassSampleLocationsEXT = extern struct {
    subpassIndex: u32,
    sampleLocationsInfo: SampleLocationsInfoEXT,
};
pub const RenderPassSampleLocationsBeginInfoEXT = extern struct {
    sType: StructureType = .render_pass_sample_locations_begin_info_ext,
    pNext: ?*const c_void = null,
    attachmentInitialSampleLocationsCount: u32,
    pAttachmentInitialSampleLocations: [*]const AttachmentSampleLocationsEXT,
    postSubpassSampleLocationsCount: u32,
    pPostSubpassSampleLocations: [*]const SubpassSampleLocationsEXT,
};
pub const PipelineSampleLocationsStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_sample_locations_state_create_info_ext,
    pNext: ?*const c_void = null,
    sampleLocationsEnable: Bool32,
    sampleLocationsInfo: SampleLocationsInfoEXT,
};
pub const PhysicalDeviceSampleLocationsPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_sample_locations_properties_ext,
    pNext: ?*c_void = null,
    sampleLocationSampleCounts: SampleCountFlags,
    maxSampleLocationGridSize: Extent2D,
    sampleLocationCoordinateRange: [2]f32,
    sampleLocationSubPixelBits: u32,
    variableSampleLocations: Bool32,
};
pub const MultisamplePropertiesEXT = extern struct {
    sType: StructureType = .multisample_properties_ext,
    pNext: ?*c_void = null,
    maxSampleLocationGridSize: Extent2D,
};
pub const SamplerReductionModeCreateInfo = extern struct {
    sType: StructureType = .sampler_reduction_mode_create_info,
    pNext: ?*const c_void = null,
    reductionMode: SamplerReductionMode,
};
pub const SamplerReductionModeCreateInfoEXT = SamplerReductionModeCreateInfo;
pub const PhysicalDeviceBlendOperationAdvancedFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_blend_operation_advanced_features_ext,
    pNext: ?*c_void = null,
    advancedBlendCoherentOperations: Bool32,
};
pub const PhysicalDeviceBlendOperationAdvancedPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_blend_operation_advanced_properties_ext,
    pNext: ?*c_void = null,
    advancedBlendMaxColorAttachments: u32,
    advancedBlendIndependentBlend: Bool32,
    advancedBlendNonPremultipliedSrcColor: Bool32,
    advancedBlendNonPremultipliedDstColor: Bool32,
    advancedBlendCorrelatedOverlap: Bool32,
    advancedBlendAllOperations: Bool32,
};
pub const PipelineColorBlendAdvancedStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_color_blend_advanced_state_create_info_ext,
    pNext: ?*const c_void = null,
    srcPremultiplied: Bool32,
    dstPremultiplied: Bool32,
    blendOverlap: BlendOverlapEXT,
};
pub const PhysicalDeviceInlineUniformBlockFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_inline_uniform_block_features_ext,
    pNext: ?*c_void = null,
    inlineUniformBlock: Bool32,
    descriptorBindingInlineUniformBlockUpdateAfterBind: Bool32,
};
pub const PhysicalDeviceInlineUniformBlockPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_inline_uniform_block_properties_ext,
    pNext: ?*c_void = null,
    maxInlineUniformBlockSize: u32,
    maxPerStageDescriptorInlineUniformBlocks: u32,
    maxPerStageDescriptorUpdateAfterBindInlineUniformBlocks: u32,
    maxDescriptorSetInlineUniformBlocks: u32,
    maxDescriptorSetUpdateAfterBindInlineUniformBlocks: u32,
};
pub const WriteDescriptorSetInlineUniformBlockEXT = extern struct {
    sType: StructureType = .write_descriptor_set_inline_uniform_block_ext,
    pNext: ?*const c_void = null,
    dataSize: u32,
    pData: *const c_void,
};
pub const DescriptorPoolInlineUniformBlockCreateInfoEXT = extern struct {
    sType: StructureType = .descriptor_pool_inline_uniform_block_create_info_ext,
    pNext: ?*const c_void = null,
    maxInlineUniformBlockBindings: u32,
};
pub const PipelineCoverageModulationStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_coverage_modulation_state_create_info_nv,
    pNext: ?*const c_void = null,
    flags: PipelineCoverageModulationStateCreateFlagsNV,
    coverageModulationMode: CoverageModulationModeNV,
    coverageModulationTableEnable: Bool32,
    coverageModulationTableCount: u32,
    pCoverageModulationTable: ?[*]const f32,
};
pub const ImageFormatListCreateInfo = extern struct {
    sType: StructureType = .image_format_list_create_info,
    pNext: ?*const c_void = null,
    viewFormatCount: u32,
    pViewFormats: [*]const Format,
};
pub const ImageFormatListCreateInfoKHR = ImageFormatListCreateInfo;
pub const ValidationCacheCreateInfoEXT = extern struct {
    sType: StructureType = .validation_cache_create_info_ext,
    pNext: ?*const c_void = null,
    flags: ValidationCacheCreateFlagsEXT,
    initialDataSize: usize,
    pInitialData: *const c_void,
};
pub const ShaderModuleValidationCacheCreateInfoEXT = extern struct {
    sType: StructureType = .shader_module_validation_cache_create_info_ext,
    pNext: ?*const c_void = null,
    validationCache: ValidationCacheEXT,
};
pub const PhysicalDeviceMaintenance3Properties = extern struct {
    sType: StructureType = .physical_device_maintenance_3_properties,
    pNext: ?*c_void = null,
    maxPerSetDescriptors: u32,
    maxMemoryAllocationSize: DeviceSize,
};
pub const PhysicalDeviceMaintenance3PropertiesKHR = PhysicalDeviceMaintenance3Properties;
pub const DescriptorSetLayoutSupport = extern struct {
    sType: StructureType = .descriptor_set_layout_support,
    pNext: ?*c_void = null,
    supported: Bool32,
};
pub const DescriptorSetLayoutSupportKHR = DescriptorSetLayoutSupport;
pub const PhysicalDeviceShaderDrawParametersFeatures = extern struct {
    sType: StructureType = .physical_device_shader_draw_parameters_features,
    pNext: ?*c_void = null,
    shaderDrawParameters: Bool32,
};
pub const PhysicalDeviceShaderDrawParameterFeatures = PhysicalDeviceShaderDrawParametersFeatures;
pub const PhysicalDeviceShaderFloat16Int8Features = extern struct {
    sType: StructureType = .physical_device_shader_float16_int8_features,
    pNext: ?*c_void = null,
    shaderFloat16: Bool32,
    shaderInt8: Bool32,
};
pub const PhysicalDeviceShaderFloat16Int8FeaturesKHR = PhysicalDeviceShaderFloat16Int8Features;
pub const PhysicalDeviceFloat16Int8FeaturesKHR = PhysicalDeviceShaderFloat16Int8Features;
pub const PhysicalDeviceFloatControlsProperties = extern struct {
    sType: StructureType = .physical_device_float_controls_properties,
    pNext: ?*c_void = null,
    denormBehaviorIndependence: ShaderFloatControlsIndependence,
    roundingModeIndependence: ShaderFloatControlsIndependence,
    shaderSignedZeroInfNanPreserveFloat16: Bool32,
    shaderSignedZeroInfNanPreserveFloat32: Bool32,
    shaderSignedZeroInfNanPreserveFloat64: Bool32,
    shaderDenormPreserveFloat16: Bool32,
    shaderDenormPreserveFloat32: Bool32,
    shaderDenormPreserveFloat64: Bool32,
    shaderDenormFlushToZeroFloat16: Bool32,
    shaderDenormFlushToZeroFloat32: Bool32,
    shaderDenormFlushToZeroFloat64: Bool32,
    shaderRoundingModeRteFloat16: Bool32,
    shaderRoundingModeRteFloat32: Bool32,
    shaderRoundingModeRteFloat64: Bool32,
    shaderRoundingModeRtzFloat16: Bool32,
    shaderRoundingModeRtzFloat32: Bool32,
    shaderRoundingModeRtzFloat64: Bool32,
};
pub const PhysicalDeviceFloatControlsPropertiesKHR = PhysicalDeviceFloatControlsProperties;
pub const PhysicalDeviceHostQueryResetFeatures = extern struct {
    sType: StructureType = .physical_device_host_query_reset_features,
    pNext: ?*c_void = null,
    hostQueryReset: Bool32,
};
pub const PhysicalDeviceHostQueryResetFeaturesEXT = PhysicalDeviceHostQueryResetFeatures;
pub const NativeBufferUsage2ANDROID = extern struct {
    consumer: u64,
    producer: u64,
};
pub const NativeBufferANDROID = extern struct {
    sType: StructureType = .native_buffer_android,
    pNext: ?*const c_void = null,
    handle: *const c_void,
    stride: c_int,
    format: c_int,
    usage: c_int,
    usage2: NativeBufferUsage2ANDROID,
};
pub const SwapchainImageCreateInfoANDROID = extern struct {
    sType: StructureType = .swapchain_image_create_info_android,
    pNext: ?*const c_void = null,
    usage: SwapchainImageUsageFlagsANDROID,
};
pub const PhysicalDevicePresentationPropertiesANDROID = extern struct {
    sType: StructureType = .physical_device_presentation_properties_android,
    pNext: ?*const c_void = null,
    sharedImage: Bool32,
};
pub const ShaderResourceUsageAMD = extern struct {
    numUsedVgprs: u32,
    numUsedSgprs: u32,
    ldsSizePerLocalWorkGroup: u32,
    ldsUsageSizeInBytes: usize,
    scratchMemUsageInBytes: usize,
};
pub const ShaderStatisticsInfoAMD = extern struct {
    shaderStageMask: ShaderStageFlags,
    resourceUsage: ShaderResourceUsageAMD,
    numPhysicalVgprs: u32,
    numPhysicalSgprs: u32,
    numAvailableVgprs: u32,
    numAvailableSgprs: u32,
    computeWorkGroupSize: [3]u32,
};
pub const DeviceQueueGlobalPriorityCreateInfoEXT = extern struct {
    sType: StructureType = .device_queue_global_priority_create_info_ext,
    pNext: ?*const c_void = null,
    globalPriority: QueueGlobalPriorityEXT,
};
pub const DebugUtilsObjectNameInfoEXT = extern struct {
    sType: StructureType = .debug_utils_object_name_info_ext,
    pNext: ?*const c_void = null,
    objectType: ObjectType,
    objectHandle: u64,
    pObjectName: ?[*:0]const u8,
};
pub const DebugUtilsObjectTagInfoEXT = extern struct {
    sType: StructureType = .debug_utils_object_tag_info_ext,
    pNext: ?*const c_void = null,
    objectType: ObjectType,
    objectHandle: u64,
    tagName: u64,
    tagSize: usize,
    pTag: *const c_void,
};
pub const DebugUtilsLabelEXT = extern struct {
    sType: StructureType = .debug_utils_label_ext,
    pNext: ?*const c_void = null,
    pLabelName: [*:0]const u8,
    color: [4]f32,
};
pub const DebugUtilsMessengerCreateInfoEXT = extern struct {
    sType: StructureType = .debug_utils_messenger_create_info_ext,
    pNext: ?*const c_void = null,
    flags: DebugUtilsMessengerCreateFlagsEXT,
    messageSeverity: DebugUtilsMessageSeverityFlagsEXT,
    messageType: DebugUtilsMessageTypeFlagsEXT,
    pfnUserCallback: PfnDebugUtilsMessengerCallbackEXT,
    pUserData: ?*c_void,
};
pub const DebugUtilsMessengerCallbackDataEXT = extern struct {
    sType: StructureType = .debug_utils_messenger_callback_data_ext,
    pNext: ?*const c_void = null,
    flags: DebugUtilsMessengerCallbackDataFlagsEXT,
    pMessageIdName: ?[*:0]const u8,
    messageIdNumber: i32,
    pMessage: [*:0]const u8,
    queueLabelCount: u32,
    pQueueLabels: [*]const DebugUtilsLabelEXT,
    cmdBufLabelCount: u32,
    pCmdBufLabels: [*]const DebugUtilsLabelEXT,
    objectCount: u32,
    pObjects: [*]const DebugUtilsObjectNameInfoEXT,
};
pub const PhysicalDeviceDeviceMemoryReportFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_device_memory_report_features_ext,
    pNext: ?*c_void = null,
    deviceMemoryReport: Bool32,
};
pub const DeviceDeviceMemoryReportCreateInfoEXT = extern struct {
    sType: StructureType = .device_device_memory_report_create_info_ext,
    pNext: ?*const c_void = null,
    flags: DeviceMemoryReportFlagsEXT,
    pfnUserCallback: PfnDeviceMemoryReportCallbackEXT,
    pUserData: *c_void,
};
pub const DeviceMemoryReportCallbackDataEXT = extern struct {
    sType: StructureType = .device_memory_report_callback_data_ext,
    pNext: ?*const c_void = null,
    flags: DeviceMemoryReportFlagsEXT,
    type: DeviceMemoryReportEventTypeEXT,
    memoryObjectId: u64,
    size: DeviceSize,
    objectType: ObjectType,
    objectHandle: u64,
    heapIndex: u32,
};
pub const ImportMemoryHostPointerInfoEXT = extern struct {
    sType: StructureType = .import_memory_host_pointer_info_ext,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlags,
    pHostPointer: *c_void,
};
pub const MemoryHostPointerPropertiesEXT = extern struct {
    sType: StructureType = .memory_host_pointer_properties_ext,
    pNext: ?*c_void = null,
    memoryTypeBits: u32,
};
pub const PhysicalDeviceExternalMemoryHostPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_external_memory_host_properties_ext,
    pNext: ?*c_void = null,
    minImportedHostPointerAlignment: DeviceSize,
};
pub const PhysicalDeviceConservativeRasterizationPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_conservative_rasterization_properties_ext,
    pNext: ?*c_void = null,
    primitiveOverestimationSize: f32,
    maxExtraPrimitiveOverestimationSize: f32,
    extraPrimitiveOverestimationSizeGranularity: f32,
    primitiveUnderestimation: Bool32,
    conservativePointAndLineRasterization: Bool32,
    degenerateTrianglesRasterized: Bool32,
    degenerateLinesRasterized: Bool32,
    fullyCoveredFragmentShaderInputVariable: Bool32,
    conservativeRasterizationPostDepthCoverage: Bool32,
};
pub const CalibratedTimestampInfoEXT = extern struct {
    sType: StructureType = .calibrated_timestamp_info_ext,
    pNext: ?*const c_void = null,
    timeDomain: TimeDomainEXT,
};
pub const PhysicalDeviceShaderCorePropertiesAMD = extern struct {
    sType: StructureType = .physical_device_shader_core_properties_amd,
    pNext: ?*c_void = null,
    shaderEngineCount: u32,
    shaderArraysPerEngineCount: u32,
    computeUnitsPerShaderArray: u32,
    simdPerComputeUnit: u32,
    wavefrontsPerSimd: u32,
    wavefrontSize: u32,
    sgprsPerSimd: u32,
    minSgprAllocation: u32,
    maxSgprAllocation: u32,
    sgprAllocationGranularity: u32,
    vgprsPerSimd: u32,
    minVgprAllocation: u32,
    maxVgprAllocation: u32,
    vgprAllocationGranularity: u32,
};
pub const PhysicalDeviceShaderCoreProperties2AMD = extern struct {
    sType: StructureType = .physical_device_shader_core_properties_2_amd,
    pNext: ?*c_void = null,
    shaderCoreFeatures: ShaderCorePropertiesFlagsAMD,
    activeComputeUnitCount: u32,
};
pub const PipelineRasterizationConservativeStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_rasterization_conservative_state_create_info_ext,
    pNext: ?*const c_void = null,
    flags: PipelineRasterizationConservativeStateCreateFlagsEXT,
    conservativeRasterizationMode: ConservativeRasterizationModeEXT,
    extraPrimitiveOverestimationSize: f32,
};
pub const PhysicalDeviceDescriptorIndexingFeatures = extern struct {
    sType: StructureType = .physical_device_descriptor_indexing_features,
    pNext: ?*c_void = null,
    shaderInputAttachmentArrayDynamicIndexing: Bool32,
    shaderUniformTexelBufferArrayDynamicIndexing: Bool32,
    shaderStorageTexelBufferArrayDynamicIndexing: Bool32,
    shaderUniformBufferArrayNonUniformIndexing: Bool32,
    shaderSampledImageArrayNonUniformIndexing: Bool32,
    shaderStorageBufferArrayNonUniformIndexing: Bool32,
    shaderStorageImageArrayNonUniformIndexing: Bool32,
    shaderInputAttachmentArrayNonUniformIndexing: Bool32,
    shaderUniformTexelBufferArrayNonUniformIndexing: Bool32,
    shaderStorageTexelBufferArrayNonUniformIndexing: Bool32,
    descriptorBindingUniformBufferUpdateAfterBind: Bool32,
    descriptorBindingSampledImageUpdateAfterBind: Bool32,
    descriptorBindingStorageImageUpdateAfterBind: Bool32,
    descriptorBindingStorageBufferUpdateAfterBind: Bool32,
    descriptorBindingUniformTexelBufferUpdateAfterBind: Bool32,
    descriptorBindingStorageTexelBufferUpdateAfterBind: Bool32,
    descriptorBindingUpdateUnusedWhilePending: Bool32,
    descriptorBindingPartiallyBound: Bool32,
    descriptorBindingVariableDescriptorCount: Bool32,
    runtimeDescriptorArray: Bool32,
};
pub const PhysicalDeviceDescriptorIndexingFeaturesEXT = PhysicalDeviceDescriptorIndexingFeatures;
pub const PhysicalDeviceDescriptorIndexingProperties = extern struct {
    sType: StructureType = .physical_device_descriptor_indexing_properties,
    pNext: ?*c_void = null,
    maxUpdateAfterBindDescriptorsInAllPools: u32,
    shaderUniformBufferArrayNonUniformIndexingNative: Bool32,
    shaderSampledImageArrayNonUniformIndexingNative: Bool32,
    shaderStorageBufferArrayNonUniformIndexingNative: Bool32,
    shaderStorageImageArrayNonUniformIndexingNative: Bool32,
    shaderInputAttachmentArrayNonUniformIndexingNative: Bool32,
    robustBufferAccessUpdateAfterBind: Bool32,
    quadDivergentImplicitLod: Bool32,
    maxPerStageDescriptorUpdateAfterBindSamplers: u32,
    maxPerStageDescriptorUpdateAfterBindUniformBuffers: u32,
    maxPerStageDescriptorUpdateAfterBindStorageBuffers: u32,
    maxPerStageDescriptorUpdateAfterBindSampledImages: u32,
    maxPerStageDescriptorUpdateAfterBindStorageImages: u32,
    maxPerStageDescriptorUpdateAfterBindInputAttachments: u32,
    maxPerStageUpdateAfterBindResources: u32,
    maxDescriptorSetUpdateAfterBindSamplers: u32,
    maxDescriptorSetUpdateAfterBindUniformBuffers: u32,
    maxDescriptorSetUpdateAfterBindUniformBuffersDynamic: u32,
    maxDescriptorSetUpdateAfterBindStorageBuffers: u32,
    maxDescriptorSetUpdateAfterBindStorageBuffersDynamic: u32,
    maxDescriptorSetUpdateAfterBindSampledImages: u32,
    maxDescriptorSetUpdateAfterBindStorageImages: u32,
    maxDescriptorSetUpdateAfterBindInputAttachments: u32,
};
pub const PhysicalDeviceDescriptorIndexingPropertiesEXT = PhysicalDeviceDescriptorIndexingProperties;
pub const DescriptorSetLayoutBindingFlagsCreateInfo = extern struct {
    sType: StructureType = .descriptor_set_layout_binding_flags_create_info,
    pNext: ?*const c_void = null,
    bindingCount: u32,
    pBindingFlags: [*]const DescriptorBindingFlags,
};
pub const DescriptorSetLayoutBindingFlagsCreateInfoEXT = DescriptorSetLayoutBindingFlagsCreateInfo;
pub const DescriptorSetVariableDescriptorCountAllocateInfo = extern struct {
    sType: StructureType = .descriptor_set_variable_descriptor_count_allocate_info,
    pNext: ?*const c_void = null,
    descriptorSetCount: u32,
    pDescriptorCounts: [*]const u32,
};
pub const DescriptorSetVariableDescriptorCountAllocateInfoEXT = DescriptorSetVariableDescriptorCountAllocateInfo;
pub const DescriptorSetVariableDescriptorCountLayoutSupport = extern struct {
    sType: StructureType = .descriptor_set_variable_descriptor_count_layout_support,
    pNext: ?*c_void = null,
    maxVariableDescriptorCount: u32,
};
pub const DescriptorSetVariableDescriptorCountLayoutSupportEXT = DescriptorSetVariableDescriptorCountLayoutSupport;
pub const AttachmentDescription2 = extern struct {
    sType: StructureType = .attachment_description_2,
    pNext: ?*const c_void = null,
    flags: AttachmentDescriptionFlags,
    format: Format,
    samples: SampleCountFlags,
    loadOp: AttachmentLoadOp,
    storeOp: AttachmentStoreOp,
    stencilLoadOp: AttachmentLoadOp,
    stencilStoreOp: AttachmentStoreOp,
    initialLayout: ImageLayout,
    finalLayout: ImageLayout,
};
pub const AttachmentDescription2KHR = AttachmentDescription2;
pub const AttachmentReference2 = extern struct {
    sType: StructureType = .attachment_reference_2,
    pNext: ?*const c_void = null,
    attachment: u32,
    layout: ImageLayout,
    aspectMask: ImageAspectFlags,
};
pub const AttachmentReference2KHR = AttachmentReference2;
pub const SubpassDescription2 = extern struct {
    sType: StructureType = .subpass_description_2,
    pNext: ?*const c_void = null,
    flags: SubpassDescriptionFlags,
    pipelineBindPoint: PipelineBindPoint,
    viewMask: u32,
    inputAttachmentCount: u32,
    pInputAttachments: [*]const AttachmentReference2,
    colorAttachmentCount: u32,
    pColorAttachments: [*]const AttachmentReference2,
    pResolveAttachments: ?[*]const AttachmentReference2,
    pDepthStencilAttachment: ?*const AttachmentReference2,
    preserveAttachmentCount: u32,
    pPreserveAttachments: [*]const u32,
};
pub const SubpassDescription2KHR = SubpassDescription2;
pub const SubpassDependency2 = extern struct {
    sType: StructureType = .subpass_dependency_2,
    pNext: ?*const c_void = null,
    srcSubpass: u32,
    dstSubpass: u32,
    srcStageMask: PipelineStageFlags,
    dstStageMask: PipelineStageFlags,
    srcAccessMask: AccessFlags,
    dstAccessMask: AccessFlags,
    dependencyFlags: DependencyFlags,
    viewOffset: i32,
};
pub const SubpassDependency2KHR = SubpassDependency2;
pub const RenderPassCreateInfo2 = extern struct {
    sType: StructureType = .render_pass_create_info_2,
    pNext: ?*const c_void = null,
    flags: RenderPassCreateFlags,
    attachmentCount: u32,
    pAttachments: [*]const AttachmentDescription2,
    subpassCount: u32,
    pSubpasses: [*]const SubpassDescription2,
    dependencyCount: u32,
    pDependencies: [*]const SubpassDependency2,
    correlatedViewMaskCount: u32,
    pCorrelatedViewMasks: [*]const u32,
};
pub const RenderPassCreateInfo2KHR = RenderPassCreateInfo2;
pub const SubpassBeginInfo = extern struct {
    sType: StructureType = .subpass_begin_info,
    pNext: ?*const c_void = null,
    contents: SubpassContents,
};
pub const SubpassBeginInfoKHR = SubpassBeginInfo;
pub const SubpassEndInfo = extern struct {
    sType: StructureType = .subpass_end_info,
    pNext: ?*const c_void = null,
};
pub const SubpassEndInfoKHR = SubpassEndInfo;
pub const PhysicalDeviceTimelineSemaphoreFeatures = extern struct {
    sType: StructureType = .physical_device_timeline_semaphore_features,
    pNext: ?*c_void = null,
    timelineSemaphore: Bool32,
};
pub const PhysicalDeviceTimelineSemaphoreFeaturesKHR = PhysicalDeviceTimelineSemaphoreFeatures;
pub const PhysicalDeviceTimelineSemaphoreProperties = extern struct {
    sType: StructureType = .physical_device_timeline_semaphore_properties,
    pNext: ?*c_void = null,
    maxTimelineSemaphoreValueDifference: u64,
};
pub const PhysicalDeviceTimelineSemaphorePropertiesKHR = PhysicalDeviceTimelineSemaphoreProperties;
pub const SemaphoreTypeCreateInfo = extern struct {
    sType: StructureType = .semaphore_type_create_info,
    pNext: ?*const c_void = null,
    semaphoreType: SemaphoreType,
    initialValue: u64,
};
pub const SemaphoreTypeCreateInfoKHR = SemaphoreTypeCreateInfo;
pub const TimelineSemaphoreSubmitInfo = extern struct {
    sType: StructureType = .timeline_semaphore_submit_info,
    pNext: ?*const c_void = null,
    waitSemaphoreValueCount: u32,
    pWaitSemaphoreValues: ?[*]const u64,
    signalSemaphoreValueCount: u32,
    pSignalSemaphoreValues: ?[*]const u64,
};
pub const TimelineSemaphoreSubmitInfoKHR = TimelineSemaphoreSubmitInfo;
pub const SemaphoreWaitInfo = extern struct {
    sType: StructureType = .semaphore_wait_info,
    pNext: ?*const c_void = null,
    flags: SemaphoreWaitFlags,
    semaphoreCount: u32,
    pSemaphores: [*]const Semaphore,
    pValues: [*]const u64,
};
pub const SemaphoreWaitInfoKHR = SemaphoreWaitInfo;
pub const SemaphoreSignalInfo = extern struct {
    sType: StructureType = .semaphore_signal_info,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    value: u64,
};
pub const SemaphoreSignalInfoKHR = SemaphoreSignalInfo;
pub const VertexInputBindingDivisorDescriptionEXT = extern struct {
    binding: u32,
    divisor: u32,
};
pub const PipelineVertexInputDivisorStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_vertex_input_divisor_state_create_info_ext,
    pNext: ?*const c_void = null,
    vertexBindingDivisorCount: u32,
    pVertexBindingDivisors: [*]const VertexInputBindingDivisorDescriptionEXT,
};
pub const PhysicalDeviceVertexAttributeDivisorPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_vertex_attribute_divisor_properties_ext,
    pNext: ?*c_void = null,
    maxVertexAttribDivisor: u32,
};
pub const PhysicalDevicePCIBusInfoPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_pci_bus_info_properties_ext,
    pNext: ?*c_void = null,
    pciDomain: u32,
    pciBus: u32,
    pciDevice: u32,
    pciFunction: u32,
};
pub const ImportAndroidHardwareBufferInfoANDROID = extern struct {
    sType: StructureType = .import_android_hardware_buffer_info_android,
    pNext: ?*const c_void = null,
    buffer: *AHardwareBuffer,
};
pub const AndroidHardwareBufferUsageANDROID = extern struct {
    sType: StructureType = .android_hardware_buffer_usage_android,
    pNext: ?*c_void = null,
    androidHardwareBufferUsage: u64,
};
pub const AndroidHardwareBufferPropertiesANDROID = extern struct {
    sType: StructureType = .android_hardware_buffer_properties_android,
    pNext: ?*c_void = null,
    allocationSize: DeviceSize,
    memoryTypeBits: u32,
};
pub const MemoryGetAndroidHardwareBufferInfoANDROID = extern struct {
    sType: StructureType = .memory_get_android_hardware_buffer_info_android,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
};
pub const AndroidHardwareBufferFormatPropertiesANDROID = extern struct {
    sType: StructureType = .android_hardware_buffer_format_properties_android,
    pNext: ?*c_void = null,
    format: Format,
    externalFormat: u64,
    formatFeatures: FormatFeatureFlags,
    samplerYcbcrConversionComponents: ComponentMapping,
    suggestedYcbcrModel: SamplerYcbcrModelConversion,
    suggestedYcbcrRange: SamplerYcbcrRange,
    suggestedXChromaOffset: ChromaLocation,
    suggestedYChromaOffset: ChromaLocation,
};
pub const CommandBufferInheritanceConditionalRenderingInfoEXT = extern struct {
    sType: StructureType = .command_buffer_inheritance_conditional_rendering_info_ext,
    pNext: ?*const c_void = null,
    conditionalRenderingEnable: Bool32,
};
pub const ExternalFormatANDROID = extern struct {
    sType: StructureType = .external_format_android,
    pNext: ?*c_void = null,
    externalFormat: u64,
};
pub const PhysicalDevice8BitStorageFeatures = extern struct {
    sType: StructureType = .physical_device_8bit_storage_features,
    pNext: ?*c_void = null,
    storageBuffer8BitAccess: Bool32,
    uniformAndStorageBuffer8BitAccess: Bool32,
    storagePushConstant8: Bool32,
};
pub const PhysicalDevice8BitStorageFeaturesKHR = PhysicalDevice8BitStorageFeatures;
pub const PhysicalDeviceConditionalRenderingFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_conditional_rendering_features_ext,
    pNext: ?*c_void = null,
    conditionalRendering: Bool32,
    inheritedConditionalRendering: Bool32,
};
pub const PhysicalDeviceVulkanMemoryModelFeatures = extern struct {
    sType: StructureType = .physical_device_vulkan_memory_model_features,
    pNext: ?*c_void = null,
    vulkanMemoryModel: Bool32,
    vulkanMemoryModelDeviceScope: Bool32,
    vulkanMemoryModelAvailabilityVisibilityChains: Bool32,
};
pub const PhysicalDeviceVulkanMemoryModelFeaturesKHR = PhysicalDeviceVulkanMemoryModelFeatures;
pub const PhysicalDeviceShaderAtomicInt64Features = extern struct {
    sType: StructureType = .physical_device_shader_atomic_int64_features,
    pNext: ?*c_void = null,
    shaderBufferInt64Atomics: Bool32,
    shaderSharedInt64Atomics: Bool32,
};
pub const PhysicalDeviceShaderAtomicInt64FeaturesKHR = PhysicalDeviceShaderAtomicInt64Features;
pub const PhysicalDeviceShaderAtomicFloatFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_shader_atomic_float_features_ext,
    pNext: ?*c_void = null,
    shaderBufferFloat32Atomics: Bool32,
    shaderBufferFloat32AtomicAdd: Bool32,
    shaderBufferFloat64Atomics: Bool32,
    shaderBufferFloat64AtomicAdd: Bool32,
    shaderSharedFloat32Atomics: Bool32,
    shaderSharedFloat32AtomicAdd: Bool32,
    shaderSharedFloat64Atomics: Bool32,
    shaderSharedFloat64AtomicAdd: Bool32,
    shaderImageFloat32Atomics: Bool32,
    shaderImageFloat32AtomicAdd: Bool32,
    sparseImageFloat32Atomics: Bool32,
    sparseImageFloat32AtomicAdd: Bool32,
};
pub const PhysicalDeviceVertexAttributeDivisorFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_vertex_attribute_divisor_features_ext,
    pNext: ?*c_void = null,
    vertexAttributeInstanceRateDivisor: Bool32,
    vertexAttributeInstanceRateZeroDivisor: Bool32,
};
pub const QueueFamilyCheckpointPropertiesNV = extern struct {
    sType: StructureType = .queue_family_checkpoint_properties_nv,
    pNext: ?*c_void = null,
    checkpointExecutionStageMask: PipelineStageFlags,
};
pub const CheckpointDataNV = extern struct {
    sType: StructureType = .checkpoint_data_nv,
    pNext: ?*c_void = null,
    stage: PipelineStageFlags,
    pCheckpointMarker: *c_void,
};
pub const PhysicalDeviceDepthStencilResolveProperties = extern struct {
    sType: StructureType = .physical_device_depth_stencil_resolve_properties,
    pNext: ?*c_void = null,
    supportedDepthResolveModes: ResolveModeFlags,
    supportedStencilResolveModes: ResolveModeFlags,
    independentResolveNone: Bool32,
    independentResolve: Bool32,
};
pub const PhysicalDeviceDepthStencilResolvePropertiesKHR = PhysicalDeviceDepthStencilResolveProperties;
pub const SubpassDescriptionDepthStencilResolve = extern struct {
    sType: StructureType = .subpass_description_depth_stencil_resolve,
    pNext: ?*const c_void = null,
    depthResolveMode: ResolveModeFlags,
    stencilResolveMode: ResolveModeFlags,
    pDepthStencilResolveAttachment: ?*const AttachmentReference2,
};
pub const SubpassDescriptionDepthStencilResolveKHR = SubpassDescriptionDepthStencilResolve;
pub const ImageViewASTCDecodeModeEXT = extern struct {
    sType: StructureType = .image_view_astc_decode_mode_ext,
    pNext: ?*const c_void = null,
    decodeMode: Format,
};
pub const PhysicalDeviceASTCDecodeFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_astc_decode_features_ext,
    pNext: ?*c_void = null,
    decodeModeSharedExponent: Bool32,
};
pub const PhysicalDeviceTransformFeedbackFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_transform_feedback_features_ext,
    pNext: ?*c_void = null,
    transformFeedback: Bool32,
    geometryStreams: Bool32,
};
pub const PhysicalDeviceTransformFeedbackPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_transform_feedback_properties_ext,
    pNext: ?*c_void = null,
    maxTransformFeedbackStreams: u32,
    maxTransformFeedbackBuffers: u32,
    maxTransformFeedbackBufferSize: DeviceSize,
    maxTransformFeedbackStreamDataSize: u32,
    maxTransformFeedbackBufferDataSize: u32,
    maxTransformFeedbackBufferDataStride: u32,
    transformFeedbackQueries: Bool32,
    transformFeedbackStreamsLinesTriangles: Bool32,
    transformFeedbackRasterizationStreamSelect: Bool32,
    transformFeedbackDraw: Bool32,
};
pub const PipelineRasterizationStateStreamCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_rasterization_state_stream_create_info_ext,
    pNext: ?*const c_void = null,
    flags: PipelineRasterizationStateStreamCreateFlagsEXT,
    rasterizationStream: u32,
};
pub const PhysicalDeviceRepresentativeFragmentTestFeaturesNV = extern struct {
    sType: StructureType = .physical_device_representative_fragment_test_features_nv,
    pNext: ?*c_void = null,
    representativeFragmentTest: Bool32,
};
pub const PipelineRepresentativeFragmentTestStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_representative_fragment_test_state_create_info_nv,
    pNext: ?*const c_void = null,
    representativeFragmentTestEnable: Bool32,
};
pub const PhysicalDeviceExclusiveScissorFeaturesNV = extern struct {
    sType: StructureType = .physical_device_exclusive_scissor_features_nv,
    pNext: ?*c_void = null,
    exclusiveScissor: Bool32,
};
pub const PipelineViewportExclusiveScissorStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_viewport_exclusive_scissor_state_create_info_nv,
    pNext: ?*const c_void = null,
    exclusiveScissorCount: u32,
    pExclusiveScissors: [*]const Rect2D,
};
pub const PhysicalDeviceCornerSampledImageFeaturesNV = extern struct {
    sType: StructureType = .physical_device_corner_sampled_image_features_nv,
    pNext: ?*c_void = null,
    cornerSampledImage: Bool32,
};
pub const PhysicalDeviceComputeShaderDerivativesFeaturesNV = extern struct {
    sType: StructureType = .physical_device_compute_shader_derivatives_features_nv,
    pNext: ?*c_void = null,
    computeDerivativeGroupQuads: Bool32,
    computeDerivativeGroupLinear: Bool32,
};
pub const PhysicalDeviceFragmentShaderBarycentricFeaturesNV = extern struct {
    sType: StructureType = .physical_device_fragment_shader_barycentric_features_nv,
    pNext: ?*c_void = null,
    fragmentShaderBarycentric: Bool32,
};
pub const PhysicalDeviceShaderImageFootprintFeaturesNV = extern struct {
    sType: StructureType = .physical_device_shader_image_footprint_features_nv,
    pNext: ?*c_void = null,
    imageFootprint: Bool32,
};
pub const PhysicalDeviceDedicatedAllocationImageAliasingFeaturesNV = extern struct {
    sType: StructureType = .physical_device_dedicated_allocation_image_aliasing_features_nv,
    pNext: ?*c_void = null,
    dedicatedAllocationImageAliasing: Bool32,
};
pub const ShadingRatePaletteNV = extern struct {
    shadingRatePaletteEntryCount: u32,
    pShadingRatePaletteEntries: [*]const ShadingRatePaletteEntryNV,
};
pub const PipelineViewportShadingRateImageStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_viewport_shading_rate_image_state_create_info_nv,
    pNext: ?*const c_void = null,
    shadingRateImageEnable: Bool32,
    viewportCount: u32,
    pShadingRatePalettes: [*]const ShadingRatePaletteNV,
};
pub const PhysicalDeviceShadingRateImageFeaturesNV = extern struct {
    sType: StructureType = .physical_device_shading_rate_image_features_nv,
    pNext: ?*c_void = null,
    shadingRateImage: Bool32,
    shadingRateCoarseSampleOrder: Bool32,
};
pub const PhysicalDeviceShadingRateImagePropertiesNV = extern struct {
    sType: StructureType = .physical_device_shading_rate_image_properties_nv,
    pNext: ?*c_void = null,
    shadingRateTexelSize: Extent2D,
    shadingRatePaletteSize: u32,
    shadingRateMaxCoarseSamples: u32,
};
pub const CoarseSampleLocationNV = extern struct {
    pixelX: u32,
    pixelY: u32,
    sample: u32,
};
pub const CoarseSampleOrderCustomNV = extern struct {
    shadingRate: ShadingRatePaletteEntryNV,
    sampleCount: u32,
    sampleLocationCount: u32,
    pSampleLocations: [*]const CoarseSampleLocationNV,
};
pub const PipelineViewportCoarseSampleOrderStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_viewport_coarse_sample_order_state_create_info_nv,
    pNext: ?*const c_void = null,
    sampleOrderType: CoarseSampleOrderTypeNV,
    customSampleOrderCount: u32,
    pCustomSampleOrders: [*]const CoarseSampleOrderCustomNV,
};
pub const PhysicalDeviceMeshShaderFeaturesNV = extern struct {
    sType: StructureType = .physical_device_mesh_shader_features_nv,
    pNext: ?*c_void = null,
    taskShader: Bool32,
    meshShader: Bool32,
};
pub const PhysicalDeviceMeshShaderPropertiesNV = extern struct {
    sType: StructureType = .physical_device_mesh_shader_properties_nv,
    pNext: ?*c_void = null,
    maxDrawMeshTasksCount: u32,
    maxTaskWorkGroupInvocations: u32,
    maxTaskWorkGroupSize: [3]u32,
    maxTaskTotalMemorySize: u32,
    maxTaskOutputCount: u32,
    maxMeshWorkGroupInvocations: u32,
    maxMeshWorkGroupSize: [3]u32,
    maxMeshTotalMemorySize: u32,
    maxMeshOutputVertices: u32,
    maxMeshOutputPrimitives: u32,
    maxMeshMultiviewViewCount: u32,
    meshOutputPerVertexGranularity: u32,
    meshOutputPerPrimitiveGranularity: u32,
};
pub const DrawMeshTasksIndirectCommandNV = extern struct {
    taskCount: u32,
    firstTask: u32,
};
pub const RayTracingShaderGroupCreateInfoNV = extern struct {
    sType: StructureType = .ray_tracing_shader_group_create_info_nv,
    pNext: ?*const c_void = null,
    type: RayTracingShaderGroupTypeKHR,
    generalShader: u32,
    closestHitShader: u32,
    anyHitShader: u32,
    intersectionShader: u32,
};
pub const RayTracingShaderGroupCreateInfoKHR = extern struct {
    sType: StructureType = .ray_tracing_shader_group_create_info_khr,
    pNext: ?*const c_void = null,
    type: RayTracingShaderGroupTypeKHR,
    generalShader: u32,
    closestHitShader: u32,
    anyHitShader: u32,
    intersectionShader: u32,
    pShaderGroupCaptureReplayHandle: ?*const c_void,
};
pub const RayTracingPipelineCreateInfoNV = extern struct {
    sType: StructureType = .ray_tracing_pipeline_create_info_nv,
    pNext: ?*const c_void = null,
    flags: PipelineCreateFlags,
    stageCount: u32,
    pStages: [*]const PipelineShaderStageCreateInfo,
    groupCount: u32,
    pGroups: [*]const RayTracingShaderGroupCreateInfoNV,
    maxRecursionDepth: u32,
    layout: PipelineLayout,
    basePipelineHandle: Pipeline,
    basePipelineIndex: i32,
};
pub const RayTracingPipelineCreateInfoKHR = extern struct {
    sType: StructureType = .ray_tracing_pipeline_create_info_khr,
    pNext: ?*const c_void = null,
    flags: PipelineCreateFlags,
    stageCount: u32,
    pStages: [*]const PipelineShaderStageCreateInfo,
    groupCount: u32,
    pGroups: [*]const RayTracingShaderGroupCreateInfoKHR,
    maxPipelineRayRecursionDepth: u32,
    pLibraryInfo: ?*const PipelineLibraryCreateInfoKHR,
    pLibraryInterface: ?*const RayTracingPipelineInterfaceCreateInfoKHR,
    pDynamicState: ?*const PipelineDynamicStateCreateInfo,
    layout: PipelineLayout,
    basePipelineHandle: Pipeline,
    basePipelineIndex: i32,
};
pub const GeometryTrianglesNV = extern struct {
    sType: StructureType = .geometry_triangles_nv,
    pNext: ?*const c_void = null,
    vertexData: Buffer,
    vertexOffset: DeviceSize,
    vertexCount: u32,
    vertexStride: DeviceSize,
    vertexFormat: Format,
    indexData: Buffer,
    indexOffset: DeviceSize,
    indexCount: u32,
    indexType: IndexType,
    transformData: Buffer,
    transformOffset: DeviceSize,
};
pub const GeometryAABBNV = extern struct {
    sType: StructureType = .geometry_aabb_nv,
    pNext: ?*const c_void = null,
    aabbData: Buffer,
    numAabBs: u32,
    stride: u32,
    offset: DeviceSize,
};
pub const GeometryDataNV = extern struct {
    triangles: GeometryTrianglesNV,
    aabbs: GeometryAABBNV,
};
pub const GeometryNV = extern struct {
    sType: StructureType = .geometry_nv,
    pNext: ?*const c_void = null,
    geometryType: GeometryTypeKHR,
    geometry: GeometryDataNV,
    flags: GeometryFlagsKHR,
};
pub const AccelerationStructureInfoNV = extern struct {
    sType: StructureType = .acceleration_structure_info_nv,
    pNext: ?*const c_void = null,
    type: AccelerationStructureTypeNV,
    flags: BuildAccelerationStructureFlagsNV,
    instanceCount: u32,
    geometryCount: u32,
    pGeometries: [*]const GeometryNV,
};
pub const AccelerationStructureCreateInfoNV = extern struct {
    sType: StructureType = .acceleration_structure_create_info_nv,
    pNext: ?*const c_void = null,
    compactedSize: DeviceSize,
    info: AccelerationStructureInfoNV,
};
pub const BindAccelerationStructureMemoryInfoNV = extern struct {
    sType: StructureType = .bind_acceleration_structure_memory_info_nv,
    pNext: ?*const c_void = null,
    accelerationStructure: AccelerationStructureNV,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
    deviceIndexCount: u32,
    pDeviceIndices: [*]const u32,
};
pub const WriteDescriptorSetAccelerationStructureKHR = extern struct {
    sType: StructureType = .write_descriptor_set_acceleration_structure_khr,
    pNext: ?*const c_void = null,
    accelerationStructureCount: u32,
    pAccelerationStructures: [*]const AccelerationStructureKHR,
};
pub const WriteDescriptorSetAccelerationStructureNV = extern struct {
    sType: StructureType = .write_descriptor_set_acceleration_structure_nv,
    pNext: ?*const c_void = null,
    accelerationStructureCount: u32,
    pAccelerationStructures: [*]const AccelerationStructureNV,
};
pub const AccelerationStructureMemoryRequirementsInfoNV = extern struct {
    sType: StructureType = .acceleration_structure_memory_requirements_info_nv,
    pNext: ?*const c_void = null,
    type: AccelerationStructureMemoryRequirementsTypeNV,
    accelerationStructure: AccelerationStructureNV,
};
pub const PhysicalDeviceAccelerationStructureFeaturesKHR = extern struct {
    sType: StructureType = .physical_device_acceleration_structure_features_khr,
    pNext: ?*c_void = null,
    accelerationStructure: Bool32,
    accelerationStructureCaptureReplay: Bool32,
    accelerationStructureIndirectBuild: Bool32,
    accelerationStructureHostCommands: Bool32,
    descriptorBindingAccelerationStructureUpdateAfterBind: Bool32,
};
pub const PhysicalDeviceRayTracingPipelineFeaturesKHR = extern struct {
    sType: StructureType = .physical_device_ray_tracing_pipeline_features_khr,
    pNext: ?*c_void = null,
    rayTracingPipeline: Bool32,
    rayTracingPipelineShaderGroupHandleCaptureReplay: Bool32,
    rayTracingPipelineShaderGroupHandleCaptureReplayMixed: Bool32,
    rayTracingPipelineTraceRaysIndirect: Bool32,
    rayTraversalPrimitiveCulling: Bool32,
};
pub const PhysicalDeviceRayQueryFeaturesKHR = extern struct {
    sType: StructureType = .physical_device_ray_query_features_khr,
    pNext: ?*c_void = null,
    rayQuery: Bool32,
};
pub const PhysicalDeviceAccelerationStructurePropertiesKHR = extern struct {
    sType: StructureType = .physical_device_acceleration_structure_properties_khr,
    pNext: ?*c_void = null,
    maxGeometryCount: u64,
    maxInstanceCount: u64,
    maxPrimitiveCount: u64,
    maxPerStageDescriptorAccelerationStructures: u32,
    maxPerStageDescriptorUpdateAfterBindAccelerationStructures: u32,
    maxDescriptorSetAccelerationStructures: u32,
    maxDescriptorSetUpdateAfterBindAccelerationStructures: u32,
    minAccelerationStructureScratchOffsetAlignment: u32,
};
pub const PhysicalDeviceRayTracingPipelinePropertiesKHR = extern struct {
    sType: StructureType = .physical_device_ray_tracing_pipeline_properties_khr,
    pNext: ?*c_void = null,
    shaderGroupHandleSize: u32,
    maxRayRecursionDepth: u32,
    maxShaderGroupStride: u32,
    shaderGroupBaseAlignment: u32,
    shaderGroupHandleCaptureReplaySize: u32,
    maxRayDispatchInvocationCount: u32,
    shaderGroupHandleAlignment: u32,
    maxRayHitAttributeSize: u32,
};
pub const PhysicalDeviceRayTracingPropertiesNV = extern struct {
    sType: StructureType = .physical_device_ray_tracing_properties_nv,
    pNext: ?*c_void = null,
    shaderGroupHandleSize: u32,
    maxRecursionDepth: u32,
    maxShaderGroupStride: u32,
    shaderGroupBaseAlignment: u32,
    maxGeometryCount: u64,
    maxInstanceCount: u64,
    maxTriangleCount: u64,
    maxDescriptorSetAccelerationStructures: u32,
};
pub const StridedDeviceAddressRegionKHR = extern struct {
    deviceAddress: DeviceAddress,
    stride: DeviceSize,
    size: DeviceSize,
};
pub const TraceRaysIndirectCommandKHR = extern struct {
    width: u32,
    height: u32,
    depth: u32,
};
pub const DrmFormatModifierPropertiesListEXT = extern struct {
    sType: StructureType = .drm_format_modifier_properties_list_ext,
    pNext: ?*c_void = null,
    drmFormatModifierCount: u32,
    pDrmFormatModifierProperties: ?[*]DrmFormatModifierPropertiesEXT,
};
pub const DrmFormatModifierPropertiesEXT = extern struct {
    drmFormatModifier: u64,
    drmFormatModifierPlaneCount: u32,
    drmFormatModifierTilingFeatures: FormatFeatureFlags,
};
pub const PhysicalDeviceImageDrmFormatModifierInfoEXT = extern struct {
    sType: StructureType = .physical_device_image_drm_format_modifier_info_ext,
    pNext: ?*const c_void = null,
    drmFormatModifier: u64,
    sharingMode: SharingMode,
    queueFamilyIndexCount: u32,
    pQueueFamilyIndices: [*]const u32,
};
pub const ImageDrmFormatModifierListCreateInfoEXT = extern struct {
    sType: StructureType = .image_drm_format_modifier_list_create_info_ext,
    pNext: ?*const c_void = null,
    drmFormatModifierCount: u32,
    pDrmFormatModifiers: [*]const u64,
};
pub const ImageDrmFormatModifierExplicitCreateInfoEXT = extern struct {
    sType: StructureType = .image_drm_format_modifier_explicit_create_info_ext,
    pNext: ?*const c_void = null,
    drmFormatModifier: u64,
    drmFormatModifierPlaneCount: u32,
    pPlaneLayouts: [*]const SubresourceLayout,
};
pub const ImageDrmFormatModifierPropertiesEXT = extern struct {
    sType: StructureType = .image_drm_format_modifier_properties_ext,
    pNext: ?*c_void = null,
    drmFormatModifier: u64,
};
pub const ImageStencilUsageCreateInfo = extern struct {
    sType: StructureType = .image_stencil_usage_create_info,
    pNext: ?*const c_void = null,
    stencilUsage: ImageUsageFlags,
};
pub const ImageStencilUsageCreateInfoEXT = ImageStencilUsageCreateInfo;
pub const DeviceMemoryOverallocationCreateInfoAMD = extern struct {
    sType: StructureType = .device_memory_overallocation_create_info_amd,
    pNext: ?*const c_void = null,
    overallocationBehavior: MemoryOverallocationBehaviorAMD,
};
pub const PhysicalDeviceFragmentDensityMapFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_fragment_density_map_features_ext,
    pNext: ?*c_void = null,
    fragmentDensityMap: Bool32,
    fragmentDensityMapDynamic: Bool32,
    fragmentDensityMapNonSubsampledImages: Bool32,
};
pub const PhysicalDeviceFragmentDensityMap2FeaturesEXT = extern struct {
    sType: StructureType = .physical_device_fragment_density_map_2_features_ext,
    pNext: ?*c_void = null,
    fragmentDensityMapDeferred: Bool32,
};
pub const PhysicalDeviceFragmentDensityMapPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_fragment_density_map_properties_ext,
    pNext: ?*c_void = null,
    minFragmentDensityTexelSize: Extent2D,
    maxFragmentDensityTexelSize: Extent2D,
    fragmentDensityInvocations: Bool32,
};
pub const PhysicalDeviceFragmentDensityMap2PropertiesEXT = extern struct {
    sType: StructureType = .physical_device_fragment_density_map_2_properties_ext,
    pNext: ?*c_void = null,
    subsampledLoads: Bool32,
    subsampledCoarseReconstructionEarlyAccess: Bool32,
    maxSubsampledArrayLayers: u32,
    maxDescriptorSetSubsampledSamplers: u32,
};
pub const RenderPassFragmentDensityMapCreateInfoEXT = extern struct {
    sType: StructureType = .render_pass_fragment_density_map_create_info_ext,
    pNext: ?*const c_void = null,
    fragmentDensityMapAttachment: AttachmentReference,
};
pub const PhysicalDeviceScalarBlockLayoutFeatures = extern struct {
    sType: StructureType = .physical_device_scalar_block_layout_features,
    pNext: ?*c_void = null,
    scalarBlockLayout: Bool32,
};
pub const PhysicalDeviceScalarBlockLayoutFeaturesEXT = PhysicalDeviceScalarBlockLayoutFeatures;
pub const SurfaceProtectedCapabilitiesKHR = extern struct {
    sType: StructureType = .surface_protected_capabilities_khr,
    pNext: ?*const c_void = null,
    supportsProtected: Bool32,
};
pub const PhysicalDeviceUniformBufferStandardLayoutFeatures = extern struct {
    sType: StructureType = .physical_device_uniform_buffer_standard_layout_features,
    pNext: ?*c_void = null,
    uniformBufferStandardLayout: Bool32,
};
pub const PhysicalDeviceUniformBufferStandardLayoutFeaturesKHR = PhysicalDeviceUniformBufferStandardLayoutFeatures;
pub const PhysicalDeviceDepthClipEnableFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_depth_clip_enable_features_ext,
    pNext: ?*c_void = null,
    depthClipEnable: Bool32,
};
pub const PipelineRasterizationDepthClipStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_rasterization_depth_clip_state_create_info_ext,
    pNext: ?*const c_void = null,
    flags: PipelineRasterizationDepthClipStateCreateFlagsEXT,
    depthClipEnable: Bool32,
};
pub const PhysicalDeviceMemoryBudgetPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_memory_budget_properties_ext,
    pNext: ?*c_void = null,
    heapBudget: [MAX_MEMORY_HEAPS]DeviceSize,
    heapUsage: [MAX_MEMORY_HEAPS]DeviceSize,
};
pub const PhysicalDeviceMemoryPriorityFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_memory_priority_features_ext,
    pNext: ?*c_void = null,
    memoryPriority: Bool32,
};
pub const MemoryPriorityAllocateInfoEXT = extern struct {
    sType: StructureType = .memory_priority_allocate_info_ext,
    pNext: ?*const c_void = null,
    priority: f32,
};
pub const PhysicalDeviceBufferDeviceAddressFeatures = extern struct {
    sType: StructureType = .physical_device_buffer_device_address_features,
    pNext: ?*c_void = null,
    bufferDeviceAddress: Bool32,
    bufferDeviceAddressCaptureReplay: Bool32,
    bufferDeviceAddressMultiDevice: Bool32,
};
pub const PhysicalDeviceBufferDeviceAddressFeaturesKHR = PhysicalDeviceBufferDeviceAddressFeatures;
pub const PhysicalDeviceBufferDeviceAddressFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_buffer_device_address_features_ext,
    pNext: ?*c_void = null,
    bufferDeviceAddress: Bool32,
    bufferDeviceAddressCaptureReplay: Bool32,
    bufferDeviceAddressMultiDevice: Bool32,
};
pub const PhysicalDeviceBufferAddressFeaturesEXT = PhysicalDeviceBufferDeviceAddressFeaturesEXT;
pub const BufferDeviceAddressInfo = extern struct {
    sType: StructureType = .buffer_device_address_info,
    pNext: ?*const c_void = null,
    buffer: Buffer,
};
pub const BufferDeviceAddressInfoKHR = BufferDeviceAddressInfo;
pub const BufferDeviceAddressInfoEXT = BufferDeviceAddressInfo;
pub const BufferOpaqueCaptureAddressCreateInfo = extern struct {
    sType: StructureType = .buffer_opaque_capture_address_create_info,
    pNext: ?*const c_void = null,
    opaqueCaptureAddress: u64,
};
pub const BufferOpaqueCaptureAddressCreateInfoKHR = BufferOpaqueCaptureAddressCreateInfo;
pub const BufferDeviceAddressCreateInfoEXT = extern struct {
    sType: StructureType = .buffer_device_address_create_info_ext,
    pNext: ?*const c_void = null,
    deviceAddress: DeviceAddress,
};
pub const PhysicalDeviceImageViewImageFormatInfoEXT = extern struct {
    sType: StructureType = .physical_device_image_view_image_format_info_ext,
    pNext: ?*c_void = null,
    imageViewType: ImageViewType,
};
pub const FilterCubicImageViewImageFormatPropertiesEXT = extern struct {
    sType: StructureType = .filter_cubic_image_view_image_format_properties_ext,
    pNext: ?*c_void = null,
    filterCubic: Bool32,
    filterCubicMinmax: Bool32,
};
pub const PhysicalDeviceImagelessFramebufferFeatures = extern struct {
    sType: StructureType = .physical_device_imageless_framebuffer_features,
    pNext: ?*c_void = null,
    imagelessFramebuffer: Bool32,
};
pub const PhysicalDeviceImagelessFramebufferFeaturesKHR = PhysicalDeviceImagelessFramebufferFeatures;
pub const FramebufferAttachmentsCreateInfo = extern struct {
    sType: StructureType = .framebuffer_attachments_create_info,
    pNext: ?*const c_void = null,
    attachmentImageInfoCount: u32,
    pAttachmentImageInfos: [*]const FramebufferAttachmentImageInfo,
};
pub const FramebufferAttachmentsCreateInfoKHR = FramebufferAttachmentsCreateInfo;
pub const FramebufferAttachmentImageInfo = extern struct {
    sType: StructureType = .framebuffer_attachment_image_info,
    pNext: ?*const c_void = null,
    flags: ImageCreateFlags,
    usage: ImageUsageFlags,
    width: u32,
    height: u32,
    layerCount: u32,
    viewFormatCount: u32,
    pViewFormats: [*]const Format,
};
pub const FramebufferAttachmentImageInfoKHR = FramebufferAttachmentImageInfo;
pub const RenderPassAttachmentBeginInfo = extern struct {
    sType: StructureType = .render_pass_attachment_begin_info,
    pNext: ?*const c_void = null,
    attachmentCount: u32,
    pAttachments: [*]const ImageView,
};
pub const RenderPassAttachmentBeginInfoKHR = RenderPassAttachmentBeginInfo;
pub const PhysicalDeviceTextureCompressionASTCHDRFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_texture_compression_astc_hdr_features_ext,
    pNext: ?*c_void = null,
    textureCompressionAstcHdr: Bool32,
};
pub const PhysicalDeviceCooperativeMatrixFeaturesNV = extern struct {
    sType: StructureType = .physical_device_cooperative_matrix_features_nv,
    pNext: ?*c_void = null,
    cooperativeMatrix: Bool32,
    cooperativeMatrixRobustBufferAccess: Bool32,
};
pub const PhysicalDeviceCooperativeMatrixPropertiesNV = extern struct {
    sType: StructureType = .physical_device_cooperative_matrix_properties_nv,
    pNext: ?*c_void = null,
    cooperativeMatrixSupportedStages: ShaderStageFlags,
};
pub const CooperativeMatrixPropertiesNV = extern struct {
    sType: StructureType = .cooperative_matrix_properties_nv,
    pNext: ?*c_void = null,
    mSize: u32,
    nSize: u32,
    kSize: u32,
    aType: ComponentTypeNV,
    bType: ComponentTypeNV,
    cType: ComponentTypeNV,
    dType: ComponentTypeNV,
    scope: ScopeNV,
};
pub const PhysicalDeviceYcbcrImageArraysFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_ycbcr_image_arrays_features_ext,
    pNext: ?*c_void = null,
    ycbcrImageArrays: Bool32,
};
pub const ImageViewHandleInfoNVX = extern struct {
    sType: StructureType = .image_view_handle_info_nvx,
    pNext: ?*const c_void = null,
    imageView: ImageView,
    descriptorType: DescriptorType,
    sampler: Sampler,
};
pub const ImageViewAddressPropertiesNVX = extern struct {
    sType: StructureType = .image_view_address_properties_nvx,
    pNext: ?*c_void = null,
    deviceAddress: DeviceAddress,
    size: DeviceSize,
};
pub const PresentFrameTokenGGP = extern struct {
    sType: StructureType = .present_frame_token_ggp,
    pNext: ?*const c_void = null,
    frameToken: GgpFrameToken,
};
pub const PipelineCreationFeedbackEXT = extern struct {
    flags: PipelineCreationFeedbackFlagsEXT,
    duration: u64,
};
pub const PipelineCreationFeedbackCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_creation_feedback_create_info_ext,
    pNext: ?*const c_void = null,
    pPipelineCreationFeedback: *PipelineCreationFeedbackEXT,
    pipelineStageCreationFeedbackCount: u32,
    pPipelineStageCreationFeedbacks: [*]PipelineCreationFeedbackEXT,
};
pub const SurfaceFullScreenExclusiveInfoEXT = extern struct {
    sType: StructureType = .surface_full_screen_exclusive_info_ext,
    pNext: ?*c_void = null,
    fullScreenExclusive: FullScreenExclusiveEXT,
};
pub const SurfaceFullScreenExclusiveWin32InfoEXT = extern struct {
    sType: StructureType = .surface_full_screen_exclusive_win32_info_ext,
    pNext: ?*const c_void = null,
    hmonitor: HMONITOR,
};
pub const SurfaceCapabilitiesFullScreenExclusiveEXT = extern struct {
    sType: StructureType = .surface_capabilities_full_screen_exclusive_ext,
    pNext: ?*c_void = null,
    fullScreenExclusiveSupported: Bool32,
};
pub const PhysicalDevicePerformanceQueryFeaturesKHR = extern struct {
    sType: StructureType = .physical_device_performance_query_features_khr,
    pNext: ?*c_void = null,
    performanceCounterQueryPools: Bool32,
    performanceCounterMultipleQueryPools: Bool32,
};
pub const PhysicalDevicePerformanceQueryPropertiesKHR = extern struct {
    sType: StructureType = .physical_device_performance_query_properties_khr,
    pNext: ?*c_void = null,
    allowCommandBufferQueryCopies: Bool32,
};
pub const PerformanceCounterKHR = extern struct {
    sType: StructureType = .performance_counter_khr,
    pNext: ?*const c_void = null,
    unit: PerformanceCounterUnitKHR,
    scope: PerformanceCounterScopeKHR,
    storage: PerformanceCounterStorageKHR,
    uuid: [UUID_SIZE]u8,
};
pub const PerformanceCounterDescriptionKHR = extern struct {
    sType: StructureType = .performance_counter_description_khr,
    pNext: ?*const c_void = null,
    flags: PerformanceCounterDescriptionFlagsKHR,
    name: [MAX_DESCRIPTION_SIZE]u8,
    category: [MAX_DESCRIPTION_SIZE]u8,
    description: [MAX_DESCRIPTION_SIZE]u8,
};
pub const QueryPoolPerformanceCreateInfoKHR = extern struct {
    sType: StructureType = .query_pool_performance_create_info_khr,
    pNext: ?*const c_void = null,
    queueFamilyIndex: u32,
    counterIndexCount: u32,
    pCounterIndices: [*]const u32,
};
pub const PerformanceCounterResultKHR = extern union {
    int32: i32,
    int64: i64,
    uint32: u32,
    uint64: u64,
    float32: f32,
    float64: f64,
};
pub const AcquireProfilingLockInfoKHR = extern struct {
    sType: StructureType = .acquire_profiling_lock_info_khr,
    pNext: ?*const c_void = null,
    flags: AcquireProfilingLockFlagsKHR,
    timeout: u64,
};
pub const PerformanceQuerySubmitInfoKHR = extern struct {
    sType: StructureType = .performance_query_submit_info_khr,
    pNext: ?*const c_void = null,
    counterPassIndex: u32,
};
pub const HeadlessSurfaceCreateInfoEXT = extern struct {
    sType: StructureType = .headless_surface_create_info_ext,
    pNext: ?*const c_void = null,
    flags: HeadlessSurfaceCreateFlagsEXT,
};
pub const PhysicalDeviceCoverageReductionModeFeaturesNV = extern struct {
    sType: StructureType = .physical_device_coverage_reduction_mode_features_nv,
    pNext: ?*c_void = null,
    coverageReductionMode: Bool32,
};
pub const PipelineCoverageReductionStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_coverage_reduction_state_create_info_nv,
    pNext: ?*const c_void = null,
    flags: PipelineCoverageReductionStateCreateFlagsNV,
    coverageReductionMode: CoverageReductionModeNV,
};
pub const FramebufferMixedSamplesCombinationNV = extern struct {
    sType: StructureType = .framebuffer_mixed_samples_combination_nv,
    pNext: ?*c_void = null,
    coverageReductionMode: CoverageReductionModeNV,
    rasterizationSamples: SampleCountFlags,
    depthStencilSamples: SampleCountFlags,
    colorSamples: SampleCountFlags,
};
pub const PhysicalDeviceShaderIntegerFunctions2FeaturesINTEL = extern struct {
    sType: StructureType = .physical_device_shader_integer_functions_2_features_intel,
    pNext: ?*c_void = null,
    shaderIntegerFunctions2: Bool32,
};
pub const PerformanceValueDataINTEL = extern union {
    value32: u32,
    value64: u64,
    valueFloat: f32,
    valueBool: Bool32,
    valueString: [*:0]const u8,
};
pub const PerformanceValueINTEL = extern struct {
    type: PerformanceValueTypeINTEL,
    data: PerformanceValueDataINTEL,
};
pub const InitializePerformanceApiInfoINTEL = extern struct {
    sType: StructureType = .initialize_performance_api_info_intel,
    pNext: ?*const c_void = null,
    pUserData: ?*c_void,
};
pub const QueryPoolPerformanceQueryCreateInfoINTEL = extern struct {
    sType: StructureType = .query_pool_performance_query_create_info_intel,
    pNext: ?*const c_void = null,
    performanceCountersSampling: QueryPoolSamplingModeINTEL,
};
pub const QueryPoolCreateInfoINTEL = QueryPoolPerformanceQueryCreateInfoINTEL;
pub const PerformanceMarkerInfoINTEL = extern struct {
    sType: StructureType = .performance_marker_info_intel,
    pNext: ?*const c_void = null,
    marker: u64,
};
pub const PerformanceStreamMarkerInfoINTEL = extern struct {
    sType: StructureType = .performance_stream_marker_info_intel,
    pNext: ?*const c_void = null,
    marker: u32,
};
pub const PerformanceOverrideInfoINTEL = extern struct {
    sType: StructureType = .performance_override_info_intel,
    pNext: ?*const c_void = null,
    type: PerformanceOverrideTypeINTEL,
    enable: Bool32,
    parameter: u64,
};
pub const PerformanceConfigurationAcquireInfoINTEL = extern struct {
    sType: StructureType = .performance_configuration_acquire_info_intel,
    pNext: ?*const c_void = null,
    type: PerformanceConfigurationTypeINTEL,
};
pub const PhysicalDeviceShaderClockFeaturesKHR = extern struct {
    sType: StructureType = .physical_device_shader_clock_features_khr,
    pNext: ?*c_void = null,
    shaderSubgroupClock: Bool32,
    shaderDeviceClock: Bool32,
};
pub const PhysicalDeviceIndexTypeUint8FeaturesEXT = extern struct {
    sType: StructureType = .physical_device_index_type_uint8_features_ext,
    pNext: ?*c_void = null,
    indexTypeUint8: Bool32,
};
pub const PhysicalDeviceShaderSMBuiltinsPropertiesNV = extern struct {
    sType: StructureType = .physical_device_shader_sm_builtins_properties_nv,
    pNext: ?*c_void = null,
    shaderSmCount: u32,
    shaderWarpsPerSm: u32,
};
pub const PhysicalDeviceShaderSMBuiltinsFeaturesNV = extern struct {
    sType: StructureType = .physical_device_shader_sm_builtins_features_nv,
    pNext: ?*c_void = null,
    shaderSmBuiltins: Bool32,
};
pub const PhysicalDeviceFragmentShaderInterlockFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_fragment_shader_interlock_features_ext,
    pNext: ?*c_void = null,
    fragmentShaderSampleInterlock: Bool32,
    fragmentShaderPixelInterlock: Bool32,
    fragmentShaderShadingRateInterlock: Bool32,
};
pub const PhysicalDeviceSeparateDepthStencilLayoutsFeatures = extern struct {
    sType: StructureType = .physical_device_separate_depth_stencil_layouts_features,
    pNext: ?*c_void = null,
    separateDepthStencilLayouts: Bool32,
};
pub const PhysicalDeviceSeparateDepthStencilLayoutsFeaturesKHR = PhysicalDeviceSeparateDepthStencilLayoutsFeatures;
pub const AttachmentReferenceStencilLayout = extern struct {
    sType: StructureType = .attachment_reference_stencil_layout,
    pNext: ?*c_void = null,
    stencilLayout: ImageLayout,
};
pub const AttachmentReferenceStencilLayoutKHR = AttachmentReferenceStencilLayout;
pub const AttachmentDescriptionStencilLayout = extern struct {
    sType: StructureType = .attachment_description_stencil_layout,
    pNext: ?*c_void = null,
    stencilInitialLayout: ImageLayout,
    stencilFinalLayout: ImageLayout,
};
pub const AttachmentDescriptionStencilLayoutKHR = AttachmentDescriptionStencilLayout;
pub const PhysicalDevicePipelineExecutablePropertiesFeaturesKHR = extern struct {
    sType: StructureType = .physical_device_pipeline_executable_properties_features_khr,
    pNext: ?*c_void = null,
    pipelineExecutableInfo: Bool32,
};
pub const PipelineInfoKHR = extern struct {
    sType: StructureType = .pipeline_info_khr,
    pNext: ?*const c_void = null,
    pipeline: Pipeline,
};
pub const PipelineExecutablePropertiesKHR = extern struct {
    sType: StructureType = .pipeline_executable_properties_khr,
    pNext: ?*c_void = null,
    stages: ShaderStageFlags,
    name: [MAX_DESCRIPTION_SIZE]u8,
    description: [MAX_DESCRIPTION_SIZE]u8,
    subgroupSize: u32,
};
pub const PipelineExecutableInfoKHR = extern struct {
    sType: StructureType = .pipeline_executable_info_khr,
    pNext: ?*const c_void = null,
    pipeline: Pipeline,
    executableIndex: u32,
};
pub const PipelineExecutableStatisticValueKHR = extern union {
    b32: Bool32,
    i64: i64,
    u64: u64,
    f64: f64,
};
pub const PipelineExecutableStatisticKHR = extern struct {
    sType: StructureType = .pipeline_executable_statistic_khr,
    pNext: ?*c_void = null,
    name: [MAX_DESCRIPTION_SIZE]u8,
    description: [MAX_DESCRIPTION_SIZE]u8,
    format: PipelineExecutableStatisticFormatKHR,
    value: PipelineExecutableStatisticValueKHR,
};
pub const PipelineExecutableInternalRepresentationKHR = extern struct {
    sType: StructureType = .pipeline_executable_internal_representation_khr,
    pNext: ?*c_void = null,
    name: [MAX_DESCRIPTION_SIZE]u8,
    description: [MAX_DESCRIPTION_SIZE]u8,
    isText: Bool32,
    dataSize: usize,
    pData: ?*c_void,
};
pub const PhysicalDeviceShaderDemoteToHelperInvocationFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_shader_demote_to_helper_invocation_features_ext,
    pNext: ?*c_void = null,
    shaderDemoteToHelperInvocation: Bool32,
};
pub const PhysicalDeviceTexelBufferAlignmentFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_texel_buffer_alignment_features_ext,
    pNext: ?*c_void = null,
    texelBufferAlignment: Bool32,
};
pub const PhysicalDeviceTexelBufferAlignmentPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_texel_buffer_alignment_properties_ext,
    pNext: ?*c_void = null,
    storageTexelBufferOffsetAlignmentBytes: DeviceSize,
    storageTexelBufferOffsetSingleTexelAlignment: Bool32,
    uniformTexelBufferOffsetAlignmentBytes: DeviceSize,
    uniformTexelBufferOffsetSingleTexelAlignment: Bool32,
};
pub const PhysicalDeviceSubgroupSizeControlFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_subgroup_size_control_features_ext,
    pNext: ?*c_void = null,
    subgroupSizeControl: Bool32,
    computeFullSubgroups: Bool32,
};
pub const PhysicalDeviceSubgroupSizeControlPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_subgroup_size_control_properties_ext,
    pNext: ?*c_void = null,
    minSubgroupSize: u32,
    maxSubgroupSize: u32,
    maxComputeWorkgroupSubgroups: u32,
    requiredSubgroupSizeStages: ShaderStageFlags,
};
pub const PipelineShaderStageRequiredSubgroupSizeCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_shader_stage_required_subgroup_size_create_info_ext,
    pNext: ?*c_void = null,
    requiredSubgroupSize: u32,
};
pub const MemoryOpaqueCaptureAddressAllocateInfo = extern struct {
    sType: StructureType = .memory_opaque_capture_address_allocate_info,
    pNext: ?*const c_void = null,
    opaqueCaptureAddress: u64,
};
pub const MemoryOpaqueCaptureAddressAllocateInfoKHR = MemoryOpaqueCaptureAddressAllocateInfo;
pub const DeviceMemoryOpaqueCaptureAddressInfo = extern struct {
    sType: StructureType = .device_memory_opaque_capture_address_info,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
};
pub const DeviceMemoryOpaqueCaptureAddressInfoKHR = DeviceMemoryOpaqueCaptureAddressInfo;
pub const PhysicalDeviceLineRasterizationFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_line_rasterization_features_ext,
    pNext: ?*c_void = null,
    rectangularLines: Bool32,
    bresenhamLines: Bool32,
    smoothLines: Bool32,
    stippledRectangularLines: Bool32,
    stippledBresenhamLines: Bool32,
    stippledSmoothLines: Bool32,
};
pub const PhysicalDeviceLineRasterizationPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_line_rasterization_properties_ext,
    pNext: ?*c_void = null,
    lineSubPixelPrecisionBits: u32,
};
pub const PipelineRasterizationLineStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipeline_rasterization_line_state_create_info_ext,
    pNext: ?*const c_void = null,
    lineRasterizationMode: LineRasterizationModeEXT,
    stippledLineEnable: Bool32,
    lineStippleFactor: u32,
    lineStipplePattern: u16,
};
pub const PhysicalDevicePipelineCreationCacheControlFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_pipeline_creation_cache_control_features_ext,
    pNext: ?*c_void = null,
    pipelineCreationCacheControl: Bool32,
};
pub const PhysicalDeviceVulkan11Features = extern struct {
    sType: StructureType = .physical_device_vulkan_1_1_features,
    pNext: ?*c_void = null,
    storageBuffer16BitAccess: Bool32,
    uniformAndStorageBuffer16BitAccess: Bool32,
    storagePushConstant16: Bool32,
    storageInputOutput16: Bool32,
    multiview: Bool32,
    multiviewGeometryShader: Bool32,
    multiviewTessellationShader: Bool32,
    variablePointersStorageBuffer: Bool32,
    variablePointers: Bool32,
    protectedMemory: Bool32,
    samplerYcbcrConversion: Bool32,
    shaderDrawParameters: Bool32,
};
pub const PhysicalDeviceVulkan11Properties = extern struct {
    sType: StructureType = .physical_device_vulkan_1_1_properties,
    pNext: ?*c_void = null,
    deviceUuid: [UUID_SIZE]u8,
    driverUuid: [UUID_SIZE]u8,
    deviceLuid: [LUID_SIZE]u8,
    deviceNodeMask: u32,
    deviceLuidValid: Bool32,
    subgroupSize: u32,
    subgroupSupportedStages: ShaderStageFlags,
    subgroupSupportedOperations: SubgroupFeatureFlags,
    subgroupQuadOperationsInAllStages: Bool32,
    pointClippingBehavior: PointClippingBehavior,
    maxMultiviewViewCount: u32,
    maxMultiviewInstanceIndex: u32,
    protectedNoFault: Bool32,
    maxPerSetDescriptors: u32,
    maxMemoryAllocationSize: DeviceSize,
};
pub const PhysicalDeviceVulkan12Features = extern struct {
    sType: StructureType = .physical_device_vulkan_1_2_features,
    pNext: ?*c_void = null,
    samplerMirrorClampToEdge: Bool32,
    drawIndirectCount: Bool32,
    storageBuffer8BitAccess: Bool32,
    uniformAndStorageBuffer8BitAccess: Bool32,
    storagePushConstant8: Bool32,
    shaderBufferInt64Atomics: Bool32,
    shaderSharedInt64Atomics: Bool32,
    shaderFloat16: Bool32,
    shaderInt8: Bool32,
    descriptorIndexing: Bool32,
    shaderInputAttachmentArrayDynamicIndexing: Bool32,
    shaderUniformTexelBufferArrayDynamicIndexing: Bool32,
    shaderStorageTexelBufferArrayDynamicIndexing: Bool32,
    shaderUniformBufferArrayNonUniformIndexing: Bool32,
    shaderSampledImageArrayNonUniformIndexing: Bool32,
    shaderStorageBufferArrayNonUniformIndexing: Bool32,
    shaderStorageImageArrayNonUniformIndexing: Bool32,
    shaderInputAttachmentArrayNonUniformIndexing: Bool32,
    shaderUniformTexelBufferArrayNonUniformIndexing: Bool32,
    shaderStorageTexelBufferArrayNonUniformIndexing: Bool32,
    descriptorBindingUniformBufferUpdateAfterBind: Bool32,
    descriptorBindingSampledImageUpdateAfterBind: Bool32,
    descriptorBindingStorageImageUpdateAfterBind: Bool32,
    descriptorBindingStorageBufferUpdateAfterBind: Bool32,
    descriptorBindingUniformTexelBufferUpdateAfterBind: Bool32,
    descriptorBindingStorageTexelBufferUpdateAfterBind: Bool32,
    descriptorBindingUpdateUnusedWhilePending: Bool32,
    descriptorBindingPartiallyBound: Bool32,
    descriptorBindingVariableDescriptorCount: Bool32,
    runtimeDescriptorArray: Bool32,
    samplerFilterMinmax: Bool32,
    scalarBlockLayout: Bool32,
    imagelessFramebuffer: Bool32,
    uniformBufferStandardLayout: Bool32,
    shaderSubgroupExtendedTypes: Bool32,
    separateDepthStencilLayouts: Bool32,
    hostQueryReset: Bool32,
    timelineSemaphore: Bool32,
    bufferDeviceAddress: Bool32,
    bufferDeviceAddressCaptureReplay: Bool32,
    bufferDeviceAddressMultiDevice: Bool32,
    vulkanMemoryModel: Bool32,
    vulkanMemoryModelDeviceScope: Bool32,
    vulkanMemoryModelAvailabilityVisibilityChains: Bool32,
    shaderOutputViewportIndex: Bool32,
    shaderOutputLayer: Bool32,
    subgroupBroadcastDynamicId: Bool32,
};
pub const PhysicalDeviceVulkan12Properties = extern struct {
    sType: StructureType = .physical_device_vulkan_1_2_properties,
    pNext: ?*c_void = null,
    driverId: DriverId,
    driverName: [MAX_DRIVER_NAME_SIZE]u8,
    driverInfo: [MAX_DRIVER_INFO_SIZE]u8,
    conformanceVersion: ConformanceVersion,
    denormBehaviorIndependence: ShaderFloatControlsIndependence,
    roundingModeIndependence: ShaderFloatControlsIndependence,
    shaderSignedZeroInfNanPreserveFloat16: Bool32,
    shaderSignedZeroInfNanPreserveFloat32: Bool32,
    shaderSignedZeroInfNanPreserveFloat64: Bool32,
    shaderDenormPreserveFloat16: Bool32,
    shaderDenormPreserveFloat32: Bool32,
    shaderDenormPreserveFloat64: Bool32,
    shaderDenormFlushToZeroFloat16: Bool32,
    shaderDenormFlushToZeroFloat32: Bool32,
    shaderDenormFlushToZeroFloat64: Bool32,
    shaderRoundingModeRteFloat16: Bool32,
    shaderRoundingModeRteFloat32: Bool32,
    shaderRoundingModeRteFloat64: Bool32,
    shaderRoundingModeRtzFloat16: Bool32,
    shaderRoundingModeRtzFloat32: Bool32,
    shaderRoundingModeRtzFloat64: Bool32,
    maxUpdateAfterBindDescriptorsInAllPools: u32,
    shaderUniformBufferArrayNonUniformIndexingNative: Bool32,
    shaderSampledImageArrayNonUniformIndexingNative: Bool32,
    shaderStorageBufferArrayNonUniformIndexingNative: Bool32,
    shaderStorageImageArrayNonUniformIndexingNative: Bool32,
    shaderInputAttachmentArrayNonUniformIndexingNative: Bool32,
    robustBufferAccessUpdateAfterBind: Bool32,
    quadDivergentImplicitLod: Bool32,
    maxPerStageDescriptorUpdateAfterBindSamplers: u32,
    maxPerStageDescriptorUpdateAfterBindUniformBuffers: u32,
    maxPerStageDescriptorUpdateAfterBindStorageBuffers: u32,
    maxPerStageDescriptorUpdateAfterBindSampledImages: u32,
    maxPerStageDescriptorUpdateAfterBindStorageImages: u32,
    maxPerStageDescriptorUpdateAfterBindInputAttachments: u32,
    maxPerStageUpdateAfterBindResources: u32,
    maxDescriptorSetUpdateAfterBindSamplers: u32,
    maxDescriptorSetUpdateAfterBindUniformBuffers: u32,
    maxDescriptorSetUpdateAfterBindUniformBuffersDynamic: u32,
    maxDescriptorSetUpdateAfterBindStorageBuffers: u32,
    maxDescriptorSetUpdateAfterBindStorageBuffersDynamic: u32,
    maxDescriptorSetUpdateAfterBindSampledImages: u32,
    maxDescriptorSetUpdateAfterBindStorageImages: u32,
    maxDescriptorSetUpdateAfterBindInputAttachments: u32,
    supportedDepthResolveModes: ResolveModeFlags,
    supportedStencilResolveModes: ResolveModeFlags,
    independentResolveNone: Bool32,
    independentResolve: Bool32,
    filterMinmaxSingleComponentFormats: Bool32,
    filterMinmaxImageComponentMapping: Bool32,
    maxTimelineSemaphoreValueDifference: u64,
    framebufferIntegerColorSampleCounts: SampleCountFlags,
};
pub const PipelineCompilerControlCreateInfoAMD = extern struct {
    sType: StructureType = .pipeline_compiler_control_create_info_amd,
    pNext: ?*const c_void = null,
    compilerControlFlags: PipelineCompilerControlFlagsAMD,
};
pub const PhysicalDeviceCoherentMemoryFeaturesAMD = extern struct {
    sType: StructureType = .physical_device_coherent_memory_features_amd,
    pNext: ?*c_void = null,
    deviceCoherentMemory: Bool32,
};
pub const PhysicalDeviceToolPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_tool_properties_ext,
    pNext: ?*c_void = null,
    name: [MAX_EXTENSION_NAME_SIZE]u8,
    version: [MAX_EXTENSION_NAME_SIZE]u8,
    purposes: ToolPurposeFlagsEXT,
    description: [MAX_DESCRIPTION_SIZE]u8,
    layer: [MAX_EXTENSION_NAME_SIZE]u8,
};
pub const SamplerCustomBorderColorCreateInfoEXT = extern struct {
    sType: StructureType = .sampler_custom_border_color_create_info_ext,
    pNext: ?*const c_void = null,
    customBorderColor: ClearColorValue,
    format: Format,
};
pub const PhysicalDeviceCustomBorderColorPropertiesEXT = extern struct {
    sType: StructureType = .physical_device_custom_border_color_properties_ext,
    pNext: ?*c_void = null,
    maxCustomBorderColorSamplers: u32,
};
pub const PhysicalDeviceCustomBorderColorFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_custom_border_color_features_ext,
    pNext: ?*c_void = null,
    customBorderColors: Bool32,
    customBorderColorWithoutFormat: Bool32,
};
pub const DeviceOrHostAddressKHR = extern union {
    deviceAddress: DeviceAddress,
    hostAddress: *c_void,
};
pub const DeviceOrHostAddressConstKHR = extern union {
    deviceAddress: DeviceAddress,
    hostAddress: *const c_void,
};
pub const AccelerationStructureGeometryTrianglesDataKHR = extern struct {
    sType: StructureType = .acceleration_structure_geometry_triangles_data_khr,
    pNext: ?*const c_void = null,
    vertexFormat: Format,
    vertexData: DeviceOrHostAddressConstKHR,
    vertexStride: DeviceSize,
    maxVertex: u32,
    indexType: IndexType,
    indexData: DeviceOrHostAddressConstKHR,
    transformData: DeviceOrHostAddressConstKHR,
};
pub const AccelerationStructureGeometryAabbsDataKHR = extern struct {
    sType: StructureType = .acceleration_structure_geometry_aabbs_data_khr,
    pNext: ?*const c_void = null,
    data: DeviceOrHostAddressConstKHR,
    stride: DeviceSize,
};
pub const AccelerationStructureGeometryInstancesDataKHR = extern struct {
    sType: StructureType = .acceleration_structure_geometry_instances_data_khr,
    pNext: ?*const c_void = null,
    arrayOfPointers: Bool32,
    data: DeviceOrHostAddressConstKHR,
};
pub const AccelerationStructureGeometryDataKHR = extern union {
    triangles: AccelerationStructureGeometryTrianglesDataKHR,
    aabbs: AccelerationStructureGeometryAabbsDataKHR,
    instances: AccelerationStructureGeometryInstancesDataKHR,
};
pub const AccelerationStructureGeometryKHR = extern struct {
    sType: StructureType = .acceleration_structure_geometry_khr,
    pNext: ?*const c_void = null,
    geometryType: GeometryTypeKHR,
    geometry: AccelerationStructureGeometryDataKHR,
    flags: GeometryFlagsKHR,
};
pub const AccelerationStructureBuildGeometryInfoKHR = extern struct {
    sType: StructureType = .acceleration_structure_build_geometry_info_khr,
    pNext: ?*const c_void = null,
    type: AccelerationStructureTypeKHR,
    flags: BuildAccelerationStructureFlagsKHR,
    mode: BuildAccelerationStructureModeKHR,
    srcAccelerationStructure: AccelerationStructureKHR,
    dstAccelerationStructure: AccelerationStructureKHR,
    geometryCount: u32,
    pGeometries: ?[*]const AccelerationStructureGeometryKHR,
    ppGeometries: ?[*]const [*]const AccelerationStructureGeometryKHR,
    scratchData: DeviceOrHostAddressKHR,
};
pub const AccelerationStructureBuildRangeInfoKHR = extern struct {
    primitiveCount: u32,
    primitiveOffset: u32,
    firstVertex: u32,
    transformOffset: u32,
};
pub const AccelerationStructureCreateInfoKHR = extern struct {
    sType: StructureType = .acceleration_structure_create_info_khr,
    pNext: ?*const c_void = null,
    createFlags: AccelerationStructureCreateFlagsKHR,
    buffer: Buffer,
    offset: DeviceSize,
    size: DeviceSize,
    type: AccelerationStructureTypeKHR,
    deviceAddress: DeviceAddress,
};
pub const AabbPositionsKHR = extern struct {
    minX: f32,
    minY: f32,
    minZ: f32,
    maxX: f32,
    maxY: f32,
    maxZ: f32,
};
pub const AabbPositionsNV = AabbPositionsKHR;
pub const TransformMatrixKHR = extern struct {
    matrix: [3][4]f32,
};
pub const TransformMatrixNV = TransformMatrixKHR;
pub const AccelerationStructureInstanceKHR = packed struct {
    transform: TransformMatrixKHR,
    instanceCustomIndex: u24,
    mask: u8,
    instanceShaderBindingTableRecordOffset: u24,
    flags: u8, // GeometryInstanceFlagsKHR
    accelerationStructureReference: u64,
};
pub const AccelerationStructureInstanceNV = AccelerationStructureInstanceKHR;
pub const AccelerationStructureDeviceAddressInfoKHR = extern struct {
    sType: StructureType = .acceleration_structure_device_address_info_khr,
    pNext: ?*const c_void = null,
    accelerationStructure: AccelerationStructureKHR,
};
pub const AccelerationStructureVersionInfoKHR = extern struct {
    sType: StructureType = .acceleration_structure_version_info_khr,
    pNext: ?*const c_void = null,
    pVersionData: [*]const u8,
};
pub const CopyAccelerationStructureInfoKHR = extern struct {
    sType: StructureType = .copy_acceleration_structure_info_khr,
    pNext: ?*const c_void = null,
    src: AccelerationStructureKHR,
    dst: AccelerationStructureKHR,
    mode: CopyAccelerationStructureModeKHR,
};
pub const CopyAccelerationStructureToMemoryInfoKHR = extern struct {
    sType: StructureType = .copy_acceleration_structure_to_memory_info_khr,
    pNext: ?*const c_void = null,
    src: AccelerationStructureKHR,
    dst: DeviceOrHostAddressKHR,
    mode: CopyAccelerationStructureModeKHR,
};
pub const CopyMemoryToAccelerationStructureInfoKHR = extern struct {
    sType: StructureType = .copy_memory_to_acceleration_structure_info_khr,
    pNext: ?*const c_void = null,
    src: DeviceOrHostAddressConstKHR,
    dst: AccelerationStructureKHR,
    mode: CopyAccelerationStructureModeKHR,
};
pub const RayTracingPipelineInterfaceCreateInfoKHR = extern struct {
    sType: StructureType = .ray_tracing_pipeline_interface_create_info_khr,
    pNext: ?*const c_void = null,
    maxPipelineRayPayloadSize: u32,
    maxPipelineRayHitAttributeSize: u32,
};
pub const PipelineLibraryCreateInfoKHR = extern struct {
    sType: StructureType = .pipeline_library_create_info_khr,
    pNext: ?*const c_void = null,
    libraryCount: u32,
    pLibraries: [*]const Pipeline,
};
pub const PhysicalDeviceExtendedDynamicStateFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_extended_dynamic_state_features_ext,
    pNext: ?*c_void = null,
    extendedDynamicState: Bool32,
};
pub const RenderPassTransformBeginInfoQCOM = extern struct {
    sType: StructureType = .render_pass_transform_begin_info_qcom,
    pNext: ?*c_void = null,
    transform: SurfaceTransformFlagsKHR,
};
pub const CopyCommandTransformInfoQCOM = extern struct {
    sType: StructureType = .copy_command_transform_info_qcom,
    pNext: ?*const c_void = null,
    transform: SurfaceTransformFlagsKHR,
};
pub const CommandBufferInheritanceRenderPassTransformInfoQCOM = extern struct {
    sType: StructureType = .command_buffer_inheritance_render_pass_transform_info_qcom,
    pNext: ?*c_void = null,
    transform: SurfaceTransformFlagsKHR,
    renderArea: Rect2D,
};
pub const PhysicalDeviceDiagnosticsConfigFeaturesNV = extern struct {
    sType: StructureType = .physical_device_diagnostics_config_features_nv,
    pNext: ?*c_void = null,
    diagnosticsConfig: Bool32,
};
pub const DeviceDiagnosticsConfigCreateInfoNV = extern struct {
    sType: StructureType = .device_diagnostics_config_create_info_nv,
    pNext: ?*const c_void = null,
    flags: DeviceDiagnosticsConfigFlagsNV,
};
pub const PhysicalDeviceRobustness2FeaturesEXT = extern struct {
    sType: StructureType = .physical_device_robustness_2_features_ext,
    pNext: ?*c_void = null,
    robustBufferAccess2: Bool32,
    robustImageAccess2: Bool32,
    nullDescriptor: Bool32,
};
pub const PhysicalDeviceRobustness2PropertiesEXT = extern struct {
    sType: StructureType = .physical_device_robustness_2_properties_ext,
    pNext: ?*c_void = null,
    robustStorageBufferAccessSizeAlignment: DeviceSize,
    robustUniformBufferAccessSizeAlignment: DeviceSize,
};
pub const PhysicalDeviceImageRobustnessFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_image_robustness_features_ext,
    pNext: ?*c_void = null,
    robustImageAccess: Bool32,
};
pub const PhysicalDevicePortabilitySubsetFeaturesKHR = extern struct {
    sType: StructureType = .physical_device_portability_subset_features_khr,
    pNext: ?*c_void = null,
    constantAlphaColorBlendFactors: Bool32,
    events: Bool32,
    imageViewFormatReinterpretation: Bool32,
    imageViewFormatSwizzle: Bool32,
    imageView2DOn3DImage: Bool32,
    multisampleArrayImage: Bool32,
    mutableComparisonSamplers: Bool32,
    pointPolygons: Bool32,
    samplerMipLodBias: Bool32,
    separateStencilMaskRef: Bool32,
    shaderSampleRateInterpolationFunctions: Bool32,
    tessellationIsolines: Bool32,
    tessellationPointMode: Bool32,
    triangleFans: Bool32,
    vertexAttributeAccessBeyondStride: Bool32,
};
pub const PhysicalDevicePortabilitySubsetPropertiesKHR = extern struct {
    sType: StructureType = .physical_device_portability_subset_properties_khr,
    pNext: ?*c_void = null,
    minVertexInputBindingStrideAlignment: u32,
};
pub const PhysicalDevice4444FormatsFeaturesEXT = extern struct {
    sType: StructureType = .physical_device_4444_formats_features_ext,
    pNext: ?*c_void = null,
    formatA4r4g4b4: Bool32,
    formatA4b4g4r4: Bool32,
};
pub const BufferCopy2KHR = extern struct {
    sType: StructureType = .buffer_copy_2_khr,
    pNext: ?*const c_void = null,
    srcOffset: DeviceSize,
    dstOffset: DeviceSize,
    size: DeviceSize,
};
pub const ImageCopy2KHR = extern struct {
    sType: StructureType = .image_copy_2_khr,
    pNext: ?*const c_void = null,
    srcSubresource: ImageSubresourceLayers,
    srcOffset: Offset3D,
    dstSubresource: ImageSubresourceLayers,
    dstOffset: Offset3D,
    extent: Extent3D,
};
pub const ImageBlit2KHR = extern struct {
    sType: StructureType = .image_blit_2_khr,
    pNext: ?*const c_void = null,
    srcSubresource: ImageSubresourceLayers,
    srcOffsets: [2]Offset3D,
    dstSubresource: ImageSubresourceLayers,
    dstOffsets: [2]Offset3D,
};
pub const BufferImageCopy2KHR = extern struct {
    sType: StructureType = .buffer_image_copy_2_khr,
    pNext: ?*const c_void = null,
    bufferOffset: DeviceSize,
    bufferRowLength: u32,
    bufferImageHeight: u32,
    imageSubresource: ImageSubresourceLayers,
    imageOffset: Offset3D,
    imageExtent: Extent3D,
};
pub const ImageResolve2KHR = extern struct {
    sType: StructureType = .image_resolve_2_khr,
    pNext: ?*const c_void = null,
    srcSubresource: ImageSubresourceLayers,
    srcOffset: Offset3D,
    dstSubresource: ImageSubresourceLayers,
    dstOffset: Offset3D,
    extent: Extent3D,
};
pub const CopyBufferInfo2KHR = extern struct {
    sType: StructureType = .copy_buffer_info_2_khr,
    pNext: ?*const c_void = null,
    srcBuffer: Buffer,
    dstBuffer: Buffer,
    regionCount: u32,
    pRegions: [*]const BufferCopy2KHR,
};
pub const CopyImageInfo2KHR = extern struct {
    sType: StructureType = .copy_image_info_2_khr,
    pNext: ?*const c_void = null,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const ImageCopy2KHR,
};
pub const BlitImageInfo2KHR = extern struct {
    sType: StructureType = .blit_image_info_2_khr,
    pNext: ?*const c_void = null,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const ImageBlit2KHR,
    filter: Filter,
};
pub const CopyBufferToImageInfo2KHR = extern struct {
    sType: StructureType = .copy_buffer_to_image_info_2_khr,
    pNext: ?*const c_void = null,
    srcBuffer: Buffer,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const BufferImageCopy2KHR,
};
pub const CopyImageToBufferInfo2KHR = extern struct {
    sType: StructureType = .copy_image_to_buffer_info_2_khr,
    pNext: ?*const c_void = null,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstBuffer: Buffer,
    regionCount: u32,
    pRegions: [*]const BufferImageCopy2KHR,
};
pub const ResolveImageInfo2KHR = extern struct {
    sType: StructureType = .resolve_image_info_2_khr,
    pNext: ?*const c_void = null,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const ImageResolve2KHR,
};
pub const PhysicalDeviceShaderImageAtomicInt64FeaturesEXT = extern struct {
    sType: StructureType = .physical_device_shader_image_atomic_int64_features_ext,
    pNext: ?*c_void = null,
    shaderImageInt64Atomics: Bool32,
    sparseImageInt64Atomics: Bool32,
};
pub const FragmentShadingRateAttachmentInfoKHR = extern struct {
    sType: StructureType = .fragment_shading_rate_attachment_info_khr,
    pNext: ?*const c_void = null,
    pFragmentShadingRateAttachment: *const AttachmentReference2,
    shadingRateAttachmentTexelSize: Extent2D,
};
pub const PipelineFragmentShadingRateStateCreateInfoKHR = extern struct {
    sType: StructureType = .pipeline_fragment_shading_rate_state_create_info_khr,
    pNext: ?*const c_void = null,
    fragmentSize: Extent2D,
    combinerOps: [2]FragmentShadingRateCombinerOpKHR,
};
pub const PhysicalDeviceFragmentShadingRateFeaturesKHR = extern struct {
    sType: StructureType = .physical_device_fragment_shading_rate_features_khr,
    pNext: ?*c_void = null,
    pipelineFragmentShadingRate: Bool32,
    primitiveFragmentShadingRate: Bool32,
    attachmentFragmentShadingRate: Bool32,
};
pub const PhysicalDeviceFragmentShadingRatePropertiesKHR = extern struct {
    sType: StructureType = .physical_device_fragment_shading_rate_properties_khr,
    pNext: ?*c_void = null,
    minFragmentShadingRateAttachmentTexelSize: Extent2D,
    maxFragmentShadingRateAttachmentTexelSize: Extent2D,
    maxFragmentShadingRateAttachmentTexelSizeAspectRatio: u32,
    primitiveFragmentShadingRateWithMultipleViewports: Bool32,
    layeredShadingRateAttachments: Bool32,
    fragmentShadingRateNonTrivialCombinerOps: Bool32,
    maxFragmentSize: Extent2D,
    maxFragmentSizeAspectRatio: u32,
    maxFragmentShadingRateCoverageSamples: u32,
    maxFragmentShadingRateRasterizationSamples: SampleCountFlags,
    fragmentShadingRateWithShaderDepthStencilWrites: Bool32,
    fragmentShadingRateWithSampleMask: Bool32,
    fragmentShadingRateWithShaderSampleMask: Bool32,
    fragmentShadingRateWithConservativeRasterization: Bool32,
    fragmentShadingRateWithFragmentShaderInterlock: Bool32,
    fragmentShadingRateWithCustomSampleLocations: Bool32,
    fragmentShadingRateStrictMultiplyCombiner: Bool32,
};
pub const PhysicalDeviceFragmentShadingRateKHR = extern struct {
    sType: StructureType = .physical_device_fragment_shading_rate_khr,
    pNext: ?*c_void = null,
    sampleCounts: SampleCountFlags,
    fragmentSize: Extent2D,
};
pub const PhysicalDeviceShaderTerminateInvocationFeaturesKHR = extern struct {
    sType: StructureType = .physical_device_shader_terminate_invocation_features_khr,
    pNext: ?*c_void = null,
    shaderTerminateInvocation: Bool32,
};
pub const PhysicalDeviceFragmentShadingRateEnumsFeaturesNV = extern struct {
    sType: StructureType = .physical_device_fragment_shading_rate_enums_features_nv,
    pNext: ?*c_void = null,
    fragmentShadingRateEnums: Bool32,
    supersampleFragmentShadingRates: Bool32,
    noInvocationFragmentShadingRates: Bool32,
};
pub const PhysicalDeviceFragmentShadingRateEnumsPropertiesNV = extern struct {
    sType: StructureType = .physical_device_fragment_shading_rate_enums_properties_nv,
    pNext: ?*c_void = null,
    maxFragmentShadingRateInvocationCount: SampleCountFlags,
};
pub const PipelineFragmentShadingRateEnumStateCreateInfoNV = extern struct {
    sType: StructureType = .pipeline_fragment_shading_rate_enum_state_create_info_nv,
    pNext: ?*const c_void = null,
    shadingRateType: FragmentShadingRateTypeNV,
    shadingRate: FragmentShadingRateNV,
    combinerOps: [2]FragmentShadingRateCombinerOpKHR,
};
pub const AccelerationStructureBuildSizesInfoKHR = extern struct {
    sType: StructureType = .acceleration_structure_build_sizes_info_khr,
    pNext: ?*const c_void = null,
    accelerationStructureSize: DeviceSize,
    updateScratchSize: DeviceSize,
    buildScratchSize: DeviceSize,
};
pub const ImageLayout = extern enum {
    undefined_ = 0,
    general = 1,
    color_attachment_optimal = 2,
    depth_stencil_attachment_optimal = 3,
    depth_stencil_read_only_optimal = 4,
    shader_read_only_optimal = 5,
    transfer_src_optimal = 6,
    transfer_dst_optimal = 7,
    preinitialized = 8,
    depth_read_only_stencil_attachment_optimal = 1000117000,
    depth_attachment_stencil_read_only_optimal = 1000117001,
    depth_attachment_optimal = 1000241000,
    depth_read_only_optimal = 1000241001,
    stencil_attachment_optimal = 1000241002,
    stencil_read_only_optimal = 1000241003,
    present_src_khr = 1000001002,
    shared_present_khr = 1000111000,
    shading_rate_optimal_nv = 1000164003,
    fragment_density_map_optimal_ext = 1000218000,
    pub const fragment_shading_rate_attachment_optimal_khr = .shading_rate_optimal_nv;
};
pub const AttachmentLoadOp = extern enum {
    load = 0,
    clear = 1,
    dont_care = 2,
};
pub const AttachmentStoreOp = extern enum {
    store = 0,
    dont_care = 1,
    none_qcom = 1000301000,
};
pub const ImageType = extern enum {
    i1d = 0,
    i2d = 1,
    i3d = 2,
};
pub const ImageTiling = extern enum {
    optimal = 0,
    linear = 1,
    drm_format_modifier_ext = 1000158000,
};
pub const ImageViewType = extern enum {
    i1d = 0,
    i2d = 1,
    i3d = 2,
    cube = 3,
    i1d_array = 4,
    i2d_array = 5,
    cube_array = 6,
};
pub const CommandBufferLevel = extern enum {
    primary = 0,
    secondary = 1,
};
pub const ComponentSwizzle = extern enum {
    identity = 0,
    zero = 1,
    one = 2,
    r = 3,
    g = 4,
    b = 5,
    a = 6,
};
pub const DescriptorType = extern enum {
    sampler = 0,
    combined_image_sampler = 1,
    sampled_image = 2,
    storage_image = 3,
    uniform_texel_buffer = 4,
    storage_texel_buffer = 5,
    uniform_buffer = 6,
    storage_buffer = 7,
    uniform_buffer_dynamic = 8,
    storage_buffer_dynamic = 9,
    input_attachment = 10,
    inline_uniform_block_ext = 1000138000,
    acceleration_structure_khr = 1000150000,
    acceleration_structure_nv = 1000165000,
};
pub const QueryType = extern enum {
    occlusion = 0,
    pipeline_statistics = 1,
    timestamp = 2,
    transform_feedback_stream_ext = 1000028004,
    performance_query_khr = 1000116000,
    acceleration_structure_compacted_size_khr = 1000150000,
    acceleration_structure_serialization_size_khr = 1000150001,
    acceleration_structure_compacted_size_nv = 1000165000,
    performance_query_intel = 1000210000,
};
pub const BorderColor = extern enum {
    float_transparent_black = 0,
    int_transparent_black = 1,
    float_opaque_black = 2,
    int_opaque_black = 3,
    float_opaque_white = 4,
    int_opaque_white = 5,
    float_custom_ext = 1000287003,
    int_custom_ext = 1000287004,
};
pub const PipelineBindPoint = extern enum {
    graphics = 0,
    compute = 1,
    ray_tracing_khr = 1000165000,
    pub const ray_tracing_nv = .ray_tracing_khr;
};
pub const PipelineCacheHeaderVersion = extern enum {
    one = 1,
};
pub const PipelineCacheCreateFlags = packed struct {
    externally_synchronized_bit_ext: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(PipelineCacheCreateFlags);
};
pub const PrimitiveTopology = extern enum {
    point_list = 0,
    line_list = 1,
    line_strip = 2,
    triangle_list = 3,
    triangle_strip = 4,
    triangle_fan = 5,
    line_list_with_adjacency = 6,
    line_strip_with_adjacency = 7,
    triangle_list_with_adjacency = 8,
    triangle_strip_with_adjacency = 9,
    patch_list = 10,
};
pub const SharingMode = extern enum {
    exclusive = 0,
    concurrent = 1,
};
pub const IndexType = extern enum {
    uint16 = 0,
    uint32 = 1,
    none_khr = 1000165000,
    uint8_ext = 1000265000,
    pub const none_nv = .none_khr;
};
pub const Filter = extern enum {
    nearest = 0,
    linear = 1,
    cubic_img = 1000015000,
    pub const cubic_ext = .cubic_img;
};
pub const SamplerMipmapMode = extern enum {
    nearest = 0,
    linear = 1,
};
pub const SamplerAddressMode = extern enum {
    repeat = 0,
    mirrored_repeat = 1,
    clamp_to_edge = 2,
    clamp_to_border = 3,
    mirror_clamp_to_edge = 4,
};
pub const CompareOp = extern enum {
    never = 0,
    less = 1,
    equal = 2,
    less_or_equal = 3,
    greater = 4,
    not_equal = 5,
    greater_or_equal = 6,
    always = 7,
};
pub const PolygonMode = extern enum {
    fill = 0,
    line = 1,
    point = 2,
    fill_rectangle_nv = 1000153000,
};
pub const FrontFace = extern enum {
    counter_clockwise = 0,
    clockwise = 1,
};
pub const BlendFactor = extern enum {
    zero = 0,
    one = 1,
    src_color = 2,
    one_minus_src_color = 3,
    dst_color = 4,
    one_minus_dst_color = 5,
    src_alpha = 6,
    one_minus_src_alpha = 7,
    dst_alpha = 8,
    one_minus_dst_alpha = 9,
    constant_color = 10,
    one_minus_constant_color = 11,
    constant_alpha = 12,
    one_minus_constant_alpha = 13,
    src_alpha_saturate = 14,
    src1_color = 15,
    one_minus_src1_color = 16,
    src1_alpha = 17,
    one_minus_src1_alpha = 18,
};
pub const BlendOp = extern enum {
    add = 0,
    subtract = 1,
    reverse_subtract = 2,
    min = 3,
    max = 4,
    zero_ext = 1000148000,
    src_ext = 1000148001,
    dst_ext = 1000148002,
    src_over_ext = 1000148003,
    dst_over_ext = 1000148004,
    src_in_ext = 1000148005,
    dst_in_ext = 1000148006,
    src_out_ext = 1000148007,
    dst_out_ext = 1000148008,
    src_atop_ext = 1000148009,
    dst_atop_ext = 1000148010,
    xor_ext = 1000148011,
    multiply_ext = 1000148012,
    screen_ext = 1000148013,
    overlay_ext = 1000148014,
    darken_ext = 1000148015,
    lighten_ext = 1000148016,
    colordodge_ext = 1000148017,
    colorburn_ext = 1000148018,
    hardlight_ext = 1000148019,
    softlight_ext = 1000148020,
    difference_ext = 1000148021,
    exclusion_ext = 1000148022,
    invert_ext = 1000148023,
    invert_rgb_ext = 1000148024,
    lineardodge_ext = 1000148025,
    linearburn_ext = 1000148026,
    vividlight_ext = 1000148027,
    linearlight_ext = 1000148028,
    pinlight_ext = 1000148029,
    hardmix_ext = 1000148030,
    hsl_hue_ext = 1000148031,
    hsl_saturation_ext = 1000148032,
    hsl_color_ext = 1000148033,
    hsl_luminosity_ext = 1000148034,
    plus_ext = 1000148035,
    plus_clamped_ext = 1000148036,
    plus_clamped_alpha_ext = 1000148037,
    plus_darker_ext = 1000148038,
    minus_ext = 1000148039,
    minus_clamped_ext = 1000148040,
    contrast_ext = 1000148041,
    invert_ovg_ext = 1000148042,
    red_ext = 1000148043,
    green_ext = 1000148044,
    blue_ext = 1000148045,
};
pub const StencilOp = extern enum {
    keep = 0,
    zero = 1,
    replace = 2,
    increment_and_clamp = 3,
    decrement_and_clamp = 4,
    invert = 5,
    increment_and_wrap = 6,
    decrement_and_wrap = 7,
};
pub const LogicOp = extern enum {
    clear = 0,
    and_ = 1,
    and_reverse = 2,
    copy = 3,
    and_inverted = 4,
    no_op = 5,
    xor = 6,
    or_ = 7,
    nor = 8,
    equivalent = 9,
    invert = 10,
    or_reverse = 11,
    copy_inverted = 12,
    or_inverted = 13,
    nand = 14,
    set = 15,
};
pub const InternalAllocationType = extern enum {
    executable = 0,
};
pub const SystemAllocationScope = extern enum {
    command = 0,
    object = 1,
    cache = 2,
    device = 3,
    instance = 4,
};
pub const PhysicalDeviceType = extern enum {
    other = 0,
    integrated_gpu = 1,
    discrete_gpu = 2,
    virtual_gpu = 3,
    cpu = 4,
};
pub const VertexInputRate = extern enum {
    vertex = 0,
    instance = 1,
};
pub const Format = extern enum {
    undefined_ = 0,
    r4g4_unorm_pack8 = 1,
    r4g4b4a4_unorm_pack16 = 2,
    b4g4r4a4_unorm_pack16 = 3,
    r5g6b5_unorm_pack16 = 4,
    b5g6r5_unorm_pack16 = 5,
    r5g5b5a1_unorm_pack16 = 6,
    b5g5r5a1_unorm_pack16 = 7,
    a1r5g5b5_unorm_pack16 = 8,
    r8_unorm = 9,
    r8_snorm = 10,
    r8_uscaled = 11,
    r8_sscaled = 12,
    r8_uint = 13,
    r8_sint = 14,
    r8_srgb = 15,
    r8g8_unorm = 16,
    r8g8_snorm = 17,
    r8g8_uscaled = 18,
    r8g8_sscaled = 19,
    r8g8_uint = 20,
    r8g8_sint = 21,
    r8g8_srgb = 22,
    r8g8b8_unorm = 23,
    r8g8b8_snorm = 24,
    r8g8b8_uscaled = 25,
    r8g8b8_sscaled = 26,
    r8g8b8_uint = 27,
    r8g8b8_sint = 28,
    r8g8b8_srgb = 29,
    b8g8r8_unorm = 30,
    b8g8r8_snorm = 31,
    b8g8r8_uscaled = 32,
    b8g8r8_sscaled = 33,
    b8g8r8_uint = 34,
    b8g8r8_sint = 35,
    b8g8r8_srgb = 36,
    r8g8b8a8_unorm = 37,
    r8g8b8a8_snorm = 38,
    r8g8b8a8_uscaled = 39,
    r8g8b8a8_sscaled = 40,
    r8g8b8a8_uint = 41,
    r8g8b8a8_sint = 42,
    r8g8b8a8_srgb = 43,
    b8g8r8a8_unorm = 44,
    b8g8r8a8_snorm = 45,
    b8g8r8a8_uscaled = 46,
    b8g8r8a8_sscaled = 47,
    b8g8r8a8_uint = 48,
    b8g8r8a8_sint = 49,
    b8g8r8a8_srgb = 50,
    a8b8g8r8_unorm_pack32 = 51,
    a8b8g8r8_snorm_pack32 = 52,
    a8b8g8r8_uscaled_pack32 = 53,
    a8b8g8r8_sscaled_pack32 = 54,
    a8b8g8r8_uint_pack32 = 55,
    a8b8g8r8_sint_pack32 = 56,
    a8b8g8r8_srgb_pack32 = 57,
    a2r10g10b10_unorm_pack32 = 58,
    a2r10g10b10_snorm_pack32 = 59,
    a2r10g10b10_uscaled_pack32 = 60,
    a2r10g10b10_sscaled_pack32 = 61,
    a2r10g10b10_uint_pack32 = 62,
    a2r10g10b10_sint_pack32 = 63,
    a2b10g10r10_unorm_pack32 = 64,
    a2b10g10r10_snorm_pack32 = 65,
    a2b10g10r10_uscaled_pack32 = 66,
    a2b10g10r10_sscaled_pack32 = 67,
    a2b10g10r10_uint_pack32 = 68,
    a2b10g10r10_sint_pack32 = 69,
    r16_unorm = 70,
    r16_snorm = 71,
    r16_uscaled = 72,
    r16_sscaled = 73,
    r16_uint = 74,
    r16_sint = 75,
    r16_sfloat = 76,
    r16g16_unorm = 77,
    r16g16_snorm = 78,
    r16g16_uscaled = 79,
    r16g16_sscaled = 80,
    r16g16_uint = 81,
    r16g16_sint = 82,
    r16g16_sfloat = 83,
    r16g16b16_unorm = 84,
    r16g16b16_snorm = 85,
    r16g16b16_uscaled = 86,
    r16g16b16_sscaled = 87,
    r16g16b16_uint = 88,
    r16g16b16_sint = 89,
    r16g16b16_sfloat = 90,
    r16g16b16a16_unorm = 91,
    r16g16b16a16_snorm = 92,
    r16g16b16a16_uscaled = 93,
    r16g16b16a16_sscaled = 94,
    r16g16b16a16_uint = 95,
    r16g16b16a16_sint = 96,
    r16g16b16a16_sfloat = 97,
    r32_uint = 98,
    r32_sint = 99,
    r32_sfloat = 100,
    r32g32_uint = 101,
    r32g32_sint = 102,
    r32g32_sfloat = 103,
    r32g32b32_uint = 104,
    r32g32b32_sint = 105,
    r32g32b32_sfloat = 106,
    r32g32b32a32_uint = 107,
    r32g32b32a32_sint = 108,
    r32g32b32a32_sfloat = 109,
    r64_uint = 110,
    r64_sint = 111,
    r64_sfloat = 112,
    r64g64_uint = 113,
    r64g64_sint = 114,
    r64g64_sfloat = 115,
    r64g64b64_uint = 116,
    r64g64b64_sint = 117,
    r64g64b64_sfloat = 118,
    r64g64b64a64_uint = 119,
    r64g64b64a64_sint = 120,
    r64g64b64a64_sfloat = 121,
    b10g11r11_ufloat_pack32 = 122,
    e5b9g9r9_ufloat_pack32 = 123,
    d16_unorm = 124,
    x8_d24_unorm_pack32 = 125,
    d32_sfloat = 126,
    s8_uint = 127,
    d16_unorm_s8_uint = 128,
    d24_unorm_s8_uint = 129,
    d32_sfloat_s8_uint = 130,
    bc1_rgb_unorm_block = 131,
    bc1_rgb_srgb_block = 132,
    bc1_rgba_unorm_block = 133,
    bc1_rgba_srgb_block = 134,
    bc2_unorm_block = 135,
    bc2_srgb_block = 136,
    bc3_unorm_block = 137,
    bc3_srgb_block = 138,
    bc4_unorm_block = 139,
    bc4_snorm_block = 140,
    bc5_unorm_block = 141,
    bc5_snorm_block = 142,
    bc6h_ufloat_block = 143,
    bc6h_sfloat_block = 144,
    bc7_unorm_block = 145,
    bc7_srgb_block = 146,
    etc2_r8g8b8_unorm_block = 147,
    etc2_r8g8b8_srgb_block = 148,
    etc2_r8g8b8a1_unorm_block = 149,
    etc2_r8g8b8a1_srgb_block = 150,
    etc2_r8g8b8a8_unorm_block = 151,
    etc2_r8g8b8a8_srgb_block = 152,
    eac_r11_unorm_block = 153,
    eac_r11_snorm_block = 154,
    eac_r11g11_unorm_block = 155,
    eac_r11g11_snorm_block = 156,
    astc_4x_4_unorm_block = 157,
    astc_4x_4_srgb_block = 158,
    astc_5x_4_unorm_block = 159,
    astc_5x_4_srgb_block = 160,
    astc_5x_5_unorm_block = 161,
    astc_5x_5_srgb_block = 162,
    astc_6x_5_unorm_block = 163,
    astc_6x_5_srgb_block = 164,
    astc_6x_6_unorm_block = 165,
    astc_6x_6_srgb_block = 166,
    astc_8x_5_unorm_block = 167,
    astc_8x_5_srgb_block = 168,
    astc_8x_6_unorm_block = 169,
    astc_8x_6_srgb_block = 170,
    astc_8x_8_unorm_block = 171,
    astc_8x_8_srgb_block = 172,
    astc_1_0x_5_unorm_block = 173,
    astc_1_0x_5_srgb_block = 174,
    astc_1_0x_6_unorm_block = 175,
    astc_1_0x_6_srgb_block = 176,
    astc_1_0x_8_unorm_block = 177,
    astc_1_0x_8_srgb_block = 178,
    astc_1_0x_10_unorm_block = 179,
    astc_1_0x_10_srgb_block = 180,
    astc_1_2x_10_unorm_block = 181,
    astc_1_2x_10_srgb_block = 182,
    astc_1_2x_12_unorm_block = 183,
    astc_1_2x_12_srgb_block = 184,
    g8b8g8r8_422_unorm = 1000156000,
    b8g8r8g8_422_unorm = 1000156001,
    g8_b8_r8_3plane_420_unorm = 1000156002,
    g8_b8r8_2plane_420_unorm = 1000156003,
    g8_b8_r8_3plane_422_unorm = 1000156004,
    g8_b8r8_2plane_422_unorm = 1000156005,
    g8_b8_r8_3plane_444_unorm = 1000156006,
    r10x6_unorm_pack16 = 1000156007,
    r10x6g10x6_unorm_2pack16 = 1000156008,
    r10x6g10x6b10x6a10x6_unorm_4pack16 = 1000156009,
    g10x6b10x6g10x6r10x6_422_unorm_4pack16 = 1000156010,
    b10x6g10x6r10x6g10x6_422_unorm_4pack16 = 1000156011,
    g10x6_b10x6_r10x6_3plane_420_unorm_3pack16 = 1000156012,
    g10x6_b10x6r10x6_2plane_420_unorm_3pack16 = 1000156013,
    g10x6_b10x6_r10x6_3plane_422_unorm_3pack16 = 1000156014,
    g10x6_b10x6r10x6_2plane_422_unorm_3pack16 = 1000156015,
    g10x6_b10x6_r10x6_3plane_444_unorm_3pack16 = 1000156016,
    r12x4_unorm_pack16 = 1000156017,
    r12x4g12x4_unorm_2pack16 = 1000156018,
    r12x4g12x4b12x4a12x4_unorm_4pack16 = 1000156019,
    g12x4b12x4g12x4r12x4_422_unorm_4pack16 = 1000156020,
    b12x4g12x4r12x4g12x4_422_unorm_4pack16 = 1000156021,
    g12x4_b12x4_r12x4_3plane_420_unorm_3pack16 = 1000156022,
    g12x4_b12x4r12x4_2plane_420_unorm_3pack16 = 1000156023,
    g12x4_b12x4_r12x4_3plane_422_unorm_3pack16 = 1000156024,
    g12x4_b12x4r12x4_2plane_422_unorm_3pack16 = 1000156025,
    g12x4_b12x4_r12x4_3plane_444_unorm_3pack16 = 1000156026,
    g16b16g16r16_422_unorm = 1000156027,
    b16g16r16g16_422_unorm = 1000156028,
    g16_b16_r16_3plane_420_unorm = 1000156029,
    g16_b16r16_2plane_420_unorm = 1000156030,
    g16_b16_r16_3plane_422_unorm = 1000156031,
    g16_b16r16_2plane_422_unorm = 1000156032,
    g16_b16_r16_3plane_444_unorm = 1000156033,
    pvrtc1_2bpp_unorm_block_img = 1000054000,
    pvrtc1_4bpp_unorm_block_img = 1000054001,
    pvrtc2_2bpp_unorm_block_img = 1000054002,
    pvrtc2_4bpp_unorm_block_img = 1000054003,
    pvrtc1_2bpp_srgb_block_img = 1000054004,
    pvrtc1_4bpp_srgb_block_img = 1000054005,
    pvrtc2_2bpp_srgb_block_img = 1000054006,
    pvrtc2_4bpp_srgb_block_img = 1000054007,
    astc_4x_4_sfloat_block_ext = 1000066000,
    astc_5x_4_sfloat_block_ext = 1000066001,
    astc_5x_5_sfloat_block_ext = 1000066002,
    astc_6x_5_sfloat_block_ext = 1000066003,
    astc_6x_6_sfloat_block_ext = 1000066004,
    astc_8x_5_sfloat_block_ext = 1000066005,
    astc_8x_6_sfloat_block_ext = 1000066006,
    astc_8x_8_sfloat_block_ext = 1000066007,
    astc_1_0x_5_sfloat_block_ext = 1000066008,
    astc_1_0x_6_sfloat_block_ext = 1000066009,
    astc_1_0x_8_sfloat_block_ext = 1000066010,
    astc_1_0x_10_sfloat_block_ext = 1000066011,
    astc_1_2x_10_sfloat_block_ext = 1000066012,
    astc_1_2x_12_sfloat_block_ext = 1000066013,
    a4r4g4b4_unorm_pack16_ext = 1000340000,
    a4b4g4r4_unorm_pack16_ext = 1000340001,
};
pub const StructureType = extern enum {
    application_info = 0,
    instance_create_info = 1,
    device_queue_create_info = 2,
    device_create_info = 3,
    submit_info = 4,
    memory_allocate_info = 5,
    mapped_memory_range = 6,
    bind_sparse_info = 7,
    fence_create_info = 8,
    semaphore_create_info = 9,
    event_create_info = 10,
    query_pool_create_info = 11,
    buffer_create_info = 12,
    buffer_view_create_info = 13,
    image_create_info = 14,
    image_view_create_info = 15,
    shader_module_create_info = 16,
    pipeline_cache_create_info = 17,
    pipeline_shader_stage_create_info = 18,
    pipeline_vertex_input_state_create_info = 19,
    pipeline_input_assembly_state_create_info = 20,
    pipeline_tessellation_state_create_info = 21,
    pipeline_viewport_state_create_info = 22,
    pipeline_rasterization_state_create_info = 23,
    pipeline_multisample_state_create_info = 24,
    pipeline_depth_stencil_state_create_info = 25,
    pipeline_color_blend_state_create_info = 26,
    pipeline_dynamic_state_create_info = 27,
    graphics_pipeline_create_info = 28,
    compute_pipeline_create_info = 29,
    pipeline_layout_create_info = 30,
    sampler_create_info = 31,
    descriptor_set_layout_create_info = 32,
    descriptor_pool_create_info = 33,
    descriptor_set_allocate_info = 34,
    write_descriptor_set = 35,
    copy_descriptor_set = 36,
    framebuffer_create_info = 37,
    render_pass_create_info = 38,
    command_pool_create_info = 39,
    command_buffer_allocate_info = 40,
    command_buffer_inheritance_info = 41,
    command_buffer_begin_info = 42,
    render_pass_begin_info = 43,
    buffer_memory_barrier = 44,
    image_memory_barrier = 45,
    memory_barrier = 46,
    loader_instance_create_info = 47,
    loader_device_create_info = 48,
    physical_device_subgroup_properties = 1000094000,
    bind_buffer_memory_info = 1000157000,
    bind_image_memory_info = 1000157001,
    physical_device_16bit_storage_features = 1000083000,
    memory_dedicated_requirements = 1000127000,
    memory_dedicated_allocate_info = 1000127001,
    memory_allocate_flags_info = 1000060000,
    device_group_render_pass_begin_info = 1000060003,
    device_group_command_buffer_begin_info = 1000060004,
    device_group_submit_info = 1000060005,
    device_group_bind_sparse_info = 1000060006,
    bind_buffer_memory_device_group_info = 1000060013,
    bind_image_memory_device_group_info = 1000060014,
    physical_device_group_properties = 1000070000,
    device_group_device_create_info = 1000070001,
    buffer_memory_requirements_info_2 = 1000146000,
    image_memory_requirements_info_2 = 1000146001,
    image_sparse_memory_requirements_info_2 = 1000146002,
    memory_requirements_2 = 1000146003,
    sparse_image_memory_requirements_2 = 1000146004,
    physical_device_features_2 = 1000059000,
    physical_device_properties_2 = 1000059001,
    format_properties_2 = 1000059002,
    image_format_properties_2 = 1000059003,
    physical_device_image_format_info_2 = 1000059004,
    queue_family_properties_2 = 1000059005,
    physical_device_memory_properties_2 = 1000059006,
    sparse_image_format_properties_2 = 1000059007,
    physical_device_sparse_image_format_info_2 = 1000059008,
    physical_device_point_clipping_properties = 1000117000,
    render_pass_input_attachment_aspect_create_info = 1000117001,
    image_view_usage_create_info = 1000117002,
    pipeline_tessellation_domain_origin_state_create_info = 1000117003,
    render_pass_multiview_create_info = 1000053000,
    physical_device_multiview_features = 1000053001,
    physical_device_multiview_properties = 1000053002,
    physical_device_variable_pointers_features = 1000120000,
    protected_submit_info = 1000145000,
    physical_device_protected_memory_features = 1000145001,
    physical_device_protected_memory_properties = 1000145002,
    device_queue_info_2 = 1000145003,
    sampler_ycbcr_conversion_create_info = 1000156000,
    sampler_ycbcr_conversion_info = 1000156001,
    bind_image_plane_memory_info = 1000156002,
    image_plane_memory_requirements_info = 1000156003,
    physical_device_sampler_ycbcr_conversion_features = 1000156004,
    sampler_ycbcr_conversion_image_format_properties = 1000156005,
    descriptor_update_template_create_info = 1000085000,
    physical_device_external_image_format_info = 1000071000,
    external_image_format_properties = 1000071001,
    physical_device_external_buffer_info = 1000071002,
    external_buffer_properties = 1000071003,
    physical_device_id_properties = 1000071004,
    external_memory_buffer_create_info = 1000072000,
    external_memory_image_create_info = 1000072001,
    export_memory_allocate_info = 1000072002,
    physical_device_external_fence_info = 1000112000,
    external_fence_properties = 1000112001,
    export_fence_create_info = 1000113000,
    export_semaphore_create_info = 1000077000,
    physical_device_external_semaphore_info = 1000076000,
    external_semaphore_properties = 1000076001,
    physical_device_maintenance_3_properties = 1000168000,
    descriptor_set_layout_support = 1000168001,
    physical_device_shader_draw_parameters_features = 1000063000,
    physical_device_vulkan_1_1_features = 49,
    physical_device_vulkan_1_1_properties = 50,
    physical_device_vulkan_1_2_features = 51,
    physical_device_vulkan_1_2_properties = 52,
    image_format_list_create_info = 1000147000,
    attachment_description_2 = 1000109000,
    attachment_reference_2 = 1000109001,
    subpass_description_2 = 1000109002,
    subpass_dependency_2 = 1000109003,
    render_pass_create_info_2 = 1000109004,
    subpass_begin_info = 1000109005,
    subpass_end_info = 1000109006,
    physical_device_8bit_storage_features = 1000177000,
    physical_device_driver_properties = 1000196000,
    physical_device_shader_atomic_int64_features = 1000180000,
    physical_device_shader_float16_int8_features = 1000082000,
    physical_device_float_controls_properties = 1000197000,
    descriptor_set_layout_binding_flags_create_info = 1000161000,
    physical_device_descriptor_indexing_features = 1000161001,
    physical_device_descriptor_indexing_properties = 1000161002,
    descriptor_set_variable_descriptor_count_allocate_info = 1000161003,
    descriptor_set_variable_descriptor_count_layout_support = 1000161004,
    physical_device_depth_stencil_resolve_properties = 1000199000,
    subpass_description_depth_stencil_resolve = 1000199001,
    physical_device_scalar_block_layout_features = 1000221000,
    image_stencil_usage_create_info = 1000246000,
    physical_device_sampler_filter_minmax_properties = 1000130000,
    sampler_reduction_mode_create_info = 1000130001,
    physical_device_vulkan_memory_model_features = 1000211000,
    physical_device_imageless_framebuffer_features = 1000108000,
    framebuffer_attachments_create_info = 1000108001,
    framebuffer_attachment_image_info = 1000108002,
    render_pass_attachment_begin_info = 1000108003,
    physical_device_uniform_buffer_standard_layout_features = 1000253000,
    physical_device_shader_subgroup_extended_types_features = 1000175000,
    physical_device_separate_depth_stencil_layouts_features = 1000241000,
    attachment_reference_stencil_layout = 1000241001,
    attachment_description_stencil_layout = 1000241002,
    physical_device_host_query_reset_features = 1000261000,
    physical_device_timeline_semaphore_features = 1000207000,
    physical_device_timeline_semaphore_properties = 1000207001,
    semaphore_type_create_info = 1000207002,
    timeline_semaphore_submit_info = 1000207003,
    semaphore_wait_info = 1000207004,
    semaphore_signal_info = 1000207005,
    physical_device_buffer_device_address_features = 1000257000,
    buffer_device_address_info = 1000244001,
    buffer_opaque_capture_address_create_info = 1000257002,
    memory_opaque_capture_address_allocate_info = 1000257003,
    device_memory_opaque_capture_address_info = 1000257004,
    swapchain_create_info_khr = 1000001000,
    present_info_khr = 1000001001,
    device_group_present_capabilities_khr = 1000060007,
    image_swapchain_create_info_khr = 1000060008,
    bind_image_memory_swapchain_info_khr = 1000060009,
    acquire_next_image_info_khr = 1000060010,
    device_group_present_info_khr = 1000060011,
    device_group_swapchain_create_info_khr = 1000060012,
    display_mode_create_info_khr = 1000002000,
    display_surface_create_info_khr = 1000002001,
    display_present_info_khr = 1000003000,
    xlib_surface_create_info_khr = 1000004000,
    xcb_surface_create_info_khr = 1000005000,
    wayland_surface_create_info_khr = 1000006000,
    android_surface_create_info_khr = 1000008000,
    win32_surface_create_info_khr = 1000009000,
    debug_report_callback_create_info_ext = 1000011000,
    pipeline_rasterization_state_rasterization_order_amd = 1000018000,
    dedicated_allocation_image_create_info_nv = 1000026000,
    dedicated_allocation_buffer_create_info_nv = 1000026001,
    dedicated_allocation_memory_allocate_info_nv = 1000026002,
    physical_device_transform_feedback_features_ext = 1000028000,
    physical_device_transform_feedback_properties_ext = 1000028001,
    pipeline_rasterization_state_stream_create_info_ext = 1000028002,
    image_view_handle_info_nvx = 1000030000,
    image_view_address_properties_nvx = 1000030001,
    texture_lod_gather_format_properties_amd = 1000041000,
    stream_descriptor_surface_create_info_ggp = 1000049000,
    physical_device_corner_sampled_image_features_nv = 1000050000,
    external_memory_image_create_info_nv = 1000056000,
    export_memory_allocate_info_nv = 1000056001,
    import_memory_win32_handle_info_nv = 1000057000,
    export_memory_win32_handle_info_nv = 1000057001,
    validation_flags_ext = 1000061000,
    vi_surface_create_info_nn = 1000062000,
    physical_device_texture_compression_astc_hdr_features_ext = 1000066000,
    image_view_astc_decode_mode_ext = 1000067000,
    physical_device_astc_decode_features_ext = 1000067001,
    import_memory_win32_handle_info_khr = 1000073000,
    export_memory_win32_handle_info_khr = 1000073001,
    memory_win32_handle_properties_khr = 1000073002,
    memory_get_win32_handle_info_khr = 1000073003,
    import_memory_fd_info_khr = 1000074000,
    memory_fd_properties_khr = 1000074001,
    memory_get_fd_info_khr = 1000074002,
    win32_keyed_mutex_acquire_release_info_khr = 1000075000,
    import_semaphore_win32_handle_info_khr = 1000078000,
    export_semaphore_win32_handle_info_khr = 1000078001,
    d3d12_fence_submit_info_khr = 1000078002,
    semaphore_get_win32_handle_info_khr = 1000078003,
    import_semaphore_fd_info_khr = 1000079000,
    semaphore_get_fd_info_khr = 1000079001,
    physical_device_push_descriptor_properties_khr = 1000080000,
    command_buffer_inheritance_conditional_rendering_info_ext = 1000081000,
    physical_device_conditional_rendering_features_ext = 1000081001,
    conditional_rendering_begin_info_ext = 1000081002,
    present_regions_khr = 1000084000,
    pipeline_viewport_w_scaling_state_create_info_nv = 1000087000,
    surface_capabilities_2_ext = 1000090000,
    display_power_info_ext = 1000091000,
    device_event_info_ext = 1000091001,
    display_event_info_ext = 1000091002,
    swapchain_counter_create_info_ext = 1000091003,
    present_times_info_google = 1000092000,
    physical_device_multiview_per_view_attributes_properties_nvx = 1000097000,
    pipeline_viewport_swizzle_state_create_info_nv = 1000098000,
    physical_device_discard_rectangle_properties_ext = 1000099000,
    pipeline_discard_rectangle_state_create_info_ext = 1000099001,
    physical_device_conservative_rasterization_properties_ext = 1000101000,
    pipeline_rasterization_conservative_state_create_info_ext = 1000101001,
    physical_device_depth_clip_enable_features_ext = 1000102000,
    pipeline_rasterization_depth_clip_state_create_info_ext = 1000102001,
    hdr_metadata_ext = 1000105000,
    shared_present_surface_capabilities_khr = 1000111000,
    import_fence_win32_handle_info_khr = 1000114000,
    export_fence_win32_handle_info_khr = 1000114001,
    fence_get_win32_handle_info_khr = 1000114002,
    import_fence_fd_info_khr = 1000115000,
    fence_get_fd_info_khr = 1000115001,
    physical_device_performance_query_features_khr = 1000116000,
    physical_device_performance_query_properties_khr = 1000116001,
    query_pool_performance_create_info_khr = 1000116002,
    performance_query_submit_info_khr = 1000116003,
    acquire_profiling_lock_info_khr = 1000116004,
    performance_counter_khr = 1000116005,
    performance_counter_description_khr = 1000116006,
    physical_device_surface_info_2_khr = 1000119000,
    surface_capabilities_2_khr = 1000119001,
    surface_format_2_khr = 1000119002,
    display_properties_2_khr = 1000121000,
    display_plane_properties_2_khr = 1000121001,
    display_mode_properties_2_khr = 1000121002,
    display_plane_info_2_khr = 1000121003,
    display_plane_capabilities_2_khr = 1000121004,
    ios_surface_create_info_mvk = 1000122000,
    macos_surface_create_info_mvk = 1000123000,
    debug_utils_object_name_info_ext = 1000128000,
    debug_utils_object_tag_info_ext = 1000128001,
    debug_utils_label_ext = 1000128002,
    debug_utils_messenger_callback_data_ext = 1000128003,
    debug_utils_messenger_create_info_ext = 1000128004,
    android_hardware_buffer_usage_android = 1000129000,
    android_hardware_buffer_properties_android = 1000129001,
    android_hardware_buffer_format_properties_android = 1000129002,
    import_android_hardware_buffer_info_android = 1000129003,
    memory_get_android_hardware_buffer_info_android = 1000129004,
    external_format_android = 1000129005,
    physical_device_inline_uniform_block_features_ext = 1000138000,
    physical_device_inline_uniform_block_properties_ext = 1000138001,
    write_descriptor_set_inline_uniform_block_ext = 1000138002,
    descriptor_pool_inline_uniform_block_create_info_ext = 1000138003,
    sample_locations_info_ext = 1000143000,
    render_pass_sample_locations_begin_info_ext = 1000143001,
    pipeline_sample_locations_state_create_info_ext = 1000143002,
    physical_device_sample_locations_properties_ext = 1000143003,
    multisample_properties_ext = 1000143004,
    physical_device_blend_operation_advanced_features_ext = 1000148000,
    physical_device_blend_operation_advanced_properties_ext = 1000148001,
    pipeline_color_blend_advanced_state_create_info_ext = 1000148002,
    pipeline_coverage_to_color_state_create_info_nv = 1000149000,
    write_descriptor_set_acceleration_structure_khr = 1000150007,
    acceleration_structure_build_geometry_info_khr = 1000150000,
    acceleration_structure_device_address_info_khr = 1000150002,
    acceleration_structure_geometry_aabbs_data_khr = 1000150003,
    acceleration_structure_geometry_instances_data_khr = 1000150004,
    acceleration_structure_geometry_triangles_data_khr = 1000150005,
    acceleration_structure_geometry_khr = 1000150006,
    acceleration_structure_version_info_khr = 1000150009,
    copy_acceleration_structure_info_khr = 1000150010,
    copy_acceleration_structure_to_memory_info_khr = 1000150011,
    copy_memory_to_acceleration_structure_info_khr = 1000150012,
    physical_device_acceleration_structure_features_khr = 1000150013,
    physical_device_acceleration_structure_properties_khr = 1000150014,
    acceleration_structure_create_info_khr = 1000150017,
    acceleration_structure_build_sizes_info_khr = 1000150020,
    physical_device_ray_tracing_pipeline_features_khr = 1000347000,
    physical_device_ray_tracing_pipeline_properties_khr = 1000347001,
    ray_tracing_pipeline_create_info_khr = 1000150015,
    ray_tracing_shader_group_create_info_khr = 1000150016,
    ray_tracing_pipeline_interface_create_info_khr = 1000150018,
    physical_device_ray_query_features_khr = 1000348013,
    pipeline_coverage_modulation_state_create_info_nv = 1000152000,
    physical_device_shader_sm_builtins_features_nv = 1000154000,
    physical_device_shader_sm_builtins_properties_nv = 1000154001,
    drm_format_modifier_properties_list_ext = 1000158000,
    physical_device_image_drm_format_modifier_info_ext = 1000158002,
    image_drm_format_modifier_list_create_info_ext = 1000158003,
    image_drm_format_modifier_explicit_create_info_ext = 1000158004,
    image_drm_format_modifier_properties_ext = 1000158005,
    validation_cache_create_info_ext = 1000160000,
    shader_module_validation_cache_create_info_ext = 1000160001,
    physical_device_portability_subset_features_khr = 1000163000,
    physical_device_portability_subset_properties_khr = 1000163001,
    pipeline_viewport_shading_rate_image_state_create_info_nv = 1000164000,
    physical_device_shading_rate_image_features_nv = 1000164001,
    physical_device_shading_rate_image_properties_nv = 1000164002,
    pipeline_viewport_coarse_sample_order_state_create_info_nv = 1000164005,
    ray_tracing_pipeline_create_info_nv = 1000165000,
    acceleration_structure_create_info_nv = 1000165001,
    geometry_nv = 1000165003,
    geometry_triangles_nv = 1000165004,
    geometry_aabb_nv = 1000165005,
    bind_acceleration_structure_memory_info_nv = 1000165006,
    write_descriptor_set_acceleration_structure_nv = 1000165007,
    acceleration_structure_memory_requirements_info_nv = 1000165008,
    physical_device_ray_tracing_properties_nv = 1000165009,
    ray_tracing_shader_group_create_info_nv = 1000165011,
    acceleration_structure_info_nv = 1000165012,
    physical_device_representative_fragment_test_features_nv = 1000166000,
    pipeline_representative_fragment_test_state_create_info_nv = 1000166001,
    physical_device_image_view_image_format_info_ext = 1000170000,
    filter_cubic_image_view_image_format_properties_ext = 1000170001,
    device_queue_global_priority_create_info_ext = 1000174000,
    import_memory_host_pointer_info_ext = 1000178000,
    memory_host_pointer_properties_ext = 1000178001,
    physical_device_external_memory_host_properties_ext = 1000178002,
    physical_device_shader_clock_features_khr = 1000181000,
    pipeline_compiler_control_create_info_amd = 1000183000,
    calibrated_timestamp_info_ext = 1000184000,
    physical_device_shader_core_properties_amd = 1000185000,
    device_memory_overallocation_create_info_amd = 1000189000,
    physical_device_vertex_attribute_divisor_properties_ext = 1000190000,
    pipeline_vertex_input_divisor_state_create_info_ext = 1000190001,
    physical_device_vertex_attribute_divisor_features_ext = 1000190002,
    present_frame_token_ggp = 1000191000,
    pipeline_creation_feedback_create_info_ext = 1000192000,
    physical_device_compute_shader_derivatives_features_nv = 1000201000,
    physical_device_mesh_shader_features_nv = 1000202000,
    physical_device_mesh_shader_properties_nv = 1000202001,
    physical_device_fragment_shader_barycentric_features_nv = 1000203000,
    physical_device_shader_image_footprint_features_nv = 1000204000,
    pipeline_viewport_exclusive_scissor_state_create_info_nv = 1000205000,
    physical_device_exclusive_scissor_features_nv = 1000205002,
    checkpoint_data_nv = 1000206000,
    queue_family_checkpoint_properties_nv = 1000206001,
    physical_device_shader_integer_functions_2_features_intel = 1000209000,
    query_pool_performance_query_create_info_intel = 1000210000,
    initialize_performance_api_info_intel = 1000210001,
    performance_marker_info_intel = 1000210002,
    performance_stream_marker_info_intel = 1000210003,
    performance_override_info_intel = 1000210004,
    performance_configuration_acquire_info_intel = 1000210005,
    physical_device_pci_bus_info_properties_ext = 1000212000,
    display_native_hdr_surface_capabilities_amd = 1000213000,
    swapchain_display_native_hdr_create_info_amd = 1000213001,
    imagepipe_surface_create_info_fuchsia = 1000214000,
    physical_device_shader_terminate_invocation_features_khr = 1000215000,
    metal_surface_create_info_ext = 1000217000,
    physical_device_fragment_density_map_features_ext = 1000218000,
    physical_device_fragment_density_map_properties_ext = 1000218001,
    render_pass_fragment_density_map_create_info_ext = 1000218002,
    physical_device_subgroup_size_control_properties_ext = 1000225000,
    pipeline_shader_stage_required_subgroup_size_create_info_ext = 1000225001,
    physical_device_subgroup_size_control_features_ext = 1000225002,
    fragment_shading_rate_attachment_info_khr = 1000226000,
    pipeline_fragment_shading_rate_state_create_info_khr = 1000226001,
    physical_device_fragment_shading_rate_properties_khr = 1000226002,
    physical_device_fragment_shading_rate_features_khr = 1000226003,
    physical_device_fragment_shading_rate_khr = 1000226004,
    physical_device_shader_core_properties_2_amd = 1000227000,
    physical_device_coherent_memory_features_amd = 1000229000,
    physical_device_shader_image_atomic_int64_features_ext = 1000234000,
    physical_device_memory_budget_properties_ext = 1000237000,
    physical_device_memory_priority_features_ext = 1000238000,
    memory_priority_allocate_info_ext = 1000238001,
    surface_protected_capabilities_khr = 1000239000,
    physical_device_dedicated_allocation_image_aliasing_features_nv = 1000240000,
    physical_device_buffer_device_address_features_ext = 1000244000,
    buffer_device_address_create_info_ext = 1000244002,
    physical_device_tool_properties_ext = 1000245000,
    validation_features_ext = 1000247000,
    physical_device_cooperative_matrix_features_nv = 1000249000,
    cooperative_matrix_properties_nv = 1000249001,
    physical_device_cooperative_matrix_properties_nv = 1000249002,
    physical_device_coverage_reduction_mode_features_nv = 1000250000,
    pipeline_coverage_reduction_state_create_info_nv = 1000250001,
    framebuffer_mixed_samples_combination_nv = 1000250002,
    physical_device_fragment_shader_interlock_features_ext = 1000251000,
    physical_device_ycbcr_image_arrays_features_ext = 1000252000,
    surface_full_screen_exclusive_info_ext = 1000255000,
    surface_capabilities_full_screen_exclusive_ext = 1000255002,
    surface_full_screen_exclusive_win32_info_ext = 1000255001,
    headless_surface_create_info_ext = 1000256000,
    physical_device_line_rasterization_features_ext = 1000259000,
    pipeline_rasterization_line_state_create_info_ext = 1000259001,
    physical_device_line_rasterization_properties_ext = 1000259002,
    physical_device_shader_atomic_float_features_ext = 1000260000,
    physical_device_index_type_uint8_features_ext = 1000265000,
    physical_device_extended_dynamic_state_features_ext = 1000267000,
    physical_device_pipeline_executable_properties_features_khr = 1000269000,
    pipeline_info_khr = 1000269001,
    pipeline_executable_properties_khr = 1000269002,
    pipeline_executable_info_khr = 1000269003,
    pipeline_executable_statistic_khr = 1000269004,
    pipeline_executable_internal_representation_khr = 1000269005,
    physical_device_shader_demote_to_helper_invocation_features_ext = 1000276000,
    physical_device_device_generated_commands_properties_nv = 1000277000,
    graphics_shader_group_create_info_nv = 1000277001,
    graphics_pipeline_shader_groups_create_info_nv = 1000277002,
    indirect_commands_layout_token_nv = 1000277003,
    indirect_commands_layout_create_info_nv = 1000277004,
    generated_commands_info_nv = 1000277005,
    generated_commands_memory_requirements_info_nv = 1000277006,
    physical_device_device_generated_commands_features_nv = 1000277007,
    physical_device_texel_buffer_alignment_features_ext = 1000281000,
    physical_device_texel_buffer_alignment_properties_ext = 1000281001,
    command_buffer_inheritance_render_pass_transform_info_qcom = 1000282000,
    render_pass_transform_begin_info_qcom = 1000282001,
    physical_device_device_memory_report_features_ext = 1000284000,
    device_device_memory_report_create_info_ext = 1000284001,
    device_memory_report_callback_data_ext = 1000284002,
    physical_device_robustness_2_features_ext = 1000286000,
    physical_device_robustness_2_properties_ext = 1000286001,
    sampler_custom_border_color_create_info_ext = 1000287000,
    physical_device_custom_border_color_properties_ext = 1000287001,
    physical_device_custom_border_color_features_ext = 1000287002,
    pipeline_library_create_info_khr = 1000290000,
    physical_device_private_data_features_ext = 1000295000,
    device_private_data_create_info_ext = 1000295001,
    private_data_slot_create_info_ext = 1000295002,
    physical_device_pipeline_creation_cache_control_features_ext = 1000297000,
    physical_device_diagnostics_config_features_nv = 1000300000,
    device_diagnostics_config_create_info_nv = 1000300001,
    physical_device_fragment_shading_rate_enums_properties_nv = 1000326000,
    physical_device_fragment_shading_rate_enums_features_nv = 1000326001,
    pipeline_fragment_shading_rate_enum_state_create_info_nv = 1000326002,
    physical_device_fragment_density_map_2_features_ext = 1000332000,
    physical_device_fragment_density_map_2_properties_ext = 1000332001,
    copy_command_transform_info_qcom = 1000333000,
    physical_device_image_robustness_features_ext = 1000335000,
    copy_buffer_info_2_khr = 1000337000,
    copy_image_info_2_khr = 1000337001,
    copy_buffer_to_image_info_2_khr = 1000337002,
    copy_image_to_buffer_info_2_khr = 1000337003,
    blit_image_info_2_khr = 1000337004,
    resolve_image_info_2_khr = 1000337005,
    buffer_copy_2_khr = 1000337006,
    image_copy_2_khr = 1000337007,
    image_blit_2_khr = 1000337008,
    buffer_image_copy_2_khr = 1000337009,
    image_resolve_2_khr = 1000337010,
    physical_device_4444_formats_features_ext = 1000340000,
    directfb_surface_create_info_ext = 1000346000,
    debug_marker_object_name_info_ext = 1000022000,
    debug_marker_object_tag_info_ext = 1000022001,
    debug_marker_marker_info_ext = 1000022002,
    pub const physical_device_variable_pointer_features = .physical_device_variable_pointers_features;
    pub const physical_device_shader_draw_parameter_features = .physical_device_shader_draw_parameters_features;
    pub const query_pool_create_info_intel = .query_pool_performance_query_create_info_intel;
    pub const physical_device_buffer_address_features_ext = .physical_device_buffer_device_address_features_ext;
    pub const buffer_device_address_info_ext = .buffer_device_address_info;
};
pub const SubpassContents = extern enum {
    inline_ = 0,
    secondary_command_buffers = 1,
};
pub const Result = extern enum {
    success = 0,
    not_ready = 1,
    timeout = 2,
    event_set = 3,
    event_reset = 4,
    incomplete = 5,
    error_out_of_host_memory = -1,
    error_out_of_device_memory = -2,
    error_initialization_failed = -3,
    error_device_lost = -4,
    error_memory_map_failed = -5,
    error_layer_not_present = -6,
    error_extension_not_present = -7,
    error_feature_not_present = -8,
    error_incompatible_driver = -9,
    error_too_many_objects = -10,
    error_format_not_supported = -11,
    error_fragmented_pool = -12,
    error_unknown = -13,
    error_out_of_pool_memory = -1000069000,
    error_invalid_external_handle = -1000072003,
    error_fragmentation = -1000161000,
    error_invalid_opaque_capture_address = -1000257000,
    error_surface_lost_khr = -1000000000,
    error_native_window_in_use_khr = -1000000001,
    suboptimal_khr = 1000001003,
    error_out_of_date_khr = -1000001004,
    error_incompatible_display_khr = -1000003001,
    error_validation_failed_ext = -1000011001,
    error_invalid_shader_nv = -1000012000,
    error_invalid_drm_format_modifier_plane_layout_ext = -1000158000,
    error_not_permitted_ext = -1000174001,
    error_full_screen_exclusive_mode_lost_ext = -1000255000,
    thread_idle_khr = 1000268000,
    thread_done_khr = 1000268001,
    operation_deferred_khr = 1000268002,
    operation_not_deferred_khr = 1000268003,
    pipeline_compile_required_ext = 1000297000,
    pub const error_invalid_device_address_ext = .error_invalid_opaque_capture_address;
    pub const error_pipeline_compile_required_ext = .pipeline_compile_required_ext;
};
pub const DynamicState = extern enum {
    viewport = 0,
    scissor = 1,
    line_width = 2,
    depth_bias = 3,
    blend_constants = 4,
    depth_bounds = 5,
    stencil_compare_mask = 6,
    stencil_write_mask = 7,
    stencil_reference = 8,
    viewport_w_scaling_nv = 1000087000,
    discard_rectangle_ext = 1000099000,
    sample_locations_ext = 1000143000,
    ray_tracing_pipeline_stack_size_khr = 1000347000,
    viewport_shading_rate_palette_nv = 1000164004,
    viewport_coarse_sample_order_nv = 1000164006,
    exclusive_scissor_nv = 1000205001,
    fragment_shading_rate_khr = 1000226000,
    line_stipple_ext = 1000259000,
    cull_mode_ext = 1000267000,
    front_face_ext = 1000267001,
    primitive_topology_ext = 1000267002,
    viewport_with_count_ext = 1000267003,
    scissor_with_count_ext = 1000267004,
    vertex_input_binding_stride_ext = 1000267005,
    depth_test_enable_ext = 1000267006,
    depth_write_enable_ext = 1000267007,
    depth_compare_op_ext = 1000267008,
    depth_bounds_test_enable_ext = 1000267009,
    stencil_test_enable_ext = 1000267010,
    stencil_op_ext = 1000267011,
};
pub const DescriptorUpdateTemplateType = extern enum {
    descriptor_set = 0,
    push_descriptors_khr = 1,
};
pub const ObjectType = extern enum {
    unknown = 0,
    instance = 1,
    physical_device = 2,
    device = 3,
    queue = 4,
    semaphore = 5,
    command_buffer = 6,
    fence = 7,
    device_memory = 8,
    buffer = 9,
    image = 10,
    event = 11,
    query_pool = 12,
    buffer_view = 13,
    image_view = 14,
    shader_module = 15,
    pipeline_cache = 16,
    pipeline_layout = 17,
    render_pass = 18,
    pipeline = 19,
    descriptor_set_layout = 20,
    sampler = 21,
    descriptor_pool = 22,
    descriptor_set = 23,
    framebuffer = 24,
    command_pool = 25,
    sampler_ycbcr_conversion = 1000156000,
    descriptor_update_template = 1000085000,
    surface_khr = 1000000000,
    swapchain_khr = 1000001000,
    display_khr = 1000002000,
    display_mode_khr = 1000002001,
    debug_report_callback_ext = 1000011000,
    debug_utils_messenger_ext = 1000128000,
    acceleration_structure_khr = 1000150000,
    validation_cache_ext = 1000160000,
    acceleration_structure_nv = 1000165000,
    performance_configuration_intel = 1000210000,
    deferred_operation_khr = 1000268000,
    indirect_commands_layout_nv = 1000277000,
    private_data_slot_ext = 1000295000,
};
pub const QueueFlags = packed struct {
    graphics_bit: bool align(@alignOf(Flags)) = false,
    compute_bit: bool = false,
    transfer_bit: bool = false,
    sparse_binding_bit: bool = false,
    protected_bit: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(QueueFlags);
};
pub const CullModeFlags = packed struct {
    front_bit: bool align(@alignOf(Flags)) = false,
    back_bit: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(CullModeFlags);
};
pub const RenderPassCreateFlags = packed struct {
    _reserved_bit_0: bool align(@alignOf(Flags)) = false,
    transform_bit_qcom: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(RenderPassCreateFlags);
};
pub const DeviceQueueCreateFlags = packed struct {
    protected_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DeviceQueueCreateFlags);
};
pub const MemoryPropertyFlags = packed struct {
    device_local_bit: bool align(@alignOf(Flags)) = false,
    host_visible_bit: bool = false,
    host_coherent_bit: bool = false,
    host_cached_bit: bool = false,
    lazily_allocated_bit: bool = false,
    protected_bit: bool = false,
    device_coherent_bit_amd: bool = false,
    device_uncached_bit_amd: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(MemoryPropertyFlags);
};
pub const MemoryHeapFlags = packed struct {
    device_local_bit: bool align(@alignOf(Flags)) = false,
    multi_instance_bit: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(MemoryHeapFlags);
};
pub const AccessFlags = packed struct {
    indirect_command_read_bit: bool align(@alignOf(Flags)) = false,
    index_read_bit: bool = false,
    vertex_attribute_read_bit: bool = false,
    uniform_read_bit: bool = false,
    input_attachment_read_bit: bool = false,
    shader_read_bit: bool = false,
    shader_write_bit: bool = false,
    color_attachment_read_bit: bool = false,
    color_attachment_write_bit: bool = false,
    depth_stencil_attachment_read_bit: bool = false,
    depth_stencil_attachment_write_bit: bool = false,
    transfer_read_bit: bool = false,
    transfer_write_bit: bool = false,
    host_read_bit: bool = false,
    host_write_bit: bool = false,
    memory_read_bit: bool = false,
    memory_write_bit: bool = false,
    command_preprocess_read_bit_nv: bool = false,
    command_preprocess_write_bit_nv: bool = false,
    color_attachment_read_noncoherent_bit_ext: bool = false,
    conditional_rendering_read_bit_ext: bool = false,
    acceleration_structure_read_bit_khr: bool = false,
    acceleration_structure_write_bit_khr: bool = false,
    shading_rate_image_read_bit_nv: bool = false,
    fragment_density_map_read_bit_ext: bool = false,
    transform_feedback_write_bit_ext: bool = false,
    transform_feedback_counter_read_bit_ext: bool = false,
    transform_feedback_counter_write_bit_ext: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(AccessFlags);
};
pub const BufferUsageFlags = packed struct {
    transfer_src_bit: bool align(@alignOf(Flags)) = false,
    transfer_dst_bit: bool = false,
    uniform_texel_buffer_bit: bool = false,
    storage_texel_buffer_bit: bool = false,
    uniform_buffer_bit: bool = false,
    storage_buffer_bit: bool = false,
    index_buffer_bit: bool = false,
    vertex_buffer_bit: bool = false,
    indirect_buffer_bit: bool = false,
    conditional_rendering_bit_ext: bool = false,
    shader_binding_table_bit_khr: bool = false,
    transform_feedback_buffer_bit_ext: bool = false,
    transform_feedback_counter_buffer_bit_ext: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    shader_device_address_bit: bool = false,
    _reserved_bit_18: bool = false,
    acceleration_structure_build_input_read_only_bit_khr: bool = false,
    acceleration_structure_storage_bit_khr: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(BufferUsageFlags);
};
pub const BufferCreateFlags = packed struct {
    sparse_binding_bit: bool align(@alignOf(Flags)) = false,
    sparse_residency_bit: bool = false,
    sparse_aliased_bit: bool = false,
    protected_bit: bool = false,
    device_address_capture_replay_bit: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(BufferCreateFlags);
};
pub const ShaderStageFlags = packed struct {
    vertex_bit: bool align(@alignOf(Flags)) = false,
    tessellation_control_bit: bool = false,
    tessellation_evaluation_bit: bool = false,
    geometry_bit: bool = false,
    fragment_bit: bool = false,
    compute_bit: bool = false,
    task_bit_nv: bool = false,
    mesh_bit_nv: bool = false,
    raygen_bit_khr: bool = false,
    any_hit_bit_khr: bool = false,
    closest_hit_bit_khr: bool = false,
    miss_bit_khr: bool = false,
    intersection_bit_khr: bool = false,
    callable_bit_khr: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ShaderStageFlags);
};
pub const ImageUsageFlags = packed struct {
    transfer_src_bit: bool align(@alignOf(Flags)) = false,
    transfer_dst_bit: bool = false,
    sampled_bit: bool = false,
    storage_bit: bool = false,
    color_attachment_bit: bool = false,
    depth_stencil_attachment_bit: bool = false,
    transient_attachment_bit: bool = false,
    input_attachment_bit: bool = false,
    shading_rate_image_bit_nv: bool = false,
    fragment_density_map_bit_ext: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ImageUsageFlags);
};
pub const ImageCreateFlags = packed struct {
    sparse_binding_bit: bool align(@alignOf(Flags)) = false,
    sparse_residency_bit: bool = false,
    sparse_aliased_bit: bool = false,
    mutable_format_bit: bool = false,
    cube_compatible_bit: bool = false,
    i2d_array_compatible_bit: bool = false,
    split_instance_bind_regions_bit: bool = false,
    block_texel_view_compatible_bit: bool = false,
    extended_usage_bit: bool = false,
    disjoint_bit: bool = false,
    alias_bit: bool = false,
    protected_bit: bool = false,
    sample_locations_compatible_depth_bit_ext: bool = false,
    corner_sampled_bit_nv: bool = false,
    subsampled_bit_ext: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ImageCreateFlags);
};
pub const ImageViewCreateFlags = packed struct {
    fragment_density_map_dynamic_bit_ext: bool align(@alignOf(Flags)) = false,
    fragment_density_map_deferred_bit_ext: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ImageViewCreateFlags);
};
pub const SamplerCreateFlags = packed struct {
    subsampled_bit_ext: bool align(@alignOf(Flags)) = false,
    subsampled_coarse_reconstruction_bit_ext: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SamplerCreateFlags);
};
pub const PipelineCreateFlags = packed struct {
    disable_optimization_bit: bool align(@alignOf(Flags)) = false,
    allow_derivatives_bit: bool = false,
    derivative_bit: bool = false,
    view_index_from_device_index_bit: bool = false,
    dispatch_base_bit: bool = false,
    defer_compile_bit_nv: bool = false,
    capture_statistics_bit_khr: bool = false,
    capture_internal_representations_bit_khr: bool = false,
    fail_on_pipeline_compile_required_bit_ext: bool = false,
    early_return_on_failure_bit_ext: bool = false,
    _reserved_bit_10: bool = false,
    library_bit_khr: bool = false,
    ray_tracing_skip_triangles_bit_khr: bool = false,
    ray_tracing_skip_aabbs_bit_khr: bool = false,
    ray_tracing_no_null_any_hit_shaders_bit_khr: bool = false,
    ray_tracing_no_null_closest_hit_shaders_bit_khr: bool = false,
    ray_tracing_no_null_miss_shaders_bit_khr: bool = false,
    ray_tracing_no_null_intersection_shaders_bit_khr: bool = false,
    indirect_bindable_bit_nv: bool = false,
    ray_tracing_shader_group_handle_capture_replay_bit_khr: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(PipelineCreateFlags);
};
pub const PipelineShaderStageCreateFlags = packed struct {
    allow_varying_subgroup_size_bit_ext: bool align(@alignOf(Flags)) = false,
    require_full_subgroups_bit_ext: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(PipelineShaderStageCreateFlags);
};
pub const ColorComponentFlags = packed struct {
    r_bit: bool align(@alignOf(Flags)) = false,
    g_bit: bool = false,
    b_bit: bool = false,
    a_bit: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ColorComponentFlags);
};
pub const FenceCreateFlags = packed struct {
    signaled_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(FenceCreateFlags);
};
pub const FormatFeatureFlags = packed struct {
    sampled_image_bit: bool align(@alignOf(Flags)) = false,
    storage_image_bit: bool = false,
    storage_image_atomic_bit: bool = false,
    uniform_texel_buffer_bit: bool = false,
    storage_texel_buffer_bit: bool = false,
    storage_texel_buffer_atomic_bit: bool = false,
    vertex_buffer_bit: bool = false,
    color_attachment_bit: bool = false,
    color_attachment_blend_bit: bool = false,
    depth_stencil_attachment_bit: bool = false,
    blit_src_bit: bool = false,
    blit_dst_bit: bool = false,
    sampled_image_filter_linear_bit: bool = false,
    sampled_image_filter_cubic_bit_img: bool = false,
    transfer_src_bit: bool = false,
    transfer_dst_bit: bool = false,
    sampled_image_filter_minmax_bit: bool = false,
    midpoint_chroma_samples_bit: bool = false,
    sampled_image_ycbcr_conversion_linear_filter_bit: bool = false,
    sampled_image_ycbcr_conversion_separate_reconstruction_filter_bit: bool = false,
    sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_bit: bool = false,
    sampled_image_ycbcr_conversion_chroma_reconstruction_explicit_forceable_bit: bool = false,
    disjoint_bit: bool = false,
    cosited_chroma_samples_bit: bool = false,
    fragment_density_map_bit_ext: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    acceleration_structure_vertex_buffer_bit_khr: bool = false,
    fragment_shading_rate_attachment_bit_khr: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(FormatFeatureFlags);
};
pub const QueryControlFlags = packed struct {
    precise_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(QueryControlFlags);
};
pub const QueryResultFlags = packed struct {
    i64_bit: bool align(@alignOf(Flags)) = false,
    wait_bit: bool = false,
    with_availability_bit: bool = false,
    partial_bit: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(QueryResultFlags);
};
pub const CommandBufferUsageFlags = packed struct {
    one_time_submit_bit: bool align(@alignOf(Flags)) = false,
    render_pass_continue_bit: bool = false,
    simultaneous_use_bit: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(CommandBufferUsageFlags);
};
pub const QueryPipelineStatisticFlags = packed struct {
    input_assembly_vertices_bit: bool align(@alignOf(Flags)) = false,
    input_assembly_primitives_bit: bool = false,
    vertex_shader_invocations_bit: bool = false,
    geometry_shader_invocations_bit: bool = false,
    geometry_shader_primitives_bit: bool = false,
    clipping_invocations_bit: bool = false,
    clipping_primitives_bit: bool = false,
    fragment_shader_invocations_bit: bool = false,
    tessellation_control_shader_patches_bit: bool = false,
    tessellation_evaluation_shader_invocations_bit: bool = false,
    compute_shader_invocations_bit: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(QueryPipelineStatisticFlags);
};
pub const ImageAspectFlags = packed struct {
    color_bit: bool align(@alignOf(Flags)) = false,
    depth_bit: bool = false,
    stencil_bit: bool = false,
    metadata_bit: bool = false,
    plane_0_bit: bool = false,
    plane_1_bit: bool = false,
    plane_2_bit: bool = false,
    memory_plane_0_bit_ext: bool = false,
    memory_plane_1_bit_ext: bool = false,
    memory_plane_2_bit_ext: bool = false,
    memory_plane_3_bit_ext: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ImageAspectFlags);
};
pub const SparseImageFormatFlags = packed struct {
    single_miptail_bit: bool align(@alignOf(Flags)) = false,
    aligned_mip_size_bit: bool = false,
    nonstandard_block_size_bit: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SparseImageFormatFlags);
};
pub const SparseMemoryBindFlags = packed struct {
    metadata_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SparseMemoryBindFlags);
};
pub const PipelineStageFlags = packed struct {
    top_of_pipe_bit: bool align(@alignOf(Flags)) = false,
    draw_indirect_bit: bool = false,
    vertex_input_bit: bool = false,
    vertex_shader_bit: bool = false,
    tessellation_control_shader_bit: bool = false,
    tessellation_evaluation_shader_bit: bool = false,
    geometry_shader_bit: bool = false,
    fragment_shader_bit: bool = false,
    early_fragment_tests_bit: bool = false,
    late_fragment_tests_bit: bool = false,
    color_attachment_output_bit: bool = false,
    compute_shader_bit: bool = false,
    transfer_bit: bool = false,
    bottom_of_pipe_bit: bool = false,
    host_bit: bool = false,
    all_graphics_bit: bool = false,
    all_commands_bit: bool = false,
    command_preprocess_bit_nv: bool = false,
    conditional_rendering_bit_ext: bool = false,
    task_shader_bit_nv: bool = false,
    mesh_shader_bit_nv: bool = false,
    ray_tracing_shader_bit_khr: bool = false,
    shading_rate_image_bit_nv: bool = false,
    fragment_density_process_bit_ext: bool = false,
    transform_feedback_bit_ext: bool = false,
    acceleration_structure_build_bit_khr: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(PipelineStageFlags);
};
pub const CommandPoolCreateFlags = packed struct {
    transient_bit: bool align(@alignOf(Flags)) = false,
    reset_command_buffer_bit: bool = false,
    protected_bit: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(CommandPoolCreateFlags);
};
pub const CommandPoolResetFlags = packed struct {
    release_resources_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(CommandPoolResetFlags);
};
pub const CommandBufferResetFlags = packed struct {
    release_resources_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(CommandBufferResetFlags);
};
pub const SampleCountFlags = packed struct {
    i1_bit: bool align(@alignOf(Flags)) = false,
    i2_bit: bool = false,
    i4_bit: bool = false,
    i8_bit: bool = false,
    i16_bit: bool = false,
    i32_bit: bool = false,
    i64_bit: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SampleCountFlags);
};
pub const AttachmentDescriptionFlags = packed struct {
    may_alias_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(AttachmentDescriptionFlags);
};
pub const StencilFaceFlags = packed struct {
    front_bit: bool align(@alignOf(Flags)) = false,
    back_bit: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(StencilFaceFlags);
};
pub const DescriptorPoolCreateFlags = packed struct {
    free_descriptor_set_bit: bool align(@alignOf(Flags)) = false,
    update_after_bind_bit: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DescriptorPoolCreateFlags);
};
pub const DependencyFlags = packed struct {
    by_region_bit: bool align(@alignOf(Flags)) = false,
    view_local_bit: bool = false,
    device_group_bit: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DependencyFlags);
};
pub const SemaphoreType = extern enum {
    binary = 0,
    timeline = 1,
};
pub const SemaphoreWaitFlags = packed struct {
    any_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SemaphoreWaitFlags);
};
pub const PresentModeKHR = extern enum {
    immediate_khr = 0,
    mailbox_khr = 1,
    fifo_khr = 2,
    fifo_relaxed_khr = 3,
    shared_demand_refresh_khr = 1000111000,
    shared_continuous_refresh_khr = 1000111001,
};
pub const ColorSpaceKHR = extern enum {
    srgb_nonlinear_khr = 0,
    display_p3_nonlinear_ext = 1000104001,
    extended_srgb_linear_ext = 1000104002,
    display_p3_linear_ext = 1000104003,
    dci_p3_nonlinear_ext = 1000104004,
    bt709_linear_ext = 1000104005,
    bt709_nonlinear_ext = 1000104006,
    bt2020_linear_ext = 1000104007,
    hdr10_st2084_ext = 1000104008,
    dolbyvision_ext = 1000104009,
    hdr10_hlg_ext = 1000104010,
    adobergb_linear_ext = 1000104011,
    adobergb_nonlinear_ext = 1000104012,
    pass_through_ext = 1000104013,
    extended_srgb_nonlinear_ext = 1000104014,
    display_native_amd = 1000213000,
};
pub const DisplayPlaneAlphaFlagsKHR = packed struct {
    opaque_bit_khr: bool align(@alignOf(Flags)) = false,
    global_bit_khr: bool = false,
    per_pixel_bit_khr: bool = false,
    per_pixel_premultiplied_bit_khr: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DisplayPlaneAlphaFlagsKHR);
};
pub const CompositeAlphaFlagsKHR = packed struct {
    opaque_bit_khr: bool align(@alignOf(Flags)) = false,
    pre_multiplied_bit_khr: bool = false,
    post_multiplied_bit_khr: bool = false,
    inherit_bit_khr: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(CompositeAlphaFlagsKHR);
};
pub const SurfaceTransformFlagsKHR = packed struct {
    identity_bit_khr: bool align(@alignOf(Flags)) = false,
    rotate_90_bit_khr: bool = false,
    rotate_180_bit_khr: bool = false,
    rotate_270_bit_khr: bool = false,
    horizontal_mirror_bit_khr: bool = false,
    horizontal_mirror_rotate_90_bit_khr: bool = false,
    horizontal_mirror_rotate_180_bit_khr: bool = false,
    horizontal_mirror_rotate_270_bit_khr: bool = false,
    inherit_bit_khr: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SurfaceTransformFlagsKHR);
};
pub const SwapchainImageUsageFlagsANDROID = packed struct {
    shared_bit_android: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SwapchainImageUsageFlagsANDROID);
};
pub const TimeDomainEXT = extern enum {
    device_ext = 0,
    clock_monotonic_ext = 1,
    clock_monotonic_raw_ext = 2,
    query_performance_counter_ext = 3,
};
pub const DebugReportFlagsEXT = packed struct {
    information_bit_ext: bool align(@alignOf(Flags)) = false,
    warning_bit_ext: bool = false,
    performance_warning_bit_ext: bool = false,
    error_bit_ext: bool = false,
    debug_bit_ext: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DebugReportFlagsEXT);
};
pub const DebugReportObjectTypeEXT = extern enum {
    unknown_ext = 0,
    instance_ext = 1,
    physical_device_ext = 2,
    device_ext = 3,
    queue_ext = 4,
    semaphore_ext = 5,
    command_buffer_ext = 6,
    fence_ext = 7,
    device_memory_ext = 8,
    buffer_ext = 9,
    image_ext = 10,
    event_ext = 11,
    query_pool_ext = 12,
    buffer_view_ext = 13,
    image_view_ext = 14,
    shader_module_ext = 15,
    pipeline_cache_ext = 16,
    pipeline_layout_ext = 17,
    render_pass_ext = 18,
    pipeline_ext = 19,
    descriptor_set_layout_ext = 20,
    sampler_ext = 21,
    descriptor_pool_ext = 22,
    descriptor_set_ext = 23,
    framebuffer_ext = 24,
    command_pool_ext = 25,
    surface_khr_ext = 26,
    swapchain_khr_ext = 27,
    debug_report_callback_ext_ext = 28,
    display_khr_ext = 29,
    display_mode_khr_ext = 30,
    validation_cache_ext_ext = 33,
    sampler_ycbcr_conversion_ext = 1000156000,
    descriptor_update_template_ext = 1000085000,
    acceleration_structure_khr_ext = 1000150000,
    acceleration_structure_nv_ext = 1000165000,
};
pub const DeviceMemoryReportEventTypeEXT = extern enum {
    allocate_ext = 0,
    free_ext = 1,
    import_ext = 2,
    unimport_ext = 3,
    allocation_failed_ext = 4,
};
pub const RasterizationOrderAMD = extern enum {
    strict_amd = 0,
    relaxed_amd = 1,
};
pub const ExternalMemoryHandleTypeFlagsNV = packed struct {
    opaque_win32_bit_nv: bool align(@alignOf(Flags)) = false,
    opaque_win32_kmt_bit_nv: bool = false,
    d3d11_image_bit_nv: bool = false,
    d3d11_image_kmt_bit_nv: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ExternalMemoryHandleTypeFlagsNV);
};
pub const ExternalMemoryFeatureFlagsNV = packed struct {
    dedicated_only_bit_nv: bool align(@alignOf(Flags)) = false,
    exportable_bit_nv: bool = false,
    importable_bit_nv: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ExternalMemoryFeatureFlagsNV);
};
pub const ValidationCheckEXT = extern enum {
    all_ext = 0,
    shaders_ext = 1,
};
pub const ValidationFeatureEnableEXT = extern enum {
    gpu_assisted_ext = 0,
    gpu_assisted_reserve_binding_slot_ext = 1,
    best_practices_ext = 2,
    debug_printf_ext = 3,
    synchronization_validation_ext = 4,
};
pub const ValidationFeatureDisableEXT = extern enum {
    all_ext = 0,
    shaders_ext = 1,
    thread_safety_ext = 2,
    api_parameters_ext = 3,
    object_lifetimes_ext = 4,
    core_checks_ext = 5,
    unique_handles_ext = 6,
};
pub const SubgroupFeatureFlags = packed struct {
    basic_bit: bool align(@alignOf(Flags)) = false,
    vote_bit: bool = false,
    arithmetic_bit: bool = false,
    ballot_bit: bool = false,
    shuffle_bit: bool = false,
    shuffle_relative_bit: bool = false,
    clustered_bit: bool = false,
    quad_bit: bool = false,
    partitioned_bit_nv: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SubgroupFeatureFlags);
};
pub const IndirectCommandsLayoutUsageFlagsNV = packed struct {
    explicit_preprocess_bit_nv: bool align(@alignOf(Flags)) = false,
    indexed_sequences_bit_nv: bool = false,
    unordered_sequences_bit_nv: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(IndirectCommandsLayoutUsageFlagsNV);
};
pub const IndirectStateFlagsNV = packed struct {
    frontface_bit_nv: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(IndirectStateFlagsNV);
};
pub const IndirectCommandsTokenTypeNV = extern enum {
    shader_group_nv = 0,
    state_flags_nv = 1,
    index_buffer_nv = 2,
    vertex_buffer_nv = 3,
    push_constant_nv = 4,
    draw_indexed_nv = 5,
    draw_nv = 6,
    draw_tasks_nv = 7,
};
pub const PrivateDataSlotCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PrivateDataSlotCreateFlagsEXT);
};
pub const DescriptorSetLayoutCreateFlags = packed struct {
    push_descriptor_bit_khr: bool align(@alignOf(Flags)) = false,
    update_after_bind_pool_bit: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DescriptorSetLayoutCreateFlags);
};
pub const ExternalMemoryHandleTypeFlags = packed struct {
    opaque_fd_bit: bool align(@alignOf(Flags)) = false,
    opaque_win32_bit: bool = false,
    opaque_win32_kmt_bit: bool = false,
    d3d11_texture_bit: bool = false,
    d3d11_texture_kmt_bit: bool = false,
    d3d12_heap_bit: bool = false,
    d3d12_resource_bit: bool = false,
    host_allocation_bit_ext: bool = false,
    host_mapped_foreign_memory_bit_ext: bool = false,
    dma_buf_bit_ext: bool = false,
    android_hardware_buffer_bit_android: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ExternalMemoryHandleTypeFlags);
};
pub const ExternalMemoryFeatureFlags = packed struct {
    dedicated_only_bit: bool align(@alignOf(Flags)) = false,
    exportable_bit: bool = false,
    importable_bit: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ExternalMemoryFeatureFlags);
};
pub const ExternalSemaphoreHandleTypeFlags = packed struct {
    opaque_fd_bit: bool align(@alignOf(Flags)) = false,
    opaque_win32_bit: bool = false,
    opaque_win32_kmt_bit: bool = false,
    d3d12_fence_bit: bool = false,
    sync_fd_bit: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ExternalSemaphoreHandleTypeFlags);
};
pub const ExternalSemaphoreFeatureFlags = packed struct {
    exportable_bit: bool align(@alignOf(Flags)) = false,
    importable_bit: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ExternalSemaphoreFeatureFlags);
};
pub const SemaphoreImportFlags = packed struct {
    temporary_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SemaphoreImportFlags);
};
pub const ExternalFenceHandleTypeFlags = packed struct {
    opaque_fd_bit: bool align(@alignOf(Flags)) = false,
    opaque_win32_bit: bool = false,
    opaque_win32_kmt_bit: bool = false,
    sync_fd_bit: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ExternalFenceHandleTypeFlags);
};
pub const ExternalFenceFeatureFlags = packed struct {
    exportable_bit: bool align(@alignOf(Flags)) = false,
    importable_bit: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ExternalFenceFeatureFlags);
};
pub const FenceImportFlags = packed struct {
    temporary_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(FenceImportFlags);
};
pub const SurfaceCounterFlagsEXT = packed struct {
    vblank_bit_ext: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SurfaceCounterFlagsEXT);
};
pub const DisplayPowerStateEXT = extern enum {
    off_ext = 0,
    suspend_ext = 1,
    on_ext = 2,
};
pub const DeviceEventTypeEXT = extern enum {
    display_hotplug_ext = 0,
};
pub const DisplayEventTypeEXT = extern enum {
    first_pixel_out_ext = 0,
};
pub const PeerMemoryFeatureFlags = packed struct {
    copy_src_bit: bool align(@alignOf(Flags)) = false,
    copy_dst_bit: bool = false,
    generic_src_bit: bool = false,
    generic_dst_bit: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(PeerMemoryFeatureFlags);
};
pub const MemoryAllocateFlags = packed struct {
    device_mask_bit: bool align(@alignOf(Flags)) = false,
    device_address_bit: bool = false,
    device_address_capture_replay_bit: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(MemoryAllocateFlags);
};
pub const DeviceGroupPresentModeFlagsKHR = packed struct {
    local_bit_khr: bool align(@alignOf(Flags)) = false,
    remote_bit_khr: bool = false,
    sum_bit_khr: bool = false,
    local_multi_device_bit_khr: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DeviceGroupPresentModeFlagsKHR);
};
pub const SwapchainCreateFlagsKHR = packed struct {
    split_instance_bind_regions_bit_khr: bool align(@alignOf(Flags)) = false,
    protected_bit_khr: bool = false,
    mutable_format_bit_khr: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SwapchainCreateFlagsKHR);
};
pub const ViewportCoordinateSwizzleNV = extern enum {
    positive_x_nv = 0,
    negative_x_nv = 1,
    positive_y_nv = 2,
    negative_y_nv = 3,
    positive_z_nv = 4,
    negative_z_nv = 5,
    positive_w_nv = 6,
    negative_w_nv = 7,
};
pub const DiscardRectangleModeEXT = extern enum {
    inclusive_ext = 0,
    exclusive_ext = 1,
};
pub const SubpassDescriptionFlags = packed struct {
    per_view_attributes_bit_nvx: bool align(@alignOf(Flags)) = false,
    per_view_position_x_only_bit_nvx: bool = false,
    fragment_region_bit_qcom: bool = false,
    shader_resolve_bit_qcom: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(SubpassDescriptionFlags);
};
pub const PointClippingBehavior = extern enum {
    all_clip_planes = 0,
    user_clip_planes_only = 1,
};
pub const SamplerReductionMode = extern enum {
    weighted_average = 0,
    min = 1,
    max = 2,
};
pub const TessellationDomainOrigin = extern enum {
    upper_left = 0,
    lower_left = 1,
};
pub const SamplerYcbcrModelConversion = extern enum {
    rgb_identity = 0,
    ycbcr_identity = 1,
    ycbcr_709 = 2,
    ycbcr_601 = 3,
    ycbcr_2020 = 4,
};
pub const SamplerYcbcrRange = extern enum {
    itu_full = 0,
    itu_narrow = 1,
};
pub const ChromaLocation = extern enum {
    cosited_even = 0,
    midpoint = 1,
};
pub const BlendOverlapEXT = extern enum {
    uncorrelated_ext = 0,
    disjoint_ext = 1,
    conjoint_ext = 2,
};
pub const CoverageModulationModeNV = extern enum {
    none_nv = 0,
    rgb_nv = 1,
    alpha_nv = 2,
    rgba_nv = 3,
};
pub const CoverageReductionModeNV = extern enum {
    merge_nv = 0,
    truncate_nv = 1,
};
pub const ValidationCacheHeaderVersionEXT = extern enum {
    one_ext = 1,
};
pub const ShaderInfoTypeAMD = extern enum {
    statistics_amd = 0,
    binary_amd = 1,
    disassembly_amd = 2,
};
pub const QueueGlobalPriorityEXT = extern enum {
    low_ext = 128,
    medium_ext = 256,
    high_ext = 512,
    realtime_ext = 1024,
};
pub const DebugUtilsMessageSeverityFlagsEXT = packed struct {
    verbose_bit_ext: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    info_bit_ext: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    warning_bit_ext: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    error_bit_ext: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DebugUtilsMessageSeverityFlagsEXT);
};
pub const DebugUtilsMessageTypeFlagsEXT = packed struct {
    general_bit_ext: bool align(@alignOf(Flags)) = false,
    validation_bit_ext: bool = false,
    performance_bit_ext: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DebugUtilsMessageTypeFlagsEXT);
};
pub const ConservativeRasterizationModeEXT = extern enum {
    disabled_ext = 0,
    overestimate_ext = 1,
    underestimate_ext = 2,
};
pub const DescriptorBindingFlags = packed struct {
    update_after_bind_bit: bool align(@alignOf(Flags)) = false,
    update_unused_while_pending_bit: bool = false,
    partially_bound_bit: bool = false,
    variable_descriptor_count_bit: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DescriptorBindingFlags);
};
pub const VendorId = extern enum {
    _viv = 0x10001,
    _vsi = 0x10002,
    kazan = 0x10003,
    codeplay = 0x10004,
    _mesa = 0x10005,
    pocl = 0x10006,
};
pub const DriverId = extern enum {
    amd_proprietary = 1,
    amd_open_source = 2,
    mesa_radv = 3,
    nvidia_proprietary = 4,
    intel_proprietary_windows = 5,
    intel_open_source_mesa = 6,
    imagination_proprietary = 7,
    qualcomm_proprietary = 8,
    arm_proprietary = 9,
    google_swiftshader = 10,
    ggp_proprietary = 11,
    broadcom_proprietary = 12,
    mesa_llvmpipe = 13,
    moltenvk = 14,
};
pub const ConditionalRenderingFlagsEXT = packed struct {
    inverted_bit_ext: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ConditionalRenderingFlagsEXT);
};
pub const ResolveModeFlags = packed struct {
    sample_zero_bit: bool align(@alignOf(Flags)) = false,
    average_bit: bool = false,
    min_bit: bool = false,
    max_bit: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ResolveModeFlags);
};
pub const ShadingRatePaletteEntryNV = extern enum {
    no_invocations_nv = 0,
    i16_invocations_per_pixel_nv = 1,
    i8_invocations_per_pixel_nv = 2,
    i4_invocations_per_pixel_nv = 3,
    i2_invocations_per_pixel_nv = 4,
    i1_invocation_per_pixel_nv = 5,
    i1_invocation_per_2x1_pixels_nv = 6,
    i1_invocation_per_1x2_pixels_nv = 7,
    i1_invocation_per_2x2_pixels_nv = 8,
    i1_invocation_per_4x2_pixels_nv = 9,
    i1_invocation_per_2x4_pixels_nv = 10,
    i1_invocation_per_4x4_pixels_nv = 11,
};
pub const CoarseSampleOrderTypeNV = extern enum {
    default_nv = 0,
    custom_nv = 1,
    pixel_major_nv = 2,
    sample_major_nv = 3,
};
pub const GeometryInstanceFlagsKHR = packed struct {
    triangle_facing_cull_disable_bit_khr: bool align(@alignOf(Flags)) = false,
    triangle_front_counterclockwise_bit_khr: bool = false,
    force_opaque_bit_khr: bool = false,
    force_no_opaque_bit_khr: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(GeometryInstanceFlagsKHR);
};
pub const GeometryFlagsKHR = packed struct {
    opaque_bit_khr: bool align(@alignOf(Flags)) = false,
    no_duplicate_any_hit_invocation_bit_khr: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(GeometryFlagsKHR);
};
pub const BuildAccelerationStructureFlagsKHR = packed struct {
    allow_update_bit_khr: bool align(@alignOf(Flags)) = false,
    allow_compaction_bit_khr: bool = false,
    prefer_fast_trace_bit_khr: bool = false,
    prefer_fast_build_bit_khr: bool = false,
    low_memory_bit_khr: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(BuildAccelerationStructureFlagsKHR);
};
pub const AccelerationStructureCreateFlagsKHR = packed struct {
    device_address_capture_replay_bit_khr: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(AccelerationStructureCreateFlagsKHR);
};
pub const CopyAccelerationStructureModeKHR = extern enum {
    clone_khr = 0,
    compact_khr = 1,
    serialize_khr = 2,
    deserialize_khr = 3,
    pub const clone_nv = .clone_khr;
    pub const compact_nv = .compact_khr;
};
pub const BuildAccelerationStructureModeKHR = extern enum {
    build_khr = 0,
    update_khr = 1,
};
pub const AccelerationStructureTypeKHR = extern enum {
    top_level_khr = 0,
    bottom_level_khr = 1,
    generic_khr = 2,
    pub const top_level_nv = .top_level_khr;
    pub const bottom_level_nv = .bottom_level_khr;
};
pub const GeometryTypeKHR = extern enum {
    triangles_khr = 0,
    aabbs_khr = 1,
    instances_khr = 2,
    pub const triangles_nv = .triangles_khr;
    pub const aabbs_nv = .aabbs_khr;
};
pub const AccelerationStructureMemoryRequirementsTypeNV = extern enum {
    object_nv = 0,
    build_scratch_nv = 1,
    update_scratch_nv = 2,
};
pub const AccelerationStructureBuildTypeKHR = extern enum {
    host_khr = 0,
    device_khr = 1,
    host_or_device_khr = 2,
};
pub const RayTracingShaderGroupTypeKHR = extern enum {
    general_khr = 0,
    triangles_hit_group_khr = 1,
    procedural_hit_group_khr = 2,
    pub const general_nv = .general_khr;
    pub const triangles_hit_group_nv = .triangles_hit_group_khr;
    pub const procedural_hit_group_nv = .procedural_hit_group_khr;
};
pub const AccelerationStructureCompatibilityKHR = extern enum {
    compatible_khr = 0,
    incompatible_khr = 1,
};
pub const ShaderGroupShaderKHR = extern enum {
    general_khr = 0,
    closest_hit_khr = 1,
    any_hit_khr = 2,
    intersection_khr = 3,
};
pub const MemoryOverallocationBehaviorAMD = extern enum {
    default_amd = 0,
    allowed_amd = 1,
    disallowed_amd = 2,
};
pub const FramebufferCreateFlags = packed struct {
    imageless_bit: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(FramebufferCreateFlags);
};
pub const ScopeNV = extern enum {
    device_nv = 1,
    workgroup_nv = 2,
    subgroup_nv = 3,
    queue_family_nv = 5,
};
pub const ComponentTypeNV = extern enum {
    float16_nv = 0,
    float32_nv = 1,
    float64_nv = 2,
    sint8_nv = 3,
    sint16_nv = 4,
    sint32_nv = 5,
    sint64_nv = 6,
    uint8_nv = 7,
    uint16_nv = 8,
    uint32_nv = 9,
    uint64_nv = 10,
};
pub const DeviceDiagnosticsConfigFlagsNV = packed struct {
    enable_shader_debug_info_bit_nv: bool align(@alignOf(Flags)) = false,
    enable_resource_tracking_bit_nv: bool = false,
    enable_automatic_checkpoints_bit_nv: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(DeviceDiagnosticsConfigFlagsNV);
};
pub const PipelineCreationFeedbackFlagsEXT = packed struct {
    valid_bit_ext: bool align(@alignOf(Flags)) = false,
    application_pipeline_cache_hit_bit_ext: bool = false,
    base_pipeline_acceleration_bit_ext: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(PipelineCreationFeedbackFlagsEXT);
};
pub const FullScreenExclusiveEXT = extern enum {
    default_ext = 0,
    allowed_ext = 1,
    disallowed_ext = 2,
    application_controlled_ext = 3,
};
pub const PerformanceCounterScopeKHR = extern enum {
    command_buffer_khr = 0,
    render_pass_khr = 1,
    command_khr = 2,
    pub const query_scope_command_buffer_khr = .command_buffer_khr;
    pub const query_scope_render_pass_khr = .render_pass_khr;
    pub const query_scope_command_khr = .command_khr;
};
pub const PerformanceCounterUnitKHR = extern enum {
    generic_khr = 0,
    percentage_khr = 1,
    nanoseconds_khr = 2,
    bytes_khr = 3,
    bytes_per_second_khr = 4,
    kelvin_khr = 5,
    watts_khr = 6,
    volts_khr = 7,
    amps_khr = 8,
    hertz_khr = 9,
    cycles_khr = 10,
};
pub const PerformanceCounterStorageKHR = extern enum {
    int32_khr = 0,
    int64_khr = 1,
    uint32_khr = 2,
    uint64_khr = 3,
    float32_khr = 4,
    float64_khr = 5,
};
pub const PerformanceCounterDescriptionFlagsKHR = packed struct {
    performance_impacting_bit_khr: bool align(@alignOf(Flags)) = false,
    concurrently_impacted_bit_khr: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    _reserved_bit_4: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(PerformanceCounterDescriptionFlagsKHR);
};
pub const AcquireProfilingLockFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(AcquireProfilingLockFlagsKHR);
};
pub const ShaderCorePropertiesFlagsAMD = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ShaderCorePropertiesFlagsAMD);
};
pub const PerformanceConfigurationTypeINTEL = extern enum {
    command_queue_metrics_discovery_activated_intel = 0,
};
pub const QueryPoolSamplingModeINTEL = extern enum {
    manual_intel = 0,
};
pub const PerformanceOverrideTypeINTEL = extern enum {
    null_hardware_intel = 0,
    flush_gpu_caches_intel = 1,
};
pub const PerformanceParameterTypeINTEL = extern enum {
    hw_counters_supported_intel = 0,
    stream_marker_valid_bits_intel = 1,
};
pub const PerformanceValueTypeINTEL = extern enum {
    uint32_intel = 0,
    uint64_intel = 1,
    float_intel = 2,
    bool_intel = 3,
    string_intel = 4,
};
pub const ShaderFloatControlsIndependence = extern enum {
    i32_bit_only = 0,
    all = 1,
    none = 2,
};
pub const PipelineExecutableStatisticFormatKHR = extern enum {
    bool32_khr = 0,
    int64_khr = 1,
    uint64_khr = 2,
    float64_khr = 3,
};
pub const LineRasterizationModeEXT = extern enum {
    default_ext = 0,
    rectangular_ext = 1,
    bresenham_ext = 2,
    rectangular_smooth_ext = 3,
};
pub const ShaderModuleCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ShaderModuleCreateFlags);
};
pub const PipelineCompilerControlFlagsAMD = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineCompilerControlFlagsAMD);
};
pub const ToolPurposeFlagsEXT = packed struct {
    validation_bit_ext: bool align(@alignOf(Flags)) = false,
    profiling_bit_ext: bool = false,
    tracing_bit_ext: bool = false,
    additional_features_bit_ext: bool = false,
    modifying_features_bit_ext: bool = false,
    debug_reporting_bit_ext: bool = false,
    debug_markers_bit_ext: bool = false,
    _reserved_bit_7: bool = false,
    _reserved_bit_8: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    _reserved_bit_12: bool = false,
    _reserved_bit_13: bool = false,
    _reserved_bit_14: bool = false,
    _reserved_bit_15: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    _reserved_bit_18: bool = false,
    _reserved_bit_19: bool = false,
    _reserved_bit_20: bool = false,
    _reserved_bit_21: bool = false,
    _reserved_bit_22: bool = false,
    _reserved_bit_23: bool = false,
    _reserved_bit_24: bool = false,
    _reserved_bit_25: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(ToolPurposeFlagsEXT);
};
pub const FragmentShadingRateCombinerOpKHR = extern enum {
    keep_khr = 0,
    replace_khr = 1,
    min_khr = 2,
    max_khr = 3,
    mul_khr = 4,
};
pub const FragmentShadingRateNV = extern enum {
    i1_invocation_per_pixel_nv = 0,
    i1_invocation_per_1x2_pixels_nv = 1,
    i1_invocation_per_2x1_pixels_nv = 4,
    i1_invocation_per_2x2_pixels_nv = 5,
    i1_invocation_per_2x4_pixels_nv = 6,
    i1_invocation_per_4x2_pixels_nv = 9,
    i1_invocation_per_4x4_pixels_nv = 10,
    i2_invocations_per_pixel_nv = 11,
    i4_invocations_per_pixel_nv = 12,
    i8_invocations_per_pixel_nv = 13,
    i16_invocations_per_pixel_nv = 14,
    no_invocations_nv = 15,
};
pub const FragmentShadingRateTypeNV = extern enum {
    fragment_size_nv = 0,
    enums_nv = 1,
};
pub const PfnCreateInstance = fn (
    p_create_info: *const InstanceCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_instance: *Instance,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyInstance = fn (
    instance: Instance,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnEnumeratePhysicalDevices = fn (
    instance: Instance,
    p_physical_device_count: *u32,
    p_physical_devices: ?[*]PhysicalDevice,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceProcAddr = fn (
    device: Device,
    p_name: [*:0]const u8,
) callconv(vulkan_call_conv) PfnVoidFunction;
pub const PfnGetInstanceProcAddr = fn (
    instance: Instance,
    p_name: [*:0]const u8,
) callconv(vulkan_call_conv) PfnVoidFunction;
pub const PfnGetPhysicalDeviceProperties = fn (
    physical_device: PhysicalDevice,
    p_properties: *PhysicalDeviceProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceQueueFamilyProperties = fn (
    physical_device: PhysicalDevice,
    p_queue_family_property_count: *u32,
    p_queue_family_properties: ?[*]QueueFamilyProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceMemoryProperties = fn (
    physical_device: PhysicalDevice,
    p_memory_properties: *PhysicalDeviceMemoryProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFeatures = fn (
    physical_device: PhysicalDevice,
    p_features: *PhysicalDeviceFeatures,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFormatProperties = fn (
    physical_device: PhysicalDevice,
    format: Format,
    p_format_properties: *FormatProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceImageFormatProperties = fn (
    physical_device: PhysicalDevice,
    format: Format,
    type: ImageType,
    tiling: ImageTiling,
    usage: ImageUsageFlags.IntType,
    flags: ImageCreateFlags.IntType,
    p_image_format_properties: *ImageFormatProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateDevice = fn (
    physical_device: PhysicalDevice,
    p_create_info: *const DeviceCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_device: *Device,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDevice = fn (
    device: Device,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnEnumerateInstanceVersion = fn (
    p_api_version: *u32,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumerateInstanceLayerProperties = fn (
    p_property_count: *u32,
    p_properties: ?[*]LayerProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumerateInstanceExtensionProperties = fn (
    p_layer_name: ?[*:0]const u8,
    p_property_count: *u32,
    p_properties: ?[*]ExtensionProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumerateDeviceLayerProperties = fn (
    physical_device: PhysicalDevice,
    p_property_count: *u32,
    p_properties: ?[*]LayerProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumerateDeviceExtensionProperties = fn (
    physical_device: PhysicalDevice,
    p_layer_name: ?[*:0]const u8,
    p_property_count: *u32,
    p_properties: ?[*]ExtensionProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceQueue = fn (
    device: Device,
    queue_family_index: u32,
    queue_index: u32,
    p_queue: *Queue,
) callconv(vulkan_call_conv) void;
pub const PfnQueueSubmit = fn (
    queue: Queue,
    submit_count: u32,
    p_submits: [*]const SubmitInfo,
    fence: Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnQueueWaitIdle = fn (
    queue: Queue,
) callconv(vulkan_call_conv) Result;
pub const PfnDeviceWaitIdle = fn (
    device: Device,
) callconv(vulkan_call_conv) Result;
pub const PfnAllocateMemory = fn (
    device: Device,
    p_allocate_info: *const MemoryAllocateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_memory: *DeviceMemory,
) callconv(vulkan_call_conv) Result;
pub const PfnFreeMemory = fn (
    device: Device,
    memory: DeviceMemory,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnMapMemory = fn (
    device: Device,
    memory: DeviceMemory,
    offset: DeviceSize,
    size: DeviceSize,
    flags: MemoryMapFlags.IntType,
    pp_data: *?*c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnUnmapMemory = fn (
    device: Device,
    memory: DeviceMemory,
) callconv(vulkan_call_conv) void;
pub const PfnFlushMappedMemoryRanges = fn (
    device: Device,
    memory_range_count: u32,
    p_memory_ranges: [*]const MappedMemoryRange,
) callconv(vulkan_call_conv) Result;
pub const PfnInvalidateMappedMemoryRanges = fn (
    device: Device,
    memory_range_count: u32,
    p_memory_ranges: [*]const MappedMemoryRange,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceMemoryCommitment = fn (
    device: Device,
    memory: DeviceMemory,
    p_committed_memory_in_bytes: *DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnGetBufferMemoryRequirements = fn (
    device: Device,
    buffer: Buffer,
    p_memory_requirements: *MemoryRequirements,
) callconv(vulkan_call_conv) void;
pub const PfnBindBufferMemory = fn (
    device: Device,
    buffer: Buffer,
    memory: DeviceMemory,
    memory_offset: DeviceSize,
) callconv(vulkan_call_conv) Result;
pub const PfnGetImageMemoryRequirements = fn (
    device: Device,
    image: Image,
    p_memory_requirements: *MemoryRequirements,
) callconv(vulkan_call_conv) void;
pub const PfnBindImageMemory = fn (
    device: Device,
    image: Image,
    memory: DeviceMemory,
    memory_offset: DeviceSize,
) callconv(vulkan_call_conv) Result;
pub const PfnGetImageSparseMemoryRequirements = fn (
    device: Device,
    image: Image,
    p_sparse_memory_requirement_count: *u32,
    p_sparse_memory_requirements: ?[*]SparseImageMemoryRequirements,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceSparseImageFormatProperties = fn (
    physical_device: PhysicalDevice,
    format: Format,
    type: ImageType,
    samples: SampleCountFlags.IntType,
    usage: ImageUsageFlags.IntType,
    tiling: ImageTiling,
    p_property_count: *u32,
    p_properties: ?[*]SparseImageFormatProperties,
) callconv(vulkan_call_conv) void;
pub const PfnQueueBindSparse = fn (
    queue: Queue,
    bind_info_count: u32,
    p_bind_info: [*]const BindSparseInfo,
    fence: Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateFence = fn (
    device: Device,
    p_create_info: *const FenceCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_fence: *Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyFence = fn (
    device: Device,
    fence: Fence,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnResetFences = fn (
    device: Device,
    fence_count: u32,
    p_fences: [*]const Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnGetFenceStatus = fn (
    device: Device,
    fence: Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnWaitForFences = fn (
    device: Device,
    fence_count: u32,
    p_fences: [*]const Fence,
    wait_all: Bool32,
    timeout: u64,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateSemaphore = fn (
    device: Device,
    p_create_info: *const SemaphoreCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_semaphore: *Semaphore,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySemaphore = fn (
    device: Device,
    semaphore: Semaphore,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateEvent = fn (
    device: Device,
    p_create_info: *const EventCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_event: *Event,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyEvent = fn (
    device: Device,
    event: Event,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetEventStatus = fn (
    device: Device,
    event: Event,
) callconv(vulkan_call_conv) Result;
pub const PfnSetEvent = fn (
    device: Device,
    event: Event,
) callconv(vulkan_call_conv) Result;
pub const PfnResetEvent = fn (
    device: Device,
    event: Event,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateQueryPool = fn (
    device: Device,
    p_create_info: *const QueryPoolCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_query_pool: *QueryPool,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyQueryPool = fn (
    device: Device,
    query_pool: QueryPool,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetQueryPoolResults = fn (
    device: Device,
    query_pool: QueryPool,
    first_query: u32,
    query_count: u32,
    data_size: usize,
    p_data: *c_void,
    stride: DeviceSize,
    flags: QueryResultFlags.IntType,
) callconv(vulkan_call_conv) Result;
pub const PfnResetQueryPool = fn (
    device: Device,
    query_pool: QueryPool,
    first_query: u32,
    query_count: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCreateBuffer = fn (
    device: Device,
    p_create_info: *const BufferCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_buffer: *Buffer,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyBuffer = fn (
    device: Device,
    buffer: Buffer,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateBufferView = fn (
    device: Device,
    p_create_info: *const BufferViewCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_view: *BufferView,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyBufferView = fn (
    device: Device,
    buffer_view: BufferView,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateImage = fn (
    device: Device,
    p_create_info: *const ImageCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_image: *Image,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyImage = fn (
    device: Device,
    image: Image,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageSubresourceLayout = fn (
    device: Device,
    image: Image,
    p_subresource: *const ImageSubresource,
    p_layout: *SubresourceLayout,
) callconv(vulkan_call_conv) void;
pub const PfnCreateImageView = fn (
    device: Device,
    p_create_info: *const ImageViewCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_view: *ImageView,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyImageView = fn (
    device: Device,
    image_view: ImageView,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateShaderModule = fn (
    device: Device,
    p_create_info: *const ShaderModuleCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_shader_module: *ShaderModule,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyShaderModule = fn (
    device: Device,
    shader_module: ShaderModule,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreatePipelineCache = fn (
    device: Device,
    p_create_info: *const PipelineCacheCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_pipeline_cache: *PipelineCache,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyPipelineCache = fn (
    device: Device,
    pipeline_cache: PipelineCache,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetPipelineCacheData = fn (
    device: Device,
    pipeline_cache: PipelineCache,
    p_data_size: *usize,
    p_data: ?*c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnMergePipelineCaches = fn (
    device: Device,
    dst_cache: PipelineCache,
    src_cache_count: u32,
    p_src_caches: [*]const PipelineCache,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateGraphicsPipelines = fn (
    device: Device,
    pipeline_cache: PipelineCache,
    create_info_count: u32,
    p_create_infos: [*]const GraphicsPipelineCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_pipelines: [*]Pipeline,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateComputePipelines = fn (
    device: Device,
    pipeline_cache: PipelineCache,
    create_info_count: u32,
    p_create_infos: [*]const ComputePipelineCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_pipelines: [*]Pipeline,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyPipeline = fn (
    device: Device,
    pipeline: Pipeline,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreatePipelineLayout = fn (
    device: Device,
    p_create_info: *const PipelineLayoutCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_pipeline_layout: *PipelineLayout,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyPipelineLayout = fn (
    device: Device,
    pipeline_layout: PipelineLayout,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateSampler = fn (
    device: Device,
    p_create_info: *const SamplerCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_sampler: *Sampler,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySampler = fn (
    device: Device,
    sampler: Sampler,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateDescriptorSetLayout = fn (
    device: Device,
    p_create_info: *const DescriptorSetLayoutCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_set_layout: *DescriptorSetLayout,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDescriptorSetLayout = fn (
    device: Device,
    descriptor_set_layout: DescriptorSetLayout,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateDescriptorPool = fn (
    device: Device,
    p_create_info: *const DescriptorPoolCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_descriptor_pool: *DescriptorPool,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDescriptorPool = fn (
    device: Device,
    descriptor_pool: DescriptorPool,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnResetDescriptorPool = fn (
    device: Device,
    descriptor_pool: DescriptorPool,
    flags: DescriptorPoolResetFlags.IntType,
) callconv(vulkan_call_conv) Result;
pub const PfnAllocateDescriptorSets = fn (
    device: Device,
    p_allocate_info: *const DescriptorSetAllocateInfo,
    p_descriptor_sets: [*]DescriptorSet,
) callconv(vulkan_call_conv) Result;
pub const PfnFreeDescriptorSets = fn (
    device: Device,
    descriptor_pool: DescriptorPool,
    descriptor_set_count: u32,
    p_descriptor_sets: [*]const DescriptorSet,
) callconv(vulkan_call_conv) Result;
pub const PfnUpdateDescriptorSets = fn (
    device: Device,
    descriptor_write_count: u32,
    p_descriptor_writes: [*]const WriteDescriptorSet,
    descriptor_copy_count: u32,
    p_descriptor_copies: [*]const CopyDescriptorSet,
) callconv(vulkan_call_conv) void;
pub const PfnCreateFramebuffer = fn (
    device: Device,
    p_create_info: *const FramebufferCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_framebuffer: *Framebuffer,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyFramebuffer = fn (
    device: Device,
    framebuffer: Framebuffer,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateRenderPass = fn (
    device: Device,
    p_create_info: *const RenderPassCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_render_pass: *RenderPass,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyRenderPass = fn (
    device: Device,
    render_pass: RenderPass,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetRenderAreaGranularity = fn (
    device: Device,
    render_pass: RenderPass,
    p_granularity: *Extent2D,
) callconv(vulkan_call_conv) void;
pub const PfnCreateCommandPool = fn (
    device: Device,
    p_create_info: *const CommandPoolCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_command_pool: *CommandPool,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyCommandPool = fn (
    device: Device,
    command_pool: CommandPool,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnResetCommandPool = fn (
    device: Device,
    command_pool: CommandPool,
    flags: CommandPoolResetFlags.IntType,
) callconv(vulkan_call_conv) Result;
pub const PfnAllocateCommandBuffers = fn (
    device: Device,
    p_allocate_info: *const CommandBufferAllocateInfo,
    p_command_buffers: [*]CommandBuffer,
) callconv(vulkan_call_conv) Result;
pub const PfnFreeCommandBuffers = fn (
    device: Device,
    command_pool: CommandPool,
    command_buffer_count: u32,
    p_command_buffers: [*]const CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnBeginCommandBuffer = fn (
    command_buffer: CommandBuffer,
    p_begin_info: *const CommandBufferBeginInfo,
) callconv(vulkan_call_conv) Result;
pub const PfnEndCommandBuffer = fn (
    command_buffer: CommandBuffer,
) callconv(vulkan_call_conv) Result;
pub const PfnResetCommandBuffer = fn (
    command_buffer: CommandBuffer,
    flags: CommandBufferResetFlags.IntType,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdBindPipeline = fn (
    command_buffer: CommandBuffer,
    pipeline_bind_point: PipelineBindPoint,
    pipeline: Pipeline,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetViewport = fn (
    command_buffer: CommandBuffer,
    first_viewport: u32,
    viewport_count: u32,
    p_viewports: [*]const Viewport,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetScissor = fn (
    command_buffer: CommandBuffer,
    first_scissor: u32,
    scissor_count: u32,
    p_scissors: [*]const Rect2D,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetLineWidth = fn (
    command_buffer: CommandBuffer,
    line_width: f32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthBias = fn (
    command_buffer: CommandBuffer,
    depth_bias_constant_factor: f32,
    depth_bias_clamp: f32,
    depth_bias_slope_factor: f32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetBlendConstants = fn (
    command_buffer: CommandBuffer,
    blend_constants: [4]f32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthBounds = fn (
    command_buffer: CommandBuffer,
    min_depth_bounds: f32,
    max_depth_bounds: f32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilCompareMask = fn (
    command_buffer: CommandBuffer,
    face_mask: StencilFaceFlags.IntType,
    compare_mask: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilWriteMask = fn (
    command_buffer: CommandBuffer,
    face_mask: StencilFaceFlags.IntType,
    write_mask: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilReference = fn (
    command_buffer: CommandBuffer,
    face_mask: StencilFaceFlags.IntType,
    reference: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindDescriptorSets = fn (
    command_buffer: CommandBuffer,
    pipeline_bind_point: PipelineBindPoint,
    layout: PipelineLayout,
    first_set: u32,
    descriptor_set_count: u32,
    p_descriptor_sets: [*]const DescriptorSet,
    dynamic_offset_count: u32,
    p_dynamic_offsets: [*]const u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindIndexBuffer = fn (
    command_buffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    index_type: IndexType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindVertexBuffers = fn (
    command_buffer: CommandBuffer,
    first_binding: u32,
    binding_count: u32,
    p_buffers: [*]const Buffer,
    p_offsets: [*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDraw = fn (
    command_buffer: CommandBuffer,
    vertex_count: u32,
    instance_count: u32,
    first_vertex: u32,
    first_instance: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndexed = fn (
    command_buffer: CommandBuffer,
    index_count: u32,
    instance_count: u32,
    first_index: u32,
    vertex_offset: i32,
    first_instance: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndirect = fn (
    command_buffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    draw_count: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndexedIndirect = fn (
    command_buffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    draw_count: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDispatch = fn (
    command_buffer: CommandBuffer,
    group_count_x: u32,
    group_count_y: u32,
    group_count_z: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDispatchIndirect = fn (
    command_buffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyBuffer = fn (
    command_buffer: CommandBuffer,
    src_buffer: Buffer,
    dst_buffer: Buffer,
    region_count: u32,
    p_regions: [*]const BufferCopy,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyImage = fn (
    command_buffer: CommandBuffer,
    src_image: Image,
    src_image_layout: ImageLayout,
    dst_image: Image,
    dst_image_layout: ImageLayout,
    region_count: u32,
    p_regions: [*]const ImageCopy,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBlitImage = fn (
    command_buffer: CommandBuffer,
    src_image: Image,
    src_image_layout: ImageLayout,
    dst_image: Image,
    dst_image_layout: ImageLayout,
    region_count: u32,
    p_regions: [*]const ImageBlit,
    filter: Filter,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyBufferToImage = fn (
    command_buffer: CommandBuffer,
    src_buffer: Buffer,
    dst_image: Image,
    dst_image_layout: ImageLayout,
    region_count: u32,
    p_regions: [*]const BufferImageCopy,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyImageToBuffer = fn (
    command_buffer: CommandBuffer,
    src_image: Image,
    src_image_layout: ImageLayout,
    dst_buffer: Buffer,
    region_count: u32,
    p_regions: [*]const BufferImageCopy,
) callconv(vulkan_call_conv) void;
pub const PfnCmdUpdateBuffer = fn (
    command_buffer: CommandBuffer,
    dst_buffer: Buffer,
    dst_offset: DeviceSize,
    data_size: DeviceSize,
    p_data: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnCmdFillBuffer = fn (
    command_buffer: CommandBuffer,
    dst_buffer: Buffer,
    dst_offset: DeviceSize,
    size: DeviceSize,
    data: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdClearColorImage = fn (
    command_buffer: CommandBuffer,
    image: Image,
    image_layout: ImageLayout,
    p_color: *const ClearColorValue,
    range_count: u32,
    p_ranges: [*]const ImageSubresourceRange,
) callconv(vulkan_call_conv) void;
pub const PfnCmdClearDepthStencilImage = fn (
    command_buffer: CommandBuffer,
    image: Image,
    image_layout: ImageLayout,
    p_depth_stencil: *const ClearDepthStencilValue,
    range_count: u32,
    p_ranges: [*]const ImageSubresourceRange,
) callconv(vulkan_call_conv) void;
pub const PfnCmdClearAttachments = fn (
    command_buffer: CommandBuffer,
    attachment_count: u32,
    p_attachments: [*]const ClearAttachment,
    rect_count: u32,
    p_rects: [*]const ClearRect,
) callconv(vulkan_call_conv) void;
pub const PfnCmdResolveImage = fn (
    command_buffer: CommandBuffer,
    src_image: Image,
    src_image_layout: ImageLayout,
    dst_image: Image,
    dst_image_layout: ImageLayout,
    region_count: u32,
    p_regions: [*]const ImageResolve,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetEvent = fn (
    command_buffer: CommandBuffer,
    event: Event,
    stage_mask: PipelineStageFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdResetEvent = fn (
    command_buffer: CommandBuffer,
    event: Event,
    stage_mask: PipelineStageFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdWaitEvents = fn (
    command_buffer: CommandBuffer,
    event_count: u32,
    p_events: [*]const Event,
    src_stage_mask: PipelineStageFlags.IntType,
    dst_stage_mask: PipelineStageFlags.IntType,
    memory_barrier_count: u32,
    p_memory_barriers: [*]const MemoryBarrier,
    buffer_memory_barrier_count: u32,
    p_buffer_memory_barriers: [*]const BufferMemoryBarrier,
    image_memory_barrier_count: u32,
    p_image_memory_barriers: [*]const ImageMemoryBarrier,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPipelineBarrier = fn (
    command_buffer: CommandBuffer,
    src_stage_mask: PipelineStageFlags.IntType,
    dst_stage_mask: PipelineStageFlags.IntType,
    dependency_flags: DependencyFlags.IntType,
    memory_barrier_count: u32,
    p_memory_barriers: [*]const MemoryBarrier,
    buffer_memory_barrier_count: u32,
    p_buffer_memory_barriers: [*]const BufferMemoryBarrier,
    image_memory_barrier_count: u32,
    p_image_memory_barriers: [*]const ImageMemoryBarrier,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginQuery = fn (
    command_buffer: CommandBuffer,
    query_pool: QueryPool,
    query: u32,
    flags: QueryControlFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndQuery = fn (
    command_buffer: CommandBuffer,
    query_pool: QueryPool,
    query: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginConditionalRenderingEXT = fn (
    command_buffer: CommandBuffer,
    p_conditional_rendering_begin: *const ConditionalRenderingBeginInfoEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndConditionalRenderingEXT = fn (
    command_buffer: CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCmdResetQueryPool = fn (
    command_buffer: CommandBuffer,
    query_pool: QueryPool,
    first_query: u32,
    query_count: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdWriteTimestamp = fn (
    command_buffer: CommandBuffer,
    pipeline_stage: PipelineStageFlags.IntType,
    query_pool: QueryPool,
    query: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyQueryPoolResults = fn (
    command_buffer: CommandBuffer,
    query_pool: QueryPool,
    first_query: u32,
    query_count: u32,
    dst_buffer: Buffer,
    dst_offset: DeviceSize,
    stride: DeviceSize,
    flags: QueryResultFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPushConstants = fn (
    command_buffer: CommandBuffer,
    layout: PipelineLayout,
    stage_flags: ShaderStageFlags.IntType,
    offset: u32,
    size: u32,
    p_values: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginRenderPass = fn (
    command_buffer: CommandBuffer,
    p_render_pass_begin: *const RenderPassBeginInfo,
    contents: SubpassContents,
) callconv(vulkan_call_conv) void;
pub const PfnCmdNextSubpass = fn (
    command_buffer: CommandBuffer,
    contents: SubpassContents,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndRenderPass = fn (
    command_buffer: CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCmdExecuteCommands = fn (
    command_buffer: CommandBuffer,
    command_buffer_count: u32,
    p_command_buffers: [*]const CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCreateAndroidSurfaceKHR = fn (
    instance: Instance,
    p_create_info: *const AndroidSurfaceCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDisplayPropertiesKHR = fn (
    physical_device: PhysicalDevice,
    p_property_count: *u32,
    p_properties: ?[*]DisplayPropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDisplayPlanePropertiesKHR = fn (
    physical_device: PhysicalDevice,
    p_property_count: *u32,
    p_properties: ?[*]DisplayPlanePropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayPlaneSupportedDisplaysKHR = fn (
    physical_device: PhysicalDevice,
    plane_index: u32,
    p_display_count: *u32,
    p_displays: ?[*]DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayModePropertiesKHR = fn (
    physical_device: PhysicalDevice,
    display: DisplayKHR,
    p_property_count: *u32,
    p_properties: ?[*]DisplayModePropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateDisplayModeKHR = fn (
    physical_device: PhysicalDevice,
    display: DisplayKHR,
    p_create_info: *const DisplayModeCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_mode: *DisplayModeKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayPlaneCapabilitiesKHR = fn (
    physical_device: PhysicalDevice,
    mode: DisplayModeKHR,
    plane_index: u32,
    p_capabilities: *DisplayPlaneCapabilitiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateDisplayPlaneSurfaceKHR = fn (
    instance: Instance,
    p_create_info: *const DisplaySurfaceCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateSharedSwapchainsKHR = fn (
    device: Device,
    swapchain_count: u32,
    p_create_infos: [*]const SwapchainCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_swapchains: [*]SwapchainKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySurfaceKHR = fn (
    instance: Instance,
    surface: SurfaceKHR,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceSurfaceSupportKHR = fn (
    physical_device: PhysicalDevice,
    queue_family_index: u32,
    surface: SurfaceKHR,
    p_supported: *Bool32,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfaceCapabilitiesKHR = fn (
    physical_device: PhysicalDevice,
    surface: SurfaceKHR,
    p_surface_capabilities: *SurfaceCapabilitiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfaceFormatsKHR = fn (
    physical_device: PhysicalDevice,
    surface: SurfaceKHR,
    p_surface_format_count: *u32,
    p_surface_formats: ?[*]SurfaceFormatKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfacePresentModesKHR = fn (
    physical_device: PhysicalDevice,
    surface: SurfaceKHR,
    p_present_mode_count: *u32,
    p_present_modes: ?[*]PresentModeKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateSwapchainKHR = fn (
    device: Device,
    p_create_info: *const SwapchainCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_swapchain: *SwapchainKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySwapchainKHR = fn (
    device: Device,
    swapchain: SwapchainKHR,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetSwapchainImagesKHR = fn (
    device: Device,
    swapchain: SwapchainKHR,
    p_swapchain_image_count: *u32,
    p_swapchain_images: ?[*]Image,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireNextImageKHR = fn (
    device: Device,
    swapchain: SwapchainKHR,
    timeout: u64,
    semaphore: Semaphore,
    fence: Fence,
    p_image_index: *u32,
) callconv(vulkan_call_conv) Result;
pub const PfnQueuePresentKHR = fn (
    queue: Queue,
    p_present_info: *const PresentInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateViSurfaceNN = fn (
    instance: Instance,
    p_create_info: *const ViSurfaceCreateInfoNN,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateWaylandSurfaceKHR = fn (
    instance: Instance,
    p_create_info: *const WaylandSurfaceCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceWaylandPresentationSupportKHR = fn (
    physical_device: PhysicalDevice,
    queue_family_index: u32,
    display: *wl_display,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateWin32SurfaceKHR = fn (
    instance: Instance,
    p_create_info: *const Win32SurfaceCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceWin32PresentationSupportKHR = fn (
    physical_device: PhysicalDevice,
    queue_family_index: u32,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateXlibSurfaceKHR = fn (
    instance: Instance,
    p_create_info: *const XlibSurfaceCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceXlibPresentationSupportKHR = fn (
    physical_device: PhysicalDevice,
    queue_family_index: u32,
    dpy: *Display,
    visual_id: VisualID,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateXcbSurfaceKHR = fn (
    instance: Instance,
    p_create_info: *const XcbSurfaceCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceXcbPresentationSupportKHR = fn (
    physical_device: PhysicalDevice,
    queue_family_index: u32,
    connection: *xcb_connection_t,
    visual_id: xcb_visualid_t,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateDirectFBSurfaceEXT = fn (
    instance: Instance,
    p_create_info: *const DirectFBSurfaceCreateInfoEXT,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDirectFBPresentationSupportEXT = fn (
    physical_device: PhysicalDevice,
    queue_family_index: u32,
    dfb: *IDirectFB,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateImagePipeSurfaceFUCHSIA = fn (
    instance: Instance,
    p_create_info: *const ImagePipeSurfaceCreateInfoFUCHSIA,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateStreamDescriptorSurfaceGGP = fn (
    instance: Instance,
    p_create_info: *const StreamDescriptorSurfaceCreateInfoGGP,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateDebugReportCallbackEXT = fn (
    instance: Instance,
    p_create_info: *const DebugReportCallbackCreateInfoEXT,
    p_allocator: ?*const AllocationCallbacks,
    p_callback: *DebugReportCallbackEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDebugReportCallbackEXT = fn (
    instance: Instance,
    callback: DebugReportCallbackEXT,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnDebugReportMessageEXT = fn (
    instance: Instance,
    flags: DebugReportFlagsEXT.IntType,
    object_type: DebugReportObjectTypeEXT,
    object: u64,
    location: usize,
    message_code: i32,
    p_layer_prefix: [*:0]const u8,
    p_message: [*:0]const u8,
) callconv(vulkan_call_conv) void;
pub const PfnDebugMarkerSetObjectNameEXT = fn (
    device: Device,
    p_name_info: *const DebugMarkerObjectNameInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDebugMarkerSetObjectTagEXT = fn (
    device: Device,
    p_tag_info: *const DebugMarkerObjectTagInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdDebugMarkerBeginEXT = fn (
    command_buffer: CommandBuffer,
    p_marker_info: *const DebugMarkerMarkerInfoEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDebugMarkerEndEXT = fn (
    command_buffer: CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDebugMarkerInsertEXT = fn (
    command_buffer: CommandBuffer,
    p_marker_info: *const DebugMarkerMarkerInfoEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceExternalImageFormatPropertiesNV = fn (
    physical_device: PhysicalDevice,
    format: Format,
    type: ImageType,
    tiling: ImageTiling,
    usage: ImageUsageFlags.IntType,
    flags: ImageCreateFlags.IntType,
    external_handle_type: ExternalMemoryHandleTypeFlagsNV.IntType,
    p_external_image_format_properties: *ExternalImageFormatPropertiesNV,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryWin32HandleNV = fn (
    device: Device,
    memory: DeviceMemory,
    handle_type: ExternalMemoryHandleTypeFlagsNV.IntType,
    p_handle: *HANDLE,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdExecuteGeneratedCommandsNV = fn (
    command_buffer: CommandBuffer,
    is_preprocessed: Bool32,
    p_generated_commands_info: *const GeneratedCommandsInfoNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPreprocessGeneratedCommandsNV = fn (
    command_buffer: CommandBuffer,
    p_generated_commands_info: *const GeneratedCommandsInfoNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindPipelineShaderGroupNV = fn (
    command_buffer: CommandBuffer,
    pipeline_bind_point: PipelineBindPoint,
    pipeline: Pipeline,
    group_index: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetGeneratedCommandsMemoryRequirementsNV = fn (
    device: Device,
    p_info: *const GeneratedCommandsMemoryRequirementsInfoNV,
    p_memory_requirements: *MemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnCreateIndirectCommandsLayoutNV = fn (
    device: Device,
    p_create_info: *const IndirectCommandsLayoutCreateInfoNV,
    p_allocator: ?*const AllocationCallbacks,
    p_indirect_commands_layout: *IndirectCommandsLayoutNV,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyIndirectCommandsLayoutNV = fn (
    device: Device,
    indirect_commands_layout: IndirectCommandsLayoutNV,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFeatures2 = fn (
    physical_device: PhysicalDevice,
    p_features: *PhysicalDeviceFeatures2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceProperties2 = fn (
    physical_device: PhysicalDevice,
    p_properties: *PhysicalDeviceProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFormatProperties2 = fn (
    physical_device: PhysicalDevice,
    format: Format,
    p_format_properties: *FormatProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceImageFormatProperties2 = fn (
    physical_device: PhysicalDevice,
    p_image_format_info: *const PhysicalDeviceImageFormatInfo2,
    p_image_format_properties: *ImageFormatProperties2,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceQueueFamilyProperties2 = fn (
    physical_device: PhysicalDevice,
    p_queue_family_property_count: *u32,
    p_queue_family_properties: ?[*]QueueFamilyProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceMemoryProperties2 = fn (
    physical_device: PhysicalDevice,
    p_memory_properties: *PhysicalDeviceMemoryProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceSparseImageFormatProperties2 = fn (
    physical_device: PhysicalDevice,
    p_format_info: *const PhysicalDeviceSparseImageFormatInfo2,
    p_property_count: *u32,
    p_properties: ?[*]SparseImageFormatProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPushDescriptorSetKHR = fn (
    command_buffer: CommandBuffer,
    pipeline_bind_point: PipelineBindPoint,
    layout: PipelineLayout,
    set: u32,
    descriptor_write_count: u32,
    p_descriptor_writes: [*]const WriteDescriptorSet,
) callconv(vulkan_call_conv) void;
pub const PfnTrimCommandPool = fn (
    device: Device,
    command_pool: CommandPool,
    flags: CommandPoolTrimFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceExternalBufferProperties = fn (
    physical_device: PhysicalDevice,
    p_external_buffer_info: *const PhysicalDeviceExternalBufferInfo,
    p_external_buffer_properties: *ExternalBufferProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetMemoryWin32HandleKHR = fn (
    device: Device,
    p_get_win_32_handle_info: *const MemoryGetWin32HandleInfoKHR,
    p_handle: *HANDLE,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryWin32HandlePropertiesKHR = fn (
    device: Device,
    handle_type: ExternalMemoryHandleTypeFlags.IntType,
    handle: HANDLE,
    p_memory_win_32_handle_properties: *MemoryWin32HandlePropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryFdKHR = fn (
    device: Device,
    p_get_fd_info: *const MemoryGetFdInfoKHR,
    p_fd: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryFdPropertiesKHR = fn (
    device: Device,
    handle_type: ExternalMemoryHandleTypeFlags.IntType,
    fd: c_int,
    p_memory_fd_properties: *MemoryFdPropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceExternalSemaphoreProperties = fn (
    physical_device: PhysicalDevice,
    p_external_semaphore_info: *const PhysicalDeviceExternalSemaphoreInfo,
    p_external_semaphore_properties: *ExternalSemaphoreProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetSemaphoreWin32HandleKHR = fn (
    device: Device,
    p_get_win_32_handle_info: *const SemaphoreGetWin32HandleInfoKHR,
    p_handle: *HANDLE,
) callconv(vulkan_call_conv) Result;
pub const PfnImportSemaphoreWin32HandleKHR = fn (
    device: Device,
    p_import_semaphore_win_32_handle_info: *const ImportSemaphoreWin32HandleInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetSemaphoreFdKHR = fn (
    device: Device,
    p_get_fd_info: *const SemaphoreGetFdInfoKHR,
    p_fd: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnImportSemaphoreFdKHR = fn (
    device: Device,
    p_import_semaphore_fd_info: *const ImportSemaphoreFdInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceExternalFenceProperties = fn (
    physical_device: PhysicalDevice,
    p_external_fence_info: *const PhysicalDeviceExternalFenceInfo,
    p_external_fence_properties: *ExternalFenceProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetFenceWin32HandleKHR = fn (
    device: Device,
    p_get_win_32_handle_info: *const FenceGetWin32HandleInfoKHR,
    p_handle: *HANDLE,
) callconv(vulkan_call_conv) Result;
pub const PfnImportFenceWin32HandleKHR = fn (
    device: Device,
    p_import_fence_win_32_handle_info: *const ImportFenceWin32HandleInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetFenceFdKHR = fn (
    device: Device,
    p_get_fd_info: *const FenceGetFdInfoKHR,
    p_fd: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnImportFenceFdKHR = fn (
    device: Device,
    p_import_fence_fd_info: *const ImportFenceFdInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnReleaseDisplayEXT = fn (
    physical_device: PhysicalDevice,
    display: DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireXlibDisplayEXT = fn (
    physical_device: PhysicalDevice,
    dpy: *Display,
    display: DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetRandROutputDisplayEXT = fn (
    physical_device: PhysicalDevice,
    dpy: *Display,
    rr_output: RROutput,
    p_display: *DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDisplayPowerControlEXT = fn (
    device: Device,
    display: DisplayKHR,
    p_display_power_info: *const DisplayPowerInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnRegisterDeviceEventEXT = fn (
    device: Device,
    p_device_event_info: *const DeviceEventInfoEXT,
    p_allocator: ?*const AllocationCallbacks,
    p_fence: *Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnRegisterDisplayEventEXT = fn (
    device: Device,
    display: DisplayKHR,
    p_display_event_info: *const DisplayEventInfoEXT,
    p_allocator: ?*const AllocationCallbacks,
    p_fence: *Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnGetSwapchainCounterEXT = fn (
    device: Device,
    swapchain: SwapchainKHR,
    counter: SurfaceCounterFlagsEXT.IntType,
    p_counter_value: *u64,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfaceCapabilities2EXT = fn (
    physical_device: PhysicalDevice,
    surface: SurfaceKHR,
    p_surface_capabilities: *SurfaceCapabilities2EXT,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumeratePhysicalDeviceGroups = fn (
    instance: Instance,
    p_physical_device_group_count: *u32,
    p_physical_device_group_properties: ?[*]PhysicalDeviceGroupProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceGroupPeerMemoryFeatures = fn (
    device: Device,
    heap_index: u32,
    local_device_index: u32,
    remote_device_index: u32,
    p_peer_memory_features: *PeerMemoryFeatureFlags,
) callconv(vulkan_call_conv) void;
pub const PfnBindBufferMemory2 = fn (
    device: Device,
    bind_info_count: u32,
    p_bind_infos: [*]const BindBufferMemoryInfo,
) callconv(vulkan_call_conv) Result;
pub const PfnBindImageMemory2 = fn (
    device: Device,
    bind_info_count: u32,
    p_bind_infos: [*]const BindImageMemoryInfo,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetDeviceMask = fn (
    command_buffer: CommandBuffer,
    device_mask: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeviceGroupPresentCapabilitiesKHR = fn (
    device: Device,
    p_device_group_present_capabilities: *DeviceGroupPresentCapabilitiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceGroupSurfacePresentModesKHR = fn (
    device: Device,
    surface: SurfaceKHR,
    p_modes: *DeviceGroupPresentModeFlagsKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireNextImage2KHR = fn (
    device: Device,
    p_acquire_info: *const AcquireNextImageInfoKHR,
    p_image_index: *u32,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdDispatchBase = fn (
    command_buffer: CommandBuffer,
    base_group_x: u32,
    base_group_y: u32,
    base_group_z: u32,
    group_count_x: u32,
    group_count_y: u32,
    group_count_z: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDevicePresentRectanglesKHR = fn (
    physical_device: PhysicalDevice,
    surface: SurfaceKHR,
    p_rect_count: *u32,
    p_rects: ?[*]Rect2D,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateDescriptorUpdateTemplate = fn (
    device: Device,
    p_create_info: *const DescriptorUpdateTemplateCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_descriptor_update_template: *DescriptorUpdateTemplate,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDescriptorUpdateTemplate = fn (
    device: Device,
    descriptor_update_template: DescriptorUpdateTemplate,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnUpdateDescriptorSetWithTemplate = fn (
    device: Device,
    descriptor_set: DescriptorSet,
    descriptor_update_template: DescriptorUpdateTemplate,
    p_data: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPushDescriptorSetWithTemplateKHR = fn (
    command_buffer: CommandBuffer,
    descriptor_update_template: DescriptorUpdateTemplate,
    layout: PipelineLayout,
    set: u32,
    p_data: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnSetHdrMetadataEXT = fn (
    device: Device,
    swapchain_count: u32,
    p_swapchains: [*]const SwapchainKHR,
    p_metadata: [*]const HdrMetadataEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetSwapchainStatusKHR = fn (
    device: Device,
    swapchain: SwapchainKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetRefreshCycleDurationGOOGLE = fn (
    device: Device,
    swapchain: SwapchainKHR,
    p_display_timing_properties: *RefreshCycleDurationGOOGLE,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPastPresentationTimingGOOGLE = fn (
    device: Device,
    swapchain: SwapchainKHR,
    p_presentation_timing_count: *u32,
    p_presentation_timings: ?[*]PastPresentationTimingGOOGLE,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateIOSSurfaceMVK = fn (
    instance: Instance,
    p_create_info: *const IOSSurfaceCreateInfoMVK,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateMacOSSurfaceMVK = fn (
    instance: Instance,
    p_create_info: *const MacOSSurfaceCreateInfoMVK,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateMetalSurfaceEXT = fn (
    instance: Instance,
    p_create_info: *const MetalSurfaceCreateInfoEXT,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetViewportWScalingNV = fn (
    command_buffer: CommandBuffer,
    first_viewport: u32,
    viewport_count: u32,
    p_viewport_w_scalings: [*]const ViewportWScalingNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDiscardRectangleEXT = fn (
    command_buffer: CommandBuffer,
    first_discard_rectangle: u32,
    discard_rectangle_count: u32,
    p_discard_rectangles: [*]const Rect2D,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetSampleLocationsEXT = fn (
    command_buffer: CommandBuffer,
    p_sample_locations_info: *const SampleLocationsInfoEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceMultisamplePropertiesEXT = fn (
    physical_device: PhysicalDevice,
    samples: SampleCountFlags.IntType,
    p_multisample_properties: *MultisamplePropertiesEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceSurfaceCapabilities2KHR = fn (
    physical_device: PhysicalDevice,
    p_surface_info: *const PhysicalDeviceSurfaceInfo2KHR,
    p_surface_capabilities: *SurfaceCapabilities2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfaceFormats2KHR = fn (
    physical_device: PhysicalDevice,
    p_surface_info: *const PhysicalDeviceSurfaceInfo2KHR,
    p_surface_format_count: *u32,
    p_surface_formats: ?[*]SurfaceFormat2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDisplayProperties2KHR = fn (
    physical_device: PhysicalDevice,
    p_property_count: *u32,
    p_properties: ?[*]DisplayProperties2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDisplayPlaneProperties2KHR = fn (
    physical_device: PhysicalDevice,
    p_property_count: *u32,
    p_properties: ?[*]DisplayPlaneProperties2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayModeProperties2KHR = fn (
    physical_device: PhysicalDevice,
    display: DisplayKHR,
    p_property_count: *u32,
    p_properties: ?[*]DisplayModeProperties2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayPlaneCapabilities2KHR = fn (
    physical_device: PhysicalDevice,
    p_display_plane_info: *const DisplayPlaneInfo2KHR,
    p_capabilities: *DisplayPlaneCapabilities2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetBufferMemoryRequirements2 = fn (
    device: Device,
    p_info: *const BufferMemoryRequirementsInfo2,
    p_memory_requirements: *MemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageMemoryRequirements2 = fn (
    device: Device,
    p_info: *const ImageMemoryRequirementsInfo2,
    p_memory_requirements: *MemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageSparseMemoryRequirements2 = fn (
    device: Device,
    p_info: *const ImageSparseMemoryRequirementsInfo2,
    p_sparse_memory_requirement_count: *u32,
    p_sparse_memory_requirements: ?[*]SparseImageMemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnCreateSamplerYcbcrConversion = fn (
    device: Device,
    p_create_info: *const SamplerYcbcrConversionCreateInfo,
    p_allocator: ?*const AllocationCallbacks,
    p_ycbcr_conversion: *SamplerYcbcrConversion,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySamplerYcbcrConversion = fn (
    device: Device,
    ycbcr_conversion: SamplerYcbcrConversion,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeviceQueue2 = fn (
    device: Device,
    p_queue_info: *const DeviceQueueInfo2,
    p_queue: *Queue,
) callconv(vulkan_call_conv) void;
pub const PfnCreateValidationCacheEXT = fn (
    device: Device,
    p_create_info: *const ValidationCacheCreateInfoEXT,
    p_allocator: ?*const AllocationCallbacks,
    p_validation_cache: *ValidationCacheEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyValidationCacheEXT = fn (
    device: Device,
    validation_cache: ValidationCacheEXT,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetValidationCacheDataEXT = fn (
    device: Device,
    validation_cache: ValidationCacheEXT,
    p_data_size: *usize,
    p_data: ?*c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnMergeValidationCachesEXT = fn (
    device: Device,
    dst_cache: ValidationCacheEXT,
    src_cache_count: u32,
    p_src_caches: [*]const ValidationCacheEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDescriptorSetLayoutSupport = fn (
    device: Device,
    p_create_info: *const DescriptorSetLayoutCreateInfo,
    p_support: *DescriptorSetLayoutSupport,
) callconv(vulkan_call_conv) void;
pub const PfnGetSwapchainGrallocUsageANDROID = fn (
    device: Device,
    format: Format,
    image_usage: ImageUsageFlags.IntType,
    gralloc_usage: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnGetSwapchainGrallocUsage2ANDROID = fn (
    device: Device,
    format: Format,
    image_usage: ImageUsageFlags.IntType,
    swapchain_image_usage: SwapchainImageUsageFlagsANDROID.IntType,
    gralloc_consumer_usage: *u64,
    gralloc_producer_usage: *u64,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireImageANDROID = fn (
    device: Device,
    image: Image,
    native_fence_fd: c_int,
    semaphore: Semaphore,
    fence: Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnQueueSignalReleaseImageANDROID = fn (
    queue: Queue,
    wait_semaphore_count: u32,
    p_wait_semaphores: [*]const Semaphore,
    image: Image,
    p_native_fence_fd: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnGetShaderInfoAMD = fn (
    device: Device,
    pipeline: Pipeline,
    shader_stage: ShaderStageFlags.IntType,
    info_type: ShaderInfoTypeAMD,
    p_info_size: *usize,
    p_info: ?*c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnSetLocalDimmingAMD = fn (
    device: Device,
    swap_chain: SwapchainKHR,
    local_dimming_enable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceCalibrateableTimeDomainsEXT = fn (
    physical_device: PhysicalDevice,
    p_time_domain_count: *u32,
    p_time_domains: ?[*]TimeDomainEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnGetCalibratedTimestampsEXT = fn (
    device: Device,
    timestamp_count: u32,
    p_timestamp_infos: [*]const CalibratedTimestampInfoEXT,
    p_timestamps: [*]u64,
    p_max_deviation: *u64,
) callconv(vulkan_call_conv) Result;
pub const PfnSetDebugUtilsObjectNameEXT = fn (
    device: Device,
    p_name_info: *const DebugUtilsObjectNameInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnSetDebugUtilsObjectTagEXT = fn (
    device: Device,
    p_tag_info: *const DebugUtilsObjectTagInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnQueueBeginDebugUtilsLabelEXT = fn (
    queue: Queue,
    p_label_info: *const DebugUtilsLabelEXT,
) callconv(vulkan_call_conv) void;
pub const PfnQueueEndDebugUtilsLabelEXT = fn (
    queue: Queue,
) callconv(vulkan_call_conv) void;
pub const PfnQueueInsertDebugUtilsLabelEXT = fn (
    queue: Queue,
    p_label_info: *const DebugUtilsLabelEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginDebugUtilsLabelEXT = fn (
    command_buffer: CommandBuffer,
    p_label_info: *const DebugUtilsLabelEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndDebugUtilsLabelEXT = fn (
    command_buffer: CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCmdInsertDebugUtilsLabelEXT = fn (
    command_buffer: CommandBuffer,
    p_label_info: *const DebugUtilsLabelEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCreateDebugUtilsMessengerEXT = fn (
    instance: Instance,
    p_create_info: *const DebugUtilsMessengerCreateInfoEXT,
    p_allocator: ?*const AllocationCallbacks,
    p_messenger: *DebugUtilsMessengerEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDebugUtilsMessengerEXT = fn (
    instance: Instance,
    messenger: DebugUtilsMessengerEXT,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnSubmitDebugUtilsMessageEXT = fn (
    instance: Instance,
    message_severity: DebugUtilsMessageSeverityFlagsEXT.IntType,
    message_types: DebugUtilsMessageTypeFlagsEXT.IntType,
    p_callback_data: *const DebugUtilsMessengerCallbackDataEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetMemoryHostPointerPropertiesEXT = fn (
    device: Device,
    handle_type: ExternalMemoryHandleTypeFlags.IntType,
    p_host_pointer: *const c_void,
    p_memory_host_pointer_properties: *MemoryHostPointerPropertiesEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdWriteBufferMarkerAMD = fn (
    command_buffer: CommandBuffer,
    pipeline_stage: PipelineStageFlags.IntType,
    dst_buffer: Buffer,
    dst_offset: DeviceSize,
    marker: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCreateRenderPass2 = fn (
    device: Device,
    p_create_info: *const RenderPassCreateInfo2,
    p_allocator: ?*const AllocationCallbacks,
    p_render_pass: *RenderPass,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdBeginRenderPass2 = fn (
    command_buffer: CommandBuffer,
    p_render_pass_begin: *const RenderPassBeginInfo,
    p_subpass_begin_info: *const SubpassBeginInfo,
) callconv(vulkan_call_conv) void;
pub const PfnCmdNextSubpass2 = fn (
    command_buffer: CommandBuffer,
    p_subpass_begin_info: *const SubpassBeginInfo,
    p_subpass_end_info: *const SubpassEndInfo,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndRenderPass2 = fn (
    command_buffer: CommandBuffer,
    p_subpass_end_info: *const SubpassEndInfo,
) callconv(vulkan_call_conv) void;
pub const PfnGetSemaphoreCounterValue = fn (
    device: Device,
    semaphore: Semaphore,
    p_value: *u64,
) callconv(vulkan_call_conv) Result;
pub const PfnWaitSemaphores = fn (
    device: Device,
    p_wait_info: *const SemaphoreWaitInfo,
    timeout: u64,
) callconv(vulkan_call_conv) Result;
pub const PfnSignalSemaphore = fn (
    device: Device,
    p_signal_info: *const SemaphoreSignalInfo,
) callconv(vulkan_call_conv) Result;
pub const PfnGetAndroidHardwareBufferPropertiesANDROID = fn (
    device: Device,
    buffer: *const AHardwareBuffer,
    p_properties: *AndroidHardwareBufferPropertiesANDROID,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryAndroidHardwareBufferANDROID = fn (
    device: Device,
    p_info: *const MemoryGetAndroidHardwareBufferInfoANDROID,
    p_buffer: **AHardwareBuffer,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdDrawIndirectCount = fn (
    command_buffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    count_buffer: Buffer,
    count_buffer_offset: DeviceSize,
    max_draw_count: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndexedIndirectCount = fn (
    command_buffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    count_buffer: Buffer,
    count_buffer_offset: DeviceSize,
    max_draw_count: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetCheckpointNV = fn (
    command_buffer: CommandBuffer,
    p_checkpoint_marker: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnGetQueueCheckpointDataNV = fn (
    queue: Queue,
    p_checkpoint_data_count: *u32,
    p_checkpoint_data: ?[*]CheckpointDataNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindTransformFeedbackBuffersEXT = fn (
    command_buffer: CommandBuffer,
    first_binding: u32,
    binding_count: u32,
    p_buffers: [*]const Buffer,
    p_offsets: [*]const DeviceSize,
    p_sizes: ?[*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginTransformFeedbackEXT = fn (
    command_buffer: CommandBuffer,
    first_counter_buffer: u32,
    counter_buffer_count: u32,
    p_counter_buffers: [*]const Buffer,
    p_counter_buffer_offsets: ?[*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndTransformFeedbackEXT = fn (
    command_buffer: CommandBuffer,
    first_counter_buffer: u32,
    counter_buffer_count: u32,
    p_counter_buffers: [*]const Buffer,
    p_counter_buffer_offsets: ?[*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginQueryIndexedEXT = fn (
    command_buffer: CommandBuffer,
    query_pool: QueryPool,
    query: u32,
    flags: QueryControlFlags.IntType,
    index: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndQueryIndexedEXT = fn (
    command_buffer: CommandBuffer,
    query_pool: QueryPool,
    query: u32,
    index: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndirectByteCountEXT = fn (
    command_buffer: CommandBuffer,
    instance_count: u32,
    first_instance: u32,
    counter_buffer: Buffer,
    counter_buffer_offset: DeviceSize,
    counter_offset: u32,
    vertex_stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetExclusiveScissorNV = fn (
    command_buffer: CommandBuffer,
    first_exclusive_scissor: u32,
    exclusive_scissor_count: u32,
    p_exclusive_scissors: [*]const Rect2D,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindShadingRateImageNV = fn (
    command_buffer: CommandBuffer,
    image_view: ImageView,
    image_layout: ImageLayout,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetViewportShadingRatePaletteNV = fn (
    command_buffer: CommandBuffer,
    first_viewport: u32,
    viewport_count: u32,
    p_shading_rate_palettes: [*]const ShadingRatePaletteNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetCoarseSampleOrderNV = fn (
    command_buffer: CommandBuffer,
    sample_order_type: CoarseSampleOrderTypeNV,
    custom_sample_order_count: u32,
    p_custom_sample_orders: [*]const CoarseSampleOrderCustomNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawMeshTasksNV = fn (
    command_buffer: CommandBuffer,
    task_count: u32,
    first_task: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawMeshTasksIndirectNV = fn (
    command_buffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    draw_count: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawMeshTasksIndirectCountNV = fn (
    command_buffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    count_buffer: Buffer,
    count_buffer_offset: DeviceSize,
    max_draw_count: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCompileDeferredNV = fn (
    device: Device,
    pipeline: Pipeline,
    shader: u32,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateAccelerationStructureNV = fn (
    device: Device,
    p_create_info: *const AccelerationStructureCreateInfoNV,
    p_allocator: ?*const AllocationCallbacks,
    p_acceleration_structure: *AccelerationStructureNV,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyAccelerationStructureKHR = fn (
    device: Device,
    acceleration_structure: AccelerationStructureKHR,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnDestroyAccelerationStructureNV = fn (
    device: Device,
    acceleration_structure: AccelerationStructureNV,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetAccelerationStructureMemoryRequirementsNV = fn (
    device: Device,
    p_info: *const AccelerationStructureMemoryRequirementsInfoNV,
    p_memory_requirements: *MemoryRequirements2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnBindAccelerationStructureMemoryNV = fn (
    device: Device,
    bind_info_count: u32,
    p_bind_infos: [*]const BindAccelerationStructureMemoryInfoNV,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdCopyAccelerationStructureNV = fn (
    command_buffer: CommandBuffer,
    dst: AccelerationStructureNV,
    src: AccelerationStructureNV,
    mode: CopyAccelerationStructureModeKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyAccelerationStructureKHR = fn (
    command_buffer: CommandBuffer,
    p_info: *const CopyAccelerationStructureInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCopyAccelerationStructureKHR = fn (
    device: Device,
    deferred_operation: DeferredOperationKHR,
    p_info: *const CopyAccelerationStructureInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdCopyAccelerationStructureToMemoryKHR = fn (
    command_buffer: CommandBuffer,
    p_info: *const CopyAccelerationStructureToMemoryInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCopyAccelerationStructureToMemoryKHR = fn (
    device: Device,
    deferred_operation: DeferredOperationKHR,
    p_info: *const CopyAccelerationStructureToMemoryInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdCopyMemoryToAccelerationStructureKHR = fn (
    command_buffer: CommandBuffer,
    p_info: *const CopyMemoryToAccelerationStructureInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCopyMemoryToAccelerationStructureKHR = fn (
    device: Device,
    deferred_operation: DeferredOperationKHR,
    p_info: *const CopyMemoryToAccelerationStructureInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdWriteAccelerationStructuresPropertiesKHR = fn (
    command_buffer: CommandBuffer,
    acceleration_structure_count: u32,
    p_acceleration_structures: [*]const AccelerationStructureKHR,
    query_type: QueryType,
    query_pool: QueryPool,
    first_query: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdWriteAccelerationStructuresPropertiesNV = fn (
    command_buffer: CommandBuffer,
    acceleration_structure_count: u32,
    p_acceleration_structures: [*]const AccelerationStructureNV,
    query_type: QueryType,
    query_pool: QueryPool,
    first_query: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBuildAccelerationStructureNV = fn (
    command_buffer: CommandBuffer,
    p_info: *const AccelerationStructureInfoNV,
    instance_data: Buffer,
    instance_offset: DeviceSize,
    update: Bool32,
    dst: AccelerationStructureNV,
    src: AccelerationStructureNV,
    scratch: Buffer,
    scratch_offset: DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnWriteAccelerationStructuresPropertiesKHR = fn (
    device: Device,
    acceleration_structure_count: u32,
    p_acceleration_structures: [*]const AccelerationStructureKHR,
    query_type: QueryType,
    data_size: usize,
    p_data: *c_void,
    stride: usize,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdTraceRaysKHR = fn (
    command_buffer: CommandBuffer,
    p_raygen_shader_binding_table: *const StridedDeviceAddressRegionKHR,
    p_miss_shader_binding_table: *const StridedDeviceAddressRegionKHR,
    p_hit_shader_binding_table: *const StridedDeviceAddressRegionKHR,
    p_callable_shader_binding_table: *const StridedDeviceAddressRegionKHR,
    width: u32,
    height: u32,
    depth: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdTraceRaysNV = fn (
    command_buffer: CommandBuffer,
    raygen_shader_binding_table_buffer: Buffer,
    raygen_shader_binding_offset: DeviceSize,
    miss_shader_binding_table_buffer: Buffer,
    miss_shader_binding_offset: DeviceSize,
    miss_shader_binding_stride: DeviceSize,
    hit_shader_binding_table_buffer: Buffer,
    hit_shader_binding_offset: DeviceSize,
    hit_shader_binding_stride: DeviceSize,
    callable_shader_binding_table_buffer: Buffer,
    callable_shader_binding_offset: DeviceSize,
    callable_shader_binding_stride: DeviceSize,
    width: u32,
    height: u32,
    depth: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetRayTracingShaderGroupHandlesKHR = fn (
    device: Device,
    pipeline: Pipeline,
    first_group: u32,
    group_count: u32,
    data_size: usize,
    p_data: *c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnGetRayTracingCaptureReplayShaderGroupHandlesKHR = fn (
    device: Device,
    pipeline: Pipeline,
    first_group: u32,
    group_count: u32,
    data_size: usize,
    p_data: *c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnGetAccelerationStructureHandleNV = fn (
    device: Device,
    acceleration_structure: AccelerationStructureNV,
    data_size: usize,
    p_data: *c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateRayTracingPipelinesNV = fn (
    device: Device,
    pipeline_cache: PipelineCache,
    create_info_count: u32,
    p_create_infos: [*]const RayTracingPipelineCreateInfoNV,
    p_allocator: ?*const AllocationCallbacks,
    p_pipelines: [*]Pipeline,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateRayTracingPipelinesKHR = fn (
    device: Device,
    deferred_operation: DeferredOperationKHR,
    pipeline_cache: PipelineCache,
    create_info_count: u32,
    p_create_infos: [*]const RayTracingPipelineCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_pipelines: [*]Pipeline,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceCooperativeMatrixPropertiesNV = fn (
    physical_device: PhysicalDevice,
    p_property_count: *u32,
    p_properties: ?[*]CooperativeMatrixPropertiesNV,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdTraceRaysIndirectKHR = fn (
    command_buffer: CommandBuffer,
    p_raygen_shader_binding_table: *const StridedDeviceAddressRegionKHR,
    p_miss_shader_binding_table: *const StridedDeviceAddressRegionKHR,
    p_hit_shader_binding_table: *const StridedDeviceAddressRegionKHR,
    p_callable_shader_binding_table: *const StridedDeviceAddressRegionKHR,
    indirect_device_address: DeviceAddress,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeviceAccelerationStructureCompatibilityKHR = fn (
    device: Device,
    p_version_info: *const AccelerationStructureVersionInfoKHR,
    p_compatibility: *AccelerationStructureCompatibilityKHR,
) callconv(vulkan_call_conv) void;
pub const PfnGetRayTracingShaderGroupStackSizeKHR = fn (
    device: Device,
    pipeline: Pipeline,
    group: u32,
    group_shader: ShaderGroupShaderKHR,
) callconv(vulkan_call_conv) DeviceSize;
pub const PfnCmdSetRayTracingPipelineStackSizeKHR = fn (
    command_buffer: CommandBuffer,
    pipeline_stack_size: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageViewHandleNVX = fn (
    device: Device,
    p_info: *const ImageViewHandleInfoNVX,
) callconv(vulkan_call_conv) u32;
pub const PfnGetImageViewAddressNVX = fn (
    device: Device,
    image_view: ImageView,
    p_properties: *ImageViewAddressPropertiesNVX,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfacePresentModes2EXT = fn (
    physical_device: PhysicalDevice,
    p_surface_info: *const PhysicalDeviceSurfaceInfo2KHR,
    p_present_mode_count: *u32,
    p_present_modes: ?[*]PresentModeKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceGroupSurfacePresentModes2EXT = fn (
    device: Device,
    p_surface_info: *const PhysicalDeviceSurfaceInfo2KHR,
    p_modes: *DeviceGroupPresentModeFlagsKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireFullScreenExclusiveModeEXT = fn (
    device: Device,
    swapchain: SwapchainKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnReleaseFullScreenExclusiveModeEXT = fn (
    device: Device,
    swapchain: SwapchainKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR = fn (
    physical_device: PhysicalDevice,
    queue_family_index: u32,
    p_counter_count: *u32,
    p_counters: ?[*]PerformanceCounterKHR,
    p_counter_descriptions: ?[*]PerformanceCounterDescriptionKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR = fn (
    physical_device: PhysicalDevice,
    p_performance_query_create_info: *const QueryPoolPerformanceCreateInfoKHR,
    p_num_passes: *u32,
) callconv(vulkan_call_conv) void;
pub const PfnAcquireProfilingLockKHR = fn (
    device: Device,
    p_info: *const AcquireProfilingLockInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnReleaseProfilingLockKHR = fn (
    device: Device,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageDrmFormatModifierPropertiesEXT = fn (
    device: Device,
    image: Image,
    p_properties: *ImageDrmFormatModifierPropertiesEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnGetBufferOpaqueCaptureAddress = fn (
    device: Device,
    p_info: *const BufferDeviceAddressInfo,
) callconv(vulkan_call_conv) u64;
pub const PfnGetBufferDeviceAddress = fn (
    device: Device,
    p_info: *const BufferDeviceAddressInfo,
) callconv(vulkan_call_conv) DeviceAddress;
pub const PfnCreateHeadlessSurfaceEXT = fn (
    instance: Instance,
    p_create_info: *const HeadlessSurfaceCreateInfoEXT,
    p_allocator: ?*const AllocationCallbacks,
    p_surface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV = fn (
    physical_device: PhysicalDevice,
    p_combination_count: *u32,
    p_combinations: ?[*]FramebufferMixedSamplesCombinationNV,
) callconv(vulkan_call_conv) Result;
pub const PfnInitializePerformanceApiINTEL = fn (
    device: Device,
    p_initialize_info: *const InitializePerformanceApiInfoINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnUninitializePerformanceApiINTEL = fn (
    device: Device,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetPerformanceMarkerINTEL = fn (
    command_buffer: CommandBuffer,
    p_marker_info: *const PerformanceMarkerInfoINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetPerformanceStreamMarkerINTEL = fn (
    command_buffer: CommandBuffer,
    p_marker_info: *const PerformanceStreamMarkerInfoINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetPerformanceOverrideINTEL = fn (
    command_buffer: CommandBuffer,
    p_override_info: *const PerformanceOverrideInfoINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquirePerformanceConfigurationINTEL = fn (
    device: Device,
    p_acquire_info: *const PerformanceConfigurationAcquireInfoINTEL,
    p_configuration: *PerformanceConfigurationINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnReleasePerformanceConfigurationINTEL = fn (
    device: Device,
    configuration: PerformanceConfigurationINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnQueueSetPerformanceConfigurationINTEL = fn (
    queue: Queue,
    configuration: PerformanceConfigurationINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPerformanceParameterINTEL = fn (
    device: Device,
    parameter: PerformanceParameterTypeINTEL,
    p_value: *PerformanceValueINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceMemoryOpaqueCaptureAddress = fn (
    device: Device,
    p_info: *const DeviceMemoryOpaqueCaptureAddressInfo,
) callconv(vulkan_call_conv) u64;
pub const PfnGetPipelineExecutablePropertiesKHR = fn (
    device: Device,
    p_pipeline_info: *const PipelineInfoKHR,
    p_executable_count: *u32,
    p_properties: ?[*]PipelineExecutablePropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPipelineExecutableStatisticsKHR = fn (
    device: Device,
    p_executable_info: *const PipelineExecutableInfoKHR,
    p_statistic_count: *u32,
    p_statistics: ?[*]PipelineExecutableStatisticKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPipelineExecutableInternalRepresentationsKHR = fn (
    device: Device,
    p_executable_info: *const PipelineExecutableInfoKHR,
    p_internal_representation_count: *u32,
    p_internal_representations: ?[*]PipelineExecutableInternalRepresentationKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetLineStippleEXT = fn (
    command_buffer: CommandBuffer,
    line_stipple_factor: u32,
    line_stipple_pattern: u16,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceToolPropertiesEXT = fn (
    physical_device: PhysicalDevice,
    p_tool_count: *u32,
    p_tool_properties: ?[*]PhysicalDeviceToolPropertiesEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateAccelerationStructureKHR = fn (
    device: Device,
    p_create_info: *const AccelerationStructureCreateInfoKHR,
    p_allocator: ?*const AllocationCallbacks,
    p_acceleration_structure: *AccelerationStructureKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdBuildAccelerationStructuresKHR = fn (
    command_buffer: CommandBuffer,
    info_count: u32,
    p_infos: [*]const AccelerationStructureBuildGeometryInfoKHR,
    pp_build_range_infos: [*]const *const AccelerationStructureBuildRangeInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBuildAccelerationStructuresIndirectKHR = fn (
    command_buffer: CommandBuffer,
    info_count: u32,
    p_infos: [*]const AccelerationStructureBuildGeometryInfoKHR,
    p_indirect_device_addresses: [*]const DeviceAddress,
    p_indirect_strides: [*]const u32,
    pp_max_primitive_counts: [*]const *const u32,
) callconv(vulkan_call_conv) void;
pub const PfnBuildAccelerationStructuresKHR = fn (
    device: Device,
    deferred_operation: DeferredOperationKHR,
    info_count: u32,
    p_infos: [*]const AccelerationStructureBuildGeometryInfoKHR,
    pp_build_range_infos: [*]const *const AccelerationStructureBuildRangeInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetAccelerationStructureDeviceAddressKHR = fn (
    device: Device,
    p_info: *const AccelerationStructureDeviceAddressInfoKHR,
) callconv(vulkan_call_conv) DeviceAddress;
pub const PfnCreateDeferredOperationKHR = fn (
    device: Device,
    p_allocator: ?*const AllocationCallbacks,
    p_deferred_operation: *DeferredOperationKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDeferredOperationKHR = fn (
    device: Device,
    operation: DeferredOperationKHR,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeferredOperationMaxConcurrencyKHR = fn (
    device: Device,
    operation: DeferredOperationKHR,
) callconv(vulkan_call_conv) u32;
pub const PfnGetDeferredOperationResultKHR = fn (
    device: Device,
    operation: DeferredOperationKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDeferredOperationJoinKHR = fn (
    device: Device,
    operation: DeferredOperationKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetCullModeEXT = fn (
    command_buffer: CommandBuffer,
    cull_mode: CullModeFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetFrontFaceEXT = fn (
    command_buffer: CommandBuffer,
    front_face: FrontFace,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetPrimitiveTopologyEXT = fn (
    command_buffer: CommandBuffer,
    primitive_topology: PrimitiveTopology,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetViewportWithCountEXT = fn (
    command_buffer: CommandBuffer,
    viewport_count: u32,
    p_viewports: [*]const Viewport,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetScissorWithCountEXT = fn (
    command_buffer: CommandBuffer,
    scissor_count: u32,
    p_scissors: [*]const Rect2D,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindVertexBuffers2EXT = fn (
    command_buffer: CommandBuffer,
    first_binding: u32,
    binding_count: u32,
    p_buffers: [*]const Buffer,
    p_offsets: [*]const DeviceSize,
    p_sizes: ?[*]const DeviceSize,
    p_strides: ?[*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthTestEnableEXT = fn (
    command_buffer: CommandBuffer,
    depth_test_enable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthWriteEnableEXT = fn (
    command_buffer: CommandBuffer,
    depth_write_enable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthCompareOpEXT = fn (
    command_buffer: CommandBuffer,
    depth_compare_op: CompareOp,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthBoundsTestEnableEXT = fn (
    command_buffer: CommandBuffer,
    depth_bounds_test_enable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilTestEnableEXT = fn (
    command_buffer: CommandBuffer,
    stencil_test_enable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilOpEXT = fn (
    command_buffer: CommandBuffer,
    face_mask: StencilFaceFlags.IntType,
    fail_op: StencilOp,
    pass_op: StencilOp,
    depth_fail_op: StencilOp,
    compare_op: CompareOp,
) callconv(vulkan_call_conv) void;
pub const PfnCreatePrivateDataSlotEXT = fn (
    device: Device,
    p_create_info: *const PrivateDataSlotCreateInfoEXT,
    p_allocator: ?*const AllocationCallbacks,
    p_private_data_slot: *PrivateDataSlotEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyPrivateDataSlotEXT = fn (
    device: Device,
    private_data_slot: PrivateDataSlotEXT,
    p_allocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnSetPrivateDataEXT = fn (
    device: Device,
    object_type: ObjectType,
    object_handle: u64,
    private_data_slot: PrivateDataSlotEXT,
    data: u64,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPrivateDataEXT = fn (
    device: Device,
    object_type: ObjectType,
    object_handle: u64,
    private_data_slot: PrivateDataSlotEXT,
    p_data: *u64,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyBuffer2KHR = fn (
    command_buffer: CommandBuffer,
    p_copy_buffer_info: *const CopyBufferInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyImage2KHR = fn (
    command_buffer: CommandBuffer,
    p_copy_image_info: *const CopyImageInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBlitImage2KHR = fn (
    command_buffer: CommandBuffer,
    p_blit_image_info: *const BlitImageInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyBufferToImage2KHR = fn (
    command_buffer: CommandBuffer,
    p_copy_buffer_to_image_info: *const CopyBufferToImageInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyImageToBuffer2KHR = fn (
    command_buffer: CommandBuffer,
    p_copy_image_to_buffer_info: *const CopyImageToBufferInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdResolveImage2KHR = fn (
    command_buffer: CommandBuffer,
    p_resolve_image_info: *const ResolveImageInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetFragmentShadingRateKHR = fn (
    command_buffer: CommandBuffer,
    p_fragment_size: *const Extent2D,
    combiner_ops: [2]FragmentShadingRateCombinerOpKHR,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFragmentShadingRatesKHR = fn (
    physical_device: PhysicalDevice,
    p_fragment_shading_rate_count: *u32,
    p_fragment_shading_rates: ?[*]PhysicalDeviceFragmentShadingRateKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetFragmentShadingRateEnumNV = fn (
    command_buffer: CommandBuffer,
    shading_rate: FragmentShadingRateNV,
    combiner_ops: [2]FragmentShadingRateCombinerOpKHR,
) callconv(vulkan_call_conv) void;
pub const PfnGetAccelerationStructureBuildSizesKHR = fn (
    device: Device,
    build_type: AccelerationStructureBuildTypeKHR,
    p_build_info: *const AccelerationStructureBuildGeometryInfoKHR,
    p_max_primitive_counts: [*]const u32,
    p_size_info: *AccelerationStructureBuildSizesInfoKHR,
) callconv(vulkan_call_conv) void;
pub const extension_info = struct {
    const Info = struct {
        name: [:0]const u8,
        version: u32,
    };
    pub const khr_surface = Info{
        .name = "VK_KHR_surface",
        .version = 25,
    };
    pub const khr_swapchain = Info{
        .name = "VK_KHR_swapchain",
        .version = 70,
    };
    pub const khr_display = Info{
        .name = "VK_KHR_display",
        .version = 23,
    };
    pub const khr_display_swapchain = Info{
        .name = "VK_KHR_display_swapchain",
        .version = 10,
    };
    pub const khr_xlib_surface = Info{
        .name = "VK_KHR_xlib_surface",
        .version = 6,
    };
    pub const khr_xcb_surface = Info{
        .name = "VK_KHR_xcb_surface",
        .version = 6,
    };
    pub const khr_wayland_surface = Info{
        .name = "VK_KHR_wayland_surface",
        .version = 6,
    };
    pub const khr_android_surface = Info{
        .name = "VK_KHR_android_surface",
        .version = 6,
    };
    pub const khr_win_32_surface = Info{
        .name = "VK_KHR_win32_surface",
        .version = 6,
    };
    pub const ext_debug_report = Info{
        .name = "VK_EXT_debug_report",
        .version = 9,
    };
    pub const nv_glsl_shader = Info{
        .name = "VK_NV_glsl_shader",
        .version = 1,
    };
    pub const ext_depth_range_unrestricted = Info{
        .name = "VK_EXT_depth_range_unrestricted",
        .version = 1,
    };
    pub const img_filter_cubic = Info{
        .name = "VK_IMG_filter_cubic",
        .version = 1,
    };
    pub const amd_rasterization_order = Info{
        .name = "VK_AMD_rasterization_order",
        .version = 1,
    };
    pub const amd_shader_trinary_minmax = Info{
        .name = "VK_AMD_shader_trinary_minmax",
        .version = 1,
    };
    pub const amd_shader_explicit_vertex_parameter = Info{
        .name = "VK_AMD_shader_explicit_vertex_parameter",
        .version = 1,
    };
    pub const amd_gcn_shader = Info{
        .name = "VK_AMD_gcn_shader",
        .version = 1,
    };
    pub const nv_dedicated_allocation = Info{
        .name = "VK_NV_dedicated_allocation",
        .version = 1,
    };
    pub const ext_transform_feedback = Info{
        .name = "VK_EXT_transform_feedback",
        .version = 1,
    };
    pub const nvx_image_view_handle = Info{
        .name = "VK_NVX_image_view_handle",
        .version = 2,
    };
    pub const amd_negative_viewport_height = Info{
        .name = "VK_AMD_negative_viewport_height",
        .version = 1,
    };
    pub const amd_gpu_shader_half_float = Info{
        .name = "VK_AMD_gpu_shader_half_float",
        .version = 2,
    };
    pub const amd_shader_ballot = Info{
        .name = "VK_AMD_shader_ballot",
        .version = 1,
    };
    pub const amd_texture_gather_bias_lod = Info{
        .name = "VK_AMD_texture_gather_bias_lod",
        .version = 1,
    };
    pub const amd_shader_info = Info{
        .name = "VK_AMD_shader_info",
        .version = 1,
    };
    pub const amd_shader_image_load_store_lod = Info{
        .name = "VK_AMD_shader_image_load_store_lod",
        .version = 1,
    };
    pub const ggp_stream_descriptor_surface = Info{
        .name = "VK_GGP_stream_descriptor_surface",
        .version = 1,
    };
    pub const nv_corner_sampled_image = Info{
        .name = "VK_NV_corner_sampled_image",
        .version = 2,
    };
    pub const img_format_pvrtc = Info{
        .name = "VK_IMG_format_pvrtc",
        .version = 1,
    };
    pub const nv_external_memory_capabilities = Info{
        .name = "VK_NV_external_memory_capabilities",
        .version = 1,
    };
    pub const nv_external_memory = Info{
        .name = "VK_NV_external_memory",
        .version = 1,
    };
    pub const nv_external_memory_win_32 = Info{
        .name = "VK_NV_external_memory_win32",
        .version = 1,
    };
    pub const ext_validation_flags = Info{
        .name = "VK_EXT_validation_flags",
        .version = 2,
    };
    pub const nn_vi_surface = Info{
        .name = "VK_NN_vi_surface",
        .version = 1,
    };
    pub const ext_shader_subgroup_ballot = Info{
        .name = "VK_EXT_shader_subgroup_ballot",
        .version = 1,
    };
    pub const ext_shader_subgroup_vote = Info{
        .name = "VK_EXT_shader_subgroup_vote",
        .version = 1,
    };
    pub const ext_texture_compression_astc_hdr = Info{
        .name = "VK_EXT_texture_compression_astc_hdr",
        .version = 1,
    };
    pub const ext_astc_decode_mode = Info{
        .name = "VK_EXT_astc_decode_mode",
        .version = 1,
    };
    pub const khr_external_memory_win_32 = Info{
        .name = "VK_KHR_external_memory_win32",
        .version = 1,
    };
    pub const khr_external_memory_fd = Info{
        .name = "VK_KHR_external_memory_fd",
        .version = 1,
    };
    pub const khr_win_32_keyed_mutex = Info{
        .name = "VK_KHR_win32_keyed_mutex",
        .version = 1,
    };
    pub const khr_external_semaphore_win_32 = Info{
        .name = "VK_KHR_external_semaphore_win32",
        .version = 1,
    };
    pub const khr_external_semaphore_fd = Info{
        .name = "VK_KHR_external_semaphore_fd",
        .version = 1,
    };
    pub const khr_push_descriptor = Info{
        .name = "VK_KHR_push_descriptor",
        .version = 2,
    };
    pub const ext_conditional_rendering = Info{
        .name = "VK_EXT_conditional_rendering",
        .version = 2,
    };
    pub const khr_incremental_present = Info{
        .name = "VK_KHR_incremental_present",
        .version = 1,
    };
    pub const nv_clip_space_w_scaling = Info{
        .name = "VK_NV_clip_space_w_scaling",
        .version = 1,
    };
    pub const ext_direct_mode_display = Info{
        .name = "VK_EXT_direct_mode_display",
        .version = 1,
    };
    pub const ext_acquire_xlib_display = Info{
        .name = "VK_EXT_acquire_xlib_display",
        .version = 1,
    };
    pub const ext_display_surface_counter = Info{
        .name = "VK_EXT_display_surface_counter",
        .version = 1,
    };
    pub const ext_display_control = Info{
        .name = "VK_EXT_display_control",
        .version = 1,
    };
    pub const google_display_timing = Info{
        .name = "VK_GOOGLE_display_timing",
        .version = 1,
    };
    pub const nv_sample_mask_override_coverage = Info{
        .name = "VK_NV_sample_mask_override_coverage",
        .version = 1,
    };
    pub const nv_geometry_shader_passthrough = Info{
        .name = "VK_NV_geometry_shader_passthrough",
        .version = 1,
    };
    pub const nv_viewport_array_2 = Info{
        .name = "VK_NV_viewport_array2",
        .version = 1,
    };
    pub const nvx_multiview_per_view_attributes = Info{
        .name = "VK_NVX_multiview_per_view_attributes",
        .version = 1,
    };
    pub const nv_viewport_swizzle = Info{
        .name = "VK_NV_viewport_swizzle",
        .version = 1,
    };
    pub const ext_discard_rectangles = Info{
        .name = "VK_EXT_discard_rectangles",
        .version = 1,
    };
    pub const ext_conservative_rasterization = Info{
        .name = "VK_EXT_conservative_rasterization",
        .version = 1,
    };
    pub const ext_depth_clip_enable = Info{
        .name = "VK_EXT_depth_clip_enable",
        .version = 1,
    };
    pub const ext_swapchain_colorspace = Info{
        .name = "VK_EXT_swapchain_colorspace",
        .version = 4,
    };
    pub const ext_hdr_metadata = Info{
        .name = "VK_EXT_hdr_metadata",
        .version = 2,
    };
    pub const khr_shared_presentable_image = Info{
        .name = "VK_KHR_shared_presentable_image",
        .version = 1,
    };
    pub const khr_external_fence_win_32 = Info{
        .name = "VK_KHR_external_fence_win32",
        .version = 1,
    };
    pub const khr_external_fence_fd = Info{
        .name = "VK_KHR_external_fence_fd",
        .version = 1,
    };
    pub const khr_performance_query = Info{
        .name = "VK_KHR_performance_query",
        .version = 1,
    };
    pub const khr_get_surface_capabilities_2 = Info{
        .name = "VK_KHR_get_surface_capabilities2",
        .version = 1,
    };
    pub const khr_get_display_properties_2 = Info{
        .name = "VK_KHR_get_display_properties2",
        .version = 1,
    };
    pub const mvk_ios_surface = Info{
        .name = "VK_MVK_ios_surface",
        .version = 3,
    };
    pub const mvk_macos_surface = Info{
        .name = "VK_MVK_macos_surface",
        .version = 3,
    };
    pub const ext_external_memory_dma_buf = Info{
        .name = "VK_EXT_external_memory_dma_buf",
        .version = 1,
    };
    pub const ext_queue_family_foreign = Info{
        .name = "VK_EXT_queue_family_foreign",
        .version = 1,
    };
    pub const ext_debug_utils = Info{
        .name = "VK_EXT_debug_utils",
        .version = 2,
    };
    pub const android_external_memory_android_hardware_buffer = Info{
        .name = "VK_ANDROID_external_memory_android_hardware_buffer",
        .version = 3,
    };
    pub const amd_gpu_shader_int_16 = Info{
        .name = "VK_AMD_gpu_shader_int16",
        .version = 2,
    };
    pub const amd_mixed_attachment_samples = Info{
        .name = "VK_AMD_mixed_attachment_samples",
        .version = 1,
    };
    pub const amd_shader_fragment_mask = Info{
        .name = "VK_AMD_shader_fragment_mask",
        .version = 1,
    };
    pub const ext_inline_uniform_block = Info{
        .name = "VK_EXT_inline_uniform_block",
        .version = 1,
    };
    pub const ext_shader_stencil_export = Info{
        .name = "VK_EXT_shader_stencil_export",
        .version = 1,
    };
    pub const ext_sample_locations = Info{
        .name = "VK_EXT_sample_locations",
        .version = 1,
    };
    pub const ext_blend_operation_advanced = Info{
        .name = "VK_EXT_blend_operation_advanced",
        .version = 2,
    };
    pub const nv_fragment_coverage_to_color = Info{
        .name = "VK_NV_fragment_coverage_to_color",
        .version = 1,
    };
    pub const khr_acceleration_structure = Info{
        .name = "VK_KHR_acceleration_structure",
        .version = 11,
    };
    pub const khr_ray_tracing_pipeline = Info{
        .name = "VK_KHR_ray_tracing_pipeline",
        .version = 1,
    };
    pub const khr_ray_query = Info{
        .name = "VK_KHR_ray_query",
        .version = 1,
    };
    pub const nv_framebuffer_mixed_samples = Info{
        .name = "VK_NV_framebuffer_mixed_samples",
        .version = 1,
    };
    pub const nv_fill_rectangle = Info{
        .name = "VK_NV_fill_rectangle",
        .version = 1,
    };
    pub const nv_shader_sm_builtins = Info{
        .name = "VK_NV_shader_sm_builtins",
        .version = 1,
    };
    pub const ext_post_depth_coverage = Info{
        .name = "VK_EXT_post_depth_coverage",
        .version = 1,
    };
    pub const ext_image_drm_format_modifier = Info{
        .name = "VK_EXT_image_drm_format_modifier",
        .version = 1,
    };
    pub const ext_validation_cache = Info{
        .name = "VK_EXT_validation_cache",
        .version = 1,
    };
    pub const khr_portability_subset = Info{
        .name = "VK_KHR_portability_subset",
        .version = 1,
    };
    pub const nv_shading_rate_image = Info{
        .name = "VK_NV_shading_rate_image",
        .version = 3,
    };
    pub const nv_ray_tracing = Info{
        .name = "VK_NV_ray_tracing",
        .version = 3,
    };
    pub const nv_representative_fragment_test = Info{
        .name = "VK_NV_representative_fragment_test",
        .version = 2,
    };
    pub const ext_filter_cubic = Info{
        .name = "VK_EXT_filter_cubic",
        .version = 3,
    };
    pub const qcom_render_pass_shader_resolve = Info{
        .name = "VK_QCOM_render_pass_shader_resolve",
        .version = 4,
    };
    pub const ext_global_priority = Info{
        .name = "VK_EXT_global_priority",
        .version = 2,
    };
    pub const ext_external_memory_host = Info{
        .name = "VK_EXT_external_memory_host",
        .version = 1,
    };
    pub const amd_buffer_marker = Info{
        .name = "VK_AMD_buffer_marker",
        .version = 1,
    };
    pub const khr_shader_clock = Info{
        .name = "VK_KHR_shader_clock",
        .version = 1,
    };
    pub const amd_pipeline_compiler_control = Info{
        .name = "VK_AMD_pipeline_compiler_control",
        .version = 1,
    };
    pub const ext_calibrated_timestamps = Info{
        .name = "VK_EXT_calibrated_timestamps",
        .version = 1,
    };
    pub const amd_shader_core_properties = Info{
        .name = "VK_AMD_shader_core_properties",
        .version = 2,
    };
    pub const amd_memory_overallocation_behavior = Info{
        .name = "VK_AMD_memory_overallocation_behavior",
        .version = 1,
    };
    pub const ext_vertex_attribute_divisor = Info{
        .name = "VK_EXT_vertex_attribute_divisor",
        .version = 3,
    };
    pub const ggp_frame_token = Info{
        .name = "VK_GGP_frame_token",
        .version = 1,
    };
    pub const ext_pipeline_creation_feedback = Info{
        .name = "VK_EXT_pipeline_creation_feedback",
        .version = 1,
    };
    pub const nv_shader_subgroup_partitioned = Info{
        .name = "VK_NV_shader_subgroup_partitioned",
        .version = 1,
    };
    pub const khr_swapchain_mutable_format = Info{
        .name = "VK_KHR_swapchain_mutable_format",
        .version = 1,
    };
    pub const nv_compute_shader_derivatives = Info{
        .name = "VK_NV_compute_shader_derivatives",
        .version = 1,
    };
    pub const nv_mesh_shader = Info{
        .name = "VK_NV_mesh_shader",
        .version = 1,
    };
    pub const nv_fragment_shader_barycentric = Info{
        .name = "VK_NV_fragment_shader_barycentric",
        .version = 1,
    };
    pub const nv_shader_image_footprint = Info{
        .name = "VK_NV_shader_image_footprint",
        .version = 2,
    };
    pub const nv_scissor_exclusive = Info{
        .name = "VK_NV_scissor_exclusive",
        .version = 1,
    };
    pub const nv_device_diagnostic_checkpoints = Info{
        .name = "VK_NV_device_diagnostic_checkpoints",
        .version = 2,
    };
    pub const intel_shader_integer_functions_2 = Info{
        .name = "VK_INTEL_shader_integer_functions2",
        .version = 1,
    };
    pub const intel_performance_query = Info{
        .name = "VK_INTEL_performance_query",
        .version = 2,
    };
    pub const ext_pci_bus_info = Info{
        .name = "VK_EXT_pci_bus_info",
        .version = 2,
    };
    pub const amd_display_native_hdr = Info{
        .name = "VK_AMD_display_native_hdr",
        .version = 1,
    };
    pub const fuchsia_imagepipe_surface = Info{
        .name = "VK_FUCHSIA_imagepipe_surface",
        .version = 1,
    };
    pub const khr_shader_terminate_invocation = Info{
        .name = "VK_KHR_shader_terminate_invocation",
        .version = 1,
    };
    pub const ext_metal_surface = Info{
        .name = "VK_EXT_metal_surface",
        .version = 1,
    };
    pub const ext_fragment_density_map = Info{
        .name = "VK_EXT_fragment_density_map",
        .version = 1,
    };
    pub const google_hlsl_functionality_1 = Info{
        .name = "VK_GOOGLE_hlsl_functionality1",
        .version = 1,
    };
    pub const google_decorate_string = Info{
        .name = "VK_GOOGLE_decorate_string",
        .version = 1,
    };
    pub const ext_subgroup_size_control = Info{
        .name = "VK_EXT_subgroup_size_control",
        .version = 2,
    };
    pub const khr_fragment_shading_rate = Info{
        .name = "VK_KHR_fragment_shading_rate",
        .version = 1,
    };
    pub const amd_shader_core_properties_2 = Info{
        .name = "VK_AMD_shader_core_properties2",
        .version = 1,
    };
    pub const amd_device_coherent_memory = Info{
        .name = "VK_AMD_device_coherent_memory",
        .version = 1,
    };
    pub const ext_shader_image_atomic_int_64 = Info{
        .name = "VK_EXT_shader_image_atomic_int64",
        .version = 1,
    };
    pub const ext_memory_budget = Info{
        .name = "VK_EXT_memory_budget",
        .version = 1,
    };
    pub const ext_memory_priority = Info{
        .name = "VK_EXT_memory_priority",
        .version = 1,
    };
    pub const khr_surface_protected_capabilities = Info{
        .name = "VK_KHR_surface_protected_capabilities",
        .version = 1,
    };
    pub const nv_dedicated_allocation_image_aliasing = Info{
        .name = "VK_NV_dedicated_allocation_image_aliasing",
        .version = 1,
    };
    pub const ext_buffer_device_address = Info{
        .name = "VK_EXT_buffer_device_address",
        .version = 2,
    };
    pub const ext_tooling_info = Info{
        .name = "VK_EXT_tooling_info",
        .version = 1,
    };
    pub const ext_validation_features = Info{
        .name = "VK_EXT_validation_features",
        .version = 4,
    };
    pub const nv_cooperative_matrix = Info{
        .name = "VK_NV_cooperative_matrix",
        .version = 1,
    };
    pub const nv_coverage_reduction_mode = Info{
        .name = "VK_NV_coverage_reduction_mode",
        .version = 1,
    };
    pub const ext_fragment_shader_interlock = Info{
        .name = "VK_EXT_fragment_shader_interlock",
        .version = 1,
    };
    pub const ext_ycbcr_image_arrays = Info{
        .name = "VK_EXT_ycbcr_image_arrays",
        .version = 1,
    };
    pub const ext_full_screen_exclusive = Info{
        .name = "VK_EXT_full_screen_exclusive",
        .version = 4,
    };
    pub const ext_headless_surface = Info{
        .name = "VK_EXT_headless_surface",
        .version = 1,
    };
    pub const ext_line_rasterization = Info{
        .name = "VK_EXT_line_rasterization",
        .version = 1,
    };
    pub const ext_shader_atomic_float = Info{
        .name = "VK_EXT_shader_atomic_float",
        .version = 1,
    };
    pub const ext_index_type_uint_8 = Info{
        .name = "VK_EXT_index_type_uint8",
        .version = 1,
    };
    pub const ext_extended_dynamic_state = Info{
        .name = "VK_EXT_extended_dynamic_state",
        .version = 1,
    };
    pub const khr_deferred_host_operations = Info{
        .name = "VK_KHR_deferred_host_operations",
        .version = 4,
    };
    pub const khr_pipeline_executable_properties = Info{
        .name = "VK_KHR_pipeline_executable_properties",
        .version = 1,
    };
    pub const ext_shader_demote_to_helper_invocation = Info{
        .name = "VK_EXT_shader_demote_to_helper_invocation",
        .version = 1,
    };
    pub const nv_device_generated_commands = Info{
        .name = "VK_NV_device_generated_commands",
        .version = 3,
    };
    pub const ext_texel_buffer_alignment = Info{
        .name = "VK_EXT_texel_buffer_alignment",
        .version = 1,
    };
    pub const qcom_render_pass_transform = Info{
        .name = "VK_QCOM_render_pass_transform",
        .version = 1,
    };
    pub const ext_device_memory_report = Info{
        .name = "VK_EXT_device_memory_report",
        .version = 1,
    };
    pub const ext_robustness_2 = Info{
        .name = "VK_EXT_robustness2",
        .version = 1,
    };
    pub const ext_custom_border_color = Info{
        .name = "VK_EXT_custom_border_color",
        .version = 12,
    };
    pub const google_user_type = Info{
        .name = "VK_GOOGLE_user_type",
        .version = 1,
    };
    pub const khr_pipeline_library = Info{
        .name = "VK_KHR_pipeline_library",
        .version = 1,
    };
    pub const khr_shader_non_semantic_info = Info{
        .name = "VK_KHR_shader_non_semantic_info",
        .version = 1,
    };
    pub const ext_private_data = Info{
        .name = "VK_EXT_private_data",
        .version = 1,
    };
    pub const ext_pipeline_creation_cache_control = Info{
        .name = "VK_EXT_pipeline_creation_cache_control",
        .version = 3,
    };
    pub const nv_device_diagnostics_config = Info{
        .name = "VK_NV_device_diagnostics_config",
        .version = 1,
    };
    pub const qcom_render_pass_store_ops = Info{
        .name = "VK_QCOM_render_pass_store_ops",
        .version = 2,
    };
    pub const nv_fragment_shading_rate_enums = Info{
        .name = "VK_NV_fragment_shading_rate_enums",
        .version = 1,
    };
    pub const ext_fragment_density_map_2 = Info{
        .name = "VK_EXT_fragment_density_map2",
        .version = 1,
    };
    pub const qcom_rotated_copy_commands = Info{
        .name = "VK_QCOM_rotated_copy_commands",
        .version = 0,
    };
    pub const ext_image_robustness = Info{
        .name = "VK_EXT_image_robustness",
        .version = 1,
    };
    pub const khr_copy_commands_2 = Info{
        .name = "VK_KHR_copy_commands2",
        .version = 1,
    };
    pub const ext_4444_formats = Info{
        .name = "VK_EXT_4444_formats",
        .version = 1,
    };
    pub const ext_directfb_surface = Info{
        .name = "VK_EXT_directfb_surface",
        .version = 1,
    };
};
pub fn BaseWrapper(comptime Self: type) type {
    return struct {
        pub fn load(loader: anytype) !Self {
            var self: Self = undefined;
            inline for (std.meta.fields(Self)) |field| {
                const name = @ptrCast([*:0]const u8, field.name ++ "\x00");
                const cmd_ptr = loader(.null_handle, name) orelse return error.InvalidCommand;
                @field(self, field.name) = @ptrCast(field.field_type, cmd_ptr);
            }
            return self;
        }
        pub fn createInstance(
            self: Self,
            create_info: InstanceCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            LayerNotPresent,
            ExtensionNotPresent,
            IncompatibleDriver,
            Unknown,
        }!Instance {
            var instance: Instance = undefined;
            const result = self.vkCreateInstance(
                &create_info,
                p_allocator,
                &instance,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_initialization_failed => return error.InitializationFailed,
                .error_layer_not_present => return error.LayerNotPresent,
                .error_extension_not_present => return error.ExtensionNotPresent,
                .error_incompatible_driver => return error.IncompatibleDriver,
                else => return error.Unknown,
            }
            return instance;
        }
        pub fn getInstanceProcAddr(
            self: Self,
            instance: Instance,
            p_name: [*:0]const u8,
        ) PfnVoidFunction {
            return self.vkGetInstanceProcAddr(
                instance,
                p_name,
            );
        }
        pub fn enumerateInstanceVersion(
            self: Self,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!u32 {
            var api_version: u32 = undefined;
            const result = self.vkEnumerateInstanceVersion(
                &api_version,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return api_version;
        }
        pub fn enumerateInstanceLayerProperties(
            self: Self,
            p_property_count: *u32,
            p_properties: ?[*]LayerProperties,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkEnumerateInstanceLayerProperties(
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn enumerateInstanceExtensionProperties(
            self: Self,
            p_layer_name: ?[*:0]const u8,
            p_property_count: *u32,
            p_properties: ?[*]ExtensionProperties,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            LayerNotPresent,
            Unknown,
        }!Result {
            const result = self.vkEnumerateInstanceExtensionProperties(
                p_layer_name,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_layer_not_present => return error.LayerNotPresent,
                else => return error.Unknown,
            }
            return result;
        }
    };
}
pub fn InstanceWrapper(comptime Self: type) type {
    return struct {
        pub fn load(instance: Instance, loader: anytype) !Self {
            var self: Self = undefined;
            inline for (std.meta.fields(Self)) |field| {
                const name = @ptrCast([*:0]const u8, field.name ++ "\x00");
                const cmd_ptr = loader(instance, name) orelse return error.InvalidCommand;
                @field(self, field.name) = @ptrCast(field.field_type, cmd_ptr);
            }
            return self;
        }
        pub fn destroyInstance(
            self: Self,
            instance: Instance,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyInstance(
                instance,
                p_allocator,
            );
        }
        pub fn enumeratePhysicalDevices(
            self: Self,
            instance: Instance,
            p_physical_device_count: *u32,
            p_physical_devices: ?[*]PhysicalDevice,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            Unknown,
        }!Result {
            const result = self.vkEnumeratePhysicalDevices(
                instance,
                p_physical_device_count,
                p_physical_devices,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_initialization_failed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getDeviceProcAddr(
            self: Self,
            device: Device,
            p_name: [*:0]const u8,
        ) PfnVoidFunction {
            return self.vkGetDeviceProcAddr(
                device,
                p_name,
            );
        }
        pub fn getPhysicalDeviceProperties(
            self: Self,
            physical_device: PhysicalDevice,
        ) PhysicalDeviceProperties {
            var properties: PhysicalDeviceProperties = undefined;
            self.vkGetPhysicalDeviceProperties(
                physical_device,
                &properties,
            );
            return properties;
        }
        pub fn getPhysicalDeviceQueueFamilyProperties(
            self: Self,
            physical_device: PhysicalDevice,
            p_queue_family_property_count: *u32,
            p_queue_family_properties: ?[*]QueueFamilyProperties,
        ) void {
            self.vkGetPhysicalDeviceQueueFamilyProperties(
                physical_device,
                p_queue_family_property_count,
                p_queue_family_properties,
            );
        }
        pub fn getPhysicalDeviceMemoryProperties(
            self: Self,
            physical_device: PhysicalDevice,
        ) PhysicalDeviceMemoryProperties {
            var memory_properties: PhysicalDeviceMemoryProperties = undefined;
            self.vkGetPhysicalDeviceMemoryProperties(
                physical_device,
                &memory_properties,
            );
            return memory_properties;
        }
        pub fn getPhysicalDeviceFeatures(
            self: Self,
            physical_device: PhysicalDevice,
        ) PhysicalDeviceFeatures {
            var features: PhysicalDeviceFeatures = undefined;
            self.vkGetPhysicalDeviceFeatures(
                physical_device,
                &features,
            );
            return features;
        }
        pub fn getPhysicalDeviceFormatProperties(
            self: Self,
            physical_device: PhysicalDevice,
            format: Format,
        ) FormatProperties {
            var format_properties: FormatProperties = undefined;
            self.vkGetPhysicalDeviceFormatProperties(
                physical_device,
                format,
                &format_properties,
            );
            return format_properties;
        }
        pub fn getPhysicalDeviceImageFormatProperties(
            self: Self,
            physical_device: PhysicalDevice,
            format: Format,
            type: ImageType,
            tiling: ImageTiling,
            usage: ImageUsageFlags,
            flags: ImageCreateFlags,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            FormatNotSupported,
            Unknown,
        }!ImageFormatProperties {
            var image_format_properties: ImageFormatProperties = undefined;
            const result = self.vkGetPhysicalDeviceImageFormatProperties(
                physical_device,
                format,
                type,
                tiling,
                usage.toInt(),
                flags.toInt(),
                &image_format_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_format_not_supported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
            return image_format_properties;
        }
        pub fn createDevice(
            self: Self,
            physical_device: PhysicalDevice,
            create_info: DeviceCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            ExtensionNotPresent,
            FeatureNotPresent,
            TooManyObjects,
            DeviceLost,
            Unknown,
        }!Device {
            var device: Device = undefined;
            const result = self.vkCreateDevice(
                physical_device,
                &create_info,
                p_allocator,
                &device,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_initialization_failed => return error.InitializationFailed,
                .error_extension_not_present => return error.ExtensionNotPresent,
                .error_feature_not_present => return error.FeatureNotPresent,
                .error_too_many_objects => return error.TooManyObjects,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return device;
        }
        pub fn enumerateDeviceLayerProperties(
            self: Self,
            physical_device: PhysicalDevice,
            p_property_count: *u32,
            p_properties: ?[*]LayerProperties,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkEnumerateDeviceLayerProperties(
                physical_device,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn enumerateDeviceExtensionProperties(
            self: Self,
            physical_device: PhysicalDevice,
            p_layer_name: ?[*:0]const u8,
            p_property_count: *u32,
            p_properties: ?[*]ExtensionProperties,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            LayerNotPresent,
            Unknown,
        }!Result {
            const result = self.vkEnumerateDeviceExtensionProperties(
                physical_device,
                p_layer_name,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_layer_not_present => return error.LayerNotPresent,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceSparseImageFormatProperties(
            self: Self,
            physical_device: PhysicalDevice,
            format: Format,
            type: ImageType,
            samples: SampleCountFlags,
            usage: ImageUsageFlags,
            tiling: ImageTiling,
            p_property_count: *u32,
            p_properties: ?[*]SparseImageFormatProperties,
        ) void {
            self.vkGetPhysicalDeviceSparseImageFormatProperties(
                physical_device,
                format,
                type,
                samples.toInt(),
                usage.toInt(),
                tiling,
                p_property_count,
                p_properties,
            );
        }
        pub fn createAndroidSurfaceKHR(
            self: Self,
            instance: Instance,
            create_info: AndroidSurfaceCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateAndroidSurfaceKHR(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_native_window_in_use_khr => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceDisplayPropertiesKHR(
            self: Self,
            physical_device: PhysicalDevice,
            p_property_count: *u32,
            p_properties: ?[*]DisplayPropertiesKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceDisplayPropertiesKHR(
                physical_device,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceDisplayPlanePropertiesKHR(
            self: Self,
            physical_device: PhysicalDevice,
            p_property_count: *u32,
            p_properties: ?[*]DisplayPlanePropertiesKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceDisplayPlanePropertiesKHR(
                physical_device,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getDisplayPlaneSupportedDisplaysKHR(
            self: Self,
            physical_device: PhysicalDevice,
            plane_index: u32,
            p_display_count: *u32,
            p_displays: ?[*]DisplayKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetDisplayPlaneSupportedDisplaysKHR(
                physical_device,
                plane_index,
                p_display_count,
                p_displays,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getDisplayModePropertiesKHR(
            self: Self,
            physical_device: PhysicalDevice,
            display: DisplayKHR,
            p_property_count: *u32,
            p_properties: ?[*]DisplayModePropertiesKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetDisplayModePropertiesKHR(
                physical_device,
                display,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn createDisplayModeKHR(
            self: Self,
            physical_device: PhysicalDevice,
            display: DisplayKHR,
            create_info: DisplayModeCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            Unknown,
        }!DisplayModeKHR {
            var mode: DisplayModeKHR = undefined;
            const result = self.vkCreateDisplayModeKHR(
                physical_device,
                display,
                &create_info,
                p_allocator,
                &mode,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_initialization_failed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return mode;
        }
        pub fn getDisplayPlaneCapabilitiesKHR(
            self: Self,
            physical_device: PhysicalDevice,
            mode: DisplayModeKHR,
            plane_index: u32,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!DisplayPlaneCapabilitiesKHR {
            var capabilities: DisplayPlaneCapabilitiesKHR = undefined;
            const result = self.vkGetDisplayPlaneCapabilitiesKHR(
                physical_device,
                mode,
                plane_index,
                &capabilities,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return capabilities;
        }
        pub fn createDisplayPlaneSurfaceKHR(
            self: Self,
            instance: Instance,
            create_info: DisplaySurfaceCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateDisplayPlaneSurfaceKHR(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn destroySurfaceKHR(
            self: Self,
            instance: Instance,
            surface: SurfaceKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroySurfaceKHR(
                instance,
                surface,
                p_allocator,
            );
        }
        pub fn getPhysicalDeviceSurfaceSupportKHR(
            self: Self,
            physical_device: PhysicalDevice,
            queue_family_index: u32,
            surface: SurfaceKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!Bool32 {
            var supported: Bool32 = undefined;
            const result = self.vkGetPhysicalDeviceSurfaceSupportKHR(
                physical_device,
                queue_family_index,
                surface,
                &supported,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return supported;
        }
        pub fn getPhysicalDeviceSurfaceCapabilitiesKHR(
            self: Self,
            physical_device: PhysicalDevice,
            surface: SurfaceKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!SurfaceCapabilitiesKHR {
            var surface_capabilities: SurfaceCapabilitiesKHR = undefined;
            const result = self.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(
                physical_device,
                surface,
                &surface_capabilities,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return surface_capabilities;
        }
        pub fn getPhysicalDeviceSurfaceFormatsKHR(
            self: Self,
            physical_device: PhysicalDevice,
            surface: SurfaceKHR,
            p_surface_format_count: *u32,
            p_surface_formats: ?[*]SurfaceFormatKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceSurfaceFormatsKHR(
                physical_device,
                surface,
                p_surface_format_count,
                p_surface_formats,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceSurfacePresentModesKHR(
            self: Self,
            physical_device: PhysicalDevice,
            surface: SurfaceKHR,
            p_present_mode_count: *u32,
            p_present_modes: ?[*]PresentModeKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceSurfacePresentModesKHR(
                physical_device,
                surface,
                p_present_mode_count,
                p_present_modes,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn createViSurfaceNN(
            self: Self,
            instance: Instance,
            create_info: ViSurfaceCreateInfoNN,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateViSurfaceNN(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_native_window_in_use_khr => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn createWaylandSurfaceKHR(
            self: Self,
            instance: Instance,
            create_info: WaylandSurfaceCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateWaylandSurfaceKHR(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceWaylandPresentationSupportKHR(
            self: Self,
            physical_device: PhysicalDevice,
            queue_family_index: u32,
            display: *wl_display,
        ) Bool32 {
            return self.vkGetPhysicalDeviceWaylandPresentationSupportKHR(
                physical_device,
                queue_family_index,
                display,
            );
        }
        pub fn createWin32SurfaceKHR(
            self: Self,
            instance: Instance,
            create_info: Win32SurfaceCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateWin32SurfaceKHR(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceWin32PresentationSupportKHR(
            self: Self,
            physical_device: PhysicalDevice,
            queue_family_index: u32,
        ) Bool32 {
            return self.vkGetPhysicalDeviceWin32PresentationSupportKHR(
                physical_device,
                queue_family_index,
            );
        }
        pub fn createXlibSurfaceKHR(
            self: Self,
            instance: Instance,
            create_info: XlibSurfaceCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateXlibSurfaceKHR(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceXlibPresentationSupportKHR(
            self: Self,
            physical_device: PhysicalDevice,
            queue_family_index: u32,
            dpy: *Display,
            visual_id: VisualID,
        ) Bool32 {
            return self.vkGetPhysicalDeviceXlibPresentationSupportKHR(
                physical_device,
                queue_family_index,
                dpy,
                visual_id,
            );
        }
        pub fn createXcbSurfaceKHR(
            self: Self,
            instance: Instance,
            create_info: XcbSurfaceCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateXcbSurfaceKHR(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceXcbPresentationSupportKHR(
            self: Self,
            physical_device: PhysicalDevice,
            queue_family_index: u32,
            connection: *xcb_connection_t,
            visual_id: xcb_visualid_t,
        ) Bool32 {
            return self.vkGetPhysicalDeviceXcbPresentationSupportKHR(
                physical_device,
                queue_family_index,
                connection,
                visual_id,
            );
        }
        pub fn createDirectFbSurfaceEXT(
            self: Self,
            instance: Instance,
            create_info: DirectFBSurfaceCreateInfoEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateDirectFBSurfaceEXT(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceDirectFbPresentationSupportEXT(
            self: Self,
            physical_device: PhysicalDevice,
            queue_family_index: u32,
            dfb: *IDirectFB,
        ) Bool32 {
            return self.vkGetPhysicalDeviceDirectFBPresentationSupportEXT(
                physical_device,
                queue_family_index,
                dfb,
            );
        }
        pub fn createImagePipeSurfaceFUCHSIA(
            self: Self,
            instance: Instance,
            create_info: ImagePipeSurfaceCreateInfoFUCHSIA,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateImagePipeSurfaceFUCHSIA(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn createStreamDescriptorSurfaceGGP(
            self: Self,
            instance: Instance,
            create_info: StreamDescriptorSurfaceCreateInfoGGP,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateStreamDescriptorSurfaceGGP(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_native_window_in_use_khr => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn createDebugReportCallbackEXT(
            self: Self,
            instance: Instance,
            create_info: DebugReportCallbackCreateInfoEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!DebugReportCallbackEXT {
            var callback: DebugReportCallbackEXT = undefined;
            const result = self.vkCreateDebugReportCallbackEXT(
                instance,
                &create_info,
                p_allocator,
                &callback,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return callback;
        }
        pub fn destroyDebugReportCallbackEXT(
            self: Self,
            instance: Instance,
            callback: DebugReportCallbackEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyDebugReportCallbackEXT(
                instance,
                callback,
                p_allocator,
            );
        }
        pub fn debugReportMessageEXT(
            self: Self,
            instance: Instance,
            flags: DebugReportFlagsEXT,
            object_type: DebugReportObjectTypeEXT,
            object: u64,
            location: usize,
            message_code: i32,
            p_layer_prefix: [*:0]const u8,
            p_message: [*:0]const u8,
        ) void {
            self.vkDebugReportMessageEXT(
                instance,
                flags.toInt(),
                object_type,
                object,
                location,
                message_code,
                p_layer_prefix,
                p_message,
            );
        }
        pub fn getPhysicalDeviceExternalImageFormatPropertiesNV(
            self: Self,
            physical_device: PhysicalDevice,
            format: Format,
            type: ImageType,
            tiling: ImageTiling,
            usage: ImageUsageFlags,
            flags: ImageCreateFlags,
            external_handle_type: ExternalMemoryHandleTypeFlagsNV,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            FormatNotSupported,
            Unknown,
        }!ExternalImageFormatPropertiesNV {
            var external_image_format_properties: ExternalImageFormatPropertiesNV = undefined;
            const result = self.vkGetPhysicalDeviceExternalImageFormatPropertiesNV(
                physical_device,
                format,
                type,
                tiling,
                usage.toInt(),
                flags.toInt(),
                external_handle_type.toInt(),
                &external_image_format_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_format_not_supported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
            return external_image_format_properties;
        }
        pub fn getPhysicalDeviceFeatures2(
            self: Self,
            physical_device: PhysicalDevice,
            p_features: *PhysicalDeviceFeatures2,
        ) void {
            self.vkGetPhysicalDeviceFeatures2(
                physical_device,
                p_features,
            );
        }
        pub fn getPhysicalDeviceProperties2(
            self: Self,
            physical_device: PhysicalDevice,
            p_properties: *PhysicalDeviceProperties2,
        ) void {
            self.vkGetPhysicalDeviceProperties2(
                physical_device,
                p_properties,
            );
        }
        pub fn getPhysicalDeviceFormatProperties2(
            self: Self,
            physical_device: PhysicalDevice,
            format: Format,
            p_format_properties: *FormatProperties2,
        ) void {
            self.vkGetPhysicalDeviceFormatProperties2(
                physical_device,
                format,
                p_format_properties,
            );
        }
        pub fn getPhysicalDeviceImageFormatProperties2(
            self: Self,
            physical_device: PhysicalDevice,
            image_format_info: PhysicalDeviceImageFormatInfo2,
            p_image_format_properties: *ImageFormatProperties2,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            FormatNotSupported,
            Unknown,
        }!void {
            const result = self.vkGetPhysicalDeviceImageFormatProperties2(
                physical_device,
                &image_format_info,
                p_image_format_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_format_not_supported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
        }
        pub fn getPhysicalDeviceQueueFamilyProperties2(
            self: Self,
            physical_device: PhysicalDevice,
            p_queue_family_property_count: *u32,
            p_queue_family_properties: ?[*]QueueFamilyProperties2,
        ) void {
            self.vkGetPhysicalDeviceQueueFamilyProperties2(
                physical_device,
                p_queue_family_property_count,
                p_queue_family_properties,
            );
        }
        pub fn getPhysicalDeviceMemoryProperties2(
            self: Self,
            physical_device: PhysicalDevice,
            p_memory_properties: *PhysicalDeviceMemoryProperties2,
        ) void {
            self.vkGetPhysicalDeviceMemoryProperties2(
                physical_device,
                p_memory_properties,
            );
        }
        pub fn getPhysicalDeviceSparseImageFormatProperties2(
            self: Self,
            physical_device: PhysicalDevice,
            format_info: PhysicalDeviceSparseImageFormatInfo2,
            p_property_count: *u32,
            p_properties: ?[*]SparseImageFormatProperties2,
        ) void {
            self.vkGetPhysicalDeviceSparseImageFormatProperties2(
                physical_device,
                &format_info,
                p_property_count,
                p_properties,
            );
        }
        pub fn getPhysicalDeviceExternalBufferProperties(
            self: Self,
            physical_device: PhysicalDevice,
            external_buffer_info: PhysicalDeviceExternalBufferInfo,
            p_external_buffer_properties: *ExternalBufferProperties,
        ) void {
            self.vkGetPhysicalDeviceExternalBufferProperties(
                physical_device,
                &external_buffer_info,
                p_external_buffer_properties,
            );
        }
        pub fn getPhysicalDeviceExternalSemaphoreProperties(
            self: Self,
            physical_device: PhysicalDevice,
            external_semaphore_info: PhysicalDeviceExternalSemaphoreInfo,
            p_external_semaphore_properties: *ExternalSemaphoreProperties,
        ) void {
            self.vkGetPhysicalDeviceExternalSemaphoreProperties(
                physical_device,
                &external_semaphore_info,
                p_external_semaphore_properties,
            );
        }
        pub fn getPhysicalDeviceExternalFenceProperties(
            self: Self,
            physical_device: PhysicalDevice,
            external_fence_info: PhysicalDeviceExternalFenceInfo,
            p_external_fence_properties: *ExternalFenceProperties,
        ) void {
            self.vkGetPhysicalDeviceExternalFenceProperties(
                physical_device,
                &external_fence_info,
                p_external_fence_properties,
            );
        }
        pub fn releaseDisplayEXT(
            self: Self,
            physical_device: PhysicalDevice,
            display: DisplayKHR,
        ) error{Unknown}!void {
            const result = self.vkReleaseDisplayEXT(
                physical_device,
                display,
            );
            switch (result) {
                .success => {},
                else => return error.Unknown,
            }
        }
        pub fn acquireXlibDisplayEXT(
            self: Self,
            physical_device: PhysicalDevice,
            dpy: *Display,
            display: DisplayKHR,
        ) error{
            OutOfHostMemory,
            InitializationFailed,
            Unknown,
        }!void {
            const result = self.vkAcquireXlibDisplayEXT(
                physical_device,
                dpy,
                display,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_initialization_failed => return error.InitializationFailed,
                else => return error.Unknown,
            }
        }
        pub fn getRandROutputDisplayEXT(
            self: Self,
            physical_device: PhysicalDevice,
            dpy: *Display,
            rr_output: RROutput,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!DisplayKHR {
            var display: DisplayKHR = undefined;
            const result = self.vkGetRandROutputDisplayEXT(
                physical_device,
                dpy,
                rr_output,
                &display,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return display;
        }
        pub fn getPhysicalDeviceSurfaceCapabilities2EXT(
            self: Self,
            physical_device: PhysicalDevice,
            surface: SurfaceKHR,
            p_surface_capabilities: *SurfaceCapabilities2EXT,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!void {
            const result = self.vkGetPhysicalDeviceSurfaceCapabilities2EXT(
                physical_device,
                surface,
                p_surface_capabilities,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub fn enumeratePhysicalDeviceGroups(
            self: Self,
            instance: Instance,
            p_physical_device_group_count: *u32,
            p_physical_device_group_properties: ?[*]PhysicalDeviceGroupProperties,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            Unknown,
        }!Result {
            const result = self.vkEnumeratePhysicalDeviceGroups(
                instance,
                p_physical_device_group_count,
                p_physical_device_group_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_initialization_failed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDevicePresentRectanglesKHR(
            self: Self,
            physical_device: PhysicalDevice,
            surface: SurfaceKHR,
            p_rect_count: *u32,
            p_rects: ?[*]Rect2D,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDevicePresentRectanglesKHR(
                physical_device,
                surface,
                p_rect_count,
                p_rects,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn createIosSurfaceMVK(
            self: Self,
            instance: Instance,
            create_info: IOSSurfaceCreateInfoMVK,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateIOSSurfaceMVK(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_native_window_in_use_khr => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn createMacOsSurfaceMVK(
            self: Self,
            instance: Instance,
            create_info: MacOSSurfaceCreateInfoMVK,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateMacOSSurfaceMVK(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_native_window_in_use_khr => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn createMetalSurfaceEXT(
            self: Self,
            instance: Instance,
            create_info: MetalSurfaceCreateInfoEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateMetalSurfaceEXT(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_native_window_in_use_khr => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceMultisamplePropertiesEXT(
            self: Self,
            physical_device: PhysicalDevice,
            samples: SampleCountFlags,
            p_multisample_properties: *MultisamplePropertiesEXT,
        ) void {
            self.vkGetPhysicalDeviceMultisamplePropertiesEXT(
                physical_device,
                samples.toInt(),
                p_multisample_properties,
            );
        }
        pub fn getPhysicalDeviceSurfaceCapabilities2KHR(
            self: Self,
            physical_device: PhysicalDevice,
            surface_info: PhysicalDeviceSurfaceInfo2KHR,
            p_surface_capabilities: *SurfaceCapabilities2KHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!void {
            const result = self.vkGetPhysicalDeviceSurfaceCapabilities2KHR(
                physical_device,
                &surface_info,
                p_surface_capabilities,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub fn getPhysicalDeviceSurfaceFormats2KHR(
            self: Self,
            physical_device: PhysicalDevice,
            surface_info: PhysicalDeviceSurfaceInfo2KHR,
            p_surface_format_count: *u32,
            p_surface_formats: ?[*]SurfaceFormat2KHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceSurfaceFormats2KHR(
                physical_device,
                &surface_info,
                p_surface_format_count,
                p_surface_formats,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceDisplayProperties2KHR(
            self: Self,
            physical_device: PhysicalDevice,
            p_property_count: *u32,
            p_properties: ?[*]DisplayProperties2KHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceDisplayProperties2KHR(
                physical_device,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceDisplayPlaneProperties2KHR(
            self: Self,
            physical_device: PhysicalDevice,
            p_property_count: *u32,
            p_properties: ?[*]DisplayPlaneProperties2KHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceDisplayPlaneProperties2KHR(
                physical_device,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getDisplayModeProperties2KHR(
            self: Self,
            physical_device: PhysicalDevice,
            display: DisplayKHR,
            p_property_count: *u32,
            p_properties: ?[*]DisplayModeProperties2KHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetDisplayModeProperties2KHR(
                physical_device,
                display,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getDisplayPlaneCapabilities2KHR(
            self: Self,
            physical_device: PhysicalDevice,
            display_plane_info: DisplayPlaneInfo2KHR,
            p_capabilities: *DisplayPlaneCapabilities2KHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkGetDisplayPlaneCapabilities2KHR(
                physical_device,
                &display_plane_info,
                p_capabilities,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getPhysicalDeviceCalibrateableTimeDomainsEXT(
            self: Self,
            physical_device: PhysicalDevice,
            p_time_domain_count: *u32,
            p_time_domains: ?[*]TimeDomainEXT,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceCalibrateableTimeDomainsEXT(
                physical_device,
                p_time_domain_count,
                p_time_domains,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn createDebugUtilsMessengerEXT(
            self: Self,
            instance: Instance,
            create_info: DebugUtilsMessengerCreateInfoEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!DebugUtilsMessengerEXT {
            var messenger: DebugUtilsMessengerEXT = undefined;
            const result = self.vkCreateDebugUtilsMessengerEXT(
                instance,
                &create_info,
                p_allocator,
                &messenger,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return messenger;
        }
        pub fn destroyDebugUtilsMessengerEXT(
            self: Self,
            instance: Instance,
            messenger: DebugUtilsMessengerEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyDebugUtilsMessengerEXT(
                instance,
                messenger,
                p_allocator,
            );
        }
        pub fn submitDebugUtilsMessageEXT(
            self: Self,
            instance: Instance,
            message_severity: DebugUtilsMessageSeverityFlagsEXT,
            message_types: DebugUtilsMessageTypeFlagsEXT,
            callback_data: DebugUtilsMessengerCallbackDataEXT,
        ) void {
            self.vkSubmitDebugUtilsMessageEXT(
                instance,
                message_severity.toInt(),
                message_types.toInt(),
                &callback_data,
            );
        }
        pub fn getPhysicalDeviceCooperativeMatrixPropertiesNV(
            self: Self,
            physical_device: PhysicalDevice,
            p_property_count: *u32,
            p_properties: ?[*]CooperativeMatrixPropertiesNV,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceCooperativeMatrixPropertiesNV(
                physical_device,
                p_property_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceSurfacePresentModes2EXT(
            self: Self,
            physical_device: PhysicalDevice,
            surface_info: PhysicalDeviceSurfaceInfo2KHR,
            p_present_mode_count: *u32,
            p_present_modes: ?[*]PresentModeKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceSurfacePresentModes2EXT(
                physical_device,
                &surface_info,
                p_present_mode_count,
                p_present_modes,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn enumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(
            self: Self,
            physical_device: PhysicalDevice,
            queue_family_index: u32,
            p_counter_count: *u32,
            p_counters: ?[*]PerformanceCounterKHR,
            p_counter_descriptions: ?[*]PerformanceCounterDescriptionKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            Unknown,
        }!Result {
            const result = self.vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(
                physical_device,
                queue_family_index,
                p_counter_count,
                p_counters,
                p_counter_descriptions,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_initialization_failed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(
            self: Self,
            physical_device: PhysicalDevice,
            performance_query_create_info: QueryPoolPerformanceCreateInfoKHR,
        ) u32 {
            var num_passes: u32 = undefined;
            self.vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(
                physical_device,
                &performance_query_create_info,
                &num_passes,
            );
            return num_passes;
        }
        pub fn createHeadlessSurfaceEXT(
            self: Self,
            instance: Instance,
            create_info: HeadlessSurfaceCreateInfoEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.vkCreateHeadlessSurfaceEXT(
                instance,
                &create_info,
                p_allocator,
                &surface,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(
            self: Self,
            physical_device: PhysicalDevice,
            p_combination_count: *u32,
            p_combinations: ?[*]FramebufferMixedSamplesCombinationNV,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(
                physical_device,
                p_combination_count,
                p_combinations,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceToolPropertiesEXT(
            self: Self,
            physical_device: PhysicalDevice,
            p_tool_count: *u32,
            p_tool_properties: ?[*]PhysicalDeviceToolPropertiesEXT,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceToolPropertiesEXT(
                physical_device,
                p_tool_count,
                p_tool_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceFragmentShadingRatesKHR(
            self: Self,
            physical_device: PhysicalDevice,
            p_fragment_shading_rate_count: *u32,
            p_fragment_shading_rates: ?[*]PhysicalDeviceFragmentShadingRateKHR,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPhysicalDeviceFragmentShadingRatesKHR(
                physical_device,
                p_fragment_shading_rate_count,
                p_fragment_shading_rates,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return result;
        }
    };
}
pub fn DeviceWrapper(comptime Self: type) type {
    return struct {
        pub fn load(device: Device, loader: anytype) !Self {
            var self: Self = undefined;
            inline for (std.meta.fields(Self)) |field| {
                const name = @ptrCast([*:0]const u8, field.name ++ "\x00");
                const cmd_ptr = loader(device, name) orelse return error.InvalidCommand;
                @field(self, field.name) = @ptrCast(field.field_type, cmd_ptr);
            }
            return self;
        }
        pub fn destroyDevice(
            self: Self,
            device: Device,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyDevice(
                device,
                p_allocator,
            );
        }
        pub fn getDeviceQueue(
            self: Self,
            device: Device,
            queue_family_index: u32,
            queue_index: u32,
        ) Queue {
            var queue: Queue = undefined;
            self.vkGetDeviceQueue(
                device,
                queue_family_index,
                queue_index,
                &queue,
            );
            return queue;
        }
        pub fn queueSubmit(
            self: Self,
            queue: Queue,
            submit_count: u32,
            p_submits: [*]const SubmitInfo,
            fence: Fence,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!void {
            const result = self.vkQueueSubmit(
                queue,
                submit_count,
                p_submits,
                fence,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
        }
        pub fn queueWaitIdle(
            self: Self,
            queue: Queue,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!void {
            const result = self.vkQueueWaitIdle(
                queue,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
        }
        pub fn deviceWaitIdle(
            self: Self,
            device: Device,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!void {
            const result = self.vkDeviceWaitIdle(
                device,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
        }
        pub fn allocateMemory(
            self: Self,
            device: Device,
            allocate_info: MemoryAllocateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidExternalHandle,
            InvalidOpaqueCaptureAddress,
            Unknown,
        }!DeviceMemory {
            var memory: DeviceMemory = undefined;
            const result = self.vkAllocateMemory(
                device,
                &allocate_info,
                p_allocator,
                &memory,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_invalid_external_handle => return error.InvalidExternalHandle,
                .error_invalid_opaque_capture_address => return error.InvalidOpaqueCaptureAddress,
                else => return error.Unknown,
            }
            return memory;
        }
        pub fn freeMemory(
            self: Self,
            device: Device,
            memory: DeviceMemory,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkFreeMemory(
                device,
                memory,
                p_allocator,
            );
        }
        pub fn mapMemory(
            self: Self,
            device: Device,
            memory: DeviceMemory,
            offset: DeviceSize,
            size: DeviceSize,
            flags: MemoryMapFlags,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            MemoryMapFailed,
            Unknown,
        }!?*c_void {
            var pp_data: ?*c_void = undefined;
            const result = self.vkMapMemory(
                device,
                memory,
                offset,
                size,
                flags.toInt(),
                &pp_data,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_memory_map_failed => return error.MemoryMapFailed,
                else => return error.Unknown,
            }
            return pp_data;
        }
        pub fn unmapMemory(
            self: Self,
            device: Device,
            memory: DeviceMemory,
        ) void {
            self.vkUnmapMemory(
                device,
                memory,
            );
        }
        pub fn flushMappedMemoryRanges(
            self: Self,
            device: Device,
            memory_range_count: u32,
            p_memory_ranges: [*]const MappedMemoryRange,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkFlushMappedMemoryRanges(
                device,
                memory_range_count,
                p_memory_ranges,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn invalidateMappedMemoryRanges(
            self: Self,
            device: Device,
            memory_range_count: u32,
            p_memory_ranges: [*]const MappedMemoryRange,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkInvalidateMappedMemoryRanges(
                device,
                memory_range_count,
                p_memory_ranges,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getDeviceMemoryCommitment(
            self: Self,
            device: Device,
            memory: DeviceMemory,
        ) DeviceSize {
            var committed_memory_in_bytes: DeviceSize = undefined;
            self.vkGetDeviceMemoryCommitment(
                device,
                memory,
                &committed_memory_in_bytes,
            );
            return committed_memory_in_bytes;
        }
        pub fn getBufferMemoryRequirements(
            self: Self,
            device: Device,
            buffer: Buffer,
        ) MemoryRequirements {
            var memory_requirements: MemoryRequirements = undefined;
            self.vkGetBufferMemoryRequirements(
                device,
                buffer,
                &memory_requirements,
            );
            return memory_requirements;
        }
        pub fn bindBufferMemory(
            self: Self,
            device: Device,
            buffer: Buffer,
            memory: DeviceMemory,
            memory_offset: DeviceSize,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidOpaqueCaptureAddress,
            Unknown,
        }!void {
            const result = self.vkBindBufferMemory(
                device,
                buffer,
                memory,
                memory_offset,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_invalid_opaque_capture_address => return error.InvalidOpaqueCaptureAddress,
                else => return error.Unknown,
            }
        }
        pub fn getImageMemoryRequirements(
            self: Self,
            device: Device,
            image: Image,
        ) MemoryRequirements {
            var memory_requirements: MemoryRequirements = undefined;
            self.vkGetImageMemoryRequirements(
                device,
                image,
                &memory_requirements,
            );
            return memory_requirements;
        }
        pub fn bindImageMemory(
            self: Self,
            device: Device,
            image: Image,
            memory: DeviceMemory,
            memory_offset: DeviceSize,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkBindImageMemory(
                device,
                image,
                memory,
                memory_offset,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getImageSparseMemoryRequirements(
            self: Self,
            device: Device,
            image: Image,
            p_sparse_memory_requirement_count: *u32,
            p_sparse_memory_requirements: ?[*]SparseImageMemoryRequirements,
        ) void {
            self.vkGetImageSparseMemoryRequirements(
                device,
                image,
                p_sparse_memory_requirement_count,
                p_sparse_memory_requirements,
            );
        }
        pub fn queueBindSparse(
            self: Self,
            queue: Queue,
            bind_info_count: u32,
            p_bind_info: [*]const BindSparseInfo,
            fence: Fence,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!void {
            const result = self.vkQueueBindSparse(
                queue,
                bind_info_count,
                p_bind_info,
                fence,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
        }
        pub fn createFence(
            self: Self,
            device: Device,
            create_info: FenceCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Fence {
            var fence: Fence = undefined;
            const result = self.vkCreateFence(
                device,
                &create_info,
                p_allocator,
                &fence,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return fence;
        }
        pub fn destroyFence(
            self: Self,
            device: Device,
            fence: Fence,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyFence(
                device,
                fence,
                p_allocator,
            );
        }
        pub fn resetFences(
            self: Self,
            device: Device,
            fence_count: u32,
            p_fences: [*]const Fence,
        ) error{
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkResetFences(
                device,
                fence_count,
                p_fences,
            );
            switch (result) {
                .success => {},
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getFenceStatus(
            self: Self,
            device: Device,
            fence: Fence,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!Result {
            const result = self.vkGetFenceStatus(
                device,
                fence,
            );
            switch (result) {
                .success => {},
                .not_ready => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn waitForFences(
            self: Self,
            device: Device,
            fence_count: u32,
            p_fences: [*]const Fence,
            wait_all: Bool32,
            timeout: u64,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!Result {
            const result = self.vkWaitForFences(
                device,
                fence_count,
                p_fences,
                wait_all,
                timeout,
            );
            switch (result) {
                .success => {},
                .timeout => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn createSemaphore(
            self: Self,
            device: Device,
            create_info: SemaphoreCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Semaphore {
            var semaphore: Semaphore = undefined;
            const result = self.vkCreateSemaphore(
                device,
                &create_info,
                p_allocator,
                &semaphore,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return semaphore;
        }
        pub fn destroySemaphore(
            self: Self,
            device: Device,
            semaphore: Semaphore,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroySemaphore(
                device,
                semaphore,
                p_allocator,
            );
        }
        pub fn createEvent(
            self: Self,
            device: Device,
            create_info: EventCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Event {
            var event: Event = undefined;
            const result = self.vkCreateEvent(
                device,
                &create_info,
                p_allocator,
                &event,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return event;
        }
        pub fn destroyEvent(
            self: Self,
            device: Device,
            event: Event,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyEvent(
                device,
                event,
                p_allocator,
            );
        }
        pub fn getEventStatus(
            self: Self,
            device: Device,
            event: Event,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!Result {
            const result = self.vkGetEventStatus(
                device,
                event,
            );
            switch (result) {
                .event_set => {},
                .event_reset => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn setEvent(
            self: Self,
            device: Device,
            event: Event,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkSetEvent(
                device,
                event,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn resetEvent(
            self: Self,
            device: Device,
            event: Event,
        ) error{
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkResetEvent(
                device,
                event,
            );
            switch (result) {
                .success => {},
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn createQueryPool(
            self: Self,
            device: Device,
            create_info: QueryPoolCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!QueryPool {
            var query_pool: QueryPool = undefined;
            const result = self.vkCreateQueryPool(
                device,
                &create_info,
                p_allocator,
                &query_pool,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return query_pool;
        }
        pub fn destroyQueryPool(
            self: Self,
            device: Device,
            query_pool: QueryPool,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyQueryPool(
                device,
                query_pool,
                p_allocator,
            );
        }
        pub fn getQueryPoolResults(
            self: Self,
            device: Device,
            query_pool: QueryPool,
            first_query: u32,
            query_count: u32,
            data_size: usize,
            p_data: *c_void,
            stride: DeviceSize,
            flags: QueryResultFlags,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!Result {
            const result = self.vkGetQueryPoolResults(
                device,
                query_pool,
                first_query,
                query_count,
                data_size,
                p_data,
                stride,
                flags.toInt(),
            );
            switch (result) {
                .success => {},
                .not_ready => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn resetQueryPool(
            self: Self,
            device: Device,
            query_pool: QueryPool,
            first_query: u32,
            query_count: u32,
        ) void {
            self.vkResetQueryPool(
                device,
                query_pool,
                first_query,
                query_count,
            );
        }
        pub fn createBuffer(
            self: Self,
            device: Device,
            create_info: BufferCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidOpaqueCaptureAddress,
            Unknown,
        }!Buffer {
            var buffer: Buffer = undefined;
            const result = self.vkCreateBuffer(
                device,
                &create_info,
                p_allocator,
                &buffer,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_invalid_opaque_capture_address => return error.InvalidOpaqueCaptureAddress,
                else => return error.Unknown,
            }
            return buffer;
        }
        pub fn destroyBuffer(
            self: Self,
            device: Device,
            buffer: Buffer,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyBuffer(
                device,
                buffer,
                p_allocator,
            );
        }
        pub fn createBufferView(
            self: Self,
            device: Device,
            create_info: BufferViewCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!BufferView {
            var view: BufferView = undefined;
            const result = self.vkCreateBufferView(
                device,
                &create_info,
                p_allocator,
                &view,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return view;
        }
        pub fn destroyBufferView(
            self: Self,
            device: Device,
            buffer_view: BufferView,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyBufferView(
                device,
                buffer_view,
                p_allocator,
            );
        }
        pub fn createImage(
            self: Self,
            device: Device,
            create_info: ImageCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Image {
            var image: Image = undefined;
            const result = self.vkCreateImage(
                device,
                &create_info,
                p_allocator,
                &image,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return image;
        }
        pub fn destroyImage(
            self: Self,
            device: Device,
            image: Image,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyImage(
                device,
                image,
                p_allocator,
            );
        }
        pub fn getImageSubresourceLayout(
            self: Self,
            device: Device,
            image: Image,
            subresource: ImageSubresource,
        ) SubresourceLayout {
            var layout: SubresourceLayout = undefined;
            self.vkGetImageSubresourceLayout(
                device,
                image,
                &subresource,
                &layout,
            );
            return layout;
        }
        pub fn createImageView(
            self: Self,
            device: Device,
            create_info: ImageViewCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!ImageView {
            var view: ImageView = undefined;
            const result = self.vkCreateImageView(
                device,
                &create_info,
                p_allocator,
                &view,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return view;
        }
        pub fn destroyImageView(
            self: Self,
            device: Device,
            image_view: ImageView,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyImageView(
                device,
                image_view,
                p_allocator,
            );
        }
        pub fn createShaderModule(
            self: Self,
            device: Device,
            create_info: ShaderModuleCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidShaderNV,
            Unknown,
        }!ShaderModule {
            var shader_module: ShaderModule = undefined;
            const result = self.vkCreateShaderModule(
                device,
                &create_info,
                p_allocator,
                &shader_module,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_invalid_shader_nv => return error.InvalidShaderNV,
                else => return error.Unknown,
            }
            return shader_module;
        }
        pub fn destroyShaderModule(
            self: Self,
            device: Device,
            shader_module: ShaderModule,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyShaderModule(
                device,
                shader_module,
                p_allocator,
            );
        }
        pub fn createPipelineCache(
            self: Self,
            device: Device,
            create_info: PipelineCacheCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!PipelineCache {
            var pipeline_cache: PipelineCache = undefined;
            const result = self.vkCreatePipelineCache(
                device,
                &create_info,
                p_allocator,
                &pipeline_cache,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return pipeline_cache;
        }
        pub fn destroyPipelineCache(
            self: Self,
            device: Device,
            pipeline_cache: PipelineCache,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyPipelineCache(
                device,
                pipeline_cache,
                p_allocator,
            );
        }
        pub fn getPipelineCacheData(
            self: Self,
            device: Device,
            pipeline_cache: PipelineCache,
            p_data_size: *usize,
            p_data: ?*c_void,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPipelineCacheData(
                device,
                pipeline_cache,
                p_data_size,
                p_data,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn mergePipelineCaches(
            self: Self,
            device: Device,
            dst_cache: PipelineCache,
            src_cache_count: u32,
            p_src_caches: [*]const PipelineCache,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkMergePipelineCaches(
                device,
                dst_cache,
                src_cache_count,
                p_src_caches,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn createGraphicsPipelines(
            self: Self,
            device: Device,
            pipeline_cache: PipelineCache,
            create_info_count: u32,
            p_create_infos: [*]const GraphicsPipelineCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
            p_pipelines: [*]Pipeline,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidShaderNV,
            Unknown,
        }!Result {
            const result = self.vkCreateGraphicsPipelines(
                device,
                pipeline_cache,
                create_info_count,
                p_create_infos,
                p_allocator,
                p_pipelines,
            );
            switch (result) {
                .success => {},
                .pipeline_compile_required_ext => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_invalid_shader_nv => return error.InvalidShaderNV,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn createComputePipelines(
            self: Self,
            device: Device,
            pipeline_cache: PipelineCache,
            create_info_count: u32,
            p_create_infos: [*]const ComputePipelineCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
            p_pipelines: [*]Pipeline,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidShaderNV,
            Unknown,
        }!Result {
            const result = self.vkCreateComputePipelines(
                device,
                pipeline_cache,
                create_info_count,
                p_create_infos,
                p_allocator,
                p_pipelines,
            );
            switch (result) {
                .success => {},
                .pipeline_compile_required_ext => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_invalid_shader_nv => return error.InvalidShaderNV,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn destroyPipeline(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyPipeline(
                device,
                pipeline,
                p_allocator,
            );
        }
        pub fn createPipelineLayout(
            self: Self,
            device: Device,
            create_info: PipelineLayoutCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!PipelineLayout {
            var pipeline_layout: PipelineLayout = undefined;
            const result = self.vkCreatePipelineLayout(
                device,
                &create_info,
                p_allocator,
                &pipeline_layout,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return pipeline_layout;
        }
        pub fn destroyPipelineLayout(
            self: Self,
            device: Device,
            pipeline_layout: PipelineLayout,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyPipelineLayout(
                device,
                pipeline_layout,
                p_allocator,
            );
        }
        pub fn createSampler(
            self: Self,
            device: Device,
            create_info: SamplerCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Sampler {
            var sampler: Sampler = undefined;
            const result = self.vkCreateSampler(
                device,
                &create_info,
                p_allocator,
                &sampler,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return sampler;
        }
        pub fn destroySampler(
            self: Self,
            device: Device,
            sampler: Sampler,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroySampler(
                device,
                sampler,
                p_allocator,
            );
        }
        pub fn createDescriptorSetLayout(
            self: Self,
            device: Device,
            create_info: DescriptorSetLayoutCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!DescriptorSetLayout {
            var set_layout: DescriptorSetLayout = undefined;
            const result = self.vkCreateDescriptorSetLayout(
                device,
                &create_info,
                p_allocator,
                &set_layout,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return set_layout;
        }
        pub fn destroyDescriptorSetLayout(
            self: Self,
            device: Device,
            descriptor_set_layout: DescriptorSetLayout,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyDescriptorSetLayout(
                device,
                descriptor_set_layout,
                p_allocator,
            );
        }
        pub fn createDescriptorPool(
            self: Self,
            device: Device,
            create_info: DescriptorPoolCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Fragmentation,
            Unknown,
        }!DescriptorPool {
            var descriptor_pool: DescriptorPool = undefined;
            const result = self.vkCreateDescriptorPool(
                device,
                &create_info,
                p_allocator,
                &descriptor_pool,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_fragmentation => return error.Fragmentation,
                else => return error.Unknown,
            }
            return descriptor_pool;
        }
        pub fn destroyDescriptorPool(
            self: Self,
            device: Device,
            descriptor_pool: DescriptorPool,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyDescriptorPool(
                device,
                descriptor_pool,
                p_allocator,
            );
        }
        pub fn resetDescriptorPool(
            self: Self,
            device: Device,
            descriptor_pool: DescriptorPool,
            flags: DescriptorPoolResetFlags,
        ) error{Unknown}!void {
            const result = self.vkResetDescriptorPool(
                device,
                descriptor_pool,
                flags.toInt(),
            );
            switch (result) {
                .success => {},
                else => return error.Unknown,
            }
        }
        pub fn allocateDescriptorSets(
            self: Self,
            device: Device,
            allocate_info: DescriptorSetAllocateInfo,
            p_descriptor_sets: [*]DescriptorSet,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            FragmentedPool,
            OutOfPoolMemory,
            Unknown,
        }!void {
            const result = self.vkAllocateDescriptorSets(
                device,
                &allocate_info,
                p_descriptor_sets,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_fragmented_pool => return error.FragmentedPool,
                .error_out_of_pool_memory => return error.OutOfPoolMemory,
                else => return error.Unknown,
            }
        }
        pub fn freeDescriptorSets(
            self: Self,
            device: Device,
            descriptor_pool: DescriptorPool,
            descriptor_set_count: u32,
            p_descriptor_sets: [*]const DescriptorSet,
        ) error{Unknown}!void {
            const result = self.vkFreeDescriptorSets(
                device,
                descriptor_pool,
                descriptor_set_count,
                p_descriptor_sets,
            );
            switch (result) {
                .success => {},
                else => return error.Unknown,
            }
        }
        pub fn updateDescriptorSets(
            self: Self,
            device: Device,
            descriptor_write_count: u32,
            p_descriptor_writes: [*]const WriteDescriptorSet,
            descriptor_copy_count: u32,
            p_descriptor_copies: [*]const CopyDescriptorSet,
        ) void {
            self.vkUpdateDescriptorSets(
                device,
                descriptor_write_count,
                p_descriptor_writes,
                descriptor_copy_count,
                p_descriptor_copies,
            );
        }
        pub fn createFramebuffer(
            self: Self,
            device: Device,
            create_info: FramebufferCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Framebuffer {
            var framebuffer: Framebuffer = undefined;
            const result = self.vkCreateFramebuffer(
                device,
                &create_info,
                p_allocator,
                &framebuffer,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return framebuffer;
        }
        pub fn destroyFramebuffer(
            self: Self,
            device: Device,
            framebuffer: Framebuffer,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyFramebuffer(
                device,
                framebuffer,
                p_allocator,
            );
        }
        pub fn createRenderPass(
            self: Self,
            device: Device,
            create_info: RenderPassCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!RenderPass {
            var render_pass: RenderPass = undefined;
            const result = self.vkCreateRenderPass(
                device,
                &create_info,
                p_allocator,
                &render_pass,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return render_pass;
        }
        pub fn destroyRenderPass(
            self: Self,
            device: Device,
            render_pass: RenderPass,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyRenderPass(
                device,
                render_pass,
                p_allocator,
            );
        }
        pub fn getRenderAreaGranularity(
            self: Self,
            device: Device,
            render_pass: RenderPass,
        ) Extent2D {
            var granularity: Extent2D = undefined;
            self.vkGetRenderAreaGranularity(
                device,
                render_pass,
                &granularity,
            );
            return granularity;
        }
        pub fn createCommandPool(
            self: Self,
            device: Device,
            create_info: CommandPoolCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!CommandPool {
            var command_pool: CommandPool = undefined;
            const result = self.vkCreateCommandPool(
                device,
                &create_info,
                p_allocator,
                &command_pool,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return command_pool;
        }
        pub fn destroyCommandPool(
            self: Self,
            device: Device,
            command_pool: CommandPool,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyCommandPool(
                device,
                command_pool,
                p_allocator,
            );
        }
        pub fn resetCommandPool(
            self: Self,
            device: Device,
            command_pool: CommandPool,
            flags: CommandPoolResetFlags,
        ) error{
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkResetCommandPool(
                device,
                command_pool,
                flags.toInt(),
            );
            switch (result) {
                .success => {},
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn allocateCommandBuffers(
            self: Self,
            device: Device,
            allocate_info: CommandBufferAllocateInfo,
            p_command_buffers: [*]CommandBuffer,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkAllocateCommandBuffers(
                device,
                &allocate_info,
                p_command_buffers,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn freeCommandBuffers(
            self: Self,
            device: Device,
            command_pool: CommandPool,
            command_buffer_count: u32,
            p_command_buffers: [*]const CommandBuffer,
        ) void {
            self.vkFreeCommandBuffers(
                device,
                command_pool,
                command_buffer_count,
                p_command_buffers,
            );
        }
        pub fn beginCommandBuffer(
            self: Self,
            command_buffer: CommandBuffer,
            begin_info: CommandBufferBeginInfo,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkBeginCommandBuffer(
                command_buffer,
                &begin_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn endCommandBuffer(
            self: Self,
            command_buffer: CommandBuffer,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkEndCommandBuffer(
                command_buffer,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn resetCommandBuffer(
            self: Self,
            command_buffer: CommandBuffer,
            flags: CommandBufferResetFlags,
        ) error{
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkResetCommandBuffer(
                command_buffer,
                flags.toInt(),
            );
            switch (result) {
                .success => {},
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdBindPipeline(
            self: Self,
            command_buffer: CommandBuffer,
            pipeline_bind_point: PipelineBindPoint,
            pipeline: Pipeline,
        ) void {
            self.vkCmdBindPipeline(
                command_buffer,
                pipeline_bind_point,
                pipeline,
            );
        }
        pub fn cmdSetViewport(
            self: Self,
            command_buffer: CommandBuffer,
            first_viewport: u32,
            viewport_count: u32,
            p_viewports: [*]const Viewport,
        ) void {
            self.vkCmdSetViewport(
                command_buffer,
                first_viewport,
                viewport_count,
                p_viewports,
            );
        }
        pub fn cmdSetScissor(
            self: Self,
            command_buffer: CommandBuffer,
            first_scissor: u32,
            scissor_count: u32,
            p_scissors: [*]const Rect2D,
        ) void {
            self.vkCmdSetScissor(
                command_buffer,
                first_scissor,
                scissor_count,
                p_scissors,
            );
        }
        pub fn cmdSetLineWidth(
            self: Self,
            command_buffer: CommandBuffer,
            line_width: f32,
        ) void {
            self.vkCmdSetLineWidth(
                command_buffer,
                line_width,
            );
        }
        pub fn cmdSetDepthBias(
            self: Self,
            command_buffer: CommandBuffer,
            depth_bias_constant_factor: f32,
            depth_bias_clamp: f32,
            depth_bias_slope_factor: f32,
        ) void {
            self.vkCmdSetDepthBias(
                command_buffer,
                depth_bias_constant_factor,
                depth_bias_clamp,
                depth_bias_slope_factor,
            );
        }
        pub fn cmdSetBlendConstants(
            self: Self,
            command_buffer: CommandBuffer,
            blend_constants: [4]f32,
        ) void {
            self.vkCmdSetBlendConstants(
                command_buffer,
                blend_constants,
            );
        }
        pub fn cmdSetDepthBounds(
            self: Self,
            command_buffer: CommandBuffer,
            min_depth_bounds: f32,
            max_depth_bounds: f32,
        ) void {
            self.vkCmdSetDepthBounds(
                command_buffer,
                min_depth_bounds,
                max_depth_bounds,
            );
        }
        pub fn cmdSetStencilCompareMask(
            self: Self,
            command_buffer: CommandBuffer,
            face_mask: StencilFaceFlags,
            compare_mask: u32,
        ) void {
            self.vkCmdSetStencilCompareMask(
                command_buffer,
                face_mask.toInt(),
                compare_mask,
            );
        }
        pub fn cmdSetStencilWriteMask(
            self: Self,
            command_buffer: CommandBuffer,
            face_mask: StencilFaceFlags,
            write_mask: u32,
        ) void {
            self.vkCmdSetStencilWriteMask(
                command_buffer,
                face_mask.toInt(),
                write_mask,
            );
        }
        pub fn cmdSetStencilReference(
            self: Self,
            command_buffer: CommandBuffer,
            face_mask: StencilFaceFlags,
            reference: u32,
        ) void {
            self.vkCmdSetStencilReference(
                command_buffer,
                face_mask.toInt(),
                reference,
            );
        }
        pub fn cmdBindDescriptorSets(
            self: Self,
            command_buffer: CommandBuffer,
            pipeline_bind_point: PipelineBindPoint,
            layout: PipelineLayout,
            first_set: u32,
            descriptor_set_count: u32,
            p_descriptor_sets: [*]const DescriptorSet,
            dynamic_offset_count: u32,
            p_dynamic_offsets: [*]const u32,
        ) void {
            self.vkCmdBindDescriptorSets(
                command_buffer,
                pipeline_bind_point,
                layout,
                first_set,
                descriptor_set_count,
                p_descriptor_sets,
                dynamic_offset_count,
                p_dynamic_offsets,
            );
        }
        pub fn cmdBindIndexBuffer(
            self: Self,
            command_buffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            index_type: IndexType,
        ) void {
            self.vkCmdBindIndexBuffer(
                command_buffer,
                buffer,
                offset,
                index_type,
            );
        }
        pub fn cmdBindVertexBuffers(
            self: Self,
            command_buffer: CommandBuffer,
            first_binding: u32,
            binding_count: u32,
            p_buffers: [*]const Buffer,
            p_offsets: [*]const DeviceSize,
        ) void {
            self.vkCmdBindVertexBuffers(
                command_buffer,
                first_binding,
                binding_count,
                p_buffers,
                p_offsets,
            );
        }
        pub fn cmdDraw(
            self: Self,
            command_buffer: CommandBuffer,
            vertex_count: u32,
            instance_count: u32,
            first_vertex: u32,
            first_instance: u32,
        ) void {
            self.vkCmdDraw(
                command_buffer,
                vertex_count,
                instance_count,
                first_vertex,
                first_instance,
            );
        }
        pub fn cmdDrawIndexed(
            self: Self,
            command_buffer: CommandBuffer,
            index_count: u32,
            instance_count: u32,
            first_index: u32,
            vertex_offset: i32,
            first_instance: u32,
        ) void {
            self.vkCmdDrawIndexed(
                command_buffer,
                index_count,
                instance_count,
                first_index,
                vertex_offset,
                first_instance,
            );
        }
        pub fn cmdDrawIndirect(
            self: Self,
            command_buffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            draw_count: u32,
            stride: u32,
        ) void {
            self.vkCmdDrawIndirect(
                command_buffer,
                buffer,
                offset,
                draw_count,
                stride,
            );
        }
        pub fn cmdDrawIndexedIndirect(
            self: Self,
            command_buffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            draw_count: u32,
            stride: u32,
        ) void {
            self.vkCmdDrawIndexedIndirect(
                command_buffer,
                buffer,
                offset,
                draw_count,
                stride,
            );
        }
        pub fn cmdDispatch(
            self: Self,
            command_buffer: CommandBuffer,
            group_count_x: u32,
            group_count_y: u32,
            group_count_z: u32,
        ) void {
            self.vkCmdDispatch(
                command_buffer,
                group_count_x,
                group_count_y,
                group_count_z,
            );
        }
        pub fn cmdDispatchIndirect(
            self: Self,
            command_buffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
        ) void {
            self.vkCmdDispatchIndirect(
                command_buffer,
                buffer,
                offset,
            );
        }
        pub fn cmdCopyBuffer(
            self: Self,
            command_buffer: CommandBuffer,
            src_buffer: Buffer,
            dst_buffer: Buffer,
            region_count: u32,
            p_regions: [*]const BufferCopy,
        ) void {
            self.vkCmdCopyBuffer(
                command_buffer,
                src_buffer,
                dst_buffer,
                region_count,
                p_regions,
            );
        }
        pub fn cmdCopyImage(
            self: Self,
            command_buffer: CommandBuffer,
            src_image: Image,
            src_image_layout: ImageLayout,
            dst_image: Image,
            dst_image_layout: ImageLayout,
            region_count: u32,
            p_regions: [*]const ImageCopy,
        ) void {
            self.vkCmdCopyImage(
                command_buffer,
                src_image,
                src_image_layout,
                dst_image,
                dst_image_layout,
                region_count,
                p_regions,
            );
        }
        pub fn cmdBlitImage(
            self: Self,
            command_buffer: CommandBuffer,
            src_image: Image,
            src_image_layout: ImageLayout,
            dst_image: Image,
            dst_image_layout: ImageLayout,
            region_count: u32,
            p_regions: [*]const ImageBlit,
            filter: Filter,
        ) void {
            self.vkCmdBlitImage(
                command_buffer,
                src_image,
                src_image_layout,
                dst_image,
                dst_image_layout,
                region_count,
                p_regions,
                filter,
            );
        }
        pub fn cmdCopyBufferToImage(
            self: Self,
            command_buffer: CommandBuffer,
            src_buffer: Buffer,
            dst_image: Image,
            dst_image_layout: ImageLayout,
            region_count: u32,
            p_regions: [*]const BufferImageCopy,
        ) void {
            self.vkCmdCopyBufferToImage(
                command_buffer,
                src_buffer,
                dst_image,
                dst_image_layout,
                region_count,
                p_regions,
            );
        }
        pub fn cmdCopyImageToBuffer(
            self: Self,
            command_buffer: CommandBuffer,
            src_image: Image,
            src_image_layout: ImageLayout,
            dst_buffer: Buffer,
            region_count: u32,
            p_regions: [*]const BufferImageCopy,
        ) void {
            self.vkCmdCopyImageToBuffer(
                command_buffer,
                src_image,
                src_image_layout,
                dst_buffer,
                region_count,
                p_regions,
            );
        }
        pub fn cmdUpdateBuffer(
            self: Self,
            command_buffer: CommandBuffer,
            dst_buffer: Buffer,
            dst_offset: DeviceSize,
            data_size: DeviceSize,
            p_data: *const c_void,
        ) void {
            self.vkCmdUpdateBuffer(
                command_buffer,
                dst_buffer,
                dst_offset,
                data_size,
                p_data,
            );
        }
        pub fn cmdFillBuffer(
            self: Self,
            command_buffer: CommandBuffer,
            dst_buffer: Buffer,
            dst_offset: DeviceSize,
            size: DeviceSize,
            data: u32,
        ) void {
            self.vkCmdFillBuffer(
                command_buffer,
                dst_buffer,
                dst_offset,
                size,
                data,
            );
        }
        pub fn cmdClearColorImage(
            self: Self,
            command_buffer: CommandBuffer,
            image: Image,
            image_layout: ImageLayout,
            color: ClearColorValue,
            range_count: u32,
            p_ranges: [*]const ImageSubresourceRange,
        ) void {
            self.vkCmdClearColorImage(
                command_buffer,
                image,
                image_layout,
                &color,
                range_count,
                p_ranges,
            );
        }
        pub fn cmdClearDepthStencilImage(
            self: Self,
            command_buffer: CommandBuffer,
            image: Image,
            image_layout: ImageLayout,
            depth_stencil: ClearDepthStencilValue,
            range_count: u32,
            p_ranges: [*]const ImageSubresourceRange,
        ) void {
            self.vkCmdClearDepthStencilImage(
                command_buffer,
                image,
                image_layout,
                &depth_stencil,
                range_count,
                p_ranges,
            );
        }
        pub fn cmdClearAttachments(
            self: Self,
            command_buffer: CommandBuffer,
            attachment_count: u32,
            p_attachments: [*]const ClearAttachment,
            rect_count: u32,
            p_rects: [*]const ClearRect,
        ) void {
            self.vkCmdClearAttachments(
                command_buffer,
                attachment_count,
                p_attachments,
                rect_count,
                p_rects,
            );
        }
        pub fn cmdResolveImage(
            self: Self,
            command_buffer: CommandBuffer,
            src_image: Image,
            src_image_layout: ImageLayout,
            dst_image: Image,
            dst_image_layout: ImageLayout,
            region_count: u32,
            p_regions: [*]const ImageResolve,
        ) void {
            self.vkCmdResolveImage(
                command_buffer,
                src_image,
                src_image_layout,
                dst_image,
                dst_image_layout,
                region_count,
                p_regions,
            );
        }
        pub fn cmdSetEvent(
            self: Self,
            command_buffer: CommandBuffer,
            event: Event,
            stage_mask: PipelineStageFlags,
        ) void {
            self.vkCmdSetEvent(
                command_buffer,
                event,
                stage_mask.toInt(),
            );
        }
        pub fn cmdResetEvent(
            self: Self,
            command_buffer: CommandBuffer,
            event: Event,
            stage_mask: PipelineStageFlags,
        ) void {
            self.vkCmdResetEvent(
                command_buffer,
                event,
                stage_mask.toInt(),
            );
        }
        pub fn cmdWaitEvents(
            self: Self,
            command_buffer: CommandBuffer,
            event_count: u32,
            p_events: [*]const Event,
            src_stage_mask: PipelineStageFlags,
            dst_stage_mask: PipelineStageFlags,
            memory_barrier_count: u32,
            p_memory_barriers: [*]const MemoryBarrier,
            buffer_memory_barrier_count: u32,
            p_buffer_memory_barriers: [*]const BufferMemoryBarrier,
            image_memory_barrier_count: u32,
            p_image_memory_barriers: [*]const ImageMemoryBarrier,
        ) void {
            self.vkCmdWaitEvents(
                command_buffer,
                event_count,
                p_events,
                src_stage_mask.toInt(),
                dst_stage_mask.toInt(),
                memory_barrier_count,
                p_memory_barriers,
                buffer_memory_barrier_count,
                p_buffer_memory_barriers,
                image_memory_barrier_count,
                p_image_memory_barriers,
            );
        }
        pub fn cmdPipelineBarrier(
            self: Self,
            command_buffer: CommandBuffer,
            src_stage_mask: PipelineStageFlags,
            dst_stage_mask: PipelineStageFlags,
            dependency_flags: DependencyFlags,
            memory_barrier_count: u32,
            p_memory_barriers: [*]const MemoryBarrier,
            buffer_memory_barrier_count: u32,
            p_buffer_memory_barriers: [*]const BufferMemoryBarrier,
            image_memory_barrier_count: u32,
            p_image_memory_barriers: [*]const ImageMemoryBarrier,
        ) void {
            self.vkCmdPipelineBarrier(
                command_buffer,
                src_stage_mask.toInt(),
                dst_stage_mask.toInt(),
                dependency_flags.toInt(),
                memory_barrier_count,
                p_memory_barriers,
                buffer_memory_barrier_count,
                p_buffer_memory_barriers,
                image_memory_barrier_count,
                p_image_memory_barriers,
            );
        }
        pub fn cmdBeginQuery(
            self: Self,
            command_buffer: CommandBuffer,
            query_pool: QueryPool,
            query: u32,
            flags: QueryControlFlags,
        ) void {
            self.vkCmdBeginQuery(
                command_buffer,
                query_pool,
                query,
                flags.toInt(),
            );
        }
        pub fn cmdEndQuery(
            self: Self,
            command_buffer: CommandBuffer,
            query_pool: QueryPool,
            query: u32,
        ) void {
            self.vkCmdEndQuery(
                command_buffer,
                query_pool,
                query,
            );
        }
        pub fn cmdBeginConditionalRenderingEXT(
            self: Self,
            command_buffer: CommandBuffer,
            conditional_rendering_begin: ConditionalRenderingBeginInfoEXT,
        ) void {
            self.vkCmdBeginConditionalRenderingEXT(
                command_buffer,
                &conditional_rendering_begin,
            );
        }
        pub fn cmdEndConditionalRenderingEXT(
            self: Self,
            command_buffer: CommandBuffer,
        ) void {
            self.vkCmdEndConditionalRenderingEXT(
                command_buffer,
            );
        }
        pub fn cmdResetQueryPool(
            self: Self,
            command_buffer: CommandBuffer,
            query_pool: QueryPool,
            first_query: u32,
            query_count: u32,
        ) void {
            self.vkCmdResetQueryPool(
                command_buffer,
                query_pool,
                first_query,
                query_count,
            );
        }
        pub fn cmdWriteTimestamp(
            self: Self,
            command_buffer: CommandBuffer,
            pipeline_stage: PipelineStageFlags,
            query_pool: QueryPool,
            query: u32,
        ) void {
            self.vkCmdWriteTimestamp(
                command_buffer,
                pipeline_stage.toInt(),
                query_pool,
                query,
            );
        }
        pub fn cmdCopyQueryPoolResults(
            self: Self,
            command_buffer: CommandBuffer,
            query_pool: QueryPool,
            first_query: u32,
            query_count: u32,
            dst_buffer: Buffer,
            dst_offset: DeviceSize,
            stride: DeviceSize,
            flags: QueryResultFlags,
        ) void {
            self.vkCmdCopyQueryPoolResults(
                command_buffer,
                query_pool,
                first_query,
                query_count,
                dst_buffer,
                dst_offset,
                stride,
                flags.toInt(),
            );
        }
        pub fn cmdPushConstants(
            self: Self,
            command_buffer: CommandBuffer,
            layout: PipelineLayout,
            stage_flags: ShaderStageFlags,
            offset: u32,
            size: u32,
            p_values: *const c_void,
        ) void {
            self.vkCmdPushConstants(
                command_buffer,
                layout,
                stage_flags.toInt(),
                offset,
                size,
                p_values,
            );
        }
        pub fn cmdBeginRenderPass(
            self: Self,
            command_buffer: CommandBuffer,
            render_pass_begin: RenderPassBeginInfo,
            contents: SubpassContents,
        ) void {
            self.vkCmdBeginRenderPass(
                command_buffer,
                &render_pass_begin,
                contents,
            );
        }
        pub fn cmdNextSubpass(
            self: Self,
            command_buffer: CommandBuffer,
            contents: SubpassContents,
        ) void {
            self.vkCmdNextSubpass(
                command_buffer,
                contents,
            );
        }
        pub fn cmdEndRenderPass(
            self: Self,
            command_buffer: CommandBuffer,
        ) void {
            self.vkCmdEndRenderPass(
                command_buffer,
            );
        }
        pub fn cmdExecuteCommands(
            self: Self,
            command_buffer: CommandBuffer,
            command_buffer_count: u32,
            p_command_buffers: [*]const CommandBuffer,
        ) void {
            self.vkCmdExecuteCommands(
                command_buffer,
                command_buffer_count,
                p_command_buffers,
            );
        }
        pub fn createSharedSwapchainsKHR(
            self: Self,
            device: Device,
            swapchain_count: u32,
            p_create_infos: [*]const SwapchainCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
            p_swapchains: [*]SwapchainKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            IncompatibleDisplayKHR,
            DeviceLost,
            SurfaceLostKHR,
            Unknown,
        }!void {
            const result = self.vkCreateSharedSwapchainsKHR(
                device,
                swapchain_count,
                p_create_infos,
                p_allocator,
                p_swapchains,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_incompatible_display_khr => return error.IncompatibleDisplayKHR,
                .error_device_lost => return error.DeviceLost,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub fn createSwapchainKHR(
            self: Self,
            device: Device,
            create_info: SwapchainCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            SurfaceLostKHR,
            NativeWindowInUseKHR,
            InitializationFailed,
            Unknown,
        }!SwapchainKHR {
            var swapchain: SwapchainKHR = undefined;
            const result = self.vkCreateSwapchainKHR(
                device,
                &create_info,
                p_allocator,
                &swapchain,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                .error_native_window_in_use_khr => return error.NativeWindowInUseKHR,
                .error_initialization_failed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return swapchain;
        }
        pub fn destroySwapchainKHR(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroySwapchainKHR(
                device,
                swapchain,
                p_allocator,
            );
        }
        pub fn getSwapchainImagesKHR(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            p_swapchain_image_count: *u32,
            p_swapchain_images: ?[*]Image,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetSwapchainImagesKHR(
                device,
                swapchain,
                p_swapchain_image_count,
                p_swapchain_images,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const AcquireNextImageKHRResult = struct {
            result: Result,
            imageIndex: u32,
        };
        pub fn acquireNextImageKHR(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            timeout: u64,
            semaphore: Semaphore,
            fence: Fence,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            FullScreenExclusiveModeLostEXT,
            Unknown,
        }!AcquireNextImageKHRResult {
            var return_values: AcquireNextImageKHRResult = undefined;
            const result = self.vkAcquireNextImageKHR(
                device,
                swapchain,
                timeout,
                semaphore,
                fence,
                &return_values.imageIndex,
            );
            switch (result) {
                .success => {},
                .timeout => {},
                .not_ready => {},
                .suboptimal_khr => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                .error_out_of_date_khr => return error.OutOfDateKHR,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                .error_full_screen_exclusive_mode_lost_ext => return error.FullScreenExclusiveModeLostEXT,
                else => return error.Unknown,
            }
            return_values.result = result;
            return return_values;
        }
        pub fn queuePresentKHR(
            self: Self,
            queue: Queue,
            present_info: PresentInfoKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            FullScreenExclusiveModeLostEXT,
            Unknown,
        }!Result {
            const result = self.vkQueuePresentKHR(
                queue,
                &present_info,
            );
            switch (result) {
                .success => {},
                .suboptimal_khr => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                .error_out_of_date_khr => return error.OutOfDateKHR,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                .error_full_screen_exclusive_mode_lost_ext => return error.FullScreenExclusiveModeLostEXT,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn debugMarkerSetObjectNameEXT(
            self: Self,
            device: Device,
            name_info: DebugMarkerObjectNameInfoEXT,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkDebugMarkerSetObjectNameEXT(
                device,
                &name_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn debugMarkerSetObjectTagEXT(
            self: Self,
            device: Device,
            tag_info: DebugMarkerObjectTagInfoEXT,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkDebugMarkerSetObjectTagEXT(
                device,
                &tag_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdDebugMarkerBeginEXT(
            self: Self,
            command_buffer: CommandBuffer,
            marker_info: DebugMarkerMarkerInfoEXT,
        ) void {
            self.vkCmdDebugMarkerBeginEXT(
                command_buffer,
                &marker_info,
            );
        }
        pub fn cmdDebugMarkerEndEXT(
            self: Self,
            command_buffer: CommandBuffer,
        ) void {
            self.vkCmdDebugMarkerEndEXT(
                command_buffer,
            );
        }
        pub fn cmdDebugMarkerInsertEXT(
            self: Self,
            command_buffer: CommandBuffer,
            marker_info: DebugMarkerMarkerInfoEXT,
        ) void {
            self.vkCmdDebugMarkerInsertEXT(
                command_buffer,
                &marker_info,
            );
        }
        pub fn getMemoryWin32HandleNV(
            self: Self,
            device: Device,
            memory: DeviceMemory,
            handle_type: ExternalMemoryHandleTypeFlagsNV,
            p_handle: *HANDLE,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkGetMemoryWin32HandleNV(
                device,
                memory,
                handle_type.toInt(),
                p_handle,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdExecuteGeneratedCommandsNV(
            self: Self,
            command_buffer: CommandBuffer,
            is_preprocessed: Bool32,
            generated_commands_info: GeneratedCommandsInfoNV,
        ) void {
            self.vkCmdExecuteGeneratedCommandsNV(
                command_buffer,
                is_preprocessed,
                &generated_commands_info,
            );
        }
        pub fn cmdPreprocessGeneratedCommandsNV(
            self: Self,
            command_buffer: CommandBuffer,
            generated_commands_info: GeneratedCommandsInfoNV,
        ) void {
            self.vkCmdPreprocessGeneratedCommandsNV(
                command_buffer,
                &generated_commands_info,
            );
        }
        pub fn cmdBindPipelineShaderGroupNV(
            self: Self,
            command_buffer: CommandBuffer,
            pipeline_bind_point: PipelineBindPoint,
            pipeline: Pipeline,
            group_index: u32,
        ) void {
            self.vkCmdBindPipelineShaderGroupNV(
                command_buffer,
                pipeline_bind_point,
                pipeline,
                group_index,
            );
        }
        pub fn getGeneratedCommandsMemoryRequirementsNV(
            self: Self,
            device: Device,
            info: GeneratedCommandsMemoryRequirementsInfoNV,
            p_memory_requirements: *MemoryRequirements2,
        ) void {
            self.vkGetGeneratedCommandsMemoryRequirementsNV(
                device,
                &info,
                p_memory_requirements,
            );
        }
        pub fn createIndirectCommandsLayoutNV(
            self: Self,
            device: Device,
            create_info: IndirectCommandsLayoutCreateInfoNV,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!IndirectCommandsLayoutNV {
            var indirect_commands_layout: IndirectCommandsLayoutNV = undefined;
            const result = self.vkCreateIndirectCommandsLayoutNV(
                device,
                &create_info,
                p_allocator,
                &indirect_commands_layout,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return indirect_commands_layout;
        }
        pub fn destroyIndirectCommandsLayoutNV(
            self: Self,
            device: Device,
            indirect_commands_layout: IndirectCommandsLayoutNV,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyIndirectCommandsLayoutNV(
                device,
                indirect_commands_layout,
                p_allocator,
            );
        }
        pub fn cmdPushDescriptorSetKHR(
            self: Self,
            command_buffer: CommandBuffer,
            pipeline_bind_point: PipelineBindPoint,
            layout: PipelineLayout,
            set: u32,
            descriptor_write_count: u32,
            p_descriptor_writes: [*]const WriteDescriptorSet,
        ) void {
            self.vkCmdPushDescriptorSetKHR(
                command_buffer,
                pipeline_bind_point,
                layout,
                set,
                descriptor_write_count,
                p_descriptor_writes,
            );
        }
        pub fn trimCommandPool(
            self: Self,
            device: Device,
            command_pool: CommandPool,
            flags: CommandPoolTrimFlags,
        ) void {
            self.vkTrimCommandPool(
                device,
                command_pool,
                flags.toInt(),
            );
        }
        pub fn getMemoryWin32HandleKHR(
            self: Self,
            device: Device,
            get_win_32_handle_info: MemoryGetWin32HandleInfoKHR,
            p_handle: *HANDLE,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkGetMemoryWin32HandleKHR(
                device,
                &get_win_32_handle_info,
                p_handle,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn getMemoryWin32HandlePropertiesKHR(
            self: Self,
            device: Device,
            handle_type: ExternalMemoryHandleTypeFlags,
            handle: HANDLE,
            p_memory_win_32_handle_properties: *MemoryWin32HandlePropertiesKHR,
        ) error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        }!void {
            const result = self.vkGetMemoryWin32HandlePropertiesKHR(
                device,
                handle_type.toInt(),
                handle,
                p_memory_win_32_handle_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_invalid_external_handle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub fn getMemoryFdKHR(
            self: Self,
            device: Device,
            get_fd_info: MemoryGetFdInfoKHR,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!c_int {
            var fd: c_int = undefined;
            const result = self.vkGetMemoryFdKHR(
                device,
                &get_fd_info,
                &fd,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fd;
        }
        pub fn getMemoryFdPropertiesKHR(
            self: Self,
            device: Device,
            handle_type: ExternalMemoryHandleTypeFlags,
            fd: c_int,
            p_memory_fd_properties: *MemoryFdPropertiesKHR,
        ) error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        }!void {
            const result = self.vkGetMemoryFdPropertiesKHR(
                device,
                handle_type.toInt(),
                fd,
                p_memory_fd_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_invalid_external_handle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub fn getSemaphoreWin32HandleKHR(
            self: Self,
            device: Device,
            get_win_32_handle_info: SemaphoreGetWin32HandleInfoKHR,
            p_handle: *HANDLE,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkGetSemaphoreWin32HandleKHR(
                device,
                &get_win_32_handle_info,
                p_handle,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn importSemaphoreWin32HandleKHR(
            self: Self,
            device: Device,
            import_semaphore_win_32_handle_info: ImportSemaphoreWin32HandleInfoKHR,
        ) error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        }!void {
            const result = self.vkImportSemaphoreWin32HandleKHR(
                device,
                &import_semaphore_win_32_handle_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_invalid_external_handle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub fn getSemaphoreFdKHR(
            self: Self,
            device: Device,
            get_fd_info: SemaphoreGetFdInfoKHR,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!c_int {
            var fd: c_int = undefined;
            const result = self.vkGetSemaphoreFdKHR(
                device,
                &get_fd_info,
                &fd,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fd;
        }
        pub fn importSemaphoreFdKHR(
            self: Self,
            device: Device,
            import_semaphore_fd_info: ImportSemaphoreFdInfoKHR,
        ) error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        }!void {
            const result = self.vkImportSemaphoreFdKHR(
                device,
                &import_semaphore_fd_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_invalid_external_handle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub fn getFenceWin32HandleKHR(
            self: Self,
            device: Device,
            get_win_32_handle_info: FenceGetWin32HandleInfoKHR,
            p_handle: *HANDLE,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkGetFenceWin32HandleKHR(
                device,
                &get_win_32_handle_info,
                p_handle,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn importFenceWin32HandleKHR(
            self: Self,
            device: Device,
            import_fence_win_32_handle_info: ImportFenceWin32HandleInfoKHR,
        ) error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        }!void {
            const result = self.vkImportFenceWin32HandleKHR(
                device,
                &import_fence_win_32_handle_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_invalid_external_handle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub fn getFenceFdKHR(
            self: Self,
            device: Device,
            get_fd_info: FenceGetFdInfoKHR,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!c_int {
            var fd: c_int = undefined;
            const result = self.vkGetFenceFdKHR(
                device,
                &get_fd_info,
                &fd,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fd;
        }
        pub fn importFenceFdKHR(
            self: Self,
            device: Device,
            import_fence_fd_info: ImportFenceFdInfoKHR,
        ) error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        }!void {
            const result = self.vkImportFenceFdKHR(
                device,
                &import_fence_fd_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_invalid_external_handle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub fn displayPowerControlEXT(
            self: Self,
            device: Device,
            display: DisplayKHR,
            display_power_info: DisplayPowerInfoEXT,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkDisplayPowerControlEXT(
                device,
                display,
                &display_power_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn registerDeviceEventEXT(
            self: Self,
            device: Device,
            device_event_info: DeviceEventInfoEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!Fence {
            var fence: Fence = undefined;
            const result = self.vkRegisterDeviceEventEXT(
                device,
                &device_event_info,
                p_allocator,
                &fence,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fence;
        }
        pub fn registerDisplayEventEXT(
            self: Self,
            device: Device,
            display: DisplayKHR,
            display_event_info: DisplayEventInfoEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!Fence {
            var fence: Fence = undefined;
            const result = self.vkRegisterDisplayEventEXT(
                device,
                display,
                &display_event_info,
                p_allocator,
                &fence,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fence;
        }
        pub fn getSwapchainCounterEXT(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            counter: SurfaceCounterFlagsEXT,
        ) error{
            OutOfHostMemory,
            DeviceLost,
            OutOfDateKHR,
            Unknown,
        }!u64 {
            var counter_value: u64 = undefined;
            const result = self.vkGetSwapchainCounterEXT(
                device,
                swapchain,
                counter.toInt(),
                &counter_value,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_device_lost => return error.DeviceLost,
                .error_out_of_date_khr => return error.OutOfDateKHR,
                else => return error.Unknown,
            }
            return counter_value;
        }
        pub fn getDeviceGroupPeerMemoryFeatures(
            self: Self,
            device: Device,
            heap_index: u32,
            local_device_index: u32,
            remote_device_index: u32,
        ) PeerMemoryFeatureFlags {
            var peer_memory_features: PeerMemoryFeatureFlags = undefined;
            self.vkGetDeviceGroupPeerMemoryFeatures(
                device,
                heap_index,
                local_device_index,
                remote_device_index,
                &peer_memory_features,
            );
            return peer_memory_features;
        }
        pub fn bindBufferMemory2(
            self: Self,
            device: Device,
            bind_info_count: u32,
            p_bind_infos: [*]const BindBufferMemoryInfo,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidOpaqueCaptureAddress,
            Unknown,
        }!void {
            const result = self.vkBindBufferMemory2(
                device,
                bind_info_count,
                p_bind_infos,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_invalid_opaque_capture_address => return error.InvalidOpaqueCaptureAddress,
                else => return error.Unknown,
            }
        }
        pub fn bindImageMemory2(
            self: Self,
            device: Device,
            bind_info_count: u32,
            p_bind_infos: [*]const BindImageMemoryInfo,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkBindImageMemory2(
                device,
                bind_info_count,
                p_bind_infos,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdSetDeviceMask(
            self: Self,
            command_buffer: CommandBuffer,
            device_mask: u32,
        ) void {
            self.vkCmdSetDeviceMask(
                command_buffer,
                device_mask,
            );
        }
        pub fn getDeviceGroupPresentCapabilitiesKHR(
            self: Self,
            device: Device,
            p_device_group_present_capabilities: *DeviceGroupPresentCapabilitiesKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkGetDeviceGroupPresentCapabilitiesKHR(
                device,
                p_device_group_present_capabilities,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getDeviceGroupSurfacePresentModesKHR(
            self: Self,
            device: Device,
            surface: SurfaceKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!DeviceGroupPresentModeFlagsKHR {
            var modes: DeviceGroupPresentModeFlagsKHR = undefined;
            const result = self.vkGetDeviceGroupSurfacePresentModesKHR(
                device,
                surface,
                &modes,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return modes;
        }
        pub const AcquireNextImage2KHRResult = struct {
            result: Result,
            imageIndex: u32,
        };
        pub fn acquireNextImage2KHR(
            self: Self,
            device: Device,
            acquire_info: AcquireNextImageInfoKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            FullScreenExclusiveModeLostEXT,
            Unknown,
        }!AcquireNextImage2KHRResult {
            var return_values: AcquireNextImage2KHRResult = undefined;
            const result = self.vkAcquireNextImage2KHR(
                device,
                &acquire_info,
                &return_values.imageIndex,
            );
            switch (result) {
                .success => {},
                .timeout => {},
                .not_ready => {},
                .suboptimal_khr => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                .error_out_of_date_khr => return error.OutOfDateKHR,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                .error_full_screen_exclusive_mode_lost_ext => return error.FullScreenExclusiveModeLostEXT,
                else => return error.Unknown,
            }
            return_values.result = result;
            return return_values;
        }
        pub fn cmdDispatchBase(
            self: Self,
            command_buffer: CommandBuffer,
            base_group_x: u32,
            base_group_y: u32,
            base_group_z: u32,
            group_count_x: u32,
            group_count_y: u32,
            group_count_z: u32,
        ) void {
            self.vkCmdDispatchBase(
                command_buffer,
                base_group_x,
                base_group_y,
                base_group_z,
                group_count_x,
                group_count_y,
                group_count_z,
            );
        }
        pub fn createDescriptorUpdateTemplate(
            self: Self,
            device: Device,
            create_info: DescriptorUpdateTemplateCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!DescriptorUpdateTemplate {
            var descriptor_update_template: DescriptorUpdateTemplate = undefined;
            const result = self.vkCreateDescriptorUpdateTemplate(
                device,
                &create_info,
                p_allocator,
                &descriptor_update_template,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return descriptor_update_template;
        }
        pub fn destroyDescriptorUpdateTemplate(
            self: Self,
            device: Device,
            descriptor_update_template: DescriptorUpdateTemplate,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyDescriptorUpdateTemplate(
                device,
                descriptor_update_template,
                p_allocator,
            );
        }
        pub fn updateDescriptorSetWithTemplate(
            self: Self,
            device: Device,
            descriptor_set: DescriptorSet,
            descriptor_update_template: DescriptorUpdateTemplate,
            p_data: *const c_void,
        ) void {
            self.vkUpdateDescriptorSetWithTemplate(
                device,
                descriptor_set,
                descriptor_update_template,
                p_data,
            );
        }
        pub fn cmdPushDescriptorSetWithTemplateKHR(
            self: Self,
            command_buffer: CommandBuffer,
            descriptor_update_template: DescriptorUpdateTemplate,
            layout: PipelineLayout,
            set: u32,
            p_data: *const c_void,
        ) void {
            self.vkCmdPushDescriptorSetWithTemplateKHR(
                command_buffer,
                descriptor_update_template,
                layout,
                set,
                p_data,
            );
        }
        pub fn setHdrMetadataEXT(
            self: Self,
            device: Device,
            swapchain_count: u32,
            p_swapchains: [*]const SwapchainKHR,
            p_metadata: [*]const HdrMetadataEXT,
        ) void {
            self.vkSetHdrMetadataEXT(
                device,
                swapchain_count,
                p_swapchains,
                p_metadata,
            );
        }
        pub fn getSwapchainStatusKHR(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            FullScreenExclusiveModeLostEXT,
            Unknown,
        }!Result {
            const result = self.vkGetSwapchainStatusKHR(
                device,
                swapchain,
            );
            switch (result) {
                .success => {},
                .suboptimal_khr => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                .error_out_of_date_khr => return error.OutOfDateKHR,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                .error_full_screen_exclusive_mode_lost_ext => return error.FullScreenExclusiveModeLostEXT,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getRefreshCycleDurationGOOGLE(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
        ) error{
            OutOfHostMemory,
            DeviceLost,
            SurfaceLostKHR,
            Unknown,
        }!RefreshCycleDurationGOOGLE {
            var display_timing_properties: RefreshCycleDurationGOOGLE = undefined;
            const result = self.vkGetRefreshCycleDurationGOOGLE(
                device,
                swapchain,
                &display_timing_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_device_lost => return error.DeviceLost,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return display_timing_properties;
        }
        pub fn getPastPresentationTimingGOOGLE(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            p_presentation_timing_count: *u32,
            p_presentation_timings: ?[*]PastPresentationTimingGOOGLE,
        ) error{
            OutOfHostMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            Unknown,
        }!Result {
            const result = self.vkGetPastPresentationTimingGOOGLE(
                device,
                swapchain,
                p_presentation_timing_count,
                p_presentation_timings,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_device_lost => return error.DeviceLost,
                .error_out_of_date_khr => return error.OutOfDateKHR,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdSetViewportWScalingNV(
            self: Self,
            command_buffer: CommandBuffer,
            first_viewport: u32,
            viewport_count: u32,
            p_viewport_w_scalings: [*]const ViewportWScalingNV,
        ) void {
            self.vkCmdSetViewportWScalingNV(
                command_buffer,
                first_viewport,
                viewport_count,
                p_viewport_w_scalings,
            );
        }
        pub fn cmdSetDiscardRectangleEXT(
            self: Self,
            command_buffer: CommandBuffer,
            first_discard_rectangle: u32,
            discard_rectangle_count: u32,
            p_discard_rectangles: [*]const Rect2D,
        ) void {
            self.vkCmdSetDiscardRectangleEXT(
                command_buffer,
                first_discard_rectangle,
                discard_rectangle_count,
                p_discard_rectangles,
            );
        }
        pub fn cmdSetSampleLocationsEXT(
            self: Self,
            command_buffer: CommandBuffer,
            sample_locations_info: SampleLocationsInfoEXT,
        ) void {
            self.vkCmdSetSampleLocationsEXT(
                command_buffer,
                &sample_locations_info,
            );
        }
        pub fn getBufferMemoryRequirements2(
            self: Self,
            device: Device,
            info: BufferMemoryRequirementsInfo2,
            p_memory_requirements: *MemoryRequirements2,
        ) void {
            self.vkGetBufferMemoryRequirements2(
                device,
                &info,
                p_memory_requirements,
            );
        }
        pub fn getImageMemoryRequirements2(
            self: Self,
            device: Device,
            info: ImageMemoryRequirementsInfo2,
            p_memory_requirements: *MemoryRequirements2,
        ) void {
            self.vkGetImageMemoryRequirements2(
                device,
                &info,
                p_memory_requirements,
            );
        }
        pub fn getImageSparseMemoryRequirements2(
            self: Self,
            device: Device,
            info: ImageSparseMemoryRequirementsInfo2,
            p_sparse_memory_requirement_count: *u32,
            p_sparse_memory_requirements: ?[*]SparseImageMemoryRequirements2,
        ) void {
            self.vkGetImageSparseMemoryRequirements2(
                device,
                &info,
                p_sparse_memory_requirement_count,
                p_sparse_memory_requirements,
            );
        }
        pub fn createSamplerYcbcrConversion(
            self: Self,
            device: Device,
            create_info: SamplerYcbcrConversionCreateInfo,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!SamplerYcbcrConversion {
            var ycbcr_conversion: SamplerYcbcrConversion = undefined;
            const result = self.vkCreateSamplerYcbcrConversion(
                device,
                &create_info,
                p_allocator,
                &ycbcr_conversion,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return ycbcr_conversion;
        }
        pub fn destroySamplerYcbcrConversion(
            self: Self,
            device: Device,
            ycbcr_conversion: SamplerYcbcrConversion,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroySamplerYcbcrConversion(
                device,
                ycbcr_conversion,
                p_allocator,
            );
        }
        pub fn getDeviceQueue2(
            self: Self,
            device: Device,
            queue_info: DeviceQueueInfo2,
        ) Queue {
            var queue: Queue = undefined;
            self.vkGetDeviceQueue2(
                device,
                &queue_info,
                &queue,
            );
            return queue;
        }
        pub fn createValidationCacheEXT(
            self: Self,
            device: Device,
            create_info: ValidationCacheCreateInfoEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!ValidationCacheEXT {
            var validation_cache: ValidationCacheEXT = undefined;
            const result = self.vkCreateValidationCacheEXT(
                device,
                &create_info,
                p_allocator,
                &validation_cache,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return validation_cache;
        }
        pub fn destroyValidationCacheEXT(
            self: Self,
            device: Device,
            validation_cache: ValidationCacheEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyValidationCacheEXT(
                device,
                validation_cache,
                p_allocator,
            );
        }
        pub fn getValidationCacheDataEXT(
            self: Self,
            device: Device,
            validation_cache: ValidationCacheEXT,
            p_data_size: *usize,
            p_data: ?*c_void,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetValidationCacheDataEXT(
                device,
                validation_cache,
                p_data_size,
                p_data,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn mergeValidationCachesEXT(
            self: Self,
            device: Device,
            dst_cache: ValidationCacheEXT,
            src_cache_count: u32,
            p_src_caches: [*]const ValidationCacheEXT,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkMergeValidationCachesEXT(
                device,
                dst_cache,
                src_cache_count,
                p_src_caches,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getDescriptorSetLayoutSupport(
            self: Self,
            device: Device,
            create_info: DescriptorSetLayoutCreateInfo,
            p_support: *DescriptorSetLayoutSupport,
        ) void {
            self.vkGetDescriptorSetLayoutSupport(
                device,
                &create_info,
                p_support,
            );
        }
        pub fn getSwapchainGrallocUsageANDROID(
            self: Self,
            device: Device,
            format: Format,
            image_usage: ImageUsageFlags,
        ) error{Unknown}!c_int {
            var gralloc_usage: c_int = undefined;
            const result = self.vkGetSwapchainGrallocUsageANDROID(
                device,
                format,
                image_usage.toInt(),
                &gralloc_usage,
            );
            switch (result) {
                else => return error.Unknown,
            }
            return gralloc_usage;
        }
        pub const GetSwapchainGrallocUsage2ANDROIDResult = struct {
            gralloc_consumer_usage: u64,
            gralloc_producer_usage: u64,
        };
        pub fn getSwapchainGrallocUsage2ANDROID(
            self: Self,
            device: Device,
            format: Format,
            image_usage: ImageUsageFlags,
            swapchain_image_usage: SwapchainImageUsageFlagsANDROID,
        ) error{Unknown}!GetSwapchainGrallocUsage2ANDROIDResult {
            var return_values: GetSwapchainGrallocUsage2ANDROIDResult = undefined;
            const result = self.vkGetSwapchainGrallocUsage2ANDROID(
                device,
                format,
                image_usage.toInt(),
                swapchain_image_usage.toInt(),
                &return_values.gralloc_consumer_usage,
                &return_values.gralloc_producer_usage,
            );
            switch (result) {
                else => return error.Unknown,
            }
            return return_values;
        }
        pub fn acquireImageANDROID(
            self: Self,
            device: Device,
            image: Image,
            native_fence_fd: c_int,
            semaphore: Semaphore,
            fence: Fence,
        ) error{Unknown}!void {
            const result = self.vkAcquireImageANDROID(
                device,
                image,
                native_fence_fd,
                semaphore,
                fence,
            );
            switch (result) {
                else => return error.Unknown,
            }
        }
        pub fn queueSignalReleaseImageANDROID(
            self: Self,
            queue: Queue,
            wait_semaphore_count: u32,
            p_wait_semaphores: [*]const Semaphore,
            image: Image,
        ) error{Unknown}!c_int {
            var native_fence_fd: c_int = undefined;
            const result = self.vkQueueSignalReleaseImageANDROID(
                queue,
                wait_semaphore_count,
                p_wait_semaphores,
                image,
                &native_fence_fd,
            );
            switch (result) {
                else => return error.Unknown,
            }
            return native_fence_fd;
        }
        pub fn getShaderInfoAMD(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            shader_stage: ShaderStageFlags,
            info_type: ShaderInfoTypeAMD,
            p_info_size: *usize,
            p_info: ?*c_void,
        ) error{
            FeatureNotPresent,
            OutOfHostMemory,
            Unknown,
        }!Result {
            const result = self.vkGetShaderInfoAMD(
                device,
                pipeline,
                shader_stage.toInt(),
                info_type,
                p_info_size,
                p_info,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_feature_not_present => return error.FeatureNotPresent,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn setLocalDimmingAMD(
            self: Self,
            device: Device,
            swap_chain: SwapchainKHR,
            local_dimming_enable: Bool32,
        ) void {
            self.vkSetLocalDimmingAMD(
                device,
                swap_chain,
                local_dimming_enable,
            );
        }
        pub fn getCalibratedTimestampsEXT(
            self: Self,
            device: Device,
            timestamp_count: u32,
            p_timestamp_infos: [*]const CalibratedTimestampInfoEXT,
            p_timestamps: [*]u64,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!u64 {
            var max_deviation: u64 = undefined;
            const result = self.vkGetCalibratedTimestampsEXT(
                device,
                timestamp_count,
                p_timestamp_infos,
                p_timestamps,
                &max_deviation,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return max_deviation;
        }
        pub fn setDebugUtilsObjectNameEXT(
            self: Self,
            device: Device,
            name_info: DebugUtilsObjectNameInfoEXT,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkSetDebugUtilsObjectNameEXT(
                device,
                &name_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn setDebugUtilsObjectTagEXT(
            self: Self,
            device: Device,
            tag_info: DebugUtilsObjectTagInfoEXT,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkSetDebugUtilsObjectTagEXT(
                device,
                &tag_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn queueBeginDebugUtilsLabelEXT(
            self: Self,
            queue: Queue,
            label_info: DebugUtilsLabelEXT,
        ) void {
            self.vkQueueBeginDebugUtilsLabelEXT(
                queue,
                &label_info,
            );
        }
        pub fn queueEndDebugUtilsLabelEXT(
            self: Self,
            queue: Queue,
        ) void {
            self.vkQueueEndDebugUtilsLabelEXT(
                queue,
            );
        }
        pub fn queueInsertDebugUtilsLabelEXT(
            self: Self,
            queue: Queue,
            label_info: DebugUtilsLabelEXT,
        ) void {
            self.vkQueueInsertDebugUtilsLabelEXT(
                queue,
                &label_info,
            );
        }
        pub fn cmdBeginDebugUtilsLabelEXT(
            self: Self,
            command_buffer: CommandBuffer,
            label_info: DebugUtilsLabelEXT,
        ) void {
            self.vkCmdBeginDebugUtilsLabelEXT(
                command_buffer,
                &label_info,
            );
        }
        pub fn cmdEndDebugUtilsLabelEXT(
            self: Self,
            command_buffer: CommandBuffer,
        ) void {
            self.vkCmdEndDebugUtilsLabelEXT(
                command_buffer,
            );
        }
        pub fn cmdInsertDebugUtilsLabelEXT(
            self: Self,
            command_buffer: CommandBuffer,
            label_info: DebugUtilsLabelEXT,
        ) void {
            self.vkCmdInsertDebugUtilsLabelEXT(
                command_buffer,
                &label_info,
            );
        }
        pub fn getMemoryHostPointerPropertiesEXT(
            self: Self,
            device: Device,
            handle_type: ExternalMemoryHandleTypeFlags,
            p_host_pointer: *const c_void,
            p_memory_host_pointer_properties: *MemoryHostPointerPropertiesEXT,
        ) error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        }!void {
            const result = self.vkGetMemoryHostPointerPropertiesEXT(
                device,
                handle_type.toInt(),
                p_host_pointer,
                p_memory_host_pointer_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_invalid_external_handle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub fn cmdWriteBufferMarkerAMD(
            self: Self,
            command_buffer: CommandBuffer,
            pipeline_stage: PipelineStageFlags,
            dst_buffer: Buffer,
            dst_offset: DeviceSize,
            marker: u32,
        ) void {
            self.vkCmdWriteBufferMarkerAMD(
                command_buffer,
                pipeline_stage.toInt(),
                dst_buffer,
                dst_offset,
                marker,
            );
        }
        pub fn createRenderPass2(
            self: Self,
            device: Device,
            create_info: RenderPassCreateInfo2,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!RenderPass {
            var render_pass: RenderPass = undefined;
            const result = self.vkCreateRenderPass2(
                device,
                &create_info,
                p_allocator,
                &render_pass,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return render_pass;
        }
        pub fn cmdBeginRenderPass2(
            self: Self,
            command_buffer: CommandBuffer,
            render_pass_begin: RenderPassBeginInfo,
            subpass_begin_info: SubpassBeginInfo,
        ) void {
            self.vkCmdBeginRenderPass2(
                command_buffer,
                &render_pass_begin,
                &subpass_begin_info,
            );
        }
        pub fn cmdNextSubpass2(
            self: Self,
            command_buffer: CommandBuffer,
            subpass_begin_info: SubpassBeginInfo,
            subpass_end_info: SubpassEndInfo,
        ) void {
            self.vkCmdNextSubpass2(
                command_buffer,
                &subpass_begin_info,
                &subpass_end_info,
            );
        }
        pub fn cmdEndRenderPass2(
            self: Self,
            command_buffer: CommandBuffer,
            subpass_end_info: SubpassEndInfo,
        ) void {
            self.vkCmdEndRenderPass2(
                command_buffer,
                &subpass_end_info,
            );
        }
        pub fn getSemaphoreCounterValue(
            self: Self,
            device: Device,
            semaphore: Semaphore,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!u64 {
            var value: u64 = undefined;
            const result = self.vkGetSemaphoreCounterValue(
                device,
                semaphore,
                &value,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return value;
        }
        pub fn waitSemaphores(
            self: Self,
            device: Device,
            wait_info: SemaphoreWaitInfo,
            timeout: u64,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        }!Result {
            const result = self.vkWaitSemaphores(
                device,
                &wait_info,
                timeout,
            );
            switch (result) {
                .success => {},
                .timeout => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_device_lost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn signalSemaphore(
            self: Self,
            device: Device,
            signal_info: SemaphoreSignalInfo,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkSignalSemaphore(
                device,
                &signal_info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getAndroidHardwareBufferPropertiesANDROID(
            self: Self,
            device: Device,
            buffer: *const AHardwareBuffer,
            p_properties: *AndroidHardwareBufferPropertiesANDROID,
        ) error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        }!void {
            const result = self.vkGetAndroidHardwareBufferPropertiesANDROID(
                device,
                buffer,
                p_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_invalid_external_handle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub fn getMemoryAndroidHardwareBufferANDROID(
            self: Self,
            device: Device,
            info: MemoryGetAndroidHardwareBufferInfoANDROID,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!*AHardwareBuffer {
            var buffer: *AHardwareBuffer = undefined;
            const result = self.vkGetMemoryAndroidHardwareBufferANDROID(
                device,
                &info,
                &buffer,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return buffer;
        }
        pub fn cmdDrawIndirectCount(
            self: Self,
            command_buffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            count_buffer: Buffer,
            count_buffer_offset: DeviceSize,
            max_draw_count: u32,
            stride: u32,
        ) void {
            self.vkCmdDrawIndirectCount(
                command_buffer,
                buffer,
                offset,
                count_buffer,
                count_buffer_offset,
                max_draw_count,
                stride,
            );
        }
        pub fn cmdDrawIndexedIndirectCount(
            self: Self,
            command_buffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            count_buffer: Buffer,
            count_buffer_offset: DeviceSize,
            max_draw_count: u32,
            stride: u32,
        ) void {
            self.vkCmdDrawIndexedIndirectCount(
                command_buffer,
                buffer,
                offset,
                count_buffer,
                count_buffer_offset,
                max_draw_count,
                stride,
            );
        }
        pub fn cmdSetCheckpointNV(
            self: Self,
            command_buffer: CommandBuffer,
            p_checkpoint_marker: *const c_void,
        ) void {
            self.vkCmdSetCheckpointNV(
                command_buffer,
                p_checkpoint_marker,
            );
        }
        pub fn getQueueCheckpointDataNV(
            self: Self,
            queue: Queue,
            p_checkpoint_data_count: *u32,
            p_checkpoint_data: ?[*]CheckpointDataNV,
        ) void {
            self.vkGetQueueCheckpointDataNV(
                queue,
                p_checkpoint_data_count,
                p_checkpoint_data,
            );
        }
        pub fn cmdBindTransformFeedbackBuffersEXT(
            self: Self,
            command_buffer: CommandBuffer,
            first_binding: u32,
            binding_count: u32,
            p_buffers: [*]const Buffer,
            p_offsets: [*]const DeviceSize,
            p_sizes: ?[*]const DeviceSize,
        ) void {
            self.vkCmdBindTransformFeedbackBuffersEXT(
                command_buffer,
                first_binding,
                binding_count,
                p_buffers,
                p_offsets,
                p_sizes,
            );
        }
        pub fn cmdBeginTransformFeedbackEXT(
            self: Self,
            command_buffer: CommandBuffer,
            first_counter_buffer: u32,
            counter_buffer_count: u32,
            p_counter_buffers: [*]const Buffer,
            p_counter_buffer_offsets: ?[*]const DeviceSize,
        ) void {
            self.vkCmdBeginTransformFeedbackEXT(
                command_buffer,
                first_counter_buffer,
                counter_buffer_count,
                p_counter_buffers,
                p_counter_buffer_offsets,
            );
        }
        pub fn cmdEndTransformFeedbackEXT(
            self: Self,
            command_buffer: CommandBuffer,
            first_counter_buffer: u32,
            counter_buffer_count: u32,
            p_counter_buffers: [*]const Buffer,
            p_counter_buffer_offsets: ?[*]const DeviceSize,
        ) void {
            self.vkCmdEndTransformFeedbackEXT(
                command_buffer,
                first_counter_buffer,
                counter_buffer_count,
                p_counter_buffers,
                p_counter_buffer_offsets,
            );
        }
        pub fn cmdBeginQueryIndexedEXT(
            self: Self,
            command_buffer: CommandBuffer,
            query_pool: QueryPool,
            query: u32,
            flags: QueryControlFlags,
            index: u32,
        ) void {
            self.vkCmdBeginQueryIndexedEXT(
                command_buffer,
                query_pool,
                query,
                flags.toInt(),
                index,
            );
        }
        pub fn cmdEndQueryIndexedEXT(
            self: Self,
            command_buffer: CommandBuffer,
            query_pool: QueryPool,
            query: u32,
            index: u32,
        ) void {
            self.vkCmdEndQueryIndexedEXT(
                command_buffer,
                query_pool,
                query,
                index,
            );
        }
        pub fn cmdDrawIndirectByteCountEXT(
            self: Self,
            command_buffer: CommandBuffer,
            instance_count: u32,
            first_instance: u32,
            counter_buffer: Buffer,
            counter_buffer_offset: DeviceSize,
            counter_offset: u32,
            vertex_stride: u32,
        ) void {
            self.vkCmdDrawIndirectByteCountEXT(
                command_buffer,
                instance_count,
                first_instance,
                counter_buffer,
                counter_buffer_offset,
                counter_offset,
                vertex_stride,
            );
        }
        pub fn cmdSetExclusiveScissorNV(
            self: Self,
            command_buffer: CommandBuffer,
            first_exclusive_scissor: u32,
            exclusive_scissor_count: u32,
            p_exclusive_scissors: [*]const Rect2D,
        ) void {
            self.vkCmdSetExclusiveScissorNV(
                command_buffer,
                first_exclusive_scissor,
                exclusive_scissor_count,
                p_exclusive_scissors,
            );
        }
        pub fn cmdBindShadingRateImageNV(
            self: Self,
            command_buffer: CommandBuffer,
            image_view: ImageView,
            image_layout: ImageLayout,
        ) void {
            self.vkCmdBindShadingRateImageNV(
                command_buffer,
                image_view,
                image_layout,
            );
        }
        pub fn cmdSetViewportShadingRatePaletteNV(
            self: Self,
            command_buffer: CommandBuffer,
            first_viewport: u32,
            viewport_count: u32,
            p_shading_rate_palettes: [*]const ShadingRatePaletteNV,
        ) void {
            self.vkCmdSetViewportShadingRatePaletteNV(
                command_buffer,
                first_viewport,
                viewport_count,
                p_shading_rate_palettes,
            );
        }
        pub fn cmdSetCoarseSampleOrderNV(
            self: Self,
            command_buffer: CommandBuffer,
            sample_order_type: CoarseSampleOrderTypeNV,
            custom_sample_order_count: u32,
            p_custom_sample_orders: [*]const CoarseSampleOrderCustomNV,
        ) void {
            self.vkCmdSetCoarseSampleOrderNV(
                command_buffer,
                sample_order_type,
                custom_sample_order_count,
                p_custom_sample_orders,
            );
        }
        pub fn cmdDrawMeshTasksNV(
            self: Self,
            command_buffer: CommandBuffer,
            task_count: u32,
            first_task: u32,
        ) void {
            self.vkCmdDrawMeshTasksNV(
                command_buffer,
                task_count,
                first_task,
            );
        }
        pub fn cmdDrawMeshTasksIndirectNV(
            self: Self,
            command_buffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            draw_count: u32,
            stride: u32,
        ) void {
            self.vkCmdDrawMeshTasksIndirectNV(
                command_buffer,
                buffer,
                offset,
                draw_count,
                stride,
            );
        }
        pub fn cmdDrawMeshTasksIndirectCountNV(
            self: Self,
            command_buffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            count_buffer: Buffer,
            count_buffer_offset: DeviceSize,
            max_draw_count: u32,
            stride: u32,
        ) void {
            self.vkCmdDrawMeshTasksIndirectCountNV(
                command_buffer,
                buffer,
                offset,
                count_buffer,
                count_buffer_offset,
                max_draw_count,
                stride,
            );
        }
        pub fn compileDeferredNV(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            shader: u32,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkCompileDeferredNV(
                device,
                pipeline,
                shader,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn createAccelerationStructureNV(
            self: Self,
            device: Device,
            create_info: AccelerationStructureCreateInfoNV,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!AccelerationStructureNV {
            var acceleration_structure: AccelerationStructureNV = undefined;
            const result = self.vkCreateAccelerationStructureNV(
                device,
                &create_info,
                p_allocator,
                &acceleration_structure,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return acceleration_structure;
        }
        pub fn destroyAccelerationStructureKHR(
            self: Self,
            device: Device,
            acceleration_structure: AccelerationStructureKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyAccelerationStructureKHR(
                device,
                acceleration_structure,
                p_allocator,
            );
        }
        pub fn destroyAccelerationStructureNV(
            self: Self,
            device: Device,
            acceleration_structure: AccelerationStructureNV,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyAccelerationStructureNV(
                device,
                acceleration_structure,
                p_allocator,
            );
        }
        pub fn getAccelerationStructureMemoryRequirementsNV(
            self: Self,
            device: Device,
            info: AccelerationStructureMemoryRequirementsInfoNV,
            p_memory_requirements: *MemoryRequirements2KHR,
        ) void {
            self.vkGetAccelerationStructureMemoryRequirementsNV(
                device,
                &info,
                p_memory_requirements,
            );
        }
        pub fn bindAccelerationStructureMemoryNV(
            self: Self,
            device: Device,
            bind_info_count: u32,
            p_bind_infos: [*]const BindAccelerationStructureMemoryInfoNV,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkBindAccelerationStructureMemoryNV(
                device,
                bind_info_count,
                p_bind_infos,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdCopyAccelerationStructureNV(
            self: Self,
            command_buffer: CommandBuffer,
            dst: AccelerationStructureNV,
            src: AccelerationStructureNV,
            mode: CopyAccelerationStructureModeKHR,
        ) void {
            self.vkCmdCopyAccelerationStructureNV(
                command_buffer,
                dst,
                src,
                mode,
            );
        }
        pub fn cmdCopyAccelerationStructureKHR(
            self: Self,
            command_buffer: CommandBuffer,
            info: CopyAccelerationStructureInfoKHR,
        ) void {
            self.vkCmdCopyAccelerationStructureKHR(
                command_buffer,
                &info,
            );
        }
        pub fn copyAccelerationStructureKHR(
            self: Self,
            device: Device,
            deferred_operation: DeferredOperationKHR,
            info: CopyAccelerationStructureInfoKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkCopyAccelerationStructureKHR(
                device,
                deferred_operation,
                &info,
            );
            switch (result) {
                .success => {},
                .operation_deferred_khr => {},
                .operation_not_deferred_khr => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdCopyAccelerationStructureToMemoryKHR(
            self: Self,
            command_buffer: CommandBuffer,
            info: CopyAccelerationStructureToMemoryInfoKHR,
        ) void {
            self.vkCmdCopyAccelerationStructureToMemoryKHR(
                command_buffer,
                &info,
            );
        }
        pub fn copyAccelerationStructureToMemoryKHR(
            self: Self,
            device: Device,
            deferred_operation: DeferredOperationKHR,
            info: CopyAccelerationStructureToMemoryInfoKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkCopyAccelerationStructureToMemoryKHR(
                device,
                deferred_operation,
                &info,
            );
            switch (result) {
                .success => {},
                .operation_deferred_khr => {},
                .operation_not_deferred_khr => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdCopyMemoryToAccelerationStructureKHR(
            self: Self,
            command_buffer: CommandBuffer,
            info: CopyMemoryToAccelerationStructureInfoKHR,
        ) void {
            self.vkCmdCopyMemoryToAccelerationStructureKHR(
                command_buffer,
                &info,
            );
        }
        pub fn copyMemoryToAccelerationStructureKHR(
            self: Self,
            device: Device,
            deferred_operation: DeferredOperationKHR,
            info: CopyMemoryToAccelerationStructureInfoKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkCopyMemoryToAccelerationStructureKHR(
                device,
                deferred_operation,
                &info,
            );
            switch (result) {
                .success => {},
                .operation_deferred_khr => {},
                .operation_not_deferred_khr => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdWriteAccelerationStructuresPropertiesKHR(
            self: Self,
            command_buffer: CommandBuffer,
            acceleration_structure_count: u32,
            p_acceleration_structures: [*]const AccelerationStructureKHR,
            query_type: QueryType,
            query_pool: QueryPool,
            first_query: u32,
        ) void {
            self.vkCmdWriteAccelerationStructuresPropertiesKHR(
                command_buffer,
                acceleration_structure_count,
                p_acceleration_structures,
                query_type,
                query_pool,
                first_query,
            );
        }
        pub fn cmdWriteAccelerationStructuresPropertiesNV(
            self: Self,
            command_buffer: CommandBuffer,
            acceleration_structure_count: u32,
            p_acceleration_structures: [*]const AccelerationStructureNV,
            query_type: QueryType,
            query_pool: QueryPool,
            first_query: u32,
        ) void {
            self.vkCmdWriteAccelerationStructuresPropertiesNV(
                command_buffer,
                acceleration_structure_count,
                p_acceleration_structures,
                query_type,
                query_pool,
                first_query,
            );
        }
        pub fn cmdBuildAccelerationStructureNV(
            self: Self,
            command_buffer: CommandBuffer,
            info: AccelerationStructureInfoNV,
            instance_data: Buffer,
            instance_offset: DeviceSize,
            update: Bool32,
            dst: AccelerationStructureNV,
            src: AccelerationStructureNV,
            scratch: Buffer,
            scratch_offset: DeviceSize,
        ) void {
            self.vkCmdBuildAccelerationStructureNV(
                command_buffer,
                &info,
                instance_data,
                instance_offset,
                update,
                dst,
                src,
                scratch,
                scratch_offset,
            );
        }
        pub fn writeAccelerationStructuresPropertiesKHR(
            self: Self,
            device: Device,
            acceleration_structure_count: u32,
            p_acceleration_structures: [*]const AccelerationStructureKHR,
            query_type: QueryType,
            data_size: usize,
            p_data: *c_void,
            stride: usize,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkWriteAccelerationStructuresPropertiesKHR(
                device,
                acceleration_structure_count,
                p_acceleration_structures,
                query_type,
                data_size,
                p_data,
                stride,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdTraceRaysKHR(
            self: Self,
            command_buffer: CommandBuffer,
            raygen_shader_binding_table: StridedDeviceAddressRegionKHR,
            miss_shader_binding_table: StridedDeviceAddressRegionKHR,
            hit_shader_binding_table: StridedDeviceAddressRegionKHR,
            callable_shader_binding_table: StridedDeviceAddressRegionKHR,
            width: u32,
            height: u32,
            depth: u32,
        ) void {
            self.vkCmdTraceRaysKHR(
                command_buffer,
                &raygen_shader_binding_table,
                &miss_shader_binding_table,
                &hit_shader_binding_table,
                &callable_shader_binding_table,
                width,
                height,
                depth,
            );
        }
        pub fn cmdTraceRaysNV(
            self: Self,
            command_buffer: CommandBuffer,
            raygen_shader_binding_table_buffer: Buffer,
            raygen_shader_binding_offset: DeviceSize,
            miss_shader_binding_table_buffer: Buffer,
            miss_shader_binding_offset: DeviceSize,
            miss_shader_binding_stride: DeviceSize,
            hit_shader_binding_table_buffer: Buffer,
            hit_shader_binding_offset: DeviceSize,
            hit_shader_binding_stride: DeviceSize,
            callable_shader_binding_table_buffer: Buffer,
            callable_shader_binding_offset: DeviceSize,
            callable_shader_binding_stride: DeviceSize,
            width: u32,
            height: u32,
            depth: u32,
        ) void {
            self.vkCmdTraceRaysNV(
                command_buffer,
                raygen_shader_binding_table_buffer,
                raygen_shader_binding_offset,
                miss_shader_binding_table_buffer,
                miss_shader_binding_offset,
                miss_shader_binding_stride,
                hit_shader_binding_table_buffer,
                hit_shader_binding_offset,
                hit_shader_binding_stride,
                callable_shader_binding_table_buffer,
                callable_shader_binding_offset,
                callable_shader_binding_stride,
                width,
                height,
                depth,
            );
        }
        pub fn getRayTracingShaderGroupHandlesKHR(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            first_group: u32,
            group_count: u32,
            data_size: usize,
            p_data: *c_void,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkGetRayTracingShaderGroupHandlesKHR(
                device,
                pipeline,
                first_group,
                group_count,
                data_size,
                p_data,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getRayTracingCaptureReplayShaderGroupHandlesKHR(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            first_group: u32,
            group_count: u32,
            data_size: usize,
            p_data: *c_void,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkGetRayTracingCaptureReplayShaderGroupHandlesKHR(
                device,
                pipeline,
                first_group,
                group_count,
                data_size,
                p_data,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getAccelerationStructureHandleNV(
            self: Self,
            device: Device,
            acceleration_structure: AccelerationStructureNV,
            data_size: usize,
            p_data: *c_void,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!void {
            const result = self.vkGetAccelerationStructureHandleNV(
                device,
                acceleration_structure,
                data_size,
                p_data,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn createRayTracingPipelinesNV(
            self: Self,
            device: Device,
            pipeline_cache: PipelineCache,
            create_info_count: u32,
            p_create_infos: [*]const RayTracingPipelineCreateInfoNV,
            p_allocator: ?*const AllocationCallbacks,
            p_pipelines: [*]Pipeline,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidShaderNV,
            Unknown,
        }!Result {
            const result = self.vkCreateRayTracingPipelinesNV(
                device,
                pipeline_cache,
                create_info_count,
                p_create_infos,
                p_allocator,
                p_pipelines,
            );
            switch (result) {
                .success => {},
                .pipeline_compile_required_ext => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_invalid_shader_nv => return error.InvalidShaderNV,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn createRayTracingPipelinesKHR(
            self: Self,
            device: Device,
            deferred_operation: DeferredOperationKHR,
            pipeline_cache: PipelineCache,
            create_info_count: u32,
            p_create_infos: [*]const RayTracingPipelineCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
            p_pipelines: [*]Pipeline,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidOpaqueCaptureAddress,
            Unknown,
        }!Result {
            const result = self.vkCreateRayTracingPipelinesKHR(
                device,
                deferred_operation,
                pipeline_cache,
                create_info_count,
                p_create_infos,
                p_allocator,
                p_pipelines,
            );
            switch (result) {
                .success => {},
                .operation_deferred_khr => {},
                .operation_not_deferred_khr => {},
                .pipeline_compile_required_ext => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_invalid_opaque_capture_address => return error.InvalidOpaqueCaptureAddress,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdTraceRaysIndirectKHR(
            self: Self,
            command_buffer: CommandBuffer,
            raygen_shader_binding_table: StridedDeviceAddressRegionKHR,
            miss_shader_binding_table: StridedDeviceAddressRegionKHR,
            hit_shader_binding_table: StridedDeviceAddressRegionKHR,
            callable_shader_binding_table: StridedDeviceAddressRegionKHR,
            indirect_device_address: DeviceAddress,
        ) void {
            self.vkCmdTraceRaysIndirectKHR(
                command_buffer,
                &raygen_shader_binding_table,
                &miss_shader_binding_table,
                &hit_shader_binding_table,
                &callable_shader_binding_table,
                indirect_device_address,
            );
        }
        pub fn getDeviceAccelerationStructureCompatibilityKHR(
            self: Self,
            device: Device,
            version_info: AccelerationStructureVersionInfoKHR,
        ) AccelerationStructureCompatibilityKHR {
            var compatibility: AccelerationStructureCompatibilityKHR = undefined;
            self.vkGetDeviceAccelerationStructureCompatibilityKHR(
                device,
                &version_info,
                &compatibility,
            );
            return compatibility;
        }
        pub fn getRayTracingShaderGroupStackSizeKHR(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            group: u32,
            group_shader: ShaderGroupShaderKHR,
        ) DeviceSize {
            return self.vkGetRayTracingShaderGroupStackSizeKHR(
                device,
                pipeline,
                group,
                group_shader,
            );
        }
        pub fn cmdSetRayTracingPipelineStackSizeKHR(
            self: Self,
            command_buffer: CommandBuffer,
            pipeline_stack_size: u32,
        ) void {
            self.vkCmdSetRayTracingPipelineStackSizeKHR(
                command_buffer,
                pipeline_stack_size,
            );
        }
        pub fn getImageViewHandleNVX(
            self: Self,
            device: Device,
            info: ImageViewHandleInfoNVX,
        ) u32 {
            return self.vkGetImageViewHandleNVX(
                device,
                &info,
            );
        }
        pub fn getImageViewAddressNVX(
            self: Self,
            device: Device,
            image_view: ImageView,
            p_properties: *ImageViewAddressPropertiesNVX,
        ) error{
            OutOfHostMemory,
            Unknown,
            Unknown,
        }!void {
            const result = self.vkGetImageViewAddressNVX(
                device,
                image_view,
                p_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_unknown => return error.Unknown,
                else => return error.Unknown,
            }
        }
        pub fn getDeviceGroupSurfacePresentModes2EXT(
            self: Self,
            device: Device,
            surface_info: PhysicalDeviceSurfaceInfo2KHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!DeviceGroupPresentModeFlagsKHR {
            var modes: DeviceGroupPresentModeFlagsKHR = undefined;
            const result = self.vkGetDeviceGroupSurfacePresentModes2EXT(
                device,
                &surface_info,
                &modes,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return modes;
        }
        pub fn acquireFullScreenExclusiveModeEXT(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            SurfaceLostKHR,
            Unknown,
        }!void {
            const result = self.vkAcquireFullScreenExclusiveModeEXT(
                device,
                swapchain,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_initialization_failed => return error.InitializationFailed,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub fn releaseFullScreenExclusiveModeEXT(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        }!void {
            const result = self.vkReleaseFullScreenExclusiveModeEXT(
                device,
                swapchain,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                .error_surface_lost_khr => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub fn acquireProfilingLockKHR(
            self: Self,
            device: Device,
            info: AcquireProfilingLockInfoKHR,
        ) error{
            OutOfHostMemory,
            Timeout,
            Unknown,
        }!void {
            const result = self.vkAcquireProfilingLockKHR(
                device,
                &info,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .timeout => return error.Timeout,
                else => return error.Unknown,
            }
        }
        pub fn releaseProfilingLockKHR(
            self: Self,
            device: Device,
        ) void {
            self.vkReleaseProfilingLockKHR(
                device,
            );
        }
        pub fn getImageDrmFormatModifierPropertiesEXT(
            self: Self,
            device: Device,
            image: Image,
            p_properties: *ImageDrmFormatModifierPropertiesEXT,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkGetImageDrmFormatModifierPropertiesEXT(
                device,
                image,
                p_properties,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn getBufferOpaqueCaptureAddress(
            self: Self,
            device: Device,
            info: BufferDeviceAddressInfo,
        ) u64 {
            return self.vkGetBufferOpaqueCaptureAddress(
                device,
                &info,
            );
        }
        pub fn getBufferDeviceAddress(
            self: Self,
            device: Device,
            info: BufferDeviceAddressInfo,
        ) DeviceAddress {
            return self.vkGetBufferDeviceAddress(
                device,
                &info,
            );
        }
        pub fn initializePerformanceApiINTEL(
            self: Self,
            device: Device,
            initialize_info: InitializePerformanceApiInfoINTEL,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkInitializePerformanceApiINTEL(
                device,
                &initialize_info,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn uninitializePerformanceApiINTEL(
            self: Self,
            device: Device,
        ) void {
            self.vkUninitializePerformanceApiINTEL(
                device,
            );
        }
        pub fn cmdSetPerformanceMarkerINTEL(
            self: Self,
            command_buffer: CommandBuffer,
            marker_info: PerformanceMarkerInfoINTEL,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkCmdSetPerformanceMarkerINTEL(
                command_buffer,
                &marker_info,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdSetPerformanceStreamMarkerINTEL(
            self: Self,
            command_buffer: CommandBuffer,
            marker_info: PerformanceStreamMarkerInfoINTEL,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkCmdSetPerformanceStreamMarkerINTEL(
                command_buffer,
                &marker_info,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdSetPerformanceOverrideINTEL(
            self: Self,
            command_buffer: CommandBuffer,
            override_info: PerformanceOverrideInfoINTEL,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkCmdSetPerformanceOverrideINTEL(
                command_buffer,
                &override_info,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn acquirePerformanceConfigurationINTEL(
            self: Self,
            device: Device,
            acquire_info: PerformanceConfigurationAcquireInfoINTEL,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!PerformanceConfigurationINTEL {
            var configuration: PerformanceConfigurationINTEL = undefined;
            const result = self.vkAcquirePerformanceConfigurationINTEL(
                device,
                &acquire_info,
                &configuration,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return configuration;
        }
        pub fn releasePerformanceConfigurationINTEL(
            self: Self,
            device: Device,
            configuration: PerformanceConfigurationINTEL,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkReleasePerformanceConfigurationINTEL(
                device,
                configuration,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn queueSetPerformanceConfigurationINTEL(
            self: Self,
            queue: Queue,
            configuration: PerformanceConfigurationINTEL,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkQueueSetPerformanceConfigurationINTEL(
                queue,
                configuration,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn getPerformanceParameterINTEL(
            self: Self,
            device: Device,
            parameter: PerformanceParameterTypeINTEL,
        ) error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        }!PerformanceValueINTEL {
            var value: PerformanceValueINTEL = undefined;
            const result = self.vkGetPerformanceParameterINTEL(
                device,
                parameter,
                &value,
            );
            switch (result) {
                .success => {},
                .error_too_many_objects => return error.TooManyObjects,
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return value;
        }
        pub fn getDeviceMemoryOpaqueCaptureAddress(
            self: Self,
            device: Device,
            info: DeviceMemoryOpaqueCaptureAddressInfo,
        ) u64 {
            return self.vkGetDeviceMemoryOpaqueCaptureAddress(
                device,
                &info,
            );
        }
        pub fn getPipelineExecutablePropertiesKHR(
            self: Self,
            device: Device,
            pipeline_info: PipelineInfoKHR,
            p_executable_count: *u32,
            p_properties: ?[*]PipelineExecutablePropertiesKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPipelineExecutablePropertiesKHR(
                device,
                &pipeline_info,
                p_executable_count,
                p_properties,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPipelineExecutableStatisticsKHR(
            self: Self,
            device: Device,
            executable_info: PipelineExecutableInfoKHR,
            p_statistic_count: *u32,
            p_statistics: ?[*]PipelineExecutableStatisticKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPipelineExecutableStatisticsKHR(
                device,
                &executable_info,
                p_statistic_count,
                p_statistics,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPipelineExecutableInternalRepresentationsKHR(
            self: Self,
            device: Device,
            executable_info: PipelineExecutableInfoKHR,
            p_internal_representation_count: *u32,
            p_internal_representations: ?[*]PipelineExecutableInternalRepresentationKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkGetPipelineExecutableInternalRepresentationsKHR(
                device,
                &executable_info,
                p_internal_representation_count,
                p_internal_representations,
            );
            switch (result) {
                .success => {},
                .incomplete => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdSetLineStippleEXT(
            self: Self,
            command_buffer: CommandBuffer,
            line_stipple_factor: u32,
            line_stipple_pattern: u16,
        ) void {
            self.vkCmdSetLineStippleEXT(
                command_buffer,
                line_stipple_factor,
                line_stipple_pattern,
            );
        }
        pub fn createAccelerationStructureKHR(
            self: Self,
            device: Device,
            create_info: AccelerationStructureCreateInfoKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            InvalidOpaqueCaptureAddress,
            Unknown,
        }!AccelerationStructureKHR {
            var acceleration_structure: AccelerationStructureKHR = undefined;
            const result = self.vkCreateAccelerationStructureKHR(
                device,
                &create_info,
                p_allocator,
                &acceleration_structure,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_invalid_opaque_capture_address => return error.InvalidOpaqueCaptureAddress,
                else => return error.Unknown,
            }
            return acceleration_structure;
        }
        pub fn cmdBuildAccelerationStructuresKHR(
            self: Self,
            command_buffer: CommandBuffer,
            info_count: u32,
            p_infos: [*]const AccelerationStructureBuildGeometryInfoKHR,
            pp_build_range_infos: [*]const *const AccelerationStructureBuildRangeInfoKHR,
        ) void {
            self.vkCmdBuildAccelerationStructuresKHR(
                command_buffer,
                info_count,
                p_infos,
                pp_build_range_infos,
            );
        }
        pub fn cmdBuildAccelerationStructuresIndirectKHR(
            self: Self,
            command_buffer: CommandBuffer,
            info_count: u32,
            p_infos: [*]const AccelerationStructureBuildGeometryInfoKHR,
            p_indirect_device_addresses: [*]const DeviceAddress,
            p_indirect_strides: [*]const u32,
            pp_max_primitive_counts: [*]const *const u32,
        ) void {
            self.vkCmdBuildAccelerationStructuresIndirectKHR(
                command_buffer,
                info_count,
                p_infos,
                p_indirect_device_addresses,
                p_indirect_strides,
                pp_max_primitive_counts,
            );
        }
        pub fn buildAccelerationStructuresKHR(
            self: Self,
            device: Device,
            deferred_operation: DeferredOperationKHR,
            info_count: u32,
            p_infos: [*]const AccelerationStructureBuildGeometryInfoKHR,
            pp_build_range_infos: [*]const *const AccelerationStructureBuildRangeInfoKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkBuildAccelerationStructuresKHR(
                device,
                deferred_operation,
                info_count,
                p_infos,
                pp_build_range_infos,
            );
            switch (result) {
                .success => {},
                .operation_deferred_khr => {},
                .operation_not_deferred_khr => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getAccelerationStructureDeviceAddressKHR(
            self: Self,
            device: Device,
            info: AccelerationStructureDeviceAddressInfoKHR,
        ) DeviceAddress {
            return self.vkGetAccelerationStructureDeviceAddressKHR(
                device,
                &info,
            );
        }
        pub fn createDeferredOperationKHR(
            self: Self,
            device: Device,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!DeferredOperationKHR {
            var deferred_operation: DeferredOperationKHR = undefined;
            const result = self.vkCreateDeferredOperationKHR(
                device,
                p_allocator,
                &deferred_operation,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return deferred_operation;
        }
        pub fn destroyDeferredOperationKHR(
            self: Self,
            device: Device,
            operation: DeferredOperationKHR,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyDeferredOperationKHR(
                device,
                operation,
                p_allocator,
            );
        }
        pub fn getDeferredOperationMaxConcurrencyKHR(
            self: Self,
            device: Device,
            operation: DeferredOperationKHR,
        ) u32 {
            return self.vkGetDeferredOperationMaxConcurrencyKHR(
                device,
                operation,
            );
        }
        pub fn getDeferredOperationResultKHR(
            self: Self,
            device: Device,
            operation: DeferredOperationKHR,
        ) error{Unknown}!Result {
            const result = self.vkGetDeferredOperationResultKHR(
                device,
                operation,
            );
            switch (result) {
                .success => {},
                .not_ready => {},
                else => return error.Unknown,
            }
            return result;
        }
        pub fn deferredOperationJoinKHR(
            self: Self,
            device: Device,
            operation: DeferredOperationKHR,
        ) error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        }!Result {
            const result = self.vkDeferredOperationJoinKHR(
                device,
                operation,
            );
            switch (result) {
                .success => {},
                .thread_done_khr => {},
                .thread_idle_khr => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                .error_out_of_device_memory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdSetCullModeEXT(
            self: Self,
            command_buffer: CommandBuffer,
            cull_mode: CullModeFlags,
        ) void {
            self.vkCmdSetCullModeEXT(
                command_buffer,
                cull_mode.toInt(),
            );
        }
        pub fn cmdSetFrontFaceEXT(
            self: Self,
            command_buffer: CommandBuffer,
            front_face: FrontFace,
        ) void {
            self.vkCmdSetFrontFaceEXT(
                command_buffer,
                front_face,
            );
        }
        pub fn cmdSetPrimitiveTopologyEXT(
            self: Self,
            command_buffer: CommandBuffer,
            primitive_topology: PrimitiveTopology,
        ) void {
            self.vkCmdSetPrimitiveTopologyEXT(
                command_buffer,
                primitive_topology,
            );
        }
        pub fn cmdSetViewportWithCountEXT(
            self: Self,
            command_buffer: CommandBuffer,
            viewport_count: u32,
            p_viewports: [*]const Viewport,
        ) void {
            self.vkCmdSetViewportWithCountEXT(
                command_buffer,
                viewport_count,
                p_viewports,
            );
        }
        pub fn cmdSetScissorWithCountEXT(
            self: Self,
            command_buffer: CommandBuffer,
            scissor_count: u32,
            p_scissors: [*]const Rect2D,
        ) void {
            self.vkCmdSetScissorWithCountEXT(
                command_buffer,
                scissor_count,
                p_scissors,
            );
        }
        pub fn cmdBindVertexBuffers2EXT(
            self: Self,
            command_buffer: CommandBuffer,
            first_binding: u32,
            binding_count: u32,
            p_buffers: [*]const Buffer,
            p_offsets: [*]const DeviceSize,
            p_sizes: ?[*]const DeviceSize,
            p_strides: ?[*]const DeviceSize,
        ) void {
            self.vkCmdBindVertexBuffers2EXT(
                command_buffer,
                first_binding,
                binding_count,
                p_buffers,
                p_offsets,
                p_sizes,
                p_strides,
            );
        }
        pub fn cmdSetDepthTestEnableEXT(
            self: Self,
            command_buffer: CommandBuffer,
            depth_test_enable: Bool32,
        ) void {
            self.vkCmdSetDepthTestEnableEXT(
                command_buffer,
                depth_test_enable,
            );
        }
        pub fn cmdSetDepthWriteEnableEXT(
            self: Self,
            command_buffer: CommandBuffer,
            depth_write_enable: Bool32,
        ) void {
            self.vkCmdSetDepthWriteEnableEXT(
                command_buffer,
                depth_write_enable,
            );
        }
        pub fn cmdSetDepthCompareOpEXT(
            self: Self,
            command_buffer: CommandBuffer,
            depth_compare_op: CompareOp,
        ) void {
            self.vkCmdSetDepthCompareOpEXT(
                command_buffer,
                depth_compare_op,
            );
        }
        pub fn cmdSetDepthBoundsTestEnableEXT(
            self: Self,
            command_buffer: CommandBuffer,
            depth_bounds_test_enable: Bool32,
        ) void {
            self.vkCmdSetDepthBoundsTestEnableEXT(
                command_buffer,
                depth_bounds_test_enable,
            );
        }
        pub fn cmdSetStencilTestEnableEXT(
            self: Self,
            command_buffer: CommandBuffer,
            stencil_test_enable: Bool32,
        ) void {
            self.vkCmdSetStencilTestEnableEXT(
                command_buffer,
                stencil_test_enable,
            );
        }
        pub fn cmdSetStencilOpEXT(
            self: Self,
            command_buffer: CommandBuffer,
            face_mask: StencilFaceFlags,
            fail_op: StencilOp,
            pass_op: StencilOp,
            depth_fail_op: StencilOp,
            compare_op: CompareOp,
        ) void {
            self.vkCmdSetStencilOpEXT(
                command_buffer,
                face_mask.toInt(),
                fail_op,
                pass_op,
                depth_fail_op,
                compare_op,
            );
        }
        pub fn createPrivateDataSlotEXT(
            self: Self,
            device: Device,
            create_info: PrivateDataSlotCreateInfoEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!PrivateDataSlotEXT {
            var private_data_slot: PrivateDataSlotEXT = undefined;
            const result = self.vkCreatePrivateDataSlotEXT(
                device,
                &create_info,
                p_allocator,
                &private_data_slot,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return private_data_slot;
        }
        pub fn destroyPrivateDataSlotEXT(
            self: Self,
            device: Device,
            private_data_slot: PrivateDataSlotEXT,
            p_allocator: ?*const AllocationCallbacks,
        ) void {
            self.vkDestroyPrivateDataSlotEXT(
                device,
                private_data_slot,
                p_allocator,
            );
        }
        pub fn setPrivateDataEXT(
            self: Self,
            device: Device,
            object_type: ObjectType,
            object_handle: u64,
            private_data_slot: PrivateDataSlotEXT,
            data: u64,
        ) error{
            OutOfHostMemory,
            Unknown,
        }!void {
            const result = self.vkSetPrivateDataEXT(
                device,
                object_type,
                object_handle,
                private_data_slot,
                data,
            );
            switch (result) {
                .success => {},
                .error_out_of_host_memory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn getPrivateDataEXT(
            self: Self,
            device: Device,
            object_type: ObjectType,
            object_handle: u64,
            private_data_slot: PrivateDataSlotEXT,
        ) u64 {
            var data: u64 = undefined;
            self.vkGetPrivateDataEXT(
                device,
                object_type,
                object_handle,
                private_data_slot,
                &data,
            );
            return data;
        }
        pub fn cmdCopyBuffer2KHR(
            self: Self,
            command_buffer: CommandBuffer,
            copy_buffer_info: CopyBufferInfo2KHR,
        ) void {
            self.vkCmdCopyBuffer2KHR(
                command_buffer,
                &copy_buffer_info,
            );
        }
        pub fn cmdCopyImage2KHR(
            self: Self,
            command_buffer: CommandBuffer,
            copy_image_info: CopyImageInfo2KHR,
        ) void {
            self.vkCmdCopyImage2KHR(
                command_buffer,
                &copy_image_info,
            );
        }
        pub fn cmdBlitImage2KHR(
            self: Self,
            command_buffer: CommandBuffer,
            blit_image_info: BlitImageInfo2KHR,
        ) void {
            self.vkCmdBlitImage2KHR(
                command_buffer,
                &blit_image_info,
            );
        }
        pub fn cmdCopyBufferToImage2KHR(
            self: Self,
            command_buffer: CommandBuffer,
            copy_buffer_to_image_info: CopyBufferToImageInfo2KHR,
        ) void {
            self.vkCmdCopyBufferToImage2KHR(
                command_buffer,
                &copy_buffer_to_image_info,
            );
        }
        pub fn cmdCopyImageToBuffer2KHR(
            self: Self,
            command_buffer: CommandBuffer,
            copy_image_to_buffer_info: CopyImageToBufferInfo2KHR,
        ) void {
            self.vkCmdCopyImageToBuffer2KHR(
                command_buffer,
                &copy_image_to_buffer_info,
            );
        }
        pub fn cmdResolveImage2KHR(
            self: Self,
            command_buffer: CommandBuffer,
            resolve_image_info: ResolveImageInfo2KHR,
        ) void {
            self.vkCmdResolveImage2KHR(
                command_buffer,
                &resolve_image_info,
            );
        }
        pub fn cmdSetFragmentShadingRateKHR(
            self: Self,
            command_buffer: CommandBuffer,
            fragment_size: Extent2D,
            combiner_ops: [2]FragmentShadingRateCombinerOpKHR,
        ) void {
            self.vkCmdSetFragmentShadingRateKHR(
                command_buffer,
                &fragment_size,
                combiner_ops,
            );
        }
        pub fn cmdSetFragmentShadingRateEnumNV(
            self: Self,
            command_buffer: CommandBuffer,
            shading_rate: FragmentShadingRateNV,
            combiner_ops: [2]FragmentShadingRateCombinerOpKHR,
        ) void {
            self.vkCmdSetFragmentShadingRateEnumNV(
                command_buffer,
                shading_rate,
                combiner_ops,
            );
        }
        pub fn getAccelerationStructureBuildSizesKHR(
            self: Self,
            device: Device,
            build_type: AccelerationStructureBuildTypeKHR,
            build_info: AccelerationStructureBuildGeometryInfoKHR,
            p_max_primitive_counts: [*]const u32,
            p_size_info: *AccelerationStructureBuildSizesInfoKHR,
        ) void {
            self.vkGetAccelerationStructureBuildSizesKHR(
                device,
                build_type,
                &build_info,
                p_max_primitive_counts,
                p_size_info,
            );
        }
    };
}
