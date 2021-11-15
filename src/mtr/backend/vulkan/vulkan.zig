//
//
// Copyright 2015-2021 The Khronos Group Inc.
//
// SPDX-License-Identifier: Apache-2.0 OR MIT
//

// This file is generated from the Khronos Vulkan XML API registry by vulkan-zig.

const std = @import("std");
const builtin = @import("builtin");
const root = @import("root");

const GlobalScope = @This();

pub const vulkan_call_conv: std.builtin.CallingConvention = if (builtin.os.tag == .windows and builtin.cpu.arch == .i386)
    .Stdcall
else if (builtin.abi == .android and (builtin.cpu.arch.isARM() or builtin.cpu.arch.isThumb()) and std.Target.arm.featureSetHas(builtin.cpu.features, .has_v7) and builtin.cpu.arch.ptrBitWidth() == 32)
    // On Android 32-bit ARM targets, Vulkan functions use the "hardfloat"
    // calling convention, i.e. float parameters are passed in registers. This
    // is true even if the rest of the application passes floats on the stack,
    // as it does by default when compiling for the armeabi-v7a NDK ABI.
    .AAPCSVFP
else
    .C;
pub fn FlagsMixin(comptime FlagsType: type, comptime Int: type) type {
    return struct {
        pub const IntType = Int;
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
            return fromInt(~toInt(self));
        }
        pub fn subtract(lhs: FlagsType, rhs: FlagsType) FlagsType {
            return fromInt(toInt(lhs) & toInt(rhs.complement()));
        }
        pub fn contains(lhs: FlagsType, rhs: FlagsType) bool {
            return toInt(intersect(lhs, rhs)) == toInt(rhs);
        }
    };
}
pub fn makeApiVersion(variant: u3, major: u7, minor: u10, patch: u12) u32 {
    return (@as(u32, variant) << 29) | (@as(u32, major) << 22) | (@as(u32, minor) << 12) | patch;
}
pub fn apiVersionVariant(version: u32) u3 {
    return @truncate(u3, version >> 29);
}
pub fn apiVersionMajor(version: u32) u7 {
    return @truncate(u7, version >> 22);
}
pub fn apiVersionMinor(version: u32) u10 {
    return @truncate(u10, version >> 12);
}
pub fn apiVersionPatch(version: u32) u12 {
    return @truncate(u12, version);
}
pub const BaseCommand = enum {
    createInstance,
    getInstanceProcAddr,
    enumerateInstanceVersion,
    enumerateInstanceLayerProperties,
    enumerateInstanceExtensionProperties,

    pub fn symbol(self: BaseCommand) [:0]const u8 {
        return switch (self) {
            .createInstance => "vkCreateInstance",
            .getInstanceProcAddr => "vkGetInstanceProcAddr",
            .enumerateInstanceVersion => "vkEnumerateInstanceVersion",
            .enumerateInstanceLayerProperties => "vkEnumerateInstanceLayerProperties",
            .enumerateInstanceExtensionProperties => "vkEnumerateInstanceExtensionProperties",
        };
    }

    pub fn PfnType(comptime self: BaseCommand) type {
        return switch (self) {
            .createInstance => PfnCreateInstance,
            .getInstanceProcAddr => PfnGetInstanceProcAddr,
            .enumerateInstanceVersion => PfnEnumerateInstanceVersion,
            .enumerateInstanceLayerProperties => PfnEnumerateInstanceLayerProperties,
            .enumerateInstanceExtensionProperties => PfnEnumerateInstanceExtensionProperties,
        };
    }
};
pub const InstanceCommand = enum {
    destroyInstance,
    enumeratePhysicalDevices,
    getDeviceProcAddr,
    getPhysicalDeviceProperties,
    getPhysicalDeviceQueueFamilyProperties,
    getPhysicalDeviceMemoryProperties,
    getPhysicalDeviceFeatures,
    getPhysicalDeviceFormatProperties,
    getPhysicalDeviceImageFormatProperties,
    createDevice,
    enumerateDeviceLayerProperties,
    enumerateDeviceExtensionProperties,
    getPhysicalDeviceSparseImageFormatProperties,
    createAndroidSurfaceKHR,
    getPhysicalDeviceDisplayPropertiesKHR,
    getPhysicalDeviceDisplayPlanePropertiesKHR,
    getDisplayPlaneSupportedDisplaysKHR,
    getDisplayModePropertiesKHR,
    createDisplayModeKHR,
    getDisplayPlaneCapabilitiesKHR,
    createDisplayPlaneSurfaceKHR,
    destroySurfaceKHR,
    getPhysicalDeviceSurfaceSupportKHR,
    getPhysicalDeviceSurfaceCapabilitiesKHR,
    getPhysicalDeviceSurfaceFormatsKHR,
    getPhysicalDeviceSurfacePresentModesKHR,
    createViSurfaceNN,
    createWaylandSurfaceKHR,
    getPhysicalDeviceWaylandPresentationSupportKHR,
    createWin32SurfaceKHR,
    getPhysicalDeviceWin32PresentationSupportKHR,
    createXlibSurfaceKHR,
    getPhysicalDeviceXlibPresentationSupportKHR,
    createXcbSurfaceKHR,
    getPhysicalDeviceXcbPresentationSupportKHR,
    createDirectFbSurfaceEXT,
    getPhysicalDeviceDirectFbPresentationSupportEXT,
    createImagePipeSurfaceFUCHSIA,
    createStreamDescriptorSurfaceGGP,
    createScreenSurfaceQNX,
    getPhysicalDeviceScreenPresentationSupportQNX,
    createDebugReportCallbackEXT,
    destroyDebugReportCallbackEXT,
    debugReportMessageEXT,
    getPhysicalDeviceExternalImageFormatPropertiesNV,
    getPhysicalDeviceFeatures2,
    getPhysicalDeviceProperties2,
    getPhysicalDeviceFormatProperties2,
    getPhysicalDeviceImageFormatProperties2,
    getPhysicalDeviceQueueFamilyProperties2,
    getPhysicalDeviceMemoryProperties2,
    getPhysicalDeviceSparseImageFormatProperties2,
    getPhysicalDeviceExternalBufferProperties,
    getPhysicalDeviceExternalSemaphoreProperties,
    getPhysicalDeviceExternalFenceProperties,
    releaseDisplayEXT,
    acquireXlibDisplayEXT,
    getRandROutputDisplayEXT,
    acquireWinrtDisplayNV,
    getWinrtDisplayNV,
    getPhysicalDeviceSurfaceCapabilities2EXT,
    enumeratePhysicalDeviceGroups,
    getPhysicalDevicePresentRectanglesKHR,
    createIosSurfaceMVK,
    createMacOsSurfaceMVK,
    createMetalSurfaceEXT,
    getPhysicalDeviceMultisamplePropertiesEXT,
    getPhysicalDeviceSurfaceCapabilities2KHR,
    getPhysicalDeviceSurfaceFormats2KHR,
    getPhysicalDeviceDisplayProperties2KHR,
    getPhysicalDeviceDisplayPlaneProperties2KHR,
    getDisplayModeProperties2KHR,
    getDisplayPlaneCapabilities2KHR,
    getPhysicalDeviceCalibrateableTimeDomainsEXT,
    createDebugUtilsMessengerEXT,
    destroyDebugUtilsMessengerEXT,
    submitDebugUtilsMessageEXT,
    getPhysicalDeviceCooperativeMatrixPropertiesNV,
    getPhysicalDeviceSurfacePresentModes2EXT,
    enumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR,
    getPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR,
    createHeadlessSurfaceEXT,
    getPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV,
    getPhysicalDeviceToolPropertiesEXT,
    getPhysicalDeviceFragmentShadingRatesKHR,
    getPhysicalDeviceVideoCapabilitiesKHR,
    getPhysicalDeviceVideoFormatPropertiesKHR,
    acquireDrmDisplayEXT,
    getDrmDisplayEXT,

    pub fn symbol(self: InstanceCommand) [:0]const u8 {
        return switch (self) {
            .destroyInstance => "vkDestroyInstance",
            .enumeratePhysicalDevices => "vkEnumeratePhysicalDevices",
            .getDeviceProcAddr => "vkGetDeviceProcAddr",
            .getPhysicalDeviceProperties => "vkGetPhysicalDeviceProperties",
            .getPhysicalDeviceQueueFamilyProperties => "vkGetPhysicalDeviceQueueFamilyProperties",
            .getPhysicalDeviceMemoryProperties => "vkGetPhysicalDeviceMemoryProperties",
            .getPhysicalDeviceFeatures => "vkGetPhysicalDeviceFeatures",
            .getPhysicalDeviceFormatProperties => "vkGetPhysicalDeviceFormatProperties",
            .getPhysicalDeviceImageFormatProperties => "vkGetPhysicalDeviceImageFormatProperties",
            .createDevice => "vkCreateDevice",
            .enumerateDeviceLayerProperties => "vkEnumerateDeviceLayerProperties",
            .enumerateDeviceExtensionProperties => "vkEnumerateDeviceExtensionProperties",
            .getPhysicalDeviceSparseImageFormatProperties => "vkGetPhysicalDeviceSparseImageFormatProperties",
            .createAndroidSurfaceKHR => "vkCreateAndroidSurfaceKHR",
            .getPhysicalDeviceDisplayPropertiesKHR => "vkGetPhysicalDeviceDisplayPropertiesKHR",
            .getPhysicalDeviceDisplayPlanePropertiesKHR => "vkGetPhysicalDeviceDisplayPlanePropertiesKHR",
            .getDisplayPlaneSupportedDisplaysKHR => "vkGetDisplayPlaneSupportedDisplaysKHR",
            .getDisplayModePropertiesKHR => "vkGetDisplayModePropertiesKHR",
            .createDisplayModeKHR => "vkCreateDisplayModeKHR",
            .getDisplayPlaneCapabilitiesKHR => "vkGetDisplayPlaneCapabilitiesKHR",
            .createDisplayPlaneSurfaceKHR => "vkCreateDisplayPlaneSurfaceKHR",
            .destroySurfaceKHR => "vkDestroySurfaceKHR",
            .getPhysicalDeviceSurfaceSupportKHR => "vkGetPhysicalDeviceSurfaceSupportKHR",
            .getPhysicalDeviceSurfaceCapabilitiesKHR => "vkGetPhysicalDeviceSurfaceCapabilitiesKHR",
            .getPhysicalDeviceSurfaceFormatsKHR => "vkGetPhysicalDeviceSurfaceFormatsKHR",
            .getPhysicalDeviceSurfacePresentModesKHR => "vkGetPhysicalDeviceSurfacePresentModesKHR",
            .createViSurfaceNN => "vkCreateViSurfaceNN",
            .createWaylandSurfaceKHR => "vkCreateWaylandSurfaceKHR",
            .getPhysicalDeviceWaylandPresentationSupportKHR => "vkGetPhysicalDeviceWaylandPresentationSupportKHR",
            .createWin32SurfaceKHR => "vkCreateWin32SurfaceKHR",
            .getPhysicalDeviceWin32PresentationSupportKHR => "vkGetPhysicalDeviceWin32PresentationSupportKHR",
            .createXlibSurfaceKHR => "vkCreateXlibSurfaceKHR",
            .getPhysicalDeviceXlibPresentationSupportKHR => "vkGetPhysicalDeviceXlibPresentationSupportKHR",
            .createXcbSurfaceKHR => "vkCreateXcbSurfaceKHR",
            .getPhysicalDeviceXcbPresentationSupportKHR => "vkGetPhysicalDeviceXcbPresentationSupportKHR",
            .createDirectFbSurfaceEXT => "vkCreateDirectFBSurfaceEXT",
            .getPhysicalDeviceDirectFbPresentationSupportEXT => "vkGetPhysicalDeviceDirectFBPresentationSupportEXT",
            .createImagePipeSurfaceFUCHSIA => "vkCreateImagePipeSurfaceFUCHSIA",
            .createStreamDescriptorSurfaceGGP => "vkCreateStreamDescriptorSurfaceGGP",
            .createScreenSurfaceQNX => "vkCreateScreenSurfaceQNX",
            .getPhysicalDeviceScreenPresentationSupportQNX => "vkGetPhysicalDeviceScreenPresentationSupportQNX",
            .createDebugReportCallbackEXT => "vkCreateDebugReportCallbackEXT",
            .destroyDebugReportCallbackEXT => "vkDestroyDebugReportCallbackEXT",
            .debugReportMessageEXT => "vkDebugReportMessageEXT",
            .getPhysicalDeviceExternalImageFormatPropertiesNV => "vkGetPhysicalDeviceExternalImageFormatPropertiesNV",
            .getPhysicalDeviceFeatures2 => "vkGetPhysicalDeviceFeatures2",
            .getPhysicalDeviceProperties2 => "vkGetPhysicalDeviceProperties2",
            .getPhysicalDeviceFormatProperties2 => "vkGetPhysicalDeviceFormatProperties2",
            .getPhysicalDeviceImageFormatProperties2 => "vkGetPhysicalDeviceImageFormatProperties2",
            .getPhysicalDeviceQueueFamilyProperties2 => "vkGetPhysicalDeviceQueueFamilyProperties2",
            .getPhysicalDeviceMemoryProperties2 => "vkGetPhysicalDeviceMemoryProperties2",
            .getPhysicalDeviceSparseImageFormatProperties2 => "vkGetPhysicalDeviceSparseImageFormatProperties2",
            .getPhysicalDeviceExternalBufferProperties => "vkGetPhysicalDeviceExternalBufferProperties",
            .getPhysicalDeviceExternalSemaphoreProperties => "vkGetPhysicalDeviceExternalSemaphoreProperties",
            .getPhysicalDeviceExternalFenceProperties => "vkGetPhysicalDeviceExternalFenceProperties",
            .releaseDisplayEXT => "vkReleaseDisplayEXT",
            .acquireXlibDisplayEXT => "vkAcquireXlibDisplayEXT",
            .getRandROutputDisplayEXT => "vkGetRandROutputDisplayEXT",
            .acquireWinrtDisplayNV => "vkAcquireWinrtDisplayNV",
            .getWinrtDisplayNV => "vkGetWinrtDisplayNV",
            .getPhysicalDeviceSurfaceCapabilities2EXT => "vkGetPhysicalDeviceSurfaceCapabilities2EXT",
            .enumeratePhysicalDeviceGroups => "vkEnumeratePhysicalDeviceGroups",
            .getPhysicalDevicePresentRectanglesKHR => "vkGetPhysicalDevicePresentRectanglesKHR",
            .createIosSurfaceMVK => "vkCreateIOSSurfaceMVK",
            .createMacOsSurfaceMVK => "vkCreateMacOSSurfaceMVK",
            .createMetalSurfaceEXT => "vkCreateMetalSurfaceEXT",
            .getPhysicalDeviceMultisamplePropertiesEXT => "vkGetPhysicalDeviceMultisamplePropertiesEXT",
            .getPhysicalDeviceSurfaceCapabilities2KHR => "vkGetPhysicalDeviceSurfaceCapabilities2KHR",
            .getPhysicalDeviceSurfaceFormats2KHR => "vkGetPhysicalDeviceSurfaceFormats2KHR",
            .getPhysicalDeviceDisplayProperties2KHR => "vkGetPhysicalDeviceDisplayProperties2KHR",
            .getPhysicalDeviceDisplayPlaneProperties2KHR => "vkGetPhysicalDeviceDisplayPlaneProperties2KHR",
            .getDisplayModeProperties2KHR => "vkGetDisplayModeProperties2KHR",
            .getDisplayPlaneCapabilities2KHR => "vkGetDisplayPlaneCapabilities2KHR",
            .getPhysicalDeviceCalibrateableTimeDomainsEXT => "vkGetPhysicalDeviceCalibrateableTimeDomainsEXT",
            .createDebugUtilsMessengerEXT => "vkCreateDebugUtilsMessengerEXT",
            .destroyDebugUtilsMessengerEXT => "vkDestroyDebugUtilsMessengerEXT",
            .submitDebugUtilsMessageEXT => "vkSubmitDebugUtilsMessageEXT",
            .getPhysicalDeviceCooperativeMatrixPropertiesNV => "vkGetPhysicalDeviceCooperativeMatrixPropertiesNV",
            .getPhysicalDeviceSurfacePresentModes2EXT => "vkGetPhysicalDeviceSurfacePresentModes2EXT",
            .enumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR => "vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR",
            .getPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR => "vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR",
            .createHeadlessSurfaceEXT => "vkCreateHeadlessSurfaceEXT",
            .getPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV => "vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV",
            .getPhysicalDeviceToolPropertiesEXT => "vkGetPhysicalDeviceToolPropertiesEXT",
            .getPhysicalDeviceFragmentShadingRatesKHR => "vkGetPhysicalDeviceFragmentShadingRatesKHR",
            .getPhysicalDeviceVideoCapabilitiesKHR => "vkGetPhysicalDeviceVideoCapabilitiesKHR",
            .getPhysicalDeviceVideoFormatPropertiesKHR => "vkGetPhysicalDeviceVideoFormatPropertiesKHR",
            .acquireDrmDisplayEXT => "vkAcquireDrmDisplayEXT",
            .getDrmDisplayEXT => "vkGetDrmDisplayEXT",
        };
    }

    pub fn PfnType(comptime self: InstanceCommand) type {
        return switch (self) {
            .destroyInstance => PfnDestroyInstance,
            .enumeratePhysicalDevices => PfnEnumeratePhysicalDevices,
            .getDeviceProcAddr => PfnGetDeviceProcAddr,
            .getPhysicalDeviceProperties => PfnGetPhysicalDeviceProperties,
            .getPhysicalDeviceQueueFamilyProperties => PfnGetPhysicalDeviceQueueFamilyProperties,
            .getPhysicalDeviceMemoryProperties => PfnGetPhysicalDeviceMemoryProperties,
            .getPhysicalDeviceFeatures => PfnGetPhysicalDeviceFeatures,
            .getPhysicalDeviceFormatProperties => PfnGetPhysicalDeviceFormatProperties,
            .getPhysicalDeviceImageFormatProperties => PfnGetPhysicalDeviceImageFormatProperties,
            .createDevice => PfnCreateDevice,
            .enumerateDeviceLayerProperties => PfnEnumerateDeviceLayerProperties,
            .enumerateDeviceExtensionProperties => PfnEnumerateDeviceExtensionProperties,
            .getPhysicalDeviceSparseImageFormatProperties => PfnGetPhysicalDeviceSparseImageFormatProperties,
            .createAndroidSurfaceKHR => PfnCreateAndroidSurfaceKHR,
            .getPhysicalDeviceDisplayPropertiesKHR => PfnGetPhysicalDeviceDisplayPropertiesKHR,
            .getPhysicalDeviceDisplayPlanePropertiesKHR => PfnGetPhysicalDeviceDisplayPlanePropertiesKHR,
            .getDisplayPlaneSupportedDisplaysKHR => PfnGetDisplayPlaneSupportedDisplaysKHR,
            .getDisplayModePropertiesKHR => PfnGetDisplayModePropertiesKHR,
            .createDisplayModeKHR => PfnCreateDisplayModeKHR,
            .getDisplayPlaneCapabilitiesKHR => PfnGetDisplayPlaneCapabilitiesKHR,
            .createDisplayPlaneSurfaceKHR => PfnCreateDisplayPlaneSurfaceKHR,
            .destroySurfaceKHR => PfnDestroySurfaceKHR,
            .getPhysicalDeviceSurfaceSupportKHR => PfnGetPhysicalDeviceSurfaceSupportKHR,
            .getPhysicalDeviceSurfaceCapabilitiesKHR => PfnGetPhysicalDeviceSurfaceCapabilitiesKHR,
            .getPhysicalDeviceSurfaceFormatsKHR => PfnGetPhysicalDeviceSurfaceFormatsKHR,
            .getPhysicalDeviceSurfacePresentModesKHR => PfnGetPhysicalDeviceSurfacePresentModesKHR,
            .createViSurfaceNN => PfnCreateViSurfaceNN,
            .createWaylandSurfaceKHR => PfnCreateWaylandSurfaceKHR,
            .getPhysicalDeviceWaylandPresentationSupportKHR => PfnGetPhysicalDeviceWaylandPresentationSupportKHR,
            .createWin32SurfaceKHR => PfnCreateWin32SurfaceKHR,
            .getPhysicalDeviceWin32PresentationSupportKHR => PfnGetPhysicalDeviceWin32PresentationSupportKHR,
            .createXlibSurfaceKHR => PfnCreateXlibSurfaceKHR,
            .getPhysicalDeviceXlibPresentationSupportKHR => PfnGetPhysicalDeviceXlibPresentationSupportKHR,
            .createXcbSurfaceKHR => PfnCreateXcbSurfaceKHR,
            .getPhysicalDeviceXcbPresentationSupportKHR => PfnGetPhysicalDeviceXcbPresentationSupportKHR,
            .createDirectFbSurfaceEXT => PfnCreateDirectFBSurfaceEXT,
            .getPhysicalDeviceDirectFbPresentationSupportEXT => PfnGetPhysicalDeviceDirectFBPresentationSupportEXT,
            .createImagePipeSurfaceFUCHSIA => PfnCreateImagePipeSurfaceFUCHSIA,
            .createStreamDescriptorSurfaceGGP => PfnCreateStreamDescriptorSurfaceGGP,
            .createScreenSurfaceQNX => PfnCreateScreenSurfaceQNX,
            .getPhysicalDeviceScreenPresentationSupportQNX => PfnGetPhysicalDeviceScreenPresentationSupportQNX,
            .createDebugReportCallbackEXT => PfnCreateDebugReportCallbackEXT,
            .destroyDebugReportCallbackEXT => PfnDestroyDebugReportCallbackEXT,
            .debugReportMessageEXT => PfnDebugReportMessageEXT,
            .getPhysicalDeviceExternalImageFormatPropertiesNV => PfnGetPhysicalDeviceExternalImageFormatPropertiesNV,
            .getPhysicalDeviceFeatures2 => PfnGetPhysicalDeviceFeatures2,
            .getPhysicalDeviceProperties2 => PfnGetPhysicalDeviceProperties2,
            .getPhysicalDeviceFormatProperties2 => PfnGetPhysicalDeviceFormatProperties2,
            .getPhysicalDeviceImageFormatProperties2 => PfnGetPhysicalDeviceImageFormatProperties2,
            .getPhysicalDeviceQueueFamilyProperties2 => PfnGetPhysicalDeviceQueueFamilyProperties2,
            .getPhysicalDeviceMemoryProperties2 => PfnGetPhysicalDeviceMemoryProperties2,
            .getPhysicalDeviceSparseImageFormatProperties2 => PfnGetPhysicalDeviceSparseImageFormatProperties2,
            .getPhysicalDeviceExternalBufferProperties => PfnGetPhysicalDeviceExternalBufferProperties,
            .getPhysicalDeviceExternalSemaphoreProperties => PfnGetPhysicalDeviceExternalSemaphoreProperties,
            .getPhysicalDeviceExternalFenceProperties => PfnGetPhysicalDeviceExternalFenceProperties,
            .releaseDisplayEXT => PfnReleaseDisplayEXT,
            .acquireXlibDisplayEXT => PfnAcquireXlibDisplayEXT,
            .getRandROutputDisplayEXT => PfnGetRandROutputDisplayEXT,
            .acquireWinrtDisplayNV => PfnAcquireWinrtDisplayNV,
            .getWinrtDisplayNV => PfnGetWinrtDisplayNV,
            .getPhysicalDeviceSurfaceCapabilities2EXT => PfnGetPhysicalDeviceSurfaceCapabilities2EXT,
            .enumeratePhysicalDeviceGroups => PfnEnumeratePhysicalDeviceGroups,
            .getPhysicalDevicePresentRectanglesKHR => PfnGetPhysicalDevicePresentRectanglesKHR,
            .createIosSurfaceMVK => PfnCreateIOSSurfaceMVK,
            .createMacOsSurfaceMVK => PfnCreateMacOSSurfaceMVK,
            .createMetalSurfaceEXT => PfnCreateMetalSurfaceEXT,
            .getPhysicalDeviceMultisamplePropertiesEXT => PfnGetPhysicalDeviceMultisamplePropertiesEXT,
            .getPhysicalDeviceSurfaceCapabilities2KHR => PfnGetPhysicalDeviceSurfaceCapabilities2KHR,
            .getPhysicalDeviceSurfaceFormats2KHR => PfnGetPhysicalDeviceSurfaceFormats2KHR,
            .getPhysicalDeviceDisplayProperties2KHR => PfnGetPhysicalDeviceDisplayProperties2KHR,
            .getPhysicalDeviceDisplayPlaneProperties2KHR => PfnGetPhysicalDeviceDisplayPlaneProperties2KHR,
            .getDisplayModeProperties2KHR => PfnGetDisplayModeProperties2KHR,
            .getDisplayPlaneCapabilities2KHR => PfnGetDisplayPlaneCapabilities2KHR,
            .getPhysicalDeviceCalibrateableTimeDomainsEXT => PfnGetPhysicalDeviceCalibrateableTimeDomainsEXT,
            .createDebugUtilsMessengerEXT => PfnCreateDebugUtilsMessengerEXT,
            .destroyDebugUtilsMessengerEXT => PfnDestroyDebugUtilsMessengerEXT,
            .submitDebugUtilsMessageEXT => PfnSubmitDebugUtilsMessageEXT,
            .getPhysicalDeviceCooperativeMatrixPropertiesNV => PfnGetPhysicalDeviceCooperativeMatrixPropertiesNV,
            .getPhysicalDeviceSurfacePresentModes2EXT => PfnGetPhysicalDeviceSurfacePresentModes2EXT,
            .enumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR => PfnEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR,
            .getPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR => PfnGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR,
            .createHeadlessSurfaceEXT => PfnCreateHeadlessSurfaceEXT,
            .getPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV => PfnGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV,
            .getPhysicalDeviceToolPropertiesEXT => PfnGetPhysicalDeviceToolPropertiesEXT,
            .getPhysicalDeviceFragmentShadingRatesKHR => PfnGetPhysicalDeviceFragmentShadingRatesKHR,
            .getPhysicalDeviceVideoCapabilitiesKHR => PfnGetPhysicalDeviceVideoCapabilitiesKHR,
            .getPhysicalDeviceVideoFormatPropertiesKHR => PfnGetPhysicalDeviceVideoFormatPropertiesKHR,
            .acquireDrmDisplayEXT => PfnAcquireDrmDisplayEXT,
            .getDrmDisplayEXT => PfnGetDrmDisplayEXT,
        };
    }
};
pub const DeviceCommand = enum {
    destroyDevice,
    getDeviceQueue,
    queueSubmit,
    queueWaitIdle,
    deviceWaitIdle,
    allocateMemory,
    freeMemory,
    mapMemory,
    unmapMemory,
    flushMappedMemoryRanges,
    invalidateMappedMemoryRanges,
    getDeviceMemoryCommitment,
    getBufferMemoryRequirements,
    bindBufferMemory,
    getImageMemoryRequirements,
    bindImageMemory,
    getImageSparseMemoryRequirements,
    queueBindSparse,
    createFence,
    destroyFence,
    resetFences,
    getFenceStatus,
    waitForFences,
    createSemaphore,
    destroySemaphore,
    createEvent,
    destroyEvent,
    getEventStatus,
    setEvent,
    resetEvent,
    createQueryPool,
    destroyQueryPool,
    getQueryPoolResults,
    resetQueryPool,
    createBuffer,
    destroyBuffer,
    createBufferView,
    destroyBufferView,
    createImage,
    destroyImage,
    getImageSubresourceLayout,
    createImageView,
    destroyImageView,
    createShaderModule,
    destroyShaderModule,
    createPipelineCache,
    destroyPipelineCache,
    getPipelineCacheData,
    mergePipelineCaches,
    createGraphicsPipelines,
    createComputePipelines,
    getDeviceSubpassShadingMaxWorkgroupSizeHUAWEI,
    destroyPipeline,
    createPipelineLayout,
    destroyPipelineLayout,
    createSampler,
    destroySampler,
    createDescriptorSetLayout,
    destroyDescriptorSetLayout,
    createDescriptorPool,
    destroyDescriptorPool,
    resetDescriptorPool,
    allocateDescriptorSets,
    freeDescriptorSets,
    updateDescriptorSets,
    createFramebuffer,
    destroyFramebuffer,
    createRenderPass,
    destroyRenderPass,
    getRenderAreaGranularity,
    createCommandPool,
    destroyCommandPool,
    resetCommandPool,
    allocateCommandBuffers,
    freeCommandBuffers,
    beginCommandBuffer,
    endCommandBuffer,
    resetCommandBuffer,
    cmdBindPipeline,
    cmdSetViewport,
    cmdSetScissor,
    cmdSetLineWidth,
    cmdSetDepthBias,
    cmdSetBlendConstants,
    cmdSetDepthBounds,
    cmdSetStencilCompareMask,
    cmdSetStencilWriteMask,
    cmdSetStencilReference,
    cmdBindDescriptorSets,
    cmdBindIndexBuffer,
    cmdBindVertexBuffers,
    cmdDraw,
    cmdDrawIndexed,
    cmdDrawMultiEXT,
    cmdDrawMultiIndexedEXT,
    cmdDrawIndirect,
    cmdDrawIndexedIndirect,
    cmdDispatch,
    cmdDispatchIndirect,
    cmdSubpassShadingHUAWEI,
    cmdCopyBuffer,
    cmdCopyImage,
    cmdBlitImage,
    cmdCopyBufferToImage,
    cmdCopyImageToBuffer,
    cmdUpdateBuffer,
    cmdFillBuffer,
    cmdClearColorImage,
    cmdClearDepthStencilImage,
    cmdClearAttachments,
    cmdResolveImage,
    cmdSetEvent,
    cmdResetEvent,
    cmdWaitEvents,
    cmdPipelineBarrier,
    cmdBeginQuery,
    cmdEndQuery,
    cmdBeginConditionalRenderingEXT,
    cmdEndConditionalRenderingEXT,
    cmdResetQueryPool,
    cmdWriteTimestamp,
    cmdCopyQueryPoolResults,
    cmdPushConstants,
    cmdBeginRenderPass,
    cmdNextSubpass,
    cmdEndRenderPass,
    cmdExecuteCommands,
    createSharedSwapchainsKHR,
    createSwapchainKHR,
    destroySwapchainKHR,
    getSwapchainImagesKHR,
    acquireNextImageKHR,
    queuePresentKHR,
    debugMarkerSetObjectNameEXT,
    debugMarkerSetObjectTagEXT,
    cmdDebugMarkerBeginEXT,
    cmdDebugMarkerEndEXT,
    cmdDebugMarkerInsertEXT,
    getMemoryWin32HandleNV,
    cmdExecuteGeneratedCommandsNV,
    cmdPreprocessGeneratedCommandsNV,
    cmdBindPipelineShaderGroupNV,
    getGeneratedCommandsMemoryRequirementsNV,
    createIndirectCommandsLayoutNV,
    destroyIndirectCommandsLayoutNV,
    cmdPushDescriptorSetKHR,
    trimCommandPool,
    getMemoryWin32HandleKHR,
    getMemoryWin32HandlePropertiesKHR,
    getMemoryFdKHR,
    getMemoryFdPropertiesKHR,
    getMemoryZirconHandleFUCHSIA,
    getMemoryZirconHandlePropertiesFUCHSIA,
    getMemoryRemoteAddressNV,
    getSemaphoreWin32HandleKHR,
    importSemaphoreWin32HandleKHR,
    getSemaphoreFdKHR,
    importSemaphoreFdKHR,
    getSemaphoreZirconHandleFUCHSIA,
    importSemaphoreZirconHandleFUCHSIA,
    getFenceWin32HandleKHR,
    importFenceWin32HandleKHR,
    getFenceFdKHR,
    importFenceFdKHR,
    displayPowerControlEXT,
    registerDeviceEventEXT,
    registerDisplayEventEXT,
    getSwapchainCounterEXT,
    getDeviceGroupPeerMemoryFeatures,
    bindBufferMemory2,
    bindImageMemory2,
    cmdSetDeviceMask,
    getDeviceGroupPresentCapabilitiesKHR,
    getDeviceGroupSurfacePresentModesKHR,
    acquireNextImage2KHR,
    cmdDispatchBase,
    createDescriptorUpdateTemplate,
    destroyDescriptorUpdateTemplate,
    updateDescriptorSetWithTemplate,
    cmdPushDescriptorSetWithTemplateKHR,
    setHdrMetadataEXT,
    getSwapchainStatusKHR,
    getRefreshCycleDurationGOOGLE,
    getPastPresentationTimingGOOGLE,
    cmdSetViewportWScalingNV,
    cmdSetDiscardRectangleEXT,
    cmdSetSampleLocationsEXT,
    getBufferMemoryRequirements2,
    getImageMemoryRequirements2,
    getImageSparseMemoryRequirements2,
    getDeviceBufferMemoryRequirementsKHR,
    getDeviceImageMemoryRequirementsKHR,
    getDeviceImageSparseMemoryRequirementsKHR,
    createSamplerYcbcrConversion,
    destroySamplerYcbcrConversion,
    getDeviceQueue2,
    createValidationCacheEXT,
    destroyValidationCacheEXT,
    getValidationCacheDataEXT,
    mergeValidationCachesEXT,
    getDescriptorSetLayoutSupport,
    getSwapchainGrallocUsageANDROID,
    getSwapchainGrallocUsage2ANDROID,
    acquireImageANDROID,
    queueSignalReleaseImageANDROID,
    getShaderInfoAMD,
    setLocalDimmingAMD,
    getCalibratedTimestampsEXT,
    setDebugUtilsObjectNameEXT,
    setDebugUtilsObjectTagEXT,
    queueBeginDebugUtilsLabelEXT,
    queueEndDebugUtilsLabelEXT,
    queueInsertDebugUtilsLabelEXT,
    cmdBeginDebugUtilsLabelEXT,
    cmdEndDebugUtilsLabelEXT,
    cmdInsertDebugUtilsLabelEXT,
    getMemoryHostPointerPropertiesEXT,
    cmdWriteBufferMarkerAMD,
    createRenderPass2,
    cmdBeginRenderPass2,
    cmdNextSubpass2,
    cmdEndRenderPass2,
    getSemaphoreCounterValue,
    waitSemaphores,
    signalSemaphore,
    getAndroidHardwareBufferPropertiesANDROID,
    getMemoryAndroidHardwareBufferANDROID,
    cmdDrawIndirectCount,
    cmdDrawIndexedIndirectCount,
    cmdSetCheckpointNV,
    getQueueCheckpointDataNV,
    cmdBindTransformFeedbackBuffersEXT,
    cmdBeginTransformFeedbackEXT,
    cmdEndTransformFeedbackEXT,
    cmdBeginQueryIndexedEXT,
    cmdEndQueryIndexedEXT,
    cmdDrawIndirectByteCountEXT,
    cmdSetExclusiveScissorNV,
    cmdBindShadingRateImageNV,
    cmdSetViewportShadingRatePaletteNV,
    cmdSetCoarseSampleOrderNV,
    cmdDrawMeshTasksNV,
    cmdDrawMeshTasksIndirectNV,
    cmdDrawMeshTasksIndirectCountNV,
    compileDeferredNV,
    createAccelerationStructureNV,
    cmdBindInvocationMaskHUAWEI,
    destroyAccelerationStructureKHR,
    destroyAccelerationStructureNV,
    getAccelerationStructureMemoryRequirementsNV,
    bindAccelerationStructureMemoryNV,
    cmdCopyAccelerationStructureNV,
    cmdCopyAccelerationStructureKHR,
    copyAccelerationStructureKHR,
    cmdCopyAccelerationStructureToMemoryKHR,
    copyAccelerationStructureToMemoryKHR,
    cmdCopyMemoryToAccelerationStructureKHR,
    copyMemoryToAccelerationStructureKHR,
    cmdWriteAccelerationStructuresPropertiesKHR,
    cmdWriteAccelerationStructuresPropertiesNV,
    cmdBuildAccelerationStructureNV,
    writeAccelerationStructuresPropertiesKHR,
    cmdTraceRaysKHR,
    cmdTraceRaysNV,
    getRayTracingShaderGroupHandlesKHR,
    getRayTracingCaptureReplayShaderGroupHandlesKHR,
    getAccelerationStructureHandleNV,
    createRayTracingPipelinesNV,
    createRayTracingPipelinesKHR,
    cmdTraceRaysIndirectKHR,
    getDeviceAccelerationStructureCompatibilityKHR,
    getRayTracingShaderGroupStackSizeKHR,
    cmdSetRayTracingPipelineStackSizeKHR,
    getImageViewHandleNVX,
    getImageViewAddressNVX,
    getDeviceGroupSurfacePresentModes2EXT,
    acquireFullScreenExclusiveModeEXT,
    releaseFullScreenExclusiveModeEXT,
    acquireProfilingLockKHR,
    releaseProfilingLockKHR,
    getImageDrmFormatModifierPropertiesEXT,
    getBufferOpaqueCaptureAddress,
    getBufferDeviceAddress,
    initializePerformanceApiINTEL,
    uninitializePerformanceApiINTEL,
    cmdSetPerformanceMarkerINTEL,
    cmdSetPerformanceStreamMarkerINTEL,
    cmdSetPerformanceOverrideINTEL,
    acquirePerformanceConfigurationINTEL,
    releasePerformanceConfigurationINTEL,
    queueSetPerformanceConfigurationINTEL,
    getPerformanceParameterINTEL,
    getDeviceMemoryOpaqueCaptureAddress,
    getPipelineExecutablePropertiesKHR,
    getPipelineExecutableStatisticsKHR,
    getPipelineExecutableInternalRepresentationsKHR,
    cmdSetLineStippleEXT,
    createAccelerationStructureKHR,
    cmdBuildAccelerationStructuresKHR,
    cmdBuildAccelerationStructuresIndirectKHR,
    buildAccelerationStructuresKHR,
    getAccelerationStructureDeviceAddressKHR,
    createDeferredOperationKHR,
    destroyDeferredOperationKHR,
    getDeferredOperationMaxConcurrencyKHR,
    getDeferredOperationResultKHR,
    deferredOperationJoinKHR,
    cmdSetCullModeEXT,
    cmdSetFrontFaceEXT,
    cmdSetPrimitiveTopologyEXT,
    cmdSetViewportWithCountEXT,
    cmdSetScissorWithCountEXT,
    cmdBindVertexBuffers2EXT,
    cmdSetDepthTestEnableEXT,
    cmdSetDepthWriteEnableEXT,
    cmdSetDepthCompareOpEXT,
    cmdSetDepthBoundsTestEnableEXT,
    cmdSetStencilTestEnableEXT,
    cmdSetStencilOpEXT,
    cmdSetPatchControlPointsEXT,
    cmdSetRasterizerDiscardEnableEXT,
    cmdSetDepthBiasEnableEXT,
    cmdSetLogicOpEXT,
    cmdSetPrimitiveRestartEnableEXT,
    createPrivateDataSlotEXT,
    destroyPrivateDataSlotEXT,
    setPrivateDataEXT,
    getPrivateDataEXT,
    cmdCopyBuffer2KHR,
    cmdCopyImage2KHR,
    cmdBlitImage2KHR,
    cmdCopyBufferToImage2KHR,
    cmdCopyImageToBuffer2KHR,
    cmdResolveImage2KHR,
    cmdSetFragmentShadingRateKHR,
    cmdSetFragmentShadingRateEnumNV,
    getAccelerationStructureBuildSizesKHR,
    cmdSetVertexInputEXT,
    cmdSetColorWriteEnableEXT,
    cmdSetEvent2KHR,
    cmdResetEvent2KHR,
    cmdWaitEvents2KHR,
    cmdPipelineBarrier2KHR,
    queueSubmit2KHR,
    cmdWriteTimestamp2KHR,
    cmdWriteBufferMarker2AMD,
    getQueueCheckpointData2NV,
    createVideoSessionKHR,
    destroyVideoSessionKHR,
    createVideoSessionParametersKHR,
    updateVideoSessionParametersKHR,
    destroyVideoSessionParametersKHR,
    getVideoSessionMemoryRequirementsKHR,
    bindVideoSessionMemoryKHR,
    cmdDecodeVideoKHR,
    cmdBeginVideoCodingKHR,
    cmdControlVideoCodingKHR,
    cmdEndVideoCodingKHR,
    cmdEncodeVideoKHR,
    createCuModuleNVX,
    createCuFunctionNVX,
    destroyCuModuleNVX,
    destroyCuFunctionNVX,
    cmdCuLaunchKernelNVX,
    setDeviceMemoryPriorityEXT,
    waitForPresentKHR,
    createBufferCollectionFUCHSIA,
    setBufferCollectionBufferConstraintsFUCHSIA,
    setBufferCollectionImageConstraintsFUCHSIA,
    destroyBufferCollectionFUCHSIA,
    getBufferCollectionPropertiesFUCHSIA,

    pub fn symbol(self: DeviceCommand) [:0]const u8 {
        return switch (self) {
            .destroyDevice => "vkDestroyDevice",
            .getDeviceQueue => "vkGetDeviceQueue",
            .queueSubmit => "vkQueueSubmit",
            .queueWaitIdle => "vkQueueWaitIdle",
            .deviceWaitIdle => "vkDeviceWaitIdle",
            .allocateMemory => "vkAllocateMemory",
            .freeMemory => "vkFreeMemory",
            .mapMemory => "vkMapMemory",
            .unmapMemory => "vkUnmapMemory",
            .flushMappedMemoryRanges => "vkFlushMappedMemoryRanges",
            .invalidateMappedMemoryRanges => "vkInvalidateMappedMemoryRanges",
            .getDeviceMemoryCommitment => "vkGetDeviceMemoryCommitment",
            .getBufferMemoryRequirements => "vkGetBufferMemoryRequirements",
            .bindBufferMemory => "vkBindBufferMemory",
            .getImageMemoryRequirements => "vkGetImageMemoryRequirements",
            .bindImageMemory => "vkBindImageMemory",
            .getImageSparseMemoryRequirements => "vkGetImageSparseMemoryRequirements",
            .queueBindSparse => "vkQueueBindSparse",
            .createFence => "vkCreateFence",
            .destroyFence => "vkDestroyFence",
            .resetFences => "vkResetFences",
            .getFenceStatus => "vkGetFenceStatus",
            .waitForFences => "vkWaitForFences",
            .createSemaphore => "vkCreateSemaphore",
            .destroySemaphore => "vkDestroySemaphore",
            .createEvent => "vkCreateEvent",
            .destroyEvent => "vkDestroyEvent",
            .getEventStatus => "vkGetEventStatus",
            .setEvent => "vkSetEvent",
            .resetEvent => "vkResetEvent",
            .createQueryPool => "vkCreateQueryPool",
            .destroyQueryPool => "vkDestroyQueryPool",
            .getQueryPoolResults => "vkGetQueryPoolResults",
            .resetQueryPool => "vkResetQueryPool",
            .createBuffer => "vkCreateBuffer",
            .destroyBuffer => "vkDestroyBuffer",
            .createBufferView => "vkCreateBufferView",
            .destroyBufferView => "vkDestroyBufferView",
            .createImage => "vkCreateImage",
            .destroyImage => "vkDestroyImage",
            .getImageSubresourceLayout => "vkGetImageSubresourceLayout",
            .createImageView => "vkCreateImageView",
            .destroyImageView => "vkDestroyImageView",
            .createShaderModule => "vkCreateShaderModule",
            .destroyShaderModule => "vkDestroyShaderModule",
            .createPipelineCache => "vkCreatePipelineCache",
            .destroyPipelineCache => "vkDestroyPipelineCache",
            .getPipelineCacheData => "vkGetPipelineCacheData",
            .mergePipelineCaches => "vkMergePipelineCaches",
            .createGraphicsPipelines => "vkCreateGraphicsPipelines",
            .createComputePipelines => "vkCreateComputePipelines",
            .getDeviceSubpassShadingMaxWorkgroupSizeHUAWEI => "vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI",
            .destroyPipeline => "vkDestroyPipeline",
            .createPipelineLayout => "vkCreatePipelineLayout",
            .destroyPipelineLayout => "vkDestroyPipelineLayout",
            .createSampler => "vkCreateSampler",
            .destroySampler => "vkDestroySampler",
            .createDescriptorSetLayout => "vkCreateDescriptorSetLayout",
            .destroyDescriptorSetLayout => "vkDestroyDescriptorSetLayout",
            .createDescriptorPool => "vkCreateDescriptorPool",
            .destroyDescriptorPool => "vkDestroyDescriptorPool",
            .resetDescriptorPool => "vkResetDescriptorPool",
            .allocateDescriptorSets => "vkAllocateDescriptorSets",
            .freeDescriptorSets => "vkFreeDescriptorSets",
            .updateDescriptorSets => "vkUpdateDescriptorSets",
            .createFramebuffer => "vkCreateFramebuffer",
            .destroyFramebuffer => "vkDestroyFramebuffer",
            .createRenderPass => "vkCreateRenderPass",
            .destroyRenderPass => "vkDestroyRenderPass",
            .getRenderAreaGranularity => "vkGetRenderAreaGranularity",
            .createCommandPool => "vkCreateCommandPool",
            .destroyCommandPool => "vkDestroyCommandPool",
            .resetCommandPool => "vkResetCommandPool",
            .allocateCommandBuffers => "vkAllocateCommandBuffers",
            .freeCommandBuffers => "vkFreeCommandBuffers",
            .beginCommandBuffer => "vkBeginCommandBuffer",
            .endCommandBuffer => "vkEndCommandBuffer",
            .resetCommandBuffer => "vkResetCommandBuffer",
            .cmdBindPipeline => "vkCmdBindPipeline",
            .cmdSetViewport => "vkCmdSetViewport",
            .cmdSetScissor => "vkCmdSetScissor",
            .cmdSetLineWidth => "vkCmdSetLineWidth",
            .cmdSetDepthBias => "vkCmdSetDepthBias",
            .cmdSetBlendConstants => "vkCmdSetBlendConstants",
            .cmdSetDepthBounds => "vkCmdSetDepthBounds",
            .cmdSetStencilCompareMask => "vkCmdSetStencilCompareMask",
            .cmdSetStencilWriteMask => "vkCmdSetStencilWriteMask",
            .cmdSetStencilReference => "vkCmdSetStencilReference",
            .cmdBindDescriptorSets => "vkCmdBindDescriptorSets",
            .cmdBindIndexBuffer => "vkCmdBindIndexBuffer",
            .cmdBindVertexBuffers => "vkCmdBindVertexBuffers",
            .cmdDraw => "vkCmdDraw",
            .cmdDrawIndexed => "vkCmdDrawIndexed",
            .cmdDrawMultiEXT => "vkCmdDrawMultiEXT",
            .cmdDrawMultiIndexedEXT => "vkCmdDrawMultiIndexedEXT",
            .cmdDrawIndirect => "vkCmdDrawIndirect",
            .cmdDrawIndexedIndirect => "vkCmdDrawIndexedIndirect",
            .cmdDispatch => "vkCmdDispatch",
            .cmdDispatchIndirect => "vkCmdDispatchIndirect",
            .cmdSubpassShadingHUAWEI => "vkCmdSubpassShadingHUAWEI",
            .cmdCopyBuffer => "vkCmdCopyBuffer",
            .cmdCopyImage => "vkCmdCopyImage",
            .cmdBlitImage => "vkCmdBlitImage",
            .cmdCopyBufferToImage => "vkCmdCopyBufferToImage",
            .cmdCopyImageToBuffer => "vkCmdCopyImageToBuffer",
            .cmdUpdateBuffer => "vkCmdUpdateBuffer",
            .cmdFillBuffer => "vkCmdFillBuffer",
            .cmdClearColorImage => "vkCmdClearColorImage",
            .cmdClearDepthStencilImage => "vkCmdClearDepthStencilImage",
            .cmdClearAttachments => "vkCmdClearAttachments",
            .cmdResolveImage => "vkCmdResolveImage",
            .cmdSetEvent => "vkCmdSetEvent",
            .cmdResetEvent => "vkCmdResetEvent",
            .cmdWaitEvents => "vkCmdWaitEvents",
            .cmdPipelineBarrier => "vkCmdPipelineBarrier",
            .cmdBeginQuery => "vkCmdBeginQuery",
            .cmdEndQuery => "vkCmdEndQuery",
            .cmdBeginConditionalRenderingEXT => "vkCmdBeginConditionalRenderingEXT",
            .cmdEndConditionalRenderingEXT => "vkCmdEndConditionalRenderingEXT",
            .cmdResetQueryPool => "vkCmdResetQueryPool",
            .cmdWriteTimestamp => "vkCmdWriteTimestamp",
            .cmdCopyQueryPoolResults => "vkCmdCopyQueryPoolResults",
            .cmdPushConstants => "vkCmdPushConstants",
            .cmdBeginRenderPass => "vkCmdBeginRenderPass",
            .cmdNextSubpass => "vkCmdNextSubpass",
            .cmdEndRenderPass => "vkCmdEndRenderPass",
            .cmdExecuteCommands => "vkCmdExecuteCommands",
            .createSharedSwapchainsKHR => "vkCreateSharedSwapchainsKHR",
            .createSwapchainKHR => "vkCreateSwapchainKHR",
            .destroySwapchainKHR => "vkDestroySwapchainKHR",
            .getSwapchainImagesKHR => "vkGetSwapchainImagesKHR",
            .acquireNextImageKHR => "vkAcquireNextImageKHR",
            .queuePresentKHR => "vkQueuePresentKHR",
            .debugMarkerSetObjectNameEXT => "vkDebugMarkerSetObjectNameEXT",
            .debugMarkerSetObjectTagEXT => "vkDebugMarkerSetObjectTagEXT",
            .cmdDebugMarkerBeginEXT => "vkCmdDebugMarkerBeginEXT",
            .cmdDebugMarkerEndEXT => "vkCmdDebugMarkerEndEXT",
            .cmdDebugMarkerInsertEXT => "vkCmdDebugMarkerInsertEXT",
            .getMemoryWin32HandleNV => "vkGetMemoryWin32HandleNV",
            .cmdExecuteGeneratedCommandsNV => "vkCmdExecuteGeneratedCommandsNV",
            .cmdPreprocessGeneratedCommandsNV => "vkCmdPreprocessGeneratedCommandsNV",
            .cmdBindPipelineShaderGroupNV => "vkCmdBindPipelineShaderGroupNV",
            .getGeneratedCommandsMemoryRequirementsNV => "vkGetGeneratedCommandsMemoryRequirementsNV",
            .createIndirectCommandsLayoutNV => "vkCreateIndirectCommandsLayoutNV",
            .destroyIndirectCommandsLayoutNV => "vkDestroyIndirectCommandsLayoutNV",
            .cmdPushDescriptorSetKHR => "vkCmdPushDescriptorSetKHR",
            .trimCommandPool => "vkTrimCommandPool",
            .getMemoryWin32HandleKHR => "vkGetMemoryWin32HandleKHR",
            .getMemoryWin32HandlePropertiesKHR => "vkGetMemoryWin32HandlePropertiesKHR",
            .getMemoryFdKHR => "vkGetMemoryFdKHR",
            .getMemoryFdPropertiesKHR => "vkGetMemoryFdPropertiesKHR",
            .getMemoryZirconHandleFUCHSIA => "vkGetMemoryZirconHandleFUCHSIA",
            .getMemoryZirconHandlePropertiesFUCHSIA => "vkGetMemoryZirconHandlePropertiesFUCHSIA",
            .getMemoryRemoteAddressNV => "vkGetMemoryRemoteAddressNV",
            .getSemaphoreWin32HandleKHR => "vkGetSemaphoreWin32HandleKHR",
            .importSemaphoreWin32HandleKHR => "vkImportSemaphoreWin32HandleKHR",
            .getSemaphoreFdKHR => "vkGetSemaphoreFdKHR",
            .importSemaphoreFdKHR => "vkImportSemaphoreFdKHR",
            .getSemaphoreZirconHandleFUCHSIA => "vkGetSemaphoreZirconHandleFUCHSIA",
            .importSemaphoreZirconHandleFUCHSIA => "vkImportSemaphoreZirconHandleFUCHSIA",
            .getFenceWin32HandleKHR => "vkGetFenceWin32HandleKHR",
            .importFenceWin32HandleKHR => "vkImportFenceWin32HandleKHR",
            .getFenceFdKHR => "vkGetFenceFdKHR",
            .importFenceFdKHR => "vkImportFenceFdKHR",
            .displayPowerControlEXT => "vkDisplayPowerControlEXT",
            .registerDeviceEventEXT => "vkRegisterDeviceEventEXT",
            .registerDisplayEventEXT => "vkRegisterDisplayEventEXT",
            .getSwapchainCounterEXT => "vkGetSwapchainCounterEXT",
            .getDeviceGroupPeerMemoryFeatures => "vkGetDeviceGroupPeerMemoryFeatures",
            .bindBufferMemory2 => "vkBindBufferMemory2",
            .bindImageMemory2 => "vkBindImageMemory2",
            .cmdSetDeviceMask => "vkCmdSetDeviceMask",
            .getDeviceGroupPresentCapabilitiesKHR => "vkGetDeviceGroupPresentCapabilitiesKHR",
            .getDeviceGroupSurfacePresentModesKHR => "vkGetDeviceGroupSurfacePresentModesKHR",
            .acquireNextImage2KHR => "vkAcquireNextImage2KHR",
            .cmdDispatchBase => "vkCmdDispatchBase",
            .createDescriptorUpdateTemplate => "vkCreateDescriptorUpdateTemplate",
            .destroyDescriptorUpdateTemplate => "vkDestroyDescriptorUpdateTemplate",
            .updateDescriptorSetWithTemplate => "vkUpdateDescriptorSetWithTemplate",
            .cmdPushDescriptorSetWithTemplateKHR => "vkCmdPushDescriptorSetWithTemplateKHR",
            .setHdrMetadataEXT => "vkSetHdrMetadataEXT",
            .getSwapchainStatusKHR => "vkGetSwapchainStatusKHR",
            .getRefreshCycleDurationGOOGLE => "vkGetRefreshCycleDurationGOOGLE",
            .getPastPresentationTimingGOOGLE => "vkGetPastPresentationTimingGOOGLE",
            .cmdSetViewportWScalingNV => "vkCmdSetViewportWScalingNV",
            .cmdSetDiscardRectangleEXT => "vkCmdSetDiscardRectangleEXT",
            .cmdSetSampleLocationsEXT => "vkCmdSetSampleLocationsEXT",
            .getBufferMemoryRequirements2 => "vkGetBufferMemoryRequirements2",
            .getImageMemoryRequirements2 => "vkGetImageMemoryRequirements2",
            .getImageSparseMemoryRequirements2 => "vkGetImageSparseMemoryRequirements2",
            .getDeviceBufferMemoryRequirementsKHR => "vkGetDeviceBufferMemoryRequirementsKHR",
            .getDeviceImageMemoryRequirementsKHR => "vkGetDeviceImageMemoryRequirementsKHR",
            .getDeviceImageSparseMemoryRequirementsKHR => "vkGetDeviceImageSparseMemoryRequirementsKHR",
            .createSamplerYcbcrConversion => "vkCreateSamplerYcbcrConversion",
            .destroySamplerYcbcrConversion => "vkDestroySamplerYcbcrConversion",
            .getDeviceQueue2 => "vkGetDeviceQueue2",
            .createValidationCacheEXT => "vkCreateValidationCacheEXT",
            .destroyValidationCacheEXT => "vkDestroyValidationCacheEXT",
            .getValidationCacheDataEXT => "vkGetValidationCacheDataEXT",
            .mergeValidationCachesEXT => "vkMergeValidationCachesEXT",
            .getDescriptorSetLayoutSupport => "vkGetDescriptorSetLayoutSupport",
            .getSwapchainGrallocUsageANDROID => "vkGetSwapchainGrallocUsageANDROID",
            .getSwapchainGrallocUsage2ANDROID => "vkGetSwapchainGrallocUsage2ANDROID",
            .acquireImageANDROID => "vkAcquireImageANDROID",
            .queueSignalReleaseImageANDROID => "vkQueueSignalReleaseImageANDROID",
            .getShaderInfoAMD => "vkGetShaderInfoAMD",
            .setLocalDimmingAMD => "vkSetLocalDimmingAMD",
            .getCalibratedTimestampsEXT => "vkGetCalibratedTimestampsEXT",
            .setDebugUtilsObjectNameEXT => "vkSetDebugUtilsObjectNameEXT",
            .setDebugUtilsObjectTagEXT => "vkSetDebugUtilsObjectTagEXT",
            .queueBeginDebugUtilsLabelEXT => "vkQueueBeginDebugUtilsLabelEXT",
            .queueEndDebugUtilsLabelEXT => "vkQueueEndDebugUtilsLabelEXT",
            .queueInsertDebugUtilsLabelEXT => "vkQueueInsertDebugUtilsLabelEXT",
            .cmdBeginDebugUtilsLabelEXT => "vkCmdBeginDebugUtilsLabelEXT",
            .cmdEndDebugUtilsLabelEXT => "vkCmdEndDebugUtilsLabelEXT",
            .cmdInsertDebugUtilsLabelEXT => "vkCmdInsertDebugUtilsLabelEXT",
            .getMemoryHostPointerPropertiesEXT => "vkGetMemoryHostPointerPropertiesEXT",
            .cmdWriteBufferMarkerAMD => "vkCmdWriteBufferMarkerAMD",
            .createRenderPass2 => "vkCreateRenderPass2",
            .cmdBeginRenderPass2 => "vkCmdBeginRenderPass2",
            .cmdNextSubpass2 => "vkCmdNextSubpass2",
            .cmdEndRenderPass2 => "vkCmdEndRenderPass2",
            .getSemaphoreCounterValue => "vkGetSemaphoreCounterValue",
            .waitSemaphores => "vkWaitSemaphores",
            .signalSemaphore => "vkSignalSemaphore",
            .getAndroidHardwareBufferPropertiesANDROID => "vkGetAndroidHardwareBufferPropertiesANDROID",
            .getMemoryAndroidHardwareBufferANDROID => "vkGetMemoryAndroidHardwareBufferANDROID",
            .cmdDrawIndirectCount => "vkCmdDrawIndirectCount",
            .cmdDrawIndexedIndirectCount => "vkCmdDrawIndexedIndirectCount",
            .cmdSetCheckpointNV => "vkCmdSetCheckpointNV",
            .getQueueCheckpointDataNV => "vkGetQueueCheckpointDataNV",
            .cmdBindTransformFeedbackBuffersEXT => "vkCmdBindTransformFeedbackBuffersEXT",
            .cmdBeginTransformFeedbackEXT => "vkCmdBeginTransformFeedbackEXT",
            .cmdEndTransformFeedbackEXT => "vkCmdEndTransformFeedbackEXT",
            .cmdBeginQueryIndexedEXT => "vkCmdBeginQueryIndexedEXT",
            .cmdEndQueryIndexedEXT => "vkCmdEndQueryIndexedEXT",
            .cmdDrawIndirectByteCountEXT => "vkCmdDrawIndirectByteCountEXT",
            .cmdSetExclusiveScissorNV => "vkCmdSetExclusiveScissorNV",
            .cmdBindShadingRateImageNV => "vkCmdBindShadingRateImageNV",
            .cmdSetViewportShadingRatePaletteNV => "vkCmdSetViewportShadingRatePaletteNV",
            .cmdSetCoarseSampleOrderNV => "vkCmdSetCoarseSampleOrderNV",
            .cmdDrawMeshTasksNV => "vkCmdDrawMeshTasksNV",
            .cmdDrawMeshTasksIndirectNV => "vkCmdDrawMeshTasksIndirectNV",
            .cmdDrawMeshTasksIndirectCountNV => "vkCmdDrawMeshTasksIndirectCountNV",
            .compileDeferredNV => "vkCompileDeferredNV",
            .createAccelerationStructureNV => "vkCreateAccelerationStructureNV",
            .cmdBindInvocationMaskHUAWEI => "vkCmdBindInvocationMaskHUAWEI",
            .destroyAccelerationStructureKHR => "vkDestroyAccelerationStructureKHR",
            .destroyAccelerationStructureNV => "vkDestroyAccelerationStructureNV",
            .getAccelerationStructureMemoryRequirementsNV => "vkGetAccelerationStructureMemoryRequirementsNV",
            .bindAccelerationStructureMemoryNV => "vkBindAccelerationStructureMemoryNV",
            .cmdCopyAccelerationStructureNV => "vkCmdCopyAccelerationStructureNV",
            .cmdCopyAccelerationStructureKHR => "vkCmdCopyAccelerationStructureKHR",
            .copyAccelerationStructureKHR => "vkCopyAccelerationStructureKHR",
            .cmdCopyAccelerationStructureToMemoryKHR => "vkCmdCopyAccelerationStructureToMemoryKHR",
            .copyAccelerationStructureToMemoryKHR => "vkCopyAccelerationStructureToMemoryKHR",
            .cmdCopyMemoryToAccelerationStructureKHR => "vkCmdCopyMemoryToAccelerationStructureKHR",
            .copyMemoryToAccelerationStructureKHR => "vkCopyMemoryToAccelerationStructureKHR",
            .cmdWriteAccelerationStructuresPropertiesKHR => "vkCmdWriteAccelerationStructuresPropertiesKHR",
            .cmdWriteAccelerationStructuresPropertiesNV => "vkCmdWriteAccelerationStructuresPropertiesNV",
            .cmdBuildAccelerationStructureNV => "vkCmdBuildAccelerationStructureNV",
            .writeAccelerationStructuresPropertiesKHR => "vkWriteAccelerationStructuresPropertiesKHR",
            .cmdTraceRaysKHR => "vkCmdTraceRaysKHR",
            .cmdTraceRaysNV => "vkCmdTraceRaysNV",
            .getRayTracingShaderGroupHandlesKHR => "vkGetRayTracingShaderGroupHandlesKHR",
            .getRayTracingCaptureReplayShaderGroupHandlesKHR => "vkGetRayTracingCaptureReplayShaderGroupHandlesKHR",
            .getAccelerationStructureHandleNV => "vkGetAccelerationStructureHandleNV",
            .createRayTracingPipelinesNV => "vkCreateRayTracingPipelinesNV",
            .createRayTracingPipelinesKHR => "vkCreateRayTracingPipelinesKHR",
            .cmdTraceRaysIndirectKHR => "vkCmdTraceRaysIndirectKHR",
            .getDeviceAccelerationStructureCompatibilityKHR => "vkGetDeviceAccelerationStructureCompatibilityKHR",
            .getRayTracingShaderGroupStackSizeKHR => "vkGetRayTracingShaderGroupStackSizeKHR",
            .cmdSetRayTracingPipelineStackSizeKHR => "vkCmdSetRayTracingPipelineStackSizeKHR",
            .getImageViewHandleNVX => "vkGetImageViewHandleNVX",
            .getImageViewAddressNVX => "vkGetImageViewAddressNVX",
            .getDeviceGroupSurfacePresentModes2EXT => "vkGetDeviceGroupSurfacePresentModes2EXT",
            .acquireFullScreenExclusiveModeEXT => "vkAcquireFullScreenExclusiveModeEXT",
            .releaseFullScreenExclusiveModeEXT => "vkReleaseFullScreenExclusiveModeEXT",
            .acquireProfilingLockKHR => "vkAcquireProfilingLockKHR",
            .releaseProfilingLockKHR => "vkReleaseProfilingLockKHR",
            .getImageDrmFormatModifierPropertiesEXT => "vkGetImageDrmFormatModifierPropertiesEXT",
            .getBufferOpaqueCaptureAddress => "vkGetBufferOpaqueCaptureAddress",
            .getBufferDeviceAddress => "vkGetBufferDeviceAddress",
            .initializePerformanceApiINTEL => "vkInitializePerformanceApiINTEL",
            .uninitializePerformanceApiINTEL => "vkUninitializePerformanceApiINTEL",
            .cmdSetPerformanceMarkerINTEL => "vkCmdSetPerformanceMarkerINTEL",
            .cmdSetPerformanceStreamMarkerINTEL => "vkCmdSetPerformanceStreamMarkerINTEL",
            .cmdSetPerformanceOverrideINTEL => "vkCmdSetPerformanceOverrideINTEL",
            .acquirePerformanceConfigurationINTEL => "vkAcquirePerformanceConfigurationINTEL",
            .releasePerformanceConfigurationINTEL => "vkReleasePerformanceConfigurationINTEL",
            .queueSetPerformanceConfigurationINTEL => "vkQueueSetPerformanceConfigurationINTEL",
            .getPerformanceParameterINTEL => "vkGetPerformanceParameterINTEL",
            .getDeviceMemoryOpaqueCaptureAddress => "vkGetDeviceMemoryOpaqueCaptureAddress",
            .getPipelineExecutablePropertiesKHR => "vkGetPipelineExecutablePropertiesKHR",
            .getPipelineExecutableStatisticsKHR => "vkGetPipelineExecutableStatisticsKHR",
            .getPipelineExecutableInternalRepresentationsKHR => "vkGetPipelineExecutableInternalRepresentationsKHR",
            .cmdSetLineStippleEXT => "vkCmdSetLineStippleEXT",
            .createAccelerationStructureKHR => "vkCreateAccelerationStructureKHR",
            .cmdBuildAccelerationStructuresKHR => "vkCmdBuildAccelerationStructuresKHR",
            .cmdBuildAccelerationStructuresIndirectKHR => "vkCmdBuildAccelerationStructuresIndirectKHR",
            .buildAccelerationStructuresKHR => "vkBuildAccelerationStructuresKHR",
            .getAccelerationStructureDeviceAddressKHR => "vkGetAccelerationStructureDeviceAddressKHR",
            .createDeferredOperationKHR => "vkCreateDeferredOperationKHR",
            .destroyDeferredOperationKHR => "vkDestroyDeferredOperationKHR",
            .getDeferredOperationMaxConcurrencyKHR => "vkGetDeferredOperationMaxConcurrencyKHR",
            .getDeferredOperationResultKHR => "vkGetDeferredOperationResultKHR",
            .deferredOperationJoinKHR => "vkDeferredOperationJoinKHR",
            .cmdSetCullModeEXT => "vkCmdSetCullModeEXT",
            .cmdSetFrontFaceEXT => "vkCmdSetFrontFaceEXT",
            .cmdSetPrimitiveTopologyEXT => "vkCmdSetPrimitiveTopologyEXT",
            .cmdSetViewportWithCountEXT => "vkCmdSetViewportWithCountEXT",
            .cmdSetScissorWithCountEXT => "vkCmdSetScissorWithCountEXT",
            .cmdBindVertexBuffers2EXT => "vkCmdBindVertexBuffers2EXT",
            .cmdSetDepthTestEnableEXT => "vkCmdSetDepthTestEnableEXT",
            .cmdSetDepthWriteEnableEXT => "vkCmdSetDepthWriteEnableEXT",
            .cmdSetDepthCompareOpEXT => "vkCmdSetDepthCompareOpEXT",
            .cmdSetDepthBoundsTestEnableEXT => "vkCmdSetDepthBoundsTestEnableEXT",
            .cmdSetStencilTestEnableEXT => "vkCmdSetStencilTestEnableEXT",
            .cmdSetStencilOpEXT => "vkCmdSetStencilOpEXT",
            .cmdSetPatchControlPointsEXT => "vkCmdSetPatchControlPointsEXT",
            .cmdSetRasterizerDiscardEnableEXT => "vkCmdSetRasterizerDiscardEnableEXT",
            .cmdSetDepthBiasEnableEXT => "vkCmdSetDepthBiasEnableEXT",
            .cmdSetLogicOpEXT => "vkCmdSetLogicOpEXT",
            .cmdSetPrimitiveRestartEnableEXT => "vkCmdSetPrimitiveRestartEnableEXT",
            .createPrivateDataSlotEXT => "vkCreatePrivateDataSlotEXT",
            .destroyPrivateDataSlotEXT => "vkDestroyPrivateDataSlotEXT",
            .setPrivateDataEXT => "vkSetPrivateDataEXT",
            .getPrivateDataEXT => "vkGetPrivateDataEXT",
            .cmdCopyBuffer2KHR => "vkCmdCopyBuffer2KHR",
            .cmdCopyImage2KHR => "vkCmdCopyImage2KHR",
            .cmdBlitImage2KHR => "vkCmdBlitImage2KHR",
            .cmdCopyBufferToImage2KHR => "vkCmdCopyBufferToImage2KHR",
            .cmdCopyImageToBuffer2KHR => "vkCmdCopyImageToBuffer2KHR",
            .cmdResolveImage2KHR => "vkCmdResolveImage2KHR",
            .cmdSetFragmentShadingRateKHR => "vkCmdSetFragmentShadingRateKHR",
            .cmdSetFragmentShadingRateEnumNV => "vkCmdSetFragmentShadingRateEnumNV",
            .getAccelerationStructureBuildSizesKHR => "vkGetAccelerationStructureBuildSizesKHR",
            .cmdSetVertexInputEXT => "vkCmdSetVertexInputEXT",
            .cmdSetColorWriteEnableEXT => "vkCmdSetColorWriteEnableEXT",
            .cmdSetEvent2KHR => "vkCmdSetEvent2KHR",
            .cmdResetEvent2KHR => "vkCmdResetEvent2KHR",
            .cmdWaitEvents2KHR => "vkCmdWaitEvents2KHR",
            .cmdPipelineBarrier2KHR => "vkCmdPipelineBarrier2KHR",
            .queueSubmit2KHR => "vkQueueSubmit2KHR",
            .cmdWriteTimestamp2KHR => "vkCmdWriteTimestamp2KHR",
            .cmdWriteBufferMarker2AMD => "vkCmdWriteBufferMarker2AMD",
            .getQueueCheckpointData2NV => "vkGetQueueCheckpointData2NV",
            .createVideoSessionKHR => "vkCreateVideoSessionKHR",
            .destroyVideoSessionKHR => "vkDestroyVideoSessionKHR",
            .createVideoSessionParametersKHR => "vkCreateVideoSessionParametersKHR",
            .updateVideoSessionParametersKHR => "vkUpdateVideoSessionParametersKHR",
            .destroyVideoSessionParametersKHR => "vkDestroyVideoSessionParametersKHR",
            .getVideoSessionMemoryRequirementsKHR => "vkGetVideoSessionMemoryRequirementsKHR",
            .bindVideoSessionMemoryKHR => "vkBindVideoSessionMemoryKHR",
            .cmdDecodeVideoKHR => "vkCmdDecodeVideoKHR",
            .cmdBeginVideoCodingKHR => "vkCmdBeginVideoCodingKHR",
            .cmdControlVideoCodingKHR => "vkCmdControlVideoCodingKHR",
            .cmdEndVideoCodingKHR => "vkCmdEndVideoCodingKHR",
            .cmdEncodeVideoKHR => "vkCmdEncodeVideoKHR",
            .createCuModuleNVX => "vkCreateCuModuleNVX",
            .createCuFunctionNVX => "vkCreateCuFunctionNVX",
            .destroyCuModuleNVX => "vkDestroyCuModuleNVX",
            .destroyCuFunctionNVX => "vkDestroyCuFunctionNVX",
            .cmdCuLaunchKernelNVX => "vkCmdCuLaunchKernelNVX",
            .setDeviceMemoryPriorityEXT => "vkSetDeviceMemoryPriorityEXT",
            .waitForPresentKHR => "vkWaitForPresentKHR",
            .createBufferCollectionFUCHSIA => "vkCreateBufferCollectionFUCHSIA",
            .setBufferCollectionBufferConstraintsFUCHSIA => "vkSetBufferCollectionBufferConstraintsFUCHSIA",
            .setBufferCollectionImageConstraintsFUCHSIA => "vkSetBufferCollectionImageConstraintsFUCHSIA",
            .destroyBufferCollectionFUCHSIA => "vkDestroyBufferCollectionFUCHSIA",
            .getBufferCollectionPropertiesFUCHSIA => "vkGetBufferCollectionPropertiesFUCHSIA",
        };
    }

    pub fn PfnType(comptime self: DeviceCommand) type {
        return switch (self) {
            .destroyDevice => PfnDestroyDevice,
            .getDeviceQueue => PfnGetDeviceQueue,
            .queueSubmit => PfnQueueSubmit,
            .queueWaitIdle => PfnQueueWaitIdle,
            .deviceWaitIdle => PfnDeviceWaitIdle,
            .allocateMemory => PfnAllocateMemory,
            .freeMemory => PfnFreeMemory,
            .mapMemory => PfnMapMemory,
            .unmapMemory => PfnUnmapMemory,
            .flushMappedMemoryRanges => PfnFlushMappedMemoryRanges,
            .invalidateMappedMemoryRanges => PfnInvalidateMappedMemoryRanges,
            .getDeviceMemoryCommitment => PfnGetDeviceMemoryCommitment,
            .getBufferMemoryRequirements => PfnGetBufferMemoryRequirements,
            .bindBufferMemory => PfnBindBufferMemory,
            .getImageMemoryRequirements => PfnGetImageMemoryRequirements,
            .bindImageMemory => PfnBindImageMemory,
            .getImageSparseMemoryRequirements => PfnGetImageSparseMemoryRequirements,
            .queueBindSparse => PfnQueueBindSparse,
            .createFence => PfnCreateFence,
            .destroyFence => PfnDestroyFence,
            .resetFences => PfnResetFences,
            .getFenceStatus => PfnGetFenceStatus,
            .waitForFences => PfnWaitForFences,
            .createSemaphore => PfnCreateSemaphore,
            .destroySemaphore => PfnDestroySemaphore,
            .createEvent => PfnCreateEvent,
            .destroyEvent => PfnDestroyEvent,
            .getEventStatus => PfnGetEventStatus,
            .setEvent => PfnSetEvent,
            .resetEvent => PfnResetEvent,
            .createQueryPool => PfnCreateQueryPool,
            .destroyQueryPool => PfnDestroyQueryPool,
            .getQueryPoolResults => PfnGetQueryPoolResults,
            .resetQueryPool => PfnResetQueryPool,
            .createBuffer => PfnCreateBuffer,
            .destroyBuffer => PfnDestroyBuffer,
            .createBufferView => PfnCreateBufferView,
            .destroyBufferView => PfnDestroyBufferView,
            .createImage => PfnCreateImage,
            .destroyImage => PfnDestroyImage,
            .getImageSubresourceLayout => PfnGetImageSubresourceLayout,
            .createImageView => PfnCreateImageView,
            .destroyImageView => PfnDestroyImageView,
            .createShaderModule => PfnCreateShaderModule,
            .destroyShaderModule => PfnDestroyShaderModule,
            .createPipelineCache => PfnCreatePipelineCache,
            .destroyPipelineCache => PfnDestroyPipelineCache,
            .getPipelineCacheData => PfnGetPipelineCacheData,
            .mergePipelineCaches => PfnMergePipelineCaches,
            .createGraphicsPipelines => PfnCreateGraphicsPipelines,
            .createComputePipelines => PfnCreateComputePipelines,
            .getDeviceSubpassShadingMaxWorkgroupSizeHUAWEI => PfnGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI,
            .destroyPipeline => PfnDestroyPipeline,
            .createPipelineLayout => PfnCreatePipelineLayout,
            .destroyPipelineLayout => PfnDestroyPipelineLayout,
            .createSampler => PfnCreateSampler,
            .destroySampler => PfnDestroySampler,
            .createDescriptorSetLayout => PfnCreateDescriptorSetLayout,
            .destroyDescriptorSetLayout => PfnDestroyDescriptorSetLayout,
            .createDescriptorPool => PfnCreateDescriptorPool,
            .destroyDescriptorPool => PfnDestroyDescriptorPool,
            .resetDescriptorPool => PfnResetDescriptorPool,
            .allocateDescriptorSets => PfnAllocateDescriptorSets,
            .freeDescriptorSets => PfnFreeDescriptorSets,
            .updateDescriptorSets => PfnUpdateDescriptorSets,
            .createFramebuffer => PfnCreateFramebuffer,
            .destroyFramebuffer => PfnDestroyFramebuffer,
            .createRenderPass => PfnCreateRenderPass,
            .destroyRenderPass => PfnDestroyRenderPass,
            .getRenderAreaGranularity => PfnGetRenderAreaGranularity,
            .createCommandPool => PfnCreateCommandPool,
            .destroyCommandPool => PfnDestroyCommandPool,
            .resetCommandPool => PfnResetCommandPool,
            .allocateCommandBuffers => PfnAllocateCommandBuffers,
            .freeCommandBuffers => PfnFreeCommandBuffers,
            .beginCommandBuffer => PfnBeginCommandBuffer,
            .endCommandBuffer => PfnEndCommandBuffer,
            .resetCommandBuffer => PfnResetCommandBuffer,
            .cmdBindPipeline => PfnCmdBindPipeline,
            .cmdSetViewport => PfnCmdSetViewport,
            .cmdSetScissor => PfnCmdSetScissor,
            .cmdSetLineWidth => PfnCmdSetLineWidth,
            .cmdSetDepthBias => PfnCmdSetDepthBias,
            .cmdSetBlendConstants => PfnCmdSetBlendConstants,
            .cmdSetDepthBounds => PfnCmdSetDepthBounds,
            .cmdSetStencilCompareMask => PfnCmdSetStencilCompareMask,
            .cmdSetStencilWriteMask => PfnCmdSetStencilWriteMask,
            .cmdSetStencilReference => PfnCmdSetStencilReference,
            .cmdBindDescriptorSets => PfnCmdBindDescriptorSets,
            .cmdBindIndexBuffer => PfnCmdBindIndexBuffer,
            .cmdBindVertexBuffers => PfnCmdBindVertexBuffers,
            .cmdDraw => PfnCmdDraw,
            .cmdDrawIndexed => PfnCmdDrawIndexed,
            .cmdDrawMultiEXT => PfnCmdDrawMultiEXT,
            .cmdDrawMultiIndexedEXT => PfnCmdDrawMultiIndexedEXT,
            .cmdDrawIndirect => PfnCmdDrawIndirect,
            .cmdDrawIndexedIndirect => PfnCmdDrawIndexedIndirect,
            .cmdDispatch => PfnCmdDispatch,
            .cmdDispatchIndirect => PfnCmdDispatchIndirect,
            .cmdSubpassShadingHUAWEI => PfnCmdSubpassShadingHUAWEI,
            .cmdCopyBuffer => PfnCmdCopyBuffer,
            .cmdCopyImage => PfnCmdCopyImage,
            .cmdBlitImage => PfnCmdBlitImage,
            .cmdCopyBufferToImage => PfnCmdCopyBufferToImage,
            .cmdCopyImageToBuffer => PfnCmdCopyImageToBuffer,
            .cmdUpdateBuffer => PfnCmdUpdateBuffer,
            .cmdFillBuffer => PfnCmdFillBuffer,
            .cmdClearColorImage => PfnCmdClearColorImage,
            .cmdClearDepthStencilImage => PfnCmdClearDepthStencilImage,
            .cmdClearAttachments => PfnCmdClearAttachments,
            .cmdResolveImage => PfnCmdResolveImage,
            .cmdSetEvent => PfnCmdSetEvent,
            .cmdResetEvent => PfnCmdResetEvent,
            .cmdWaitEvents => PfnCmdWaitEvents,
            .cmdPipelineBarrier => PfnCmdPipelineBarrier,
            .cmdBeginQuery => PfnCmdBeginQuery,
            .cmdEndQuery => PfnCmdEndQuery,
            .cmdBeginConditionalRenderingEXT => PfnCmdBeginConditionalRenderingEXT,
            .cmdEndConditionalRenderingEXT => PfnCmdEndConditionalRenderingEXT,
            .cmdResetQueryPool => PfnCmdResetQueryPool,
            .cmdWriteTimestamp => PfnCmdWriteTimestamp,
            .cmdCopyQueryPoolResults => PfnCmdCopyQueryPoolResults,
            .cmdPushConstants => PfnCmdPushConstants,
            .cmdBeginRenderPass => PfnCmdBeginRenderPass,
            .cmdNextSubpass => PfnCmdNextSubpass,
            .cmdEndRenderPass => PfnCmdEndRenderPass,
            .cmdExecuteCommands => PfnCmdExecuteCommands,
            .createSharedSwapchainsKHR => PfnCreateSharedSwapchainsKHR,
            .createSwapchainKHR => PfnCreateSwapchainKHR,
            .destroySwapchainKHR => PfnDestroySwapchainKHR,
            .getSwapchainImagesKHR => PfnGetSwapchainImagesKHR,
            .acquireNextImageKHR => PfnAcquireNextImageKHR,
            .queuePresentKHR => PfnQueuePresentKHR,
            .debugMarkerSetObjectNameEXT => PfnDebugMarkerSetObjectNameEXT,
            .debugMarkerSetObjectTagEXT => PfnDebugMarkerSetObjectTagEXT,
            .cmdDebugMarkerBeginEXT => PfnCmdDebugMarkerBeginEXT,
            .cmdDebugMarkerEndEXT => PfnCmdDebugMarkerEndEXT,
            .cmdDebugMarkerInsertEXT => PfnCmdDebugMarkerInsertEXT,
            .getMemoryWin32HandleNV => PfnGetMemoryWin32HandleNV,
            .cmdExecuteGeneratedCommandsNV => PfnCmdExecuteGeneratedCommandsNV,
            .cmdPreprocessGeneratedCommandsNV => PfnCmdPreprocessGeneratedCommandsNV,
            .cmdBindPipelineShaderGroupNV => PfnCmdBindPipelineShaderGroupNV,
            .getGeneratedCommandsMemoryRequirementsNV => PfnGetGeneratedCommandsMemoryRequirementsNV,
            .createIndirectCommandsLayoutNV => PfnCreateIndirectCommandsLayoutNV,
            .destroyIndirectCommandsLayoutNV => PfnDestroyIndirectCommandsLayoutNV,
            .cmdPushDescriptorSetKHR => PfnCmdPushDescriptorSetKHR,
            .trimCommandPool => PfnTrimCommandPool,
            .getMemoryWin32HandleKHR => PfnGetMemoryWin32HandleKHR,
            .getMemoryWin32HandlePropertiesKHR => PfnGetMemoryWin32HandlePropertiesKHR,
            .getMemoryFdKHR => PfnGetMemoryFdKHR,
            .getMemoryFdPropertiesKHR => PfnGetMemoryFdPropertiesKHR,
            .getMemoryZirconHandleFUCHSIA => PfnGetMemoryZirconHandleFUCHSIA,
            .getMemoryZirconHandlePropertiesFUCHSIA => PfnGetMemoryZirconHandlePropertiesFUCHSIA,
            .getMemoryRemoteAddressNV => PfnGetMemoryRemoteAddressNV,
            .getSemaphoreWin32HandleKHR => PfnGetSemaphoreWin32HandleKHR,
            .importSemaphoreWin32HandleKHR => PfnImportSemaphoreWin32HandleKHR,
            .getSemaphoreFdKHR => PfnGetSemaphoreFdKHR,
            .importSemaphoreFdKHR => PfnImportSemaphoreFdKHR,
            .getSemaphoreZirconHandleFUCHSIA => PfnGetSemaphoreZirconHandleFUCHSIA,
            .importSemaphoreZirconHandleFUCHSIA => PfnImportSemaphoreZirconHandleFUCHSIA,
            .getFenceWin32HandleKHR => PfnGetFenceWin32HandleKHR,
            .importFenceWin32HandleKHR => PfnImportFenceWin32HandleKHR,
            .getFenceFdKHR => PfnGetFenceFdKHR,
            .importFenceFdKHR => PfnImportFenceFdKHR,
            .displayPowerControlEXT => PfnDisplayPowerControlEXT,
            .registerDeviceEventEXT => PfnRegisterDeviceEventEXT,
            .registerDisplayEventEXT => PfnRegisterDisplayEventEXT,
            .getSwapchainCounterEXT => PfnGetSwapchainCounterEXT,
            .getDeviceGroupPeerMemoryFeatures => PfnGetDeviceGroupPeerMemoryFeatures,
            .bindBufferMemory2 => PfnBindBufferMemory2,
            .bindImageMemory2 => PfnBindImageMemory2,
            .cmdSetDeviceMask => PfnCmdSetDeviceMask,
            .getDeviceGroupPresentCapabilitiesKHR => PfnGetDeviceGroupPresentCapabilitiesKHR,
            .getDeviceGroupSurfacePresentModesKHR => PfnGetDeviceGroupSurfacePresentModesKHR,
            .acquireNextImage2KHR => PfnAcquireNextImage2KHR,
            .cmdDispatchBase => PfnCmdDispatchBase,
            .createDescriptorUpdateTemplate => PfnCreateDescriptorUpdateTemplate,
            .destroyDescriptorUpdateTemplate => PfnDestroyDescriptorUpdateTemplate,
            .updateDescriptorSetWithTemplate => PfnUpdateDescriptorSetWithTemplate,
            .cmdPushDescriptorSetWithTemplateKHR => PfnCmdPushDescriptorSetWithTemplateKHR,
            .setHdrMetadataEXT => PfnSetHdrMetadataEXT,
            .getSwapchainStatusKHR => PfnGetSwapchainStatusKHR,
            .getRefreshCycleDurationGOOGLE => PfnGetRefreshCycleDurationGOOGLE,
            .getPastPresentationTimingGOOGLE => PfnGetPastPresentationTimingGOOGLE,
            .cmdSetViewportWScalingNV => PfnCmdSetViewportWScalingNV,
            .cmdSetDiscardRectangleEXT => PfnCmdSetDiscardRectangleEXT,
            .cmdSetSampleLocationsEXT => PfnCmdSetSampleLocationsEXT,
            .getBufferMemoryRequirements2 => PfnGetBufferMemoryRequirements2,
            .getImageMemoryRequirements2 => PfnGetImageMemoryRequirements2,
            .getImageSparseMemoryRequirements2 => PfnGetImageSparseMemoryRequirements2,
            .getDeviceBufferMemoryRequirementsKHR => PfnGetDeviceBufferMemoryRequirementsKHR,
            .getDeviceImageMemoryRequirementsKHR => PfnGetDeviceImageMemoryRequirementsKHR,
            .getDeviceImageSparseMemoryRequirementsKHR => PfnGetDeviceImageSparseMemoryRequirementsKHR,
            .createSamplerYcbcrConversion => PfnCreateSamplerYcbcrConversion,
            .destroySamplerYcbcrConversion => PfnDestroySamplerYcbcrConversion,
            .getDeviceQueue2 => PfnGetDeviceQueue2,
            .createValidationCacheEXT => PfnCreateValidationCacheEXT,
            .destroyValidationCacheEXT => PfnDestroyValidationCacheEXT,
            .getValidationCacheDataEXT => PfnGetValidationCacheDataEXT,
            .mergeValidationCachesEXT => PfnMergeValidationCachesEXT,
            .getDescriptorSetLayoutSupport => PfnGetDescriptorSetLayoutSupport,
            .getSwapchainGrallocUsageANDROID => PfnGetSwapchainGrallocUsageANDROID,
            .getSwapchainGrallocUsage2ANDROID => PfnGetSwapchainGrallocUsage2ANDROID,
            .acquireImageANDROID => PfnAcquireImageANDROID,
            .queueSignalReleaseImageANDROID => PfnQueueSignalReleaseImageANDROID,
            .getShaderInfoAMD => PfnGetShaderInfoAMD,
            .setLocalDimmingAMD => PfnSetLocalDimmingAMD,
            .getCalibratedTimestampsEXT => PfnGetCalibratedTimestampsEXT,
            .setDebugUtilsObjectNameEXT => PfnSetDebugUtilsObjectNameEXT,
            .setDebugUtilsObjectTagEXT => PfnSetDebugUtilsObjectTagEXT,
            .queueBeginDebugUtilsLabelEXT => PfnQueueBeginDebugUtilsLabelEXT,
            .queueEndDebugUtilsLabelEXT => PfnQueueEndDebugUtilsLabelEXT,
            .queueInsertDebugUtilsLabelEXT => PfnQueueInsertDebugUtilsLabelEXT,
            .cmdBeginDebugUtilsLabelEXT => PfnCmdBeginDebugUtilsLabelEXT,
            .cmdEndDebugUtilsLabelEXT => PfnCmdEndDebugUtilsLabelEXT,
            .cmdInsertDebugUtilsLabelEXT => PfnCmdInsertDebugUtilsLabelEXT,
            .getMemoryHostPointerPropertiesEXT => PfnGetMemoryHostPointerPropertiesEXT,
            .cmdWriteBufferMarkerAMD => PfnCmdWriteBufferMarkerAMD,
            .createRenderPass2 => PfnCreateRenderPass2,
            .cmdBeginRenderPass2 => PfnCmdBeginRenderPass2,
            .cmdNextSubpass2 => PfnCmdNextSubpass2,
            .cmdEndRenderPass2 => PfnCmdEndRenderPass2,
            .getSemaphoreCounterValue => PfnGetSemaphoreCounterValue,
            .waitSemaphores => PfnWaitSemaphores,
            .signalSemaphore => PfnSignalSemaphore,
            .getAndroidHardwareBufferPropertiesANDROID => PfnGetAndroidHardwareBufferPropertiesANDROID,
            .getMemoryAndroidHardwareBufferANDROID => PfnGetMemoryAndroidHardwareBufferANDROID,
            .cmdDrawIndirectCount => PfnCmdDrawIndirectCount,
            .cmdDrawIndexedIndirectCount => PfnCmdDrawIndexedIndirectCount,
            .cmdSetCheckpointNV => PfnCmdSetCheckpointNV,
            .getQueueCheckpointDataNV => PfnGetQueueCheckpointDataNV,
            .cmdBindTransformFeedbackBuffersEXT => PfnCmdBindTransformFeedbackBuffersEXT,
            .cmdBeginTransformFeedbackEXT => PfnCmdBeginTransformFeedbackEXT,
            .cmdEndTransformFeedbackEXT => PfnCmdEndTransformFeedbackEXT,
            .cmdBeginQueryIndexedEXT => PfnCmdBeginQueryIndexedEXT,
            .cmdEndQueryIndexedEXT => PfnCmdEndQueryIndexedEXT,
            .cmdDrawIndirectByteCountEXT => PfnCmdDrawIndirectByteCountEXT,
            .cmdSetExclusiveScissorNV => PfnCmdSetExclusiveScissorNV,
            .cmdBindShadingRateImageNV => PfnCmdBindShadingRateImageNV,
            .cmdSetViewportShadingRatePaletteNV => PfnCmdSetViewportShadingRatePaletteNV,
            .cmdSetCoarseSampleOrderNV => PfnCmdSetCoarseSampleOrderNV,
            .cmdDrawMeshTasksNV => PfnCmdDrawMeshTasksNV,
            .cmdDrawMeshTasksIndirectNV => PfnCmdDrawMeshTasksIndirectNV,
            .cmdDrawMeshTasksIndirectCountNV => PfnCmdDrawMeshTasksIndirectCountNV,
            .compileDeferredNV => PfnCompileDeferredNV,
            .createAccelerationStructureNV => PfnCreateAccelerationStructureNV,
            .cmdBindInvocationMaskHUAWEI => PfnCmdBindInvocationMaskHUAWEI,
            .destroyAccelerationStructureKHR => PfnDestroyAccelerationStructureKHR,
            .destroyAccelerationStructureNV => PfnDestroyAccelerationStructureNV,
            .getAccelerationStructureMemoryRequirementsNV => PfnGetAccelerationStructureMemoryRequirementsNV,
            .bindAccelerationStructureMemoryNV => PfnBindAccelerationStructureMemoryNV,
            .cmdCopyAccelerationStructureNV => PfnCmdCopyAccelerationStructureNV,
            .cmdCopyAccelerationStructureKHR => PfnCmdCopyAccelerationStructureKHR,
            .copyAccelerationStructureKHR => PfnCopyAccelerationStructureKHR,
            .cmdCopyAccelerationStructureToMemoryKHR => PfnCmdCopyAccelerationStructureToMemoryKHR,
            .copyAccelerationStructureToMemoryKHR => PfnCopyAccelerationStructureToMemoryKHR,
            .cmdCopyMemoryToAccelerationStructureKHR => PfnCmdCopyMemoryToAccelerationStructureKHR,
            .copyMemoryToAccelerationStructureKHR => PfnCopyMemoryToAccelerationStructureKHR,
            .cmdWriteAccelerationStructuresPropertiesKHR => PfnCmdWriteAccelerationStructuresPropertiesKHR,
            .cmdWriteAccelerationStructuresPropertiesNV => PfnCmdWriteAccelerationStructuresPropertiesNV,
            .cmdBuildAccelerationStructureNV => PfnCmdBuildAccelerationStructureNV,
            .writeAccelerationStructuresPropertiesKHR => PfnWriteAccelerationStructuresPropertiesKHR,
            .cmdTraceRaysKHR => PfnCmdTraceRaysKHR,
            .cmdTraceRaysNV => PfnCmdTraceRaysNV,
            .getRayTracingShaderGroupHandlesKHR => PfnGetRayTracingShaderGroupHandlesKHR,
            .getRayTracingCaptureReplayShaderGroupHandlesKHR => PfnGetRayTracingCaptureReplayShaderGroupHandlesKHR,
            .getAccelerationStructureHandleNV => PfnGetAccelerationStructureHandleNV,
            .createRayTracingPipelinesNV => PfnCreateRayTracingPipelinesNV,
            .createRayTracingPipelinesKHR => PfnCreateRayTracingPipelinesKHR,
            .cmdTraceRaysIndirectKHR => PfnCmdTraceRaysIndirectKHR,
            .getDeviceAccelerationStructureCompatibilityKHR => PfnGetDeviceAccelerationStructureCompatibilityKHR,
            .getRayTracingShaderGroupStackSizeKHR => PfnGetRayTracingShaderGroupStackSizeKHR,
            .cmdSetRayTracingPipelineStackSizeKHR => PfnCmdSetRayTracingPipelineStackSizeKHR,
            .getImageViewHandleNVX => PfnGetImageViewHandleNVX,
            .getImageViewAddressNVX => PfnGetImageViewAddressNVX,
            .getDeviceGroupSurfacePresentModes2EXT => PfnGetDeviceGroupSurfacePresentModes2EXT,
            .acquireFullScreenExclusiveModeEXT => PfnAcquireFullScreenExclusiveModeEXT,
            .releaseFullScreenExclusiveModeEXT => PfnReleaseFullScreenExclusiveModeEXT,
            .acquireProfilingLockKHR => PfnAcquireProfilingLockKHR,
            .releaseProfilingLockKHR => PfnReleaseProfilingLockKHR,
            .getImageDrmFormatModifierPropertiesEXT => PfnGetImageDrmFormatModifierPropertiesEXT,
            .getBufferOpaqueCaptureAddress => PfnGetBufferOpaqueCaptureAddress,
            .getBufferDeviceAddress => PfnGetBufferDeviceAddress,
            .initializePerformanceApiINTEL => PfnInitializePerformanceApiINTEL,
            .uninitializePerformanceApiINTEL => PfnUninitializePerformanceApiINTEL,
            .cmdSetPerformanceMarkerINTEL => PfnCmdSetPerformanceMarkerINTEL,
            .cmdSetPerformanceStreamMarkerINTEL => PfnCmdSetPerformanceStreamMarkerINTEL,
            .cmdSetPerformanceOverrideINTEL => PfnCmdSetPerformanceOverrideINTEL,
            .acquirePerformanceConfigurationINTEL => PfnAcquirePerformanceConfigurationINTEL,
            .releasePerformanceConfigurationINTEL => PfnReleasePerformanceConfigurationINTEL,
            .queueSetPerformanceConfigurationINTEL => PfnQueueSetPerformanceConfigurationINTEL,
            .getPerformanceParameterINTEL => PfnGetPerformanceParameterINTEL,
            .getDeviceMemoryOpaqueCaptureAddress => PfnGetDeviceMemoryOpaqueCaptureAddress,
            .getPipelineExecutablePropertiesKHR => PfnGetPipelineExecutablePropertiesKHR,
            .getPipelineExecutableStatisticsKHR => PfnGetPipelineExecutableStatisticsKHR,
            .getPipelineExecutableInternalRepresentationsKHR => PfnGetPipelineExecutableInternalRepresentationsKHR,
            .cmdSetLineStippleEXT => PfnCmdSetLineStippleEXT,
            .createAccelerationStructureKHR => PfnCreateAccelerationStructureKHR,
            .cmdBuildAccelerationStructuresKHR => PfnCmdBuildAccelerationStructuresKHR,
            .cmdBuildAccelerationStructuresIndirectKHR => PfnCmdBuildAccelerationStructuresIndirectKHR,
            .buildAccelerationStructuresKHR => PfnBuildAccelerationStructuresKHR,
            .getAccelerationStructureDeviceAddressKHR => PfnGetAccelerationStructureDeviceAddressKHR,
            .createDeferredOperationKHR => PfnCreateDeferredOperationKHR,
            .destroyDeferredOperationKHR => PfnDestroyDeferredOperationKHR,
            .getDeferredOperationMaxConcurrencyKHR => PfnGetDeferredOperationMaxConcurrencyKHR,
            .getDeferredOperationResultKHR => PfnGetDeferredOperationResultKHR,
            .deferredOperationJoinKHR => PfnDeferredOperationJoinKHR,
            .cmdSetCullModeEXT => PfnCmdSetCullModeEXT,
            .cmdSetFrontFaceEXT => PfnCmdSetFrontFaceEXT,
            .cmdSetPrimitiveTopologyEXT => PfnCmdSetPrimitiveTopologyEXT,
            .cmdSetViewportWithCountEXT => PfnCmdSetViewportWithCountEXT,
            .cmdSetScissorWithCountEXT => PfnCmdSetScissorWithCountEXT,
            .cmdBindVertexBuffers2EXT => PfnCmdBindVertexBuffers2EXT,
            .cmdSetDepthTestEnableEXT => PfnCmdSetDepthTestEnableEXT,
            .cmdSetDepthWriteEnableEXT => PfnCmdSetDepthWriteEnableEXT,
            .cmdSetDepthCompareOpEXT => PfnCmdSetDepthCompareOpEXT,
            .cmdSetDepthBoundsTestEnableEXT => PfnCmdSetDepthBoundsTestEnableEXT,
            .cmdSetStencilTestEnableEXT => PfnCmdSetStencilTestEnableEXT,
            .cmdSetStencilOpEXT => PfnCmdSetStencilOpEXT,
            .cmdSetPatchControlPointsEXT => PfnCmdSetPatchControlPointsEXT,
            .cmdSetRasterizerDiscardEnableEXT => PfnCmdSetRasterizerDiscardEnableEXT,
            .cmdSetDepthBiasEnableEXT => PfnCmdSetDepthBiasEnableEXT,
            .cmdSetLogicOpEXT => PfnCmdSetLogicOpEXT,
            .cmdSetPrimitiveRestartEnableEXT => PfnCmdSetPrimitiveRestartEnableEXT,
            .createPrivateDataSlotEXT => PfnCreatePrivateDataSlotEXT,
            .destroyPrivateDataSlotEXT => PfnDestroyPrivateDataSlotEXT,
            .setPrivateDataEXT => PfnSetPrivateDataEXT,
            .getPrivateDataEXT => PfnGetPrivateDataEXT,
            .cmdCopyBuffer2KHR => PfnCmdCopyBuffer2KHR,
            .cmdCopyImage2KHR => PfnCmdCopyImage2KHR,
            .cmdBlitImage2KHR => PfnCmdBlitImage2KHR,
            .cmdCopyBufferToImage2KHR => PfnCmdCopyBufferToImage2KHR,
            .cmdCopyImageToBuffer2KHR => PfnCmdCopyImageToBuffer2KHR,
            .cmdResolveImage2KHR => PfnCmdResolveImage2KHR,
            .cmdSetFragmentShadingRateKHR => PfnCmdSetFragmentShadingRateKHR,
            .cmdSetFragmentShadingRateEnumNV => PfnCmdSetFragmentShadingRateEnumNV,
            .getAccelerationStructureBuildSizesKHR => PfnGetAccelerationStructureBuildSizesKHR,
            .cmdSetVertexInputEXT => PfnCmdSetVertexInputEXT,
            .cmdSetColorWriteEnableEXT => PfnCmdSetColorWriteEnableEXT,
            .cmdSetEvent2KHR => PfnCmdSetEvent2KHR,
            .cmdResetEvent2KHR => PfnCmdResetEvent2KHR,
            .cmdWaitEvents2KHR => PfnCmdWaitEvents2KHR,
            .cmdPipelineBarrier2KHR => PfnCmdPipelineBarrier2KHR,
            .queueSubmit2KHR => PfnQueueSubmit2KHR,
            .cmdWriteTimestamp2KHR => PfnCmdWriteTimestamp2KHR,
            .cmdWriteBufferMarker2AMD => PfnCmdWriteBufferMarker2AMD,
            .getQueueCheckpointData2NV => PfnGetQueueCheckpointData2NV,
            .createVideoSessionKHR => PfnCreateVideoSessionKHR,
            .destroyVideoSessionKHR => PfnDestroyVideoSessionKHR,
            .createVideoSessionParametersKHR => PfnCreateVideoSessionParametersKHR,
            .updateVideoSessionParametersKHR => PfnUpdateVideoSessionParametersKHR,
            .destroyVideoSessionParametersKHR => PfnDestroyVideoSessionParametersKHR,
            .getVideoSessionMemoryRequirementsKHR => PfnGetVideoSessionMemoryRequirementsKHR,
            .bindVideoSessionMemoryKHR => PfnBindVideoSessionMemoryKHR,
            .cmdDecodeVideoKHR => PfnCmdDecodeVideoKHR,
            .cmdBeginVideoCodingKHR => PfnCmdBeginVideoCodingKHR,
            .cmdControlVideoCodingKHR => PfnCmdControlVideoCodingKHR,
            .cmdEndVideoCodingKHR => PfnCmdEndVideoCodingKHR,
            .cmdEncodeVideoKHR => PfnCmdEncodeVideoKHR,
            .createCuModuleNVX => PfnCreateCuModuleNVX,
            .createCuFunctionNVX => PfnCreateCuFunctionNVX,
            .destroyCuModuleNVX => PfnDestroyCuModuleNVX,
            .destroyCuFunctionNVX => PfnDestroyCuFunctionNVX,
            .cmdCuLaunchKernelNVX => PfnCmdCuLaunchKernelNVX,
            .setDeviceMemoryPriorityEXT => PfnSetDeviceMemoryPriorityEXT,
            .waitForPresentKHR => PfnWaitForPresentKHR,
            .createBufferCollectionFUCHSIA => PfnCreateBufferCollectionFUCHSIA,
            .setBufferCollectionBufferConstraintsFUCHSIA => PfnSetBufferCollectionBufferConstraintsFUCHSIA,
            .setBufferCollectionImageConstraintsFUCHSIA => PfnSetBufferCollectionImageConstraintsFUCHSIA,
            .destroyBufferCollectionFUCHSIA => PfnDestroyBufferCollectionFUCHSIA,
            .getBufferCollectionPropertiesFUCHSIA => PfnGetBufferCollectionPropertiesFUCHSIA,
        };
    }
};

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
pub const QUEUE_FAMILY_EXTERNAL = ~@as(u32, 1);
pub const QUEUE_FAMILY_EXTERNAL_KHR = QUEUE_FAMILY_EXTERNAL;
pub const QUEUE_FAMILY_FOREIGN_EXT = ~@as(u32, 2);
pub const SUBPASS_EXTERNAL = ~@as(u32, 0);
pub const MAX_DEVICE_GROUP_SIZE = 32;
pub const MAX_DEVICE_GROUP_SIZE_KHR = MAX_DEVICE_GROUP_SIZE;
pub const MAX_DRIVER_NAME_SIZE = 256;
pub const MAX_DRIVER_NAME_SIZE_KHR = MAX_DRIVER_NAME_SIZE;
pub const MAX_DRIVER_INFO_SIZE = 256;
pub const MAX_DRIVER_INFO_SIZE_KHR = MAX_DRIVER_INFO_SIZE;
pub const SHADER_UNUSED_KHR = ~@as(u32, 0);
pub const SHADER_UNUSED_NV = SHADER_UNUSED_KHR;
pub const MAX_GLOBAL_PRIORITY_SIZE_EXT = 16;
pub const API_VERSION_1_0 = makeApiVersion(0, 1, 0, 0);
pub const API_VERSION_1_1 = makeApiVersion(0, 1, 1, 0);
pub const API_VERSION_1_2 = makeApiVersion(0, 1, 2, 0);
pub const HEADER_VERSION = 196;
pub const HEADER_VERSION_COMPLETE = makeApiVersion(0, 1, 2, HEADER_VERSION);
pub const Display = if (@hasDecl(root, "Display")) root.Display else opaque {};
pub const VisualID = if (@hasDecl(root, "VisualID")) root.VisualID else c_uint;
pub const Window = if (@hasDecl(root, "Window")) root.Window else c_ulong;
pub const RROutput = if (@hasDecl(root, "RROutput")) root.RROutput else c_ulong;
pub const wl_display = if (@hasDecl(root, "wl_display")) root.wl_display else opaque {};
pub const wl_surface = if (@hasDecl(root, "wl_surface")) root.wl_surface else opaque {};
pub const HINSTANCE = if (@hasDecl(root, "HINSTANCE")) root.HINSTANCE else std.os.windows.HINSTANCE;
pub const HWND = if (@hasDecl(root, "HWND")) root.HWND else std.os.windows.HWND;
pub const HMONITOR = if (@hasDecl(root, "HMONITOR")) root.HMONITOR else *opaque {};
pub const HANDLE = if (@hasDecl(root, "HANDLE")) root.HANDLE else std.os.windows.HANDLE;
pub const SECURITY_ATTRIBUTES = if (@hasDecl(root, "SECURITY_ATTRIBUTES")) root.SECURITY_ATTRIBUTES else std.os.SECURITY_ATTRIBUTES;
pub const DWORD = if (@hasDecl(root, "DWORD")) root.DWORD else std.os.windows.DWORD;
pub const LPCWSTR = if (@hasDecl(root, "LPCWSTR")) root.LPCWSTR else std.os.windows.LPCWSTR;
pub const xcb_connection_t = if (@hasDecl(root, "xcb_connection_t")) root.xcb_connection_t else opaque {};
pub const xcb_visualid_t = if (@hasDecl(root, "xcb_visualid_t")) root.xcb_visualid_t else u32;
pub const xcb_window_t = if (@hasDecl(root, "xcb_window_t")) root.xcb_window_t else u32;
pub const IDirectFB = if (@hasDecl(root, "IDirectFB")) root.IDirectFB else @compileError("Missing type definition of 'IDirectFB'");
pub const IDirectFBSurface = if (@hasDecl(root, "IDirectFBSurface")) root.IDirectFBSurface else @compileError("Missing type definition of 'IDirectFBSurface'");
pub const zx_handle_t = if (@hasDecl(root, "zx_handle_t")) root.zx_handle_t else u32;
pub const GgpStreamDescriptor = if (@hasDecl(root, "GgpStreamDescriptor")) root.GgpStreamDescriptor else @compileError("Missing type definition of 'GgpStreamDescriptor'");
pub const GgpFrameToken = if (@hasDecl(root, "GgpFrameToken")) root.GgpFrameToken else @compileError("Missing type definition of 'GgpFrameToken'");
pub const _screen_context = if (@hasDecl(root, "_screen_context")) root._screen_context else opaque {};
pub const _screen_window = if (@hasDecl(root, "_screen_window")) root._screen_window else opaque {};
pub const ANativeWindow = opaque {};
pub const AHardwareBuffer = opaque {};
pub const CAMetalLayer = opaque {};
pub const SampleMask = u32;
pub const Bool32 = u32;
pub const Flags = u32;
pub const Flags64 = u64;
pub const DeviceSize = u64;
pub const DeviceAddress = u64;
pub const QueryPoolCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(QueryPoolCreateFlags, Flags);
};
pub const PipelineLayoutCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineLayoutCreateFlags, Flags);
};
pub const PipelineDepthStencilStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineDepthStencilStateCreateFlags, Flags);
};
pub const PipelineDynamicStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineDynamicStateCreateFlags, Flags);
};
pub const PipelineColorBlendStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineColorBlendStateCreateFlags, Flags);
};
pub const PipelineMultisampleStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineMultisampleStateCreateFlags, Flags);
};
pub const PipelineRasterizationStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineRasterizationStateCreateFlags, Flags);
};
pub const PipelineViewportStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineViewportStateCreateFlags, Flags);
};
pub const PipelineTessellationStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineTessellationStateCreateFlags, Flags);
};
pub const PipelineInputAssemblyStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineInputAssemblyStateCreateFlags, Flags);
};
pub const PipelineVertexInputStateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineVertexInputStateCreateFlags, Flags);
};
pub const BufferViewCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(BufferViewCreateFlags, Flags);
};
pub const InstanceCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(InstanceCreateFlags, Flags);
};
pub const DeviceCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DeviceCreateFlags, Flags);
};
pub const SemaphoreCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(SemaphoreCreateFlags, Flags);
};
pub const ShaderModuleCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ShaderModuleCreateFlags, Flags);
};
pub const MemoryMapFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(MemoryMapFlags, Flags);
};
pub const DescriptorPoolResetFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DescriptorPoolResetFlags, Flags);
};
pub const GeometryFlagsNV = GeometryFlagsKHR;
pub const GeometryInstanceFlagsNV = GeometryInstanceFlagsKHR;
pub const BuildAccelerationStructureFlagsNV = BuildAccelerationStructureFlagsKHR;
pub const DescriptorUpdateTemplateCreateFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DescriptorUpdateTemplateCreateFlags, Flags);
};
pub const DescriptorUpdateTemplateCreateFlagsKHR = DescriptorUpdateTemplateCreateFlags;
pub const SemaphoreWaitFlagsKHR = SemaphoreWaitFlags;
pub const AccelerationStructureMotionInfoFlagsNV = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(AccelerationStructureMotionInfoFlagsNV, Flags);
};
pub const AccelerationStructureMotionInstanceFlagsNV = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(AccelerationStructureMotionInstanceFlagsNV, Flags);
};
pub const DisplayModeCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DisplayModeCreateFlagsKHR, Flags);
};
pub const DisplaySurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DisplaySurfaceCreateFlagsKHR, Flags);
};
pub const AndroidSurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(AndroidSurfaceCreateFlagsKHR, Flags);
};
pub const ViSurfaceCreateFlagsNN = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ViSurfaceCreateFlagsNN, Flags);
};
pub const WaylandSurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(WaylandSurfaceCreateFlagsKHR, Flags);
};
pub const Win32SurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(Win32SurfaceCreateFlagsKHR, Flags);
};
pub const XlibSurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(XlibSurfaceCreateFlagsKHR, Flags);
};
pub const XcbSurfaceCreateFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(XcbSurfaceCreateFlagsKHR, Flags);
};
pub const DirectFBSurfaceCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DirectFBSurfaceCreateFlagsEXT, Flags);
};
pub const IOSSurfaceCreateFlagsMVK = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(IOSSurfaceCreateFlagsMVK, Flags);
};
pub const MacOSSurfaceCreateFlagsMVK = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(MacOSSurfaceCreateFlagsMVK, Flags);
};
pub const MetalSurfaceCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(MetalSurfaceCreateFlagsEXT, Flags);
};
pub const ImagePipeSurfaceCreateFlagsFUCHSIA = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ImagePipeSurfaceCreateFlagsFUCHSIA, Flags);
};
pub const StreamDescriptorSurfaceCreateFlagsGGP = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(StreamDescriptorSurfaceCreateFlagsGGP, Flags);
};
pub const HeadlessSurfaceCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(HeadlessSurfaceCreateFlagsEXT, Flags);
};
pub const ScreenSurfaceCreateFlagsQNX = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ScreenSurfaceCreateFlagsQNX, Flags);
};
pub const PeerMemoryFeatureFlagsKHR = PeerMemoryFeatureFlags;
pub const MemoryAllocateFlagsKHR = MemoryAllocateFlags;
pub const CommandPoolTrimFlags = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(CommandPoolTrimFlags, Flags);
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
    pub usingnamespace FlagsMixin(PipelineViewportSwizzleStateCreateFlagsNV, Flags);
};
pub const PipelineDiscardRectangleStateCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineDiscardRectangleStateCreateFlagsEXT, Flags);
};
pub const PipelineCoverageToColorStateCreateFlagsNV = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineCoverageToColorStateCreateFlagsNV, Flags);
};
pub const PipelineCoverageModulationStateCreateFlagsNV = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineCoverageModulationStateCreateFlagsNV, Flags);
};
pub const PipelineCoverageReductionStateCreateFlagsNV = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineCoverageReductionStateCreateFlagsNV, Flags);
};
pub const ValidationCacheCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ValidationCacheCreateFlagsEXT, Flags);
};
pub const DebugUtilsMessengerCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DebugUtilsMessengerCreateFlagsEXT, Flags);
};
pub const DebugUtilsMessengerCallbackDataFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DebugUtilsMessengerCallbackDataFlagsEXT, Flags);
};
pub const DeviceMemoryReportFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(DeviceMemoryReportFlagsEXT, Flags);
};
pub const PipelineRasterizationConservativeStateCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineRasterizationConservativeStateCreateFlagsEXT, Flags);
};
pub const DescriptorBindingFlagsEXT = DescriptorBindingFlags;
pub const ResolveModeFlagsKHR = ResolveModeFlags;
pub const PipelineRasterizationStateStreamCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineRasterizationStateStreamCreateFlagsEXT, Flags);
};
pub const PipelineRasterizationDepthClipStateCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineRasterizationDepthClipStateCreateFlagsEXT, Flags);
};
pub const ImageFormatConstraintsFlagsFUCHSIA = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ImageFormatConstraintsFlagsFUCHSIA, Flags);
};
pub const VideoBeginCodingFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(VideoBeginCodingFlagsKHR, Flags);
};
pub const VideoEndCodingFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(VideoEndCodingFlagsKHR, Flags);
};
pub const VideoDecodeH264CreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(VideoDecodeH264CreateFlagsEXT, Flags);
};
pub const VideoDecodeH265CreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(VideoDecodeH265CreateFlagsEXT, Flags);
};
pub const VideoEncodeH265CreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(VideoEncodeH265CreateFlagsEXT, Flags);
};
pub const Instance = enum(usize) { null_handle = 0, _ };
pub const PhysicalDevice = enum(usize) { null_handle = 0, _ };
pub const Device = enum(usize) { null_handle = 0, _ };
pub const Queue = enum(usize) { null_handle = 0, _ };
pub const CommandBuffer = enum(usize) { null_handle = 0, _ };
pub const DeviceMemory = enum(u64) { null_handle = 0, _ };
pub const CommandPool = enum(u64) { null_handle = 0, _ };
pub const Buffer = enum(u64) { null_handle = 0, _ };
pub const BufferView = enum(u64) { null_handle = 0, _ };
pub const Image = enum(u64) { null_handle = 0, _ };
pub const ImageView = enum(u64) { null_handle = 0, _ };
pub const ShaderModule = enum(u64) { null_handle = 0, _ };
pub const Pipeline = enum(u64) { null_handle = 0, _ };
pub const PipelineLayout = enum(u64) { null_handle = 0, _ };
pub const Sampler = enum(u64) { null_handle = 0, _ };
pub const DescriptorSet = enum(u64) { null_handle = 0, _ };
pub const DescriptorSetLayout = enum(u64) { null_handle = 0, _ };
pub const DescriptorPool = enum(u64) { null_handle = 0, _ };
pub const Fence = enum(u64) { null_handle = 0, _ };
pub const Semaphore = enum(u64) { null_handle = 0, _ };
pub const Event = enum(u64) { null_handle = 0, _ };
pub const QueryPool = enum(u64) { null_handle = 0, _ };
pub const Framebuffer = enum(u64) { null_handle = 0, _ };
pub const RenderPass = enum(u64) { null_handle = 0, _ };
pub const PipelineCache = enum(u64) { null_handle = 0, _ };
pub const IndirectCommandsLayoutNV = enum(u64) { null_handle = 0, _ };
pub const DescriptorUpdateTemplate = enum(u64) { null_handle = 0, _ };
pub const DescriptorUpdateTemplateKHR = DescriptorUpdateTemplate;
pub const SamplerYcbcrConversion = enum(u64) { null_handle = 0, _ };
pub const SamplerYcbcrConversionKHR = SamplerYcbcrConversion;
pub const ValidationCacheEXT = enum(u64) { null_handle = 0, _ };
pub const AccelerationStructureKHR = enum(u64) { null_handle = 0, _ };
pub const AccelerationStructureNV = enum(u64) { null_handle = 0, _ };
pub const PerformanceConfigurationINTEL = enum(u64) { null_handle = 0, _ };
pub const BufferCollectionFUCHSIA = enum(u64) { null_handle = 0, _ };
pub const DeferredOperationKHR = enum(u64) { null_handle = 0, _ };
pub const PrivateDataSlotEXT = enum(u64) { null_handle = 0, _ };
pub const CuModuleNVX = enum(u64) { null_handle = 0, _ };
pub const CuFunctionNVX = enum(u64) { null_handle = 0, _ };
pub const DisplayKHR = enum(u64) { null_handle = 0, _ };
pub const DisplayModeKHR = enum(u64) { null_handle = 0, _ };
pub const SurfaceKHR = enum(u64) { null_handle = 0, _ };
pub const SwapchainKHR = enum(u64) { null_handle = 0, _ };
pub const DebugReportCallbackEXT = enum(u64) { null_handle = 0, _ };
pub const DebugUtilsMessengerEXT = enum(u64) { null_handle = 0, _ };
pub const VideoSessionKHR = enum(u64) { null_handle = 0, _ };
pub const VideoSessionParametersKHR = enum(u64) { null_handle = 0, _ };
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
    pUserData: *c_void,
    size: usize,
    allocationType: InternalAllocationType,
    allocationScope: SystemAllocationScope,
) callconv(vulkan_call_conv) void;
pub const PfnInternalFreeNotification = ?fn (
    pUserData: *c_void,
    size: usize,
    allocationType: InternalAllocationType,
    allocationScope: SystemAllocationScope,
) callconv(vulkan_call_conv) void;
pub const PfnReallocationFunction = ?fn (
    pUserData: *c_void,
    pOriginal: *c_void,
    size: usize,
    alignment: usize,
    allocationScope: SystemAllocationScope,
) callconv(vulkan_call_conv) *c_void;
pub const PfnAllocationFunction = ?fn (
    pUserData: *c_void,
    size: usize,
    alignment: usize,
    allocationScope: SystemAllocationScope,
) callconv(vulkan_call_conv) *c_void;
pub const PfnFreeFunction = ?fn (
    pUserData: *c_void,
    pMemory: *c_void,
) callconv(vulkan_call_conv) void;
pub const PfnVoidFunction = ?fn () callconv(vulkan_call_conv) void;
pub const PfnDebugReportCallbackEXT = ?fn (
    flags: DebugReportFlagsEXT.IntType,
    objectType: DebugReportObjectTypeEXT,
    object: u64,
    location: usize,
    messageCode: i32,
    pLayerPrefix: *const u8,
    pMessage: *const u8,
    pUserData: *c_void,
) callconv(vulkan_call_conv) Bool32;
pub const PfnDebugUtilsMessengerCallbackEXT = ?fn (
    messageSeverity: DebugUtilsMessageSeverityFlagsEXT.IntType,
    messageTypes: DebugUtilsMessageTypeFlagsEXT.IntType,
    pCallbackData: *const DebugUtilsMessengerCallbackDataEXT,
    pUserData: *c_void,
) callconv(vulkan_call_conv) Bool32;
pub const PfnDeviceMemoryReportCallbackEXT = ?fn (
    pCallbackData: *const DeviceMemoryReportCallbackDataEXT,
    pUserData: *c_void,
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
    sType: StructureType = .applicationInfo,
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
    sType: StructureType = .deviceQueueCreateInfo,
    pNext: ?*const c_void = null,
    flags: DeviceQueueCreateFlags,
    queueFamilyIndex: u32,
    queueCount: u32,
    pQueuePriorities: [*]const f32,
};
pub const DeviceCreateInfo = extern struct {
    sType: StructureType = .deviceCreateInfo,
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
    sType: StructureType = .instanceCreateInfo,
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
    sType: StructureType = .memoryAllocateInfo,
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
    sType: StructureType = .mappedMemoryRange,
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
    sType: StructureType = .writeDescriptorSet,
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
    sType: StructureType = .copyDescriptorSet,
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
    sType: StructureType = .bufferCreateInfo,
    pNext: ?*const c_void = null,
    flags: BufferCreateFlags,
    size: DeviceSize,
    usage: BufferUsageFlags,
    sharingMode: SharingMode,
    queueFamilyIndexCount: u32,
    pQueueFamilyIndices: [*]const u32,
};
pub const BufferViewCreateInfo = extern struct {
    sType: StructureType = .bufferViewCreateInfo,
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
    sType: StructureType = .memoryBarrier,
    pNext: ?*const c_void = null,
    srcAccessMask: AccessFlags,
    dstAccessMask: AccessFlags,
};
pub const BufferMemoryBarrier = extern struct {
    sType: StructureType = .bufferMemoryBarrier,
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
    sType: StructureType = .imageMemoryBarrier,
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
    sType: StructureType = .imageCreateInfo,
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
    sType: StructureType = .imageViewCreateInfo,
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
    sType: StructureType = .bindSparseInfo,
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
    sType: StructureType = .shaderModuleCreateInfo,
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
    sType: StructureType = .descriptorSetLayoutCreateInfo,
    pNext: ?*const c_void = null,
    flags: DescriptorSetLayoutCreateFlags,
    bindingCount: u32,
    pBindings: [*]const DescriptorSetLayoutBinding,
};
pub const DescriptorPoolSize = extern struct {
    @"type": DescriptorType,
    descriptorCount: u32,
};
pub const DescriptorPoolCreateInfo = extern struct {
    sType: StructureType = .descriptorPoolCreateInfo,
    pNext: ?*const c_void = null,
    flags: DescriptorPoolCreateFlags,
    maxSets: u32,
    poolSizeCount: u32,
    pPoolSizes: [*]const DescriptorPoolSize,
};
pub const DescriptorSetAllocateInfo = extern struct {
    sType: StructureType = .descriptorSetAllocateInfo,
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
    sType: StructureType = .pipelineShaderStageCreateInfo,
    pNext: ?*const c_void = null,
    flags: PipelineShaderStageCreateFlags,
    stage: ShaderStageFlags,
    module: ShaderModule,
    pName: [*:0]const u8,
    pSpecializationInfo: ?*const SpecializationInfo,
};
pub const ComputePipelineCreateInfo = extern struct {
    sType: StructureType = .computePipelineCreateInfo,
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
    sType: StructureType = .pipelineVertexInputStateCreateInfo,
    pNext: ?*const c_void = null,
    flags: PipelineVertexInputStateCreateFlags,
    vertexBindingDescriptionCount: u32,
    pVertexBindingDescriptions: [*]const VertexInputBindingDescription,
    vertexAttributeDescriptionCount: u32,
    pVertexAttributeDescriptions: [*]const VertexInputAttributeDescription,
};
pub const PipelineInputAssemblyStateCreateInfo = extern struct {
    sType: StructureType = .pipelineInputAssemblyStateCreateInfo,
    pNext: ?*const c_void = null,
    flags: PipelineInputAssemblyStateCreateFlags,
    topology: PrimitiveTopology,
    primitiveRestartEnable: Bool32,
};
pub const PipelineTessellationStateCreateInfo = extern struct {
    sType: StructureType = .pipelineTessellationStateCreateInfo,
    pNext: ?*const c_void = null,
    flags: PipelineTessellationStateCreateFlags,
    patchControlPoints: u32,
};
pub const PipelineViewportStateCreateInfo = extern struct {
    sType: StructureType = .pipelineViewportStateCreateInfo,
    pNext: ?*const c_void = null,
    flags: PipelineViewportStateCreateFlags,
    viewportCount: u32,
    pViewports: ?[*]const Viewport,
    scissorCount: u32,
    pScissors: ?[*]const Rect2D,
};
pub const PipelineRasterizationStateCreateInfo = extern struct {
    sType: StructureType = .pipelineRasterizationStateCreateInfo,
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
    sType: StructureType = .pipelineMultisampleStateCreateInfo,
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
    sType: StructureType = .pipelineColorBlendStateCreateInfo,
    pNext: ?*const c_void = null,
    flags: PipelineColorBlendStateCreateFlags,
    logicOpEnable: Bool32,
    logicOp: LogicOp,
    attachmentCount: u32,
    pAttachments: [*]const PipelineColorBlendAttachmentState,
    blendConstants: [4]f32,
};
pub const PipelineDynamicStateCreateInfo = extern struct {
    sType: StructureType = .pipelineDynamicStateCreateInfo,
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
    sType: StructureType = .pipelineDepthStencilStateCreateInfo,
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
    sType: StructureType = .graphicsPipelineCreateInfo,
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
    sType: StructureType = .pipelineCacheCreateInfo,
    pNext: ?*const c_void = null,
    flags: PipelineCacheCreateFlags,
    initialDataSize: usize,
    pInitialData: *const c_void,
};
pub const PipelineCacheHeaderVersionOne = extern struct {
    headerSize: u32,
    headerVersion: PipelineCacheHeaderVersion,
    vendorId: u32,
    deviceId: u32,
    pipelineCacheUuid: [UUID_SIZE]u8,
};
pub const PushConstantRange = extern struct {
    stageFlags: ShaderStageFlags,
    offset: u32,
    size: u32,
};
pub const PipelineLayoutCreateInfo = extern struct {
    sType: StructureType = .pipelineLayoutCreateInfo,
    pNext: ?*const c_void = null,
    flags: PipelineLayoutCreateFlags,
    setLayoutCount: u32,
    pSetLayouts: [*]const DescriptorSetLayout,
    pushConstantRangeCount: u32,
    pPushConstantRanges: [*]const PushConstantRange,
};
pub const SamplerCreateInfo = extern struct {
    sType: StructureType = .samplerCreateInfo,
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
    sType: StructureType = .commandPoolCreateInfo,
    pNext: ?*const c_void = null,
    flags: CommandPoolCreateFlags,
    queueFamilyIndex: u32,
};
pub const CommandBufferAllocateInfo = extern struct {
    sType: StructureType = .commandBufferAllocateInfo,
    pNext: ?*const c_void = null,
    commandPool: CommandPool,
    level: CommandBufferLevel,
    commandBufferCount: u32,
};
pub const CommandBufferInheritanceInfo = extern struct {
    sType: StructureType = .commandBufferInheritanceInfo,
    pNext: ?*const c_void = null,
    renderPass: RenderPass,
    subpass: u32,
    framebuffer: Framebuffer,
    occlusionQueryEnable: Bool32,
    queryFlags: QueryControlFlags,
    pipelineStatistics: QueryPipelineStatisticFlags,
};
pub const CommandBufferBeginInfo = extern struct {
    sType: StructureType = .commandBufferBeginInfo,
    pNext: ?*const c_void = null,
    flags: CommandBufferUsageFlags,
    pInheritanceInfo: ?*const CommandBufferInheritanceInfo,
};
pub const RenderPassBeginInfo = extern struct {
    sType: StructureType = .renderPassBeginInfo,
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
    sType: StructureType = .renderPassCreateInfo,
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
    sType: StructureType = .eventCreateInfo,
    pNext: ?*const c_void = null,
    flags: EventCreateFlags,
};
pub const FenceCreateInfo = extern struct {
    sType: StructureType = .fenceCreateInfo,
    pNext: ?*const c_void = null,
    flags: FenceCreateFlags,
};
pub const PhysicalDeviceFeatures = extern struct {
    robustBufferAccess: Bool32 = FALSE,
    fullDrawIndexUint32: Bool32 = FALSE,
    imageCubeArray: Bool32 = FALSE,
    independentBlend: Bool32 = FALSE,
    geometryShader: Bool32 = FALSE,
    tessellationShader: Bool32 = FALSE,
    sampleRateShading: Bool32 = FALSE,
    dualSrcBlend: Bool32 = FALSE,
    logicOp: Bool32 = FALSE,
    multiDrawIndirect: Bool32 = FALSE,
    drawIndirectFirstInstance: Bool32 = FALSE,
    depthClamp: Bool32 = FALSE,
    depthBiasClamp: Bool32 = FALSE,
    fillModeNonSolid: Bool32 = FALSE,
    depthBounds: Bool32 = FALSE,
    wideLines: Bool32 = FALSE,
    largePoints: Bool32 = FALSE,
    alphaToOne: Bool32 = FALSE,
    multiViewport: Bool32 = FALSE,
    samplerAnisotropy: Bool32 = FALSE,
    textureCompressionEtc2: Bool32 = FALSE,
    textureCompressionAstcLdr: Bool32 = FALSE,
    textureCompressionBc: Bool32 = FALSE,
    occlusionQueryPrecise: Bool32 = FALSE,
    pipelineStatisticsQuery: Bool32 = FALSE,
    vertexPipelineStoresAndAtomics: Bool32 = FALSE,
    fragmentStoresAndAtomics: Bool32 = FALSE,
    shaderTessellationAndGeometryPointSize: Bool32 = FALSE,
    shaderImageGatherExtended: Bool32 = FALSE,
    shaderStorageImageExtendedFormats: Bool32 = FALSE,
    shaderStorageImageMultisample: Bool32 = FALSE,
    shaderStorageImageReadWithoutFormat: Bool32 = FALSE,
    shaderStorageImageWriteWithoutFormat: Bool32 = FALSE,
    shaderUniformBufferArrayDynamicIndexing: Bool32 = FALSE,
    shaderSampledImageArrayDynamicIndexing: Bool32 = FALSE,
    shaderStorageBufferArrayDynamicIndexing: Bool32 = FALSE,
    shaderStorageImageArrayDynamicIndexing: Bool32 = FALSE,
    shaderClipDistance: Bool32 = FALSE,
    shaderCullDistance: Bool32 = FALSE,
    shaderFloat64: Bool32 = FALSE,
    shaderInt64: Bool32 = FALSE,
    shaderInt16: Bool32 = FALSE,
    shaderResourceResidency: Bool32 = FALSE,
    shaderResourceMinLod: Bool32 = FALSE,
    sparseBinding: Bool32 = FALSE,
    sparseResidencyBuffer: Bool32 = FALSE,
    sparseResidencyImage2D: Bool32 = FALSE,
    sparseResidencyImage3D: Bool32 = FALSE,
    sparseResidency2Samples: Bool32 = FALSE,
    sparseResidency4Samples: Bool32 = FALSE,
    sparseResidency8Samples: Bool32 = FALSE,
    sparseResidency16Samples: Bool32 = FALSE,
    sparseResidencyAliased: Bool32 = FALSE,
    variableMultisampleRate: Bool32 = FALSE,
    inheritedQueries: Bool32 = FALSE,
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
    sType: StructureType = .semaphoreCreateInfo,
    pNext: ?*const c_void = null,
    flags: SemaphoreCreateFlags,
};
pub const QueryPoolCreateInfo = extern struct {
    sType: StructureType = .queryPoolCreateInfo,
    pNext: ?*const c_void = null,
    flags: QueryPoolCreateFlags,
    queryType: QueryType,
    queryCount: u32,
    pipelineStatistics: QueryPipelineStatisticFlags,
};
pub const FramebufferCreateInfo = extern struct {
    sType: StructureType = .framebufferCreateInfo,
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
pub const MultiDrawInfoEXT = extern struct {
    firstVertex: u32,
    vertexCount: u32,
};
pub const MultiDrawIndexedInfoEXT = extern struct {
    firstIndex: u32,
    indexCount: u32,
    vertexOffset: i32,
};
pub const SubmitInfo = extern struct {
    sType: StructureType = .submitInfo,
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
    sType: StructureType = .displayModeCreateInfoKHR,
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
    sType: StructureType = .displaySurfaceCreateInfoKHR,
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
    sType: StructureType = .displayPresentInfoKHR,
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
    sType: StructureType = .androidSurfaceCreateInfoKHR,
    pNext: ?*const c_void = null,
    flags: AndroidSurfaceCreateFlagsKHR,
    window: *ANativeWindow,
};
pub const ViSurfaceCreateInfoNN = extern struct {
    sType: StructureType = .viSurfaceCreateInfoNN,
    pNext: ?*const c_void = null,
    flags: ViSurfaceCreateFlagsNN,
    window: *c_void,
};
pub const WaylandSurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .waylandSurfaceCreateInfoKHR,
    pNext: ?*const c_void = null,
    flags: WaylandSurfaceCreateFlagsKHR,
    display: *wl_display,
    surface: *wl_surface,
};
pub const Win32SurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .win32SurfaceCreateInfoKHR,
    pNext: ?*const c_void = null,
    flags: Win32SurfaceCreateFlagsKHR,
    hinstance: HINSTANCE,
    hwnd: HWND,
};
pub const XlibSurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .xlibSurfaceCreateInfoKHR,
    pNext: ?*const c_void = null,
    flags: XlibSurfaceCreateFlagsKHR,
    dpy: *Display,
    window: Window,
};
pub const XcbSurfaceCreateInfoKHR = extern struct {
    sType: StructureType = .xcbSurfaceCreateInfoKHR,
    pNext: ?*const c_void = null,
    flags: XcbSurfaceCreateFlagsKHR,
    connection: *xcb_connection_t,
    window: xcb_window_t,
};
pub const DirectFBSurfaceCreateInfoEXT = extern struct {
    sType: StructureType = .directfbSurfaceCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: DirectFBSurfaceCreateFlagsEXT,
    dfb: *IDirectFB,
    surface: *IDirectFBSurface,
};
pub const ImagePipeSurfaceCreateInfoFUCHSIA = extern struct {
    sType: StructureType = .imagepipeSurfaceCreateInfoFUCHSIA,
    pNext: ?*const c_void = null,
    flags: ImagePipeSurfaceCreateFlagsFUCHSIA,
    imagePipeHandle: zx_handle_t,
};
pub const StreamDescriptorSurfaceCreateInfoGGP = extern struct {
    sType: StructureType = .streamDescriptorSurfaceCreateInfoGGP,
    pNext: ?*const c_void = null,
    flags: StreamDescriptorSurfaceCreateFlagsGGP,
    streamDescriptor: GgpStreamDescriptor,
};
pub const ScreenSurfaceCreateInfoQNX = extern struct {
    sType: StructureType = .screenSurfaceCreateInfoQNX,
    pNext: ?*const c_void = null,
    flags: ScreenSurfaceCreateFlagsQNX,
    context: *_screen_context,
    window: *_screen_window,
};
pub const SurfaceFormatKHR = extern struct {
    format: Format,
    colorSpace: ColorSpaceKHR,
};
pub const SwapchainCreateInfoKHR = extern struct {
    sType: StructureType = .swapchainCreateInfoKHR,
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
    sType: StructureType = .presentInfoKHR,
    pNext: ?*const c_void = null,
    waitSemaphoreCount: u32,
    pWaitSemaphores: [*]const Semaphore,
    swapchainCount: u32,
    pSwapchains: [*]const SwapchainKHR,
    pImageIndices: [*]const u32,
    pResults: ?[*]Result,
};
pub const DebugReportCallbackCreateInfoEXT = extern struct {
    sType: StructureType = .debugReportCallbackCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: DebugReportFlagsEXT,
    pfnCallback: PfnDebugReportCallbackEXT,
    pUserData: ?*c_void,
};
pub const ValidationFlagsEXT = extern struct {
    sType: StructureType = .validationFlagsEXT,
    pNext: ?*const c_void = null,
    disabledValidationCheckCount: u32,
    pDisabledValidationChecks: [*]const ValidationCheckEXT,
};
pub const ValidationFeaturesEXT = extern struct {
    sType: StructureType = .validationFeaturesEXT,
    pNext: ?*const c_void = null,
    enabledValidationFeatureCount: u32,
    pEnabledValidationFeatures: [*]const ValidationFeatureEnableEXT,
    disabledValidationFeatureCount: u32,
    pDisabledValidationFeatures: [*]const ValidationFeatureDisableEXT,
};
pub const PipelineRasterizationStateRasterizationOrderAMD = extern struct {
    sType: StructureType = .pipelineRasterizationStateRasterizationOrderAMD,
    pNext: ?*const c_void = null,
    rasterizationOrder: RasterizationOrderAMD,
};
pub const DebugMarkerObjectNameInfoEXT = extern struct {
    sType: StructureType = .debugMarkerObjectNameInfoEXT,
    pNext: ?*const c_void = null,
    objectType: DebugReportObjectTypeEXT,
    object: u64,
    pObjectName: [*:0]const u8,
};
pub const DebugMarkerObjectTagInfoEXT = extern struct {
    sType: StructureType = .debugMarkerObjectTagInfoEXT,
    pNext: ?*const c_void = null,
    objectType: DebugReportObjectTypeEXT,
    object: u64,
    tagName: u64,
    tagSize: usize,
    pTag: *const c_void,
};
pub const DebugMarkerMarkerInfoEXT = extern struct {
    sType: StructureType = .debugMarkerMarkerInfoEXT,
    pNext: ?*const c_void = null,
    pMarkerName: [*:0]const u8,
    color: [4]f32,
};
pub const DedicatedAllocationImageCreateInfoNV = extern struct {
    sType: StructureType = .dedicatedAllocationImageCreateInfoNV,
    pNext: ?*const c_void = null,
    dedicatedAllocation: Bool32,
};
pub const DedicatedAllocationBufferCreateInfoNV = extern struct {
    sType: StructureType = .dedicatedAllocationBufferCreateInfoNV,
    pNext: ?*const c_void = null,
    dedicatedAllocation: Bool32,
};
pub const DedicatedAllocationMemoryAllocateInfoNV = extern struct {
    sType: StructureType = .dedicatedAllocationMemoryAllocateInfoNV,
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
    sType: StructureType = .externalMemoryImageCreateInfoNV,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlagsNV,
};
pub const ExportMemoryAllocateInfoNV = extern struct {
    sType: StructureType = .exportMemoryAllocateInfoNV,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlagsNV,
};
pub const ImportMemoryWin32HandleInfoNV = extern struct {
    sType: StructureType = .importMemoryWin32HandleInfoNV,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlagsNV,
    handle: HANDLE,
};
pub const ExportMemoryWin32HandleInfoNV = extern struct {
    sType: StructureType = .exportMemoryWin32HandleInfoNV,
    pNext: ?*const c_void = null,
    pAttributes: ?*const SECURITY_ATTRIBUTES,
    dwAccess: DWORD,
};
pub const Win32KeyedMutexAcquireReleaseInfoNV = extern struct {
    sType: StructureType = .win32KeyedMutexAcquireReleaseInfoNV,
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
    sType: StructureType = .physicalDeviceDeviceGeneratedCommandsFeaturesNV,
    pNext: ?*c_void = null,
    deviceGeneratedCommands: Bool32 = FALSE,
};
pub const DevicePrivateDataCreateInfoEXT = extern struct {
    sType: StructureType = .devicePrivateDataCreateInfoEXT,
    pNext: ?*const c_void = null,
    privateDataSlotRequestCount: u32,
};
pub const PrivateDataSlotCreateInfoEXT = extern struct {
    sType: StructureType = .privateDataSlotCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: PrivateDataSlotCreateFlagsEXT,
};
pub const PhysicalDevicePrivateDataFeaturesEXT = extern struct {
    sType: StructureType = .physicalDevicePrivateDataFeaturesEXT,
    pNext: ?*c_void = null,
    privateData: Bool32 = FALSE,
};
pub const PhysicalDeviceDeviceGeneratedCommandsPropertiesNV = extern struct {
    sType: StructureType = .physicalDeviceDeviceGeneratedCommandsPropertiesNV,
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
pub const PhysicalDeviceMultiDrawPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceMultiDrawPropertiesEXT,
    pNext: ?*c_void = null,
    maxMultiDrawCount: u32,
};
pub const GraphicsShaderGroupCreateInfoNV = extern struct {
    sType: StructureType = .graphicsShaderGroupCreateInfoNV,
    pNext: ?*const c_void = null,
    stageCount: u32,
    pStages: [*]const PipelineShaderStageCreateInfo,
    pVertexInputState: ?*const PipelineVertexInputStateCreateInfo,
    pTessellationState: ?*const PipelineTessellationStateCreateInfo,
};
pub const GraphicsPipelineShaderGroupsCreateInfoNV = extern struct {
    sType: StructureType = .graphicsPipelineShaderGroupsCreateInfoNV,
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
    sType: StructureType = .indirectCommandsLayoutTokenNV,
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
    sType: StructureType = .indirectCommandsLayoutCreateInfoNV,
    pNext: ?*const c_void = null,
    flags: IndirectCommandsLayoutUsageFlagsNV,
    pipelineBindPoint: PipelineBindPoint,
    tokenCount: u32,
    pTokens: [*]const IndirectCommandsLayoutTokenNV,
    streamCount: u32,
    pStreamStrides: [*]const u32,
};
pub const GeneratedCommandsInfoNV = extern struct {
    sType: StructureType = .generatedCommandsInfoNV,
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
    sType: StructureType = .generatedCommandsMemoryRequirementsInfoNV,
    pNext: ?*const c_void = null,
    pipelineBindPoint: PipelineBindPoint,
    pipeline: Pipeline,
    indirectCommandsLayout: IndirectCommandsLayoutNV,
    maxSequencesCount: u32,
};
pub const PhysicalDeviceFeatures2 = extern struct {
    sType: StructureType = .physicalDeviceFeatures2,
    pNext: ?*c_void = null,
    features: PhysicalDeviceFeatures,
};
pub const PhysicalDeviceFeatures2KHR = PhysicalDeviceFeatures2;
pub const PhysicalDeviceProperties2 = extern struct {
    sType: StructureType = .physicalDeviceProperties2,
    pNext: ?*c_void = null,
    properties: PhysicalDeviceProperties,
};
pub const PhysicalDeviceProperties2KHR = PhysicalDeviceProperties2;
pub const FormatProperties2 = extern struct {
    sType: StructureType = .formatProperties2,
    pNext: ?*c_void = null,
    formatProperties: FormatProperties,
};
pub const FormatProperties2KHR = FormatProperties2;
pub const ImageFormatProperties2 = extern struct {
    sType: StructureType = .imageFormatProperties2,
    pNext: ?*c_void = null,
    imageFormatProperties: ImageFormatProperties,
};
pub const ImageFormatProperties2KHR = ImageFormatProperties2;
pub const PhysicalDeviceImageFormatInfo2 = extern struct {
    sType: StructureType = .physicalDeviceImageFormatInfo2,
    pNext: ?*const c_void = null,
    format: Format,
    @"type": ImageType,
    tiling: ImageTiling,
    usage: ImageUsageFlags,
    flags: ImageCreateFlags,
};
pub const PhysicalDeviceImageFormatInfo2KHR = PhysicalDeviceImageFormatInfo2;
pub const QueueFamilyProperties2 = extern struct {
    sType: StructureType = .queueFamilyProperties2,
    pNext: ?*c_void = null,
    queueFamilyProperties: QueueFamilyProperties,
};
pub const QueueFamilyProperties2KHR = QueueFamilyProperties2;
pub const PhysicalDeviceMemoryProperties2 = extern struct {
    sType: StructureType = .physicalDeviceMemoryProperties2,
    pNext: ?*c_void = null,
    memoryProperties: PhysicalDeviceMemoryProperties,
};
pub const PhysicalDeviceMemoryProperties2KHR = PhysicalDeviceMemoryProperties2;
pub const SparseImageFormatProperties2 = extern struct {
    sType: StructureType = .sparseImageFormatProperties2,
    pNext: ?*c_void = null,
    properties: SparseImageFormatProperties,
};
pub const SparseImageFormatProperties2KHR = SparseImageFormatProperties2;
pub const PhysicalDeviceSparseImageFormatInfo2 = extern struct {
    sType: StructureType = .physicalDeviceSparseImageFormatInfo2,
    pNext: ?*const c_void = null,
    format: Format,
    @"type": ImageType,
    samples: SampleCountFlags,
    usage: ImageUsageFlags,
    tiling: ImageTiling,
};
pub const PhysicalDeviceSparseImageFormatInfo2KHR = PhysicalDeviceSparseImageFormatInfo2;
pub const PhysicalDevicePushDescriptorPropertiesKHR = extern struct {
    sType: StructureType = .physicalDevicePushDescriptorPropertiesKHR,
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
    sType: StructureType = .physicalDeviceDriverProperties,
    pNext: ?*c_void = null,
    driverId: DriverId,
    driverName: [MAX_DRIVER_NAME_SIZE]u8,
    driverInfo: [MAX_DRIVER_INFO_SIZE]u8,
    conformanceVersion: ConformanceVersion,
};
pub const PhysicalDeviceDriverPropertiesKHR = PhysicalDeviceDriverProperties;
pub const PresentRegionsKHR = extern struct {
    sType: StructureType = .presentRegionsKHR,
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
    sType: StructureType = .physicalDeviceVariablePointersFeatures,
    pNext: ?*c_void = null,
    variablePointersStorageBuffer: Bool32 = FALSE,
    variablePointers: Bool32 = FALSE,
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
    sType: StructureType = .physicalDeviceExternalImageFormatInfo,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const PhysicalDeviceExternalImageFormatInfoKHR = PhysicalDeviceExternalImageFormatInfo;
pub const ExternalImageFormatProperties = extern struct {
    sType: StructureType = .externalImageFormatProperties,
    pNext: ?*c_void = null,
    externalMemoryProperties: ExternalMemoryProperties,
};
pub const ExternalImageFormatPropertiesKHR = ExternalImageFormatProperties;
pub const PhysicalDeviceExternalBufferInfo = extern struct {
    sType: StructureType = .physicalDeviceExternalBufferInfo,
    pNext: ?*const c_void = null,
    flags: BufferCreateFlags,
    usage: BufferUsageFlags,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const PhysicalDeviceExternalBufferInfoKHR = PhysicalDeviceExternalBufferInfo;
pub const ExternalBufferProperties = extern struct {
    sType: StructureType = .externalBufferProperties,
    pNext: ?*c_void = null,
    externalMemoryProperties: ExternalMemoryProperties,
};
pub const ExternalBufferPropertiesKHR = ExternalBufferProperties;
pub const PhysicalDeviceIDProperties = extern struct {
    sType: StructureType = .physicalDeviceIdProperties,
    pNext: ?*c_void = null,
    deviceUuid: [UUID_SIZE]u8,
    driverUuid: [UUID_SIZE]u8,
    deviceLuid: [LUID_SIZE]u8,
    deviceNodeMask: u32,
    deviceLuidValid: Bool32,
};
pub const PhysicalDeviceIDPropertiesKHR = PhysicalDeviceIDProperties;
pub const ExternalMemoryImageCreateInfo = extern struct {
    sType: StructureType = .externalMemoryImageCreateInfo,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlags,
};
pub const ExternalMemoryImageCreateInfoKHR = ExternalMemoryImageCreateInfo;
pub const ExternalMemoryBufferCreateInfo = extern struct {
    sType: StructureType = .externalMemoryBufferCreateInfo,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlags,
};
pub const ExternalMemoryBufferCreateInfoKHR = ExternalMemoryBufferCreateInfo;
pub const ExportMemoryAllocateInfo = extern struct {
    sType: StructureType = .exportMemoryAllocateInfo,
    pNext: ?*const c_void = null,
    handleTypes: ExternalMemoryHandleTypeFlags,
};
pub const ExportMemoryAllocateInfoKHR = ExportMemoryAllocateInfo;
pub const ImportMemoryWin32HandleInfoKHR = extern struct {
    sType: StructureType = .importMemoryWin32HandleInfoKHR,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlags,
    handle: HANDLE,
    name: LPCWSTR,
};
pub const ExportMemoryWin32HandleInfoKHR = extern struct {
    sType: StructureType = .exportMemoryWin32HandleInfoKHR,
    pNext: ?*const c_void = null,
    pAttributes: ?*const SECURITY_ATTRIBUTES,
    dwAccess: DWORD,
    name: LPCWSTR,
};
pub const ImportMemoryZirconHandleInfoFUCHSIA = extern struct {
    sType: StructureType = .importMemoryZirconHandleInfoFUCHSIA,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlags,
    handle: zx_handle_t,
};
pub const MemoryZirconHandlePropertiesFUCHSIA = extern struct {
    sType: StructureType = .memoryZirconHandlePropertiesFUCHSIA,
    pNext: ?*c_void = null,
    memoryTypeBits: u32,
};
pub const MemoryGetZirconHandleInfoFUCHSIA = extern struct {
    sType: StructureType = .memoryGetZirconHandleInfoFUCHSIA,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const MemoryWin32HandlePropertiesKHR = extern struct {
    sType: StructureType = .memoryWin32HandlePropertiesKHR,
    pNext: ?*c_void = null,
    memoryTypeBits: u32,
};
pub const MemoryGetWin32HandleInfoKHR = extern struct {
    sType: StructureType = .memoryGetWin32HandleInfoKHR,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const ImportMemoryFdInfoKHR = extern struct {
    sType: StructureType = .importMemoryFdInfoKHR,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlags,
    fd: c_int,
};
pub const MemoryFdPropertiesKHR = extern struct {
    sType: StructureType = .memoryFdPropertiesKHR,
    pNext: ?*c_void = null,
    memoryTypeBits: u32,
};
pub const MemoryGetFdInfoKHR = extern struct {
    sType: StructureType = .memoryGetFdInfoKHR,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const Win32KeyedMutexAcquireReleaseInfoKHR = extern struct {
    sType: StructureType = .win32KeyedMutexAcquireReleaseInfoKHR,
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
    sType: StructureType = .physicalDeviceExternalSemaphoreInfo,
    pNext: ?*const c_void = null,
    handleType: ExternalSemaphoreHandleTypeFlags,
};
pub const PhysicalDeviceExternalSemaphoreInfoKHR = PhysicalDeviceExternalSemaphoreInfo;
pub const ExternalSemaphoreProperties = extern struct {
    sType: StructureType = .externalSemaphoreProperties,
    pNext: ?*c_void = null,
    exportFromImportedHandleTypes: ExternalSemaphoreHandleTypeFlags,
    compatibleHandleTypes: ExternalSemaphoreHandleTypeFlags,
    externalSemaphoreFeatures: ExternalSemaphoreFeatureFlags,
};
pub const ExternalSemaphorePropertiesKHR = ExternalSemaphoreProperties;
pub const ExportSemaphoreCreateInfo = extern struct {
    sType: StructureType = .exportSemaphoreCreateInfo,
    pNext: ?*const c_void = null,
    handleTypes: ExternalSemaphoreHandleTypeFlags,
};
pub const ExportSemaphoreCreateInfoKHR = ExportSemaphoreCreateInfo;
pub const ImportSemaphoreWin32HandleInfoKHR = extern struct {
    sType: StructureType = .importSemaphoreWin32HandleInfoKHR,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    flags: SemaphoreImportFlags,
    handleType: ExternalSemaphoreHandleTypeFlags,
    handle: HANDLE,
    name: LPCWSTR,
};
pub const ExportSemaphoreWin32HandleInfoKHR = extern struct {
    sType: StructureType = .exportSemaphoreWin32HandleInfoKHR,
    pNext: ?*const c_void = null,
    pAttributes: ?*const SECURITY_ATTRIBUTES,
    dwAccess: DWORD,
    name: LPCWSTR,
};
pub const D3D12FenceSubmitInfoKHR = extern struct {
    sType: StructureType = .d3d12FenceSubmitInfoKHR,
    pNext: ?*const c_void = null,
    waitSemaphoreValuesCount: u32,
    pWaitSemaphoreValues: ?[*]const u64,
    signalSemaphoreValuesCount: u32,
    pSignalSemaphoreValues: ?[*]const u64,
};
pub const SemaphoreGetWin32HandleInfoKHR = extern struct {
    sType: StructureType = .semaphoreGetWin32HandleInfoKHR,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    handleType: ExternalSemaphoreHandleTypeFlags,
};
pub const ImportSemaphoreFdInfoKHR = extern struct {
    sType: StructureType = .importSemaphoreFdInfoKHR,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    flags: SemaphoreImportFlags,
    handleType: ExternalSemaphoreHandleTypeFlags,
    fd: c_int,
};
pub const SemaphoreGetFdInfoKHR = extern struct {
    sType: StructureType = .semaphoreGetFdInfoKHR,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    handleType: ExternalSemaphoreHandleTypeFlags,
};
pub const ImportSemaphoreZirconHandleInfoFUCHSIA = extern struct {
    sType: StructureType = .importSemaphoreZirconHandleInfoFUCHSIA,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    flags: SemaphoreImportFlags,
    handleType: ExternalSemaphoreHandleTypeFlags,
    zirconHandle: zx_handle_t,
};
pub const SemaphoreGetZirconHandleInfoFUCHSIA = extern struct {
    sType: StructureType = .semaphoreGetZirconHandleInfoFUCHSIA,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    handleType: ExternalSemaphoreHandleTypeFlags,
};
pub const PhysicalDeviceExternalFenceInfo = extern struct {
    sType: StructureType = .physicalDeviceExternalFenceInfo,
    pNext: ?*const c_void = null,
    handleType: ExternalFenceHandleTypeFlags,
};
pub const PhysicalDeviceExternalFenceInfoKHR = PhysicalDeviceExternalFenceInfo;
pub const ExternalFenceProperties = extern struct {
    sType: StructureType = .externalFenceProperties,
    pNext: ?*c_void = null,
    exportFromImportedHandleTypes: ExternalFenceHandleTypeFlags,
    compatibleHandleTypes: ExternalFenceHandleTypeFlags,
    externalFenceFeatures: ExternalFenceFeatureFlags,
};
pub const ExternalFencePropertiesKHR = ExternalFenceProperties;
pub const ExportFenceCreateInfo = extern struct {
    sType: StructureType = .exportFenceCreateInfo,
    pNext: ?*const c_void = null,
    handleTypes: ExternalFenceHandleTypeFlags,
};
pub const ExportFenceCreateInfoKHR = ExportFenceCreateInfo;
pub const ImportFenceWin32HandleInfoKHR = extern struct {
    sType: StructureType = .importFenceWin32HandleInfoKHR,
    pNext: ?*const c_void = null,
    fence: Fence,
    flags: FenceImportFlags,
    handleType: ExternalFenceHandleTypeFlags,
    handle: HANDLE,
    name: LPCWSTR,
};
pub const ExportFenceWin32HandleInfoKHR = extern struct {
    sType: StructureType = .exportFenceWin32HandleInfoKHR,
    pNext: ?*const c_void = null,
    pAttributes: ?*const SECURITY_ATTRIBUTES,
    dwAccess: DWORD,
    name: LPCWSTR,
};
pub const FenceGetWin32HandleInfoKHR = extern struct {
    sType: StructureType = .fenceGetWin32HandleInfoKHR,
    pNext: ?*const c_void = null,
    fence: Fence,
    handleType: ExternalFenceHandleTypeFlags,
};
pub const ImportFenceFdInfoKHR = extern struct {
    sType: StructureType = .importFenceFdInfoKHR,
    pNext: ?*const c_void = null,
    fence: Fence,
    flags: FenceImportFlags,
    handleType: ExternalFenceHandleTypeFlags,
    fd: c_int,
};
pub const FenceGetFdInfoKHR = extern struct {
    sType: StructureType = .fenceGetFdInfoKHR,
    pNext: ?*const c_void = null,
    fence: Fence,
    handleType: ExternalFenceHandleTypeFlags,
};
pub const PhysicalDeviceMultiviewFeatures = extern struct {
    sType: StructureType = .physicalDeviceMultiviewFeatures,
    pNext: ?*c_void = null,
    multiview: Bool32 = FALSE,
    multiviewGeometryShader: Bool32 = FALSE,
    multiviewTessellationShader: Bool32 = FALSE,
};
pub const PhysicalDeviceMultiviewFeaturesKHR = PhysicalDeviceMultiviewFeatures;
pub const PhysicalDeviceMultiviewProperties = extern struct {
    sType: StructureType = .physicalDeviceMultiviewProperties,
    pNext: ?*c_void = null,
    maxMultiviewViewCount: u32,
    maxMultiviewInstanceIndex: u32,
};
pub const PhysicalDeviceMultiviewPropertiesKHR = PhysicalDeviceMultiviewProperties;
pub const RenderPassMultiviewCreateInfo = extern struct {
    sType: StructureType = .renderPassMultiviewCreateInfo,
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
    sType: StructureType = .surfaceCapabilities2EXT,
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
    sType: StructureType = .displayPowerInfoEXT,
    pNext: ?*const c_void = null,
    powerState: DisplayPowerStateEXT,
};
pub const DeviceEventInfoEXT = extern struct {
    sType: StructureType = .deviceEventInfoEXT,
    pNext: ?*const c_void = null,
    deviceEvent: DeviceEventTypeEXT,
};
pub const DisplayEventInfoEXT = extern struct {
    sType: StructureType = .displayEventInfoEXT,
    pNext: ?*const c_void = null,
    displayEvent: DisplayEventTypeEXT,
};
pub const SwapchainCounterCreateInfoEXT = extern struct {
    sType: StructureType = .swapchainCounterCreateInfoEXT,
    pNext: ?*const c_void = null,
    surfaceCounters: SurfaceCounterFlagsEXT,
};
pub const PhysicalDeviceGroupProperties = extern struct {
    sType: StructureType = .physicalDeviceGroupProperties,
    pNext: ?*c_void = null,
    physicalDeviceCount: u32,
    physicalDevices: [MAX_DEVICE_GROUP_SIZE]PhysicalDevice,
    subsetAllocation: Bool32,
};
pub const PhysicalDeviceGroupPropertiesKHR = PhysicalDeviceGroupProperties;
pub const MemoryAllocateFlagsInfo = extern struct {
    sType: StructureType = .memoryAllocateFlagsInfo,
    pNext: ?*const c_void = null,
    flags: MemoryAllocateFlags,
    deviceMask: u32,
};
pub const MemoryAllocateFlagsInfoKHR = MemoryAllocateFlagsInfo;
pub const BindBufferMemoryInfo = extern struct {
    sType: StructureType = .bindBufferMemoryInfo,
    pNext: ?*const c_void = null,
    buffer: Buffer,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
};
pub const BindBufferMemoryInfoKHR = BindBufferMemoryInfo;
pub const BindBufferMemoryDeviceGroupInfo = extern struct {
    sType: StructureType = .bindBufferMemoryDeviceGroupInfo,
    pNext: ?*const c_void = null,
    deviceIndexCount: u32,
    pDeviceIndices: [*]const u32,
};
pub const BindBufferMemoryDeviceGroupInfoKHR = BindBufferMemoryDeviceGroupInfo;
pub const BindImageMemoryInfo = extern struct {
    sType: StructureType = .bindImageMemoryInfo,
    pNext: ?*const c_void = null,
    image: Image,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
};
pub const BindImageMemoryInfoKHR = BindImageMemoryInfo;
pub const BindImageMemoryDeviceGroupInfo = extern struct {
    sType: StructureType = .bindImageMemoryDeviceGroupInfo,
    pNext: ?*const c_void = null,
    deviceIndexCount: u32,
    pDeviceIndices: [*]const u32,
    splitInstanceBindRegionCount: u32,
    pSplitInstanceBindRegions: [*]const Rect2D,
};
pub const BindImageMemoryDeviceGroupInfoKHR = BindImageMemoryDeviceGroupInfo;
pub const DeviceGroupRenderPassBeginInfo = extern struct {
    sType: StructureType = .deviceGroupRenderPassBeginInfo,
    pNext: ?*const c_void = null,
    deviceMask: u32,
    deviceRenderAreaCount: u32,
    pDeviceRenderAreas: [*]const Rect2D,
};
pub const DeviceGroupRenderPassBeginInfoKHR = DeviceGroupRenderPassBeginInfo;
pub const DeviceGroupCommandBufferBeginInfo = extern struct {
    sType: StructureType = .deviceGroupCommandBufferBeginInfo,
    pNext: ?*const c_void = null,
    deviceMask: u32,
};
pub const DeviceGroupCommandBufferBeginInfoKHR = DeviceGroupCommandBufferBeginInfo;
pub const DeviceGroupSubmitInfo = extern struct {
    sType: StructureType = .deviceGroupSubmitInfo,
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
    sType: StructureType = .deviceGroupBindSparseInfo,
    pNext: ?*const c_void = null,
    resourceDeviceIndex: u32,
    memoryDeviceIndex: u32,
};
pub const DeviceGroupBindSparseInfoKHR = DeviceGroupBindSparseInfo;
pub const DeviceGroupPresentCapabilitiesKHR = extern struct {
    sType: StructureType = .deviceGroupPresentCapabilitiesKHR,
    pNext: ?*c_void = null,
    presentMask: [MAX_DEVICE_GROUP_SIZE]u32,
    modes: DeviceGroupPresentModeFlagsKHR,
};
pub const ImageSwapchainCreateInfoKHR = extern struct {
    sType: StructureType = .imageSwapchainCreateInfoKHR,
    pNext: ?*const c_void = null,
    swapchain: SwapchainKHR,
};
pub const BindImageMemorySwapchainInfoKHR = extern struct {
    sType: StructureType = .bindImageMemorySwapchainInfoKHR,
    pNext: ?*const c_void = null,
    swapchain: SwapchainKHR,
    imageIndex: u32,
};
pub const AcquireNextImageInfoKHR = extern struct {
    sType: StructureType = .acquireNextImageInfoKHR,
    pNext: ?*const c_void = null,
    swapchain: SwapchainKHR,
    timeout: u64,
    semaphore: Semaphore,
    fence: Fence,
    deviceMask: u32,
};
pub const DeviceGroupPresentInfoKHR = extern struct {
    sType: StructureType = .deviceGroupPresentInfoKHR,
    pNext: ?*const c_void = null,
    swapchainCount: u32,
    pDeviceMasks: [*]const u32,
    mode: DeviceGroupPresentModeFlagsKHR,
};
pub const DeviceGroupDeviceCreateInfo = extern struct {
    sType: StructureType = .deviceGroupDeviceCreateInfo,
    pNext: ?*const c_void = null,
    physicalDeviceCount: u32,
    pPhysicalDevices: [*]const PhysicalDevice,
};
pub const DeviceGroupDeviceCreateInfoKHR = DeviceGroupDeviceCreateInfo;
pub const DeviceGroupSwapchainCreateInfoKHR = extern struct {
    sType: StructureType = .deviceGroupSwapchainCreateInfoKHR,
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
    sType: StructureType = .descriptorUpdateTemplateCreateInfo,
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
pub const PhysicalDevicePresentIdFeaturesKHR = extern struct {
    sType: StructureType = .physicalDevicePresentIdFeaturesKHR,
    pNext: ?*c_void = null,
    presentId: Bool32 = FALSE,
};
pub const PresentIdKHR = extern struct {
    sType: StructureType = .presentIdKHR,
    pNext: ?*const c_void = null,
    swapchainCount: u32,
    pPresentIds: ?[*]const u64,
};
pub const PhysicalDevicePresentWaitFeaturesKHR = extern struct {
    sType: StructureType = .physicalDevicePresentWaitFeaturesKHR,
    pNext: ?*c_void = null,
    presentWait: Bool32 = FALSE,
};
pub const HdrMetadataEXT = extern struct {
    sType: StructureType = .hdrMetadataEXT,
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
    sType: StructureType = .displayNativeHdrSurfaceCapabilitiesAMD,
    pNext: ?*c_void = null,
    localDimmingSupport: Bool32,
};
pub const SwapchainDisplayNativeHdrCreateInfoAMD = extern struct {
    sType: StructureType = .swapchainDisplayNativeHdrCreateInfoAMD,
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
    sType: StructureType = .presentTimesInfoGOOGLE,
    pNext: ?*const c_void = null,
    swapchainCount: u32,
    pTimes: ?[*]const PresentTimeGOOGLE,
};
pub const PresentTimeGOOGLE = extern struct {
    presentId: u32,
    desiredPresentTime: u64,
};
pub const IOSSurfaceCreateInfoMVK = extern struct {
    sType: StructureType = .iosSurfaceCreateInfoMVK,
    pNext: ?*const c_void = null,
    flags: IOSSurfaceCreateFlagsMVK,
    pView: *const c_void,
};
pub const MacOSSurfaceCreateInfoMVK = extern struct {
    sType: StructureType = .macosSurfaceCreateInfoMVK,
    pNext: ?*const c_void = null,
    flags: MacOSSurfaceCreateFlagsMVK,
    pView: *const c_void,
};
pub const MetalSurfaceCreateInfoEXT = extern struct {
    sType: StructureType = .metalSurfaceCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: MetalSurfaceCreateFlagsEXT,
    pLayer: *const CAMetalLayer,
};
pub const ViewportWScalingNV = extern struct {
    xcoeff: f32,
    ycoeff: f32,
};
pub const PipelineViewportWScalingStateCreateInfoNV = extern struct {
    sType: StructureType = .pipelineViewportWScalingStateCreateInfoNV,
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
    sType: StructureType = .pipelineViewportSwizzleStateCreateInfoNV,
    pNext: ?*const c_void = null,
    flags: PipelineViewportSwizzleStateCreateFlagsNV,
    viewportCount: u32,
    pViewportSwizzles: [*]const ViewportSwizzleNV,
};
pub const PhysicalDeviceDiscardRectanglePropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceDiscardRectanglePropertiesEXT,
    pNext: ?*c_void = null,
    maxDiscardRectangles: u32,
};
pub const PipelineDiscardRectangleStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineDiscardRectangleStateCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: PipelineDiscardRectangleStateCreateFlagsEXT,
    discardRectangleMode: DiscardRectangleModeEXT,
    discardRectangleCount: u32,
    pDiscardRectangles: [*]const Rect2D,
};
pub const PhysicalDeviceMultiviewPerViewAttributesPropertiesNVX = extern struct {
    sType: StructureType = .physicalDeviceMultiviewPerViewAttributesPropertiesNVX,
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
    sType: StructureType = .renderPassInputAttachmentAspectCreateInfo,
    pNext: ?*const c_void = null,
    aspectReferenceCount: u32,
    pAspectReferences: [*]const InputAttachmentAspectReference,
};
pub const RenderPassInputAttachmentAspectCreateInfoKHR = RenderPassInputAttachmentAspectCreateInfo;
pub const PhysicalDeviceSurfaceInfo2KHR = extern struct {
    sType: StructureType = .physicalDeviceSurfaceInfo2KHR,
    pNext: ?*const c_void = null,
    surface: SurfaceKHR,
};
pub const SurfaceCapabilities2KHR = extern struct {
    sType: StructureType = .surfaceCapabilities2KHR,
    pNext: ?*c_void = null,
    surfaceCapabilities: SurfaceCapabilitiesKHR,
};
pub const SurfaceFormat2KHR = extern struct {
    sType: StructureType = .surfaceFormat2KHR,
    pNext: ?*c_void = null,
    surfaceFormat: SurfaceFormatKHR,
};
pub const DisplayProperties2KHR = extern struct {
    sType: StructureType = .displayProperties2KHR,
    pNext: ?*c_void = null,
    displayProperties: DisplayPropertiesKHR,
};
pub const DisplayPlaneProperties2KHR = extern struct {
    sType: StructureType = .displayPlaneProperties2KHR,
    pNext: ?*c_void = null,
    displayPlaneProperties: DisplayPlanePropertiesKHR,
};
pub const DisplayModeProperties2KHR = extern struct {
    sType: StructureType = .displayModeProperties2KHR,
    pNext: ?*c_void = null,
    displayModeProperties: DisplayModePropertiesKHR,
};
pub const DisplayPlaneInfo2KHR = extern struct {
    sType: StructureType = .displayPlaneInfo2KHR,
    pNext: ?*const c_void = null,
    mode: DisplayModeKHR,
    planeIndex: u32,
};
pub const DisplayPlaneCapabilities2KHR = extern struct {
    sType: StructureType = .displayPlaneCapabilities2KHR,
    pNext: ?*c_void = null,
    capabilities: DisplayPlaneCapabilitiesKHR,
};
pub const SharedPresentSurfaceCapabilitiesKHR = extern struct {
    sType: StructureType = .sharedPresentSurfaceCapabilitiesKHR,
    pNext: ?*c_void = null,
    sharedPresentSupportedUsageFlags: ImageUsageFlags,
};
pub const PhysicalDevice16BitStorageFeatures = extern struct {
    sType: StructureType = .physicalDevice16BitStorageFeatures,
    pNext: ?*c_void = null,
    storageBuffer16BitAccess: Bool32 = FALSE,
    uniformAndStorageBuffer16BitAccess: Bool32 = FALSE,
    storagePushConstant16: Bool32 = FALSE,
    storageInputOutput16: Bool32 = FALSE,
};
pub const PhysicalDevice16BitStorageFeaturesKHR = PhysicalDevice16BitStorageFeatures;
pub const PhysicalDeviceSubgroupProperties = extern struct {
    sType: StructureType = .physicalDeviceSubgroupProperties,
    pNext: ?*c_void = null,
    subgroupSize: u32,
    supportedStages: ShaderStageFlags,
    supportedOperations: SubgroupFeatureFlags,
    quadOperationsInAllStages: Bool32,
};
pub const PhysicalDeviceShaderSubgroupExtendedTypesFeatures = extern struct {
    sType: StructureType = .physicalDeviceShaderSubgroupExtendedTypesFeatures,
    pNext: ?*c_void = null,
    shaderSubgroupExtendedTypes: Bool32 = FALSE,
};
pub const PhysicalDeviceShaderSubgroupExtendedTypesFeaturesKHR = PhysicalDeviceShaderSubgroupExtendedTypesFeatures;
pub const BufferMemoryRequirementsInfo2 = extern struct {
    sType: StructureType = .bufferMemoryRequirementsInfo2,
    pNext: ?*const c_void = null,
    buffer: Buffer,
};
pub const BufferMemoryRequirementsInfo2KHR = BufferMemoryRequirementsInfo2;
pub const DeviceBufferMemoryRequirementsKHR = extern struct {
    sType: StructureType = .deviceBufferMemoryRequirementsKHR,
    pNext: ?*const c_void = null,
    pCreateInfo: *const BufferCreateInfo,
};
pub const ImageMemoryRequirementsInfo2 = extern struct {
    sType: StructureType = .imageMemoryRequirementsInfo2,
    pNext: ?*const c_void = null,
    image: Image,
};
pub const ImageMemoryRequirementsInfo2KHR = ImageMemoryRequirementsInfo2;
pub const ImageSparseMemoryRequirementsInfo2 = extern struct {
    sType: StructureType = .imageSparseMemoryRequirementsInfo2,
    pNext: ?*const c_void = null,
    image: Image,
};
pub const ImageSparseMemoryRequirementsInfo2KHR = ImageSparseMemoryRequirementsInfo2;
pub const DeviceImageMemoryRequirementsKHR = extern struct {
    sType: StructureType = .deviceImageMemoryRequirementsKHR,
    pNext: ?*const c_void = null,
    pCreateInfo: *const ImageCreateInfo,
    planeAspect: ImageAspectFlags,
};
pub const MemoryRequirements2 = extern struct {
    sType: StructureType = .memoryRequirements2,
    pNext: ?*c_void = null,
    memoryRequirements: MemoryRequirements,
};
pub const MemoryRequirements2KHR = MemoryRequirements2;
pub const SparseImageMemoryRequirements2 = extern struct {
    sType: StructureType = .sparseImageMemoryRequirements2,
    pNext: ?*c_void = null,
    memoryRequirements: SparseImageMemoryRequirements,
};
pub const SparseImageMemoryRequirements2KHR = SparseImageMemoryRequirements2;
pub const PhysicalDevicePointClippingProperties = extern struct {
    sType: StructureType = .physicalDevicePointClippingProperties,
    pNext: ?*c_void = null,
    pointClippingBehavior: PointClippingBehavior,
};
pub const PhysicalDevicePointClippingPropertiesKHR = PhysicalDevicePointClippingProperties;
pub const MemoryDedicatedRequirements = extern struct {
    sType: StructureType = .memoryDedicatedRequirements,
    pNext: ?*c_void = null,
    prefersDedicatedAllocation: Bool32,
    requiresDedicatedAllocation: Bool32,
};
pub const MemoryDedicatedRequirementsKHR = MemoryDedicatedRequirements;
pub const MemoryDedicatedAllocateInfo = extern struct {
    sType: StructureType = .memoryDedicatedAllocateInfo,
    pNext: ?*const c_void = null,
    image: Image,
    buffer: Buffer,
};
pub const MemoryDedicatedAllocateInfoKHR = MemoryDedicatedAllocateInfo;
pub const ImageViewUsageCreateInfo = extern struct {
    sType: StructureType = .imageViewUsageCreateInfo,
    pNext: ?*const c_void = null,
    usage: ImageUsageFlags,
};
pub const ImageViewUsageCreateInfoKHR = ImageViewUsageCreateInfo;
pub const PipelineTessellationDomainOriginStateCreateInfo = extern struct {
    sType: StructureType = .pipelineTessellationDomainOriginStateCreateInfo,
    pNext: ?*const c_void = null,
    domainOrigin: TessellationDomainOrigin,
};
pub const PipelineTessellationDomainOriginStateCreateInfoKHR = PipelineTessellationDomainOriginStateCreateInfo;
pub const SamplerYcbcrConversionInfo = extern struct {
    sType: StructureType = .samplerYcbcrConversionInfo,
    pNext: ?*const c_void = null,
    conversion: SamplerYcbcrConversion,
};
pub const SamplerYcbcrConversionInfoKHR = SamplerYcbcrConversionInfo;
pub const SamplerYcbcrConversionCreateInfo = extern struct {
    sType: StructureType = .samplerYcbcrConversionCreateInfo,
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
    sType: StructureType = .bindImagePlaneMemoryInfo,
    pNext: ?*const c_void = null,
    planeAspect: ImageAspectFlags,
};
pub const BindImagePlaneMemoryInfoKHR = BindImagePlaneMemoryInfo;
pub const ImagePlaneMemoryRequirementsInfo = extern struct {
    sType: StructureType = .imagePlaneMemoryRequirementsInfo,
    pNext: ?*const c_void = null,
    planeAspect: ImageAspectFlags,
};
pub const ImagePlaneMemoryRequirementsInfoKHR = ImagePlaneMemoryRequirementsInfo;
pub const PhysicalDeviceSamplerYcbcrConversionFeatures = extern struct {
    sType: StructureType = .physicalDeviceSamplerYcbcrConversionFeatures,
    pNext: ?*c_void = null,
    samplerYcbcrConversion: Bool32 = FALSE,
};
pub const PhysicalDeviceSamplerYcbcrConversionFeaturesKHR = PhysicalDeviceSamplerYcbcrConversionFeatures;
pub const SamplerYcbcrConversionImageFormatProperties = extern struct {
    sType: StructureType = .samplerYcbcrConversionImageFormatProperties,
    pNext: ?*c_void = null,
    combinedImageSamplerDescriptorCount: u32,
};
pub const SamplerYcbcrConversionImageFormatPropertiesKHR = SamplerYcbcrConversionImageFormatProperties;
pub const TextureLODGatherFormatPropertiesAMD = extern struct {
    sType: StructureType = .textureLodGatherFormatPropertiesAMD,
    pNext: ?*c_void = null,
    supportsTextureGatherLodBiasAMD: Bool32,
};
pub const ConditionalRenderingBeginInfoEXT = extern struct {
    sType: StructureType = .conditionalRenderingBeginInfoEXT,
    pNext: ?*const c_void = null,
    buffer: Buffer,
    offset: DeviceSize,
    flags: ConditionalRenderingFlagsEXT,
};
pub const ProtectedSubmitInfo = extern struct {
    sType: StructureType = .protectedSubmitInfo,
    pNext: ?*const c_void = null,
    protectedSubmit: Bool32,
};
pub const PhysicalDeviceProtectedMemoryFeatures = extern struct {
    sType: StructureType = .physicalDeviceProtectedMemoryFeatures,
    pNext: ?*c_void = null,
    protectedMemory: Bool32 = FALSE,
};
pub const PhysicalDeviceProtectedMemoryProperties = extern struct {
    sType: StructureType = .physicalDeviceProtectedMemoryProperties,
    pNext: ?*c_void = null,
    protectedNoFault: Bool32,
};
pub const DeviceQueueInfo2 = extern struct {
    sType: StructureType = .deviceQueueInfo2,
    pNext: ?*const c_void = null,
    flags: DeviceQueueCreateFlags,
    queueFamilyIndex: u32,
    queueIndex: u32,
};
pub const PipelineCoverageToColorStateCreateInfoNV = extern struct {
    sType: StructureType = .pipelineCoverageToColorStateCreateInfoNV,
    pNext: ?*const c_void = null,
    flags: PipelineCoverageToColorStateCreateFlagsNV,
    coverageToColorEnable: Bool32,
    coverageToColorLocation: u32,
};
pub const PhysicalDeviceSamplerFilterMinmaxProperties = extern struct {
    sType: StructureType = .physicalDeviceSamplerFilterMinmaxProperties,
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
    sType: StructureType = .sampleLocationsInfoEXT,
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
    sType: StructureType = .renderPassSampleLocationsBeginInfoEXT,
    pNext: ?*const c_void = null,
    attachmentInitialSampleLocationsCount: u32,
    pAttachmentInitialSampleLocations: [*]const AttachmentSampleLocationsEXT,
    postSubpassSampleLocationsCount: u32,
    pPostSubpassSampleLocations: [*]const SubpassSampleLocationsEXT,
};
pub const PipelineSampleLocationsStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineSampleLocationsStateCreateInfoEXT,
    pNext: ?*const c_void = null,
    sampleLocationsEnable: Bool32,
    sampleLocationsInfo: SampleLocationsInfoEXT,
};
pub const PhysicalDeviceSampleLocationsPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceSampleLocationsPropertiesEXT,
    pNext: ?*c_void = null,
    sampleLocationSampleCounts: SampleCountFlags,
    maxSampleLocationGridSize: Extent2D,
    sampleLocationCoordinateRange: [2]f32,
    sampleLocationSubPixelBits: u32,
    variableSampleLocations: Bool32,
};
pub const MultisamplePropertiesEXT = extern struct {
    sType: StructureType = .multisamplePropertiesEXT,
    pNext: ?*c_void = null,
    maxSampleLocationGridSize: Extent2D,
};
pub const SamplerReductionModeCreateInfo = extern struct {
    sType: StructureType = .samplerReductionModeCreateInfo,
    pNext: ?*const c_void = null,
    reductionMode: SamplerReductionMode,
};
pub const SamplerReductionModeCreateInfoEXT = SamplerReductionModeCreateInfo;
pub const PhysicalDeviceBlendOperationAdvancedFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceBlendOperationAdvancedFeaturesEXT,
    pNext: ?*c_void = null,
    advancedBlendCoherentOperations: Bool32 = FALSE,
};
pub const PhysicalDeviceMultiDrawFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceMultiDrawFeaturesEXT,
    pNext: ?*c_void = null,
    multiDraw: Bool32 = FALSE,
};
pub const PhysicalDeviceBlendOperationAdvancedPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceBlendOperationAdvancedPropertiesEXT,
    pNext: ?*c_void = null,
    advancedBlendMaxColorAttachments: u32,
    advancedBlendIndependentBlend: Bool32,
    advancedBlendNonPremultipliedSrcColor: Bool32,
    advancedBlendNonPremultipliedDstColor: Bool32,
    advancedBlendCorrelatedOverlap: Bool32,
    advancedBlendAllOperations: Bool32,
};
pub const PipelineColorBlendAdvancedStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineColorBlendAdvancedStateCreateInfoEXT,
    pNext: ?*const c_void = null,
    srcPremultiplied: Bool32,
    dstPremultiplied: Bool32,
    blendOverlap: BlendOverlapEXT,
};
pub const PhysicalDeviceInlineUniformBlockFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceInlineUniformBlockFeaturesEXT,
    pNext: ?*c_void = null,
    inlineUniformBlock: Bool32 = FALSE,
    descriptorBindingInlineUniformBlockUpdateAfterBind: Bool32 = FALSE,
};
pub const PhysicalDeviceInlineUniformBlockPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceInlineUniformBlockPropertiesEXT,
    pNext: ?*c_void = null,
    maxInlineUniformBlockSize: u32,
    maxPerStageDescriptorInlineUniformBlocks: u32,
    maxPerStageDescriptorUpdateAfterBindInlineUniformBlocks: u32,
    maxDescriptorSetInlineUniformBlocks: u32,
    maxDescriptorSetUpdateAfterBindInlineUniformBlocks: u32,
};
pub const WriteDescriptorSetInlineUniformBlockEXT = extern struct {
    sType: StructureType = .writeDescriptorSetInlineUniformBlockEXT,
    pNext: ?*const c_void = null,
    dataSize: u32,
    pData: *const c_void,
};
pub const DescriptorPoolInlineUniformBlockCreateInfoEXT = extern struct {
    sType: StructureType = .descriptorPoolInlineUniformBlockCreateInfoEXT,
    pNext: ?*const c_void = null,
    maxInlineUniformBlockBindings: u32,
};
pub const PipelineCoverageModulationStateCreateInfoNV = extern struct {
    sType: StructureType = .pipelineCoverageModulationStateCreateInfoNV,
    pNext: ?*const c_void = null,
    flags: PipelineCoverageModulationStateCreateFlagsNV,
    coverageModulationMode: CoverageModulationModeNV,
    coverageModulationTableEnable: Bool32,
    coverageModulationTableCount: u32,
    pCoverageModulationTable: ?[*]const f32,
};
pub const ImageFormatListCreateInfo = extern struct {
    sType: StructureType = .imageFormatListCreateInfo,
    pNext: ?*const c_void = null,
    viewFormatCount: u32,
    pViewFormats: [*]const Format,
};
pub const ImageFormatListCreateInfoKHR = ImageFormatListCreateInfo;
pub const ValidationCacheCreateInfoEXT = extern struct {
    sType: StructureType = .validationCacheCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: ValidationCacheCreateFlagsEXT,
    initialDataSize: usize,
    pInitialData: *const c_void,
};
pub const ShaderModuleValidationCacheCreateInfoEXT = extern struct {
    sType: StructureType = .shaderModuleValidationCacheCreateInfoEXT,
    pNext: ?*const c_void = null,
    validationCache: ValidationCacheEXT,
};
pub const PhysicalDeviceMaintenance3Properties = extern struct {
    sType: StructureType = .physicalDeviceMaintenance3Properties,
    pNext: ?*c_void = null,
    maxPerSetDescriptors: u32,
    maxMemoryAllocationSize: DeviceSize,
};
pub const PhysicalDeviceMaintenance3PropertiesKHR = PhysicalDeviceMaintenance3Properties;
pub const PhysicalDeviceMaintenance4FeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceMaintenance4FeaturesKHR,
    pNext: ?*c_void = null,
    maintenance4: Bool32 = FALSE,
};
pub const PhysicalDeviceMaintenance4PropertiesKHR = extern struct {
    sType: StructureType = .physicalDeviceMaintenance4PropertiesKHR,
    pNext: ?*c_void = null,
    maxBufferSize: DeviceSize,
};
pub const DescriptorSetLayoutSupport = extern struct {
    sType: StructureType = .descriptorSetLayoutSupport,
    pNext: ?*c_void = null,
    supported: Bool32,
};
pub const DescriptorSetLayoutSupportKHR = DescriptorSetLayoutSupport;
pub const PhysicalDeviceShaderDrawParametersFeatures = extern struct {
    sType: StructureType = .physicalDeviceShaderDrawParametersFeatures,
    pNext: ?*c_void = null,
    shaderDrawParameters: Bool32 = FALSE,
};
pub const PhysicalDeviceShaderDrawParameterFeatures = PhysicalDeviceShaderDrawParametersFeatures;
pub const PhysicalDeviceShaderFloat16Int8Features = extern struct {
    sType: StructureType = .physicalDeviceShaderFloat16Int8Features,
    pNext: ?*c_void = null,
    shaderFloat16: Bool32 = FALSE,
    shaderInt8: Bool32 = FALSE,
};
pub const PhysicalDeviceShaderFloat16Int8FeaturesKHR = PhysicalDeviceShaderFloat16Int8Features;
pub const PhysicalDeviceFloat16Int8FeaturesKHR = PhysicalDeviceShaderFloat16Int8Features;
pub const PhysicalDeviceFloatControlsProperties = extern struct {
    sType: StructureType = .physicalDeviceFloatControlsProperties,
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
    sType: StructureType = .physicalDeviceHostQueryResetFeatures,
    pNext: ?*c_void = null,
    hostQueryReset: Bool32 = FALSE,
};
pub const PhysicalDeviceHostQueryResetFeaturesEXT = PhysicalDeviceHostQueryResetFeatures;
pub const NativeBufferUsage2ANDROID = extern struct {
    consumer: u64,
    producer: u64,
};
pub const NativeBufferANDROID = extern struct {
    sType: StructureType = .nativeBufferANDROID,
    pNext: ?*const c_void = null,
    handle: *const c_void,
    stride: c_int,
    format: c_int,
    usage: c_int,
    usage2: NativeBufferUsage2ANDROID,
};
pub const SwapchainImageCreateInfoANDROID = extern struct {
    sType: StructureType = .swapchainImageCreateInfoANDROID,
    pNext: ?*const c_void = null,
    usage: SwapchainImageUsageFlagsANDROID,
};
pub const PhysicalDevicePresentationPropertiesANDROID = extern struct {
    sType: StructureType = .physicalDevicePresentationPropertiesANDROID,
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
    sType: StructureType = .deviceQueueGlobalPriorityCreateInfoEXT,
    pNext: ?*const c_void = null,
    globalPriority: QueueGlobalPriorityEXT,
};
pub const PhysicalDeviceGlobalPriorityQueryFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceGlobalPriorityQueryFeaturesEXT,
    pNext: ?*c_void = null,
    globalPriorityQuery: Bool32 = FALSE,
};
pub const QueueFamilyGlobalPriorityPropertiesEXT = extern struct {
    sType: StructureType = .queueFamilyGlobalPriorityPropertiesEXT,
    pNext: ?*c_void = null,
    priorityCount: u32,
    priorities: [MAX_GLOBAL_PRIORITY_SIZE_EXT]QueueGlobalPriorityEXT,
};
pub const DebugUtilsObjectNameInfoEXT = extern struct {
    sType: StructureType = .debugUtilsObjectNameInfoEXT,
    pNext: ?*const c_void = null,
    objectType: ObjectType,
    objectHandle: u64,
    pObjectName: ?[*:0]const u8,
};
pub const DebugUtilsObjectTagInfoEXT = extern struct {
    sType: StructureType = .debugUtilsObjectTagInfoEXT,
    pNext: ?*const c_void = null,
    objectType: ObjectType,
    objectHandle: u64,
    tagName: u64,
    tagSize: usize,
    pTag: *const c_void,
};
pub const DebugUtilsLabelEXT = extern struct {
    sType: StructureType = .debugUtilsLabelEXT,
    pNext: ?*const c_void = null,
    pLabelName: [*:0]const u8,
    color: [4]f32,
};
pub const DebugUtilsMessengerCreateInfoEXT = extern struct {
    sType: StructureType = .debugUtilsMessengerCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: DebugUtilsMessengerCreateFlagsEXT,
    messageSeverity: DebugUtilsMessageSeverityFlagsEXT,
    messageType: DebugUtilsMessageTypeFlagsEXT,
    pfnUserCallback: PfnDebugUtilsMessengerCallbackEXT,
    pUserData: ?*c_void,
};
pub const DebugUtilsMessengerCallbackDataEXT = extern struct {
    sType: StructureType = .debugUtilsMessengerCallbackDataEXT,
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
    sType: StructureType = .physicalDeviceDeviceMemoryReportFeaturesEXT,
    pNext: ?*c_void = null,
    deviceMemoryReport: Bool32 = FALSE,
};
pub const DeviceDeviceMemoryReportCreateInfoEXT = extern struct {
    sType: StructureType = .deviceDeviceMemoryReportCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: DeviceMemoryReportFlagsEXT,
    pfnUserCallback: PfnDeviceMemoryReportCallbackEXT,
    pUserData: *c_void,
};
pub const DeviceMemoryReportCallbackDataEXT = extern struct {
    sType: StructureType = .deviceMemoryReportCallbackDataEXT,
    pNext: ?*c_void = null,
    flags: DeviceMemoryReportFlagsEXT,
    @"type": DeviceMemoryReportEventTypeEXT,
    memoryObjectId: u64,
    size: DeviceSize,
    objectType: ObjectType,
    objectHandle: u64,
    heapIndex: u32,
};
pub const ImportMemoryHostPointerInfoEXT = extern struct {
    sType: StructureType = .importMemoryHostPointerInfoEXT,
    pNext: ?*const c_void = null,
    handleType: ExternalMemoryHandleTypeFlags,
    pHostPointer: *c_void,
};
pub const MemoryHostPointerPropertiesEXT = extern struct {
    sType: StructureType = .memoryHostPointerPropertiesEXT,
    pNext: ?*c_void = null,
    memoryTypeBits: u32,
};
pub const PhysicalDeviceExternalMemoryHostPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceExternalMemoryHostPropertiesEXT,
    pNext: ?*c_void = null,
    minImportedHostPointerAlignment: DeviceSize,
};
pub const PhysicalDeviceConservativeRasterizationPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceConservativeRasterizationPropertiesEXT,
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
    sType: StructureType = .calibratedTimestampInfoEXT,
    pNext: ?*const c_void = null,
    timeDomain: TimeDomainEXT,
};
pub const PhysicalDeviceShaderCorePropertiesAMD = extern struct {
    sType: StructureType = .physicalDeviceShaderCorePropertiesAMD,
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
    sType: StructureType = .physicalDeviceShaderCoreProperties2AMD,
    pNext: ?*c_void = null,
    shaderCoreFeatures: ShaderCorePropertiesFlagsAMD,
    activeComputeUnitCount: u32,
};
pub const PipelineRasterizationConservativeStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineRasterizationConservativeStateCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: PipelineRasterizationConservativeStateCreateFlagsEXT,
    conservativeRasterizationMode: ConservativeRasterizationModeEXT,
    extraPrimitiveOverestimationSize: f32,
};
pub const PhysicalDeviceDescriptorIndexingFeatures = extern struct {
    sType: StructureType = .physicalDeviceDescriptorIndexingFeatures,
    pNext: ?*c_void = null,
    shaderInputAttachmentArrayDynamicIndexing: Bool32 = FALSE,
    shaderUniformTexelBufferArrayDynamicIndexing: Bool32 = FALSE,
    shaderStorageTexelBufferArrayDynamicIndexing: Bool32 = FALSE,
    shaderUniformBufferArrayNonUniformIndexing: Bool32 = FALSE,
    shaderSampledImageArrayNonUniformIndexing: Bool32 = FALSE,
    shaderStorageBufferArrayNonUniformIndexing: Bool32 = FALSE,
    shaderStorageImageArrayNonUniformIndexing: Bool32 = FALSE,
    shaderInputAttachmentArrayNonUniformIndexing: Bool32 = FALSE,
    shaderUniformTexelBufferArrayNonUniformIndexing: Bool32 = FALSE,
    shaderStorageTexelBufferArrayNonUniformIndexing: Bool32 = FALSE,
    descriptorBindingUniformBufferUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingSampledImageUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingStorageImageUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingStorageBufferUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingUniformTexelBufferUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingStorageTexelBufferUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingUpdateUnusedWhilePending: Bool32 = FALSE,
    descriptorBindingPartiallyBound: Bool32 = FALSE,
    descriptorBindingVariableDescriptorCount: Bool32 = FALSE,
    runtimeDescriptorArray: Bool32 = FALSE,
};
pub const PhysicalDeviceDescriptorIndexingFeaturesEXT = PhysicalDeviceDescriptorIndexingFeatures;
pub const PhysicalDeviceDescriptorIndexingProperties = extern struct {
    sType: StructureType = .physicalDeviceDescriptorIndexingProperties,
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
    sType: StructureType = .descriptorSetLayoutBindingFlagsCreateInfo,
    pNext: ?*const c_void = null,
    bindingCount: u32,
    pBindingFlags: [*]const DescriptorBindingFlags,
};
pub const DescriptorSetLayoutBindingFlagsCreateInfoEXT = DescriptorSetLayoutBindingFlagsCreateInfo;
pub const DescriptorSetVariableDescriptorCountAllocateInfo = extern struct {
    sType: StructureType = .descriptorSetVariableDescriptorCountAllocateInfo,
    pNext: ?*const c_void = null,
    descriptorSetCount: u32,
    pDescriptorCounts: [*]const u32,
};
pub const DescriptorSetVariableDescriptorCountAllocateInfoEXT = DescriptorSetVariableDescriptorCountAllocateInfo;
pub const DescriptorSetVariableDescriptorCountLayoutSupport = extern struct {
    sType: StructureType = .descriptorSetVariableDescriptorCountLayoutSupport,
    pNext: ?*c_void = null,
    maxVariableDescriptorCount: u32,
};
pub const DescriptorSetVariableDescriptorCountLayoutSupportEXT = DescriptorSetVariableDescriptorCountLayoutSupport;
pub const AttachmentDescription2 = extern struct {
    sType: StructureType = .attachmentDescription2,
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
    sType: StructureType = .attachmentReference2,
    pNext: ?*const c_void = null,
    attachment: u32,
    layout: ImageLayout,
    aspectMask: ImageAspectFlags,
};
pub const AttachmentReference2KHR = AttachmentReference2;
pub const SubpassDescription2 = extern struct {
    sType: StructureType = .subpassDescription2,
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
    sType: StructureType = .subpassDependency2,
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
    sType: StructureType = .renderPassCreateInfo2,
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
    sType: StructureType = .subpassBeginInfo,
    pNext: ?*const c_void = null,
    contents: SubpassContents,
};
pub const SubpassBeginInfoKHR = SubpassBeginInfo;
pub const SubpassEndInfo = extern struct {
    sType: StructureType = .subpassEndInfo,
    pNext: ?*const c_void = null,
};
pub const SubpassEndInfoKHR = SubpassEndInfo;
pub const PhysicalDeviceTimelineSemaphoreFeatures = extern struct {
    sType: StructureType = .physicalDeviceTimelineSemaphoreFeatures,
    pNext: ?*c_void = null,
    timelineSemaphore: Bool32 = FALSE,
};
pub const PhysicalDeviceTimelineSemaphoreFeaturesKHR = PhysicalDeviceTimelineSemaphoreFeatures;
pub const PhysicalDeviceTimelineSemaphoreProperties = extern struct {
    sType: StructureType = .physicalDeviceTimelineSemaphoreProperties,
    pNext: ?*c_void = null,
    maxTimelineSemaphoreValueDifference: u64,
};
pub const PhysicalDeviceTimelineSemaphorePropertiesKHR = PhysicalDeviceTimelineSemaphoreProperties;
pub const SemaphoreTypeCreateInfo = extern struct {
    sType: StructureType = .semaphoreTypeCreateInfo,
    pNext: ?*const c_void = null,
    semaphoreType: SemaphoreType,
    initialValue: u64,
};
pub const SemaphoreTypeCreateInfoKHR = SemaphoreTypeCreateInfo;
pub const TimelineSemaphoreSubmitInfo = extern struct {
    sType: StructureType = .timelineSemaphoreSubmitInfo,
    pNext: ?*const c_void = null,
    waitSemaphoreValueCount: u32,
    pWaitSemaphoreValues: ?[*]const u64,
    signalSemaphoreValueCount: u32,
    pSignalSemaphoreValues: ?[*]const u64,
};
pub const TimelineSemaphoreSubmitInfoKHR = TimelineSemaphoreSubmitInfo;
pub const SemaphoreWaitInfo = extern struct {
    sType: StructureType = .semaphoreWaitInfo,
    pNext: ?*const c_void = null,
    flags: SemaphoreWaitFlags,
    semaphoreCount: u32,
    pSemaphores: [*]const Semaphore,
    pValues: [*]const u64,
};
pub const SemaphoreWaitInfoKHR = SemaphoreWaitInfo;
pub const SemaphoreSignalInfo = extern struct {
    sType: StructureType = .semaphoreSignalInfo,
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
    sType: StructureType = .pipelineVertexInputDivisorStateCreateInfoEXT,
    pNext: ?*const c_void = null,
    vertexBindingDivisorCount: u32,
    pVertexBindingDivisors: [*]const VertexInputBindingDivisorDescriptionEXT,
};
pub const PhysicalDeviceVertexAttributeDivisorPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceVertexAttributeDivisorPropertiesEXT,
    pNext: ?*c_void = null,
    maxVertexAttribDivisor: u32,
};
pub const PhysicalDevicePCIBusInfoPropertiesEXT = extern struct {
    sType: StructureType = .physicalDevicePciBusInfoPropertiesEXT,
    pNext: ?*c_void = null,
    pciDomain: u32,
    pciBus: u32,
    pciDevice: u32,
    pciFunction: u32,
};
pub const ImportAndroidHardwareBufferInfoANDROID = extern struct {
    sType: StructureType = .importAndroidHardwareBufferInfoANDROID,
    pNext: ?*const c_void = null,
    buffer: *AHardwareBuffer,
};
pub const AndroidHardwareBufferUsageANDROID = extern struct {
    sType: StructureType = .androidHardwareBufferUsageANDROID,
    pNext: ?*c_void = null,
    androidHardwareBufferUsage: u64,
};
pub const AndroidHardwareBufferPropertiesANDROID = extern struct {
    sType: StructureType = .androidHardwareBufferPropertiesANDROID,
    pNext: ?*c_void = null,
    allocationSize: DeviceSize,
    memoryTypeBits: u32,
};
pub const MemoryGetAndroidHardwareBufferInfoANDROID = extern struct {
    sType: StructureType = .memoryGetAndroidHardwareBufferInfoANDROID,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
};
pub const AndroidHardwareBufferFormatPropertiesANDROID = extern struct {
    sType: StructureType = .androidHardwareBufferFormatPropertiesANDROID,
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
    sType: StructureType = .commandBufferInheritanceConditionalRenderingInfoEXT,
    pNext: ?*const c_void = null,
    conditionalRenderingEnable: Bool32,
};
pub const ExternalFormatANDROID = extern struct {
    sType: StructureType = .externalFormatANDROID,
    pNext: ?*c_void = null,
    externalFormat: u64,
};
pub const PhysicalDevice8BitStorageFeatures = extern struct {
    sType: StructureType = .physicalDevice8BitStorageFeatures,
    pNext: ?*c_void = null,
    storageBuffer8BitAccess: Bool32 = FALSE,
    uniformAndStorageBuffer8BitAccess: Bool32 = FALSE,
    storagePushConstant8: Bool32 = FALSE,
};
pub const PhysicalDevice8BitStorageFeaturesKHR = PhysicalDevice8BitStorageFeatures;
pub const PhysicalDeviceConditionalRenderingFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceConditionalRenderingFeaturesEXT,
    pNext: ?*c_void = null,
    conditionalRendering: Bool32 = FALSE,
    inheritedConditionalRendering: Bool32 = FALSE,
};
pub const PhysicalDeviceVulkanMemoryModelFeatures = extern struct {
    sType: StructureType = .physicalDeviceVulkanMemoryModelFeatures,
    pNext: ?*c_void = null,
    vulkanMemoryModel: Bool32 = FALSE,
    vulkanMemoryModelDeviceScope: Bool32 = FALSE,
    vulkanMemoryModelAvailabilityVisibilityChains: Bool32 = FALSE,
};
pub const PhysicalDeviceVulkanMemoryModelFeaturesKHR = PhysicalDeviceVulkanMemoryModelFeatures;
pub const PhysicalDeviceShaderAtomicInt64Features = extern struct {
    sType: StructureType = .physicalDeviceShaderAtomicInt64Features,
    pNext: ?*c_void = null,
    shaderBufferInt64Atomics: Bool32 = FALSE,
    shaderSharedInt64Atomics: Bool32 = FALSE,
};
pub const PhysicalDeviceShaderAtomicInt64FeaturesKHR = PhysicalDeviceShaderAtomicInt64Features;
pub const PhysicalDeviceShaderAtomicFloatFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceShaderAtomicFloatFeaturesEXT,
    pNext: ?*c_void = null,
    shaderBufferFloat32Atomics: Bool32 = FALSE,
    shaderBufferFloat32AtomicAdd: Bool32 = FALSE,
    shaderBufferFloat64Atomics: Bool32 = FALSE,
    shaderBufferFloat64AtomicAdd: Bool32 = FALSE,
    shaderSharedFloat32Atomics: Bool32 = FALSE,
    shaderSharedFloat32AtomicAdd: Bool32 = FALSE,
    shaderSharedFloat64Atomics: Bool32 = FALSE,
    shaderSharedFloat64AtomicAdd: Bool32 = FALSE,
    shaderImageFloat32Atomics: Bool32 = FALSE,
    shaderImageFloat32AtomicAdd: Bool32 = FALSE,
    sparseImageFloat32Atomics: Bool32 = FALSE,
    sparseImageFloat32AtomicAdd: Bool32 = FALSE,
};
pub const PhysicalDeviceShaderAtomicFloat2FeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceShaderAtomicFloat2FeaturesEXT,
    pNext: ?*c_void = null,
    shaderBufferFloat16Atomics: Bool32 = FALSE,
    shaderBufferFloat16AtomicAdd: Bool32 = FALSE,
    shaderBufferFloat16AtomicMinMax: Bool32 = FALSE,
    shaderBufferFloat32AtomicMinMax: Bool32 = FALSE,
    shaderBufferFloat64AtomicMinMax: Bool32 = FALSE,
    shaderSharedFloat16Atomics: Bool32 = FALSE,
    shaderSharedFloat16AtomicAdd: Bool32 = FALSE,
    shaderSharedFloat16AtomicMinMax: Bool32 = FALSE,
    shaderSharedFloat32AtomicMinMax: Bool32 = FALSE,
    shaderSharedFloat64AtomicMinMax: Bool32 = FALSE,
    shaderImageFloat32AtomicMinMax: Bool32 = FALSE,
    sparseImageFloat32AtomicMinMax: Bool32 = FALSE,
};
pub const PhysicalDeviceVertexAttributeDivisorFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceVertexAttributeDivisorFeaturesEXT,
    pNext: ?*c_void = null,
    vertexAttributeInstanceRateDivisor: Bool32 = FALSE,
    vertexAttributeInstanceRateZeroDivisor: Bool32 = FALSE,
};
pub const QueueFamilyCheckpointPropertiesNV = extern struct {
    sType: StructureType = .queueFamilyCheckpointPropertiesNV,
    pNext: ?*c_void = null,
    checkpointExecutionStageMask: PipelineStageFlags,
};
pub const CheckpointDataNV = extern struct {
    sType: StructureType = .checkpointDataNV,
    pNext: ?*c_void = null,
    stage: PipelineStageFlags,
    pCheckpointMarker: *c_void,
};
pub const PhysicalDeviceDepthStencilResolveProperties = extern struct {
    sType: StructureType = .physicalDeviceDepthStencilResolveProperties,
    pNext: ?*c_void = null,
    supportedDepthResolveModes: ResolveModeFlags,
    supportedStencilResolveModes: ResolveModeFlags,
    independentResolveNone: Bool32,
    independentResolve: Bool32,
};
pub const PhysicalDeviceDepthStencilResolvePropertiesKHR = PhysicalDeviceDepthStencilResolveProperties;
pub const SubpassDescriptionDepthStencilResolve = extern struct {
    sType: StructureType = .subpassDescriptionDepthStencilResolve,
    pNext: ?*const c_void = null,
    depthResolveMode: ResolveModeFlags,
    stencilResolveMode: ResolveModeFlags,
    pDepthStencilResolveAttachment: ?*const AttachmentReference2,
};
pub const SubpassDescriptionDepthStencilResolveKHR = SubpassDescriptionDepthStencilResolve;
pub const ImageViewASTCDecodeModeEXT = extern struct {
    sType: StructureType = .imageViewAstcDecodeModeEXT,
    pNext: ?*const c_void = null,
    decodeMode: Format,
};
pub const PhysicalDeviceASTCDecodeFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceAstcDecodeFeaturesEXT,
    pNext: ?*c_void = null,
    decodeModeSharedExponent: Bool32 = FALSE,
};
pub const PhysicalDeviceTransformFeedbackFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceTransformFeedbackFeaturesEXT,
    pNext: ?*c_void = null,
    transformFeedback: Bool32 = FALSE,
    geometryStreams: Bool32 = FALSE,
};
pub const PhysicalDeviceTransformFeedbackPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceTransformFeedbackPropertiesEXT,
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
    sType: StructureType = .pipelineRasterizationStateStreamCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: PipelineRasterizationStateStreamCreateFlagsEXT,
    rasterizationStream: u32,
};
pub const PhysicalDeviceRepresentativeFragmentTestFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceRepresentativeFragmentTestFeaturesNV,
    pNext: ?*c_void = null,
    representativeFragmentTest: Bool32 = FALSE,
};
pub const PipelineRepresentativeFragmentTestStateCreateInfoNV = extern struct {
    sType: StructureType = .pipelineRepresentativeFragmentTestStateCreateInfoNV,
    pNext: ?*const c_void = null,
    representativeFragmentTestEnable: Bool32,
};
pub const PhysicalDeviceExclusiveScissorFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceExclusiveScissorFeaturesNV,
    pNext: ?*c_void = null,
    exclusiveScissor: Bool32 = FALSE,
};
pub const PipelineViewportExclusiveScissorStateCreateInfoNV = extern struct {
    sType: StructureType = .pipelineViewportExclusiveScissorStateCreateInfoNV,
    pNext: ?*const c_void = null,
    exclusiveScissorCount: u32,
    pExclusiveScissors: [*]const Rect2D,
};
pub const PhysicalDeviceCornerSampledImageFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceCornerSampledImageFeaturesNV,
    pNext: ?*c_void = null,
    cornerSampledImage: Bool32 = FALSE,
};
pub const PhysicalDeviceComputeShaderDerivativesFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceComputeShaderDerivativesFeaturesNV,
    pNext: ?*c_void = null,
    computeDerivativeGroupQuads: Bool32 = FALSE,
    computeDerivativeGroupLinear: Bool32 = FALSE,
};
pub const PhysicalDeviceFragmentShaderBarycentricFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceFragmentShaderBarycentricFeaturesNV,
    pNext: ?*c_void = null,
    fragmentShaderBarycentric: Bool32 = FALSE,
};
pub const PhysicalDeviceShaderImageFootprintFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceShaderImageFootprintFeaturesNV,
    pNext: ?*c_void = null,
    imageFootprint: Bool32 = FALSE,
};
pub const PhysicalDeviceDedicatedAllocationImageAliasingFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceDedicatedAllocationImageAliasingFeaturesNV,
    pNext: ?*c_void = null,
    dedicatedAllocationImageAliasing: Bool32 = FALSE,
};
pub const ShadingRatePaletteNV = extern struct {
    shadingRatePaletteEntryCount: u32,
    pShadingRatePaletteEntries: [*]const ShadingRatePaletteEntryNV,
};
pub const PipelineViewportShadingRateImageStateCreateInfoNV = extern struct {
    sType: StructureType = .pipelineViewportShadingRateImageStateCreateInfoNV,
    pNext: ?*const c_void = null,
    shadingRateImageEnable: Bool32,
    viewportCount: u32,
    pShadingRatePalettes: [*]const ShadingRatePaletteNV,
};
pub const PhysicalDeviceShadingRateImageFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceShadingRateImageFeaturesNV,
    pNext: ?*c_void = null,
    shadingRateImage: Bool32 = FALSE,
    shadingRateCoarseSampleOrder: Bool32 = FALSE,
};
pub const PhysicalDeviceShadingRateImagePropertiesNV = extern struct {
    sType: StructureType = .physicalDeviceShadingRateImagePropertiesNV,
    pNext: ?*c_void = null,
    shadingRateTexelSize: Extent2D,
    shadingRatePaletteSize: u32,
    shadingRateMaxCoarseSamples: u32,
};
pub const PhysicalDeviceInvocationMaskFeaturesHUAWEI = extern struct {
    sType: StructureType = .physicalDeviceInvocationMaskFeaturesHUAWEI,
    pNext: ?*c_void = null,
    invocationMask: Bool32 = FALSE,
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
    sType: StructureType = .pipelineViewportCoarseSampleOrderStateCreateInfoNV,
    pNext: ?*const c_void = null,
    sampleOrderType: CoarseSampleOrderTypeNV,
    customSampleOrderCount: u32,
    pCustomSampleOrders: [*]const CoarseSampleOrderCustomNV,
};
pub const PhysicalDeviceMeshShaderFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceMeshShaderFeaturesNV,
    pNext: ?*c_void = null,
    taskShader: Bool32 = FALSE,
    meshShader: Bool32 = FALSE,
};
pub const PhysicalDeviceMeshShaderPropertiesNV = extern struct {
    sType: StructureType = .physicalDeviceMeshShaderPropertiesNV,
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
    sType: StructureType = .rayTracingShaderGroupCreateInfoNV,
    pNext: ?*const c_void = null,
    @"type": RayTracingShaderGroupTypeKHR,
    generalShader: u32,
    closestHitShader: u32,
    anyHitShader: u32,
    intersectionShader: u32,
};
pub const RayTracingShaderGroupCreateInfoKHR = extern struct {
    sType: StructureType = .rayTracingShaderGroupCreateInfoKHR,
    pNext: ?*const c_void = null,
    @"type": RayTracingShaderGroupTypeKHR,
    generalShader: u32,
    closestHitShader: u32,
    anyHitShader: u32,
    intersectionShader: u32,
    pShaderGroupCaptureReplayHandle: ?*const c_void,
};
pub const RayTracingPipelineCreateInfoNV = extern struct {
    sType: StructureType = .rayTracingPipelineCreateInfoNV,
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
    sType: StructureType = .rayTracingPipelineCreateInfoKHR,
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
    sType: StructureType = .geometryTrianglesNV,
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
    sType: StructureType = .geometryAabbNV,
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
    sType: StructureType = .geometryNV,
    pNext: ?*const c_void = null,
    geometryType: GeometryTypeKHR,
    geometry: GeometryDataNV,
    flags: GeometryFlagsKHR,
};
pub const AccelerationStructureInfoNV = extern struct {
    sType: StructureType = .accelerationStructureInfoNV,
    pNext: ?*const c_void = null,
    @"type": AccelerationStructureTypeNV,
    flags: BuildAccelerationStructureFlagsNV,
    instanceCount: u32,
    geometryCount: u32,
    pGeometries: [*]const GeometryNV,
};
pub const AccelerationStructureCreateInfoNV = extern struct {
    sType: StructureType = .accelerationStructureCreateInfoNV,
    pNext: ?*const c_void = null,
    compactedSize: DeviceSize,
    info: AccelerationStructureInfoNV,
};
pub const BindAccelerationStructureMemoryInfoNV = extern struct {
    sType: StructureType = .bindAccelerationStructureMemoryInfoNV,
    pNext: ?*const c_void = null,
    accelerationStructure: AccelerationStructureNV,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
    deviceIndexCount: u32,
    pDeviceIndices: [*]const u32,
};
pub const WriteDescriptorSetAccelerationStructureKHR = extern struct {
    sType: StructureType = .writeDescriptorSetAccelerationStructureKHR,
    pNext: ?*const c_void = null,
    accelerationStructureCount: u32,
    pAccelerationStructures: [*]const AccelerationStructureKHR,
};
pub const WriteDescriptorSetAccelerationStructureNV = extern struct {
    sType: StructureType = .writeDescriptorSetAccelerationStructureNV,
    pNext: ?*const c_void = null,
    accelerationStructureCount: u32,
    pAccelerationStructures: [*]const AccelerationStructureNV,
};
pub const AccelerationStructureMemoryRequirementsInfoNV = extern struct {
    sType: StructureType = .accelerationStructureMemoryRequirementsInfoNV,
    pNext: ?*const c_void = null,
    @"type": AccelerationStructureMemoryRequirementsTypeNV,
    accelerationStructure: AccelerationStructureNV,
};
pub const PhysicalDeviceAccelerationStructureFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceAccelerationStructureFeaturesKHR,
    pNext: ?*c_void = null,
    accelerationStructure: Bool32 = FALSE,
    accelerationStructureCaptureReplay: Bool32 = FALSE,
    accelerationStructureIndirectBuild: Bool32 = FALSE,
    accelerationStructureHostCommands: Bool32 = FALSE,
    descriptorBindingAccelerationStructureUpdateAfterBind: Bool32 = FALSE,
};
pub const PhysicalDeviceRayTracingPipelineFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceRayTracingPipelineFeaturesKHR,
    pNext: ?*c_void = null,
    rayTracingPipeline: Bool32 = FALSE,
    rayTracingPipelineShaderGroupHandleCaptureReplay: Bool32 = FALSE,
    rayTracingPipelineShaderGroupHandleCaptureReplayMixed: Bool32 = FALSE,
    rayTracingPipelineTraceRaysIndirect: Bool32 = FALSE,
    rayTraversalPrimitiveCulling: Bool32 = FALSE,
};
pub const PhysicalDeviceRayQueryFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceRayQueryFeaturesKHR,
    pNext: ?*c_void = null,
    rayQuery: Bool32 = FALSE,
};
pub const PhysicalDeviceAccelerationStructurePropertiesKHR = extern struct {
    sType: StructureType = .physicalDeviceAccelerationStructurePropertiesKHR,
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
    sType: StructureType = .physicalDeviceRayTracingPipelinePropertiesKHR,
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
    sType: StructureType = .physicalDeviceRayTracingPropertiesNV,
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
    sType: StructureType = .drmFormatModifierPropertiesListEXT,
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
    sType: StructureType = .physicalDeviceImageDrmFormatModifierInfoEXT,
    pNext: ?*const c_void = null,
    drmFormatModifier: u64,
    sharingMode: SharingMode,
    queueFamilyIndexCount: u32,
    pQueueFamilyIndices: [*]const u32,
};
pub const ImageDrmFormatModifierListCreateInfoEXT = extern struct {
    sType: StructureType = .imageDrmFormatModifierListCreateInfoEXT,
    pNext: ?*const c_void = null,
    drmFormatModifierCount: u32,
    pDrmFormatModifiers: [*]const u64,
};
pub const ImageDrmFormatModifierExplicitCreateInfoEXT = extern struct {
    sType: StructureType = .imageDrmFormatModifierExplicitCreateInfoEXT,
    pNext: ?*const c_void = null,
    drmFormatModifier: u64,
    drmFormatModifierPlaneCount: u32,
    pPlaneLayouts: [*]const SubresourceLayout,
};
pub const ImageDrmFormatModifierPropertiesEXT = extern struct {
    sType: StructureType = .imageDrmFormatModifierPropertiesEXT,
    pNext: ?*c_void = null,
    drmFormatModifier: u64,
};
pub const ImageStencilUsageCreateInfo = extern struct {
    sType: StructureType = .imageStencilUsageCreateInfo,
    pNext: ?*const c_void = null,
    stencilUsage: ImageUsageFlags,
};
pub const ImageStencilUsageCreateInfoEXT = ImageStencilUsageCreateInfo;
pub const DeviceMemoryOverallocationCreateInfoAMD = extern struct {
    sType: StructureType = .deviceMemoryOverallocationCreateInfoAMD,
    pNext: ?*const c_void = null,
    overallocationBehavior: MemoryOverallocationBehaviorAMD,
};
pub const PhysicalDeviceFragmentDensityMapFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceFragmentDensityMapFeaturesEXT,
    pNext: ?*c_void = null,
    fragmentDensityMap: Bool32 = FALSE,
    fragmentDensityMapDynamic: Bool32 = FALSE,
    fragmentDensityMapNonSubsampledImages: Bool32 = FALSE,
};
pub const PhysicalDeviceFragmentDensityMap2FeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceFragmentDensityMap2FeaturesEXT,
    pNext: ?*c_void = null,
    fragmentDensityMapDeferred: Bool32 = FALSE,
};
pub const PhysicalDeviceFragmentDensityMapPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceFragmentDensityMapPropertiesEXT,
    pNext: ?*c_void = null,
    minFragmentDensityTexelSize: Extent2D,
    maxFragmentDensityTexelSize: Extent2D,
    fragmentDensityInvocations: Bool32,
};
pub const PhysicalDeviceFragmentDensityMap2PropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceFragmentDensityMap2PropertiesEXT,
    pNext: ?*c_void = null,
    subsampledLoads: Bool32,
    subsampledCoarseReconstructionEarlyAccess: Bool32,
    maxSubsampledArrayLayers: u32,
    maxDescriptorSetSubsampledSamplers: u32,
};
pub const RenderPassFragmentDensityMapCreateInfoEXT = extern struct {
    sType: StructureType = .renderPassFragmentDensityMapCreateInfoEXT,
    pNext: ?*const c_void = null,
    fragmentDensityMapAttachment: AttachmentReference,
};
pub const PhysicalDeviceScalarBlockLayoutFeatures = extern struct {
    sType: StructureType = .physicalDeviceScalarBlockLayoutFeatures,
    pNext: ?*c_void = null,
    scalarBlockLayout: Bool32 = FALSE,
};
pub const PhysicalDeviceScalarBlockLayoutFeaturesEXT = PhysicalDeviceScalarBlockLayoutFeatures;
pub const SurfaceProtectedCapabilitiesKHR = extern struct {
    sType: StructureType = .surfaceProtectedCapabilitiesKHR,
    pNext: ?*const c_void = null,
    supportsProtected: Bool32,
};
pub const PhysicalDeviceUniformBufferStandardLayoutFeatures = extern struct {
    sType: StructureType = .physicalDeviceUniformBufferStandardLayoutFeatures,
    pNext: ?*c_void = null,
    uniformBufferStandardLayout: Bool32 = FALSE,
};
pub const PhysicalDeviceUniformBufferStandardLayoutFeaturesKHR = PhysicalDeviceUniformBufferStandardLayoutFeatures;
pub const PhysicalDeviceDepthClipEnableFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceDepthClipEnableFeaturesEXT,
    pNext: ?*c_void = null,
    depthClipEnable: Bool32 = FALSE,
};
pub const PipelineRasterizationDepthClipStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineRasterizationDepthClipStateCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: PipelineRasterizationDepthClipStateCreateFlagsEXT,
    depthClipEnable: Bool32,
};
pub const PhysicalDeviceMemoryBudgetPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceMemoryBudgetPropertiesEXT,
    pNext: ?*c_void = null,
    heapBudget: [MAX_MEMORY_HEAPS]DeviceSize,
    heapUsage: [MAX_MEMORY_HEAPS]DeviceSize,
};
pub const PhysicalDeviceMemoryPriorityFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceMemoryPriorityFeaturesEXT,
    pNext: ?*c_void = null,
    memoryPriority: Bool32 = FALSE,
};
pub const MemoryPriorityAllocateInfoEXT = extern struct {
    sType: StructureType = .memoryPriorityAllocateInfoEXT,
    pNext: ?*const c_void = null,
    priority: f32,
};
pub const PhysicalDevicePageableDeviceLocalMemoryFeaturesEXT = extern struct {
    sType: StructureType = .physicalDevicePageableDeviceLocalMemoryFeaturesEXT,
    pNext: ?*c_void = null,
    pageableDeviceLocalMemory: Bool32 = FALSE,
};
pub const PhysicalDeviceBufferDeviceAddressFeatures = extern struct {
    sType: StructureType = .physicalDeviceBufferDeviceAddressFeatures,
    pNext: ?*c_void = null,
    bufferDeviceAddress: Bool32 = FALSE,
    bufferDeviceAddressCaptureReplay: Bool32 = FALSE,
    bufferDeviceAddressMultiDevice: Bool32 = FALSE,
};
pub const PhysicalDeviceBufferDeviceAddressFeaturesKHR = PhysicalDeviceBufferDeviceAddressFeatures;
pub const PhysicalDeviceBufferDeviceAddressFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceBufferDeviceAddressFeaturesEXT,
    pNext: ?*c_void = null,
    bufferDeviceAddress: Bool32 = FALSE,
    bufferDeviceAddressCaptureReplay: Bool32 = FALSE,
    bufferDeviceAddressMultiDevice: Bool32 = FALSE,
};
pub const PhysicalDeviceBufferAddressFeaturesEXT = PhysicalDeviceBufferDeviceAddressFeaturesEXT;
pub const BufferDeviceAddressInfo = extern struct {
    sType: StructureType = .bufferDeviceAddressInfo,
    pNext: ?*const c_void = null,
    buffer: Buffer,
};
pub const BufferDeviceAddressInfoKHR = BufferDeviceAddressInfo;
pub const BufferDeviceAddressInfoEXT = BufferDeviceAddressInfo;
pub const BufferOpaqueCaptureAddressCreateInfo = extern struct {
    sType: StructureType = .bufferOpaqueCaptureAddressCreateInfo,
    pNext: ?*const c_void = null,
    opaqueCaptureAddress: u64,
};
pub const BufferOpaqueCaptureAddressCreateInfoKHR = BufferOpaqueCaptureAddressCreateInfo;
pub const BufferDeviceAddressCreateInfoEXT = extern struct {
    sType: StructureType = .bufferDeviceAddressCreateInfoEXT,
    pNext: ?*const c_void = null,
    deviceAddress: DeviceAddress,
};
pub const PhysicalDeviceImageViewImageFormatInfoEXT = extern struct {
    sType: StructureType = .physicalDeviceImageViewImageFormatInfoEXT,
    pNext: ?*c_void = null,
    imageViewType: ImageViewType,
};
pub const FilterCubicImageViewImageFormatPropertiesEXT = extern struct {
    sType: StructureType = .filterCubicImageViewImageFormatPropertiesEXT,
    pNext: ?*c_void = null,
    filterCubic: Bool32,
    filterCubicMinmax: Bool32,
};
pub const PhysicalDeviceImagelessFramebufferFeatures = extern struct {
    sType: StructureType = .physicalDeviceImagelessFramebufferFeatures,
    pNext: ?*c_void = null,
    imagelessFramebuffer: Bool32 = FALSE,
};
pub const PhysicalDeviceImagelessFramebufferFeaturesKHR = PhysicalDeviceImagelessFramebufferFeatures;
pub const FramebufferAttachmentsCreateInfo = extern struct {
    sType: StructureType = .framebufferAttachmentsCreateInfo,
    pNext: ?*const c_void = null,
    attachmentImageInfoCount: u32,
    pAttachmentImageInfos: [*]const FramebufferAttachmentImageInfo,
};
pub const FramebufferAttachmentsCreateInfoKHR = FramebufferAttachmentsCreateInfo;
pub const FramebufferAttachmentImageInfo = extern struct {
    sType: StructureType = .framebufferAttachmentImageInfo,
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
    sType: StructureType = .renderPassAttachmentBeginInfo,
    pNext: ?*const c_void = null,
    attachmentCount: u32,
    pAttachments: [*]const ImageView,
};
pub const RenderPassAttachmentBeginInfoKHR = RenderPassAttachmentBeginInfo;
pub const PhysicalDeviceTextureCompressionASTCHDRFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceTextureCompressionAstcHdrFeaturesEXT,
    pNext: ?*c_void = null,
    textureCompressionAstcHdr: Bool32 = FALSE,
};
pub const PhysicalDeviceCooperativeMatrixFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceCooperativeMatrixFeaturesNV,
    pNext: ?*c_void = null,
    cooperativeMatrix: Bool32 = FALSE,
    cooperativeMatrixRobustBufferAccess: Bool32 = FALSE,
};
pub const PhysicalDeviceCooperativeMatrixPropertiesNV = extern struct {
    sType: StructureType = .physicalDeviceCooperativeMatrixPropertiesNV,
    pNext: ?*c_void = null,
    cooperativeMatrixSupportedStages: ShaderStageFlags,
};
pub const CooperativeMatrixPropertiesNV = extern struct {
    sType: StructureType = .cooperativeMatrixPropertiesNV,
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
    sType: StructureType = .physicalDeviceYcbcrImageArraysFeaturesEXT,
    pNext: ?*c_void = null,
    ycbcrImageArrays: Bool32 = FALSE,
};
pub const ImageViewHandleInfoNVX = extern struct {
    sType: StructureType = .imageViewHandleInfoNVX,
    pNext: ?*const c_void = null,
    imageView: ImageView,
    descriptorType: DescriptorType,
    sampler: Sampler,
};
pub const ImageViewAddressPropertiesNVX = extern struct {
    sType: StructureType = .imageViewAddressPropertiesNVX,
    pNext: ?*c_void = null,
    deviceAddress: DeviceAddress,
    size: DeviceSize,
};
pub const PresentFrameTokenGGP = extern struct {
    sType: StructureType = .presentFrameTokenGGP,
    pNext: ?*const c_void = null,
    frameToken: GgpFrameToken,
};
pub const PipelineCreationFeedbackEXT = extern struct {
    flags: PipelineCreationFeedbackFlagsEXT,
    duration: u64,
};
pub const PipelineCreationFeedbackCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineCreationFeedbackCreateInfoEXT,
    pNext: ?*const c_void = null,
    pPipelineCreationFeedback: *PipelineCreationFeedbackEXT,
    pipelineStageCreationFeedbackCount: u32,
    pPipelineStageCreationFeedbacks: [*]PipelineCreationFeedbackEXT,
};
pub const SurfaceFullScreenExclusiveInfoEXT = extern struct {
    sType: StructureType = .surfaceFullScreenExclusiveInfoEXT,
    pNext: ?*c_void = null,
    fullScreenExclusive: FullScreenExclusiveEXT,
};
pub const SurfaceFullScreenExclusiveWin32InfoEXT = extern struct {
    sType: StructureType = .surfaceFullScreenExclusiveWin32InfoEXT,
    pNext: ?*const c_void = null,
    hmonitor: HMONITOR,
};
pub const SurfaceCapabilitiesFullScreenExclusiveEXT = extern struct {
    sType: StructureType = .surfaceCapabilitiesFullScreenExclusiveEXT,
    pNext: ?*c_void = null,
    fullScreenExclusiveSupported: Bool32,
};
pub const PhysicalDevicePerformanceQueryFeaturesKHR = extern struct {
    sType: StructureType = .physicalDevicePerformanceQueryFeaturesKHR,
    pNext: ?*c_void = null,
    performanceCounterQueryPools: Bool32 = FALSE,
    performanceCounterMultipleQueryPools: Bool32 = FALSE,
};
pub const PhysicalDevicePerformanceQueryPropertiesKHR = extern struct {
    sType: StructureType = .physicalDevicePerformanceQueryPropertiesKHR,
    pNext: ?*c_void = null,
    allowCommandBufferQueryCopies: Bool32,
};
pub const PerformanceCounterKHR = extern struct {
    sType: StructureType = .performanceCounterKHR,
    pNext: ?*c_void = null,
    unit: PerformanceCounterUnitKHR,
    scope: PerformanceCounterScopeKHR,
    storage: PerformanceCounterStorageKHR,
    uuid: [UUID_SIZE]u8,
};
pub const PerformanceCounterDescriptionKHR = extern struct {
    sType: StructureType = .performanceCounterDescriptionKHR,
    pNext: ?*c_void = null,
    flags: PerformanceCounterDescriptionFlagsKHR,
    name: [MAX_DESCRIPTION_SIZE]u8,
    category: [MAX_DESCRIPTION_SIZE]u8,
    description: [MAX_DESCRIPTION_SIZE]u8,
};
pub const QueryPoolPerformanceCreateInfoKHR = extern struct {
    sType: StructureType = .queryPoolPerformanceCreateInfoKHR,
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
    sType: StructureType = .acquireProfilingLockInfoKHR,
    pNext: ?*const c_void = null,
    flags: AcquireProfilingLockFlagsKHR,
    timeout: u64,
};
pub const PerformanceQuerySubmitInfoKHR = extern struct {
    sType: StructureType = .performanceQuerySubmitInfoKHR,
    pNext: ?*const c_void = null,
    counterPassIndex: u32,
};
pub const HeadlessSurfaceCreateInfoEXT = extern struct {
    sType: StructureType = .headlessSurfaceCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: HeadlessSurfaceCreateFlagsEXT,
};
pub const PhysicalDeviceCoverageReductionModeFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceCoverageReductionModeFeaturesNV,
    pNext: ?*c_void = null,
    coverageReductionMode: Bool32 = FALSE,
};
pub const PipelineCoverageReductionStateCreateInfoNV = extern struct {
    sType: StructureType = .pipelineCoverageReductionStateCreateInfoNV,
    pNext: ?*const c_void = null,
    flags: PipelineCoverageReductionStateCreateFlagsNV,
    coverageReductionMode: CoverageReductionModeNV,
};
pub const FramebufferMixedSamplesCombinationNV = extern struct {
    sType: StructureType = .framebufferMixedSamplesCombinationNV,
    pNext: ?*c_void = null,
    coverageReductionMode: CoverageReductionModeNV,
    rasterizationSamples: SampleCountFlags,
    depthStencilSamples: SampleCountFlags,
    colorSamples: SampleCountFlags,
};
pub const PhysicalDeviceShaderIntegerFunctions2FeaturesINTEL = extern struct {
    sType: StructureType = .physicalDeviceShaderIntegerFunctions2FeaturesINTEL,
    pNext: ?*c_void = null,
    shaderIntegerFunctions2: Bool32 = FALSE,
};
pub const PerformanceValueDataINTEL = extern union {
    value32: u32,
    value64: u64,
    valueFloat: f32,
    valueBool: Bool32,
    valueString: [*:0]const u8,
};
pub const PerformanceValueINTEL = extern struct {
    @"type": PerformanceValueTypeINTEL,
    data: PerformanceValueDataINTEL,
};
pub const InitializePerformanceApiInfoINTEL = extern struct {
    sType: StructureType = .initializePerformanceApiInfoINTEL,
    pNext: ?*const c_void = null,
    pUserData: ?*c_void,
};
pub const QueryPoolPerformanceQueryCreateInfoINTEL = extern struct {
    sType: StructureType = .queryPoolPerformanceQueryCreateInfoINTEL,
    pNext: ?*const c_void = null,
    performanceCountersSampling: QueryPoolSamplingModeINTEL,
};
pub const QueryPoolCreateInfoINTEL = QueryPoolPerformanceQueryCreateInfoINTEL;
pub const PerformanceMarkerInfoINTEL = extern struct {
    sType: StructureType = .performanceMarkerInfoINTEL,
    pNext: ?*const c_void = null,
    marker: u64,
};
pub const PerformanceStreamMarkerInfoINTEL = extern struct {
    sType: StructureType = .performanceStreamMarkerInfoINTEL,
    pNext: ?*const c_void = null,
    marker: u32,
};
pub const PerformanceOverrideInfoINTEL = extern struct {
    sType: StructureType = .performanceOverrideInfoINTEL,
    pNext: ?*const c_void = null,
    @"type": PerformanceOverrideTypeINTEL,
    enable: Bool32,
    parameter: u64,
};
pub const PerformanceConfigurationAcquireInfoINTEL = extern struct {
    sType: StructureType = .performanceConfigurationAcquireInfoINTEL,
    pNext: ?*const c_void = null,
    @"type": PerformanceConfigurationTypeINTEL,
};
pub const PhysicalDeviceShaderClockFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceShaderClockFeaturesKHR,
    pNext: ?*c_void = null,
    shaderSubgroupClock: Bool32 = FALSE,
    shaderDeviceClock: Bool32 = FALSE,
};
pub const PhysicalDeviceIndexTypeUint8FeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceIndexTypeUint8FeaturesEXT,
    pNext: ?*c_void = null,
    indexTypeUint8: Bool32 = FALSE,
};
pub const PhysicalDeviceShaderSMBuiltinsPropertiesNV = extern struct {
    sType: StructureType = .physicalDeviceShaderSmBuiltinsPropertiesNV,
    pNext: ?*c_void = null,
    shaderSmCount: u32,
    shaderWarpsPerSm: u32,
};
pub const PhysicalDeviceShaderSMBuiltinsFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceShaderSmBuiltinsFeaturesNV,
    pNext: ?*c_void = null,
    shaderSmBuiltins: Bool32 = FALSE,
};
pub const PhysicalDeviceFragmentShaderInterlockFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceFragmentShaderInterlockFeaturesEXT,
    pNext: ?*c_void = null,
    fragmentShaderSampleInterlock: Bool32 = FALSE,
    fragmentShaderPixelInterlock: Bool32 = FALSE,
    fragmentShaderShadingRateInterlock: Bool32 = FALSE,
};
pub const PhysicalDeviceSeparateDepthStencilLayoutsFeatures = extern struct {
    sType: StructureType = .physicalDeviceSeparateDepthStencilLayoutsFeatures,
    pNext: ?*c_void = null,
    separateDepthStencilLayouts: Bool32 = FALSE,
};
pub const PhysicalDeviceSeparateDepthStencilLayoutsFeaturesKHR = PhysicalDeviceSeparateDepthStencilLayoutsFeatures;
pub const AttachmentReferenceStencilLayout = extern struct {
    sType: StructureType = .attachmentReferenceStencilLayout,
    pNext: ?*c_void = null,
    stencilLayout: ImageLayout,
};
pub const PhysicalDevicePrimitiveTopologyListRestartFeaturesEXT = extern struct {
    sType: StructureType = .physicalDevicePrimitiveTopologyListRestartFeaturesEXT,
    pNext: ?*c_void = null,
    primitiveTopologyListRestart: Bool32 = FALSE,
    primitiveTopologyPatchListRestart: Bool32 = FALSE,
};
pub const AttachmentReferenceStencilLayoutKHR = AttachmentReferenceStencilLayout;
pub const AttachmentDescriptionStencilLayout = extern struct {
    sType: StructureType = .attachmentDescriptionStencilLayout,
    pNext: ?*c_void = null,
    stencilInitialLayout: ImageLayout,
    stencilFinalLayout: ImageLayout,
};
pub const AttachmentDescriptionStencilLayoutKHR = AttachmentDescriptionStencilLayout;
pub const PhysicalDevicePipelineExecutablePropertiesFeaturesKHR = extern struct {
    sType: StructureType = .physicalDevicePipelineExecutablePropertiesFeaturesKHR,
    pNext: ?*c_void = null,
    pipelineExecutableInfo: Bool32 = FALSE,
};
pub const PipelineInfoKHR = extern struct {
    sType: StructureType = .pipelineInfoKHR,
    pNext: ?*const c_void = null,
    pipeline: Pipeline,
};
pub const PipelineExecutablePropertiesKHR = extern struct {
    sType: StructureType = .pipelineExecutablePropertiesKHR,
    pNext: ?*c_void = null,
    stages: ShaderStageFlags,
    name: [MAX_DESCRIPTION_SIZE]u8,
    description: [MAX_DESCRIPTION_SIZE]u8,
    subgroupSize: u32,
};
pub const PipelineExecutableInfoKHR = extern struct {
    sType: StructureType = .pipelineExecutableInfoKHR,
    pNext: ?*const c_void = null,
    pipeline: Pipeline,
    executableIndex: u32,
};
pub const PipelineExecutableStatisticValueKHR = extern union {
    b32: Bool32,
    @"i64": i64,
    @"u64": u64,
    @"f64": f64,
};
pub const PipelineExecutableStatisticKHR = extern struct {
    sType: StructureType = .pipelineExecutableStatisticKHR,
    pNext: ?*c_void = null,
    name: [MAX_DESCRIPTION_SIZE]u8,
    description: [MAX_DESCRIPTION_SIZE]u8,
    format: PipelineExecutableStatisticFormatKHR,
    value: PipelineExecutableStatisticValueKHR,
};
pub const PipelineExecutableInternalRepresentationKHR = extern struct {
    sType: StructureType = .pipelineExecutableInternalRepresentationKHR,
    pNext: ?*c_void = null,
    name: [MAX_DESCRIPTION_SIZE]u8,
    description: [MAX_DESCRIPTION_SIZE]u8,
    isText: Bool32,
    dataSize: usize,
    pData: ?*c_void,
};
pub const PhysicalDeviceShaderDemoteToHelperInvocationFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceShaderDemoteToHelperInvocationFeaturesEXT,
    pNext: ?*c_void = null,
    shaderDemoteToHelperInvocation: Bool32 = FALSE,
};
pub const PhysicalDeviceTexelBufferAlignmentFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceTexelBufferAlignmentFeaturesEXT,
    pNext: ?*c_void = null,
    texelBufferAlignment: Bool32 = FALSE,
};
pub const PhysicalDeviceTexelBufferAlignmentPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceTexelBufferAlignmentPropertiesEXT,
    pNext: ?*c_void = null,
    storageTexelBufferOffsetAlignmentBytes: DeviceSize,
    storageTexelBufferOffsetSingleTexelAlignment: Bool32,
    uniformTexelBufferOffsetAlignmentBytes: DeviceSize,
    uniformTexelBufferOffsetSingleTexelAlignment: Bool32,
};
pub const PhysicalDeviceSubgroupSizeControlFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceSubgroupSizeControlFeaturesEXT,
    pNext: ?*c_void = null,
    subgroupSizeControl: Bool32 = FALSE,
    computeFullSubgroups: Bool32 = FALSE,
};
pub const PhysicalDeviceSubgroupSizeControlPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceSubgroupSizeControlPropertiesEXT,
    pNext: ?*c_void = null,
    minSubgroupSize: u32,
    maxSubgroupSize: u32,
    maxComputeWorkgroupSubgroups: u32,
    requiredSubgroupSizeStages: ShaderStageFlags,
};
pub const PipelineShaderStageRequiredSubgroupSizeCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineShaderStageRequiredSubgroupSizeCreateInfoEXT,
    pNext: ?*c_void = null,
    requiredSubgroupSize: u32,
};
pub const SubpassShadingPipelineCreateInfoHUAWEI = extern struct {
    sType: StructureType = .subpassShadingPipelineCreateInfoHUAWEI,
    pNext: ?*c_void = null,
    renderPass: RenderPass,
    subpass: u32,
};
pub const PhysicalDeviceSubpassShadingPropertiesHUAWEI = extern struct {
    sType: StructureType = .physicalDeviceSubpassShadingPropertiesHUAWEI,
    pNext: ?*c_void = null,
    maxSubpassShadingWorkgroupSizeAspectRatio: u32,
};
pub const MemoryOpaqueCaptureAddressAllocateInfo = extern struct {
    sType: StructureType = .memoryOpaqueCaptureAddressAllocateInfo,
    pNext: ?*const c_void = null,
    opaqueCaptureAddress: u64,
};
pub const MemoryOpaqueCaptureAddressAllocateInfoKHR = MemoryOpaqueCaptureAddressAllocateInfo;
pub const DeviceMemoryOpaqueCaptureAddressInfo = extern struct {
    sType: StructureType = .deviceMemoryOpaqueCaptureAddressInfo,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
};
pub const DeviceMemoryOpaqueCaptureAddressInfoKHR = DeviceMemoryOpaqueCaptureAddressInfo;
pub const PhysicalDeviceLineRasterizationFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceLineRasterizationFeaturesEXT,
    pNext: ?*c_void = null,
    rectangularLines: Bool32 = FALSE,
    bresenhamLines: Bool32 = FALSE,
    smoothLines: Bool32 = FALSE,
    stippledRectangularLines: Bool32 = FALSE,
    stippledBresenhamLines: Bool32 = FALSE,
    stippledSmoothLines: Bool32 = FALSE,
};
pub const PhysicalDeviceLineRasterizationPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceLineRasterizationPropertiesEXT,
    pNext: ?*c_void = null,
    lineSubPixelPrecisionBits: u32,
};
pub const PipelineRasterizationLineStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineRasterizationLineStateCreateInfoEXT,
    pNext: ?*const c_void = null,
    lineRasterizationMode: LineRasterizationModeEXT,
    stippledLineEnable: Bool32,
    lineStippleFactor: u32,
    lineStipplePattern: u16,
};
pub const PhysicalDevicePipelineCreationCacheControlFeaturesEXT = extern struct {
    sType: StructureType = .physicalDevicePipelineCreationCacheControlFeaturesEXT,
    pNext: ?*c_void = null,
    pipelineCreationCacheControl: Bool32 = FALSE,
};
pub const PhysicalDeviceVulkan11Features = extern struct {
    sType: StructureType = .physicalDeviceVulkan11Features,
    pNext: ?*c_void = null,
    storageBuffer16BitAccess: Bool32 = FALSE,
    uniformAndStorageBuffer16BitAccess: Bool32 = FALSE,
    storagePushConstant16: Bool32 = FALSE,
    storageInputOutput16: Bool32 = FALSE,
    multiview: Bool32 = FALSE,
    multiviewGeometryShader: Bool32 = FALSE,
    multiviewTessellationShader: Bool32 = FALSE,
    variablePointersStorageBuffer: Bool32 = FALSE,
    variablePointers: Bool32 = FALSE,
    protectedMemory: Bool32 = FALSE,
    samplerYcbcrConversion: Bool32 = FALSE,
    shaderDrawParameters: Bool32 = FALSE,
};
pub const PhysicalDeviceVulkan11Properties = extern struct {
    sType: StructureType = .physicalDeviceVulkan11Properties,
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
    sType: StructureType = .physicalDeviceVulkan12Features,
    pNext: ?*c_void = null,
    samplerMirrorClampToEdge: Bool32 = FALSE,
    drawIndirectCount: Bool32 = FALSE,
    storageBuffer8BitAccess: Bool32 = FALSE,
    uniformAndStorageBuffer8BitAccess: Bool32 = FALSE,
    storagePushConstant8: Bool32 = FALSE,
    shaderBufferInt64Atomics: Bool32 = FALSE,
    shaderSharedInt64Atomics: Bool32 = FALSE,
    shaderFloat16: Bool32 = FALSE,
    shaderInt8: Bool32 = FALSE,
    descriptorIndexing: Bool32 = FALSE,
    shaderInputAttachmentArrayDynamicIndexing: Bool32 = FALSE,
    shaderUniformTexelBufferArrayDynamicIndexing: Bool32 = FALSE,
    shaderStorageTexelBufferArrayDynamicIndexing: Bool32 = FALSE,
    shaderUniformBufferArrayNonUniformIndexing: Bool32 = FALSE,
    shaderSampledImageArrayNonUniformIndexing: Bool32 = FALSE,
    shaderStorageBufferArrayNonUniformIndexing: Bool32 = FALSE,
    shaderStorageImageArrayNonUniformIndexing: Bool32 = FALSE,
    shaderInputAttachmentArrayNonUniformIndexing: Bool32 = FALSE,
    shaderUniformTexelBufferArrayNonUniformIndexing: Bool32 = FALSE,
    shaderStorageTexelBufferArrayNonUniformIndexing: Bool32 = FALSE,
    descriptorBindingUniformBufferUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingSampledImageUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingStorageImageUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingStorageBufferUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingUniformTexelBufferUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingStorageTexelBufferUpdateAfterBind: Bool32 = FALSE,
    descriptorBindingUpdateUnusedWhilePending: Bool32 = FALSE,
    descriptorBindingPartiallyBound: Bool32 = FALSE,
    descriptorBindingVariableDescriptorCount: Bool32 = FALSE,
    runtimeDescriptorArray: Bool32 = FALSE,
    samplerFilterMinmax: Bool32 = FALSE,
    scalarBlockLayout: Bool32 = FALSE,
    imagelessFramebuffer: Bool32 = FALSE,
    uniformBufferStandardLayout: Bool32 = FALSE,
    shaderSubgroupExtendedTypes: Bool32 = FALSE,
    separateDepthStencilLayouts: Bool32 = FALSE,
    hostQueryReset: Bool32 = FALSE,
    timelineSemaphore: Bool32 = FALSE,
    bufferDeviceAddress: Bool32 = FALSE,
    bufferDeviceAddressCaptureReplay: Bool32 = FALSE,
    bufferDeviceAddressMultiDevice: Bool32 = FALSE,
    vulkanMemoryModel: Bool32 = FALSE,
    vulkanMemoryModelDeviceScope: Bool32 = FALSE,
    vulkanMemoryModelAvailabilityVisibilityChains: Bool32 = FALSE,
    shaderOutputViewportIndex: Bool32 = FALSE,
    shaderOutputLayer: Bool32 = FALSE,
    subgroupBroadcastDynamicId: Bool32 = FALSE,
};
pub const PhysicalDeviceVulkan12Properties = extern struct {
    sType: StructureType = .physicalDeviceVulkan12Properties,
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
    sType: StructureType = .pipelineCompilerControlCreateInfoAMD,
    pNext: ?*const c_void = null,
    compilerControlFlags: PipelineCompilerControlFlagsAMD,
};
pub const PhysicalDeviceCoherentMemoryFeaturesAMD = extern struct {
    sType: StructureType = .physicalDeviceCoherentMemoryFeaturesAMD,
    pNext: ?*c_void = null,
    deviceCoherentMemory: Bool32 = FALSE,
};
pub const PhysicalDeviceToolPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceToolPropertiesEXT,
    pNext: ?*c_void = null,
    name: [MAX_EXTENSION_NAME_SIZE]u8,
    version: [MAX_EXTENSION_NAME_SIZE]u8,
    purposes: ToolPurposeFlagsEXT,
    description: [MAX_DESCRIPTION_SIZE]u8,
    layer: [MAX_EXTENSION_NAME_SIZE]u8,
};
pub const SamplerCustomBorderColorCreateInfoEXT = extern struct {
    sType: StructureType = .samplerCustomBorderColorCreateInfoEXT,
    pNext: ?*const c_void = null,
    customBorderColor: ClearColorValue,
    format: Format,
};
pub const PhysicalDeviceCustomBorderColorPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceCustomBorderColorPropertiesEXT,
    pNext: ?*c_void = null,
    maxCustomBorderColorSamplers: u32,
};
pub const PhysicalDeviceCustomBorderColorFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceCustomBorderColorFeaturesEXT,
    pNext: ?*c_void = null,
    customBorderColors: Bool32 = FALSE,
    customBorderColorWithoutFormat: Bool32 = FALSE,
};
pub const SamplerBorderColorComponentMappingCreateInfoEXT = extern struct {
    sType: StructureType = .samplerBorderColorComponentMappingCreateInfoEXT,
    pNext: ?*const c_void = null,
    components: ComponentMapping,
    srgb: Bool32,
};
pub const PhysicalDeviceBorderColorSwizzleFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceBorderColorSwizzleFeaturesEXT,
    pNext: ?*c_void = null,
    borderColorSwizzle: Bool32 = FALSE,
    borderColorSwizzleFromImage: Bool32 = FALSE,
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
    sType: StructureType = .accelerationStructureGeometryTrianglesDataKHR,
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
    sType: StructureType = .accelerationStructureGeometryAabbsDataKHR,
    pNext: ?*const c_void = null,
    data: DeviceOrHostAddressConstKHR,
    stride: DeviceSize,
};
pub const AccelerationStructureGeometryInstancesDataKHR = extern struct {
    sType: StructureType = .accelerationStructureGeometryInstancesDataKHR,
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
    sType: StructureType = .accelerationStructureGeometryKHR,
    pNext: ?*const c_void = null,
    geometryType: GeometryTypeKHR,
    geometry: AccelerationStructureGeometryDataKHR,
    flags: GeometryFlagsKHR,
};
pub const AccelerationStructureBuildGeometryInfoKHR = extern struct {
    sType: StructureType = .accelerationStructureBuildGeometryInfoKHR,
    pNext: ?*const c_void = null,
    @"type": AccelerationStructureTypeKHR,
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
    sType: StructureType = .accelerationStructureCreateInfoKHR,
    pNext: ?*const c_void = null,
    createFlags: AccelerationStructureCreateFlagsKHR,
    buffer: Buffer,
    offset: DeviceSize,
    size: DeviceSize,
    @"type": AccelerationStructureTypeKHR,
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
    sType: StructureType = .accelerationStructureDeviceAddressInfoKHR,
    pNext: ?*const c_void = null,
    accelerationStructure: AccelerationStructureKHR,
};
pub const AccelerationStructureVersionInfoKHR = extern struct {
    sType: StructureType = .accelerationStructureVersionInfoKHR,
    pNext: ?*const c_void = null,
    pVersionData: [*]const u8,
};
pub const CopyAccelerationStructureInfoKHR = extern struct {
    sType: StructureType = .copyAccelerationStructureInfoKHR,
    pNext: ?*const c_void = null,
    src: AccelerationStructureKHR,
    dst: AccelerationStructureKHR,
    mode: CopyAccelerationStructureModeKHR,
};
pub const CopyAccelerationStructureToMemoryInfoKHR = extern struct {
    sType: StructureType = .copyAccelerationStructureToMemoryInfoKHR,
    pNext: ?*const c_void = null,
    src: AccelerationStructureKHR,
    dst: DeviceOrHostAddressKHR,
    mode: CopyAccelerationStructureModeKHR,
};
pub const CopyMemoryToAccelerationStructureInfoKHR = extern struct {
    sType: StructureType = .copyMemoryToAccelerationStructureInfoKHR,
    pNext: ?*const c_void = null,
    src: DeviceOrHostAddressConstKHR,
    dst: AccelerationStructureKHR,
    mode: CopyAccelerationStructureModeKHR,
};
pub const RayTracingPipelineInterfaceCreateInfoKHR = extern struct {
    sType: StructureType = .rayTracingPipelineInterfaceCreateInfoKHR,
    pNext: ?*const c_void = null,
    maxPipelineRayPayloadSize: u32,
    maxPipelineRayHitAttributeSize: u32,
};
pub const PipelineLibraryCreateInfoKHR = extern struct {
    sType: StructureType = .pipelineLibraryCreateInfoKHR,
    pNext: ?*const c_void = null,
    libraryCount: u32,
    pLibraries: [*]const Pipeline,
};
pub const PhysicalDeviceExtendedDynamicStateFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceExtendedDynamicStateFeaturesEXT,
    pNext: ?*c_void = null,
    extendedDynamicState: Bool32 = FALSE,
};
pub const PhysicalDeviceExtendedDynamicState2FeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceExtendedDynamicState2FeaturesEXT,
    pNext: ?*c_void = null,
    extendedDynamicState2: Bool32 = FALSE,
    extendedDynamicState2LogicOp: Bool32 = FALSE,
    extendedDynamicState2PatchControlPoints: Bool32 = FALSE,
};
pub const RenderPassTransformBeginInfoQCOM = extern struct {
    sType: StructureType = .renderPassTransformBeginInfoQCOM,
    pNext: ?*c_void = null,
    transform: SurfaceTransformFlagsKHR,
};
pub const CopyCommandTransformInfoQCOM = extern struct {
    sType: StructureType = .copyCommandTransformInfoQCOM,
    pNext: ?*const c_void = null,
    transform: SurfaceTransformFlagsKHR,
};
pub const CommandBufferInheritanceRenderPassTransformInfoQCOM = extern struct {
    sType: StructureType = .commandBufferInheritanceRenderPassTransformInfoQCOM,
    pNext: ?*c_void = null,
    transform: SurfaceTransformFlagsKHR,
    renderArea: Rect2D,
};
pub const PhysicalDeviceDiagnosticsConfigFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceDiagnosticsConfigFeaturesNV,
    pNext: ?*c_void = null,
    diagnosticsConfig: Bool32 = FALSE,
};
pub const DeviceDiagnosticsConfigCreateInfoNV = extern struct {
    sType: StructureType = .deviceDiagnosticsConfigCreateInfoNV,
    pNext: ?*const c_void = null,
    flags: DeviceDiagnosticsConfigFlagsNV,
};
pub const PhysicalDeviceZeroInitializeWorkgroupMemoryFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceZeroInitializeWorkgroupMemoryFeaturesKHR,
    pNext: ?*c_void = null,
    shaderZeroInitializeWorkgroupMemory: Bool32 = FALSE,
};
pub const PhysicalDeviceShaderSubgroupUniformControlFlowFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceShaderSubgroupUniformControlFlowFeaturesKHR,
    pNext: ?*c_void = null,
    shaderSubgroupUniformControlFlow: Bool32 = FALSE,
};
pub const PhysicalDeviceRobustness2FeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceRobustness2FeaturesEXT,
    pNext: ?*c_void = null,
    robustBufferAccess2: Bool32 = FALSE,
    robustImageAccess2: Bool32 = FALSE,
    nullDescriptor: Bool32 = FALSE,
};
pub const PhysicalDeviceRobustness2PropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceRobustness2PropertiesEXT,
    pNext: ?*c_void = null,
    robustStorageBufferAccessSizeAlignment: DeviceSize,
    robustUniformBufferAccessSizeAlignment: DeviceSize,
};
pub const PhysicalDeviceImageRobustnessFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceImageRobustnessFeaturesEXT,
    pNext: ?*c_void = null,
    robustImageAccess: Bool32 = FALSE,
};
pub const PhysicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR,
    pNext: ?*c_void = null,
    workgroupMemoryExplicitLayout: Bool32 = FALSE,
    workgroupMemoryExplicitLayoutScalarBlockLayout: Bool32 = FALSE,
    workgroupMemoryExplicitLayout8BitAccess: Bool32 = FALSE,
    workgroupMemoryExplicitLayout16BitAccess: Bool32 = FALSE,
};
pub const PhysicalDevicePortabilitySubsetFeaturesKHR = extern struct {
    sType: StructureType = .physicalDevicePortabilitySubsetFeaturesKHR,
    pNext: ?*c_void = null,
    constantAlphaColorBlendFactors: Bool32 = FALSE,
    events: Bool32 = FALSE,
    imageViewFormatReinterpretation: Bool32 = FALSE,
    imageViewFormatSwizzle: Bool32 = FALSE,
    imageView2DOn3DImage: Bool32 = FALSE,
    multisampleArrayImage: Bool32 = FALSE,
    mutableComparisonSamplers: Bool32 = FALSE,
    pointPolygons: Bool32 = FALSE,
    samplerMipLodBias: Bool32 = FALSE,
    separateStencilMaskRef: Bool32 = FALSE,
    shaderSampleRateInterpolationFunctions: Bool32 = FALSE,
    tessellationIsolines: Bool32 = FALSE,
    tessellationPointMode: Bool32 = FALSE,
    triangleFans: Bool32 = FALSE,
    vertexAttributeAccessBeyondStride: Bool32 = FALSE,
};
pub const PhysicalDevicePortabilitySubsetPropertiesKHR = extern struct {
    sType: StructureType = .physicalDevicePortabilitySubsetPropertiesKHR,
    pNext: ?*c_void = null,
    minVertexInputBindingStrideAlignment: u32,
};
pub const PhysicalDevice4444FormatsFeaturesEXT = extern struct {
    sType: StructureType = .physicalDevice4444FormatsFeaturesEXT,
    pNext: ?*c_void = null,
    formatA4r4g4b4: Bool32 = FALSE,
    formatA4b4g4r4: Bool32 = FALSE,
};
pub const PhysicalDeviceSubpassShadingFeaturesHUAWEI = extern struct {
    sType: StructureType = .physicalDeviceSubpassShadingFeaturesHUAWEI,
    pNext: ?*c_void = null,
    subpassShading: Bool32 = FALSE,
};
pub const BufferCopy2KHR = extern struct {
    sType: StructureType = .bufferCopy2KHR,
    pNext: ?*const c_void = null,
    srcOffset: DeviceSize,
    dstOffset: DeviceSize,
    size: DeviceSize,
};
pub const ImageCopy2KHR = extern struct {
    sType: StructureType = .imageCopy2KHR,
    pNext: ?*const c_void = null,
    srcSubresource: ImageSubresourceLayers,
    srcOffset: Offset3D,
    dstSubresource: ImageSubresourceLayers,
    dstOffset: Offset3D,
    extent: Extent3D,
};
pub const ImageBlit2KHR = extern struct {
    sType: StructureType = .imageBlit2KHR,
    pNext: ?*const c_void = null,
    srcSubresource: ImageSubresourceLayers,
    srcOffsets: [2]Offset3D,
    dstSubresource: ImageSubresourceLayers,
    dstOffsets: [2]Offset3D,
};
pub const BufferImageCopy2KHR = extern struct {
    sType: StructureType = .bufferImageCopy2KHR,
    pNext: ?*const c_void = null,
    bufferOffset: DeviceSize,
    bufferRowLength: u32,
    bufferImageHeight: u32,
    imageSubresource: ImageSubresourceLayers,
    imageOffset: Offset3D,
    imageExtent: Extent3D,
};
pub const ImageResolve2KHR = extern struct {
    sType: StructureType = .imageResolve2KHR,
    pNext: ?*const c_void = null,
    srcSubresource: ImageSubresourceLayers,
    srcOffset: Offset3D,
    dstSubresource: ImageSubresourceLayers,
    dstOffset: Offset3D,
    extent: Extent3D,
};
pub const CopyBufferInfo2KHR = extern struct {
    sType: StructureType = .copyBufferInfo2KHR,
    pNext: ?*const c_void = null,
    srcBuffer: Buffer,
    dstBuffer: Buffer,
    regionCount: u32,
    pRegions: [*]const BufferCopy2KHR,
};
pub const CopyImageInfo2KHR = extern struct {
    sType: StructureType = .copyImageInfo2KHR,
    pNext: ?*const c_void = null,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const ImageCopy2KHR,
};
pub const BlitImageInfo2KHR = extern struct {
    sType: StructureType = .blitImageInfo2KHR,
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
    sType: StructureType = .copyBufferToImageInfo2KHR,
    pNext: ?*const c_void = null,
    srcBuffer: Buffer,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const BufferImageCopy2KHR,
};
pub const CopyImageToBufferInfo2KHR = extern struct {
    sType: StructureType = .copyImageToBufferInfo2KHR,
    pNext: ?*const c_void = null,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstBuffer: Buffer,
    regionCount: u32,
    pRegions: [*]const BufferImageCopy2KHR,
};
pub const ResolveImageInfo2KHR = extern struct {
    sType: StructureType = .resolveImageInfo2KHR,
    pNext: ?*const c_void = null,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const ImageResolve2KHR,
};
pub const PhysicalDeviceShaderImageAtomicInt64FeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceShaderImageAtomicInt64FeaturesEXT,
    pNext: ?*c_void = null,
    shaderImageInt64Atomics: Bool32 = FALSE,
    sparseImageInt64Atomics: Bool32 = FALSE,
};
pub const FragmentShadingRateAttachmentInfoKHR = extern struct {
    sType: StructureType = .fragmentShadingRateAttachmentInfoKHR,
    pNext: ?*const c_void = null,
    pFragmentShadingRateAttachment: ?*const AttachmentReference2,
    shadingRateAttachmentTexelSize: Extent2D,
};
pub const PipelineFragmentShadingRateStateCreateInfoKHR = extern struct {
    sType: StructureType = .pipelineFragmentShadingRateStateCreateInfoKHR,
    pNext: ?*const c_void = null,
    fragmentSize: Extent2D,
    combinerOps: [2]FragmentShadingRateCombinerOpKHR,
};
pub const PhysicalDeviceFragmentShadingRateFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceFragmentShadingRateFeaturesKHR,
    pNext: ?*c_void = null,
    pipelineFragmentShadingRate: Bool32 = FALSE,
    primitiveFragmentShadingRate: Bool32 = FALSE,
    attachmentFragmentShadingRate: Bool32 = FALSE,
};
pub const PhysicalDeviceFragmentShadingRatePropertiesKHR = extern struct {
    sType: StructureType = .physicalDeviceFragmentShadingRatePropertiesKHR,
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
    sType: StructureType = .physicalDeviceFragmentShadingRateKHR,
    pNext: ?*c_void = null,
    sampleCounts: SampleCountFlags,
    fragmentSize: Extent2D,
};
pub const PhysicalDeviceShaderTerminateInvocationFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceShaderTerminateInvocationFeaturesKHR,
    pNext: ?*c_void = null,
    shaderTerminateInvocation: Bool32 = FALSE,
};
pub const PhysicalDeviceFragmentShadingRateEnumsFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceFragmentShadingRateEnumsFeaturesNV,
    pNext: ?*c_void = null,
    fragmentShadingRateEnums: Bool32 = FALSE,
    supersampleFragmentShadingRates: Bool32 = FALSE,
    noInvocationFragmentShadingRates: Bool32 = FALSE,
};
pub const PhysicalDeviceFragmentShadingRateEnumsPropertiesNV = extern struct {
    sType: StructureType = .physicalDeviceFragmentShadingRateEnumsPropertiesNV,
    pNext: ?*c_void = null,
    maxFragmentShadingRateInvocationCount: SampleCountFlags,
};
pub const PipelineFragmentShadingRateEnumStateCreateInfoNV = extern struct {
    sType: StructureType = .pipelineFragmentShadingRateEnumStateCreateInfoNV,
    pNext: ?*const c_void = null,
    shadingRateType: FragmentShadingRateTypeNV,
    shadingRate: FragmentShadingRateNV,
    combinerOps: [2]FragmentShadingRateCombinerOpKHR,
};
pub const AccelerationStructureBuildSizesInfoKHR = extern struct {
    sType: StructureType = .accelerationStructureBuildSizesInfoKHR,
    pNext: ?*const c_void = null,
    accelerationStructureSize: DeviceSize,
    updateScratchSize: DeviceSize,
    buildScratchSize: DeviceSize,
};
pub const PhysicalDeviceMutableDescriptorTypeFeaturesVALVE = extern struct {
    sType: StructureType = .physicalDeviceMutableDescriptorTypeFeaturesVALVE,
    pNext: ?*c_void = null,
    mutableDescriptorType: Bool32 = FALSE,
};
pub const MutableDescriptorTypeListVALVE = extern struct {
    descriptorTypeCount: u32,
    pDescriptorTypes: [*]const DescriptorType,
};
pub const MutableDescriptorTypeCreateInfoVALVE = extern struct {
    sType: StructureType = .mutableDescriptorTypeCreateInfoVALVE,
    pNext: ?*const c_void = null,
    mutableDescriptorTypeListCount: u32,
    pMutableDescriptorTypeLists: [*]const MutableDescriptorTypeListVALVE,
};
pub const PhysicalDeviceVertexInputDynamicStateFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceVertexInputDynamicStateFeaturesEXT,
    pNext: ?*c_void = null,
    vertexInputDynamicState: Bool32 = FALSE,
};
pub const PhysicalDeviceExternalMemoryRDMAFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceExternalMemoryRdmaFeaturesNV,
    pNext: ?*c_void = null,
    externalMemoryRdma: Bool32 = FALSE,
};
pub const VertexInputBindingDescription2EXT = extern struct {
    sType: StructureType = .vertexInputBindingDescription2EXT,
    pNext: ?*c_void = null,
    binding: u32,
    stride: u32,
    inputRate: VertexInputRate,
    divisor: u32,
};
pub const VertexInputAttributeDescription2EXT = extern struct {
    sType: StructureType = .vertexInputAttributeDescription2EXT,
    pNext: ?*c_void = null,
    location: u32,
    binding: u32,
    format: Format,
    offset: u32,
};
pub const PhysicalDeviceColorWriteEnableFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceColorWriteEnableFeaturesEXT,
    pNext: ?*c_void = null,
    colorWriteEnable: Bool32 = FALSE,
};
pub const PipelineColorWriteCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineColorWriteCreateInfoEXT,
    pNext: ?*const c_void = null,
    attachmentCount: u32,
    pColorWriteEnables: [*]const Bool32,
};
pub const MemoryBarrier2KHR = extern struct {
    sType: StructureType = .memoryBarrier2KHR,
    pNext: ?*const c_void = null,
    srcStageMask: PipelineStageFlags2KHR,
    srcAccessMask: AccessFlags2KHR,
    dstStageMask: PipelineStageFlags2KHR,
    dstAccessMask: AccessFlags2KHR,
};
pub const ImageMemoryBarrier2KHR = extern struct {
    sType: StructureType = .imageMemoryBarrier2KHR,
    pNext: ?*const c_void = null,
    srcStageMask: PipelineStageFlags2KHR,
    srcAccessMask: AccessFlags2KHR,
    dstStageMask: PipelineStageFlags2KHR,
    dstAccessMask: AccessFlags2KHR,
    oldLayout: ImageLayout,
    newLayout: ImageLayout,
    srcQueueFamilyIndex: u32,
    dstQueueFamilyIndex: u32,
    image: Image,
    subresourceRange: ImageSubresourceRange,
};
pub const BufferMemoryBarrier2KHR = extern struct {
    sType: StructureType = .bufferMemoryBarrier2KHR,
    pNext: ?*const c_void = null,
    srcStageMask: PipelineStageFlags2KHR,
    srcAccessMask: AccessFlags2KHR,
    dstStageMask: PipelineStageFlags2KHR,
    dstAccessMask: AccessFlags2KHR,
    srcQueueFamilyIndex: u32,
    dstQueueFamilyIndex: u32,
    buffer: Buffer,
    offset: DeviceSize,
    size: DeviceSize,
};
pub const DependencyInfoKHR = extern struct {
    sType: StructureType = .dependencyInfoKHR,
    pNext: ?*const c_void = null,
    dependencyFlags: DependencyFlags,
    memoryBarrierCount: u32,
    pMemoryBarriers: [*]const MemoryBarrier2KHR,
    bufferMemoryBarrierCount: u32,
    pBufferMemoryBarriers: [*]const BufferMemoryBarrier2KHR,
    imageMemoryBarrierCount: u32,
    pImageMemoryBarriers: [*]const ImageMemoryBarrier2KHR,
};
pub const SemaphoreSubmitInfoKHR = extern struct {
    sType: StructureType = .semaphoreSubmitInfoKHR,
    pNext: ?*const c_void = null,
    semaphore: Semaphore,
    value: u64,
    stageMask: PipelineStageFlags2KHR,
    deviceIndex: u32,
};
pub const CommandBufferSubmitInfoKHR = extern struct {
    sType: StructureType = .commandBufferSubmitInfoKHR,
    pNext: ?*const c_void = null,
    commandBuffer: CommandBuffer,
    deviceMask: u32,
};
pub const SubmitInfo2KHR = extern struct {
    sType: StructureType = .submitInfo2KHR,
    pNext: ?*const c_void = null,
    flags: SubmitFlagsKHR,
    waitSemaphoreInfoCount: u32,
    pWaitSemaphoreInfos: [*]const SemaphoreSubmitInfoKHR,
    commandBufferInfoCount: u32,
    pCommandBufferInfos: [*]const CommandBufferSubmitInfoKHR,
    signalSemaphoreInfoCount: u32,
    pSignalSemaphoreInfos: [*]const SemaphoreSubmitInfoKHR,
};
pub const QueueFamilyCheckpointProperties2NV = extern struct {
    sType: StructureType = .queueFamilyCheckpointProperties2NV,
    pNext: ?*c_void = null,
    checkpointExecutionStageMask: PipelineStageFlags2KHR,
};
pub const CheckpointData2NV = extern struct {
    sType: StructureType = .checkpointData2NV,
    pNext: ?*c_void = null,
    stage: PipelineStageFlags2KHR,
    pCheckpointMarker: *c_void,
};
pub const PhysicalDeviceSynchronization2FeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceSynchronization2FeaturesKHR,
    pNext: ?*c_void = null,
    synchronization2: Bool32 = FALSE,
};
pub const VideoQueueFamilyProperties2KHR = extern struct {
    sType: StructureType = .videoQueueFamilyProperties2KHR,
    pNext: ?*c_void = null,
    videoCodecOperations: VideoCodecOperationFlagsKHR,
};
pub const VideoProfilesKHR = extern struct {
    sType: StructureType = .videoProfilesKHR,
    pNext: ?*c_void = null,
    profileCount: u32,
    pProfiles: *const VideoProfileKHR,
};
pub const PhysicalDeviceVideoFormatInfoKHR = extern struct {
    sType: StructureType = .physicalDeviceVideoFormatInfoKHR,
    pNext: ?*c_void = null,
    imageUsage: ImageUsageFlags,
    pVideoProfiles: *const VideoProfilesKHR,
};
pub const VideoFormatPropertiesKHR = extern struct {
    sType: StructureType = .videoFormatPropertiesKHR,
    pNext: ?*c_void = null,
    format: Format,
};
pub const VideoProfileKHR = extern struct {
    sType: StructureType = .videoProfileKHR,
    pNext: ?*c_void = null,
    videoCodecOperation: VideoCodecOperationFlagsKHR,
    chromaSubsampling: VideoChromaSubsamplingFlagsKHR,
    lumaBitDepth: VideoComponentBitDepthFlagsKHR,
    chromaBitDepth: VideoComponentBitDepthFlagsKHR,
};
pub const VideoCapabilitiesKHR = extern struct {
    sType: StructureType = .videoCapabilitiesKHR,
    pNext: ?*c_void = null,
    capabilityFlags: VideoCapabilityFlagsKHR,
    minBitstreamBufferOffsetAlignment: DeviceSize,
    minBitstreamBufferSizeAlignment: DeviceSize,
    videoPictureExtentGranularity: Extent2D,
    minExtent: Extent2D,
    maxExtent: Extent2D,
    maxReferencePicturesSlotsCount: u32,
    maxReferencePicturesActiveCount: u32,
};
pub const VideoGetMemoryPropertiesKHR = extern struct {
    sType: StructureType = .videoGetMemoryPropertiesKHR,
    pNext: ?*const c_void = null,
    memoryBindIndex: u32,
    pMemoryRequirements: *MemoryRequirements2,
};
pub const VideoBindMemoryKHR = extern struct {
    sType: StructureType = .videoBindMemoryKHR,
    pNext: ?*const c_void = null,
    memoryBindIndex: u32,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
    memorySize: DeviceSize,
};
pub const VideoPictureResourceKHR = extern struct {
    sType: StructureType = .videoPictureResourceKHR,
    pNext: ?*const c_void = null,
    codedOffset: Offset2D,
    codedExtent: Extent2D,
    baseArrayLayer: u32,
    imageViewBinding: ImageView,
};
pub const VideoReferenceSlotKHR = extern struct {
    sType: StructureType = .videoReferenceSlotKHR,
    pNext: ?*const c_void = null,
    slotIndex: i8,
    pPictureResource: *const VideoPictureResourceKHR,
};
pub const VideoDecodeInfoKHR = extern struct {
    sType: StructureType = .videoDecodeInfoKHR,
    pNext: ?*const c_void = null,
    flags: VideoDecodeFlagsKHR,
    codedOffset: Offset2D,
    codedExtent: Extent2D,
    srcBuffer: Buffer,
    srcBufferOffset: DeviceSize,
    srcBufferRange: DeviceSize,
    dstPictureResource: VideoPictureResourceKHR,
    pSetupReferenceSlot: *const VideoReferenceSlotKHR,
    referenceSlotCount: u32,
    pReferenceSlots: [*]const VideoReferenceSlotKHR,
};
pub const StdVideoH264ProfileIdc = if (@hasDecl(root, "StdVideoH264ProfileIdc")) root.StdVideoH264ProfileIdc else @compileError("Missing type definition of 'StdVideoH264ProfileIdc'");
pub const StdVideoH264Level = if (@hasDecl(root, "StdVideoH264Level")) root.StdVideoH264Level else @compileError("Missing type definition of 'StdVideoH264Level'");
pub const StdVideoH264ChromaFormatIdc = if (@hasDecl(root, "StdVideoH264ChromaFormatIdc")) root.StdVideoH264ChromaFormatIdc else @compileError("Missing type definition of 'StdVideoH264ChromaFormatIdc'");
pub const StdVideoH264PocType = if (@hasDecl(root, "StdVideoH264PocType")) root.StdVideoH264PocType else @compileError("Missing type definition of 'StdVideoH264PocType'");
pub const StdVideoH264SpsFlags = if (@hasDecl(root, "StdVideoH264SpsFlags")) root.StdVideoH264SpsFlags else @compileError("Missing type definition of 'StdVideoH264SpsFlags'");
pub const StdVideoH264ScalingLists = if (@hasDecl(root, "StdVideoH264ScalingLists")) root.StdVideoH264ScalingLists else @compileError("Missing type definition of 'StdVideoH264ScalingLists'");
pub const StdVideoH264SequenceParameterSetVui = if (@hasDecl(root, "StdVideoH264SequenceParameterSetVui")) root.StdVideoH264SequenceParameterSetVui else @compileError("Missing type definition of 'StdVideoH264SequenceParameterSetVui'");
pub const StdVideoH264AspectRatioIdc = if (@hasDecl(root, "StdVideoH264AspectRatioIdc")) root.StdVideoH264AspectRatioIdc else @compileError("Missing type definition of 'StdVideoH264AspectRatioIdc'");
pub const StdVideoH264HrdParameters = if (@hasDecl(root, "StdVideoH264HrdParameters")) root.StdVideoH264HrdParameters else @compileError("Missing type definition of 'StdVideoH264HrdParameters'");
pub const StdVideoH264SpsVuiFlags = if (@hasDecl(root, "StdVideoH264SpsVuiFlags")) root.StdVideoH264SpsVuiFlags else @compileError("Missing type definition of 'StdVideoH264SpsVuiFlags'");
pub const StdVideoH264WeightedBiPredIdc = if (@hasDecl(root, "StdVideoH264WeightedBiPredIdc")) root.StdVideoH264WeightedBiPredIdc else @compileError("Missing type definition of 'StdVideoH264WeightedBiPredIdc'");
pub const StdVideoH264PpsFlags = if (@hasDecl(root, "StdVideoH264PpsFlags")) root.StdVideoH264PpsFlags else @compileError("Missing type definition of 'StdVideoH264PpsFlags'");
pub const StdVideoH264SliceType = if (@hasDecl(root, "StdVideoH264SliceType")) root.StdVideoH264SliceType else @compileError("Missing type definition of 'StdVideoH264SliceType'");
pub const StdVideoH264CabacInitIdc = if (@hasDecl(root, "StdVideoH264CabacInitIdc")) root.StdVideoH264CabacInitIdc else @compileError("Missing type definition of 'StdVideoH264CabacInitIdc'");
pub const StdVideoH264DisableDeblockingFilterIdc = if (@hasDecl(root, "StdVideoH264DisableDeblockingFilterIdc")) root.StdVideoH264DisableDeblockingFilterIdc else @compileError("Missing type definition of 'StdVideoH264DisableDeblockingFilterIdc'");
pub const StdVideoH264PictureType = if (@hasDecl(root, "StdVideoH264PictureType")) root.StdVideoH264PictureType else @compileError("Missing type definition of 'StdVideoH264PictureType'");
pub const StdVideoH264ModificationOfPicNumsIdc = if (@hasDecl(root, "StdVideoH264ModificationOfPicNumsIdc")) root.StdVideoH264ModificationOfPicNumsIdc else @compileError("Missing type definition of 'StdVideoH264ModificationOfPicNumsIdc'");
pub const StdVideoH264MemMgmtControlOp = if (@hasDecl(root, "StdVideoH264MemMgmtControlOp")) root.StdVideoH264MemMgmtControlOp else @compileError("Missing type definition of 'StdVideoH264MemMgmtControlOp'");
pub const StdVideoDecodeH264PictureInfo = if (@hasDecl(root, "StdVideoDecodeH264PictureInfo")) root.StdVideoDecodeH264PictureInfo else @compileError("Missing type definition of 'StdVideoDecodeH264PictureInfo'");
pub const StdVideoDecodeH264ReferenceInfo = if (@hasDecl(root, "StdVideoDecodeH264ReferenceInfo")) root.StdVideoDecodeH264ReferenceInfo else @compileError("Missing type definition of 'StdVideoDecodeH264ReferenceInfo'");
pub const StdVideoDecodeH264Mvc = if (@hasDecl(root, "StdVideoDecodeH264Mvc")) root.StdVideoDecodeH264Mvc else @compileError("Missing type definition of 'StdVideoDecodeH264Mvc'");
pub const StdVideoDecodeH264PictureInfoFlags = if (@hasDecl(root, "StdVideoDecodeH264PictureInfoFlags")) root.StdVideoDecodeH264PictureInfoFlags else @compileError("Missing type definition of 'StdVideoDecodeH264PictureInfoFlags'");
pub const StdVideoDecodeH264ReferenceInfoFlags = if (@hasDecl(root, "StdVideoDecodeH264ReferenceInfoFlags")) root.StdVideoDecodeH264ReferenceInfoFlags else @compileError("Missing type definition of 'StdVideoDecodeH264ReferenceInfoFlags'");
pub const StdVideoDecodeH264MvcElement = if (@hasDecl(root, "StdVideoDecodeH264MvcElement")) root.StdVideoDecodeH264MvcElement else @compileError("Missing type definition of 'StdVideoDecodeH264MvcElement'");
pub const StdVideoDecodeH264MvcElementFlags = if (@hasDecl(root, "StdVideoDecodeH264MvcElementFlags")) root.StdVideoDecodeH264MvcElementFlags else @compileError("Missing type definition of 'StdVideoDecodeH264MvcElementFlags'");
pub const VideoDecodeH264ProfileEXT = extern struct {
    sType: StructureType = .videoDecodeH264ProfileEXT,
    pNext: ?*const c_void = null,
    stdProfileIdc: StdVideoH264ProfileIdc,
    pictureLayout: VideoDecodeH264PictureLayoutFlagsEXT,
};
pub const VideoDecodeH264CapabilitiesEXT = extern struct {
    sType: StructureType = .videoDecodeH264CapabilitiesEXT,
    pNext: ?*c_void = null,
    maxLevel: u32,
    fieldOffsetGranularity: Offset2D,
    stdExtensionVersion: ExtensionProperties,
};
pub const VideoDecodeH264SessionCreateInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH264SessionCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: VideoDecodeH264CreateFlagsEXT,
    pStdExtensionVersion: *const ExtensionProperties,
};
pub const StdVideoH264SequenceParameterSet = if (@hasDecl(root, "StdVideoH264SequenceParameterSet")) root.StdVideoH264SequenceParameterSet else @compileError("Missing type definition of 'StdVideoH264SequenceParameterSet'");
pub const StdVideoH264PictureParameterSet = if (@hasDecl(root, "StdVideoH264PictureParameterSet")) root.StdVideoH264PictureParameterSet else @compileError("Missing type definition of 'StdVideoH264PictureParameterSet'");
pub const VideoDecodeH264SessionParametersAddInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH264SessionParametersAddInfoEXT,
    pNext: ?*const c_void = null,
    spsStdCount: u32,
    pSpsStd: ?[*]const StdVideoH264SequenceParameterSet,
    ppsStdCount: u32,
    pPpsStd: ?[*]const StdVideoH264PictureParameterSet,
};
pub const VideoDecodeH264SessionParametersCreateInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH264SessionParametersCreateInfoEXT,
    pNext: ?*const c_void = null,
    maxSpsStdCount: u32,
    maxPpsStdCount: u32,
    pParametersAddInfo: ?*const VideoDecodeH264SessionParametersAddInfoEXT,
};
pub const VideoDecodeH264PictureInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH264PictureInfoEXT,
    pNext: ?*const c_void = null,
    pStdPictureInfo: *const StdVideoDecodeH264PictureInfo,
    slicesCount: u32,
    pSlicesDataOffsets: [*]const u32,
};
pub const VideoDecodeH264DpbSlotInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH264DpbSlotInfoEXT,
    pNext: ?*const c_void = null,
    pStdReferenceInfo: *const StdVideoDecodeH264ReferenceInfo,
};
pub const VideoDecodeH264MvcEXT = extern struct {
    sType: StructureType = .videoDecodeH264MvcEXT,
    pNext: ?*const c_void = null,
    pStdMvc: *const StdVideoDecodeH264Mvc,
};
pub const StdVideoH265ProfileIdc = if (@hasDecl(root, "StdVideoH265ProfileIdc")) root.StdVideoH265ProfileIdc else @compileError("Missing type definition of 'StdVideoH265ProfileIdc'");
pub const StdVideoH265VideoParameterSet = if (@hasDecl(root, "StdVideoH265VideoParameterSet")) root.StdVideoH265VideoParameterSet else @compileError("Missing type definition of 'StdVideoH265VideoParameterSet'");
pub const StdVideoH265SequenceParameterSet = if (@hasDecl(root, "StdVideoH265SequenceParameterSet")) root.StdVideoH265SequenceParameterSet else @compileError("Missing type definition of 'StdVideoH265SequenceParameterSet'");
pub const StdVideoH265PictureParameterSet = if (@hasDecl(root, "StdVideoH265PictureParameterSet")) root.StdVideoH265PictureParameterSet else @compileError("Missing type definition of 'StdVideoH265PictureParameterSet'");
pub const StdVideoH265DecPicBufMgr = if (@hasDecl(root, "StdVideoH265DecPicBufMgr")) root.StdVideoH265DecPicBufMgr else @compileError("Missing type definition of 'StdVideoH265DecPicBufMgr'");
pub const StdVideoH265HrdParameters = if (@hasDecl(root, "StdVideoH265HrdParameters")) root.StdVideoH265HrdParameters else @compileError("Missing type definition of 'StdVideoH265HrdParameters'");
pub const StdVideoH265VpsFlags = if (@hasDecl(root, "StdVideoH265VpsFlags")) root.StdVideoH265VpsFlags else @compileError("Missing type definition of 'StdVideoH265VpsFlags'");
pub const StdVideoH265Level = if (@hasDecl(root, "StdVideoH265Level")) root.StdVideoH265Level else @compileError("Missing type definition of 'StdVideoH265Level'");
pub const StdVideoH265SpsFlags = if (@hasDecl(root, "StdVideoH265SpsFlags")) root.StdVideoH265SpsFlags else @compileError("Missing type definition of 'StdVideoH265SpsFlags'");
pub const StdVideoH265ScalingLists = if (@hasDecl(root, "StdVideoH265ScalingLists")) root.StdVideoH265ScalingLists else @compileError("Missing type definition of 'StdVideoH265ScalingLists'");
pub const StdVideoH265SequenceParameterSetVui = if (@hasDecl(root, "StdVideoH265SequenceParameterSetVui")) root.StdVideoH265SequenceParameterSetVui else @compileError("Missing type definition of 'StdVideoH265SequenceParameterSetVui'");
pub const StdVideoH265PredictorPaletteEntries = if (@hasDecl(root, "StdVideoH265PredictorPaletteEntries")) root.StdVideoH265PredictorPaletteEntries else @compileError("Missing type definition of 'StdVideoH265PredictorPaletteEntries'");
pub const StdVideoH265PpsFlags = if (@hasDecl(root, "StdVideoH265PpsFlags")) root.StdVideoH265PpsFlags else @compileError("Missing type definition of 'StdVideoH265PpsFlags'");
pub const StdVideoH265SubLayerHrdParameters = if (@hasDecl(root, "StdVideoH265SubLayerHrdParameters")) root.StdVideoH265SubLayerHrdParameters else @compileError("Missing type definition of 'StdVideoH265SubLayerHrdParameters'");
pub const StdVideoH265HrdFlags = if (@hasDecl(root, "StdVideoH265HrdFlags")) root.StdVideoH265HrdFlags else @compileError("Missing type definition of 'StdVideoH265HrdFlags'");
pub const StdVideoH265SpsVuiFlags = if (@hasDecl(root, "StdVideoH265SpsVuiFlags")) root.StdVideoH265SpsVuiFlags else @compileError("Missing type definition of 'StdVideoH265SpsVuiFlags'");
pub const StdVideoDecodeH265PictureInfo = if (@hasDecl(root, "StdVideoDecodeH265PictureInfo")) root.StdVideoDecodeH265PictureInfo else @compileError("Missing type definition of 'StdVideoDecodeH265PictureInfo'");
pub const StdVideoDecodeH265ReferenceInfo = if (@hasDecl(root, "StdVideoDecodeH265ReferenceInfo")) root.StdVideoDecodeH265ReferenceInfo else @compileError("Missing type definition of 'StdVideoDecodeH265ReferenceInfo'");
pub const StdVideoDecodeH265PictureInfoFlags = if (@hasDecl(root, "StdVideoDecodeH265PictureInfoFlags")) root.StdVideoDecodeH265PictureInfoFlags else @compileError("Missing type definition of 'StdVideoDecodeH265PictureInfoFlags'");
pub const StdVideoDecodeH265ReferenceInfoFlags = if (@hasDecl(root, "StdVideoDecodeH265ReferenceInfoFlags")) root.StdVideoDecodeH265ReferenceInfoFlags else @compileError("Missing type definition of 'StdVideoDecodeH265ReferenceInfoFlags'");
pub const VideoDecodeH265ProfileEXT = extern struct {
    sType: StructureType = .videoDecodeH265ProfileEXT,
    pNext: ?*const c_void = null,
    stdProfileIdc: StdVideoH265ProfileIdc,
};
pub const VideoDecodeH265CapabilitiesEXT = extern struct {
    sType: StructureType = .videoDecodeH265CapabilitiesEXT,
    pNext: ?*c_void = null,
    maxLevel: u32,
    stdExtensionVersion: ExtensionProperties,
};
pub const VideoDecodeH265SessionCreateInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH265SessionCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: VideoDecodeH265CreateFlagsEXT,
    pStdExtensionVersion: *const ExtensionProperties,
};
pub const VideoDecodeH265SessionParametersAddInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH265SessionParametersAddInfoEXT,
    pNext: ?*const c_void = null,
    spsStdCount: u32,
    pSpsStd: ?[*]const StdVideoH265SequenceParameterSet,
    ppsStdCount: u32,
    pPpsStd: ?[*]const StdVideoH265PictureParameterSet,
};
pub const VideoDecodeH265SessionParametersCreateInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH265SessionParametersCreateInfoEXT,
    pNext: ?*const c_void = null,
    maxSpsStdCount: u32,
    maxPpsStdCount: u32,
    pParametersAddInfo: ?*const VideoDecodeH265SessionParametersAddInfoEXT,
};
pub const VideoDecodeH265PictureInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH265PictureInfoEXT,
    pNext: ?*const c_void = null,
    pStdPictureInfo: *StdVideoDecodeH265PictureInfo,
    slicesCount: u32,
    pSlicesDataOffsets: [*]const u32,
};
pub const VideoDecodeH265DpbSlotInfoEXT = extern struct {
    sType: StructureType = .videoDecodeH265DpbSlotInfoEXT,
    pNext: ?*const c_void = null,
    pStdReferenceInfo: *const StdVideoDecodeH265ReferenceInfo,
};
pub const VideoSessionCreateInfoKHR = extern struct {
    sType: StructureType = .videoSessionCreateInfoKHR,
    pNext: ?*const c_void = null,
    queueFamilyIndex: u32,
    flags: VideoSessionCreateFlagsKHR,
    pVideoProfile: *const VideoProfileKHR,
    pictureFormat: Format,
    maxCodedExtent: Extent2D,
    referencePicturesFormat: Format,
    maxReferencePicturesSlotsCount: u32,
    maxReferencePicturesActiveCount: u32,
};
pub const VideoSessionParametersCreateInfoKHR = extern struct {
    sType: StructureType = .videoSessionParametersCreateInfoKHR,
    pNext: ?*const c_void = null,
    videoSessionParametersTemplate: VideoSessionParametersKHR,
    videoSession: VideoSessionKHR,
};
pub const VideoSessionParametersUpdateInfoKHR = extern struct {
    sType: StructureType = .videoSessionParametersUpdateInfoKHR,
    pNext: ?*const c_void = null,
    updateSequenceCount: u32,
};
pub const VideoBeginCodingInfoKHR = extern struct {
    sType: StructureType = .videoBeginCodingInfoKHR,
    pNext: ?*const c_void = null,
    flags: VideoBeginCodingFlagsKHR,
    codecQualityPreset: VideoCodingQualityPresetFlagsKHR,
    videoSession: VideoSessionKHR,
    videoSessionParameters: VideoSessionParametersKHR,
    referenceSlotCount: u32,
    pReferenceSlots: [*]const VideoReferenceSlotKHR,
};
pub const VideoEndCodingInfoKHR = extern struct {
    sType: StructureType = .videoEndCodingInfoKHR,
    pNext: ?*const c_void = null,
    flags: VideoEndCodingFlagsKHR,
};
pub const VideoCodingControlInfoKHR = extern struct {
    sType: StructureType = .videoCodingControlInfoKHR,
    pNext: ?*const c_void = null,
    flags: VideoCodingControlFlagsKHR,
};
pub const VideoEncodeInfoKHR = extern struct {
    sType: StructureType = .videoEncodeInfoKHR,
    pNext: ?*const c_void = null,
    flags: VideoEncodeFlagsKHR,
    qualityLevel: u32,
    codedExtent: Extent2D,
    dstBitstreamBuffer: Buffer,
    dstBitstreamBufferOffset: DeviceSize,
    dstBitstreamBufferMaxRange: DeviceSize,
    srcPictureResource: VideoPictureResourceKHR,
    pSetupReferenceSlot: *const VideoReferenceSlotKHR,
    referenceSlotCount: u32,
    pReferenceSlots: [*]const VideoReferenceSlotKHR,
};
pub const VideoEncodeRateControlInfoKHR = extern struct {
    sType: StructureType = .videoEncodeRateControlInfoKHR,
    pNext: ?*const c_void = null,
    flags: VideoEncodeRateControlFlagsKHR,
    rateControlMode: VideoEncodeRateControlModeFlagsKHR,
    averageBitrate: u32,
    peakToAverageBitrateRatio: u16,
    frameRateNumerator: u16,
    frameRateDenominator: u16,
    virtualBufferSizeInMs: u32,
};
pub const VideoEncodeH264CapabilitiesEXT = extern struct {
    sType: StructureType = .videoEncodeH264CapabilitiesEXT,
    pNext: ?*const c_void = null,
    flags: VideoEncodeH264CapabilityFlagsEXT,
    inputModeFlags: VideoEncodeH264InputModeFlagsEXT,
    outputModeFlags: VideoEncodeH264OutputModeFlagsEXT,
    minPictureSizeInMbs: Extent2D,
    maxPictureSizeInMbs: Extent2D,
    inputImageDataAlignment: Extent2D,
    maxNumL0ReferenceForP: u8,
    maxNumL0ReferenceForB: u8,
    maxNumL1Reference: u8,
    qualityLevelCount: u8,
    stdExtensionVersion: ExtensionProperties,
};
pub const VideoEncodeH264SessionCreateInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH264SessionCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: VideoEncodeH264CreateFlagsEXT,
    maxPictureSizeInMbs: Extent2D,
    pStdExtensionVersion: *const ExtensionProperties,
};
pub const StdVideoEncodeH264SliceHeader = if (@hasDecl(root, "StdVideoEncodeH264SliceHeader")) root.StdVideoEncodeH264SliceHeader else @compileError("Missing type definition of 'StdVideoEncodeH264SliceHeader'");
pub const StdVideoEncodeH264PictureInfo = if (@hasDecl(root, "StdVideoEncodeH264PictureInfo")) root.StdVideoEncodeH264PictureInfo else @compileError("Missing type definition of 'StdVideoEncodeH264PictureInfo'");
pub const StdVideoEncodeH264SliceHeaderFlags = if (@hasDecl(root, "StdVideoEncodeH264SliceHeaderFlags")) root.StdVideoEncodeH264SliceHeaderFlags else @compileError("Missing type definition of 'StdVideoEncodeH264SliceHeaderFlags'");
pub const StdVideoEncodeH264RefMemMgmtCtrlOperations = if (@hasDecl(root, "StdVideoEncodeH264RefMemMgmtCtrlOperations")) root.StdVideoEncodeH264RefMemMgmtCtrlOperations else @compileError("Missing type definition of 'StdVideoEncodeH264RefMemMgmtCtrlOperations'");
pub const StdVideoEncodeH264PictureInfoFlags = if (@hasDecl(root, "StdVideoEncodeH264PictureInfoFlags")) root.StdVideoEncodeH264PictureInfoFlags else @compileError("Missing type definition of 'StdVideoEncodeH264PictureInfoFlags'");
pub const StdVideoEncodeH264RefMgmtFlags = if (@hasDecl(root, "StdVideoEncodeH264RefMgmtFlags")) root.StdVideoEncodeH264RefMgmtFlags else @compileError("Missing type definition of 'StdVideoEncodeH264RefMgmtFlags'");
pub const StdVideoEncodeH264RefListModEntry = if (@hasDecl(root, "StdVideoEncodeH264RefListModEntry")) root.StdVideoEncodeH264RefListModEntry else @compileError("Missing type definition of 'StdVideoEncodeH264RefListModEntry'");
pub const StdVideoEncodeH264RefPicMarkingEntry = if (@hasDecl(root, "StdVideoEncodeH264RefPicMarkingEntry")) root.StdVideoEncodeH264RefPicMarkingEntry else @compileError("Missing type definition of 'StdVideoEncodeH264RefPicMarkingEntry'");
pub const VideoEncodeH264SessionParametersAddInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH264SessionParametersAddInfoEXT,
    pNext: ?*const c_void = null,
    spsStdCount: u32,
    pSpsStd: ?[*]const StdVideoH264SequenceParameterSet,
    ppsStdCount: u32,
    pPpsStd: ?[*]const StdVideoH264PictureParameterSet,
};
pub const VideoEncodeH264SessionParametersCreateInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH264SessionParametersCreateInfoEXT,
    pNext: ?*const c_void = null,
    maxSpsStdCount: u32,
    maxPpsStdCount: u32,
    pParametersAddInfo: ?*const VideoEncodeH264SessionParametersAddInfoEXT,
};
pub const VideoEncodeH264DpbSlotInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH264DpbSlotInfoEXT,
    pNext: ?*const c_void = null,
    slotIndex: i8,
    pStdPictureInfo: *const StdVideoEncodeH264PictureInfo,
};
pub const VideoEncodeH264VclFrameInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH264VclFrameInfoEXT,
    pNext: ?*const c_void = null,
    refDefaultFinalList0EntryCount: u8,
    pRefDefaultFinalList0Entries: [*]const VideoEncodeH264DpbSlotInfoEXT,
    refDefaultFinalList1EntryCount: u8,
    pRefDefaultFinalList1Entries: [*]const VideoEncodeH264DpbSlotInfoEXT,
    naluSliceEntryCount: u32,
    pNaluSliceEntries: [*]const VideoEncodeH264NaluSliceEXT,
    pCurrentPictureInfo: *const VideoEncodeH264DpbSlotInfoEXT,
};
pub const VideoEncodeH264EmitPictureParametersEXT = extern struct {
    sType: StructureType = .videoEncodeH264EmitPictureParametersEXT,
    pNext: ?*const c_void = null,
    spsId: u8,
    emitSpsEnable: Bool32,
    ppsIdEntryCount: u32,
    ppsIdEntries: [*]const u8,
};
pub const VideoEncodeH264ProfileEXT = extern struct {
    sType: StructureType = .videoEncodeH264ProfileEXT,
    pNext: ?*const c_void = null,
    stdProfileIdc: StdVideoH264ProfileIdc,
};
pub const VideoEncodeH264NaluSliceEXT = extern struct {
    sType: StructureType = .videoEncodeH264NaluSliceEXT,
    pNext: ?*const c_void = null,
    pSliceHeaderStd: *const StdVideoEncodeH264SliceHeader,
    mbCount: u32,
    refFinalList0EntryCount: u8,
    pRefFinalList0Entries: [*]const VideoEncodeH264DpbSlotInfoEXT,
    refFinalList1EntryCount: u8,
    pRefFinalList1Entries: [*]const VideoEncodeH264DpbSlotInfoEXT,
    precedingNaluBytes: u32,
    minQp: u8,
    maxQp: u8,
};
pub const VideoEncodeH265CapabilitiesEXT = extern struct {
    sType: StructureType = .videoEncodeH265CapabilitiesEXT,
    pNext: ?*const c_void = null,
    flags: VideoEncodeH265CapabilityFlagsEXT,
    inputModeFlags: VideoEncodeH265InputModeFlagsEXT,
    outputModeFlags: VideoEncodeH265OutputModeFlagsEXT,
    ctbSizes: VideoEncodeH265CtbSizeFlagsEXT,
    inputImageDataAlignment: Extent2D,
    maxNumL0ReferenceForP: u8,
    maxNumL0ReferenceForB: u8,
    maxNumL1Reference: u8,
    maxNumSubLayers: u8,
    qualityLevelCount: u8,
    stdExtensionVersion: ExtensionProperties,
};
pub const VideoEncodeH265SessionCreateInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH265SessionCreateInfoEXT,
    pNext: ?*const c_void = null,
    flags: VideoEncodeH265CreateFlagsEXT,
    pStdExtensionVersion: *const ExtensionProperties,
};
pub const StdVideoEncodeH265PictureInfoFlags = if (@hasDecl(root, "StdVideoEncodeH265PictureInfoFlags")) root.StdVideoEncodeH265PictureInfoFlags else @compileError("Missing type definition of 'StdVideoEncodeH265PictureInfoFlags'");
pub const StdVideoEncodeH265SliceSegmentHeader = if (@hasDecl(root, "StdVideoEncodeH265SliceSegmentHeader")) root.StdVideoEncodeH265SliceSegmentHeader else @compileError("Missing type definition of 'StdVideoEncodeH265SliceSegmentHeader'");
pub const StdVideoEncodeH265PictureInfo = if (@hasDecl(root, "StdVideoEncodeH265PictureInfo")) root.StdVideoEncodeH265PictureInfo else @compileError("Missing type definition of 'StdVideoEncodeH265PictureInfo'");
pub const StdVideoEncodeH265SliceHeader = if (@hasDecl(root, "StdVideoEncodeH265SliceHeader")) root.StdVideoEncodeH265SliceHeader else @compileError("Missing type definition of 'StdVideoEncodeH265SliceHeader'");
pub const StdVideoEncodeH265ReferenceInfo = if (@hasDecl(root, "StdVideoEncodeH265ReferenceInfo")) root.StdVideoEncodeH265ReferenceInfo else @compileError("Missing type definition of 'StdVideoEncodeH265ReferenceInfo'");
pub const StdVideoEncodeH265ReferenceModifications = if (@hasDecl(root, "StdVideoEncodeH265ReferenceModifications")) root.StdVideoEncodeH265ReferenceModifications else @compileError("Missing type definition of 'StdVideoEncodeH265ReferenceModifications'");
pub const VideoEncodeH265SessionParametersAddInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH265SessionParametersAddInfoEXT,
    pNext: ?*const c_void = null,
    vpsStdCount: u32,
    pVpsStd: ?[*]const StdVideoH265VideoParameterSet,
    spsStdCount: u32,
    pSpsStd: ?[*]const StdVideoH265SequenceParameterSet,
    ppsStdCount: u32,
    pPpsStd: ?[*]const StdVideoH265PictureParameterSet,
};
pub const VideoEncodeH265SessionParametersCreateInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH265SessionParametersCreateInfoEXT,
    pNext: ?*const c_void = null,
    maxVpsStdCount: u32,
    maxSpsStdCount: u32,
    maxPpsStdCount: u32,
    pParametersAddInfo: ?*const VideoEncodeH265SessionParametersAddInfoEXT,
};
pub const VideoEncodeH265VclFrameInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH265VclFrameInfoEXT,
    pNext: ?*const c_void = null,
    pReferenceFinalLists: ?*const VideoEncodeH265ReferenceListsEXT,
    naluSliceEntryCount: u32,
    pNaluSliceEntries: [*]const VideoEncodeH265NaluSliceEXT,
    pCurrentPictureInfo: *const StdVideoEncodeH265PictureInfo,
};
pub const VideoEncodeH265EmitPictureParametersEXT = extern struct {
    sType: StructureType = .videoEncodeH265EmitPictureParametersEXT,
    pNext: ?*const c_void = null,
    vpsId: u8,
    spsId: u8,
    emitVpsEnable: Bool32,
    emitSpsEnable: Bool32,
    ppsIdEntryCount: u32,
    ppsIdEntries: [*]const u8,
};
pub const VideoEncodeH265NaluSliceEXT = extern struct {
    sType: StructureType = .videoEncodeH265NaluSliceEXT,
    pNext: ?*const c_void = null,
    ctbCount: u32,
    pReferenceFinalLists: ?*const VideoEncodeH265ReferenceListsEXT,
    pSliceHeaderStd: *const StdVideoEncodeH265SliceHeader,
};
pub const VideoEncodeH265ProfileEXT = extern struct {
    sType: StructureType = .videoEncodeH265ProfileEXT,
    pNext: ?*const c_void = null,
    stdProfileIdc: StdVideoH265ProfileIdc,
};
pub const VideoEncodeH265DpbSlotInfoEXT = extern struct {
    sType: StructureType = .videoEncodeH265DpbSlotInfoEXT,
    pNext: ?*const c_void = null,
    slotIndex: i8,
    pStdReferenceInfo: *const StdVideoEncodeH265ReferenceInfo,
};
pub const VideoEncodeH265ReferenceListsEXT = extern struct {
    sType: StructureType = .videoEncodeH265ReferenceListsEXT,
    pNext: ?*const c_void = null,
    referenceList0EntryCount: u8,
    pReferenceList0Entries: [*]const VideoEncodeH265DpbSlotInfoEXT,
    referenceList1EntryCount: u8,
    pReferenceList1Entries: [*]const VideoEncodeH265DpbSlotInfoEXT,
    pReferenceModifications: *const StdVideoEncodeH265ReferenceModifications,
};
pub const PhysicalDeviceInheritedViewportScissorFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceInheritedViewportScissorFeaturesNV,
    pNext: ?*c_void = null,
    inheritedViewportScissor2D: Bool32 = FALSE,
};
pub const CommandBufferInheritanceViewportScissorInfoNV = extern struct {
    sType: StructureType = .commandBufferInheritanceViewportScissorInfoNV,
    pNext: ?*const c_void = null,
    viewportScissor2D: Bool32,
    viewportDepthCount: u32,
    pViewportDepths: *const Viewport,
};
pub const PhysicalDeviceYcbcr2Plane444FormatsFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceYcbcr2Plane444FormatsFeaturesEXT,
    pNext: ?*c_void = null,
    ycbcr2Plane444Formats: Bool32 = FALSE,
};
pub const PhysicalDeviceProvokingVertexFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceProvokingVertexFeaturesEXT,
    pNext: ?*c_void = null,
    provokingVertexLast: Bool32 = FALSE,
    transformFeedbackPreservesProvokingVertex: Bool32 = FALSE,
};
pub const PhysicalDeviceProvokingVertexPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceProvokingVertexPropertiesEXT,
    pNext: ?*c_void = null,
    provokingVertexModePerPipeline: Bool32,
    transformFeedbackPreservesTriangleFanProvokingVertex: Bool32,
};
pub const PipelineRasterizationProvokingVertexStateCreateInfoEXT = extern struct {
    sType: StructureType = .pipelineRasterizationProvokingVertexStateCreateInfoEXT,
    pNext: ?*const c_void = null,
    provokingVertexMode: ProvokingVertexModeEXT,
};
pub const CuModuleCreateInfoNVX = extern struct {
    sType: StructureType = .cuModuleCreateInfoNVX,
    pNext: ?*const c_void = null,
    dataSize: usize,
    pData: *const c_void,
};
pub const CuFunctionCreateInfoNVX = extern struct {
    sType: StructureType = .cuFunctionCreateInfoNVX,
    pNext: ?*const c_void = null,
    module: CuModuleNVX,
    pName: [*:0]const u8,
};
pub const CuLaunchInfoNVX = extern struct {
    sType: StructureType = .cuLaunchInfoNVX,
    pNext: ?*const c_void = null,
    function: CuFunctionNVX,
    gridDimX: u32,
    gridDimY: u32,
    gridDimZ: u32,
    blockDimX: u32,
    blockDimY: u32,
    blockDimZ: u32,
    sharedMemBytes: u32,
    paramCount: usize,
    pParams: [*]const *const c_void,
    extraCount: usize,
    pExtras: [*]const *const c_void,
};
pub const PhysicalDeviceShaderIntegerDotProductFeaturesKHR = extern struct {
    sType: StructureType = .physicalDeviceShaderIntegerDotProductFeaturesKHR,
    pNext: ?*c_void = null,
    shaderIntegerDotProduct: Bool32 = FALSE,
};
pub const PhysicalDeviceShaderIntegerDotProductPropertiesKHR = extern struct {
    sType: StructureType = .physicalDeviceShaderIntegerDotProductPropertiesKHR,
    pNext: ?*c_void = null,
    integerDotProduct8BitUnsignedAccelerated: Bool32,
    integerDotProduct8BitSignedAccelerated: Bool32,
    integerDotProduct8BitMixedSignednessAccelerated: Bool32,
    integerDotProduct4X8BitPackedUnsignedAccelerated: Bool32,
    integerDotProduct4X8BitPackedSignedAccelerated: Bool32,
    integerDotProduct4X8BitPackedMixedSignednessAccelerated: Bool32,
    integerDotProduct16BitUnsignedAccelerated: Bool32,
    integerDotProduct16BitSignedAccelerated: Bool32,
    integerDotProduct16BitMixedSignednessAccelerated: Bool32,
    integerDotProduct32BitUnsignedAccelerated: Bool32,
    integerDotProduct32BitSignedAccelerated: Bool32,
    integerDotProduct32BitMixedSignednessAccelerated: Bool32,
    integerDotProduct64BitUnsignedAccelerated: Bool32,
    integerDotProduct64BitSignedAccelerated: Bool32,
    integerDotProduct64BitMixedSignednessAccelerated: Bool32,
    integerDotProductAccumulatingSaturating8BitUnsignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating8BitSignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating8BitMixedSignednessAccelerated: Bool32,
    integerDotProductAccumulatingSaturating4X8BitPackedUnsignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating4X8BitPackedSignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating4X8BitPackedMixedSignednessAccelerated: Bool32,
    integerDotProductAccumulatingSaturating16BitUnsignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating16BitSignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating16BitMixedSignednessAccelerated: Bool32,
    integerDotProductAccumulatingSaturating32BitUnsignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating32BitSignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating32BitMixedSignednessAccelerated: Bool32,
    integerDotProductAccumulatingSaturating64BitUnsignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating64BitSignedAccelerated: Bool32,
    integerDotProductAccumulatingSaturating64BitMixedSignednessAccelerated: Bool32,
};
pub const PhysicalDeviceDrmPropertiesEXT = extern struct {
    sType: StructureType = .physicalDeviceDrmPropertiesEXT,
    pNext: ?*c_void = null,
    hasPrimary: Bool32,
    hasRender: Bool32,
    primaryMajor: i64,
    primaryMinor: i64,
    renderMajor: i64,
    renderMinor: i64,
};
pub const PhysicalDeviceRayTracingMotionBlurFeaturesNV = extern struct {
    sType: StructureType = .physicalDeviceRayTracingMotionBlurFeaturesNV,
    pNext: ?*c_void = null,
    rayTracingMotionBlur: Bool32 = FALSE,
    rayTracingMotionBlurPipelineTraceRaysIndirect: Bool32 = FALSE,
};
pub const AccelerationStructureGeometryMotionTrianglesDataNV = extern struct {
    sType: StructureType = .accelerationStructureGeometryMotionTrianglesDataNV,
    pNext: ?*const c_void = null,
    vertexData: DeviceOrHostAddressConstKHR,
};
pub const AccelerationStructureMotionInfoNV = extern struct {
    sType: StructureType = .accelerationStructureMotionInfoNV,
    pNext: ?*const c_void = null,
    maxInstances: u32,
    flags: AccelerationStructureMotionInfoFlagsNV,
};
pub const SRTDataNV = extern struct {
    sx: f32,
    a: f32,
    b: f32,
    pvx: f32,
    sy: f32,
    c: f32,
    pvy: f32,
    sz: f32,
    pvz: f32,
    qx: f32,
    qy: f32,
    qz: f32,
    qw: f32,
    tx: f32,
    ty: f32,
    tz: f32,
};
pub const AccelerationStructureSRTMotionInstanceNV = packed struct {
    transformT0: SRTDataNV,
    transformT1: SRTDataNV,
    instanceCustomIndex: u24,
    mask: u8,
    instanceShaderBindingTableRecordOffset: u24,
    flags: u8, // GeometryInstanceFlagsKHR
    accelerationStructureReference: u64,
};
pub const AccelerationStructureMatrixMotionInstanceNV = packed struct {
    transformT0: TransformMatrixKHR,
    transformT1: TransformMatrixKHR,
    instanceCustomIndex: u24,
    mask: u8,
    instanceShaderBindingTableRecordOffset: u24,
    flags: u8, // GeometryInstanceFlagsKHR
    accelerationStructureReference: u64,
};
pub const AccelerationStructureMotionInstanceDataNV = extern union {
    staticInstance: AccelerationStructureInstanceKHR,
    matrixMotionInstance: AccelerationStructureMatrixMotionInstanceNV,
    srtMotionInstance: AccelerationStructureSRTMotionInstanceNV,
};
pub const AccelerationStructureMotionInstanceNV = extern struct {
    @"type": AccelerationStructureMotionInstanceTypeNV,
    flags: AccelerationStructureMotionInstanceFlagsNV,
    data: AccelerationStructureMotionInstanceDataNV,
};
pub const RemoteAddressNV = *c_void;
pub const MemoryGetRemoteAddressInfoNV = extern struct {
    sType: StructureType = .memoryGetRemoteAddressInfoNV,
    pNext: ?*const c_void = null,
    memory: DeviceMemory,
    handleType: ExternalMemoryHandleTypeFlags,
};
pub const ImportMemoryBufferCollectionFUCHSIA = extern struct {
    sType: StructureType = .importMemoryBufferCollectionFUCHSIA,
    pNext: ?*const c_void = null,
    collection: BufferCollectionFUCHSIA,
    index: u32,
};
pub const BufferCollectionImageCreateInfoFUCHSIA = extern struct {
    sType: StructureType = .bufferCollectionImageCreateInfoFUCHSIA,
    pNext: ?*const c_void = null,
    collection: BufferCollectionFUCHSIA,
    index: u32,
};
pub const BufferCollectionBufferCreateInfoFUCHSIA = extern struct {
    sType: StructureType = .bufferCollectionBufferCreateInfoFUCHSIA,
    pNext: ?*const c_void = null,
    collection: BufferCollectionFUCHSIA,
    index: u32,
};
pub const BufferCollectionCreateInfoFUCHSIA = extern struct {
    sType: StructureType = .bufferCollectionCreateInfoFUCHSIA,
    pNext: ?*const c_void = null,
    collectionToken: zx_handle_t,
};
pub const BufferCollectionPropertiesFUCHSIA = extern struct {
    sType: StructureType = .bufferCollectionPropertiesFUCHSIA,
    pNext: ?*c_void = null,
    memoryTypeBits: u32,
    bufferCount: u32,
    createInfoIndex: u32,
    sysmemPixelFormat: u64,
    formatFeatures: FormatFeatureFlags,
    sysmemColorSpaceIndex: SysmemColorSpaceFUCHSIA,
    samplerYcbcrConversionComponents: ComponentMapping,
    suggestedYcbcrModel: SamplerYcbcrModelConversion,
    suggestedYcbcrRange: SamplerYcbcrRange,
    suggestedXChromaOffset: ChromaLocation,
    suggestedYChromaOffset: ChromaLocation,
};
pub const BufferConstraintsInfoFUCHSIA = extern struct {
    sType: StructureType = .bufferConstraintsInfoFUCHSIA,
    pNext: ?*const c_void = null,
    createInfo: BufferCreateInfo,
    requiredFormatFeatures: FormatFeatureFlags,
    bufferCollectionConstraints: BufferCollectionConstraintsInfoFUCHSIA,
};
pub const SysmemColorSpaceFUCHSIA = extern struct {
    sType: StructureType = .sysmemColorSpaceFUCHSIA,
    pNext: ?*const c_void = null,
    colorSpace: u32,
};
pub const ImageFormatConstraintsInfoFUCHSIA = extern struct {
    sType: StructureType = .imageFormatConstraintsInfoFUCHSIA,
    pNext: ?*const c_void = null,
    imageCreateInfo: ImageCreateInfo,
    requiredFormatFeatures: FormatFeatureFlags,
    flags: ImageFormatConstraintsFlagsFUCHSIA,
    sysmemPixelFormat: u64,
    colorSpaceCount: u32,
    pColorSpaces: *const SysmemColorSpaceFUCHSIA,
};
pub const ImageConstraintsInfoFUCHSIA = extern struct {
    sType: StructureType = .imageConstraintsInfoFUCHSIA,
    pNext: ?*const c_void = null,
    formatConstraintsCount: u32,
    pFormatConstraints: [*]const ImageFormatConstraintsInfoFUCHSIA,
    bufferCollectionConstraints: BufferCollectionConstraintsInfoFUCHSIA,
    flags: ImageConstraintsInfoFlagsFUCHSIA,
};
pub const BufferCollectionConstraintsInfoFUCHSIA = extern struct {
    sType: StructureType = .bufferCollectionConstraintsInfoFUCHSIA,
    pNext: ?*const c_void = null,
    minBufferCount: u32,
    maxBufferCount: u32,
    minBufferCountForCamping: u32,
    minBufferCountForDedicatedSlack: u32,
    minBufferCountForSharedSlack: u32,
};
pub const PhysicalDeviceRGBA10X6FormatsFeaturesEXT = extern struct {
    sType: StructureType = .physicalDeviceRgba10x6FormatsFeaturesEXT,
    pNext: ?*c_void = null,
    formatRgba10X6WithoutYCbCrSampler: Bool32 = FALSE,
};
pub const FormatProperties3KHR = extern struct {
    sType: StructureType = .formatProperties3KHR,
    pNext: ?*c_void = null,
    linearTilingFeatures: FormatFeatureFlags2KHR,
    optimalTilingFeatures: FormatFeatureFlags2KHR,
    bufferFeatures: FormatFeatureFlags2KHR,
};
pub const DrmFormatModifierPropertiesList2EXT = extern struct {
    sType: StructureType = .drmFormatModifierPropertiesList2EXT,
    pNext: ?*c_void = null,
    drmFormatModifierCount: u32,
    pDrmFormatModifierProperties: ?[*]DrmFormatModifierProperties2EXT,
};
pub const DrmFormatModifierProperties2EXT = extern struct {
    drmFormatModifier: u64,
    drmFormatModifierPlaneCount: u32,
    drmFormatModifierTilingFeatures: FormatFeatureFlags2KHR,
};
pub const AndroidHardwareBufferFormatProperties2ANDROID = extern struct {
    sType: StructureType = .androidHardwareBufferFormatProperties2ANDROID,
    pNext: ?*c_void = null,
    format: Format,
    externalFormat: u64,
    formatFeatures: FormatFeatureFlags2KHR,
    samplerYcbcrConversionComponents: ComponentMapping,
    suggestedYcbcrModel: SamplerYcbcrModelConversion,
    suggestedYcbcrRange: SamplerYcbcrRange,
    suggestedXChromaOffset: ChromaLocation,
    suggestedYChromaOffset: ChromaLocation,
};
pub const ImageLayout = enum(i32) {
    @"undefined" = 0,
    general = 1,
    colorAttachmentOptimal = 2,
    depthStencilAttachmentOptimal = 3,
    depthStencilReadOnlyOptimal = 4,
    shaderReadOnlyOptimal = 5,
    transferSrcOptimal = 6,
    transferDstOptimal = 7,
    preinitialized = 8,
    depthReadOnlyStencilAttachmentOptimal = 1000117000,
    depthAttachmentStencilReadOnlyOptimal = 1000117001,
    depthAttachmentOptimal = 1000241000,
    depthReadOnlyOptimal = 1000241001,
    stencilAttachmentOptimal = 1000241002,
    stencilReadOnlyOptimal = 1000241003,
    presentSrcKHR = 1000001002,
    videoDecodeDstKHR = 1000024000,
    videoDecodeSrcKHR = 1000024001,
    videoDecodeDpbKHR = 1000024002,
    sharedPresentKHR = 1000111000,
    fragmentDensityMapOptimalEXT = 1000218000,
    fragmentShadingRateAttachmentOptimalKHR = 1000164003,
    videoEncodeDstKHR = 1000299000,
    videoEncodeSrcKHR = 1000299001,
    videoEncodeDpbKHR = 1000299002,
    readOnlyOptimalKHR = 1000314000,
    attachmentOptimalKHR = 1000314001,
    _,
    pub const depthReadOnlyStencilAttachmentOptimalKHR = ImageLayout.depthReadOnlyStencilAttachmentOptimal;
    pub const depthAttachmentStencilReadOnlyOptimalKHR = ImageLayout.depthAttachmentStencilReadOnlyOptimal;
    pub const shadingRateOptimalNV = ImageLayout.fragmentShadingRateAttachmentOptimalKHR;
    pub const depthAttachmentOptimalKHR = ImageLayout.depthAttachmentOptimal;
    pub const depthReadOnlyOptimalKHR = ImageLayout.depthReadOnlyOptimal;
    pub const stencilAttachmentOptimalKHR = ImageLayout.stencilAttachmentOptimal;
    pub const stencilReadOnlyOptimalKHR = ImageLayout.stencilReadOnlyOptimal;
};
pub const AttachmentLoadOp = enum(i32) {
    load = 0,
    clear = 1,
    dontCare = 2,
    noneEXT = 1000400000,
    _,
};
pub const AttachmentStoreOp = enum(i32) {
    store = 0,
    dontCare = 1,
    noneEXT = 1000301000,
    _,
    pub const noneQCOM = AttachmentStoreOp.noneEXT;
};
pub const ImageType = enum(i32) {
    @"1D" = 0,
    @"2D" = 1,
    @"3D" = 2,
    _,
};
pub const ImageTiling = enum(i32) {
    optimal = 0,
    linear = 1,
    drmFormatModifierEXT = 1000158000,
    _,
};
pub const ImageViewType = enum(i32) {
    @"1D" = 0,
    @"2D" = 1,
    @"3D" = 2,
    cube = 3,
    @"1DArray" = 4,
    @"2DArray" = 5,
    cubeArray = 6,
    _,
};
pub const CommandBufferLevel = enum(i32) {
    primary = 0,
    secondary = 1,
    _,
};
pub const ComponentSwizzle = enum(i32) {
    identity = 0,
    zero = 1,
    one = 2,
    r = 3,
    g = 4,
    b = 5,
    a = 6,
    _,
};
pub const DescriptorType = enum(i32) {
    sampler = 0,
    combinedImageSampler = 1,
    sampledImage = 2,
    storageImage = 3,
    uniformTexelBuffer = 4,
    storageTexelBuffer = 5,
    uniformBuffer = 6,
    storageBuffer = 7,
    uniformBufferDynamic = 8,
    storageBufferDynamic = 9,
    inputAttachment = 10,
    inlineUniformBlockEXT = 1000138000,
    accelerationStructureKHR = 1000150000,
    accelerationStructureNV = 1000165000,
    mutableVALVE = 1000351000,
    _,
};
pub const QueryType = enum(i32) {
    occlusion = 0,
    pipelineStatistics = 1,
    timestamp = 2,
    resultStatusOnlyKHR = 1000023000,
    transformFeedbackStreamEXT = 1000028004,
    performanceQueryKHR = 1000116000,
    accelerationStructureCompactedSizeKHR = 1000150000,
    accelerationStructureSerializationSizeKHR = 1000150001,
    accelerationStructureCompactedSizeNV = 1000165000,
    performanceQueryINTEL = 1000210000,
    videoEncodeBitstreamBufferRangeKHR = 1000299000,
    _,
};
pub const BorderColor = enum(i32) {
    floatTransparentBlack = 0,
    intTransparentBlack = 1,
    floatOpaqueBlack = 2,
    intOpaqueBlack = 3,
    floatOpaqueWhite = 4,
    intOpaqueWhite = 5,
    floatCustomEXT = 1000287003,
    intCustomEXT = 1000287004,
    _,
};
pub const PipelineBindPoint = enum(i32) {
    graphics = 0,
    compute = 1,
    rayTracingKHR = 1000165000,
    subpassShadingHUAWEI = 1000369003,
    _,
    pub const rayTracingNV = PipelineBindPoint.rayTracingKHR;
};
pub const PipelineCacheHeaderVersion = enum(i32) {
    one = 1,
    _,
};
pub const PipelineCacheCreateFlags = packed struct {
    externallySynchronizedBitEXT: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(PipelineCacheCreateFlags, Flags);
};
pub const PrimitiveTopology = enum(i32) {
    pointList = 0,
    lineList = 1,
    lineStrip = 2,
    triangleList = 3,
    triangleStrip = 4,
    triangleFan = 5,
    lineListWithAdjacency = 6,
    lineStripWithAdjacency = 7,
    triangleListWithAdjacency = 8,
    triangleStripWithAdjacency = 9,
    patchList = 10,
    _,
};
pub const SharingMode = enum(i32) {
    exclusive = 0,
    concurrent = 1,
    _,
};
pub const IndexType = enum(i32) {
    uint16 = 0,
    uint32 = 1,
    noneKHR = 1000165000,
    uint8EXT = 1000265000,
    _,
    pub const noneNV = IndexType.noneKHR;
};
pub const Filter = enum(i32) {
    nearest = 0,
    linear = 1,
    cubicIMG = 1000015000,
    _,
    pub const cubicEXT = Filter.cubicIMG;
};
pub const SamplerMipmapMode = enum(i32) {
    nearest = 0,
    linear = 1,
    _,
};
pub const SamplerAddressMode = enum(i32) {
    repeat = 0,
    mirroredRepeat = 1,
    clampToEdge = 2,
    clampToBorder = 3,
    mirrorClampToEdge = 4,
    _,
    pub const mirrorClampToEdgeKHR = SamplerAddressMode.mirrorClampToEdge;
};
pub const CompareOp = enum(i32) {
    never = 0,
    less = 1,
    equal = 2,
    lessOrEqual = 3,
    greater = 4,
    notEqual = 5,
    greaterOrEqual = 6,
    always = 7,
    _,
};
pub const PolygonMode = enum(i32) {
    fill = 0,
    line = 1,
    point = 2,
    fillRectangleNV = 1000153000,
    _,
};
pub const FrontFace = enum(i32) {
    counterClockwise = 0,
    clockwise = 1,
    _,
};
pub const BlendFactor = enum(i32) {
    zero = 0,
    one = 1,
    srcColor = 2,
    oneMinusSrcColor = 3,
    dstColor = 4,
    oneMinusDstColor = 5,
    srcAlpha = 6,
    oneMinusSrcAlpha = 7,
    dstAlpha = 8,
    oneMinusDstAlpha = 9,
    constantColor = 10,
    oneMinusConstantColor = 11,
    constantAlpha = 12,
    oneMinusConstantAlpha = 13,
    srcAlphaSaturate = 14,
    src1Color = 15,
    oneMinusSrc1Color = 16,
    src1Alpha = 17,
    oneMinusSrc1Alpha = 18,
    _,
};
pub const BlendOp = enum(i32) {
    add = 0,
    subtract = 1,
    reverseSubtract = 2,
    min = 3,
    max = 4,
    zeroEXT = 1000148000,
    srcEXT = 1000148001,
    dstEXT = 1000148002,
    srcOverEXT = 1000148003,
    dstOverEXT = 1000148004,
    srcInEXT = 1000148005,
    dstInEXT = 1000148006,
    srcOutEXT = 1000148007,
    dstOutEXT = 1000148008,
    srcAtopEXT = 1000148009,
    dstAtopEXT = 1000148010,
    xorEXT = 1000148011,
    multiplyEXT = 1000148012,
    screenEXT = 1000148013,
    overlayEXT = 1000148014,
    darkenEXT = 1000148015,
    lightenEXT = 1000148016,
    colordodgeEXT = 1000148017,
    colorburnEXT = 1000148018,
    hardlightEXT = 1000148019,
    softlightEXT = 1000148020,
    differenceEXT = 1000148021,
    exclusionEXT = 1000148022,
    invertEXT = 1000148023,
    invertRgbEXT = 1000148024,
    lineardodgeEXT = 1000148025,
    linearburnEXT = 1000148026,
    vividlightEXT = 1000148027,
    linearlightEXT = 1000148028,
    pinlightEXT = 1000148029,
    hardmixEXT = 1000148030,
    hslHueEXT = 1000148031,
    hslSaturationEXT = 1000148032,
    hslColorEXT = 1000148033,
    hslLuminosityEXT = 1000148034,
    plusEXT = 1000148035,
    plusClampedEXT = 1000148036,
    plusClampedAlphaEXT = 1000148037,
    plusDarkerEXT = 1000148038,
    minusEXT = 1000148039,
    minusClampedEXT = 1000148040,
    contrastEXT = 1000148041,
    invertOvgEXT = 1000148042,
    redEXT = 1000148043,
    greenEXT = 1000148044,
    blueEXT = 1000148045,
    _,
};
pub const StencilOp = enum(i32) {
    keep = 0,
    zero = 1,
    replace = 2,
    incrementAndClamp = 3,
    decrementAndClamp = 4,
    invert = 5,
    incrementAndWrap = 6,
    decrementAndWrap = 7,
    _,
};
pub const LogicOp = enum(i32) {
    clear = 0,
    @"and" = 1,
    andReverse = 2,
    copy = 3,
    andInverted = 4,
    noOp = 5,
    xor = 6,
    @"or" = 7,
    nor = 8,
    equivalent = 9,
    invert = 10,
    orReverse = 11,
    copyInverted = 12,
    orInverted = 13,
    nand = 14,
    set = 15,
    _,
};
pub const InternalAllocationType = enum(i32) {
    executable = 0,
    _,
};
pub const SystemAllocationScope = enum(i32) {
    command = 0,
    object = 1,
    cache = 2,
    device = 3,
    instance = 4,
    _,
};
pub const PhysicalDeviceType = enum(i32) {
    other = 0,
    integratedGpu = 1,
    discreteGpu = 2,
    virtualGpu = 3,
    cpu = 4,
    _,
};
pub const VertexInputRate = enum(i32) {
    vertex = 0,
    instance = 1,
    _,
};
pub const Format = enum(i32) {
    @"undefined" = 0,
    r4g4UnormPack8 = 1,
    r4g4b4a4UnormPack16 = 2,
    b4g4r4a4UnormPack16 = 3,
    r5g6b5UnormPack16 = 4,
    b5g6r5UnormPack16 = 5,
    r5g5b5a1UnormPack16 = 6,
    b5g5r5a1UnormPack16 = 7,
    a1r5g5b5UnormPack16 = 8,
    r8Unorm = 9,
    r8Snorm = 10,
    r8Uscaled = 11,
    r8Sscaled = 12,
    r8Uint = 13,
    r8Sint = 14,
    r8Srgb = 15,
    r8g8Unorm = 16,
    r8g8Snorm = 17,
    r8g8Uscaled = 18,
    r8g8Sscaled = 19,
    r8g8Uint = 20,
    r8g8Sint = 21,
    r8g8Srgb = 22,
    r8g8b8Unorm = 23,
    r8g8b8Snorm = 24,
    r8g8b8Uscaled = 25,
    r8g8b8Sscaled = 26,
    r8g8b8Uint = 27,
    r8g8b8Sint = 28,
    r8g8b8Srgb = 29,
    b8g8r8Unorm = 30,
    b8g8r8Snorm = 31,
    b8g8r8Uscaled = 32,
    b8g8r8Sscaled = 33,
    b8g8r8Uint = 34,
    b8g8r8Sint = 35,
    b8g8r8Srgb = 36,
    r8g8b8a8Unorm = 37,
    r8g8b8a8Snorm = 38,
    r8g8b8a8Uscaled = 39,
    r8g8b8a8Sscaled = 40,
    r8g8b8a8Uint = 41,
    r8g8b8a8Sint = 42,
    r8g8b8a8Srgb = 43,
    b8g8r8a8Unorm = 44,
    b8g8r8a8Snorm = 45,
    b8g8r8a8Uscaled = 46,
    b8g8r8a8Sscaled = 47,
    b8g8r8a8Uint = 48,
    b8g8r8a8Sint = 49,
    b8g8r8a8Srgb = 50,
    a8b8g8r8UnormPack32 = 51,
    a8b8g8r8SnormPack32 = 52,
    a8b8g8r8UscaledPack32 = 53,
    a8b8g8r8SscaledPack32 = 54,
    a8b8g8r8UintPack32 = 55,
    a8b8g8r8SintPack32 = 56,
    a8b8g8r8SrgbPack32 = 57,
    a2r10g10b10UnormPack32 = 58,
    a2r10g10b10SnormPack32 = 59,
    a2r10g10b10UscaledPack32 = 60,
    a2r10g10b10SscaledPack32 = 61,
    a2r10g10b10UintPack32 = 62,
    a2r10g10b10SintPack32 = 63,
    a2b10g10r10UnormPack32 = 64,
    a2b10g10r10SnormPack32 = 65,
    a2b10g10r10UscaledPack32 = 66,
    a2b10g10r10SscaledPack32 = 67,
    a2b10g10r10UintPack32 = 68,
    a2b10g10r10SintPack32 = 69,
    r16Unorm = 70,
    r16Snorm = 71,
    r16Uscaled = 72,
    r16Sscaled = 73,
    r16Uint = 74,
    r16Sint = 75,
    r16Sfloat = 76,
    r16g16Unorm = 77,
    r16g16Snorm = 78,
    r16g16Uscaled = 79,
    r16g16Sscaled = 80,
    r16g16Uint = 81,
    r16g16Sint = 82,
    r16g16Sfloat = 83,
    r16g16b16Unorm = 84,
    r16g16b16Snorm = 85,
    r16g16b16Uscaled = 86,
    r16g16b16Sscaled = 87,
    r16g16b16Uint = 88,
    r16g16b16Sint = 89,
    r16g16b16Sfloat = 90,
    r16g16b16a16Unorm = 91,
    r16g16b16a16Snorm = 92,
    r16g16b16a16Uscaled = 93,
    r16g16b16a16Sscaled = 94,
    r16g16b16a16Uint = 95,
    r16g16b16a16Sint = 96,
    r16g16b16a16Sfloat = 97,
    r32Uint = 98,
    r32Sint = 99,
    r32Sfloat = 100,
    r32g32Uint = 101,
    r32g32Sint = 102,
    r32g32Sfloat = 103,
    r32g32b32Uint = 104,
    r32g32b32Sint = 105,
    r32g32b32Sfloat = 106,
    r32g32b32a32Uint = 107,
    r32g32b32a32Sint = 108,
    r32g32b32a32Sfloat = 109,
    r64Uint = 110,
    r64Sint = 111,
    r64Sfloat = 112,
    r64g64Uint = 113,
    r64g64Sint = 114,
    r64g64Sfloat = 115,
    r64g64b64Uint = 116,
    r64g64b64Sint = 117,
    r64g64b64Sfloat = 118,
    r64g64b64a64Uint = 119,
    r64g64b64a64Sint = 120,
    r64g64b64a64Sfloat = 121,
    b10g11r11UfloatPack32 = 122,
    e5b9g9r9UfloatPack32 = 123,
    d16Unorm = 124,
    x8D24UnormPack32 = 125,
    d32Sfloat = 126,
    s8Uint = 127,
    d16UnormS8Uint = 128,
    d24UnormS8Uint = 129,
    d32SfloatS8Uint = 130,
    bc1RgbUnormBlock = 131,
    bc1RgbSrgbBlock = 132,
    bc1RgbaUnormBlock = 133,
    bc1RgbaSrgbBlock = 134,
    bc2UnormBlock = 135,
    bc2SrgbBlock = 136,
    bc3UnormBlock = 137,
    bc3SrgbBlock = 138,
    bc4UnormBlock = 139,
    bc4SnormBlock = 140,
    bc5UnormBlock = 141,
    bc5SnormBlock = 142,
    bc6hUfloatBlock = 143,
    bc6hSfloatBlock = 144,
    bc7UnormBlock = 145,
    bc7SrgbBlock = 146,
    etc2R8g8b8UnormBlock = 147,
    etc2R8g8b8SrgbBlock = 148,
    etc2R8g8b8a1UnormBlock = 149,
    etc2R8g8b8a1SrgbBlock = 150,
    etc2R8g8b8a8UnormBlock = 151,
    etc2R8g8b8a8SrgbBlock = 152,
    eacR11UnormBlock = 153,
    eacR11SnormBlock = 154,
    eacR11g11UnormBlock = 155,
    eacR11g11SnormBlock = 156,
    astc4X4UnormBlock = 157,
    astc4X4SrgbBlock = 158,
    astc5X4UnormBlock = 159,
    astc5X4SrgbBlock = 160,
    astc5X5UnormBlock = 161,
    astc5X5SrgbBlock = 162,
    astc6X5UnormBlock = 163,
    astc6X5SrgbBlock = 164,
    astc6X6UnormBlock = 165,
    astc6X6SrgbBlock = 166,
    astc8X5UnormBlock = 167,
    astc8X5SrgbBlock = 168,
    astc8X6UnormBlock = 169,
    astc8X6SrgbBlock = 170,
    astc8X8UnormBlock = 171,
    astc8X8SrgbBlock = 172,
    astc10X5UnormBlock = 173,
    astc10X5SrgbBlock = 174,
    astc10X6UnormBlock = 175,
    astc10X6SrgbBlock = 176,
    astc10X8UnormBlock = 177,
    astc10X8SrgbBlock = 178,
    astc10X10UnormBlock = 179,
    astc10X10SrgbBlock = 180,
    astc12X10UnormBlock = 181,
    astc12X10SrgbBlock = 182,
    astc12X12UnormBlock = 183,
    astc12X12SrgbBlock = 184,
    g8b8g8r8422Unorm = 1000156000,
    b8g8r8g8422Unorm = 1000156001,
    g8B8R83Plane420Unorm = 1000156002,
    g8B8r82Plane420Unorm = 1000156003,
    g8B8R83Plane422Unorm = 1000156004,
    g8B8r82Plane422Unorm = 1000156005,
    g8B8R83Plane444Unorm = 1000156006,
    r10x6UnormPack16 = 1000156007,
    r10x6g10x6Unorm2Pack16 = 1000156008,
    r10x6g10x6b10x6a10x6Unorm4Pack16 = 1000156009,
    g10x6b10x6g10x6r10x6422Unorm4Pack16 = 1000156010,
    b10x6g10x6r10x6g10x6422Unorm4Pack16 = 1000156011,
    g10x6B10x6R10x63Plane420Unorm3Pack16 = 1000156012,
    g10x6B10x6r10x62Plane420Unorm3Pack16 = 1000156013,
    g10x6B10x6R10x63Plane422Unorm3Pack16 = 1000156014,
    g10x6B10x6r10x62Plane422Unorm3Pack16 = 1000156015,
    g10x6B10x6R10x63Plane444Unorm3Pack16 = 1000156016,
    r12x4UnormPack16 = 1000156017,
    r12x4g12x4Unorm2Pack16 = 1000156018,
    r12x4g12x4b12x4a12x4Unorm4Pack16 = 1000156019,
    g12x4b12x4g12x4r12x4422Unorm4Pack16 = 1000156020,
    b12x4g12x4r12x4g12x4422Unorm4Pack16 = 1000156021,
    g12x4B12x4R12x43Plane420Unorm3Pack16 = 1000156022,
    g12x4B12x4r12x42Plane420Unorm3Pack16 = 1000156023,
    g12x4B12x4R12x43Plane422Unorm3Pack16 = 1000156024,
    g12x4B12x4r12x42Plane422Unorm3Pack16 = 1000156025,
    g12x4B12x4R12x43Plane444Unorm3Pack16 = 1000156026,
    g16b16g16r16422Unorm = 1000156027,
    b16g16r16g16422Unorm = 1000156028,
    g16B16R163Plane420Unorm = 1000156029,
    g16B16r162Plane420Unorm = 1000156030,
    g16B16R163Plane422Unorm = 1000156031,
    g16B16r162Plane422Unorm = 1000156032,
    g16B16R163Plane444Unorm = 1000156033,
    pvrtc12BppUnormBlockIMG = 1000054000,
    pvrtc14BppUnormBlockIMG = 1000054001,
    pvrtc22BppUnormBlockIMG = 1000054002,
    pvrtc24BppUnormBlockIMG = 1000054003,
    pvrtc12BppSrgbBlockIMG = 1000054004,
    pvrtc14BppSrgbBlockIMG = 1000054005,
    pvrtc22BppSrgbBlockIMG = 1000054006,
    pvrtc24BppSrgbBlockIMG = 1000054007,
    astc4X4SfloatBlockEXT = 1000066000,
    astc5X4SfloatBlockEXT = 1000066001,
    astc5X5SfloatBlockEXT = 1000066002,
    astc6X5SfloatBlockEXT = 1000066003,
    astc6X6SfloatBlockEXT = 1000066004,
    astc8X5SfloatBlockEXT = 1000066005,
    astc8X6SfloatBlockEXT = 1000066006,
    astc8X8SfloatBlockEXT = 1000066007,
    astc10X5SfloatBlockEXT = 1000066008,
    astc10X6SfloatBlockEXT = 1000066009,
    astc10X8SfloatBlockEXT = 1000066010,
    astc10X10SfloatBlockEXT = 1000066011,
    astc12X10SfloatBlockEXT = 1000066012,
    astc12X12SfloatBlockEXT = 1000066013,
    g8B8r82Plane444UnormEXT = 1000330000,
    g10x6B10x6r10x62Plane444Unorm3Pack16EXT = 1000330001,
    g12x4B12x4r12x42Plane444Unorm3Pack16EXT = 1000330002,
    g16B16r162Plane444UnormEXT = 1000330003,
    a4r4g4b4UnormPack16EXT = 1000340000,
    a4b4g4r4UnormPack16EXT = 1000340001,
    _,
    pub const g8b8g8r8422UnormKHR = Format.g8b8g8r8422Unorm;
    pub const b8g8r8g8422UnormKHR = Format.b8g8r8g8422Unorm;
    pub const g8B8R83Plane420UnormKHR = Format.g8B8R83Plane420Unorm;
    pub const g8B8r82Plane420UnormKHR = Format.g8B8r82Plane420Unorm;
    pub const g8B8R83Plane422UnormKHR = Format.g8B8R83Plane422Unorm;
    pub const g8B8r82Plane422UnormKHR = Format.g8B8r82Plane422Unorm;
    pub const g8B8R83Plane444UnormKHR = Format.g8B8R83Plane444Unorm;
    pub const r10x6UnormPack16KHR = Format.r10x6UnormPack16;
    pub const r10x6g10x6Unorm2Pack16KHR = Format.r10x6g10x6Unorm2Pack16;
    pub const r10x6g10x6b10x6a10x6Unorm4Pack16KHR = Format.r10x6g10x6b10x6a10x6Unorm4Pack16;
    pub const g10x6b10x6g10x6r10x6422Unorm4Pack16KHR = Format.g10x6b10x6g10x6r10x6422Unorm4Pack16;
    pub const b10x6g10x6r10x6g10x6422Unorm4Pack16KHR = Format.b10x6g10x6r10x6g10x6422Unorm4Pack16;
    pub const g10x6B10x6R10x63Plane420Unorm3Pack16KHR = Format.g10x6B10x6R10x63Plane420Unorm3Pack16;
    pub const g10x6B10x6r10x62Plane420Unorm3Pack16KHR = Format.g10x6B10x6r10x62Plane420Unorm3Pack16;
    pub const g10x6B10x6R10x63Plane422Unorm3Pack16KHR = Format.g10x6B10x6R10x63Plane422Unorm3Pack16;
    pub const g10x6B10x6r10x62Plane422Unorm3Pack16KHR = Format.g10x6B10x6r10x62Plane422Unorm3Pack16;
    pub const g10x6B10x6R10x63Plane444Unorm3Pack16KHR = Format.g10x6B10x6R10x63Plane444Unorm3Pack16;
    pub const r12x4UnormPack16KHR = Format.r12x4UnormPack16;
    pub const r12x4g12x4Unorm2Pack16KHR = Format.r12x4g12x4Unorm2Pack16;
    pub const r12x4g12x4b12x4a12x4Unorm4Pack16KHR = Format.r12x4g12x4b12x4a12x4Unorm4Pack16;
    pub const g12x4b12x4g12x4r12x4422Unorm4Pack16KHR = Format.g12x4b12x4g12x4r12x4422Unorm4Pack16;
    pub const b12x4g12x4r12x4g12x4422Unorm4Pack16KHR = Format.b12x4g12x4r12x4g12x4422Unorm4Pack16;
    pub const g12x4B12x4R12x43Plane420Unorm3Pack16KHR = Format.g12x4B12x4R12x43Plane420Unorm3Pack16;
    pub const g12x4B12x4r12x42Plane420Unorm3Pack16KHR = Format.g12x4B12x4r12x42Plane420Unorm3Pack16;
    pub const g12x4B12x4R12x43Plane422Unorm3Pack16KHR = Format.g12x4B12x4R12x43Plane422Unorm3Pack16;
    pub const g12x4B12x4r12x42Plane422Unorm3Pack16KHR = Format.g12x4B12x4r12x42Plane422Unorm3Pack16;
    pub const g12x4B12x4R12x43Plane444Unorm3Pack16KHR = Format.g12x4B12x4R12x43Plane444Unorm3Pack16;
    pub const g16b16g16r16422UnormKHR = Format.g16b16g16r16422Unorm;
    pub const b16g16r16g16422UnormKHR = Format.b16g16r16g16422Unorm;
    pub const g16B16R163Plane420UnormKHR = Format.g16B16R163Plane420Unorm;
    pub const g16B16r162Plane420UnormKHR = Format.g16B16r162Plane420Unorm;
    pub const g16B16R163Plane422UnormKHR = Format.g16B16R163Plane422Unorm;
    pub const g16B16r162Plane422UnormKHR = Format.g16B16r162Plane422Unorm;
    pub const g16B16R163Plane444UnormKHR = Format.g16B16R163Plane444Unorm;
};
pub const StructureType = enum(i32) {
    applicationInfo = 0,
    instanceCreateInfo = 1,
    deviceQueueCreateInfo = 2,
    deviceCreateInfo = 3,
    submitInfo = 4,
    memoryAllocateInfo = 5,
    mappedMemoryRange = 6,
    bindSparseInfo = 7,
    fenceCreateInfo = 8,
    semaphoreCreateInfo = 9,
    eventCreateInfo = 10,
    queryPoolCreateInfo = 11,
    bufferCreateInfo = 12,
    bufferViewCreateInfo = 13,
    imageCreateInfo = 14,
    imageViewCreateInfo = 15,
    shaderModuleCreateInfo = 16,
    pipelineCacheCreateInfo = 17,
    pipelineShaderStageCreateInfo = 18,
    pipelineVertexInputStateCreateInfo = 19,
    pipelineInputAssemblyStateCreateInfo = 20,
    pipelineTessellationStateCreateInfo = 21,
    pipelineViewportStateCreateInfo = 22,
    pipelineRasterizationStateCreateInfo = 23,
    pipelineMultisampleStateCreateInfo = 24,
    pipelineDepthStencilStateCreateInfo = 25,
    pipelineColorBlendStateCreateInfo = 26,
    pipelineDynamicStateCreateInfo = 27,
    graphicsPipelineCreateInfo = 28,
    computePipelineCreateInfo = 29,
    pipelineLayoutCreateInfo = 30,
    samplerCreateInfo = 31,
    descriptorSetLayoutCreateInfo = 32,
    descriptorPoolCreateInfo = 33,
    descriptorSetAllocateInfo = 34,
    writeDescriptorSet = 35,
    copyDescriptorSet = 36,
    framebufferCreateInfo = 37,
    renderPassCreateInfo = 38,
    commandPoolCreateInfo = 39,
    commandBufferAllocateInfo = 40,
    commandBufferInheritanceInfo = 41,
    commandBufferBeginInfo = 42,
    renderPassBeginInfo = 43,
    bufferMemoryBarrier = 44,
    imageMemoryBarrier = 45,
    memoryBarrier = 46,
    loaderInstanceCreateInfo = 47,
    loaderDeviceCreateInfo = 48,
    physicalDeviceSubgroupProperties = 1000094000,
    bindBufferMemoryInfo = 1000157000,
    bindImageMemoryInfo = 1000157001,
    physicalDevice16BitStorageFeatures = 1000083000,
    memoryDedicatedRequirements = 1000127000,
    memoryDedicatedAllocateInfo = 1000127001,
    memoryAllocateFlagsInfo = 1000060000,
    deviceGroupRenderPassBeginInfo = 1000060003,
    deviceGroupCommandBufferBeginInfo = 1000060004,
    deviceGroupSubmitInfo = 1000060005,
    deviceGroupBindSparseInfo = 1000060006,
    bindBufferMemoryDeviceGroupInfo = 1000060013,
    bindImageMemoryDeviceGroupInfo = 1000060014,
    physicalDeviceGroupProperties = 1000070000,
    deviceGroupDeviceCreateInfo = 1000070001,
    bufferMemoryRequirementsInfo2 = 1000146000,
    imageMemoryRequirementsInfo2 = 1000146001,
    imageSparseMemoryRequirementsInfo2 = 1000146002,
    memoryRequirements2 = 1000146003,
    sparseImageMemoryRequirements2 = 1000146004,
    physicalDeviceFeatures2 = 1000059000,
    physicalDeviceProperties2 = 1000059001,
    formatProperties2 = 1000059002,
    imageFormatProperties2 = 1000059003,
    physicalDeviceImageFormatInfo2 = 1000059004,
    queueFamilyProperties2 = 1000059005,
    physicalDeviceMemoryProperties2 = 1000059006,
    sparseImageFormatProperties2 = 1000059007,
    physicalDeviceSparseImageFormatInfo2 = 1000059008,
    physicalDevicePointClippingProperties = 1000117000,
    renderPassInputAttachmentAspectCreateInfo = 1000117001,
    imageViewUsageCreateInfo = 1000117002,
    pipelineTessellationDomainOriginStateCreateInfo = 1000117003,
    renderPassMultiviewCreateInfo = 1000053000,
    physicalDeviceMultiviewFeatures = 1000053001,
    physicalDeviceMultiviewProperties = 1000053002,
    physicalDeviceVariablePointersFeatures = 1000120000,
    protectedSubmitInfo = 1000145000,
    physicalDeviceProtectedMemoryFeatures = 1000145001,
    physicalDeviceProtectedMemoryProperties = 1000145002,
    deviceQueueInfo2 = 1000145003,
    samplerYcbcrConversionCreateInfo = 1000156000,
    samplerYcbcrConversionInfo = 1000156001,
    bindImagePlaneMemoryInfo = 1000156002,
    imagePlaneMemoryRequirementsInfo = 1000156003,
    physicalDeviceSamplerYcbcrConversionFeatures = 1000156004,
    samplerYcbcrConversionImageFormatProperties = 1000156005,
    descriptorUpdateTemplateCreateInfo = 1000085000,
    physicalDeviceExternalImageFormatInfo = 1000071000,
    externalImageFormatProperties = 1000071001,
    physicalDeviceExternalBufferInfo = 1000071002,
    externalBufferProperties = 1000071003,
    physicalDeviceIdProperties = 1000071004,
    externalMemoryBufferCreateInfo = 1000072000,
    externalMemoryImageCreateInfo = 1000072001,
    exportMemoryAllocateInfo = 1000072002,
    physicalDeviceExternalFenceInfo = 1000112000,
    externalFenceProperties = 1000112001,
    exportFenceCreateInfo = 1000113000,
    exportSemaphoreCreateInfo = 1000077000,
    physicalDeviceExternalSemaphoreInfo = 1000076000,
    externalSemaphoreProperties = 1000076001,
    physicalDeviceMaintenance3Properties = 1000168000,
    descriptorSetLayoutSupport = 1000168001,
    physicalDeviceShaderDrawParametersFeatures = 1000063000,
    physicalDeviceVulkan11Features = 49,
    physicalDeviceVulkan11Properties = 50,
    physicalDeviceVulkan12Features = 51,
    physicalDeviceVulkan12Properties = 52,
    imageFormatListCreateInfo = 1000147000,
    attachmentDescription2 = 1000109000,
    attachmentReference2 = 1000109001,
    subpassDescription2 = 1000109002,
    subpassDependency2 = 1000109003,
    renderPassCreateInfo2 = 1000109004,
    subpassBeginInfo = 1000109005,
    subpassEndInfo = 1000109006,
    physicalDevice8BitStorageFeatures = 1000177000,
    physicalDeviceDriverProperties = 1000196000,
    physicalDeviceShaderAtomicInt64Features = 1000180000,
    physicalDeviceShaderFloat16Int8Features = 1000082000,
    physicalDeviceFloatControlsProperties = 1000197000,
    descriptorSetLayoutBindingFlagsCreateInfo = 1000161000,
    physicalDeviceDescriptorIndexingFeatures = 1000161001,
    physicalDeviceDescriptorIndexingProperties = 1000161002,
    descriptorSetVariableDescriptorCountAllocateInfo = 1000161003,
    descriptorSetVariableDescriptorCountLayoutSupport = 1000161004,
    physicalDeviceDepthStencilResolveProperties = 1000199000,
    subpassDescriptionDepthStencilResolve = 1000199001,
    physicalDeviceScalarBlockLayoutFeatures = 1000221000,
    imageStencilUsageCreateInfo = 1000246000,
    physicalDeviceSamplerFilterMinmaxProperties = 1000130000,
    samplerReductionModeCreateInfo = 1000130001,
    physicalDeviceVulkanMemoryModelFeatures = 1000211000,
    physicalDeviceImagelessFramebufferFeatures = 1000108000,
    framebufferAttachmentsCreateInfo = 1000108001,
    framebufferAttachmentImageInfo = 1000108002,
    renderPassAttachmentBeginInfo = 1000108003,
    physicalDeviceUniformBufferStandardLayoutFeatures = 1000253000,
    physicalDeviceShaderSubgroupExtendedTypesFeatures = 1000175000,
    physicalDeviceSeparateDepthStencilLayoutsFeatures = 1000241000,
    attachmentReferenceStencilLayout = 1000241001,
    attachmentDescriptionStencilLayout = 1000241002,
    physicalDeviceHostQueryResetFeatures = 1000261000,
    physicalDeviceTimelineSemaphoreFeatures = 1000207000,
    physicalDeviceTimelineSemaphoreProperties = 1000207001,
    semaphoreTypeCreateInfo = 1000207002,
    timelineSemaphoreSubmitInfo = 1000207003,
    semaphoreWaitInfo = 1000207004,
    semaphoreSignalInfo = 1000207005,
    physicalDeviceBufferDeviceAddressFeatures = 1000257000,
    bufferDeviceAddressInfo = 1000244001,
    bufferOpaqueCaptureAddressCreateInfo = 1000257002,
    memoryOpaqueCaptureAddressAllocateInfo = 1000257003,
    deviceMemoryOpaqueCaptureAddressInfo = 1000257004,
    swapchainCreateInfoKHR = 1000001000,
    presentInfoKHR = 1000001001,
    deviceGroupPresentCapabilitiesKHR = 1000060007,
    imageSwapchainCreateInfoKHR = 1000060008,
    bindImageMemorySwapchainInfoKHR = 1000060009,
    acquireNextImageInfoKHR = 1000060010,
    deviceGroupPresentInfoKHR = 1000060011,
    deviceGroupSwapchainCreateInfoKHR = 1000060012,
    displayModeCreateInfoKHR = 1000002000,
    displaySurfaceCreateInfoKHR = 1000002001,
    displayPresentInfoKHR = 1000003000,
    xlibSurfaceCreateInfoKHR = 1000004000,
    xcbSurfaceCreateInfoKHR = 1000005000,
    waylandSurfaceCreateInfoKHR = 1000006000,
    androidSurfaceCreateInfoKHR = 1000008000,
    win32SurfaceCreateInfoKHR = 1000009000,
    debugReportCallbackCreateInfoEXT = 1000011000,
    pipelineRasterizationStateRasterizationOrderAMD = 1000018000,
    debugMarkerObjectNameInfoEXT = 1000022000,
    debugMarkerObjectTagInfoEXT = 1000022001,
    debugMarkerMarkerInfoEXT = 1000022002,
    videoProfileKHR = 1000023000,
    videoCapabilitiesKHR = 1000023001,
    videoPictureResourceKHR = 1000023002,
    videoGetMemoryPropertiesKHR = 1000023003,
    videoBindMemoryKHR = 1000023004,
    videoSessionCreateInfoKHR = 1000023005,
    videoSessionParametersCreateInfoKHR = 1000023006,
    videoSessionParametersUpdateInfoKHR = 1000023007,
    videoBeginCodingInfoKHR = 1000023008,
    videoEndCodingInfoKHR = 1000023009,
    videoCodingControlInfoKHR = 1000023010,
    videoReferenceSlotKHR = 1000023011,
    videoQueueFamilyProperties2KHR = 1000023012,
    videoProfilesKHR = 1000023013,
    physicalDeviceVideoFormatInfoKHR = 1000023014,
    videoFormatPropertiesKHR = 1000023015,
    videoDecodeInfoKHR = 1000024000,
    dedicatedAllocationImageCreateInfoNV = 1000026000,
    dedicatedAllocationBufferCreateInfoNV = 1000026001,
    dedicatedAllocationMemoryAllocateInfoNV = 1000026002,
    physicalDeviceTransformFeedbackFeaturesEXT = 1000028000,
    physicalDeviceTransformFeedbackPropertiesEXT = 1000028001,
    pipelineRasterizationStateStreamCreateInfoEXT = 1000028002,
    cuModuleCreateInfoNVX = 1000029000,
    cuFunctionCreateInfoNVX = 1000029001,
    cuLaunchInfoNVX = 1000029002,
    imageViewHandleInfoNVX = 1000030000,
    imageViewAddressPropertiesNVX = 1000030001,
    videoEncodeH264CapabilitiesEXT = 1000038000,
    videoEncodeH264SessionCreateInfoEXT = 1000038001,
    videoEncodeH264SessionParametersCreateInfoEXT = 1000038002,
    videoEncodeH264SessionParametersAddInfoEXT = 1000038003,
    videoEncodeH264VclFrameInfoEXT = 1000038004,
    videoEncodeH264DpbSlotInfoEXT = 1000038005,
    videoEncodeH264NaluSliceEXT = 1000038006,
    videoEncodeH264EmitPictureParametersEXT = 1000038007,
    videoEncodeH264ProfileEXT = 1000038008,
    videoEncodeH265CapabilitiesEXT = 1000039000,
    videoEncodeH265SessionCreateInfoEXT = 1000039001,
    videoEncodeH265SessionParametersCreateInfoEXT = 1000039002,
    videoEncodeH265SessionParametersAddInfoEXT = 1000039003,
    videoEncodeH265VclFrameInfoEXT = 1000039004,
    videoEncodeH265DpbSlotInfoEXT = 1000039005,
    videoEncodeH265NaluSliceEXT = 1000039006,
    videoEncodeH265EmitPictureParametersEXT = 1000039007,
    videoEncodeH265ProfileEXT = 1000039008,
    videoEncodeH265ReferenceListsEXT = 1000039009,
    videoDecodeH264CapabilitiesEXT = 1000040000,
    videoDecodeH264SessionCreateInfoEXT = 1000040001,
    videoDecodeH264PictureInfoEXT = 1000040002,
    videoDecodeH264MvcEXT = 1000040003,
    videoDecodeH264ProfileEXT = 1000040004,
    videoDecodeH264SessionParametersCreateInfoEXT = 1000040005,
    videoDecodeH264SessionParametersAddInfoEXT = 1000040006,
    videoDecodeH264DpbSlotInfoEXT = 1000040007,
    textureLodGatherFormatPropertiesAMD = 1000041000,
    streamDescriptorSurfaceCreateInfoGGP = 1000049000,
    physicalDeviceCornerSampledImageFeaturesNV = 1000050000,
    externalMemoryImageCreateInfoNV = 1000056000,
    exportMemoryAllocateInfoNV = 1000056001,
    importMemoryWin32HandleInfoNV = 1000057000,
    exportMemoryWin32HandleInfoNV = 1000057001,
    win32KeyedMutexAcquireReleaseInfoNV = 1000058000,
    validationFlagsEXT = 1000061000,
    viSurfaceCreateInfoNN = 1000062000,
    physicalDeviceTextureCompressionAstcHdrFeaturesEXT = 1000066000,
    imageViewAstcDecodeModeEXT = 1000067000,
    physicalDeviceAstcDecodeFeaturesEXT = 1000067001,
    importMemoryWin32HandleInfoKHR = 1000073000,
    exportMemoryWin32HandleInfoKHR = 1000073001,
    memoryWin32HandlePropertiesKHR = 1000073002,
    memoryGetWin32HandleInfoKHR = 1000073003,
    importMemoryFdInfoKHR = 1000074000,
    memoryFdPropertiesKHR = 1000074001,
    memoryGetFdInfoKHR = 1000074002,
    win32KeyedMutexAcquireReleaseInfoKHR = 1000075000,
    importSemaphoreWin32HandleInfoKHR = 1000078000,
    exportSemaphoreWin32HandleInfoKHR = 1000078001,
    d3d12FenceSubmitInfoKHR = 1000078002,
    semaphoreGetWin32HandleInfoKHR = 1000078003,
    importSemaphoreFdInfoKHR = 1000079000,
    semaphoreGetFdInfoKHR = 1000079001,
    physicalDevicePushDescriptorPropertiesKHR = 1000080000,
    commandBufferInheritanceConditionalRenderingInfoEXT = 1000081000,
    physicalDeviceConditionalRenderingFeaturesEXT = 1000081001,
    conditionalRenderingBeginInfoEXT = 1000081002,
    presentRegionsKHR = 1000084000,
    pipelineViewportWScalingStateCreateInfoNV = 1000087000,
    surfaceCapabilities2EXT = 1000090000,
    displayPowerInfoEXT = 1000091000,
    deviceEventInfoEXT = 1000091001,
    displayEventInfoEXT = 1000091002,
    swapchainCounterCreateInfoEXT = 1000091003,
    presentTimesInfoGOOGLE = 1000092000,
    physicalDeviceMultiviewPerViewAttributesPropertiesNVX = 1000097000,
    pipelineViewportSwizzleStateCreateInfoNV = 1000098000,
    physicalDeviceDiscardRectanglePropertiesEXT = 1000099000,
    pipelineDiscardRectangleStateCreateInfoEXT = 1000099001,
    physicalDeviceConservativeRasterizationPropertiesEXT = 1000101000,
    pipelineRasterizationConservativeStateCreateInfoEXT = 1000101001,
    physicalDeviceDepthClipEnableFeaturesEXT = 1000102000,
    pipelineRasterizationDepthClipStateCreateInfoEXT = 1000102001,
    hdrMetadataEXT = 1000105000,
    sharedPresentSurfaceCapabilitiesKHR = 1000111000,
    importFenceWin32HandleInfoKHR = 1000114000,
    exportFenceWin32HandleInfoKHR = 1000114001,
    fenceGetWin32HandleInfoKHR = 1000114002,
    importFenceFdInfoKHR = 1000115000,
    fenceGetFdInfoKHR = 1000115001,
    physicalDevicePerformanceQueryFeaturesKHR = 1000116000,
    physicalDevicePerformanceQueryPropertiesKHR = 1000116001,
    queryPoolPerformanceCreateInfoKHR = 1000116002,
    performanceQuerySubmitInfoKHR = 1000116003,
    acquireProfilingLockInfoKHR = 1000116004,
    performanceCounterKHR = 1000116005,
    performanceCounterDescriptionKHR = 1000116006,
    physicalDeviceSurfaceInfo2KHR = 1000119000,
    surfaceCapabilities2KHR = 1000119001,
    surfaceFormat2KHR = 1000119002,
    displayProperties2KHR = 1000121000,
    displayPlaneProperties2KHR = 1000121001,
    displayModeProperties2KHR = 1000121002,
    displayPlaneInfo2KHR = 1000121003,
    displayPlaneCapabilities2KHR = 1000121004,
    iosSurfaceCreateInfoMVK = 1000122000,
    macosSurfaceCreateInfoMVK = 1000123000,
    debugUtilsObjectNameInfoEXT = 1000128000,
    debugUtilsObjectTagInfoEXT = 1000128001,
    debugUtilsLabelEXT = 1000128002,
    debugUtilsMessengerCallbackDataEXT = 1000128003,
    debugUtilsMessengerCreateInfoEXT = 1000128004,
    androidHardwareBufferUsageANDROID = 1000129000,
    androidHardwareBufferPropertiesANDROID = 1000129001,
    androidHardwareBufferFormatPropertiesANDROID = 1000129002,
    importAndroidHardwareBufferInfoANDROID = 1000129003,
    memoryGetAndroidHardwareBufferInfoANDROID = 1000129004,
    externalFormatANDROID = 1000129005,
    androidHardwareBufferFormatProperties2ANDROID = 1000129006,
    physicalDeviceInlineUniformBlockFeaturesEXT = 1000138000,
    physicalDeviceInlineUniformBlockPropertiesEXT = 1000138001,
    writeDescriptorSetInlineUniformBlockEXT = 1000138002,
    descriptorPoolInlineUniformBlockCreateInfoEXT = 1000138003,
    sampleLocationsInfoEXT = 1000143000,
    renderPassSampleLocationsBeginInfoEXT = 1000143001,
    pipelineSampleLocationsStateCreateInfoEXT = 1000143002,
    physicalDeviceSampleLocationsPropertiesEXT = 1000143003,
    multisamplePropertiesEXT = 1000143004,
    physicalDeviceBlendOperationAdvancedFeaturesEXT = 1000148000,
    physicalDeviceBlendOperationAdvancedPropertiesEXT = 1000148001,
    pipelineColorBlendAdvancedStateCreateInfoEXT = 1000148002,
    pipelineCoverageToColorStateCreateInfoNV = 1000149000,
    writeDescriptorSetAccelerationStructureKHR = 1000150007,
    accelerationStructureBuildGeometryInfoKHR = 1000150000,
    accelerationStructureDeviceAddressInfoKHR = 1000150002,
    accelerationStructureGeometryAabbsDataKHR = 1000150003,
    accelerationStructureGeometryInstancesDataKHR = 1000150004,
    accelerationStructureGeometryTrianglesDataKHR = 1000150005,
    accelerationStructureGeometryKHR = 1000150006,
    accelerationStructureVersionInfoKHR = 1000150009,
    copyAccelerationStructureInfoKHR = 1000150010,
    copyAccelerationStructureToMemoryInfoKHR = 1000150011,
    copyMemoryToAccelerationStructureInfoKHR = 1000150012,
    physicalDeviceAccelerationStructureFeaturesKHR = 1000150013,
    physicalDeviceAccelerationStructurePropertiesKHR = 1000150014,
    accelerationStructureCreateInfoKHR = 1000150017,
    accelerationStructureBuildSizesInfoKHR = 1000150020,
    physicalDeviceRayTracingPipelineFeaturesKHR = 1000347000,
    physicalDeviceRayTracingPipelinePropertiesKHR = 1000347001,
    rayTracingPipelineCreateInfoKHR = 1000150015,
    rayTracingShaderGroupCreateInfoKHR = 1000150016,
    rayTracingPipelineInterfaceCreateInfoKHR = 1000150018,
    physicalDeviceRayQueryFeaturesKHR = 1000348013,
    pipelineCoverageModulationStateCreateInfoNV = 1000152000,
    physicalDeviceShaderSmBuiltinsFeaturesNV = 1000154000,
    physicalDeviceShaderSmBuiltinsPropertiesNV = 1000154001,
    drmFormatModifierPropertiesListEXT = 1000158000,
    physicalDeviceImageDrmFormatModifierInfoEXT = 1000158002,
    imageDrmFormatModifierListCreateInfoEXT = 1000158003,
    imageDrmFormatModifierExplicitCreateInfoEXT = 1000158004,
    imageDrmFormatModifierPropertiesEXT = 1000158005,
    drmFormatModifierPropertiesList2EXT = 1000158006,
    validationCacheCreateInfoEXT = 1000160000,
    shaderModuleValidationCacheCreateInfoEXT = 1000160001,
    physicalDevicePortabilitySubsetFeaturesKHR = 1000163000,
    physicalDevicePortabilitySubsetPropertiesKHR = 1000163001,
    pipelineViewportShadingRateImageStateCreateInfoNV = 1000164000,
    physicalDeviceShadingRateImageFeaturesNV = 1000164001,
    physicalDeviceShadingRateImagePropertiesNV = 1000164002,
    pipelineViewportCoarseSampleOrderStateCreateInfoNV = 1000164005,
    rayTracingPipelineCreateInfoNV = 1000165000,
    accelerationStructureCreateInfoNV = 1000165001,
    geometryNV = 1000165003,
    geometryTrianglesNV = 1000165004,
    geometryAabbNV = 1000165005,
    bindAccelerationStructureMemoryInfoNV = 1000165006,
    writeDescriptorSetAccelerationStructureNV = 1000165007,
    accelerationStructureMemoryRequirementsInfoNV = 1000165008,
    physicalDeviceRayTracingPropertiesNV = 1000165009,
    rayTracingShaderGroupCreateInfoNV = 1000165011,
    accelerationStructureInfoNV = 1000165012,
    physicalDeviceRepresentativeFragmentTestFeaturesNV = 1000166000,
    pipelineRepresentativeFragmentTestStateCreateInfoNV = 1000166001,
    physicalDeviceImageViewImageFormatInfoEXT = 1000170000,
    filterCubicImageViewImageFormatPropertiesEXT = 1000170001,
    deviceQueueGlobalPriorityCreateInfoEXT = 1000174000,
    importMemoryHostPointerInfoEXT = 1000178000,
    memoryHostPointerPropertiesEXT = 1000178001,
    physicalDeviceExternalMemoryHostPropertiesEXT = 1000178002,
    physicalDeviceShaderClockFeaturesKHR = 1000181000,
    pipelineCompilerControlCreateInfoAMD = 1000183000,
    calibratedTimestampInfoEXT = 1000184000,
    physicalDeviceShaderCorePropertiesAMD = 1000185000,
    videoDecodeH265CapabilitiesEXT = 1000187000,
    videoDecodeH265SessionCreateInfoEXT = 1000187001,
    videoDecodeH265SessionParametersCreateInfoEXT = 1000187002,
    videoDecodeH265SessionParametersAddInfoEXT = 1000187003,
    videoDecodeH265ProfileEXT = 1000187004,
    videoDecodeH265PictureInfoEXT = 1000187005,
    videoDecodeH265DpbSlotInfoEXT = 1000187006,
    deviceMemoryOverallocationCreateInfoAMD = 1000189000,
    physicalDeviceVertexAttributeDivisorPropertiesEXT = 1000190000,
    pipelineVertexInputDivisorStateCreateInfoEXT = 1000190001,
    physicalDeviceVertexAttributeDivisorFeaturesEXT = 1000190002,
    presentFrameTokenGGP = 1000191000,
    pipelineCreationFeedbackCreateInfoEXT = 1000192000,
    physicalDeviceComputeShaderDerivativesFeaturesNV = 1000201000,
    physicalDeviceMeshShaderFeaturesNV = 1000202000,
    physicalDeviceMeshShaderPropertiesNV = 1000202001,
    physicalDeviceFragmentShaderBarycentricFeaturesNV = 1000203000,
    physicalDeviceShaderImageFootprintFeaturesNV = 1000204000,
    pipelineViewportExclusiveScissorStateCreateInfoNV = 1000205000,
    physicalDeviceExclusiveScissorFeaturesNV = 1000205002,
    checkpointDataNV = 1000206000,
    queueFamilyCheckpointPropertiesNV = 1000206001,
    physicalDeviceShaderIntegerFunctions2FeaturesINTEL = 1000209000,
    queryPoolPerformanceQueryCreateInfoINTEL = 1000210000,
    initializePerformanceApiInfoINTEL = 1000210001,
    performanceMarkerInfoINTEL = 1000210002,
    performanceStreamMarkerInfoINTEL = 1000210003,
    performanceOverrideInfoINTEL = 1000210004,
    performanceConfigurationAcquireInfoINTEL = 1000210005,
    physicalDevicePciBusInfoPropertiesEXT = 1000212000,
    displayNativeHdrSurfaceCapabilitiesAMD = 1000213000,
    swapchainDisplayNativeHdrCreateInfoAMD = 1000213001,
    imagepipeSurfaceCreateInfoFUCHSIA = 1000214000,
    physicalDeviceShaderTerminateInvocationFeaturesKHR = 1000215000,
    metalSurfaceCreateInfoEXT = 1000217000,
    physicalDeviceFragmentDensityMapFeaturesEXT = 1000218000,
    physicalDeviceFragmentDensityMapPropertiesEXT = 1000218001,
    renderPassFragmentDensityMapCreateInfoEXT = 1000218002,
    physicalDeviceSubgroupSizeControlPropertiesEXT = 1000225000,
    pipelineShaderStageRequiredSubgroupSizeCreateInfoEXT = 1000225001,
    physicalDeviceSubgroupSizeControlFeaturesEXT = 1000225002,
    fragmentShadingRateAttachmentInfoKHR = 1000226000,
    pipelineFragmentShadingRateStateCreateInfoKHR = 1000226001,
    physicalDeviceFragmentShadingRatePropertiesKHR = 1000226002,
    physicalDeviceFragmentShadingRateFeaturesKHR = 1000226003,
    physicalDeviceFragmentShadingRateKHR = 1000226004,
    physicalDeviceShaderCoreProperties2AMD = 1000227000,
    physicalDeviceCoherentMemoryFeaturesAMD = 1000229000,
    physicalDeviceShaderImageAtomicInt64FeaturesEXT = 1000234000,
    physicalDeviceMemoryBudgetPropertiesEXT = 1000237000,
    physicalDeviceMemoryPriorityFeaturesEXT = 1000238000,
    memoryPriorityAllocateInfoEXT = 1000238001,
    surfaceProtectedCapabilitiesKHR = 1000239000,
    physicalDeviceDedicatedAllocationImageAliasingFeaturesNV = 1000240000,
    physicalDeviceBufferDeviceAddressFeaturesEXT = 1000244000,
    bufferDeviceAddressCreateInfoEXT = 1000244002,
    physicalDeviceToolPropertiesEXT = 1000245000,
    validationFeaturesEXT = 1000247000,
    physicalDevicePresentWaitFeaturesKHR = 1000248000,
    physicalDeviceCooperativeMatrixFeaturesNV = 1000249000,
    cooperativeMatrixPropertiesNV = 1000249001,
    physicalDeviceCooperativeMatrixPropertiesNV = 1000249002,
    physicalDeviceCoverageReductionModeFeaturesNV = 1000250000,
    pipelineCoverageReductionStateCreateInfoNV = 1000250001,
    framebufferMixedSamplesCombinationNV = 1000250002,
    physicalDeviceFragmentShaderInterlockFeaturesEXT = 1000251000,
    physicalDeviceYcbcrImageArraysFeaturesEXT = 1000252000,
    physicalDeviceProvokingVertexFeaturesEXT = 1000254000,
    pipelineRasterizationProvokingVertexStateCreateInfoEXT = 1000254001,
    physicalDeviceProvokingVertexPropertiesEXT = 1000254002,
    surfaceFullScreenExclusiveInfoEXT = 1000255000,
    surfaceCapabilitiesFullScreenExclusiveEXT = 1000255002,
    surfaceFullScreenExclusiveWin32InfoEXT = 1000255001,
    headlessSurfaceCreateInfoEXT = 1000256000,
    physicalDeviceLineRasterizationFeaturesEXT = 1000259000,
    pipelineRasterizationLineStateCreateInfoEXT = 1000259001,
    physicalDeviceLineRasterizationPropertiesEXT = 1000259002,
    physicalDeviceShaderAtomicFloatFeaturesEXT = 1000260000,
    physicalDeviceIndexTypeUint8FeaturesEXT = 1000265000,
    physicalDeviceExtendedDynamicStateFeaturesEXT = 1000267000,
    physicalDevicePipelineExecutablePropertiesFeaturesKHR = 1000269000,
    pipelineInfoKHR = 1000269001,
    pipelineExecutablePropertiesKHR = 1000269002,
    pipelineExecutableInfoKHR = 1000269003,
    pipelineExecutableStatisticKHR = 1000269004,
    pipelineExecutableInternalRepresentationKHR = 1000269005,
    physicalDeviceShaderAtomicFloat2FeaturesEXT = 1000273000,
    physicalDeviceShaderDemoteToHelperInvocationFeaturesEXT = 1000276000,
    physicalDeviceDeviceGeneratedCommandsPropertiesNV = 1000277000,
    graphicsShaderGroupCreateInfoNV = 1000277001,
    graphicsPipelineShaderGroupsCreateInfoNV = 1000277002,
    indirectCommandsLayoutTokenNV = 1000277003,
    indirectCommandsLayoutCreateInfoNV = 1000277004,
    generatedCommandsInfoNV = 1000277005,
    generatedCommandsMemoryRequirementsInfoNV = 1000277006,
    physicalDeviceDeviceGeneratedCommandsFeaturesNV = 1000277007,
    physicalDeviceInheritedViewportScissorFeaturesNV = 1000278000,
    commandBufferInheritanceViewportScissorInfoNV = 1000278001,
    physicalDeviceShaderIntegerDotProductFeaturesKHR = 1000280000,
    physicalDeviceShaderIntegerDotProductPropertiesKHR = 1000280001,
    physicalDeviceTexelBufferAlignmentFeaturesEXT = 1000281000,
    physicalDeviceTexelBufferAlignmentPropertiesEXT = 1000281001,
    commandBufferInheritanceRenderPassTransformInfoQCOM = 1000282000,
    renderPassTransformBeginInfoQCOM = 1000282001,
    physicalDeviceDeviceMemoryReportFeaturesEXT = 1000284000,
    deviceDeviceMemoryReportCreateInfoEXT = 1000284001,
    deviceMemoryReportCallbackDataEXT = 1000284002,
    physicalDeviceRobustness2FeaturesEXT = 1000286000,
    physicalDeviceRobustness2PropertiesEXT = 1000286001,
    samplerCustomBorderColorCreateInfoEXT = 1000287000,
    physicalDeviceCustomBorderColorPropertiesEXT = 1000287001,
    physicalDeviceCustomBorderColorFeaturesEXT = 1000287002,
    pipelineLibraryCreateInfoKHR = 1000290000,
    presentIdKHR = 1000294000,
    physicalDevicePresentIdFeaturesKHR = 1000294001,
    physicalDevicePrivateDataFeaturesEXT = 1000295000,
    devicePrivateDataCreateInfoEXT = 1000295001,
    privateDataSlotCreateInfoEXT = 1000295002,
    physicalDevicePipelineCreationCacheControlFeaturesEXT = 1000297000,
    videoEncodeInfoKHR = 1000299000,
    videoEncodeRateControlInfoKHR = 1000299001,
    physicalDeviceDiagnosticsConfigFeaturesNV = 1000300000,
    deviceDiagnosticsConfigCreateInfoNV = 1000300001,
    memoryBarrier2KHR = 1000314000,
    bufferMemoryBarrier2KHR = 1000314001,
    imageMemoryBarrier2KHR = 1000314002,
    dependencyInfoKHR = 1000314003,
    submitInfo2KHR = 1000314004,
    semaphoreSubmitInfoKHR = 1000314005,
    commandBufferSubmitInfoKHR = 1000314006,
    physicalDeviceSynchronization2FeaturesKHR = 1000314007,
    queueFamilyCheckpointProperties2NV = 1000314008,
    checkpointData2NV = 1000314009,
    physicalDeviceShaderSubgroupUniformControlFlowFeaturesKHR = 1000323000,
    physicalDeviceZeroInitializeWorkgroupMemoryFeaturesKHR = 1000325000,
    physicalDeviceFragmentShadingRateEnumsPropertiesNV = 1000326000,
    physicalDeviceFragmentShadingRateEnumsFeaturesNV = 1000326001,
    pipelineFragmentShadingRateEnumStateCreateInfoNV = 1000326002,
    accelerationStructureGeometryMotionTrianglesDataNV = 1000327000,
    physicalDeviceRayTracingMotionBlurFeaturesNV = 1000327001,
    accelerationStructureMotionInfoNV = 1000327002,
    physicalDeviceYcbcr2Plane444FormatsFeaturesEXT = 1000330000,
    physicalDeviceFragmentDensityMap2FeaturesEXT = 1000332000,
    physicalDeviceFragmentDensityMap2PropertiesEXT = 1000332001,
    copyCommandTransformInfoQCOM = 1000333000,
    physicalDeviceImageRobustnessFeaturesEXT = 1000335000,
    physicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR = 1000336000,
    copyBufferInfo2KHR = 1000337000,
    copyImageInfo2KHR = 1000337001,
    copyBufferToImageInfo2KHR = 1000337002,
    copyImageToBufferInfo2KHR = 1000337003,
    blitImageInfo2KHR = 1000337004,
    resolveImageInfo2KHR = 1000337005,
    bufferCopy2KHR = 1000337006,
    imageCopy2KHR = 1000337007,
    imageBlit2KHR = 1000337008,
    bufferImageCopy2KHR = 1000337009,
    imageResolve2KHR = 1000337010,
    physicalDevice4444FormatsFeaturesEXT = 1000340000,
    physicalDeviceRgba10x6FormatsFeaturesEXT = 1000344000,
    directfbSurfaceCreateInfoEXT = 1000346000,
    physicalDeviceMutableDescriptorTypeFeaturesVALVE = 1000351000,
    mutableDescriptorTypeCreateInfoVALVE = 1000351002,
    physicalDeviceVertexInputDynamicStateFeaturesEXT = 1000352000,
    vertexInputBindingDescription2EXT = 1000352001,
    vertexInputAttributeDescription2EXT = 1000352002,
    physicalDeviceDrmPropertiesEXT = 1000353000,
    physicalDevicePrimitiveTopologyListRestartFeaturesEXT = 1000356000,
    formatProperties3KHR = 1000360000,
    importMemoryZirconHandleInfoFUCHSIA = 1000364000,
    memoryZirconHandlePropertiesFUCHSIA = 1000364001,
    memoryGetZirconHandleInfoFUCHSIA = 1000364002,
    importSemaphoreZirconHandleInfoFUCHSIA = 1000365000,
    semaphoreGetZirconHandleInfoFUCHSIA = 1000365001,
    bufferCollectionCreateInfoFUCHSIA = 1000366000,
    importMemoryBufferCollectionFUCHSIA = 1000366001,
    bufferCollectionImageCreateInfoFUCHSIA = 1000366002,
    bufferCollectionPropertiesFUCHSIA = 1000366003,
    bufferConstraintsInfoFUCHSIA = 1000366004,
    bufferCollectionBufferCreateInfoFUCHSIA = 1000366005,
    imageConstraintsInfoFUCHSIA = 1000366006,
    imageFormatConstraintsInfoFUCHSIA = 1000366007,
    sysmemColorSpaceFUCHSIA = 1000366008,
    bufferCollectionConstraintsInfoFUCHSIA = 1000366009,
    subpassShadingPipelineCreateInfoHUAWEI = 1000369000,
    physicalDeviceSubpassShadingFeaturesHUAWEI = 1000369001,
    physicalDeviceSubpassShadingPropertiesHUAWEI = 1000369002,
    physicalDeviceInvocationMaskFeaturesHUAWEI = 1000370000,
    memoryGetRemoteAddressInfoNV = 1000371000,
    physicalDeviceExternalMemoryRdmaFeaturesNV = 1000371001,
    physicalDeviceExtendedDynamicState2FeaturesEXT = 1000377000,
    screenSurfaceCreateInfoQNX = 1000378000,
    physicalDeviceColorWriteEnableFeaturesEXT = 1000381000,
    pipelineColorWriteCreateInfoEXT = 1000381001,
    physicalDeviceGlobalPriorityQueryFeaturesEXT = 1000388000,
    queueFamilyGlobalPriorityPropertiesEXT = 1000388001,
    physicalDeviceMultiDrawFeaturesEXT = 1000392000,
    physicalDeviceMultiDrawPropertiesEXT = 1000392001,
    physicalDeviceBorderColorSwizzleFeaturesEXT = 1000411000,
    samplerBorderColorComponentMappingCreateInfoEXT = 1000411001,
    physicalDevicePageableDeviceLocalMemoryFeaturesEXT = 1000412000,
    physicalDeviceMaintenance4FeaturesKHR = 1000413000,
    physicalDeviceMaintenance4PropertiesKHR = 1000413001,
    deviceBufferMemoryRequirementsKHR = 1000413002,
    deviceImageMemoryRequirementsKHR = 1000413003,
    _,
    pub const physicalDeviceVariablePointerFeatures = StructureType.physicalDeviceVariablePointersFeatures;
    pub const physicalDeviceShaderDrawParameterFeatures = StructureType.physicalDeviceShaderDrawParametersFeatures;
    pub const renderPassMultiviewCreateInfoKHR = StructureType.renderPassMultiviewCreateInfo;
    pub const physicalDeviceMultiviewFeaturesKHR = StructureType.physicalDeviceMultiviewFeatures;
    pub const physicalDeviceMultiviewPropertiesKHR = StructureType.physicalDeviceMultiviewProperties;
    pub const physicalDeviceFeatures2KHR = StructureType.physicalDeviceFeatures2;
    pub const physicalDeviceProperties2KHR = StructureType.physicalDeviceProperties2;
    pub const formatProperties2KHR = StructureType.formatProperties2;
    pub const imageFormatProperties2KHR = StructureType.imageFormatProperties2;
    pub const physicalDeviceImageFormatInfo2KHR = StructureType.physicalDeviceImageFormatInfo2;
    pub const queueFamilyProperties2KHR = StructureType.queueFamilyProperties2;
    pub const physicalDeviceMemoryProperties2KHR = StructureType.physicalDeviceMemoryProperties2;
    pub const sparseImageFormatProperties2KHR = StructureType.sparseImageFormatProperties2;
    pub const physicalDeviceSparseImageFormatInfo2KHR = StructureType.physicalDeviceSparseImageFormatInfo2;
    pub const memoryAllocateFlagsInfoKHR = StructureType.memoryAllocateFlagsInfo;
    pub const deviceGroupRenderPassBeginInfoKHR = StructureType.deviceGroupRenderPassBeginInfo;
    pub const deviceGroupCommandBufferBeginInfoKHR = StructureType.deviceGroupCommandBufferBeginInfo;
    pub const deviceGroupSubmitInfoKHR = StructureType.deviceGroupSubmitInfo;
    pub const deviceGroupBindSparseInfoKHR = StructureType.deviceGroupBindSparseInfo;
    pub const bindBufferMemoryDeviceGroupInfoKHR = StructureType.bindBufferMemoryDeviceGroupInfo;
    pub const bindImageMemoryDeviceGroupInfoKHR = StructureType.bindImageMemoryDeviceGroupInfo;
    pub const physicalDeviceGroupPropertiesKHR = StructureType.physicalDeviceGroupProperties;
    pub const deviceGroupDeviceCreateInfoKHR = StructureType.deviceGroupDeviceCreateInfo;
    pub const physicalDeviceExternalImageFormatInfoKHR = StructureType.physicalDeviceExternalImageFormatInfo;
    pub const externalImageFormatPropertiesKHR = StructureType.externalImageFormatProperties;
    pub const physicalDeviceExternalBufferInfoKHR = StructureType.physicalDeviceExternalBufferInfo;
    pub const externalBufferPropertiesKHR = StructureType.externalBufferProperties;
    pub const physicalDeviceIdPropertiesKHR = StructureType.physicalDeviceIdProperties;
    pub const externalMemoryBufferCreateInfoKHR = StructureType.externalMemoryBufferCreateInfo;
    pub const externalMemoryImageCreateInfoKHR = StructureType.externalMemoryImageCreateInfo;
    pub const exportMemoryAllocateInfoKHR = StructureType.exportMemoryAllocateInfo;
    pub const physicalDeviceExternalSemaphoreInfoKHR = StructureType.physicalDeviceExternalSemaphoreInfo;
    pub const externalSemaphorePropertiesKHR = StructureType.externalSemaphoreProperties;
    pub const exportSemaphoreCreateInfoKHR = StructureType.exportSemaphoreCreateInfo;
    pub const physicalDeviceShaderFloat16Int8FeaturesKHR = StructureType.physicalDeviceShaderFloat16Int8Features;
    pub const physicalDeviceFloat16Int8FeaturesKHR = StructureType.physicalDeviceShaderFloat16Int8Features;
    pub const physicalDevice16BitStorageFeaturesKHR = StructureType.physicalDevice16BitStorageFeatures;
    pub const descriptorUpdateTemplateCreateInfoKHR = StructureType.descriptorUpdateTemplateCreateInfo;
    pub const physicalDeviceImagelessFramebufferFeaturesKHR = StructureType.physicalDeviceImagelessFramebufferFeatures;
    pub const framebufferAttachmentsCreateInfoKHR = StructureType.framebufferAttachmentsCreateInfo;
    pub const framebufferAttachmentImageInfoKHR = StructureType.framebufferAttachmentImageInfo;
    pub const renderPassAttachmentBeginInfoKHR = StructureType.renderPassAttachmentBeginInfo;
    pub const attachmentDescription2KHR = StructureType.attachmentDescription2;
    pub const attachmentReference2KHR = StructureType.attachmentReference2;
    pub const subpassDescription2KHR = StructureType.subpassDescription2;
    pub const subpassDependency2KHR = StructureType.subpassDependency2;
    pub const renderPassCreateInfo2KHR = StructureType.renderPassCreateInfo2;
    pub const subpassBeginInfoKHR = StructureType.subpassBeginInfo;
    pub const subpassEndInfoKHR = StructureType.subpassEndInfo;
    pub const physicalDeviceExternalFenceInfoKHR = StructureType.physicalDeviceExternalFenceInfo;
    pub const externalFencePropertiesKHR = StructureType.externalFenceProperties;
    pub const exportFenceCreateInfoKHR = StructureType.exportFenceCreateInfo;
    pub const physicalDevicePointClippingPropertiesKHR = StructureType.physicalDevicePointClippingProperties;
    pub const renderPassInputAttachmentAspectCreateInfoKHR = StructureType.renderPassInputAttachmentAspectCreateInfo;
    pub const imageViewUsageCreateInfoKHR = StructureType.imageViewUsageCreateInfo;
    pub const pipelineTessellationDomainOriginStateCreateInfoKHR = StructureType.pipelineTessellationDomainOriginStateCreateInfo;
    pub const physicalDeviceVariablePointersFeaturesKHR = StructureType.physicalDeviceVariablePointersFeatures;
    pub const physicalDeviceVariablePointerFeaturesKHR = StructureType.physicalDeviceVariablePointersFeaturesKHR;
    pub const memoryDedicatedRequirementsKHR = StructureType.memoryDedicatedRequirements;
    pub const memoryDedicatedAllocateInfoKHR = StructureType.memoryDedicatedAllocateInfo;
    pub const physicalDeviceSamplerFilterMinmaxPropertiesEXT = StructureType.physicalDeviceSamplerFilterMinmaxProperties;
    pub const samplerReductionModeCreateInfoEXT = StructureType.samplerReductionModeCreateInfo;
    pub const bufferMemoryRequirementsInfo2KHR = StructureType.bufferMemoryRequirementsInfo2;
    pub const imageMemoryRequirementsInfo2KHR = StructureType.imageMemoryRequirementsInfo2;
    pub const imageSparseMemoryRequirementsInfo2KHR = StructureType.imageSparseMemoryRequirementsInfo2;
    pub const memoryRequirements2KHR = StructureType.memoryRequirements2;
    pub const sparseImageMemoryRequirements2KHR = StructureType.sparseImageMemoryRequirements2;
    pub const imageFormatListCreateInfoKHR = StructureType.imageFormatListCreateInfo;
    pub const samplerYcbcrConversionCreateInfoKHR = StructureType.samplerYcbcrConversionCreateInfo;
    pub const samplerYcbcrConversionInfoKHR = StructureType.samplerYcbcrConversionInfo;
    pub const bindImagePlaneMemoryInfoKHR = StructureType.bindImagePlaneMemoryInfo;
    pub const imagePlaneMemoryRequirementsInfoKHR = StructureType.imagePlaneMemoryRequirementsInfo;
    pub const physicalDeviceSamplerYcbcrConversionFeaturesKHR = StructureType.physicalDeviceSamplerYcbcrConversionFeatures;
    pub const samplerYcbcrConversionImageFormatPropertiesKHR = StructureType.samplerYcbcrConversionImageFormatProperties;
    pub const bindBufferMemoryInfoKHR = StructureType.bindBufferMemoryInfo;
    pub const bindImageMemoryInfoKHR = StructureType.bindImageMemoryInfo;
    pub const descriptorSetLayoutBindingFlagsCreateInfoEXT = StructureType.descriptorSetLayoutBindingFlagsCreateInfo;
    pub const physicalDeviceDescriptorIndexingFeaturesEXT = StructureType.physicalDeviceDescriptorIndexingFeatures;
    pub const physicalDeviceDescriptorIndexingPropertiesEXT = StructureType.physicalDeviceDescriptorIndexingProperties;
    pub const descriptorSetVariableDescriptorCountAllocateInfoEXT = StructureType.descriptorSetVariableDescriptorCountAllocateInfo;
    pub const descriptorSetVariableDescriptorCountLayoutSupportEXT = StructureType.descriptorSetVariableDescriptorCountLayoutSupport;
    pub const physicalDeviceMaintenance3PropertiesKHR = StructureType.physicalDeviceMaintenance3Properties;
    pub const descriptorSetLayoutSupportKHR = StructureType.descriptorSetLayoutSupport;
    pub const physicalDeviceShaderSubgroupExtendedTypesFeaturesKHR = StructureType.physicalDeviceShaderSubgroupExtendedTypesFeatures;
    pub const physicalDevice8BitStorageFeaturesKHR = StructureType.physicalDevice8BitStorageFeatures;
    pub const physicalDeviceShaderAtomicInt64FeaturesKHR = StructureType.physicalDeviceShaderAtomicInt64Features;
    pub const physicalDeviceDriverPropertiesKHR = StructureType.physicalDeviceDriverProperties;
    pub const physicalDeviceFloatControlsPropertiesKHR = StructureType.physicalDeviceFloatControlsProperties;
    pub const physicalDeviceDepthStencilResolvePropertiesKHR = StructureType.physicalDeviceDepthStencilResolveProperties;
    pub const subpassDescriptionDepthStencilResolveKHR = StructureType.subpassDescriptionDepthStencilResolve;
    pub const physicalDeviceTimelineSemaphoreFeaturesKHR = StructureType.physicalDeviceTimelineSemaphoreFeatures;
    pub const physicalDeviceTimelineSemaphorePropertiesKHR = StructureType.physicalDeviceTimelineSemaphoreProperties;
    pub const semaphoreTypeCreateInfoKHR = StructureType.semaphoreTypeCreateInfo;
    pub const timelineSemaphoreSubmitInfoKHR = StructureType.timelineSemaphoreSubmitInfo;
    pub const semaphoreWaitInfoKHR = StructureType.semaphoreWaitInfo;
    pub const semaphoreSignalInfoKHR = StructureType.semaphoreSignalInfo;
    pub const queryPoolCreateInfoINTEL = StructureType.queryPoolPerformanceQueryCreateInfoINTEL;
    pub const physicalDeviceVulkanMemoryModelFeaturesKHR = StructureType.physicalDeviceVulkanMemoryModelFeatures;
    pub const physicalDeviceScalarBlockLayoutFeaturesEXT = StructureType.physicalDeviceScalarBlockLayoutFeatures;
    pub const physicalDeviceSeparateDepthStencilLayoutsFeaturesKHR = StructureType.physicalDeviceSeparateDepthStencilLayoutsFeatures;
    pub const attachmentReferenceStencilLayoutKHR = StructureType.attachmentReferenceStencilLayout;
    pub const attachmentDescriptionStencilLayoutKHR = StructureType.attachmentDescriptionStencilLayout;
    pub const physicalDeviceBufferAddressFeaturesEXT = StructureType.physicalDeviceBufferDeviceAddressFeaturesEXT;
    pub const bufferDeviceAddressInfoEXT = StructureType.bufferDeviceAddressInfo;
    pub const imageStencilUsageCreateInfoEXT = StructureType.imageStencilUsageCreateInfo;
    pub const physicalDeviceUniformBufferStandardLayoutFeaturesKHR = StructureType.physicalDeviceUniformBufferStandardLayoutFeatures;
    pub const physicalDeviceBufferDeviceAddressFeaturesKHR = StructureType.physicalDeviceBufferDeviceAddressFeatures;
    pub const bufferDeviceAddressInfoKHR = StructureType.bufferDeviceAddressInfo;
    pub const bufferOpaqueCaptureAddressCreateInfoKHR = StructureType.bufferOpaqueCaptureAddressCreateInfo;
    pub const memoryOpaqueCaptureAddressAllocateInfoKHR = StructureType.memoryOpaqueCaptureAddressAllocateInfo;
    pub const deviceMemoryOpaqueCaptureAddressInfoKHR = StructureType.deviceMemoryOpaqueCaptureAddressInfo;
    pub const physicalDeviceHostQueryResetFeaturesEXT = StructureType.physicalDeviceHostQueryResetFeatures;
};
pub const SubpassContents = enum(i32) {
    @"inline" = 0,
    secondaryCommandBuffers = 1,
    _,
};
pub const Result = enum(i32) {
    success = 0,
    notReady = 1,
    timeout = 2,
    eventSet = 3,
    eventReset = 4,
    incomplete = 5,
    errorOutOfHostMemory = -1,
    errorOutOfDeviceMemory = -2,
    errorInitializationFailed = -3,
    errorDeviceLost = -4,
    errorMemoryMapFailed = -5,
    errorLayerNotPresent = -6,
    errorExtensionNotPresent = -7,
    errorFeatureNotPresent = -8,
    errorIncompatibleDriver = -9,
    errorTooManyObjects = -10,
    errorFormatNotSupported = -11,
    errorFragmentedPool = -12,
    errorUnknown = -13,
    errorOutOfPoolMemory = -1000069000,
    errorInvalidExternalHandle = -1000072003,
    errorFragmentation = -1000161000,
    errorInvalidOpaqueCaptureAddress = -1000257000,
    errorSurfaceLostKHR = -1000000000,
    errorNativeWindowInUseKHR = -1000000001,
    suboptimalKHR = 1000001003,
    errorOutOfDateKHR = -1000001004,
    errorIncompatibleDisplayKHR = -1000003001,
    errorValidationFailedEXT = -1000011001,
    errorInvalidShaderNV = -1000012000,
    errorInvalidDrmFormatModifierPlaneLayoutEXT = -1000158000,
    errorNotPermittedEXT = -1000174001,
    errorFullScreenExclusiveModeLostEXT = -1000255000,
    threadIdleKHR = 1000268000,
    threadDoneKHR = 1000268001,
    operationDeferredKHR = 1000268002,
    operationNotDeferredKHR = 1000268003,
    pipelineCompileRequiredEXT = 1000297000,
    _,
    pub const errorOutOfPoolMemoryKHR = Result.errorOutOfPoolMemory;
    pub const errorInvalidExternalHandleKHR = Result.errorInvalidExternalHandle;
    pub const errorFragmentationEXT = Result.errorFragmentation;
    pub const errorInvalidDeviceAddressEXT = Result.errorInvalidOpaqueCaptureAddress;
    pub const errorInvalidOpaqueCaptureAddressKHR = Result.errorInvalidOpaqueCaptureAddress;
    pub const errorPipelineCompileRequiredEXT = Result.pipelineCompileRequiredEXT;
};
pub const DynamicState = enum(i32) {
    viewport = 0,
    scissor = 1,
    lineWidth = 2,
    depthBias = 3,
    blendConstants = 4,
    depthBounds = 5,
    stencilCompareMask = 6,
    stencilWriteMask = 7,
    stencilReference = 8,
    viewportWScalingNV = 1000087000,
    discardRectangleEXT = 1000099000,
    sampleLocationsEXT = 1000143000,
    rayTracingPipelineStackSizeKHR = 1000347000,
    viewportShadingRatePaletteNV = 1000164004,
    viewportCoarseSampleOrderNV = 1000164006,
    exclusiveScissorNV = 1000205001,
    fragmentShadingRateKHR = 1000226000,
    lineStippleEXT = 1000259000,
    cullModeEXT = 1000267000,
    frontFaceEXT = 1000267001,
    primitiveTopologyEXT = 1000267002,
    viewportWithCountEXT = 1000267003,
    scissorWithCountEXT = 1000267004,
    vertexInputBindingStrideEXT = 1000267005,
    depthTestEnableEXT = 1000267006,
    depthWriteEnableEXT = 1000267007,
    depthCompareOpEXT = 1000267008,
    depthBoundsTestEnableEXT = 1000267009,
    stencilTestEnableEXT = 1000267010,
    stencilOpEXT = 1000267011,
    vertexInputEXT = 1000352000,
    patchControlPointsEXT = 1000377000,
    rasterizerDiscardEnableEXT = 1000377001,
    depthBiasEnableEXT = 1000377002,
    logicOpEXT = 1000377003,
    primitiveRestartEnableEXT = 1000377004,
    colorWriteEnableEXT = 1000381000,
    _,
};
pub const DescriptorUpdateTemplateType = enum(i32) {
    descriptorSet = 0,
    pushDescriptorsKHR = 1,
    _,
    pub const descriptorSetKHR = DescriptorUpdateTemplateType.descriptorSet;
};
pub const ObjectType = enum(i32) {
    unknown = 0,
    instance = 1,
    physicalDevice = 2,
    device = 3,
    queue = 4,
    semaphore = 5,
    commandBuffer = 6,
    fence = 7,
    deviceMemory = 8,
    buffer = 9,
    image = 10,
    event = 11,
    queryPool = 12,
    bufferView = 13,
    imageView = 14,
    shaderModule = 15,
    pipelineCache = 16,
    pipelineLayout = 17,
    renderPass = 18,
    pipeline = 19,
    descriptorSetLayout = 20,
    sampler = 21,
    descriptorPool = 22,
    descriptorSet = 23,
    framebuffer = 24,
    commandPool = 25,
    samplerYcbcrConversion = 1000156000,
    descriptorUpdateTemplate = 1000085000,
    surfaceKHR = 1000000000,
    swapchainKHR = 1000001000,
    displayKHR = 1000002000,
    displayModeKHR = 1000002001,
    debugReportCallbackEXT = 1000011000,
    videoSessionKHR = 1000023000,
    videoSessionParametersKHR = 1000023001,
    cuModuleNVX = 1000029000,
    cuFunctionNVX = 1000029001,
    debugUtilsMessengerEXT = 1000128000,
    accelerationStructureKHR = 1000150000,
    validationCacheEXT = 1000160000,
    accelerationStructureNV = 1000165000,
    performanceConfigurationINTEL = 1000210000,
    deferredOperationKHR = 1000268000,
    indirectCommandsLayoutNV = 1000277000,
    privateDataSlotEXT = 1000295000,
    bufferCollectionFUCHSIA = 1000366000,
    _,
    pub const descriptorUpdateTemplateKHR = ObjectType.descriptorUpdateTemplate;
    pub const samplerYcbcrConversionKHR = ObjectType.samplerYcbcrConversion;
};
pub const QueueFlags = packed struct {
    graphicsBit: bool align(@alignOf(Flags)) = false,
    computeBit: bool = false,
    transferBit: bool = false,
    sparseBindingBit: bool = false,
    protectedBit: bool = false,
    videoDecodeBitKHR: bool = false,
    videoEncodeBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(QueueFlags, Flags);
};
pub const CullModeFlags = packed struct {
    frontBit: bool align(@alignOf(Flags)) = false,
    backBit: bool = false,
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
    pub usingnamespace FlagsMixin(CullModeFlags, Flags);
};
pub const RenderPassCreateFlags = packed struct {
    _reserved_bit_0: bool align(@alignOf(Flags)) = false,
    transformBitQCOM: bool = false,
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
    pub usingnamespace FlagsMixin(RenderPassCreateFlags, Flags);
};
pub const DeviceQueueCreateFlags = packed struct {
    protectedBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(DeviceQueueCreateFlags, Flags);
};
pub const MemoryPropertyFlags = packed struct {
    deviceLocalBit: bool align(@alignOf(Flags)) = false,
    hostVisibleBit: bool = false,
    hostCoherentBit: bool = false,
    hostCachedBit: bool = false,
    lazilyAllocatedBit: bool = false,
    protectedBit: bool = false,
    deviceCoherentBitAMD: bool = false,
    deviceUncachedBitAMD: bool = false,
    rdmaCapableBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(MemoryPropertyFlags, Flags);
};
pub const MemoryHeapFlags = packed struct {
    deviceLocalBit: bool align(@alignOf(Flags)) = false,
    multiInstanceBit: bool = false,
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
    pub usingnamespace FlagsMixin(MemoryHeapFlags, Flags);
};
pub const AccessFlags = packed struct {
    indirectCommandReadBit: bool align(@alignOf(Flags)) = false,
    indexReadBit: bool = false,
    vertexAttributeReadBit: bool = false,
    uniformReadBit: bool = false,
    inputAttachmentReadBit: bool = false,
    shaderReadBit: bool = false,
    shaderWriteBit: bool = false,
    colorAttachmentReadBit: bool = false,
    colorAttachmentWriteBit: bool = false,
    depthStencilAttachmentReadBit: bool = false,
    depthStencilAttachmentWriteBit: bool = false,
    transferReadBit: bool = false,
    transferWriteBit: bool = false,
    hostReadBit: bool = false,
    hostWriteBit: bool = false,
    memoryReadBit: bool = false,
    memoryWriteBit: bool = false,
    commandPreprocessReadBitNV: bool = false,
    commandPreprocessWriteBitNV: bool = false,
    colorAttachmentReadNoncoherentBitEXT: bool = false,
    conditionalRenderingReadBitEXT: bool = false,
    accelerationStructureReadBitKHR: bool = false,
    accelerationStructureWriteBitKHR: bool = false,
    fragmentShadingRateAttachmentReadBitKHR: bool = false,
    fragmentDensityMapReadBitEXT: bool = false,
    transformFeedbackWriteBitEXT: bool = false,
    transformFeedbackCounterReadBitEXT: bool = false,
    transformFeedbackCounterWriteBitEXT: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(AccessFlags, Flags);
};
pub const BufferUsageFlags = packed struct {
    transferSrcBit: bool align(@alignOf(Flags)) = false,
    transferDstBit: bool = false,
    uniformTexelBufferBit: bool = false,
    storageTexelBufferBit: bool = false,
    uniformBufferBit: bool = false,
    storageBufferBit: bool = false,
    indexBufferBit: bool = false,
    vertexBufferBit: bool = false,
    indirectBufferBit: bool = false,
    conditionalRenderingBitEXT: bool = false,
    shaderBindingTableBitKHR: bool = false,
    transformFeedbackBufferBitEXT: bool = false,
    transformFeedbackCounterBufferBitEXT: bool = false,
    videoDecodeSrcBitKHR: bool = false,
    videoDecodeDstBitKHR: bool = false,
    videoEncodeDstBitKHR: bool = false,
    videoEncodeSrcBitKHR: bool = false,
    shaderDeviceAddressBit: bool = false,
    _reserved_bit_18: bool = false,
    accelerationStructureBuildInputReadOnlyBitKHR: bool = false,
    accelerationStructureStorageBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(BufferUsageFlags, Flags);
};
pub const BufferCreateFlags = packed struct {
    sparseBindingBit: bool align(@alignOf(Flags)) = false,
    sparseResidencyBit: bool = false,
    sparseAliasedBit: bool = false,
    protectedBit: bool = false,
    deviceAddressCaptureReplayBit: bool = false,
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
    pub usingnamespace FlagsMixin(BufferCreateFlags, Flags);
};
pub const ShaderStageFlags = packed struct {
    vertexBit: bool align(@alignOf(Flags)) = false,
    tessellationControlBit: bool = false,
    tessellationEvaluationBit: bool = false,
    geometryBit: bool = false,
    fragmentBit: bool = false,
    computeBit: bool = false,
    taskBitNV: bool = false,
    meshBitNV: bool = false,
    raygenBitKHR: bool = false,
    anyHitBitKHR: bool = false,
    closestHitBitKHR: bool = false,
    missBitKHR: bool = false,
    intersectionBitKHR: bool = false,
    callableBitKHR: bool = false,
    subpassShadingBitHUAWEI: bool = false,
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
    pub usingnamespace FlagsMixin(ShaderStageFlags, Flags);
};
pub const ImageUsageFlags = packed struct {
    transferSrcBit: bool align(@alignOf(Flags)) = false,
    transferDstBit: bool = false,
    sampledBit: bool = false,
    storageBit: bool = false,
    colorAttachmentBit: bool = false,
    depthStencilAttachmentBit: bool = false,
    transientAttachmentBit: bool = false,
    inputAttachmentBit: bool = false,
    fragmentShadingRateAttachmentBitKHR: bool = false,
    fragmentDensityMapBitEXT: bool = false,
    videoDecodeDstBitKHR: bool = false,
    videoDecodeSrcBitKHR: bool = false,
    videoDecodeDpbBitKHR: bool = false,
    videoEncodeDstBitKHR: bool = false,
    videoEncodeSrcBitKHR: bool = false,
    videoEncodeDpbBitKHR: bool = false,
    _reserved_bit_16: bool = false,
    _reserved_bit_17: bool = false,
    invocationMaskBitHUAWEI: bool = false,
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
    pub usingnamespace FlagsMixin(ImageUsageFlags, Flags);
};
pub const ImageCreateFlags = packed struct {
    sparseBindingBit: bool align(@alignOf(Flags)) = false,
    sparseResidencyBit: bool = false,
    sparseAliasedBit: bool = false,
    mutableFormatBit: bool = false,
    cubeCompatibleBit: bool = false,
    @"2DArrayCompatibleBit": bool = false,
    splitInstanceBindRegionsBit: bool = false,
    blockTexelViewCompatibleBit: bool = false,
    extendedUsageBit: bool = false,
    disjointBit: bool = false,
    aliasBit: bool = false,
    protectedBit: bool = false,
    sampleLocationsCompatibleDepthBitEXT: bool = false,
    cornerSampledBitNV: bool = false,
    subsampledBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(ImageCreateFlags, Flags);
};
pub const ImageViewCreateFlags = packed struct {
    fragmentDensityMapDynamicBitEXT: bool align(@alignOf(Flags)) = false,
    fragmentDensityMapDeferredBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(ImageViewCreateFlags, Flags);
};
pub const SamplerCreateFlags = packed struct {
    subsampledBitEXT: bool align(@alignOf(Flags)) = false,
    subsampledCoarseReconstructionBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(SamplerCreateFlags, Flags);
};
pub const PipelineCreateFlags = packed struct {
    disableOptimizationBit: bool align(@alignOf(Flags)) = false,
    allowDerivativesBit: bool = false,
    derivativeBit: bool = false,
    viewIndexFromDeviceIndexBit: bool = false,
    dispatchBaseBit: bool = false,
    deferCompileBitNV: bool = false,
    captureStatisticsBitKHR: bool = false,
    captureInternalRepresentationsBitKHR: bool = false,
    failOnPipelineCompileRequiredBitEXT: bool = false,
    earlyReturnOnFailureBitEXT: bool = false,
    _reserved_bit_10: bool = false,
    libraryBitKHR: bool = false,
    rayTracingSkipTrianglesBitKHR: bool = false,
    rayTracingSkipAabbsBitKHR: bool = false,
    rayTracingNoNullAnyHitShadersBitKHR: bool = false,
    rayTracingNoNullClosestHitShadersBitKHR: bool = false,
    rayTracingNoNullMissShadersBitKHR: bool = false,
    rayTracingNoNullIntersectionShadersBitKHR: bool = false,
    indirectBindableBitNV: bool = false,
    rayTracingShaderGroupHandleCaptureReplayBitKHR: bool = false,
    rayTracingAllowMotionBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(PipelineCreateFlags, Flags);
};
pub const PipelineShaderStageCreateFlags = packed struct {
    allowVaryingSubgroupSizeBitEXT: bool align(@alignOf(Flags)) = false,
    requireFullSubgroupsBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(PipelineShaderStageCreateFlags, Flags);
};
pub const ColorComponentFlags = packed struct {
    rBit: bool align(@alignOf(Flags)) = false,
    gBit: bool = false,
    bBit: bool = false,
    aBit: bool = false,
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
    pub usingnamespace FlagsMixin(ColorComponentFlags, Flags);
};
pub const FenceCreateFlags = packed struct {
    signaledBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(FenceCreateFlags, Flags);
};
pub const FormatFeatureFlags = packed struct {
    sampledImageBit: bool align(@alignOf(Flags)) = false,
    storageImageBit: bool = false,
    storageImageAtomicBit: bool = false,
    uniformTexelBufferBit: bool = false,
    storageTexelBufferBit: bool = false,
    storageTexelBufferAtomicBit: bool = false,
    vertexBufferBit: bool = false,
    colorAttachmentBit: bool = false,
    colorAttachmentBlendBit: bool = false,
    depthStencilAttachmentBit: bool = false,
    blitSrcBit: bool = false,
    blitDstBit: bool = false,
    sampledImageFilterLinearBit: bool = false,
    sampledImageFilterCubicBitIMG: bool = false,
    transferSrcBit: bool = false,
    transferDstBit: bool = false,
    sampledImageFilterMinmaxBit: bool = false,
    midpointChromaSamplesBit: bool = false,
    sampledImageYcbcrConversionLinearFilterBit: bool = false,
    sampledImageYcbcrConversionSeparateReconstructionFilterBit: bool = false,
    sampledImageYcbcrConversionChromaReconstructionExplicitBit: bool = false,
    sampledImageYcbcrConversionChromaReconstructionExplicitForceableBit: bool = false,
    disjointBit: bool = false,
    cositedChromaSamplesBit: bool = false,
    fragmentDensityMapBitEXT: bool = false,
    videoDecodeOutputBitKHR: bool = false,
    videoDecodeDpbBitKHR: bool = false,
    videoEncodeInputBitKHR: bool = false,
    videoEncodeDpbBitKHR: bool = false,
    accelerationStructureVertexBufferBitKHR: bool = false,
    fragmentShadingRateAttachmentBitKHR: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(FormatFeatureFlags, Flags);
};
pub const QueryControlFlags = packed struct {
    preciseBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(QueryControlFlags, Flags);
};
pub const QueryResultFlags = packed struct {
    @"64bit": bool align(@alignOf(Flags)) = false,
    waitBit: bool = false,
    withAvailabilityBit: bool = false,
    partialBit: bool = false,
    withStatusBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(QueryResultFlags, Flags);
};
pub const CommandBufferUsageFlags = packed struct {
    oneTimeSubmitBit: bool align(@alignOf(Flags)) = false,
    renderPassContinueBit: bool = false,
    simultaneousUseBit: bool = false,
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
    pub usingnamespace FlagsMixin(CommandBufferUsageFlags, Flags);
};
pub const QueryPipelineStatisticFlags = packed struct {
    inputAssemblyVerticesBit: bool align(@alignOf(Flags)) = false,
    inputAssemblyPrimitivesBit: bool = false,
    vertexShaderInvocationsBit: bool = false,
    geometryShaderInvocationsBit: bool = false,
    geometryShaderPrimitivesBit: bool = false,
    clippingInvocationsBit: bool = false,
    clippingPrimitivesBit: bool = false,
    fragmentShaderInvocationsBit: bool = false,
    tessellationControlShaderPatchesBit: bool = false,
    tessellationEvaluationShaderInvocationsBit: bool = false,
    computeShaderInvocationsBit: bool = false,
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
    pub usingnamespace FlagsMixin(QueryPipelineStatisticFlags, Flags);
};
pub const ImageAspectFlags = packed struct {
    colorBit: bool align(@alignOf(Flags)) = false,
    depthBit: bool = false,
    stencilBit: bool = false,
    metadataBit: bool = false,
    plane0Bit: bool = false,
    plane1Bit: bool = false,
    plane2Bit: bool = false,
    memoryPlane0BitEXT: bool = false,
    memoryPlane1BitEXT: bool = false,
    memoryPlane2BitEXT: bool = false,
    memoryPlane3BitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(ImageAspectFlags, Flags);
};
pub const SparseImageFormatFlags = packed struct {
    singleMiptailBit: bool align(@alignOf(Flags)) = false,
    alignedMipSizeBit: bool = false,
    nonstandardBlockSizeBit: bool = false,
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
    pub usingnamespace FlagsMixin(SparseImageFormatFlags, Flags);
};
pub const SparseMemoryBindFlags = packed struct {
    metadataBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(SparseMemoryBindFlags, Flags);
};
pub const PipelineStageFlags = packed struct {
    topOfPipeBit: bool align(@alignOf(Flags)) = false,
    drawIndirectBit: bool = false,
    vertexInputBit: bool = false,
    vertexShaderBit: bool = false,
    tessellationControlShaderBit: bool = false,
    tessellationEvaluationShaderBit: bool = false,
    geometryShaderBit: bool = false,
    fragmentShaderBit: bool = false,
    earlyFragmentTestsBit: bool = false,
    lateFragmentTestsBit: bool = false,
    colorAttachmentOutputBit: bool = false,
    computeShaderBit: bool = false,
    transferBit: bool = false,
    bottomOfPipeBit: bool = false,
    hostBit: bool = false,
    allGraphicsBit: bool = false,
    allCommandsBit: bool = false,
    commandPreprocessBitNV: bool = false,
    conditionalRenderingBitEXT: bool = false,
    taskShaderBitNV: bool = false,
    meshShaderBitNV: bool = false,
    rayTracingShaderBitKHR: bool = false,
    fragmentShadingRateAttachmentBitKHR: bool = false,
    fragmentDensityProcessBitEXT: bool = false,
    transformFeedbackBitEXT: bool = false,
    accelerationStructureBuildBitKHR: bool = false,
    _reserved_bit_26: bool = false,
    _reserved_bit_27: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    pub usingnamespace FlagsMixin(PipelineStageFlags, Flags);
};
pub const CommandPoolCreateFlags = packed struct {
    transientBit: bool align(@alignOf(Flags)) = false,
    resetCommandBufferBit: bool = false,
    protectedBit: bool = false,
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
    pub usingnamespace FlagsMixin(CommandPoolCreateFlags, Flags);
};
pub const CommandPoolResetFlags = packed struct {
    releaseResourcesBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(CommandPoolResetFlags, Flags);
};
pub const CommandBufferResetFlags = packed struct {
    releaseResourcesBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(CommandBufferResetFlags, Flags);
};
pub const SampleCountFlags = packed struct {
    @"1bit": bool align(@alignOf(Flags)) = false,
    @"2bit": bool = false,
    @"4bit": bool = false,
    @"8bit": bool = false,
    @"16bit": bool = false,
    @"32bit": bool = false,
    @"64bit": bool = false,
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
    pub usingnamespace FlagsMixin(SampleCountFlags, Flags);
};
pub const AttachmentDescriptionFlags = packed struct {
    mayAliasBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(AttachmentDescriptionFlags, Flags);
};
pub const StencilFaceFlags = packed struct {
    frontBit: bool align(@alignOf(Flags)) = false,
    backBit: bool = false,
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
    pub usingnamespace FlagsMixin(StencilFaceFlags, Flags);
};
pub const DescriptorPoolCreateFlags = packed struct {
    freeDescriptorSetBit: bool align(@alignOf(Flags)) = false,
    updateAfterBindBit: bool = false,
    hostOnlyBitVALVE: bool = false,
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
    pub usingnamespace FlagsMixin(DescriptorPoolCreateFlags, Flags);
};
pub const DependencyFlags = packed struct {
    byRegionBit: bool align(@alignOf(Flags)) = false,
    viewLocalBit: bool = false,
    deviceGroupBit: bool = false,
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
    pub usingnamespace FlagsMixin(DependencyFlags, Flags);
};
pub const SemaphoreType = enum(i32) {
    binary = 0,
    timeline = 1,
    _,
    pub const binaryKHR = SemaphoreType.binary;
    pub const timelineKHR = SemaphoreType.timeline;
};
pub const SemaphoreWaitFlags = packed struct {
    anyBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(SemaphoreWaitFlags, Flags);
};
pub const PresentModeKHR = enum(i32) {
    immediateKHR = 0,
    mailboxKHR = 1,
    fifoKHR = 2,
    fifoRelaxedKHR = 3,
    sharedDemandRefreshKHR = 1000111000,
    sharedContinuousRefreshKHR = 1000111001,
    _,
};
pub const ColorSpaceKHR = enum(i32) {
    srgbNonlinearKHR = 0,
    displayP3NonlinearEXT = 1000104001,
    extendedSrgbLinearEXT = 1000104002,
    displayP3LinearEXT = 1000104003,
    dciP3NonlinearEXT = 1000104004,
    bt709LinearEXT = 1000104005,
    bt709NonlinearEXT = 1000104006,
    bt2020LinearEXT = 1000104007,
    hdr10St2084EXT = 1000104008,
    dolbyvisionEXT = 1000104009,
    hdr10HlgEXT = 1000104010,
    adobergbLinearEXT = 1000104011,
    adobergbNonlinearEXT = 1000104012,
    passThroughEXT = 1000104013,
    extendedSrgbNonlinearEXT = 1000104014,
    displayNativeAMD = 1000213000,
    _,
};
pub const DisplayPlaneAlphaFlagsKHR = packed struct {
    opaqueBitKHR: bool align(@alignOf(Flags)) = false,
    globalBitKHR: bool = false,
    perPixelBitKHR: bool = false,
    perPixelPremultipliedBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(DisplayPlaneAlphaFlagsKHR, Flags);
};
pub const CompositeAlphaFlagsKHR = packed struct {
    opaqueBitKHR: bool align(@alignOf(Flags)) = false,
    preMultipliedBitKHR: bool = false,
    postMultipliedBitKHR: bool = false,
    inheritBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(CompositeAlphaFlagsKHR, Flags);
};
pub const SurfaceTransformFlagsKHR = packed struct {
    identityBitKHR: bool align(@alignOf(Flags)) = false,
    rotate90BitKHR: bool = false,
    rotate180BitKHR: bool = false,
    rotate270BitKHR: bool = false,
    horizontalMirrorBitKHR: bool = false,
    horizontalMirrorRotate90BitKHR: bool = false,
    horizontalMirrorRotate180BitKHR: bool = false,
    horizontalMirrorRotate270BitKHR: bool = false,
    inheritBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(SurfaceTransformFlagsKHR, Flags);
};
pub const SwapchainImageUsageFlagsANDROID = packed struct {
    sharedBitANDROID: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(SwapchainImageUsageFlagsANDROID, Flags);
};
pub const TimeDomainEXT = enum(i32) {
    deviceEXT = 0,
    clockMonotonicEXT = 1,
    clockMonotonicRawEXT = 2,
    queryPerformanceCounterEXT = 3,
    _,
};
pub const DebugReportFlagsEXT = packed struct {
    informationBitEXT: bool align(@alignOf(Flags)) = false,
    warningBitEXT: bool = false,
    performanceWarningBitEXT: bool = false,
    errorBitEXT: bool = false,
    debugBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(DebugReportFlagsEXT, Flags);
};
pub const DebugReportObjectTypeEXT = enum(i32) {
    unknownEXT = 0,
    instanceEXT = 1,
    physicalDeviceEXT = 2,
    deviceEXT = 3,
    queueEXT = 4,
    semaphoreEXT = 5,
    commandBufferEXT = 6,
    fenceEXT = 7,
    deviceMemoryEXT = 8,
    bufferEXT = 9,
    imageEXT = 10,
    eventEXT = 11,
    queryPoolEXT = 12,
    bufferViewEXT = 13,
    imageViewEXT = 14,
    shaderModuleEXT = 15,
    pipelineCacheEXT = 16,
    pipelineLayoutEXT = 17,
    renderPassEXT = 18,
    pipelineEXT = 19,
    descriptorSetLayoutEXT = 20,
    samplerEXT = 21,
    descriptorPoolEXT = 22,
    descriptorSetEXT = 23,
    framebufferEXT = 24,
    commandPoolEXT = 25,
    surfaceKhrEXT = 26,
    swapchainKhrEXT = 27,
    debugReportCallbackExtEXT = 28,
    displayKhrEXT = 29,
    displayModeKhrEXT = 30,
    validationCacheExtEXT = 33,
    samplerYcbcrConversionEXT = 1000156000,
    descriptorUpdateTemplateEXT = 1000085000,
    cuModuleNvxEXT = 1000029000,
    cuFunctionNvxEXT = 1000029001,
    accelerationStructureKhrEXT = 1000150000,
    accelerationStructureNvEXT = 1000165000,
    bufferCollectionFuchsiaEXT = 1000366000,
    _,
    pub const descriptorUpdateTemplateKhrEXT = DebugReportObjectTypeEXT.descriptorUpdateTemplateEXT;
    pub const samplerYcbcrConversionKhrEXT = DebugReportObjectTypeEXT.samplerYcbcrConversionEXT;
};
pub const DeviceMemoryReportEventTypeEXT = enum(i32) {
    allocateEXT = 0,
    freeEXT = 1,
    importEXT = 2,
    unimportEXT = 3,
    allocationFailedEXT = 4,
    _,
};
pub const RasterizationOrderAMD = enum(i32) {
    strictAMD = 0,
    relaxedAMD = 1,
    _,
};
pub const ExternalMemoryHandleTypeFlagsNV = packed struct {
    opaqueWin32BitNV: bool align(@alignOf(Flags)) = false,
    opaqueWin32KmtBitNV: bool = false,
    d3d11ImageBitNV: bool = false,
    d3d11ImageKmtBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(ExternalMemoryHandleTypeFlagsNV, Flags);
};
pub const ExternalMemoryFeatureFlagsNV = packed struct {
    dedicatedOnlyBitNV: bool align(@alignOf(Flags)) = false,
    exportableBitNV: bool = false,
    importableBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(ExternalMemoryFeatureFlagsNV, Flags);
};
pub const ValidationCheckEXT = enum(i32) {
    allEXT = 0,
    shadersEXT = 1,
    _,
};
pub const ValidationFeatureEnableEXT = enum(i32) {
    gpuAssistedEXT = 0,
    gpuAssistedReserveBindingSlotEXT = 1,
    bestPracticesEXT = 2,
    debugPrintfEXT = 3,
    synchronizationValidationEXT = 4,
    _,
};
pub const ValidationFeatureDisableEXT = enum(i32) {
    allEXT = 0,
    shadersEXT = 1,
    threadSafetyEXT = 2,
    apiParametersEXT = 3,
    objectLifetimesEXT = 4,
    coreChecksEXT = 5,
    uniqueHandlesEXT = 6,
    shaderValidationCacheEXT = 7,
    _,
};
pub const SubgroupFeatureFlags = packed struct {
    basicBit: bool align(@alignOf(Flags)) = false,
    voteBit: bool = false,
    arithmeticBit: bool = false,
    ballotBit: bool = false,
    shuffleBit: bool = false,
    shuffleRelativeBit: bool = false,
    clusteredBit: bool = false,
    quadBit: bool = false,
    partitionedBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(SubgroupFeatureFlags, Flags);
};
pub const IndirectCommandsLayoutUsageFlagsNV = packed struct {
    explicitPreprocessBitNV: bool align(@alignOf(Flags)) = false,
    indexedSequencesBitNV: bool = false,
    unorderedSequencesBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(IndirectCommandsLayoutUsageFlagsNV, Flags);
};
pub const IndirectStateFlagsNV = packed struct {
    flagFrontfaceBitNV: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(IndirectStateFlagsNV, Flags);
};
pub const IndirectCommandsTokenTypeNV = enum(i32) {
    shaderGroupNV = 0,
    stateFlagsNV = 1,
    indexBufferNV = 2,
    vertexBufferNV = 3,
    pushConstantNV = 4,
    drawIndexedNV = 5,
    drawNV = 6,
    drawTasksNV = 7,
    _,
};
pub const PrivateDataSlotCreateFlagsEXT = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PrivateDataSlotCreateFlagsEXT, Flags);
};
pub const DescriptorSetLayoutCreateFlags = packed struct {
    pushDescriptorBitKHR: bool align(@alignOf(Flags)) = false,
    updateAfterBindPoolBit: bool = false,
    hostOnlyPoolBitVALVE: bool = false,
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
    pub usingnamespace FlagsMixin(DescriptorSetLayoutCreateFlags, Flags);
};
pub const ExternalMemoryHandleTypeFlags = packed struct {
    opaqueFdBit: bool align(@alignOf(Flags)) = false,
    opaqueWin32Bit: bool = false,
    opaqueWin32KmtBit: bool = false,
    d3d11TextureBit: bool = false,
    d3d11TextureKmtBit: bool = false,
    d3d12HeapBit: bool = false,
    d3d12ResourceBit: bool = false,
    hostAllocationBitEXT: bool = false,
    hostMappedForeignMemoryBitEXT: bool = false,
    dmaBufBitEXT: bool = false,
    androidHardwareBufferBitANDROID: bool = false,
    zirconVmoBitFUCHSIA: bool = false,
    rdmaAddressBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(ExternalMemoryHandleTypeFlags, Flags);
};
pub const ExternalMemoryFeatureFlags = packed struct {
    dedicatedOnlyBit: bool align(@alignOf(Flags)) = false,
    exportableBit: bool = false,
    importableBit: bool = false,
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
    pub usingnamespace FlagsMixin(ExternalMemoryFeatureFlags, Flags);
};
pub const ExternalSemaphoreHandleTypeFlags = packed struct {
    opaqueFdBit: bool align(@alignOf(Flags)) = false,
    opaqueWin32Bit: bool = false,
    opaqueWin32KmtBit: bool = false,
    d3d12FenceBit: bool = false,
    syncFdBit: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    zirconEventBitFUCHSIA: bool = false,
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
    pub usingnamespace FlagsMixin(ExternalSemaphoreHandleTypeFlags, Flags);
};
pub const ExternalSemaphoreFeatureFlags = packed struct {
    exportableBit: bool align(@alignOf(Flags)) = false,
    importableBit: bool = false,
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
    pub usingnamespace FlagsMixin(ExternalSemaphoreFeatureFlags, Flags);
};
pub const SemaphoreImportFlags = packed struct {
    temporaryBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(SemaphoreImportFlags, Flags);
};
pub const ExternalFenceHandleTypeFlags = packed struct {
    opaqueFdBit: bool align(@alignOf(Flags)) = false,
    opaqueWin32Bit: bool = false,
    opaqueWin32KmtBit: bool = false,
    syncFdBit: bool = false,
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
    pub usingnamespace FlagsMixin(ExternalFenceHandleTypeFlags, Flags);
};
pub const ExternalFenceFeatureFlags = packed struct {
    exportableBit: bool align(@alignOf(Flags)) = false,
    importableBit: bool = false,
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
    pub usingnamespace FlagsMixin(ExternalFenceFeatureFlags, Flags);
};
pub const FenceImportFlags = packed struct {
    temporaryBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(FenceImportFlags, Flags);
};
pub const SurfaceCounterFlagsEXT = packed struct {
    vblankBitEXT: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(SurfaceCounterFlagsEXT, Flags);
};
pub const DisplayPowerStateEXT = enum(i32) {
    offEXT = 0,
    suspendEXT = 1,
    onEXT = 2,
    _,
};
pub const DeviceEventTypeEXT = enum(i32) {
    displayHotplugEXT = 0,
    _,
};
pub const DisplayEventTypeEXT = enum(i32) {
    firstPixelOutEXT = 0,
    _,
};
pub const PeerMemoryFeatureFlags = packed struct {
    copySrcBit: bool align(@alignOf(Flags)) = false,
    copyDstBit: bool = false,
    genericSrcBit: bool = false,
    genericDstBit: bool = false,
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
    pub usingnamespace FlagsMixin(PeerMemoryFeatureFlags, Flags);
};
pub const MemoryAllocateFlags = packed struct {
    deviceMaskBit: bool align(@alignOf(Flags)) = false,
    deviceAddressBit: bool = false,
    deviceAddressCaptureReplayBit: bool = false,
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
    pub usingnamespace FlagsMixin(MemoryAllocateFlags, Flags);
};
pub const DeviceGroupPresentModeFlagsKHR = packed struct {
    localBitKHR: bool align(@alignOf(Flags)) = false,
    remoteBitKHR: bool = false,
    sumBitKHR: bool = false,
    localMultiDeviceBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(DeviceGroupPresentModeFlagsKHR, Flags);
};
pub const SwapchainCreateFlagsKHR = packed struct {
    splitInstanceBindRegionsBitKHR: bool align(@alignOf(Flags)) = false,
    protectedBitKHR: bool = false,
    mutableFormatBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(SwapchainCreateFlagsKHR, Flags);
};
pub const ViewportCoordinateSwizzleNV = enum(i32) {
    positiveXNV = 0,
    negativeXNV = 1,
    positiveYNV = 2,
    negativeYNV = 3,
    positiveZNV = 4,
    negativeZNV = 5,
    positiveWNV = 6,
    negativeWNV = 7,
    _,
};
pub const DiscardRectangleModeEXT = enum(i32) {
    inclusiveEXT = 0,
    exclusiveEXT = 1,
    _,
};
pub const SubpassDescriptionFlags = packed struct {
    perViewAttributesBitNVX: bool align(@alignOf(Flags)) = false,
    perViewPositionXOnlyBitNVX: bool = false,
    fragmentRegionBitQCOM: bool = false,
    shaderResolveBitQCOM: bool = false,
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
    pub usingnamespace FlagsMixin(SubpassDescriptionFlags, Flags);
};
pub const PointClippingBehavior = enum(i32) {
    allClipPlanes = 0,
    userClipPlanesOnly = 1,
    _,
    pub const allClipPlanesKHR = PointClippingBehavior.allClipPlanes;
    pub const userClipPlanesOnlyKHR = PointClippingBehavior.userClipPlanesOnly;
};
pub const SamplerReductionMode = enum(i32) {
    weightedAverage = 0,
    min = 1,
    max = 2,
    _,
    pub const weightedAverageEXT = SamplerReductionMode.weightedAverage;
    pub const minEXT = SamplerReductionMode.min;
    pub const maxEXT = SamplerReductionMode.max;
};
pub const TessellationDomainOrigin = enum(i32) {
    upperLeft = 0,
    lowerLeft = 1,
    _,
    pub const upperLeftKHR = TessellationDomainOrigin.upperLeft;
    pub const lowerLeftKHR = TessellationDomainOrigin.lowerLeft;
};
pub const SamplerYcbcrModelConversion = enum(i32) {
    rgbIdentity = 0,
    ycbcrIdentity = 1,
    ycbcr709 = 2,
    ycbcr601 = 3,
    ycbcr2020 = 4,
    _,
    pub const rgbIdentityKHR = SamplerYcbcrModelConversion.rgbIdentity;
    pub const ycbcrIdentityKHR = SamplerYcbcrModelConversion.ycbcrIdentity;
    pub const ycbcr709KHR = SamplerYcbcrModelConversion.ycbcr709;
    pub const ycbcr601KHR = SamplerYcbcrModelConversion.ycbcr601;
    pub const ycbcr2020KHR = SamplerYcbcrModelConversion.ycbcr2020;
};
pub const SamplerYcbcrRange = enum(i32) {
    ituFull = 0,
    ituNarrow = 1,
    _,
    pub const ituFullKHR = SamplerYcbcrRange.ituFull;
    pub const ituNarrowKHR = SamplerYcbcrRange.ituNarrow;
};
pub const ChromaLocation = enum(i32) {
    cositedEven = 0,
    midpoint = 1,
    _,
    pub const cositedEvenKHR = ChromaLocation.cositedEven;
    pub const midpointKHR = ChromaLocation.midpoint;
};
pub const BlendOverlapEXT = enum(i32) {
    uncorrelatedEXT = 0,
    disjointEXT = 1,
    conjointEXT = 2,
    _,
};
pub const CoverageModulationModeNV = enum(i32) {
    noneNV = 0,
    rgbNV = 1,
    alphaNV = 2,
    rgbaNV = 3,
    _,
};
pub const CoverageReductionModeNV = enum(i32) {
    mergeNV = 0,
    truncateNV = 1,
    _,
};
pub const ValidationCacheHeaderVersionEXT = enum(i32) {
    oneEXT = 1,
    _,
};
pub const ShaderInfoTypeAMD = enum(i32) {
    statisticsAMD = 0,
    binaryAMD = 1,
    disassemblyAMD = 2,
    _,
};
pub const QueueGlobalPriorityEXT = enum(i32) {
    lowEXT = 128,
    mediumEXT = 256,
    highEXT = 512,
    realtimeEXT = 1024,
    _,
};
pub const DebugUtilsMessageSeverityFlagsEXT = packed struct {
    verboseBitEXT: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    _reserved_bit_2: bool = false,
    _reserved_bit_3: bool = false,
    infoBitEXT: bool = false,
    _reserved_bit_5: bool = false,
    _reserved_bit_6: bool = false,
    _reserved_bit_7: bool = false,
    warningBitEXT: bool = false,
    _reserved_bit_9: bool = false,
    _reserved_bit_10: bool = false,
    _reserved_bit_11: bool = false,
    errorBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(DebugUtilsMessageSeverityFlagsEXT, Flags);
};
pub const DebugUtilsMessageTypeFlagsEXT = packed struct {
    generalBitEXT: bool align(@alignOf(Flags)) = false,
    validationBitEXT: bool = false,
    performanceBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(DebugUtilsMessageTypeFlagsEXT, Flags);
};
pub const ConservativeRasterizationModeEXT = enum(i32) {
    disabledEXT = 0,
    overestimateEXT = 1,
    underestimateEXT = 2,
    _,
};
pub const DescriptorBindingFlags = packed struct {
    updateAfterBindBit: bool align(@alignOf(Flags)) = false,
    updateUnusedWhilePendingBit: bool = false,
    partiallyBoundBit: bool = false,
    variableDescriptorCountBit: bool = false,
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
    pub usingnamespace FlagsMixin(DescriptorBindingFlags, Flags);
};
pub const VendorId = enum(i32) {
    VIV = 0x10001,
    VSI = 0x10002,
    kazan = 0x10003,
    codeplay = 0x10004,
    MESA = 0x10005,
    pocl = 0x10006,
    _,
};
pub const DriverId = enum(i32) {
    amdProprietary = 1,
    amdOpenSource = 2,
    mesaRadv = 3,
    nvidiaProprietary = 4,
    intelProprietaryWindows = 5,
    intelOpenSourceMESA = 6,
    imaginationProprietary = 7,
    qualcommProprietary = 8,
    armProprietary = 9,
    googleSwiftshader = 10,
    ggpProprietary = 11,
    broadcomProprietary = 12,
    mesaLlvmpipe = 13,
    moltenvk = 14,
    coreaviProprietary = 15,
    juiceProprietary = 16,
    verisiliconProprietary = 17,
    mesaTurnip = 18,
    mesaV3dv = 19,
    mesaPanvk = 20,
    _,
    pub const amdProprietaryKHR = DriverId.amdProprietary;
    pub const amdOpenSourceKHR = DriverId.amdOpenSource;
    pub const mesaRadvKHR = DriverId.mesaRadv;
    pub const nvidiaProprietaryKHR = DriverId.nvidiaProprietary;
    pub const intelProprietaryWindowsKHR = DriverId.intelProprietaryWindows;
    pub const intelOpenSourceMesaKHR = DriverId.intelOpenSourceMESA;
    pub const imaginationProprietaryKHR = DriverId.imaginationProprietary;
    pub const qualcommProprietaryKHR = DriverId.qualcommProprietary;
    pub const armProprietaryKHR = DriverId.armProprietary;
    pub const googleSwiftshaderKHR = DriverId.googleSwiftshader;
    pub const ggpProprietaryKHR = DriverId.ggpProprietary;
    pub const broadcomProprietaryKHR = DriverId.broadcomProprietary;
};
pub const ConditionalRenderingFlagsEXT = packed struct {
    invertedBitEXT: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(ConditionalRenderingFlagsEXT, Flags);
};
pub const ResolveModeFlags = packed struct {
    sampleZeroBit: bool align(@alignOf(Flags)) = false,
    averageBit: bool = false,
    minBit: bool = false,
    maxBit: bool = false,
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
    pub usingnamespace FlagsMixin(ResolveModeFlags, Flags);
};
pub const ShadingRatePaletteEntryNV = enum(i32) {
    noInvocationsNV = 0,
    @"16invocationsPerPixelNV" = 1,
    @"8invocationsPerPixelNV" = 2,
    @"4invocationsPerPixelNV" = 3,
    @"2invocationsPerPixelNV" = 4,
    @"1invocationPerPixelNV" = 5,
    @"1invocationPer2X1PixelsNV" = 6,
    @"1invocationPer1X2PixelsNV" = 7,
    @"1invocationPer2X2PixelsNV" = 8,
    @"1invocationPer4X2PixelsNV" = 9,
    @"1invocationPer2X4PixelsNV" = 10,
    @"1invocationPer4X4PixelsNV" = 11,
    _,
};
pub const CoarseSampleOrderTypeNV = enum(i32) {
    defaultNV = 0,
    customNV = 1,
    pixelMajorNV = 2,
    sampleMajorNV = 3,
    _,
};
pub const GeometryInstanceFlagsKHR = packed struct {
    triangleFacingCullDisableBitKHR: bool align(@alignOf(Flags)) = false,
    triangleFlipFacingBitKHR: bool = false,
    forceOpaqueBitKHR: bool = false,
    forceNoOpaqueBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(GeometryInstanceFlagsKHR, Flags);
};
pub const GeometryFlagsKHR = packed struct {
    opaqueBitKHR: bool align(@alignOf(Flags)) = false,
    noDuplicateAnyHitInvocationBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(GeometryFlagsKHR, Flags);
};
pub const BuildAccelerationStructureFlagsKHR = packed struct {
    allowUpdateBitKHR: bool align(@alignOf(Flags)) = false,
    allowCompactionBitKHR: bool = false,
    preferFastTraceBitKHR: bool = false,
    preferFastBuildBitKHR: bool = false,
    lowMemoryBitKHR: bool = false,
    motionBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(BuildAccelerationStructureFlagsKHR, Flags);
};
pub const AccelerationStructureCreateFlagsKHR = packed struct {
    deviceAddressCaptureReplayBitKHR: bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    motionBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(AccelerationStructureCreateFlagsKHR, Flags);
};
pub const CopyAccelerationStructureModeKHR = enum(i32) {
    cloneKHR = 0,
    compactKHR = 1,
    serializeKHR = 2,
    deserializeKHR = 3,
    _,
    pub const cloneNV = CopyAccelerationStructureModeKHR.cloneKHR;
    pub const compactNV = CopyAccelerationStructureModeKHR.compactKHR;
};
pub const BuildAccelerationStructureModeKHR = enum(i32) {
    buildKHR = 0,
    updateKHR = 1,
    _,
};
pub const AccelerationStructureTypeKHR = enum(i32) {
    topLevelKHR = 0,
    bottomLevelKHR = 1,
    genericKHR = 2,
    _,
    pub const topLevelNV = AccelerationStructureTypeKHR.topLevelKHR;
    pub const bottomLevelNV = AccelerationStructureTypeKHR.bottomLevelKHR;
};
pub const GeometryTypeKHR = enum(i32) {
    trianglesKHR = 0,
    aabbsKHR = 1,
    instancesKHR = 2,
    _,
    pub const trianglesNV = GeometryTypeKHR.trianglesKHR;
    pub const aabbsNV = GeometryTypeKHR.aabbsKHR;
};
pub const AccelerationStructureMemoryRequirementsTypeNV = enum(i32) {
    objectNV = 0,
    buildScratchNV = 1,
    updateScratchNV = 2,
    _,
};
pub const AccelerationStructureBuildTypeKHR = enum(i32) {
    hostKHR = 0,
    deviceKHR = 1,
    hostOrDeviceKHR = 2,
    _,
};
pub const RayTracingShaderGroupTypeKHR = enum(i32) {
    generalKHR = 0,
    trianglesHitGroupKHR = 1,
    proceduralHitGroupKHR = 2,
    _,
    pub const generalNV = RayTracingShaderGroupTypeKHR.generalKHR;
    pub const trianglesHitGroupNV = RayTracingShaderGroupTypeKHR.trianglesHitGroupKHR;
    pub const proceduralHitGroupNV = RayTracingShaderGroupTypeKHR.proceduralHitGroupKHR;
};
pub const AccelerationStructureCompatibilityKHR = enum(i32) {
    compatibleKHR = 0,
    incompatibleKHR = 1,
    _,
};
pub const ShaderGroupShaderKHR = enum(i32) {
    generalKHR = 0,
    closestHitKHR = 1,
    anyHitKHR = 2,
    intersectionKHR = 3,
    _,
};
pub const MemoryOverallocationBehaviorAMD = enum(i32) {
    defaultAMD = 0,
    allowedAMD = 1,
    disallowedAMD = 2,
    _,
};
pub const FramebufferCreateFlags = packed struct {
    imagelessBit: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(FramebufferCreateFlags, Flags);
};
pub const ScopeNV = enum(i32) {
    deviceNV = 1,
    workgroupNV = 2,
    subgroupNV = 3,
    queueFamilyNV = 5,
    _,
};
pub const ComponentTypeNV = enum(i32) {
    float16NV = 0,
    float32NV = 1,
    float64NV = 2,
    sint8NV = 3,
    sint16NV = 4,
    sint32NV = 5,
    sint64NV = 6,
    uint8NV = 7,
    uint16NV = 8,
    uint32NV = 9,
    uint64NV = 10,
    _,
};
pub const DeviceDiagnosticsConfigFlagsNV = packed struct {
    enableShaderDebugInfoBitNV: bool align(@alignOf(Flags)) = false,
    enableResourceTrackingBitNV: bool = false,
    enableAutomaticCheckpointsBitNV: bool = false,
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
    pub usingnamespace FlagsMixin(DeviceDiagnosticsConfigFlagsNV, Flags);
};
pub const PipelineCreationFeedbackFlagsEXT = packed struct {
    validBitEXT: bool align(@alignOf(Flags)) = false,
    applicationPipelineCacheHitBitEXT: bool = false,
    basePipelineAccelerationBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(PipelineCreationFeedbackFlagsEXT, Flags);
};
pub const FullScreenExclusiveEXT = enum(i32) {
    defaultEXT = 0,
    allowedEXT = 1,
    disallowedEXT = 2,
    applicationControlledEXT = 3,
    _,
};
pub const PerformanceCounterScopeKHR = enum(i32) {
    commandBufferKHR = 0,
    renderPassKHR = 1,
    commandKHR = 2,
    _,
    pub const queryScopeCommandBufferKHR = PerformanceCounterScopeKHR.commandBufferKHR;
    pub const queryScopeRenderPassKHR = PerformanceCounterScopeKHR.renderPassKHR;
    pub const queryScopeCommandKHR = PerformanceCounterScopeKHR.commandKHR;
};
pub const PerformanceCounterUnitKHR = enum(i32) {
    genericKHR = 0,
    percentageKHR = 1,
    nanosecondsKHR = 2,
    bytesKHR = 3,
    bytesPerSecondKHR = 4,
    kelvinKHR = 5,
    wattsKHR = 6,
    voltsKHR = 7,
    ampsKHR = 8,
    hertzKHR = 9,
    cyclesKHR = 10,
    _,
};
pub const PerformanceCounterStorageKHR = enum(i32) {
    int32KHR = 0,
    int64KHR = 1,
    uint32KHR = 2,
    uint64KHR = 3,
    float32KHR = 4,
    float64KHR = 5,
    _,
};
pub const PerformanceCounterDescriptionFlagsKHR = packed struct {
    performanceImpactingBitKHR: bool align(@alignOf(Flags)) = false,
    concurrentlyImpactedBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(PerformanceCounterDescriptionFlagsKHR, Flags);
};
pub const AcquireProfilingLockFlagsKHR = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(AcquireProfilingLockFlagsKHR, Flags);
};
pub const ShaderCorePropertiesFlagsAMD = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(ShaderCorePropertiesFlagsAMD, Flags);
};
pub const PerformanceConfigurationTypeINTEL = enum(i32) {
    commandQueueMetricsDiscoveryActivatedINTEL = 0,
    _,
};
pub const QueryPoolSamplingModeINTEL = enum(i32) {
    manualINTEL = 0,
    _,
};
pub const PerformanceOverrideTypeINTEL = enum(i32) {
    nullHardwareINTEL = 0,
    flushGpuCachesINTEL = 1,
    _,
};
pub const PerformanceParameterTypeINTEL = enum(i32) {
    hwCountersSupportedINTEL = 0,
    streamMarkerValidBitsINTEL = 1,
    _,
};
pub const PerformanceValueTypeINTEL = enum(i32) {
    uint32INTEL = 0,
    uint64INTEL = 1,
    floatINTEL = 2,
    boolINTEL = 3,
    stringINTEL = 4,
    _,
};
pub const ShaderFloatControlsIndependence = enum(i32) {
    @"32bitOnly" = 0,
    all = 1,
    none = 2,
    _,
    pub const @"32bitOnlyKHR" = ShaderFloatControlsIndependence.@"32bitOnly";
    pub const allKHR = ShaderFloatControlsIndependence.all;
    pub const noneKHR = ShaderFloatControlsIndependence.none;
};
pub const PipelineExecutableStatisticFormatKHR = enum(i32) {
    bool32KHR = 0,
    int64KHR = 1,
    uint64KHR = 2,
    float64KHR = 3,
    _,
};
pub const LineRasterizationModeEXT = enum(i32) {
    defaultEXT = 0,
    rectangularEXT = 1,
    bresenhamEXT = 2,
    rectangularSmoothEXT = 3,
    _,
};
pub const PipelineCompilerControlFlagsAMD = packed struct {
    _reserved_bits: Flags = 0,
    pub usingnamespace FlagsMixin(PipelineCompilerControlFlagsAMD, Flags);
};
pub const ToolPurposeFlagsEXT = packed struct {
    validationBitEXT: bool align(@alignOf(Flags)) = false,
    profilingBitEXT: bool = false,
    tracingBitEXT: bool = false,
    additionalFeaturesBitEXT: bool = false,
    modifyingFeaturesBitEXT: bool = false,
    debugReportingBitEXT: bool = false,
    debugMarkersBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(ToolPurposeFlagsEXT, Flags);
};
pub const FragmentShadingRateCombinerOpKHR = enum(i32) {
    keepKHR = 0,
    replaceKHR = 1,
    minKHR = 2,
    maxKHR = 3,
    mulKHR = 4,
    _,
};
pub const FragmentShadingRateNV = enum(i32) {
    @"1invocationPerPixelNV" = 0,
    @"1invocationPer1X2PixelsNV" = 1,
    @"1invocationPer2X1PixelsNV" = 4,
    @"1invocationPer2X2PixelsNV" = 5,
    @"1invocationPer2X4PixelsNV" = 6,
    @"1invocationPer4X2PixelsNV" = 9,
    @"1invocationPer4X4PixelsNV" = 10,
    @"2invocationsPerPixelNV" = 11,
    @"4invocationsPerPixelNV" = 12,
    @"8invocationsPerPixelNV" = 13,
    @"16invocationsPerPixelNV" = 14,
    noInvocationsNV = 15,
    _,
};
pub const FragmentShadingRateTypeNV = enum(i32) {
    fragmentSizeNV = 0,
    enumsNV = 1,
    _,
};
pub const AccessFlags2KHR = packed struct {
    indirectCommandReadBitKHR: bool align(@alignOf(Flags64)) = false,
    indexReadBitKHR: bool = false,
    vertexAttributeReadBitKHR: bool = false,
    uniformReadBitKHR: bool = false,
    inputAttachmentReadBitKHR: bool = false,
    shaderReadBitKHR: bool = false,
    shaderWriteBitKHR: bool = false,
    colorAttachmentReadBitKHR: bool = false,
    colorAttachmentWriteBitKHR: bool = false,
    depthStencilAttachmentReadBitKHR: bool = false,
    depthStencilAttachmentWriteBitKHR: bool = false,
    transferReadBitKHR: bool = false,
    transferWriteBitKHR: bool = false,
    hostReadBitKHR: bool = false,
    hostWriteBitKHR: bool = false,
    memoryReadBitKHR: bool = false,
    memoryWriteBitKHR: bool = false,
    commandPreprocessReadBitNV: bool = false,
    commandPreprocessWriteBitNV: bool = false,
    colorAttachmentReadNoncoherentBitEXT: bool = false,
    conditionalRenderingReadBitEXT: bool = false,
    accelerationStructureReadBitKHR: bool = false,
    accelerationStructureWriteBitKHR: bool = false,
    fragmentShadingRateAttachmentReadBitKHR: bool = false,
    fragmentDensityMapReadBitEXT: bool = false,
    transformFeedbackWriteBitEXT: bool = false,
    transformFeedbackCounterReadBitEXT: bool = false,
    transformFeedbackCounterWriteBitEXT: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    shaderSampledReadBitKHR: bool = false,
    shaderStorageReadBitKHR: bool = false,
    shaderStorageWriteBitKHR: bool = false,
    videoDecodeReadBitKHR: bool = false,
    videoDecodeWriteBitKHR: bool = false,
    videoEncodeReadBitKHR: bool = false,
    videoEncodeWriteBitKHR: bool = false,
    invocationMaskReadBitHUAWEI: bool = false,
    _reserved_bit_40: bool = false,
    _reserved_bit_41: bool = false,
    _reserved_bit_42: bool = false,
    _reserved_bit_43: bool = false,
    _reserved_bit_44: bool = false,
    _reserved_bit_45: bool = false,
    _reserved_bit_46: bool = false,
    _reserved_bit_47: bool = false,
    _reserved_bit_48: bool = false,
    _reserved_bit_49: bool = false,
    _reserved_bit_50: bool = false,
    _reserved_bit_51: bool = false,
    _reserved_bit_52: bool = false,
    _reserved_bit_53: bool = false,
    _reserved_bit_54: bool = false,
    _reserved_bit_55: bool = false,
    _reserved_bit_56: bool = false,
    _reserved_bit_57: bool = false,
    _reserved_bit_58: bool = false,
    _reserved_bit_59: bool = false,
    _reserved_bit_60: bool = false,
    _reserved_bit_61: bool = false,
    _reserved_bit_62: bool = false,
    _reserved_bit_63: bool = false,
    pub usingnamespace FlagsMixin(AccessFlags2KHR, Flags64);
};
pub const PipelineStageFlags2KHR = packed struct {
    topOfPipeBitKHR: bool align(@alignOf(Flags64)) = false,
    drawIndirectBitKHR: bool = false,
    vertexInputBitKHR: bool = false,
    vertexShaderBitKHR: bool = false,
    tessellationControlShaderBitKHR: bool = false,
    tessellationEvaluationShaderBitKHR: bool = false,
    geometryShaderBitKHR: bool = false,
    fragmentShaderBitKHR: bool = false,
    earlyFragmentTestsBitKHR: bool = false,
    lateFragmentTestsBitKHR: bool = false,
    colorAttachmentOutputBitKHR: bool = false,
    computeShaderBitKHR: bool = false,
    allTransferBitKHR: bool = false,
    bottomOfPipeBitKHR: bool = false,
    hostBitKHR: bool = false,
    allGraphicsBitKHR: bool = false,
    allCommandsBitKHR: bool = false,
    commandPreprocessBitNV: bool = false,
    conditionalRenderingBitEXT: bool = false,
    taskShaderBitNV: bool = false,
    meshShaderBitNV: bool = false,
    rayTracingShaderBitKHR: bool = false,
    fragmentShadingRateAttachmentBitKHR: bool = false,
    fragmentDensityProcessBitEXT: bool = false,
    transformFeedbackBitEXT: bool = false,
    accelerationStructureBuildBitKHR: bool = false,
    videoDecodeBitKHR: bool = false,
    videoEncodeBitKHR: bool = false,
    _reserved_bit_28: bool = false,
    _reserved_bit_29: bool = false,
    _reserved_bit_30: bool = false,
    _reserved_bit_31: bool = false,
    copyBitKHR: bool = false,
    resolveBitKHR: bool = false,
    blitBitKHR: bool = false,
    clearBitKHR: bool = false,
    indexInputBitKHR: bool = false,
    vertexAttributeInputBitKHR: bool = false,
    preRasterizationShadersBitKHR: bool = false,
    subpassShadingBitHUAWEI: bool = false,
    invocationMaskBitHUAWEI: bool = false,
    _reserved_bit_41: bool = false,
    _reserved_bit_42: bool = false,
    _reserved_bit_43: bool = false,
    _reserved_bit_44: bool = false,
    _reserved_bit_45: bool = false,
    _reserved_bit_46: bool = false,
    _reserved_bit_47: bool = false,
    _reserved_bit_48: bool = false,
    _reserved_bit_49: bool = false,
    _reserved_bit_50: bool = false,
    _reserved_bit_51: bool = false,
    _reserved_bit_52: bool = false,
    _reserved_bit_53: bool = false,
    _reserved_bit_54: bool = false,
    _reserved_bit_55: bool = false,
    _reserved_bit_56: bool = false,
    _reserved_bit_57: bool = false,
    _reserved_bit_58: bool = false,
    _reserved_bit_59: bool = false,
    _reserved_bit_60: bool = false,
    _reserved_bit_61: bool = false,
    _reserved_bit_62: bool = false,
    _reserved_bit_63: bool = false,
    pub usingnamespace FlagsMixin(PipelineStageFlags2KHR, Flags64);
};
pub const SubmitFlagsKHR = packed struct {
    protectedBitKHR: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(SubmitFlagsKHR, Flags);
};
pub const EventCreateFlags = packed struct {
    deviceOnlyBitKHR: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(EventCreateFlags, Flags);
};
pub const ProvokingVertexModeEXT = enum(i32) {
    firstVertexEXT = 0,
    lastVertexEXT = 1,
    _,
};
pub const AccelerationStructureMotionInstanceTypeNV = enum(i32) {
    staticNV = 0,
    matrixMotionNV = 1,
    srtMotionNV = 2,
    _,
};
pub const VideoCodecOperationFlagsKHR = packed struct {
    decodeH264BitEXT: bool align(@alignOf(Flags)) = false,
    decodeH265BitEXT: bool = false,
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
    encodeH264BitEXT: bool = false,
    encodeH265BitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(VideoCodecOperationFlagsKHR, Flags);
};
pub const VideoChromaSubsamplingFlagsKHR = packed struct {
    monochromeBitKHR: bool align(@alignOf(Flags)) = false,
    @"420bitKHR": bool = false,
    @"422bitKHR": bool = false,
    @"444bitKHR": bool = false,
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
    pub usingnamespace FlagsMixin(VideoChromaSubsamplingFlagsKHR, Flags);
};
pub const VideoComponentBitDepthFlagsKHR = packed struct {
    @"8bitKHR": bool align(@alignOf(Flags)) = false,
    _reserved_bit_1: bool = false,
    @"10bitKHR": bool = false,
    _reserved_bit_3: bool = false,
    @"12bitKHR": bool = false,
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
    pub usingnamespace FlagsMixin(VideoComponentBitDepthFlagsKHR, Flags);
};
pub const VideoCapabilityFlagsKHR = packed struct {
    protectedContentBitKHR: bool align(@alignOf(Flags)) = false,
    separateReferenceImagesBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(VideoCapabilityFlagsKHR, Flags);
};
pub const VideoSessionCreateFlagsKHR = packed struct {
    protectedContentBitKHR: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(VideoSessionCreateFlagsKHR, Flags);
};
pub const VideoCodingQualityPresetFlagsKHR = packed struct {
    normalBitKHR: bool align(@alignOf(Flags)) = false,
    powerBitKHR: bool = false,
    qualityBitKHR: bool = false,
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
    pub usingnamespace FlagsMixin(VideoCodingQualityPresetFlagsKHR, Flags);
};
pub const VideoDecodeH264PictureLayoutFlagsEXT = packed struct {
    interlacedInterleavedLinesBitEXT: bool align(@alignOf(Flags)) = false,
    interlacedSeparatePlanesBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(VideoDecodeH264PictureLayoutFlagsEXT, Flags);
};
pub const VideoCodingControlFlagsKHR = packed struct {
    resetBitKHR: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(VideoCodingControlFlagsKHR, Flags);
};
pub const QueryResultStatusKHR = enum(i32) {
    errorKHR = -1,
    notReadyKHR = 0,
    completeKHR = 1,
    _,
};
pub const VideoDecodeFlagsKHR = packed struct {
    reserved0BitKHR: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(VideoDecodeFlagsKHR, Flags);
};
pub const VideoEncodeFlagsKHR = packed struct {
    reserved0BitKHR: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeFlagsKHR, Flags);
};
pub const VideoEncodeRateControlFlagsKHR = packed struct {
    resetBitKHR: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeRateControlFlagsKHR, Flags);
};
pub const VideoEncodeRateControlModeFlagsKHR = packed struct {
    _reserved_bit_0: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeRateControlModeFlagsKHR, Flags);
};
pub const VideoEncodeH264CapabilityFlagsEXT = packed struct {
    cabacBitEXT: bool align(@alignOf(Flags)) = false,
    cavlcBitEXT: bool = false,
    weightedBiPredImplicitBitEXT: bool = false,
    transform8X8BitEXT: bool = false,
    chromaQpOffsetBitEXT: bool = false,
    secondChromaQpOffsetBitEXT: bool = false,
    deblockingFilterDisabledBitEXT: bool = false,
    deblockingFilterEnabledBitEXT: bool = false,
    deblockingFilterPartialBitEXT: bool = false,
    multipleSlicePerFrameBitEXT: bool = false,
    evenlyDistributedSliceSizeBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeH264CapabilityFlagsEXT, Flags);
};
pub const VideoEncodeH264InputModeFlagsEXT = packed struct {
    frameBitEXT: bool align(@alignOf(Flags)) = false,
    sliceBitEXT: bool = false,
    nonVclBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeH264InputModeFlagsEXT, Flags);
};
pub const VideoEncodeH264OutputModeFlagsEXT = packed struct {
    frameBitEXT: bool align(@alignOf(Flags)) = false,
    sliceBitEXT: bool = false,
    nonVclBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeH264OutputModeFlagsEXT, Flags);
};
pub const VideoEncodeH264CreateFlagsEXT = packed struct {
    reserved0BitEXT: bool align(@alignOf(Flags)) = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeH264CreateFlagsEXT, Flags);
};
pub const ImageConstraintsInfoFlagsFUCHSIA = packed struct {
    cpuReadRarelyFUCHSIA: bool align(@alignOf(Flags)) = false,
    cpuReadOftenFUCHSIA: bool = false,
    cpuWriteRarelyFUCHSIA: bool = false,
    cpuWriteOftenFUCHSIA: bool = false,
    protectedOptionalFUCHSIA: bool = false,
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
    pub usingnamespace FlagsMixin(ImageConstraintsInfoFlagsFUCHSIA, Flags);
};
pub const FormatFeatureFlags2KHR = packed struct {
    sampledImageBitKHR: bool align(@alignOf(Flags64)) = false,
    storageImageBitKHR: bool = false,
    storageImageAtomicBitKHR: bool = false,
    uniformTexelBufferBitKHR: bool = false,
    storageTexelBufferBitKHR: bool = false,
    storageTexelBufferAtomicBitKHR: bool = false,
    vertexBufferBitKHR: bool = false,
    colorAttachmentBitKHR: bool = false,
    colorAttachmentBlendBitKHR: bool = false,
    depthStencilAttachmentBitKHR: bool = false,
    blitSrcBitKHR: bool = false,
    blitDstBitKHR: bool = false,
    sampledImageFilterLinearBitKHR: bool = false,
    sampledImageFilterCubicBitEXT: bool = false,
    transferSrcBitKHR: bool = false,
    transferDstBitKHR: bool = false,
    sampledImageFilterMinmaxBitKHR: bool = false,
    midpointChromaSamplesBitKHR: bool = false,
    sampledImageYcbcrConversionLinearFilterBitKHR: bool = false,
    sampledImageYcbcrConversionSeparateReconstructionFilterBitKHR: bool = false,
    sampledImageYcbcrConversionChromaReconstructionExplicitBitKHR: bool = false,
    sampledImageYcbcrConversionChromaReconstructionExplicitForceableBitKHR: bool = false,
    disjointBitKHR: bool = false,
    cositedChromaSamplesBitKHR: bool = false,
    fragmentDensityMapBitEXT: bool = false,
    videoDecodeOutputBitKHR: bool = false,
    videoDecodeDpbBitKHR: bool = false,
    videoEncodeInputBitKHR: bool = false,
    videoEncodeDpbBitKHR: bool = false,
    accelerationStructureVertexBufferBitKHR: bool = false,
    fragmentShadingRateAttachmentBitKHR: bool = false,
    storageReadWithoutFormatBitKHR: bool = false,
    storageWriteWithoutFormatBitKHR: bool = false,
    sampledImageDepthComparisonBitKHR: bool = false,
    _reserved_bit_34: bool = false,
    _reserved_bit_35: bool = false,
    _reserved_bit_36: bool = false,
    _reserved_bit_37: bool = false,
    _reserved_bit_38: bool = false,
    _reserved_bit_39: bool = false,
    _reserved_bit_40: bool = false,
    _reserved_bit_41: bool = false,
    _reserved_bit_42: bool = false,
    _reserved_bit_43: bool = false,
    _reserved_bit_44: bool = false,
    _reserved_bit_45: bool = false,
    _reserved_bit_46: bool = false,
    _reserved_bit_47: bool = false,
    _reserved_bit_48: bool = false,
    _reserved_bit_49: bool = false,
    _reserved_bit_50: bool = false,
    _reserved_bit_51: bool = false,
    _reserved_bit_52: bool = false,
    _reserved_bit_53: bool = false,
    _reserved_bit_54: bool = false,
    _reserved_bit_55: bool = false,
    _reserved_bit_56: bool = false,
    _reserved_bit_57: bool = false,
    _reserved_bit_58: bool = false,
    _reserved_bit_59: bool = false,
    _reserved_bit_60: bool = false,
    _reserved_bit_61: bool = false,
    _reserved_bit_62: bool = false,
    _reserved_bit_63: bool = false,
    pub usingnamespace FlagsMixin(FormatFeatureFlags2KHR, Flags64);
};
pub const VideoEncodeH265CapabilityFlagsEXT = packed struct {
    weightedBiPredImplicitBitEXT: bool align(@alignOf(Flags)) = false,
    transform8X8BitEXT: bool = false,
    chromaQpOffsetBitEXT: bool = false,
    secondChromaQpOffsetBitEXT: bool = false,
    deblockingFilterDisabledBitEXT: bool = false,
    deblockingFilterEnabledBitEXT: bool = false,
    deblockingFilterPartialBitEXT: bool = false,
    multipleSlicePerFrameBitEXT: bool = false,
    evenlyDistributedSliceSizeBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeH265CapabilityFlagsEXT, Flags);
};
pub const VideoEncodeH265InputModeFlagsEXT = packed struct {
    frameBitEXT: bool align(@alignOf(Flags)) = false,
    sliceBitEXT: bool = false,
    nonVclBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeH265InputModeFlagsEXT, Flags);
};
pub const VideoEncodeH265OutputModeFlagsEXT = packed struct {
    frameBitEXT: bool align(@alignOf(Flags)) = false,
    sliceBitEXT: bool = false,
    nonVclBitEXT: bool = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeH265OutputModeFlagsEXT, Flags);
};
pub const VideoEncodeH265CtbSizeFlagsEXT = packed struct {
    @"8bitEXT": bool align(@alignOf(Flags)) = false,
    @"16bitEXT": bool = false,
    @"32bitEXT": bool = false,
    @"64bitEXT": bool = false,
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
    pub usingnamespace FlagsMixin(VideoEncodeH265CtbSizeFlagsEXT, Flags);
};
pub const PfnCreateInstance = fn (
    pCreateInfo: *const InstanceCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pInstance: *Instance,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyInstance = fn (
    instance: Instance,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnEnumeratePhysicalDevices = fn (
    instance: Instance,
    pPhysicalDeviceCount: *u32,
    pPhysicalDevices: ?[*]PhysicalDevice,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceProcAddr = fn (
    device: Device,
    pName: [*:0]const u8,
) callconv(vulkan_call_conv) PfnVoidFunction;
pub const PfnGetInstanceProcAddr = fn (
    instance: Instance,
    pName: [*:0]const u8,
) callconv(vulkan_call_conv) PfnVoidFunction;
pub const PfnGetPhysicalDeviceProperties = fn (
    physicalDevice: PhysicalDevice,
    pProperties: *PhysicalDeviceProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceQueueFamilyProperties = fn (
    physicalDevice: PhysicalDevice,
    pQueueFamilyPropertyCount: *u32,
    pQueueFamilyProperties: ?[*]QueueFamilyProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceMemoryProperties = fn (
    physicalDevice: PhysicalDevice,
    pMemoryProperties: *PhysicalDeviceMemoryProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFeatures = fn (
    physicalDevice: PhysicalDevice,
    pFeatures: *PhysicalDeviceFeatures,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFormatProperties = fn (
    physicalDevice: PhysicalDevice,
    format: Format,
    pFormatProperties: *FormatProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceImageFormatProperties = fn (
    physicalDevice: PhysicalDevice,
    format: Format,
    @"type": ImageType,
    tiling: ImageTiling,
    usage: ImageUsageFlags.IntType,
    flags: ImageCreateFlags.IntType,
    pImageFormatProperties: *ImageFormatProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateDevice = fn (
    physicalDevice: PhysicalDevice,
    pCreateInfo: *const DeviceCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pDevice: *Device,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDevice = fn (
    device: Device,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnEnumerateInstanceVersion = fn (
    pApiVersion: *u32,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumerateInstanceLayerProperties = fn (
    pPropertyCount: *u32,
    pProperties: ?[*]LayerProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumerateInstanceExtensionProperties = fn (
    pLayerName: ?[*:0]const u8,
    pPropertyCount: *u32,
    pProperties: ?[*]ExtensionProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumerateDeviceLayerProperties = fn (
    physicalDevice: PhysicalDevice,
    pPropertyCount: *u32,
    pProperties: ?[*]LayerProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumerateDeviceExtensionProperties = fn (
    physicalDevice: PhysicalDevice,
    pLayerName: ?[*:0]const u8,
    pPropertyCount: *u32,
    pProperties: ?[*]ExtensionProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceQueue = fn (
    device: Device,
    queueFamilyIndex: u32,
    queueIndex: u32,
    pQueue: *Queue,
) callconv(vulkan_call_conv) void;
pub const PfnQueueSubmit = fn (
    queue: Queue,
    submitCount: u32,
    pSubmits: [*]const SubmitInfo,
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
    pAllocateInfo: *const MemoryAllocateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pMemory: *DeviceMemory,
) callconv(vulkan_call_conv) Result;
pub const PfnFreeMemory = fn (
    device: Device,
    memory: DeviceMemory,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnMapMemory = fn (
    device: Device,
    memory: DeviceMemory,
    offset: DeviceSize,
    size: DeviceSize,
    flags: MemoryMapFlags.IntType,
    ppData: *?*c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnUnmapMemory = fn (
    device: Device,
    memory: DeviceMemory,
) callconv(vulkan_call_conv) void;
pub const PfnFlushMappedMemoryRanges = fn (
    device: Device,
    memoryRangeCount: u32,
    pMemoryRanges: [*]const MappedMemoryRange,
) callconv(vulkan_call_conv) Result;
pub const PfnInvalidateMappedMemoryRanges = fn (
    device: Device,
    memoryRangeCount: u32,
    pMemoryRanges: [*]const MappedMemoryRange,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceMemoryCommitment = fn (
    device: Device,
    memory: DeviceMemory,
    pCommittedMemoryInBytes: *DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnGetBufferMemoryRequirements = fn (
    device: Device,
    buffer: Buffer,
    pMemoryRequirements: *MemoryRequirements,
) callconv(vulkan_call_conv) void;
pub const PfnBindBufferMemory = fn (
    device: Device,
    buffer: Buffer,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
) callconv(vulkan_call_conv) Result;
pub const PfnGetImageMemoryRequirements = fn (
    device: Device,
    image: Image,
    pMemoryRequirements: *MemoryRequirements,
) callconv(vulkan_call_conv) void;
pub const PfnBindImageMemory = fn (
    device: Device,
    image: Image,
    memory: DeviceMemory,
    memoryOffset: DeviceSize,
) callconv(vulkan_call_conv) Result;
pub const PfnGetImageSparseMemoryRequirements = fn (
    device: Device,
    image: Image,
    pSparseMemoryRequirementCount: *u32,
    pSparseMemoryRequirements: ?[*]SparseImageMemoryRequirements,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceSparseImageFormatProperties = fn (
    physicalDevice: PhysicalDevice,
    format: Format,
    @"type": ImageType,
    samples: SampleCountFlags.IntType,
    usage: ImageUsageFlags.IntType,
    tiling: ImageTiling,
    pPropertyCount: *u32,
    pProperties: ?[*]SparseImageFormatProperties,
) callconv(vulkan_call_conv) void;
pub const PfnQueueBindSparse = fn (
    queue: Queue,
    bindInfoCount: u32,
    pBindInfo: [*]const BindSparseInfo,
    fence: Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateFence = fn (
    device: Device,
    pCreateInfo: *const FenceCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pFence: *Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyFence = fn (
    device: Device,
    fence: Fence,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnResetFences = fn (
    device: Device,
    fenceCount: u32,
    pFences: [*]const Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnGetFenceStatus = fn (
    device: Device,
    fence: Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnWaitForFences = fn (
    device: Device,
    fenceCount: u32,
    pFences: [*]const Fence,
    waitAll: Bool32,
    timeout: u64,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateSemaphore = fn (
    device: Device,
    pCreateInfo: *const SemaphoreCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pSemaphore: *Semaphore,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySemaphore = fn (
    device: Device,
    semaphore: Semaphore,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateEvent = fn (
    device: Device,
    pCreateInfo: *const EventCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pEvent: *Event,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyEvent = fn (
    device: Device,
    event: Event,
    pAllocator: ?*const AllocationCallbacks,
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
    pCreateInfo: *const QueryPoolCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pQueryPool: *QueryPool,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyQueryPool = fn (
    device: Device,
    queryPool: QueryPool,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetQueryPoolResults = fn (
    device: Device,
    queryPool: QueryPool,
    firstQuery: u32,
    queryCount: u32,
    dataSize: usize,
    pData: *c_void,
    stride: DeviceSize,
    flags: QueryResultFlags.IntType,
) callconv(vulkan_call_conv) Result;
pub const PfnResetQueryPool = fn (
    device: Device,
    queryPool: QueryPool,
    firstQuery: u32,
    queryCount: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCreateBuffer = fn (
    device: Device,
    pCreateInfo: *const BufferCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pBuffer: *Buffer,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyBuffer = fn (
    device: Device,
    buffer: Buffer,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateBufferView = fn (
    device: Device,
    pCreateInfo: *const BufferViewCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pView: *BufferView,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyBufferView = fn (
    device: Device,
    bufferView: BufferView,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateImage = fn (
    device: Device,
    pCreateInfo: *const ImageCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pImage: *Image,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyImage = fn (
    device: Device,
    image: Image,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageSubresourceLayout = fn (
    device: Device,
    image: Image,
    pSubresource: *const ImageSubresource,
    pLayout: *SubresourceLayout,
) callconv(vulkan_call_conv) void;
pub const PfnCreateImageView = fn (
    device: Device,
    pCreateInfo: *const ImageViewCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pView: *ImageView,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyImageView = fn (
    device: Device,
    imageView: ImageView,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateShaderModule = fn (
    device: Device,
    pCreateInfo: *const ShaderModuleCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pShaderModule: *ShaderModule,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyShaderModule = fn (
    device: Device,
    shaderModule: ShaderModule,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreatePipelineCache = fn (
    device: Device,
    pCreateInfo: *const PipelineCacheCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pPipelineCache: *PipelineCache,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyPipelineCache = fn (
    device: Device,
    pipelineCache: PipelineCache,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetPipelineCacheData = fn (
    device: Device,
    pipelineCache: PipelineCache,
    pDataSize: *usize,
    pData: ?*c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnMergePipelineCaches = fn (
    device: Device,
    dstCache: PipelineCache,
    srcCacheCount: u32,
    pSrcCaches: [*]const PipelineCache,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateGraphicsPipelines = fn (
    device: Device,
    pipelineCache: PipelineCache,
    createInfoCount: u32,
    pCreateInfos: [*]const GraphicsPipelineCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pPipelines: [*]Pipeline,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateComputePipelines = fn (
    device: Device,
    pipelineCache: PipelineCache,
    createInfoCount: u32,
    pCreateInfos: [*]const ComputePipelineCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pPipelines: [*]Pipeline,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI = fn (
    device: Device,
    renderpass: RenderPass,
    pMaxWorkgroupSize: *Extent2D,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyPipeline = fn (
    device: Device,
    pipeline: Pipeline,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreatePipelineLayout = fn (
    device: Device,
    pCreateInfo: *const PipelineLayoutCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pPipelineLayout: *PipelineLayout,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyPipelineLayout = fn (
    device: Device,
    pipelineLayout: PipelineLayout,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateSampler = fn (
    device: Device,
    pCreateInfo: *const SamplerCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pSampler: *Sampler,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySampler = fn (
    device: Device,
    sampler: Sampler,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateDescriptorSetLayout = fn (
    device: Device,
    pCreateInfo: *const DescriptorSetLayoutCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pSetLayout: *DescriptorSetLayout,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDescriptorSetLayout = fn (
    device: Device,
    descriptorSetLayout: DescriptorSetLayout,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateDescriptorPool = fn (
    device: Device,
    pCreateInfo: *const DescriptorPoolCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pDescriptorPool: *DescriptorPool,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDescriptorPool = fn (
    device: Device,
    descriptorPool: DescriptorPool,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnResetDescriptorPool = fn (
    device: Device,
    descriptorPool: DescriptorPool,
    flags: DescriptorPoolResetFlags.IntType,
) callconv(vulkan_call_conv) Result;
pub const PfnAllocateDescriptorSets = fn (
    device: Device,
    pAllocateInfo: *const DescriptorSetAllocateInfo,
    pDescriptorSets: [*]DescriptorSet,
) callconv(vulkan_call_conv) Result;
pub const PfnFreeDescriptorSets = fn (
    device: Device,
    descriptorPool: DescriptorPool,
    descriptorSetCount: u32,
    pDescriptorSets: [*]const DescriptorSet,
) callconv(vulkan_call_conv) Result;
pub const PfnUpdateDescriptorSets = fn (
    device: Device,
    descriptorWriteCount: u32,
    pDescriptorWrites: [*]const WriteDescriptorSet,
    descriptorCopyCount: u32,
    pDescriptorCopies: [*]const CopyDescriptorSet,
) callconv(vulkan_call_conv) void;
pub const PfnCreateFramebuffer = fn (
    device: Device,
    pCreateInfo: *const FramebufferCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pFramebuffer: *Framebuffer,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyFramebuffer = fn (
    device: Device,
    framebuffer: Framebuffer,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateRenderPass = fn (
    device: Device,
    pCreateInfo: *const RenderPassCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pRenderPass: *RenderPass,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyRenderPass = fn (
    device: Device,
    renderPass: RenderPass,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetRenderAreaGranularity = fn (
    device: Device,
    renderPass: RenderPass,
    pGranularity: *Extent2D,
) callconv(vulkan_call_conv) void;
pub const PfnCreateCommandPool = fn (
    device: Device,
    pCreateInfo: *const CommandPoolCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pCommandPool: *CommandPool,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyCommandPool = fn (
    device: Device,
    commandPool: CommandPool,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnResetCommandPool = fn (
    device: Device,
    commandPool: CommandPool,
    flags: CommandPoolResetFlags.IntType,
) callconv(vulkan_call_conv) Result;
pub const PfnAllocateCommandBuffers = fn (
    device: Device,
    pAllocateInfo: *const CommandBufferAllocateInfo,
    pCommandBuffers: [*]CommandBuffer,
) callconv(vulkan_call_conv) Result;
pub const PfnFreeCommandBuffers = fn (
    device: Device,
    commandPool: CommandPool,
    commandBufferCount: u32,
    pCommandBuffers: [*]const CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnBeginCommandBuffer = fn (
    commandBuffer: CommandBuffer,
    pBeginInfo: *const CommandBufferBeginInfo,
) callconv(vulkan_call_conv) Result;
pub const PfnEndCommandBuffer = fn (
    commandBuffer: CommandBuffer,
) callconv(vulkan_call_conv) Result;
pub const PfnResetCommandBuffer = fn (
    commandBuffer: CommandBuffer,
    flags: CommandBufferResetFlags.IntType,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdBindPipeline = fn (
    commandBuffer: CommandBuffer,
    pipelineBindPoint: PipelineBindPoint,
    pipeline: Pipeline,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetViewport = fn (
    commandBuffer: CommandBuffer,
    firstViewport: u32,
    viewportCount: u32,
    pViewports: [*]const Viewport,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetScissor = fn (
    commandBuffer: CommandBuffer,
    firstScissor: u32,
    scissorCount: u32,
    pScissors: [*]const Rect2D,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetLineWidth = fn (
    commandBuffer: CommandBuffer,
    lineWidth: f32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthBias = fn (
    commandBuffer: CommandBuffer,
    depthBiasConstantFactor: f32,
    depthBiasClamp: f32,
    depthBiasSlopeFactor: f32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetBlendConstants = fn (
    commandBuffer: CommandBuffer,
    blendConstants: [4]f32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthBounds = fn (
    commandBuffer: CommandBuffer,
    minDepthBounds: f32,
    maxDepthBounds: f32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilCompareMask = fn (
    commandBuffer: CommandBuffer,
    faceMask: StencilFaceFlags.IntType,
    compareMask: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilWriteMask = fn (
    commandBuffer: CommandBuffer,
    faceMask: StencilFaceFlags.IntType,
    writeMask: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilReference = fn (
    commandBuffer: CommandBuffer,
    faceMask: StencilFaceFlags.IntType,
    reference: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindDescriptorSets = fn (
    commandBuffer: CommandBuffer,
    pipelineBindPoint: PipelineBindPoint,
    layout: PipelineLayout,
    firstSet: u32,
    descriptorSetCount: u32,
    pDescriptorSets: [*]const DescriptorSet,
    dynamicOffsetCount: u32,
    pDynamicOffsets: [*]const u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindIndexBuffer = fn (
    commandBuffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    indexType: IndexType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindVertexBuffers = fn (
    commandBuffer: CommandBuffer,
    firstBinding: u32,
    bindingCount: u32,
    pBuffers: [*]const Buffer,
    pOffsets: [*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDraw = fn (
    commandBuffer: CommandBuffer,
    vertexCount: u32,
    instanceCount: u32,
    firstVertex: u32,
    firstInstance: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndexed = fn (
    commandBuffer: CommandBuffer,
    indexCount: u32,
    instanceCount: u32,
    firstIndex: u32,
    vertexOffset: i32,
    firstInstance: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawMultiEXT = fn (
    commandBuffer: CommandBuffer,
    drawCount: u32,
    pVertexInfo: [*]const MultiDrawInfoEXT,
    instanceCount: u32,
    firstInstance: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawMultiIndexedEXT = fn (
    commandBuffer: CommandBuffer,
    drawCount: u32,
    pIndexInfo: [*]const MultiDrawIndexedInfoEXT,
    instanceCount: u32,
    firstInstance: u32,
    stride: u32,
    pVertexOffset: ?*const i32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndirect = fn (
    commandBuffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    drawCount: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndexedIndirect = fn (
    commandBuffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    drawCount: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDispatch = fn (
    commandBuffer: CommandBuffer,
    groupCountX: u32,
    groupCountY: u32,
    groupCountZ: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDispatchIndirect = fn (
    commandBuffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSubpassShadingHUAWEI = fn (
    commandBuffer: CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyBuffer = fn (
    commandBuffer: CommandBuffer,
    srcBuffer: Buffer,
    dstBuffer: Buffer,
    regionCount: u32,
    pRegions: [*]const BufferCopy,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyImage = fn (
    commandBuffer: CommandBuffer,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const ImageCopy,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBlitImage = fn (
    commandBuffer: CommandBuffer,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const ImageBlit,
    filter: Filter,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyBufferToImage = fn (
    commandBuffer: CommandBuffer,
    srcBuffer: Buffer,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const BufferImageCopy,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyImageToBuffer = fn (
    commandBuffer: CommandBuffer,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstBuffer: Buffer,
    regionCount: u32,
    pRegions: [*]const BufferImageCopy,
) callconv(vulkan_call_conv) void;
pub const PfnCmdUpdateBuffer = fn (
    commandBuffer: CommandBuffer,
    dstBuffer: Buffer,
    dstOffset: DeviceSize,
    dataSize: DeviceSize,
    pData: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnCmdFillBuffer = fn (
    commandBuffer: CommandBuffer,
    dstBuffer: Buffer,
    dstOffset: DeviceSize,
    size: DeviceSize,
    data: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdClearColorImage = fn (
    commandBuffer: CommandBuffer,
    image: Image,
    imageLayout: ImageLayout,
    pColor: *const ClearColorValue,
    rangeCount: u32,
    pRanges: [*]const ImageSubresourceRange,
) callconv(vulkan_call_conv) void;
pub const PfnCmdClearDepthStencilImage = fn (
    commandBuffer: CommandBuffer,
    image: Image,
    imageLayout: ImageLayout,
    pDepthStencil: *const ClearDepthStencilValue,
    rangeCount: u32,
    pRanges: [*]const ImageSubresourceRange,
) callconv(vulkan_call_conv) void;
pub const PfnCmdClearAttachments = fn (
    commandBuffer: CommandBuffer,
    attachmentCount: u32,
    pAttachments: [*]const ClearAttachment,
    rectCount: u32,
    pRects: [*]const ClearRect,
) callconv(vulkan_call_conv) void;
pub const PfnCmdResolveImage = fn (
    commandBuffer: CommandBuffer,
    srcImage: Image,
    srcImageLayout: ImageLayout,
    dstImage: Image,
    dstImageLayout: ImageLayout,
    regionCount: u32,
    pRegions: [*]const ImageResolve,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetEvent = fn (
    commandBuffer: CommandBuffer,
    event: Event,
    stageMask: PipelineStageFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdResetEvent = fn (
    commandBuffer: CommandBuffer,
    event: Event,
    stageMask: PipelineStageFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdWaitEvents = fn (
    commandBuffer: CommandBuffer,
    eventCount: u32,
    pEvents: [*]const Event,
    srcStageMask: PipelineStageFlags.IntType,
    dstStageMask: PipelineStageFlags.IntType,
    memoryBarrierCount: u32,
    pMemoryBarriers: [*]const MemoryBarrier,
    bufferMemoryBarrierCount: u32,
    pBufferMemoryBarriers: [*]const BufferMemoryBarrier,
    imageMemoryBarrierCount: u32,
    pImageMemoryBarriers: [*]const ImageMemoryBarrier,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPipelineBarrier = fn (
    commandBuffer: CommandBuffer,
    srcStageMask: PipelineStageFlags.IntType,
    dstStageMask: PipelineStageFlags.IntType,
    dependencyFlags: DependencyFlags.IntType,
    memoryBarrierCount: u32,
    pMemoryBarriers: [*]const MemoryBarrier,
    bufferMemoryBarrierCount: u32,
    pBufferMemoryBarriers: [*]const BufferMemoryBarrier,
    imageMemoryBarrierCount: u32,
    pImageMemoryBarriers: [*]const ImageMemoryBarrier,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginQuery = fn (
    commandBuffer: CommandBuffer,
    queryPool: QueryPool,
    query: u32,
    flags: QueryControlFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndQuery = fn (
    commandBuffer: CommandBuffer,
    queryPool: QueryPool,
    query: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginConditionalRenderingEXT = fn (
    commandBuffer: CommandBuffer,
    pConditionalRenderingBegin: *const ConditionalRenderingBeginInfoEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndConditionalRenderingEXT = fn (
    commandBuffer: CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCmdResetQueryPool = fn (
    commandBuffer: CommandBuffer,
    queryPool: QueryPool,
    firstQuery: u32,
    queryCount: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdWriteTimestamp = fn (
    commandBuffer: CommandBuffer,
    pipelineStage: PipelineStageFlags.IntType,
    queryPool: QueryPool,
    query: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyQueryPoolResults = fn (
    commandBuffer: CommandBuffer,
    queryPool: QueryPool,
    firstQuery: u32,
    queryCount: u32,
    dstBuffer: Buffer,
    dstOffset: DeviceSize,
    stride: DeviceSize,
    flags: QueryResultFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPushConstants = fn (
    commandBuffer: CommandBuffer,
    layout: PipelineLayout,
    stageFlags: ShaderStageFlags.IntType,
    offset: u32,
    size: u32,
    pValues: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginRenderPass = fn (
    commandBuffer: CommandBuffer,
    pRenderPassBegin: *const RenderPassBeginInfo,
    contents: SubpassContents,
) callconv(vulkan_call_conv) void;
pub const PfnCmdNextSubpass = fn (
    commandBuffer: CommandBuffer,
    contents: SubpassContents,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndRenderPass = fn (
    commandBuffer: CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCmdExecuteCommands = fn (
    commandBuffer: CommandBuffer,
    commandBufferCount: u32,
    pCommandBuffers: [*]const CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCreateAndroidSurfaceKHR = fn (
    instance: Instance,
    pCreateInfo: *const AndroidSurfaceCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDisplayPropertiesKHR = fn (
    physicalDevice: PhysicalDevice,
    pPropertyCount: *u32,
    pProperties: ?[*]DisplayPropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDisplayPlanePropertiesKHR = fn (
    physicalDevice: PhysicalDevice,
    pPropertyCount: *u32,
    pProperties: ?[*]DisplayPlanePropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayPlaneSupportedDisplaysKHR = fn (
    physicalDevice: PhysicalDevice,
    planeIndex: u32,
    pDisplayCount: *u32,
    pDisplays: ?[*]DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayModePropertiesKHR = fn (
    physicalDevice: PhysicalDevice,
    display: DisplayKHR,
    pPropertyCount: *u32,
    pProperties: ?[*]DisplayModePropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateDisplayModeKHR = fn (
    physicalDevice: PhysicalDevice,
    display: DisplayKHR,
    pCreateInfo: *const DisplayModeCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pMode: *DisplayModeKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayPlaneCapabilitiesKHR = fn (
    physicalDevice: PhysicalDevice,
    mode: DisplayModeKHR,
    planeIndex: u32,
    pCapabilities: *DisplayPlaneCapabilitiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateDisplayPlaneSurfaceKHR = fn (
    instance: Instance,
    pCreateInfo: *const DisplaySurfaceCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateSharedSwapchainsKHR = fn (
    device: Device,
    swapchainCount: u32,
    pCreateInfos: [*]const SwapchainCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pSwapchains: [*]SwapchainKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySurfaceKHR = fn (
    instance: Instance,
    surface: SurfaceKHR,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceSurfaceSupportKHR = fn (
    physicalDevice: PhysicalDevice,
    queueFamilyIndex: u32,
    surface: SurfaceKHR,
    pSupported: *Bool32,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfaceCapabilitiesKHR = fn (
    physicalDevice: PhysicalDevice,
    surface: SurfaceKHR,
    pSurfaceCapabilities: *SurfaceCapabilitiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfaceFormatsKHR = fn (
    physicalDevice: PhysicalDevice,
    surface: SurfaceKHR,
    pSurfaceFormatCount: *u32,
    pSurfaceFormats: ?[*]SurfaceFormatKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfacePresentModesKHR = fn (
    physicalDevice: PhysicalDevice,
    surface: SurfaceKHR,
    pPresentModeCount: *u32,
    pPresentModes: ?[*]PresentModeKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateSwapchainKHR = fn (
    device: Device,
    pCreateInfo: *const SwapchainCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pSwapchain: *SwapchainKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySwapchainKHR = fn (
    device: Device,
    swapchain: SwapchainKHR,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetSwapchainImagesKHR = fn (
    device: Device,
    swapchain: SwapchainKHR,
    pSwapchainImageCount: *u32,
    pSwapchainImages: ?[*]Image,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireNextImageKHR = fn (
    device: Device,
    swapchain: SwapchainKHR,
    timeout: u64,
    semaphore: Semaphore,
    fence: Fence,
    pImageIndex: *u32,
) callconv(vulkan_call_conv) Result;
pub const PfnQueuePresentKHR = fn (
    queue: Queue,
    pPresentInfo: *const PresentInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateViSurfaceNN = fn (
    instance: Instance,
    pCreateInfo: *const ViSurfaceCreateInfoNN,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateWaylandSurfaceKHR = fn (
    instance: Instance,
    pCreateInfo: *const WaylandSurfaceCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceWaylandPresentationSupportKHR = fn (
    physicalDevice: PhysicalDevice,
    queueFamilyIndex: u32,
    display: *wl_display,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateWin32SurfaceKHR = fn (
    instance: Instance,
    pCreateInfo: *const Win32SurfaceCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceWin32PresentationSupportKHR = fn (
    physicalDevice: PhysicalDevice,
    queueFamilyIndex: u32,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateXlibSurfaceKHR = fn (
    instance: Instance,
    pCreateInfo: *const XlibSurfaceCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceXlibPresentationSupportKHR = fn (
    physicalDevice: PhysicalDevice,
    queueFamilyIndex: u32,
    dpy: *Display,
    visualId: VisualID,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateXcbSurfaceKHR = fn (
    instance: Instance,
    pCreateInfo: *const XcbSurfaceCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceXcbPresentationSupportKHR = fn (
    physicalDevice: PhysicalDevice,
    queueFamilyIndex: u32,
    connection: *xcb_connection_t,
    visualId: xcb_visualid_t,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateDirectFBSurfaceEXT = fn (
    instance: Instance,
    pCreateInfo: *const DirectFBSurfaceCreateInfoEXT,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDirectFBPresentationSupportEXT = fn (
    physicalDevice: PhysicalDevice,
    queueFamilyIndex: u32,
    dfb: *IDirectFB,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateImagePipeSurfaceFUCHSIA = fn (
    instance: Instance,
    pCreateInfo: *const ImagePipeSurfaceCreateInfoFUCHSIA,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateStreamDescriptorSurfaceGGP = fn (
    instance: Instance,
    pCreateInfo: *const StreamDescriptorSurfaceCreateInfoGGP,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateScreenSurfaceQNX = fn (
    instance: Instance,
    pCreateInfo: *const ScreenSurfaceCreateInfoQNX,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceScreenPresentationSupportQNX = fn (
    physicalDevice: PhysicalDevice,
    queueFamilyIndex: u32,
    window: *_screen_window,
) callconv(vulkan_call_conv) Bool32;
pub const PfnCreateDebugReportCallbackEXT = fn (
    instance: Instance,
    pCreateInfo: *const DebugReportCallbackCreateInfoEXT,
    pAllocator: ?*const AllocationCallbacks,
    pCallback: *DebugReportCallbackEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDebugReportCallbackEXT = fn (
    instance: Instance,
    callback: DebugReportCallbackEXT,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnDebugReportMessageEXT = fn (
    instance: Instance,
    flags: DebugReportFlagsEXT.IntType,
    objectType: DebugReportObjectTypeEXT,
    object: u64,
    location: usize,
    messageCode: i32,
    pLayerPrefix: [*:0]const u8,
    pMessage: [*:0]const u8,
) callconv(vulkan_call_conv) void;
pub const PfnDebugMarkerSetObjectNameEXT = fn (
    device: Device,
    pNameInfo: *const DebugMarkerObjectNameInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDebugMarkerSetObjectTagEXT = fn (
    device: Device,
    pTagInfo: *const DebugMarkerObjectTagInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdDebugMarkerBeginEXT = fn (
    commandBuffer: CommandBuffer,
    pMarkerInfo: *const DebugMarkerMarkerInfoEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDebugMarkerEndEXT = fn (
    commandBuffer: CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDebugMarkerInsertEXT = fn (
    commandBuffer: CommandBuffer,
    pMarkerInfo: *const DebugMarkerMarkerInfoEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceExternalImageFormatPropertiesNV = fn (
    physicalDevice: PhysicalDevice,
    format: Format,
    @"type": ImageType,
    tiling: ImageTiling,
    usage: ImageUsageFlags.IntType,
    flags: ImageCreateFlags.IntType,
    externalHandleType: ExternalMemoryHandleTypeFlagsNV.IntType,
    pExternalImageFormatProperties: *ExternalImageFormatPropertiesNV,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryWin32HandleNV = fn (
    device: Device,
    memory: DeviceMemory,
    handleType: ExternalMemoryHandleTypeFlagsNV.IntType,
    pHandle: *HANDLE,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdExecuteGeneratedCommandsNV = fn (
    commandBuffer: CommandBuffer,
    isPreprocessed: Bool32,
    pGeneratedCommandsInfo: *const GeneratedCommandsInfoNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPreprocessGeneratedCommandsNV = fn (
    commandBuffer: CommandBuffer,
    pGeneratedCommandsInfo: *const GeneratedCommandsInfoNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindPipelineShaderGroupNV = fn (
    commandBuffer: CommandBuffer,
    pipelineBindPoint: PipelineBindPoint,
    pipeline: Pipeline,
    groupIndex: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetGeneratedCommandsMemoryRequirementsNV = fn (
    device: Device,
    pInfo: *const GeneratedCommandsMemoryRequirementsInfoNV,
    pMemoryRequirements: *MemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnCreateIndirectCommandsLayoutNV = fn (
    device: Device,
    pCreateInfo: *const IndirectCommandsLayoutCreateInfoNV,
    pAllocator: ?*const AllocationCallbacks,
    pIndirectCommandsLayout: *IndirectCommandsLayoutNV,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyIndirectCommandsLayoutNV = fn (
    device: Device,
    indirectCommandsLayout: IndirectCommandsLayoutNV,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFeatures2 = fn (
    physicalDevice: PhysicalDevice,
    pFeatures: *PhysicalDeviceFeatures2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceProperties2 = fn (
    physicalDevice: PhysicalDevice,
    pProperties: *PhysicalDeviceProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFormatProperties2 = fn (
    physicalDevice: PhysicalDevice,
    format: Format,
    pFormatProperties: *FormatProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceImageFormatProperties2 = fn (
    physicalDevice: PhysicalDevice,
    pImageFormatInfo: *const PhysicalDeviceImageFormatInfo2,
    pImageFormatProperties: *ImageFormatProperties2,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceQueueFamilyProperties2 = fn (
    physicalDevice: PhysicalDevice,
    pQueueFamilyPropertyCount: *u32,
    pQueueFamilyProperties: ?[*]QueueFamilyProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceMemoryProperties2 = fn (
    physicalDevice: PhysicalDevice,
    pMemoryProperties: *PhysicalDeviceMemoryProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceSparseImageFormatProperties2 = fn (
    physicalDevice: PhysicalDevice,
    pFormatInfo: *const PhysicalDeviceSparseImageFormatInfo2,
    pPropertyCount: *u32,
    pProperties: ?[*]SparseImageFormatProperties2,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPushDescriptorSetKHR = fn (
    commandBuffer: CommandBuffer,
    pipelineBindPoint: PipelineBindPoint,
    layout: PipelineLayout,
    set: u32,
    descriptorWriteCount: u32,
    pDescriptorWrites: [*]const WriteDescriptorSet,
) callconv(vulkan_call_conv) void;
pub const PfnTrimCommandPool = fn (
    device: Device,
    commandPool: CommandPool,
    flags: CommandPoolTrimFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceExternalBufferProperties = fn (
    physicalDevice: PhysicalDevice,
    pExternalBufferInfo: *const PhysicalDeviceExternalBufferInfo,
    pExternalBufferProperties: *ExternalBufferProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetMemoryWin32HandleKHR = fn (
    device: Device,
    pGetWin32HandleInfo: *const MemoryGetWin32HandleInfoKHR,
    pHandle: *HANDLE,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryWin32HandlePropertiesKHR = fn (
    device: Device,
    handleType: ExternalMemoryHandleTypeFlags.IntType,
    handle: HANDLE,
    pMemoryWin32HandleProperties: *MemoryWin32HandlePropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryFdKHR = fn (
    device: Device,
    pGetFdInfo: *const MemoryGetFdInfoKHR,
    pFd: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryFdPropertiesKHR = fn (
    device: Device,
    handleType: ExternalMemoryHandleTypeFlags.IntType,
    fd: c_int,
    pMemoryFdProperties: *MemoryFdPropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryZirconHandleFUCHSIA = fn (
    device: Device,
    pGetZirconHandleInfo: *const MemoryGetZirconHandleInfoFUCHSIA,
    pZirconHandle: *zx_handle_t,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryZirconHandlePropertiesFUCHSIA = fn (
    device: Device,
    handleType: ExternalMemoryHandleTypeFlags.IntType,
    zirconHandle: zx_handle_t,
    pMemoryZirconHandleProperties: *MemoryZirconHandlePropertiesFUCHSIA,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryRemoteAddressNV = fn (
    device: Device,
    pMemoryGetRemoteAddressInfo: *const MemoryGetRemoteAddressInfoNV,
    pAddress: *RemoteAddressNV,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceExternalSemaphoreProperties = fn (
    physicalDevice: PhysicalDevice,
    pExternalSemaphoreInfo: *const PhysicalDeviceExternalSemaphoreInfo,
    pExternalSemaphoreProperties: *ExternalSemaphoreProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetSemaphoreWin32HandleKHR = fn (
    device: Device,
    pGetWin32HandleInfo: *const SemaphoreGetWin32HandleInfoKHR,
    pHandle: *HANDLE,
) callconv(vulkan_call_conv) Result;
pub const PfnImportSemaphoreWin32HandleKHR = fn (
    device: Device,
    pImportSemaphoreWin32HandleInfo: *const ImportSemaphoreWin32HandleInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetSemaphoreFdKHR = fn (
    device: Device,
    pGetFdInfo: *const SemaphoreGetFdInfoKHR,
    pFd: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnImportSemaphoreFdKHR = fn (
    device: Device,
    pImportSemaphoreFdInfo: *const ImportSemaphoreFdInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetSemaphoreZirconHandleFUCHSIA = fn (
    device: Device,
    pGetZirconHandleInfo: *const SemaphoreGetZirconHandleInfoFUCHSIA,
    pZirconHandle: *zx_handle_t,
) callconv(vulkan_call_conv) Result;
pub const PfnImportSemaphoreZirconHandleFUCHSIA = fn (
    device: Device,
    pImportSemaphoreZirconHandleInfo: *const ImportSemaphoreZirconHandleInfoFUCHSIA,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceExternalFenceProperties = fn (
    physicalDevice: PhysicalDevice,
    pExternalFenceInfo: *const PhysicalDeviceExternalFenceInfo,
    pExternalFenceProperties: *ExternalFenceProperties,
) callconv(vulkan_call_conv) void;
pub const PfnGetFenceWin32HandleKHR = fn (
    device: Device,
    pGetWin32HandleInfo: *const FenceGetWin32HandleInfoKHR,
    pHandle: *HANDLE,
) callconv(vulkan_call_conv) Result;
pub const PfnImportFenceWin32HandleKHR = fn (
    device: Device,
    pImportFenceWin32HandleInfo: *const ImportFenceWin32HandleInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetFenceFdKHR = fn (
    device: Device,
    pGetFdInfo: *const FenceGetFdInfoKHR,
    pFd: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnImportFenceFdKHR = fn (
    device: Device,
    pImportFenceFdInfo: *const ImportFenceFdInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnReleaseDisplayEXT = fn (
    physicalDevice: PhysicalDevice,
    display: DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireXlibDisplayEXT = fn (
    physicalDevice: PhysicalDevice,
    dpy: *Display,
    display: DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetRandROutputDisplayEXT = fn (
    physicalDevice: PhysicalDevice,
    dpy: *Display,
    rrOutput: RROutput,
    pDisplay: *DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireWinrtDisplayNV = fn (
    physicalDevice: PhysicalDevice,
    display: DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetWinrtDisplayNV = fn (
    physicalDevice: PhysicalDevice,
    deviceRelativeId: u32,
    pDisplay: *DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDisplayPowerControlEXT = fn (
    device: Device,
    display: DisplayKHR,
    pDisplayPowerInfo: *const DisplayPowerInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnRegisterDeviceEventEXT = fn (
    device: Device,
    pDeviceEventInfo: *const DeviceEventInfoEXT,
    pAllocator: ?*const AllocationCallbacks,
    pFence: *Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnRegisterDisplayEventEXT = fn (
    device: Device,
    display: DisplayKHR,
    pDisplayEventInfo: *const DisplayEventInfoEXT,
    pAllocator: ?*const AllocationCallbacks,
    pFence: *Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnGetSwapchainCounterEXT = fn (
    device: Device,
    swapchain: SwapchainKHR,
    counter: SurfaceCounterFlagsEXT.IntType,
    pCounterValue: *u64,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfaceCapabilities2EXT = fn (
    physicalDevice: PhysicalDevice,
    surface: SurfaceKHR,
    pSurfaceCapabilities: *SurfaceCapabilities2EXT,
) callconv(vulkan_call_conv) Result;
pub const PfnEnumeratePhysicalDeviceGroups = fn (
    instance: Instance,
    pPhysicalDeviceGroupCount: *u32,
    pPhysicalDeviceGroupProperties: ?[*]PhysicalDeviceGroupProperties,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceGroupPeerMemoryFeatures = fn (
    device: Device,
    heapIndex: u32,
    localDeviceIndex: u32,
    remoteDeviceIndex: u32,
    pPeerMemoryFeatures: *PeerMemoryFeatureFlags,
) callconv(vulkan_call_conv) void;
pub const PfnBindBufferMemory2 = fn (
    device: Device,
    bindInfoCount: u32,
    pBindInfos: [*]const BindBufferMemoryInfo,
) callconv(vulkan_call_conv) Result;
pub const PfnBindImageMemory2 = fn (
    device: Device,
    bindInfoCount: u32,
    pBindInfos: [*]const BindImageMemoryInfo,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetDeviceMask = fn (
    commandBuffer: CommandBuffer,
    deviceMask: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeviceGroupPresentCapabilitiesKHR = fn (
    device: Device,
    pDeviceGroupPresentCapabilities: *DeviceGroupPresentCapabilitiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceGroupSurfacePresentModesKHR = fn (
    device: Device,
    surface: SurfaceKHR,
    pModes: *DeviceGroupPresentModeFlagsKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireNextImage2KHR = fn (
    device: Device,
    pAcquireInfo: *const AcquireNextImageInfoKHR,
    pImageIndex: *u32,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdDispatchBase = fn (
    commandBuffer: CommandBuffer,
    baseGroupX: u32,
    baseGroupY: u32,
    baseGroupZ: u32,
    groupCountX: u32,
    groupCountY: u32,
    groupCountZ: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDevicePresentRectanglesKHR = fn (
    physicalDevice: PhysicalDevice,
    surface: SurfaceKHR,
    pRectCount: *u32,
    pRects: ?[*]Rect2D,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateDescriptorUpdateTemplate = fn (
    device: Device,
    pCreateInfo: *const DescriptorUpdateTemplateCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pDescriptorUpdateTemplate: *DescriptorUpdateTemplate,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDescriptorUpdateTemplate = fn (
    device: Device,
    descriptorUpdateTemplate: DescriptorUpdateTemplate,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnUpdateDescriptorSetWithTemplate = fn (
    device: Device,
    descriptorSet: DescriptorSet,
    descriptorUpdateTemplate: DescriptorUpdateTemplate,
    pData: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPushDescriptorSetWithTemplateKHR = fn (
    commandBuffer: CommandBuffer,
    descriptorUpdateTemplate: DescriptorUpdateTemplate,
    layout: PipelineLayout,
    set: u32,
    pData: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnSetHdrMetadataEXT = fn (
    device: Device,
    swapchainCount: u32,
    pSwapchains: [*]const SwapchainKHR,
    pMetadata: [*]const HdrMetadataEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetSwapchainStatusKHR = fn (
    device: Device,
    swapchain: SwapchainKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetRefreshCycleDurationGOOGLE = fn (
    device: Device,
    swapchain: SwapchainKHR,
    pDisplayTimingProperties: *RefreshCycleDurationGOOGLE,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPastPresentationTimingGOOGLE = fn (
    device: Device,
    swapchain: SwapchainKHR,
    pPresentationTimingCount: *u32,
    pPresentationTimings: ?[*]PastPresentationTimingGOOGLE,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateIOSSurfaceMVK = fn (
    instance: Instance,
    pCreateInfo: *const IOSSurfaceCreateInfoMVK,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateMacOSSurfaceMVK = fn (
    instance: Instance,
    pCreateInfo: *const MacOSSurfaceCreateInfoMVK,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateMetalSurfaceEXT = fn (
    instance: Instance,
    pCreateInfo: *const MetalSurfaceCreateInfoEXT,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetViewportWScalingNV = fn (
    commandBuffer: CommandBuffer,
    firstViewport: u32,
    viewportCount: u32,
    pViewportWScalings: [*]const ViewportWScalingNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDiscardRectangleEXT = fn (
    commandBuffer: CommandBuffer,
    firstDiscardRectangle: u32,
    discardRectangleCount: u32,
    pDiscardRectangles: [*]const Rect2D,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetSampleLocationsEXT = fn (
    commandBuffer: CommandBuffer,
    pSampleLocationsInfo: *const SampleLocationsInfoEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceMultisamplePropertiesEXT = fn (
    physicalDevice: PhysicalDevice,
    samples: SampleCountFlags.IntType,
    pMultisampleProperties: *MultisamplePropertiesEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceSurfaceCapabilities2KHR = fn (
    physicalDevice: PhysicalDevice,
    pSurfaceInfo: *const PhysicalDeviceSurfaceInfo2KHR,
    pSurfaceCapabilities: *SurfaceCapabilities2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfaceFormats2KHR = fn (
    physicalDevice: PhysicalDevice,
    pSurfaceInfo: *const PhysicalDeviceSurfaceInfo2KHR,
    pSurfaceFormatCount: *u32,
    pSurfaceFormats: ?[*]SurfaceFormat2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDisplayProperties2KHR = fn (
    physicalDevice: PhysicalDevice,
    pPropertyCount: *u32,
    pProperties: ?[*]DisplayProperties2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceDisplayPlaneProperties2KHR = fn (
    physicalDevice: PhysicalDevice,
    pPropertyCount: *u32,
    pProperties: ?[*]DisplayPlaneProperties2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayModeProperties2KHR = fn (
    physicalDevice: PhysicalDevice,
    display: DisplayKHR,
    pPropertyCount: *u32,
    pProperties: ?[*]DisplayModeProperties2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDisplayPlaneCapabilities2KHR = fn (
    physicalDevice: PhysicalDevice,
    pDisplayPlaneInfo: *const DisplayPlaneInfo2KHR,
    pCapabilities: *DisplayPlaneCapabilities2KHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetBufferMemoryRequirements2 = fn (
    device: Device,
    pInfo: *const BufferMemoryRequirementsInfo2,
    pMemoryRequirements: *MemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageMemoryRequirements2 = fn (
    device: Device,
    pInfo: *const ImageMemoryRequirementsInfo2,
    pMemoryRequirements: *MemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageSparseMemoryRequirements2 = fn (
    device: Device,
    pInfo: *const ImageSparseMemoryRequirementsInfo2,
    pSparseMemoryRequirementCount: *u32,
    pSparseMemoryRequirements: ?[*]SparseImageMemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeviceBufferMemoryRequirementsKHR = fn (
    device: Device,
    pInfo: *const DeviceBufferMemoryRequirementsKHR,
    pMemoryRequirements: *MemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeviceImageMemoryRequirementsKHR = fn (
    device: Device,
    pInfo: *const DeviceImageMemoryRequirementsKHR,
    pMemoryRequirements: *MemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeviceImageSparseMemoryRequirementsKHR = fn (
    device: Device,
    pInfo: *const DeviceImageMemoryRequirementsKHR,
    pSparseMemoryRequirementCount: *u32,
    pSparseMemoryRequirements: ?[*]SparseImageMemoryRequirements2,
) callconv(vulkan_call_conv) void;
pub const PfnCreateSamplerYcbcrConversion = fn (
    device: Device,
    pCreateInfo: *const SamplerYcbcrConversionCreateInfo,
    pAllocator: ?*const AllocationCallbacks,
    pYcbcrConversion: *SamplerYcbcrConversion,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroySamplerYcbcrConversion = fn (
    device: Device,
    ycbcrConversion: SamplerYcbcrConversion,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeviceQueue2 = fn (
    device: Device,
    pQueueInfo: *const DeviceQueueInfo2,
    pQueue: *Queue,
) callconv(vulkan_call_conv) void;
pub const PfnCreateValidationCacheEXT = fn (
    device: Device,
    pCreateInfo: *const ValidationCacheCreateInfoEXT,
    pAllocator: ?*const AllocationCallbacks,
    pValidationCache: *ValidationCacheEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyValidationCacheEXT = fn (
    device: Device,
    validationCache: ValidationCacheEXT,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetValidationCacheDataEXT = fn (
    device: Device,
    validationCache: ValidationCacheEXT,
    pDataSize: *usize,
    pData: ?*c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnMergeValidationCachesEXT = fn (
    device: Device,
    dstCache: ValidationCacheEXT,
    srcCacheCount: u32,
    pSrcCaches: [*]const ValidationCacheEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDescriptorSetLayoutSupport = fn (
    device: Device,
    pCreateInfo: *const DescriptorSetLayoutCreateInfo,
    pSupport: *DescriptorSetLayoutSupport,
) callconv(vulkan_call_conv) void;
pub const PfnGetSwapchainGrallocUsageANDROID = fn (
    device: Device,
    format: Format,
    imageUsage: ImageUsageFlags.IntType,
    grallocUsage: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnGetSwapchainGrallocUsage2ANDROID = fn (
    device: Device,
    format: Format,
    imageUsage: ImageUsageFlags.IntType,
    swapchainImageUsage: SwapchainImageUsageFlagsANDROID.IntType,
    grallocConsumerUsage: *u64,
    grallocProducerUsage: *u64,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquireImageANDROID = fn (
    device: Device,
    image: Image,
    nativeFenceFd: c_int,
    semaphore: Semaphore,
    fence: Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnQueueSignalReleaseImageANDROID = fn (
    queue: Queue,
    waitSemaphoreCount: u32,
    pWaitSemaphores: [*]const Semaphore,
    image: Image,
    pNativeFenceFd: *c_int,
) callconv(vulkan_call_conv) Result;
pub const PfnGetShaderInfoAMD = fn (
    device: Device,
    pipeline: Pipeline,
    shaderStage: ShaderStageFlags.IntType,
    infoType: ShaderInfoTypeAMD,
    pInfoSize: *usize,
    pInfo: ?*c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnSetLocalDimmingAMD = fn (
    device: Device,
    swapChain: SwapchainKHR,
    localDimmingEnable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceCalibrateableTimeDomainsEXT = fn (
    physicalDevice: PhysicalDevice,
    pTimeDomainCount: *u32,
    pTimeDomains: ?[*]TimeDomainEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnGetCalibratedTimestampsEXT = fn (
    device: Device,
    timestampCount: u32,
    pTimestampInfos: [*]const CalibratedTimestampInfoEXT,
    pTimestamps: [*]u64,
    pMaxDeviation: *u64,
) callconv(vulkan_call_conv) Result;
pub const PfnSetDebugUtilsObjectNameEXT = fn (
    device: Device,
    pNameInfo: *const DebugUtilsObjectNameInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnSetDebugUtilsObjectTagEXT = fn (
    device: Device,
    pTagInfo: *const DebugUtilsObjectTagInfoEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnQueueBeginDebugUtilsLabelEXT = fn (
    queue: Queue,
    pLabelInfo: *const DebugUtilsLabelEXT,
) callconv(vulkan_call_conv) void;
pub const PfnQueueEndDebugUtilsLabelEXT = fn (
    queue: Queue,
) callconv(vulkan_call_conv) void;
pub const PfnQueueInsertDebugUtilsLabelEXT = fn (
    queue: Queue,
    pLabelInfo: *const DebugUtilsLabelEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginDebugUtilsLabelEXT = fn (
    commandBuffer: CommandBuffer,
    pLabelInfo: *const DebugUtilsLabelEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndDebugUtilsLabelEXT = fn (
    commandBuffer: CommandBuffer,
) callconv(vulkan_call_conv) void;
pub const PfnCmdInsertDebugUtilsLabelEXT = fn (
    commandBuffer: CommandBuffer,
    pLabelInfo: *const DebugUtilsLabelEXT,
) callconv(vulkan_call_conv) void;
pub const PfnCreateDebugUtilsMessengerEXT = fn (
    instance: Instance,
    pCreateInfo: *const DebugUtilsMessengerCreateInfoEXT,
    pAllocator: ?*const AllocationCallbacks,
    pMessenger: *DebugUtilsMessengerEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDebugUtilsMessengerEXT = fn (
    instance: Instance,
    messenger: DebugUtilsMessengerEXT,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnSubmitDebugUtilsMessageEXT = fn (
    instance: Instance,
    messageSeverity: DebugUtilsMessageSeverityFlagsEXT.IntType,
    messageTypes: DebugUtilsMessageTypeFlagsEXT.IntType,
    pCallbackData: *const DebugUtilsMessengerCallbackDataEXT,
) callconv(vulkan_call_conv) void;
pub const PfnGetMemoryHostPointerPropertiesEXT = fn (
    device: Device,
    handleType: ExternalMemoryHandleTypeFlags.IntType,
    pHostPointer: *const c_void,
    pMemoryHostPointerProperties: *MemoryHostPointerPropertiesEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdWriteBufferMarkerAMD = fn (
    commandBuffer: CommandBuffer,
    pipelineStage: PipelineStageFlags.IntType,
    dstBuffer: Buffer,
    dstOffset: DeviceSize,
    marker: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCreateRenderPass2 = fn (
    device: Device,
    pCreateInfo: *const RenderPassCreateInfo2,
    pAllocator: ?*const AllocationCallbacks,
    pRenderPass: *RenderPass,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdBeginRenderPass2 = fn (
    commandBuffer: CommandBuffer,
    pRenderPassBegin: *const RenderPassBeginInfo,
    pSubpassBeginInfo: *const SubpassBeginInfo,
) callconv(vulkan_call_conv) void;
pub const PfnCmdNextSubpass2 = fn (
    commandBuffer: CommandBuffer,
    pSubpassBeginInfo: *const SubpassBeginInfo,
    pSubpassEndInfo: *const SubpassEndInfo,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndRenderPass2 = fn (
    commandBuffer: CommandBuffer,
    pSubpassEndInfo: *const SubpassEndInfo,
) callconv(vulkan_call_conv) void;
pub const PfnGetSemaphoreCounterValue = fn (
    device: Device,
    semaphore: Semaphore,
    pValue: *u64,
) callconv(vulkan_call_conv) Result;
pub const PfnWaitSemaphores = fn (
    device: Device,
    pWaitInfo: *const SemaphoreWaitInfo,
    timeout: u64,
) callconv(vulkan_call_conv) Result;
pub const PfnSignalSemaphore = fn (
    device: Device,
    pSignalInfo: *const SemaphoreSignalInfo,
) callconv(vulkan_call_conv) Result;
pub const PfnGetAndroidHardwareBufferPropertiesANDROID = fn (
    device: Device,
    buffer: *const AHardwareBuffer,
    pProperties: *AndroidHardwareBufferPropertiesANDROID,
) callconv(vulkan_call_conv) Result;
pub const PfnGetMemoryAndroidHardwareBufferANDROID = fn (
    device: Device,
    pInfo: *const MemoryGetAndroidHardwareBufferInfoANDROID,
    pBuffer: **AHardwareBuffer,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdDrawIndirectCount = fn (
    commandBuffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    countBuffer: Buffer,
    countBufferOffset: DeviceSize,
    maxDrawCount: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndexedIndirectCount = fn (
    commandBuffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    countBuffer: Buffer,
    countBufferOffset: DeviceSize,
    maxDrawCount: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetCheckpointNV = fn (
    commandBuffer: CommandBuffer,
    pCheckpointMarker: *const c_void,
) callconv(vulkan_call_conv) void;
pub const PfnGetQueueCheckpointDataNV = fn (
    queue: Queue,
    pCheckpointDataCount: *u32,
    pCheckpointData: ?[*]CheckpointDataNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindTransformFeedbackBuffersEXT = fn (
    commandBuffer: CommandBuffer,
    firstBinding: u32,
    bindingCount: u32,
    pBuffers: [*]const Buffer,
    pOffsets: [*]const DeviceSize,
    pSizes: ?[*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginTransformFeedbackEXT = fn (
    commandBuffer: CommandBuffer,
    firstCounterBuffer: u32,
    counterBufferCount: u32,
    pCounterBuffers: [*]const Buffer,
    pCounterBufferOffsets: ?[*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndTransformFeedbackEXT = fn (
    commandBuffer: CommandBuffer,
    firstCounterBuffer: u32,
    counterBufferCount: u32,
    pCounterBuffers: [*]const Buffer,
    pCounterBufferOffsets: ?[*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginQueryIndexedEXT = fn (
    commandBuffer: CommandBuffer,
    queryPool: QueryPool,
    query: u32,
    flags: QueryControlFlags.IntType,
    index: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndQueryIndexedEXT = fn (
    commandBuffer: CommandBuffer,
    queryPool: QueryPool,
    query: u32,
    index: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawIndirectByteCountEXT = fn (
    commandBuffer: CommandBuffer,
    instanceCount: u32,
    firstInstance: u32,
    counterBuffer: Buffer,
    counterBufferOffset: DeviceSize,
    counterOffset: u32,
    vertexStride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetExclusiveScissorNV = fn (
    commandBuffer: CommandBuffer,
    firstExclusiveScissor: u32,
    exclusiveScissorCount: u32,
    pExclusiveScissors: [*]const Rect2D,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindShadingRateImageNV = fn (
    commandBuffer: CommandBuffer,
    imageView: ImageView,
    imageLayout: ImageLayout,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetViewportShadingRatePaletteNV = fn (
    commandBuffer: CommandBuffer,
    firstViewport: u32,
    viewportCount: u32,
    pShadingRatePalettes: [*]const ShadingRatePaletteNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetCoarseSampleOrderNV = fn (
    commandBuffer: CommandBuffer,
    sampleOrderType: CoarseSampleOrderTypeNV,
    customSampleOrderCount: u32,
    pCustomSampleOrders: [*]const CoarseSampleOrderCustomNV,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawMeshTasksNV = fn (
    commandBuffer: CommandBuffer,
    taskCount: u32,
    firstTask: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawMeshTasksIndirectNV = fn (
    commandBuffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    drawCount: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdDrawMeshTasksIndirectCountNV = fn (
    commandBuffer: CommandBuffer,
    buffer: Buffer,
    offset: DeviceSize,
    countBuffer: Buffer,
    countBufferOffset: DeviceSize,
    maxDrawCount: u32,
    stride: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCompileDeferredNV = fn (
    device: Device,
    pipeline: Pipeline,
    shader: u32,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateAccelerationStructureNV = fn (
    device: Device,
    pCreateInfo: *const AccelerationStructureCreateInfoNV,
    pAllocator: ?*const AllocationCallbacks,
    pAccelerationStructure: *AccelerationStructureNV,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdBindInvocationMaskHUAWEI = fn (
    commandBuffer: CommandBuffer,
    imageView: ImageView,
    imageLayout: ImageLayout,
) callconv(vulkan_call_conv) void;
pub const PfnDestroyAccelerationStructureKHR = fn (
    device: Device,
    accelerationStructure: AccelerationStructureKHR,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnDestroyAccelerationStructureNV = fn (
    device: Device,
    accelerationStructure: AccelerationStructureNV,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetAccelerationStructureMemoryRequirementsNV = fn (
    device: Device,
    pInfo: *const AccelerationStructureMemoryRequirementsInfoNV,
    pMemoryRequirements: *MemoryRequirements2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnBindAccelerationStructureMemoryNV = fn (
    device: Device,
    bindInfoCount: u32,
    pBindInfos: [*]const BindAccelerationStructureMemoryInfoNV,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdCopyAccelerationStructureNV = fn (
    commandBuffer: CommandBuffer,
    dst: AccelerationStructureNV,
    src: AccelerationStructureNV,
    mode: CopyAccelerationStructureModeKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyAccelerationStructureKHR = fn (
    commandBuffer: CommandBuffer,
    pInfo: *const CopyAccelerationStructureInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCopyAccelerationStructureKHR = fn (
    device: Device,
    deferredOperation: DeferredOperationKHR,
    pInfo: *const CopyAccelerationStructureInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdCopyAccelerationStructureToMemoryKHR = fn (
    commandBuffer: CommandBuffer,
    pInfo: *const CopyAccelerationStructureToMemoryInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCopyAccelerationStructureToMemoryKHR = fn (
    device: Device,
    deferredOperation: DeferredOperationKHR,
    pInfo: *const CopyAccelerationStructureToMemoryInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdCopyMemoryToAccelerationStructureKHR = fn (
    commandBuffer: CommandBuffer,
    pInfo: *const CopyMemoryToAccelerationStructureInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCopyMemoryToAccelerationStructureKHR = fn (
    device: Device,
    deferredOperation: DeferredOperationKHR,
    pInfo: *const CopyMemoryToAccelerationStructureInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdWriteAccelerationStructuresPropertiesKHR = fn (
    commandBuffer: CommandBuffer,
    accelerationStructureCount: u32,
    pAccelerationStructures: [*]const AccelerationStructureKHR,
    queryType: QueryType,
    queryPool: QueryPool,
    firstQuery: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdWriteAccelerationStructuresPropertiesNV = fn (
    commandBuffer: CommandBuffer,
    accelerationStructureCount: u32,
    pAccelerationStructures: [*]const AccelerationStructureNV,
    queryType: QueryType,
    queryPool: QueryPool,
    firstQuery: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBuildAccelerationStructureNV = fn (
    commandBuffer: CommandBuffer,
    pInfo: *const AccelerationStructureInfoNV,
    instanceData: Buffer,
    instanceOffset: DeviceSize,
    update: Bool32,
    dst: AccelerationStructureNV,
    src: AccelerationStructureNV,
    scratch: Buffer,
    scratchOffset: DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnWriteAccelerationStructuresPropertiesKHR = fn (
    device: Device,
    accelerationStructureCount: u32,
    pAccelerationStructures: [*]const AccelerationStructureKHR,
    queryType: QueryType,
    dataSize: usize,
    pData: *c_void,
    stride: usize,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdTraceRaysKHR = fn (
    commandBuffer: CommandBuffer,
    pRaygenShaderBindingTable: *const StridedDeviceAddressRegionKHR,
    pMissShaderBindingTable: *const StridedDeviceAddressRegionKHR,
    pHitShaderBindingTable: *const StridedDeviceAddressRegionKHR,
    pCallableShaderBindingTable: *const StridedDeviceAddressRegionKHR,
    width: u32,
    height: u32,
    depth: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdTraceRaysNV = fn (
    commandBuffer: CommandBuffer,
    raygenShaderBindingTableBuffer: Buffer,
    raygenShaderBindingOffset: DeviceSize,
    missShaderBindingTableBuffer: Buffer,
    missShaderBindingOffset: DeviceSize,
    missShaderBindingStride: DeviceSize,
    hitShaderBindingTableBuffer: Buffer,
    hitShaderBindingOffset: DeviceSize,
    hitShaderBindingStride: DeviceSize,
    callableShaderBindingTableBuffer: Buffer,
    callableShaderBindingOffset: DeviceSize,
    callableShaderBindingStride: DeviceSize,
    width: u32,
    height: u32,
    depth: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetRayTracingShaderGroupHandlesKHR = fn (
    device: Device,
    pipeline: Pipeline,
    firstGroup: u32,
    groupCount: u32,
    dataSize: usize,
    pData: *c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnGetRayTracingCaptureReplayShaderGroupHandlesKHR = fn (
    device: Device,
    pipeline: Pipeline,
    firstGroup: u32,
    groupCount: u32,
    dataSize: usize,
    pData: *c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnGetAccelerationStructureHandleNV = fn (
    device: Device,
    accelerationStructure: AccelerationStructureNV,
    dataSize: usize,
    pData: *c_void,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateRayTracingPipelinesNV = fn (
    device: Device,
    pipelineCache: PipelineCache,
    createInfoCount: u32,
    pCreateInfos: [*]const RayTracingPipelineCreateInfoNV,
    pAllocator: ?*const AllocationCallbacks,
    pPipelines: [*]Pipeline,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateRayTracingPipelinesKHR = fn (
    device: Device,
    deferredOperation: DeferredOperationKHR,
    pipelineCache: PipelineCache,
    createInfoCount: u32,
    pCreateInfos: [*]const RayTracingPipelineCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pPipelines: [*]Pipeline,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceCooperativeMatrixPropertiesNV = fn (
    physicalDevice: PhysicalDevice,
    pPropertyCount: *u32,
    pProperties: ?[*]CooperativeMatrixPropertiesNV,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdTraceRaysIndirectKHR = fn (
    commandBuffer: CommandBuffer,
    pRaygenShaderBindingTable: *const StridedDeviceAddressRegionKHR,
    pMissShaderBindingTable: *const StridedDeviceAddressRegionKHR,
    pHitShaderBindingTable: *const StridedDeviceAddressRegionKHR,
    pCallableShaderBindingTable: *const StridedDeviceAddressRegionKHR,
    indirectDeviceAddress: DeviceAddress,
) callconv(vulkan_call_conv) void;
pub const PfnGetDeviceAccelerationStructureCompatibilityKHR = fn (
    device: Device,
    pVersionInfo: *const AccelerationStructureVersionInfoKHR,
    pCompatibility: *AccelerationStructureCompatibilityKHR,
) callconv(vulkan_call_conv) void;
pub const PfnGetRayTracingShaderGroupStackSizeKHR = fn (
    device: Device,
    pipeline: Pipeline,
    group: u32,
    groupShader: ShaderGroupShaderKHR,
) callconv(vulkan_call_conv) DeviceSize;
pub const PfnCmdSetRayTracingPipelineStackSizeKHR = fn (
    commandBuffer: CommandBuffer,
    pipelineStackSize: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageViewHandleNVX = fn (
    device: Device,
    pInfo: *const ImageViewHandleInfoNVX,
) callconv(vulkan_call_conv) u32;
pub const PfnGetImageViewAddressNVX = fn (
    device: Device,
    imageView: ImageView,
    pProperties: *ImageViewAddressPropertiesNVX,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSurfacePresentModes2EXT = fn (
    physicalDevice: PhysicalDevice,
    pSurfaceInfo: *const PhysicalDeviceSurfaceInfo2KHR,
    pPresentModeCount: *u32,
    pPresentModes: ?[*]PresentModeKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceGroupSurfacePresentModes2EXT = fn (
    device: Device,
    pSurfaceInfo: *const PhysicalDeviceSurfaceInfo2KHR,
    pModes: *DeviceGroupPresentModeFlagsKHR,
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
    physicalDevice: PhysicalDevice,
    queueFamilyIndex: u32,
    pCounterCount: *u32,
    pCounters: ?[*]PerformanceCounterKHR,
    pCounterDescriptions: ?[*]PerformanceCounterDescriptionKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR = fn (
    physicalDevice: PhysicalDevice,
    pPerformanceQueryCreateInfo: *const QueryPoolPerformanceCreateInfoKHR,
    pNumPasses: *u32,
) callconv(vulkan_call_conv) void;
pub const PfnAcquireProfilingLockKHR = fn (
    device: Device,
    pInfo: *const AcquireProfilingLockInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnReleaseProfilingLockKHR = fn (
    device: Device,
) callconv(vulkan_call_conv) void;
pub const PfnGetImageDrmFormatModifierPropertiesEXT = fn (
    device: Device,
    image: Image,
    pProperties: *ImageDrmFormatModifierPropertiesEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnGetBufferOpaqueCaptureAddress = fn (
    device: Device,
    pInfo: *const BufferDeviceAddressInfo,
) callconv(vulkan_call_conv) u64;
pub const PfnGetBufferDeviceAddress = fn (
    device: Device,
    pInfo: *const BufferDeviceAddressInfo,
) callconv(vulkan_call_conv) DeviceAddress;
pub const PfnCreateHeadlessSurfaceEXT = fn (
    instance: Instance,
    pCreateInfo: *const HeadlessSurfaceCreateInfoEXT,
    pAllocator: ?*const AllocationCallbacks,
    pSurface: *SurfaceKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV = fn (
    physicalDevice: PhysicalDevice,
    pCombinationCount: *u32,
    pCombinations: ?[*]FramebufferMixedSamplesCombinationNV,
) callconv(vulkan_call_conv) Result;
pub const PfnInitializePerformanceApiINTEL = fn (
    device: Device,
    pInitializeInfo: *const InitializePerformanceApiInfoINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnUninitializePerformanceApiINTEL = fn (
    device: Device,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetPerformanceMarkerINTEL = fn (
    commandBuffer: CommandBuffer,
    pMarkerInfo: *const PerformanceMarkerInfoINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetPerformanceStreamMarkerINTEL = fn (
    commandBuffer: CommandBuffer,
    pMarkerInfo: *const PerformanceStreamMarkerInfoINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetPerformanceOverrideINTEL = fn (
    commandBuffer: CommandBuffer,
    pOverrideInfo: *const PerformanceOverrideInfoINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnAcquirePerformanceConfigurationINTEL = fn (
    device: Device,
    pAcquireInfo: *const PerformanceConfigurationAcquireInfoINTEL,
    pConfiguration: *PerformanceConfigurationINTEL,
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
    pValue: *PerformanceValueINTEL,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDeviceMemoryOpaqueCaptureAddress = fn (
    device: Device,
    pInfo: *const DeviceMemoryOpaqueCaptureAddressInfo,
) callconv(vulkan_call_conv) u64;
pub const PfnGetPipelineExecutablePropertiesKHR = fn (
    device: Device,
    pPipelineInfo: *const PipelineInfoKHR,
    pExecutableCount: *u32,
    pProperties: ?[*]PipelineExecutablePropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPipelineExecutableStatisticsKHR = fn (
    device: Device,
    pExecutableInfo: *const PipelineExecutableInfoKHR,
    pStatisticCount: *u32,
    pStatistics: ?[*]PipelineExecutableStatisticKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPipelineExecutableInternalRepresentationsKHR = fn (
    device: Device,
    pExecutableInfo: *const PipelineExecutableInfoKHR,
    pInternalRepresentationCount: *u32,
    pInternalRepresentations: ?[*]PipelineExecutableInternalRepresentationKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetLineStippleEXT = fn (
    commandBuffer: CommandBuffer,
    lineStippleFactor: u32,
    lineStipplePattern: u16,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceToolPropertiesEXT = fn (
    physicalDevice: PhysicalDevice,
    pToolCount: *u32,
    pToolProperties: ?[*]PhysicalDeviceToolPropertiesEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateAccelerationStructureKHR = fn (
    device: Device,
    pCreateInfo: *const AccelerationStructureCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pAccelerationStructure: *AccelerationStructureKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdBuildAccelerationStructuresKHR = fn (
    commandBuffer: CommandBuffer,
    infoCount: u32,
    pInfos: [*]const AccelerationStructureBuildGeometryInfoKHR,
    ppBuildRangeInfos: [*]const *const AccelerationStructureBuildRangeInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBuildAccelerationStructuresIndirectKHR = fn (
    commandBuffer: CommandBuffer,
    infoCount: u32,
    pInfos: [*]const AccelerationStructureBuildGeometryInfoKHR,
    pIndirectDeviceAddresses: [*]const DeviceAddress,
    pIndirectStrides: [*]const u32,
    ppMaxPrimitiveCounts: [*]const *const u32,
) callconv(vulkan_call_conv) void;
pub const PfnBuildAccelerationStructuresKHR = fn (
    device: Device,
    deferredOperation: DeferredOperationKHR,
    infoCount: u32,
    pInfos: [*]const AccelerationStructureBuildGeometryInfoKHR,
    ppBuildRangeInfos: [*]const *const AccelerationStructureBuildRangeInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetAccelerationStructureDeviceAddressKHR = fn (
    device: Device,
    pInfo: *const AccelerationStructureDeviceAddressInfoKHR,
) callconv(vulkan_call_conv) DeviceAddress;
pub const PfnCreateDeferredOperationKHR = fn (
    device: Device,
    pAllocator: ?*const AllocationCallbacks,
    pDeferredOperation: *DeferredOperationKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyDeferredOperationKHR = fn (
    device: Device,
    operation: DeferredOperationKHR,
    pAllocator: ?*const AllocationCallbacks,
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
    commandBuffer: CommandBuffer,
    cullMode: CullModeFlags.IntType,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetFrontFaceEXT = fn (
    commandBuffer: CommandBuffer,
    frontFace: FrontFace,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetPrimitiveTopologyEXT = fn (
    commandBuffer: CommandBuffer,
    primitiveTopology: PrimitiveTopology,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetViewportWithCountEXT = fn (
    commandBuffer: CommandBuffer,
    viewportCount: u32,
    pViewports: [*]const Viewport,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetScissorWithCountEXT = fn (
    commandBuffer: CommandBuffer,
    scissorCount: u32,
    pScissors: [*]const Rect2D,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBindVertexBuffers2EXT = fn (
    commandBuffer: CommandBuffer,
    firstBinding: u32,
    bindingCount: u32,
    pBuffers: [*]const Buffer,
    pOffsets: [*]const DeviceSize,
    pSizes: ?[*]const DeviceSize,
    pStrides: ?[*]const DeviceSize,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthTestEnableEXT = fn (
    commandBuffer: CommandBuffer,
    depthTestEnable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthWriteEnableEXT = fn (
    commandBuffer: CommandBuffer,
    depthWriteEnable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthCompareOpEXT = fn (
    commandBuffer: CommandBuffer,
    depthCompareOp: CompareOp,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthBoundsTestEnableEXT = fn (
    commandBuffer: CommandBuffer,
    depthBoundsTestEnable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilTestEnableEXT = fn (
    commandBuffer: CommandBuffer,
    stencilTestEnable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetStencilOpEXT = fn (
    commandBuffer: CommandBuffer,
    faceMask: StencilFaceFlags.IntType,
    failOp: StencilOp,
    passOp: StencilOp,
    depthFailOp: StencilOp,
    compareOp: CompareOp,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetPatchControlPointsEXT = fn (
    commandBuffer: CommandBuffer,
    patchControlPoints: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetRasterizerDiscardEnableEXT = fn (
    commandBuffer: CommandBuffer,
    rasterizerDiscardEnable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetDepthBiasEnableEXT = fn (
    commandBuffer: CommandBuffer,
    depthBiasEnable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetLogicOpEXT = fn (
    commandBuffer: CommandBuffer,
    logicOp: LogicOp,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetPrimitiveRestartEnableEXT = fn (
    commandBuffer: CommandBuffer,
    primitiveRestartEnable: Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCreatePrivateDataSlotEXT = fn (
    device: Device,
    pCreateInfo: *const PrivateDataSlotCreateInfoEXT,
    pAllocator: ?*const AllocationCallbacks,
    pPrivateDataSlot: *PrivateDataSlotEXT,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyPrivateDataSlotEXT = fn (
    device: Device,
    privateDataSlot: PrivateDataSlotEXT,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnSetPrivateDataEXT = fn (
    device: Device,
    objectType: ObjectType,
    objectHandle: u64,
    privateDataSlot: PrivateDataSlotEXT,
    data: u64,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPrivateDataEXT = fn (
    device: Device,
    objectType: ObjectType,
    objectHandle: u64,
    privateDataSlot: PrivateDataSlotEXT,
    pData: *u64,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyBuffer2KHR = fn (
    commandBuffer: CommandBuffer,
    pCopyBufferInfo: *const CopyBufferInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyImage2KHR = fn (
    commandBuffer: CommandBuffer,
    pCopyImageInfo: *const CopyImageInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBlitImage2KHR = fn (
    commandBuffer: CommandBuffer,
    pBlitImageInfo: *const BlitImageInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyBufferToImage2KHR = fn (
    commandBuffer: CommandBuffer,
    pCopyBufferToImageInfo: *const CopyBufferToImageInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCopyImageToBuffer2KHR = fn (
    commandBuffer: CommandBuffer,
    pCopyImageToBufferInfo: *const CopyImageToBufferInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdResolveImage2KHR = fn (
    commandBuffer: CommandBuffer,
    pResolveImageInfo: *const ResolveImageInfo2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetFragmentShadingRateKHR = fn (
    commandBuffer: CommandBuffer,
    pFragmentSize: *const Extent2D,
    combinerOps: [2]FragmentShadingRateCombinerOpKHR,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceFragmentShadingRatesKHR = fn (
    physicalDevice: PhysicalDevice,
    pFragmentShadingRateCount: *u32,
    pFragmentShadingRates: ?[*]PhysicalDeviceFragmentShadingRateKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdSetFragmentShadingRateEnumNV = fn (
    commandBuffer: CommandBuffer,
    shadingRate: FragmentShadingRateNV,
    combinerOps: [2]FragmentShadingRateCombinerOpKHR,
) callconv(vulkan_call_conv) void;
pub const PfnGetAccelerationStructureBuildSizesKHR = fn (
    device: Device,
    buildType: AccelerationStructureBuildTypeKHR,
    pBuildInfo: *const AccelerationStructureBuildGeometryInfoKHR,
    pMaxPrimitiveCounts: ?[*]const u32,
    pSizeInfo: *AccelerationStructureBuildSizesInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetVertexInputEXT = fn (
    commandBuffer: CommandBuffer,
    vertexBindingDescriptionCount: u32,
    pVertexBindingDescriptions: [*]const VertexInputBindingDescription2EXT,
    vertexAttributeDescriptionCount: u32,
    pVertexAttributeDescriptions: [*]const VertexInputAttributeDescription2EXT,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetColorWriteEnableEXT = fn (
    commandBuffer: CommandBuffer,
    attachmentCount: u32,
    pColorWriteEnables: [*]const Bool32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdSetEvent2KHR = fn (
    commandBuffer: CommandBuffer,
    event: Event,
    pDependencyInfo: *const DependencyInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdResetEvent2KHR = fn (
    commandBuffer: CommandBuffer,
    event: Event,
    stageMask: PipelineStageFlags2KHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdWaitEvents2KHR = fn (
    commandBuffer: CommandBuffer,
    eventCount: u32,
    pEvents: [*]const Event,
    pDependencyInfos: [*]const DependencyInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdPipelineBarrier2KHR = fn (
    commandBuffer: CommandBuffer,
    pDependencyInfo: *const DependencyInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnQueueSubmit2KHR = fn (
    queue: Queue,
    submitCount: u32,
    pSubmits: [*]const SubmitInfo2KHR,
    fence: Fence,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdWriteTimestamp2KHR = fn (
    commandBuffer: CommandBuffer,
    stage: PipelineStageFlags2KHR,
    queryPool: QueryPool,
    query: u32,
) callconv(vulkan_call_conv) void;
pub const PfnCmdWriteBufferMarker2AMD = fn (
    commandBuffer: CommandBuffer,
    stage: PipelineStageFlags2KHR,
    dstBuffer: Buffer,
    dstOffset: DeviceSize,
    marker: u32,
) callconv(vulkan_call_conv) void;
pub const PfnGetQueueCheckpointData2NV = fn (
    queue: Queue,
    pCheckpointDataCount: *u32,
    pCheckpointData: ?[*]CheckpointData2NV,
) callconv(vulkan_call_conv) void;
pub const PfnGetPhysicalDeviceVideoCapabilitiesKHR = fn (
    physicalDevice: PhysicalDevice,
    pVideoProfile: *const VideoProfileKHR,
    pCapabilities: *VideoCapabilitiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetPhysicalDeviceVideoFormatPropertiesKHR = fn (
    physicalDevice: PhysicalDevice,
    pVideoFormatInfo: *const PhysicalDeviceVideoFormatInfoKHR,
    pVideoFormatPropertyCount: *u32,
    pVideoFormatProperties: ?[*]VideoFormatPropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateVideoSessionKHR = fn (
    device: Device,
    pCreateInfo: *const VideoSessionCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pVideoSession: *VideoSessionKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyVideoSessionKHR = fn (
    device: Device,
    videoSession: VideoSessionKHR,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCreateVideoSessionParametersKHR = fn (
    device: Device,
    pCreateInfo: *const VideoSessionParametersCreateInfoKHR,
    pAllocator: ?*const AllocationCallbacks,
    pVideoSessionParameters: *VideoSessionParametersKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnUpdateVideoSessionParametersKHR = fn (
    device: Device,
    videoSessionParameters: VideoSessionParametersKHR,
    pUpdateInfo: *const VideoSessionParametersUpdateInfoKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyVideoSessionParametersKHR = fn (
    device: Device,
    videoSessionParameters: VideoSessionParametersKHR,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetVideoSessionMemoryRequirementsKHR = fn (
    device: Device,
    videoSession: VideoSessionKHR,
    pVideoSessionMemoryRequirementsCount: *u32,
    pVideoSessionMemoryRequirements: ?[*]VideoGetMemoryPropertiesKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnBindVideoSessionMemoryKHR = fn (
    device: Device,
    videoSession: VideoSessionKHR,
    videoSessionBindMemoryCount: u32,
    pVideoSessionBindMemories: [*]const VideoBindMemoryKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnCmdDecodeVideoKHR = fn (
    commandBuffer: CommandBuffer,
    pFrameInfo: *const VideoDecodeInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdBeginVideoCodingKHR = fn (
    commandBuffer: CommandBuffer,
    pBeginInfo: *const VideoBeginCodingInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdControlVideoCodingKHR = fn (
    commandBuffer: CommandBuffer,
    pCodingControlInfo: *const VideoCodingControlInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEndVideoCodingKHR = fn (
    commandBuffer: CommandBuffer,
    pEndCodingInfo: *const VideoEndCodingInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCmdEncodeVideoKHR = fn (
    commandBuffer: CommandBuffer,
    pEncodeInfo: *const VideoEncodeInfoKHR,
) callconv(vulkan_call_conv) void;
pub const PfnCreateCuModuleNVX = fn (
    device: Device,
    pCreateInfo: *const CuModuleCreateInfoNVX,
    pAllocator: ?*const AllocationCallbacks,
    pModule: *CuModuleNVX,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateCuFunctionNVX = fn (
    device: Device,
    pCreateInfo: *const CuFunctionCreateInfoNVX,
    pAllocator: ?*const AllocationCallbacks,
    pFunction: *CuFunctionNVX,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyCuModuleNVX = fn (
    device: Device,
    module: CuModuleNVX,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnDestroyCuFunctionNVX = fn (
    device: Device,
    function: CuFunctionNVX,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnCmdCuLaunchKernelNVX = fn (
    commandBuffer: CommandBuffer,
    pLaunchInfo: *const CuLaunchInfoNVX,
) callconv(vulkan_call_conv) void;
pub const PfnSetDeviceMemoryPriorityEXT = fn (
    device: Device,
    memory: DeviceMemory,
    priority: f32,
) callconv(vulkan_call_conv) void;
pub const PfnAcquireDrmDisplayEXT = fn (
    physicalDevice: PhysicalDevice,
    drmFd: i32,
    display: DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnGetDrmDisplayEXT = fn (
    physicalDevice: PhysicalDevice,
    drmFd: i32,
    connectorId: u32,
    display: *DisplayKHR,
) callconv(vulkan_call_conv) Result;
pub const PfnWaitForPresentKHR = fn (
    device: Device,
    swapchain: SwapchainKHR,
    presentId: u64,
    timeout: u64,
) callconv(vulkan_call_conv) Result;
pub const PfnCreateBufferCollectionFUCHSIA = fn (
    device: Device,
    pCreateInfo: *const BufferCollectionCreateInfoFUCHSIA,
    pAllocator: ?*const AllocationCallbacks,
    pCollection: *BufferCollectionFUCHSIA,
) callconv(vulkan_call_conv) Result;
pub const PfnSetBufferCollectionBufferConstraintsFUCHSIA = fn (
    device: Device,
    collection: BufferCollectionFUCHSIA,
    pBufferConstraintsInfo: *const BufferConstraintsInfoFUCHSIA,
) callconv(vulkan_call_conv) Result;
pub const PfnSetBufferCollectionImageConstraintsFUCHSIA = fn (
    device: Device,
    collection: BufferCollectionFUCHSIA,
    pImageConstraintsInfo: *const ImageConstraintsInfoFUCHSIA,
) callconv(vulkan_call_conv) Result;
pub const PfnDestroyBufferCollectionFUCHSIA = fn (
    device: Device,
    collection: BufferCollectionFUCHSIA,
    pAllocator: ?*const AllocationCallbacks,
) callconv(vulkan_call_conv) void;
pub const PfnGetBufferCollectionPropertiesFUCHSIA = fn (
    device: Device,
    collection: BufferCollectionFUCHSIA,
    pProperties: *BufferCollectionPropertiesFUCHSIA,
) callconv(vulkan_call_conv) Result;
pub const extension_info = struct {
    const Info = struct {
        name: [:0]const u8,
        version: u32,
    };
    pub const khrSurface = Info{
        .name = "VK_KHR_surface",
        .version = 25,
    };
    pub const khrSwapchain = Info{
        .name = "VK_KHR_swapchain",
        .version = 70,
    };
    pub const khrDisplay = Info{
        .name = "VK_KHR_display",
        .version = 23,
    };
    pub const khrDisplaySwapchain = Info{
        .name = "VK_KHR_display_swapchain",
        .version = 10,
    };
    pub const khrXlibSurface = Info{
        .name = "VK_KHR_xlib_surface",
        .version = 6,
    };
    pub const khrXcbSurface = Info{
        .name = "VK_KHR_xcb_surface",
        .version = 6,
    };
    pub const khrWaylandSurface = Info{
        .name = "VK_KHR_wayland_surface",
        .version = 6,
    };
    pub const khrAndroidSurface = Info{
        .name = "VK_KHR_android_surface",
        .version = 6,
    };
    pub const khrWin32Surface = Info{
        .name = "VK_KHR_win32_surface",
        .version = 6,
    };
    pub const extDebugReport = Info{
        .name = "VK_EXT_debug_report",
        .version = 10,
    };
    pub const nvGlslShader = Info{
        .name = "VK_NV_glsl_shader",
        .version = 1,
    };
    pub const extDepthRangeUnrestricted = Info{
        .name = "VK_EXT_depth_range_unrestricted",
        .version = 1,
    };
    pub const khrSamplerMirrorClampToEdge = Info{
        .name = "VK_KHR_sampler_mirror_clamp_to_edge",
        .version = 3,
    };
    pub const imgFilterCubic = Info{
        .name = "VK_IMG_filter_cubic",
        .version = 1,
    };
    pub const amdRasterizationOrder = Info{
        .name = "VK_AMD_rasterization_order",
        .version = 1,
    };
    pub const amdShaderTrinaryMinmax = Info{
        .name = "VK_AMD_shader_trinary_minmax",
        .version = 1,
    };
    pub const amdShaderExplicitVertexParameter = Info{
        .name = "VK_AMD_shader_explicit_vertex_parameter",
        .version = 1,
    };
    pub const extDebugMarker = Info{
        .name = "VK_EXT_debug_marker",
        .version = 4,
    };
    pub const khrVideoQueue = Info{
        .name = "VK_KHR_video_queue",
        .version = 2,
    };
    pub const khrVideoDecodeQueue = Info{
        .name = "VK_KHR_video_decode_queue",
        .version = 2,
    };
    pub const amdGcnShader = Info{
        .name = "VK_AMD_gcn_shader",
        .version = 1,
    };
    pub const nvDedicatedAllocation = Info{
        .name = "VK_NV_dedicated_allocation",
        .version = 1,
    };
    pub const extTransformFeedback = Info{
        .name = "VK_EXT_transform_feedback",
        .version = 1,
    };
    pub const nvxBinaryImport = Info{
        .name = "VK_NVX_binary_import",
        .version = 1,
    };
    pub const nvxImageViewHandle = Info{
        .name = "VK_NVX_image_view_handle",
        .version = 2,
    };
    pub const amdDrawIndirectCount = Info{
        .name = "VK_AMD_draw_indirect_count",
        .version = 2,
    };
    pub const amdNegativeViewportHeight = Info{
        .name = "VK_AMD_negative_viewport_height",
        .version = 1,
    };
    pub const amdGpuShaderHalfFloat = Info{
        .name = "VK_AMD_gpu_shader_half_float",
        .version = 2,
    };
    pub const amdShaderBallot = Info{
        .name = "VK_AMD_shader_ballot",
        .version = 1,
    };
    pub const extVideoEncodeH264 = Info{
        .name = "VK_EXT_video_encode_h264",
        .version = 2,
    };
    pub const extVideoEncodeH265 = Info{
        .name = "VK_EXT_video_encode_h265",
        .version = 2,
    };
    pub const extVideoDecodeH264 = Info{
        .name = "VK_EXT_video_decode_h264",
        .version = 3,
    };
    pub const amdTextureGatherBiasLod = Info{
        .name = "VK_AMD_texture_gather_bias_lod",
        .version = 1,
    };
    pub const amdShaderInfo = Info{
        .name = "VK_AMD_shader_info",
        .version = 1,
    };
    pub const amdShaderImageLoadStoreLod = Info{
        .name = "VK_AMD_shader_image_load_store_lod",
        .version = 1,
    };
    pub const ggpStreamDescriptorSurface = Info{
        .name = "VK_GGP_stream_descriptor_surface",
        .version = 1,
    };
    pub const nvCornerSampledImage = Info{
        .name = "VK_NV_corner_sampled_image",
        .version = 2,
    };
    pub const khrMultiview = Info{
        .name = "VK_KHR_multiview",
        .version = 1,
    };
    pub const imgFormatPvrtc = Info{
        .name = "VK_IMG_format_pvrtc",
        .version = 1,
    };
    pub const nvExternalMemoryCapabilities = Info{
        .name = "VK_NV_external_memory_capabilities",
        .version = 1,
    };
    pub const nvExternalMemory = Info{
        .name = "VK_NV_external_memory",
        .version = 1,
    };
    pub const nvExternalMemoryWin32 = Info{
        .name = "VK_NV_external_memory_win32",
        .version = 1,
    };
    pub const nvWin32KeyedMutex = Info{
        .name = "VK_NV_win32_keyed_mutex",
        .version = 2,
    };
    pub const khrGetPhysicalDeviceProperties2 = Info{
        .name = "VK_KHR_get_physical_device_properties2",
        .version = 2,
    };
    pub const khrDeviceGroup = Info{
        .name = "VK_KHR_device_group",
        .version = 4,
    };
    pub const extValidationFlags = Info{
        .name = "VK_EXT_validation_flags",
        .version = 2,
    };
    pub const nnViSurface = Info{
        .name = "VK_NN_vi_surface",
        .version = 1,
    };
    pub const khrShaderDrawParameters = Info{
        .name = "VK_KHR_shader_draw_parameters",
        .version = 1,
    };
    pub const extShaderSubgroupBallot = Info{
        .name = "VK_EXT_shader_subgroup_ballot",
        .version = 1,
    };
    pub const extShaderSubgroupVote = Info{
        .name = "VK_EXT_shader_subgroup_vote",
        .version = 1,
    };
    pub const extTextureCompressionAstcHdr = Info{
        .name = "VK_EXT_texture_compression_astc_hdr",
        .version = 1,
    };
    pub const extAstcDecodeMode = Info{
        .name = "VK_EXT_astc_decode_mode",
        .version = 1,
    };
    pub const khrMaintenance1 = Info{
        .name = "VK_KHR_maintenance1",
        .version = 2,
    };
    pub const khrDeviceGroupCreation = Info{
        .name = "VK_KHR_device_group_creation",
        .version = 1,
    };
    pub const khrExternalMemoryCapabilities = Info{
        .name = "VK_KHR_external_memory_capabilities",
        .version = 1,
    };
    pub const khrExternalMemory = Info{
        .name = "VK_KHR_external_memory",
        .version = 1,
    };
    pub const khrExternalMemoryWin32 = Info{
        .name = "VK_KHR_external_memory_win32",
        .version = 1,
    };
    pub const khrExternalMemoryFd = Info{
        .name = "VK_KHR_external_memory_fd",
        .version = 1,
    };
    pub const khrWin32KeyedMutex = Info{
        .name = "VK_KHR_win32_keyed_mutex",
        .version = 1,
    };
    pub const khrExternalSemaphoreCapabilities = Info{
        .name = "VK_KHR_external_semaphore_capabilities",
        .version = 1,
    };
    pub const khrExternalSemaphore = Info{
        .name = "VK_KHR_external_semaphore",
        .version = 1,
    };
    pub const khrExternalSemaphoreWin32 = Info{
        .name = "VK_KHR_external_semaphore_win32",
        .version = 1,
    };
    pub const khrExternalSemaphoreFd = Info{
        .name = "VK_KHR_external_semaphore_fd",
        .version = 1,
    };
    pub const khrPushDescriptor = Info{
        .name = "VK_KHR_push_descriptor",
        .version = 2,
    };
    pub const extConditionalRendering = Info{
        .name = "VK_EXT_conditional_rendering",
        .version = 2,
    };
    pub const khrShaderFloat16Int8 = Info{
        .name = "VK_KHR_shader_float16_int8",
        .version = 1,
    };
    pub const khr16BitStorage = Info{
        .name = "VK_KHR_16bit_storage",
        .version = 1,
    };
    pub const khrIncrementalPresent = Info{
        .name = "VK_KHR_incremental_present",
        .version = 2,
    };
    pub const khrDescriptorUpdateTemplate = Info{
        .name = "VK_KHR_descriptor_update_template",
        .version = 1,
    };
    pub const nvClipSpaceWScaling = Info{
        .name = "VK_NV_clip_space_w_scaling",
        .version = 1,
    };
    pub const extDirectModeDisplay = Info{
        .name = "VK_EXT_direct_mode_display",
        .version = 1,
    };
    pub const extAcquireXlibDisplay = Info{
        .name = "VK_EXT_acquire_xlib_display",
        .version = 1,
    };
    pub const extDisplaySurfaceCounter = Info{
        .name = "VK_EXT_display_surface_counter",
        .version = 1,
    };
    pub const extDisplayControl = Info{
        .name = "VK_EXT_display_control",
        .version = 1,
    };
    pub const googleDisplayTiming = Info{
        .name = "VK_GOOGLE_display_timing",
        .version = 1,
    };
    pub const nvSampleMaskOverrideCoverage = Info{
        .name = "VK_NV_sample_mask_override_coverage",
        .version = 1,
    };
    pub const nvGeometryShaderPassthrough = Info{
        .name = "VK_NV_geometry_shader_passthrough",
        .version = 1,
    };
    pub const nvViewportArray2 = Info{
        .name = "VK_NV_viewport_array2",
        .version = 1,
    };
    pub const nvxMultiviewPerViewAttributes = Info{
        .name = "VK_NVX_multiview_per_view_attributes",
        .version = 1,
    };
    pub const nvViewportSwizzle = Info{
        .name = "VK_NV_viewport_swizzle",
        .version = 1,
    };
    pub const extDiscardRectangles = Info{
        .name = "VK_EXT_discard_rectangles",
        .version = 1,
    };
    pub const extConservativeRasterization = Info{
        .name = "VK_EXT_conservative_rasterization",
        .version = 1,
    };
    pub const extDepthClipEnable = Info{
        .name = "VK_EXT_depth_clip_enable",
        .version = 1,
    };
    pub const extSwapchainColorspace = Info{
        .name = "VK_EXT_swapchain_colorspace",
        .version = 4,
    };
    pub const extHdrMetadata = Info{
        .name = "VK_EXT_hdr_metadata",
        .version = 2,
    };
    pub const khrImagelessFramebuffer = Info{
        .name = "VK_KHR_imageless_framebuffer",
        .version = 1,
    };
    pub const khrCreateRenderpass2 = Info{
        .name = "VK_KHR_create_renderpass2",
        .version = 1,
    };
    pub const khrSharedPresentableImage = Info{
        .name = "VK_KHR_shared_presentable_image",
        .version = 1,
    };
    pub const khrExternalFenceCapabilities = Info{
        .name = "VK_KHR_external_fence_capabilities",
        .version = 1,
    };
    pub const khrExternalFence = Info{
        .name = "VK_KHR_external_fence",
        .version = 1,
    };
    pub const khrExternalFenceWin32 = Info{
        .name = "VK_KHR_external_fence_win32",
        .version = 1,
    };
    pub const khrExternalFenceFd = Info{
        .name = "VK_KHR_external_fence_fd",
        .version = 1,
    };
    pub const khrPerformanceQuery = Info{
        .name = "VK_KHR_performance_query",
        .version = 1,
    };
    pub const khrMaintenance2 = Info{
        .name = "VK_KHR_maintenance2",
        .version = 1,
    };
    pub const khrGetSurfaceCapabilities2 = Info{
        .name = "VK_KHR_get_surface_capabilities2",
        .version = 1,
    };
    pub const khrVariablePointers = Info{
        .name = "VK_KHR_variable_pointers",
        .version = 1,
    };
    pub const khrGetDisplayProperties2 = Info{
        .name = "VK_KHR_get_display_properties2",
        .version = 1,
    };
    pub const mvkIosSurface = Info{
        .name = "VK_MVK_ios_surface",
        .version = 3,
    };
    pub const mvkMacosSurface = Info{
        .name = "VK_MVK_macos_surface",
        .version = 3,
    };
    pub const extExternalMemoryDmaBuf = Info{
        .name = "VK_EXT_external_memory_dma_buf",
        .version = 1,
    };
    pub const extQueueFamilyForeign = Info{
        .name = "VK_EXT_queue_family_foreign",
        .version = 1,
    };
    pub const khrDedicatedAllocation = Info{
        .name = "VK_KHR_dedicated_allocation",
        .version = 3,
    };
    pub const extDebugUtils = Info{
        .name = "VK_EXT_debug_utils",
        .version = 2,
    };
    pub const androidExternalMemoryAndroidHardwareBuffer = Info{
        .name = "VK_ANDROID_external_memory_android_hardware_buffer",
        .version = 4,
    };
    pub const extSamplerFilterMinmax = Info{
        .name = "VK_EXT_sampler_filter_minmax",
        .version = 2,
    };
    pub const khrStorageBufferStorageClass = Info{
        .name = "VK_KHR_storage_buffer_storage_class",
        .version = 1,
    };
    pub const amdGpuShaderInt16 = Info{
        .name = "VK_AMD_gpu_shader_int16",
        .version = 2,
    };
    pub const amdMixedAttachmentSamples = Info{
        .name = "VK_AMD_mixed_attachment_samples",
        .version = 1,
    };
    pub const amdShaderFragmentMask = Info{
        .name = "VK_AMD_shader_fragment_mask",
        .version = 1,
    };
    pub const extInlineUniformBlock = Info{
        .name = "VK_EXT_inline_uniform_block",
        .version = 1,
    };
    pub const extShaderStencilExport = Info{
        .name = "VK_EXT_shader_stencil_export",
        .version = 1,
    };
    pub const extSampleLocations = Info{
        .name = "VK_EXT_sample_locations",
        .version = 1,
    };
    pub const khrRelaxedBlockLayout = Info{
        .name = "VK_KHR_relaxed_block_layout",
        .version = 1,
    };
    pub const khrGetMemoryRequirements2 = Info{
        .name = "VK_KHR_get_memory_requirements2",
        .version = 1,
    };
    pub const khrImageFormatList = Info{
        .name = "VK_KHR_image_format_list",
        .version = 1,
    };
    pub const extBlendOperationAdvanced = Info{
        .name = "VK_EXT_blend_operation_advanced",
        .version = 2,
    };
    pub const nvFragmentCoverageToColor = Info{
        .name = "VK_NV_fragment_coverage_to_color",
        .version = 1,
    };
    pub const khrAccelerationStructure = Info{
        .name = "VK_KHR_acceleration_structure",
        .version = 13,
    };
    pub const khrRayTracingPipeline = Info{
        .name = "VK_KHR_ray_tracing_pipeline",
        .version = 1,
    };
    pub const khrRayQuery = Info{
        .name = "VK_KHR_ray_query",
        .version = 1,
    };
    pub const nvFramebufferMixedSamples = Info{
        .name = "VK_NV_framebuffer_mixed_samples",
        .version = 1,
    };
    pub const nvFillRectangle = Info{
        .name = "VK_NV_fill_rectangle",
        .version = 1,
    };
    pub const nvShaderSmBuiltins = Info{
        .name = "VK_NV_shader_sm_builtins",
        .version = 1,
    };
    pub const extPostDepthCoverage = Info{
        .name = "VK_EXT_post_depth_coverage",
        .version = 1,
    };
    pub const khrSamplerYcbcrConversion = Info{
        .name = "VK_KHR_sampler_ycbcr_conversion",
        .version = 14,
    };
    pub const khrBindMemory2 = Info{
        .name = "VK_KHR_bind_memory2",
        .version = 1,
    };
    pub const extImageDrmFormatModifier = Info{
        .name = "VK_EXT_image_drm_format_modifier",
        .version = 2,
    };
    pub const extValidationCache = Info{
        .name = "VK_EXT_validation_cache",
        .version = 1,
    };
    pub const extDescriptorIndexing = Info{
        .name = "VK_EXT_descriptor_indexing",
        .version = 2,
    };
    pub const extShaderViewportIndexLayer = Info{
        .name = "VK_EXT_shader_viewport_index_layer",
        .version = 1,
    };
    pub const khrPortabilitySubset = Info{
        .name = "VK_KHR_portability_subset",
        .version = 1,
    };
    pub const nvShadingRateImage = Info{
        .name = "VK_NV_shading_rate_image",
        .version = 3,
    };
    pub const nvRayTracing = Info{
        .name = "VK_NV_ray_tracing",
        .version = 3,
    };
    pub const nvRepresentativeFragmentTest = Info{
        .name = "VK_NV_representative_fragment_test",
        .version = 2,
    };
    pub const khrMaintenance3 = Info{
        .name = "VK_KHR_maintenance3",
        .version = 1,
    };
    pub const khrDrawIndirectCount = Info{
        .name = "VK_KHR_draw_indirect_count",
        .version = 1,
    };
    pub const extFilterCubic = Info{
        .name = "VK_EXT_filter_cubic",
        .version = 3,
    };
    pub const qcomRenderPassShaderResolve = Info{
        .name = "VK_QCOM_render_pass_shader_resolve",
        .version = 4,
    };
    pub const extGlobalPriority = Info{
        .name = "VK_EXT_global_priority",
        .version = 2,
    };
    pub const khrShaderSubgroupExtendedTypes = Info{
        .name = "VK_KHR_shader_subgroup_extended_types",
        .version = 1,
    };
    pub const khr8BitStorage = Info{
        .name = "VK_KHR_8bit_storage",
        .version = 1,
    };
    pub const extExternalMemoryHost = Info{
        .name = "VK_EXT_external_memory_host",
        .version = 1,
    };
    pub const amdBufferMarker = Info{
        .name = "VK_AMD_buffer_marker",
        .version = 1,
    };
    pub const khrShaderAtomicInt64 = Info{
        .name = "VK_KHR_shader_atomic_int64",
        .version = 1,
    };
    pub const khrShaderClock = Info{
        .name = "VK_KHR_shader_clock",
        .version = 1,
    };
    pub const amdPipelineCompilerControl = Info{
        .name = "VK_AMD_pipeline_compiler_control",
        .version = 1,
    };
    pub const extCalibratedTimestamps = Info{
        .name = "VK_EXT_calibrated_timestamps",
        .version = 2,
    };
    pub const amdShaderCoreProperties = Info{
        .name = "VK_AMD_shader_core_properties",
        .version = 2,
    };
    pub const extVideoDecodeH265 = Info{
        .name = "VK_EXT_video_decode_h265",
        .version = 1,
    };
    pub const amdMemoryOverallocationBehavior = Info{
        .name = "VK_AMD_memory_overallocation_behavior",
        .version = 1,
    };
    pub const extVertexAttributeDivisor = Info{
        .name = "VK_EXT_vertex_attribute_divisor",
        .version = 3,
    };
    pub const ggpFrameToken = Info{
        .name = "VK_GGP_frame_token",
        .version = 1,
    };
    pub const extPipelineCreationFeedback = Info{
        .name = "VK_EXT_pipeline_creation_feedback",
        .version = 1,
    };
    pub const khrDriverProperties = Info{
        .name = "VK_KHR_driver_properties",
        .version = 1,
    };
    pub const khrShaderFloatControls = Info{
        .name = "VK_KHR_shader_float_controls",
        .version = 4,
    };
    pub const nvShaderSubgroupPartitioned = Info{
        .name = "VK_NV_shader_subgroup_partitioned",
        .version = 1,
    };
    pub const khrDepthStencilResolve = Info{
        .name = "VK_KHR_depth_stencil_resolve",
        .version = 1,
    };
    pub const khrSwapchainMutableFormat = Info{
        .name = "VK_KHR_swapchain_mutable_format",
        .version = 1,
    };
    pub const nvComputeShaderDerivatives = Info{
        .name = "VK_NV_compute_shader_derivatives",
        .version = 1,
    };
    pub const nvMeshShader = Info{
        .name = "VK_NV_mesh_shader",
        .version = 1,
    };
    pub const nvFragmentShaderBarycentric = Info{
        .name = "VK_NV_fragment_shader_barycentric",
        .version = 1,
    };
    pub const nvShaderImageFootprint = Info{
        .name = "VK_NV_shader_image_footprint",
        .version = 2,
    };
    pub const nvScissorExclusive = Info{
        .name = "VK_NV_scissor_exclusive",
        .version = 1,
    };
    pub const nvDeviceDiagnosticCheckpoints = Info{
        .name = "VK_NV_device_diagnostic_checkpoints",
        .version = 2,
    };
    pub const khrTimelineSemaphore = Info{
        .name = "VK_KHR_timeline_semaphore",
        .version = 2,
    };
    pub const intelShaderIntegerFunctions2 = Info{
        .name = "VK_INTEL_shader_integer_functions2",
        .version = 1,
    };
    pub const intelPerformanceQuery = Info{
        .name = "VK_INTEL_performance_query",
        .version = 2,
    };
    pub const khrVulkanMemoryModel = Info{
        .name = "VK_KHR_vulkan_memory_model",
        .version = 3,
    };
    pub const extPciBusInfo = Info{
        .name = "VK_EXT_pci_bus_info",
        .version = 2,
    };
    pub const amdDisplayNativeHdr = Info{
        .name = "VK_AMD_display_native_hdr",
        .version = 1,
    };
    pub const fuchsiaImagepipeSurface = Info{
        .name = "VK_FUCHSIA_imagepipe_surface",
        .version = 1,
    };
    pub const khrShaderTerminateInvocation = Info{
        .name = "VK_KHR_shader_terminate_invocation",
        .version = 1,
    };
    pub const extMetalSurface = Info{
        .name = "VK_EXT_metal_surface",
        .version = 1,
    };
    pub const extFragmentDensityMap = Info{
        .name = "VK_EXT_fragment_density_map",
        .version = 2,
    };
    pub const extScalarBlockLayout = Info{
        .name = "VK_EXT_scalar_block_layout",
        .version = 1,
    };
    pub const googleHlslFunctionality1 = Info{
        .name = "VK_GOOGLE_hlsl_functionality1",
        .version = 1,
    };
    pub const googleDecorateString = Info{
        .name = "VK_GOOGLE_decorate_string",
        .version = 1,
    };
    pub const extSubgroupSizeControl = Info{
        .name = "VK_EXT_subgroup_size_control",
        .version = 2,
    };
    pub const khrFragmentShadingRate = Info{
        .name = "VK_KHR_fragment_shading_rate",
        .version = 2,
    };
    pub const amdShaderCoreProperties2 = Info{
        .name = "VK_AMD_shader_core_properties2",
        .version = 1,
    };
    pub const amdDeviceCoherentMemory = Info{
        .name = "VK_AMD_device_coherent_memory",
        .version = 1,
    };
    pub const extShaderImageAtomicInt64 = Info{
        .name = "VK_EXT_shader_image_atomic_int64",
        .version = 1,
    };
    pub const khrSpirv14 = Info{
        .name = "VK_KHR_spirv_1_4",
        .version = 1,
    };
    pub const extMemoryBudget = Info{
        .name = "VK_EXT_memory_budget",
        .version = 1,
    };
    pub const extMemoryPriority = Info{
        .name = "VK_EXT_memory_priority",
        .version = 1,
    };
    pub const khrSurfaceProtectedCapabilities = Info{
        .name = "VK_KHR_surface_protected_capabilities",
        .version = 1,
    };
    pub const nvDedicatedAllocationImageAliasing = Info{
        .name = "VK_NV_dedicated_allocation_image_aliasing",
        .version = 1,
    };
    pub const khrSeparateDepthStencilLayouts = Info{
        .name = "VK_KHR_separate_depth_stencil_layouts",
        .version = 1,
    };
    pub const extBufferDeviceAddress = Info{
        .name = "VK_EXT_buffer_device_address",
        .version = 2,
    };
    pub const extToolingInfo = Info{
        .name = "VK_EXT_tooling_info",
        .version = 1,
    };
    pub const extSeparateStencilUsage = Info{
        .name = "VK_EXT_separate_stencil_usage",
        .version = 1,
    };
    pub const extValidationFeatures = Info{
        .name = "VK_EXT_validation_features",
        .version = 5,
    };
    pub const khrPresentWait = Info{
        .name = "VK_KHR_present_wait",
        .version = 1,
    };
    pub const nvCooperativeMatrix = Info{
        .name = "VK_NV_cooperative_matrix",
        .version = 1,
    };
    pub const nvCoverageReductionMode = Info{
        .name = "VK_NV_coverage_reduction_mode",
        .version = 1,
    };
    pub const extFragmentShaderInterlock = Info{
        .name = "VK_EXT_fragment_shader_interlock",
        .version = 1,
    };
    pub const extYcbcrImageArrays = Info{
        .name = "VK_EXT_ycbcr_image_arrays",
        .version = 1,
    };
    pub const khrUniformBufferStandardLayout = Info{
        .name = "VK_KHR_uniform_buffer_standard_layout",
        .version = 1,
    };
    pub const extProvokingVertex = Info{
        .name = "VK_EXT_provoking_vertex",
        .version = 1,
    };
    pub const extFullScreenExclusive = Info{
        .name = "VK_EXT_full_screen_exclusive",
        .version = 4,
    };
    pub const extHeadlessSurface = Info{
        .name = "VK_EXT_headless_surface",
        .version = 1,
    };
    pub const khrBufferDeviceAddress = Info{
        .name = "VK_KHR_buffer_device_address",
        .version = 1,
    };
    pub const extLineRasterization = Info{
        .name = "VK_EXT_line_rasterization",
        .version = 1,
    };
    pub const extShaderAtomicFloat = Info{
        .name = "VK_EXT_shader_atomic_float",
        .version = 1,
    };
    pub const extHostQueryReset = Info{
        .name = "VK_EXT_host_query_reset",
        .version = 1,
    };
    pub const extIndexTypeUint8 = Info{
        .name = "VK_EXT_index_type_uint8",
        .version = 1,
    };
    pub const extExtendedDynamicState = Info{
        .name = "VK_EXT_extended_dynamic_state",
        .version = 1,
    };
    pub const khrDeferredHostOperations = Info{
        .name = "VK_KHR_deferred_host_operations",
        .version = 4,
    };
    pub const khrPipelineExecutableProperties = Info{
        .name = "VK_KHR_pipeline_executable_properties",
        .version = 1,
    };
    pub const extShaderAtomicFloat2 = Info{
        .name = "VK_EXT_shader_atomic_float2",
        .version = 1,
    };
    pub const extShaderDemoteToHelperInvocation = Info{
        .name = "VK_EXT_shader_demote_to_helper_invocation",
        .version = 1,
    };
    pub const nvDeviceGeneratedCommands = Info{
        .name = "VK_NV_device_generated_commands",
        .version = 3,
    };
    pub const nvInheritedViewportScissor = Info{
        .name = "VK_NV_inherited_viewport_scissor",
        .version = 1,
    };
    pub const khrShaderIntegerDotProduct = Info{
        .name = "VK_KHR_shader_integer_dot_product",
        .version = 1,
    };
    pub const extTexelBufferAlignment = Info{
        .name = "VK_EXT_texel_buffer_alignment",
        .version = 1,
    };
    pub const qcomRenderPassTransform = Info{
        .name = "VK_QCOM_render_pass_transform",
        .version = 2,
    };
    pub const extDeviceMemoryReport = Info{
        .name = "VK_EXT_device_memory_report",
        .version = 2,
    };
    pub const extAcquireDrmDisplay = Info{
        .name = "VK_EXT_acquire_drm_display",
        .version = 1,
    };
    pub const extRobustness2 = Info{
        .name = "VK_EXT_robustness2",
        .version = 1,
    };
    pub const extCustomBorderColor = Info{
        .name = "VK_EXT_custom_border_color",
        .version = 12,
    };
    pub const googleUserType = Info{
        .name = "VK_GOOGLE_user_type",
        .version = 1,
    };
    pub const khrPipelineLibrary = Info{
        .name = "VK_KHR_pipeline_library",
        .version = 1,
    };
    pub const khrShaderNonSemanticInfo = Info{
        .name = "VK_KHR_shader_non_semantic_info",
        .version = 1,
    };
    pub const khrPresentId = Info{
        .name = "VK_KHR_present_id",
        .version = 1,
    };
    pub const extPrivateData = Info{
        .name = "VK_EXT_private_data",
        .version = 1,
    };
    pub const extPipelineCreationCacheControl = Info{
        .name = "VK_EXT_pipeline_creation_cache_control",
        .version = 3,
    };
    pub const khrVideoEncodeQueue = Info{
        .name = "VK_KHR_video_encode_queue",
        .version = 3,
    };
    pub const nvDeviceDiagnosticsConfig = Info{
        .name = "VK_NV_device_diagnostics_config",
        .version = 1,
    };
    pub const qcomRenderPassStoreOps = Info{
        .name = "VK_QCOM_render_pass_store_ops",
        .version = 2,
    };
    pub const khrSynchronization2 = Info{
        .name = "VK_KHR_synchronization2",
        .version = 1,
    };
    pub const khrShaderSubgroupUniformControlFlow = Info{
        .name = "VK_KHR_shader_subgroup_uniform_control_flow",
        .version = 1,
    };
    pub const khrZeroInitializeWorkgroupMemory = Info{
        .name = "VK_KHR_zero_initialize_workgroup_memory",
        .version = 1,
    };
    pub const nvFragmentShadingRateEnums = Info{
        .name = "VK_NV_fragment_shading_rate_enums",
        .version = 1,
    };
    pub const nvRayTracingMotionBlur = Info{
        .name = "VK_NV_ray_tracing_motion_blur",
        .version = 1,
    };
    pub const extYcbcr2Plane444Formats = Info{
        .name = "VK_EXT_ycbcr_2plane_444_formats",
        .version = 1,
    };
    pub const extFragmentDensityMap2 = Info{
        .name = "VK_EXT_fragment_density_map2",
        .version = 1,
    };
    pub const qcomRotatedCopyCommands = Info{
        .name = "VK_QCOM_rotated_copy_commands",
        .version = 1,
    };
    pub const extImageRobustness = Info{
        .name = "VK_EXT_image_robustness",
        .version = 1,
    };
    pub const khrWorkgroupMemoryExplicitLayout = Info{
        .name = "VK_KHR_workgroup_memory_explicit_layout",
        .version = 1,
    };
    pub const khrCopyCommands2 = Info{
        .name = "VK_KHR_copy_commands2",
        .version = 1,
    };
    pub const ext4444Formats = Info{
        .name = "VK_EXT_4444_formats",
        .version = 1,
    };
    pub const extRgba10X6Formats = Info{
        .name = "VK_EXT_rgba10x6_formats",
        .version = 1,
    };
    pub const nvAcquireWinrtDisplay = Info{
        .name = "VK_NV_acquire_winrt_display",
        .version = 1,
    };
    pub const extDirectfbSurface = Info{
        .name = "VK_EXT_directfb_surface",
        .version = 1,
    };
    pub const valveMutableDescriptorType = Info{
        .name = "VK_VALVE_mutable_descriptor_type",
        .version = 1,
    };
    pub const extVertexInputDynamicState = Info{
        .name = "VK_EXT_vertex_input_dynamic_state",
        .version = 2,
    };
    pub const extPhysicalDeviceDrm = Info{
        .name = "VK_EXT_physical_device_drm",
        .version = 1,
    };
    pub const extPrimitiveTopologyListRestart = Info{
        .name = "VK_EXT_primitive_topology_list_restart",
        .version = 1,
    };
    pub const khrFormatFeatureFlags2 = Info{
        .name = "VK_KHR_format_feature_flags2",
        .version = 1,
    };
    pub const fuchsiaExternalMemory = Info{
        .name = "VK_FUCHSIA_external_memory",
        .version = 1,
    };
    pub const fuchsiaExternalSemaphore = Info{
        .name = "VK_FUCHSIA_external_semaphore",
        .version = 1,
    };
    pub const fuchsiaBufferCollection = Info{
        .name = "VK_FUCHSIA_buffer_collection",
        .version = 2,
    };
    pub const huaweiSubpassShading = Info{
        .name = "VK_HUAWEI_subpass_shading",
        .version = 2,
    };
    pub const huaweiInvocationMask = Info{
        .name = "VK_HUAWEI_invocation_mask",
        .version = 1,
    };
    pub const nvExternalMemoryRdma = Info{
        .name = "VK_NV_external_memory_rdma",
        .version = 1,
    };
    pub const extExtendedDynamicState2 = Info{
        .name = "VK_EXT_extended_dynamic_state2",
        .version = 1,
    };
    pub const qnxScreenSurface = Info{
        .name = "VK_QNX_screen_surface",
        .version = 1,
    };
    pub const extColorWriteEnable = Info{
        .name = "VK_EXT_color_write_enable",
        .version = 1,
    };
    pub const extGlobalPriorityQuery = Info{
        .name = "VK_EXT_global_priority_query",
        .version = 1,
    };
    pub const extMultiDraw = Info{
        .name = "VK_EXT_multi_draw",
        .version = 1,
    };
    pub const extLoadStoreOpNone = Info{
        .name = "VK_EXT_load_store_op_none",
        .version = 1,
    };
    pub const extBorderColorSwizzle = Info{
        .name = "VK_EXT_border_color_swizzle",
        .version = 1,
    };
    pub const extPageableDeviceLocalMemory = Info{
        .name = "VK_EXT_pageable_device_local_memory",
        .version = 1,
    };
    pub const khrMaintenance4 = Info{
        .name = "VK_KHR_maintenance4",
        .version = 1,
    };
};
pub fn BaseWrapper(comptime cmds: []const BaseCommand) type {
    comptime var fields: [cmds.len]std.builtin.TypeInfo.StructField = undefined;
    inline for (cmds) |cmd, i| {
        const PfnType = cmd.PfnType();
        fields[i] = .{
            .name = cmd.symbol(),
            .field_type = PfnType,
            .default_value = null,
            .is_comptime = false,
            .alignment = @alignOf(PfnType),
        };
    }
    const Dispatch = @Type(.{
        .Struct = .{
            .layout = .Auto,
            .fields = &fields,
            .decls = &[_]std.builtin.TypeInfo.Declaration{},
            .is_tuple = false,
        },
    });
    return struct {
        dispatch: Dispatch,

        const Self = @This();
        pub fn load(loader: anytype) !Self {
            var self: Self = undefined;
            inline for (std.meta.fields(Dispatch)) |field| {
                const name = @ptrCast([*:0]const u8, field.name ++ "\x00");
                const cmd_ptr = loader(.null_handle, name) orelse return error.CommandLoadFailure;
                @field(self.dispatch, field.name) = @ptrCast(field.field_type, cmd_ptr);
            }
            return self;
        }
        pub const CreateInstanceError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            LayerNotPresent,
            ExtensionNotPresent,
            IncompatibleDriver,
            Unknown,
        };
        pub fn createInstance(
            self: Self,
            createInfo: InstanceCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateInstanceError!Instance {
            var instance: Instance = undefined;
            const result = self.dispatch.vkCreateInstance(
                &createInfo,
                pAllocator,
                &instance,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorLayerNotPresent => return error.LayerNotPresent,
                Result.errorExtensionNotPresent => return error.ExtensionNotPresent,
                Result.errorIncompatibleDriver => return error.IncompatibleDriver,
                else => return error.Unknown,
            }
            return instance;
        }
        pub fn getInstanceProcAddr(
            self: Self,
            instance: Instance,
            pName: [*:0]const u8,
        ) PfnVoidFunction {
            return self.dispatch.vkGetInstanceProcAddr(
                instance,
                pName,
            );
        }
        pub const EnumerateInstanceVersionError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn enumerateInstanceVersion(
            self: Self,
        ) EnumerateInstanceVersionError!u32 {
            var apiVersion: u32 = undefined;
            const result = self.dispatch.vkEnumerateInstanceVersion(
                &apiVersion,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return apiVersion;
        }
        pub const EnumerateInstanceLayerPropertiesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn enumerateInstanceLayerProperties(
            self: Self,
            pPropertyCount: *u32,
            pProperties: ?[*]LayerProperties,
        ) EnumerateInstanceLayerPropertiesError!Result {
            const result = self.dispatch.vkEnumerateInstanceLayerProperties(
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const EnumerateInstanceExtensionPropertiesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            LayerNotPresent,
            Unknown,
        };
        pub fn enumerateInstanceExtensionProperties(
            self: Self,
            pLayerName: ?[*:0]const u8,
            pPropertyCount: *u32,
            pProperties: ?[*]ExtensionProperties,
        ) EnumerateInstanceExtensionPropertiesError!Result {
            const result = self.dispatch.vkEnumerateInstanceExtensionProperties(
                pLayerName,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorLayerNotPresent => return error.LayerNotPresent,
                else => return error.Unknown,
            }
            return result;
        }
    };
}
pub fn InstanceWrapper(comptime cmds: []const InstanceCommand) type {
    comptime var fields: [cmds.len]std.builtin.TypeInfo.StructField = undefined;
    inline for (cmds) |cmd, i| {
        const PfnType = cmd.PfnType();
        fields[i] = .{
            .name = cmd.symbol(),
            .field_type = PfnType,
            .default_value = null,
            .is_comptime = false,
            .alignment = @alignOf(PfnType),
        };
    }
    const Dispatch = @Type(.{
        .Struct = .{
            .layout = .Auto,
            .fields = &fields,
            .decls = &[_]std.builtin.TypeInfo.Declaration{},
            .is_tuple = false,
        },
    });
    return struct {
        dispatch: Dispatch,

        const Self = @This();
        pub fn load(instance: Instance, loader: anytype) !Self {
            var self: Self = undefined;
            inline for (std.meta.fields(Dispatch)) |field| {
                const name = @ptrCast([*:0]const u8, field.name ++ "\x00");
                const cmd_ptr = loader(instance, name) orelse return error.CommandLoadFailure;
                @field(self.dispatch, field.name) = @ptrCast(field.field_type, cmd_ptr);
            }
            return self;
        }
        pub fn destroyInstance(
            self: Self,
            instance: Instance,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyInstance(
                instance,
                pAllocator,
            );
        }
        pub const EnumeratePhysicalDevicesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            Unknown,
        };
        pub fn enumeratePhysicalDevices(
            self: Self,
            instance: Instance,
            pPhysicalDeviceCount: *u32,
            pPhysicalDevices: ?[*]PhysicalDevice,
        ) EnumeratePhysicalDevicesError!Result {
            const result = self.dispatch.vkEnumeratePhysicalDevices(
                instance,
                pPhysicalDeviceCount,
                pPhysicalDevices,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getDeviceProcAddr(
            self: Self,
            device: Device,
            pName: [*:0]const u8,
        ) PfnVoidFunction {
            return self.dispatch.vkGetDeviceProcAddr(
                device,
                pName,
            );
        }
        pub fn getPhysicalDeviceProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
        ) PhysicalDeviceProperties {
            var properties: PhysicalDeviceProperties = undefined;
            self.dispatch.vkGetPhysicalDeviceProperties(
                physicalDevice,
                &properties,
            );
            return properties;
        }
        pub fn getPhysicalDeviceQueueFamilyProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
            pQueueFamilyPropertyCount: *u32,
            pQueueFamilyProperties: ?[*]QueueFamilyProperties,
        ) void {
            self.dispatch.vkGetPhysicalDeviceQueueFamilyProperties(
                physicalDevice,
                pQueueFamilyPropertyCount,
                pQueueFamilyProperties,
            );
        }
        pub fn getPhysicalDeviceMemoryProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
        ) PhysicalDeviceMemoryProperties {
            var memoryProperties: PhysicalDeviceMemoryProperties = undefined;
            self.dispatch.vkGetPhysicalDeviceMemoryProperties(
                physicalDevice,
                &memoryProperties,
            );
            return memoryProperties;
        }
        pub fn getPhysicalDeviceFeatures(
            self: Self,
            physicalDevice: PhysicalDevice,
        ) PhysicalDeviceFeatures {
            var features: PhysicalDeviceFeatures = undefined;
            self.dispatch.vkGetPhysicalDeviceFeatures(
                physicalDevice,
                &features,
            );
            return features;
        }
        pub fn getPhysicalDeviceFormatProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
            format: Format,
        ) FormatProperties {
            var formatProperties: FormatProperties = undefined;
            self.dispatch.vkGetPhysicalDeviceFormatProperties(
                physicalDevice,
                format,
                &formatProperties,
            );
            return formatProperties;
        }
        pub const GetPhysicalDeviceImageFormatPropertiesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            FormatNotSupported,
            Unknown,
        };
        pub fn getPhysicalDeviceImageFormatProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
            format: Format,
            @"type": ImageType,
            tiling: ImageTiling,
            usage: ImageUsageFlags,
            flags: ImageCreateFlags,
        ) GetPhysicalDeviceImageFormatPropertiesError!ImageFormatProperties {
            var imageFormatProperties: ImageFormatProperties = undefined;
            const result = self.dispatch.vkGetPhysicalDeviceImageFormatProperties(
                physicalDevice,
                format,
                @"type",
                tiling,
                usage.toInt(),
                flags.toInt(),
                &imageFormatProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorFormatNotSupported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
            return imageFormatProperties;
        }
        pub const CreateDeviceError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            ExtensionNotPresent,
            FeatureNotPresent,
            TooManyObjects,
            DeviceLost,
            Unknown,
        };
        pub fn createDevice(
            self: Self,
            physicalDevice: PhysicalDevice,
            createInfo: DeviceCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDeviceError!Device {
            var device: Device = undefined;
            const result = self.dispatch.vkCreateDevice(
                physicalDevice,
                &createInfo,
                pAllocator,
                &device,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorExtensionNotPresent => return error.ExtensionNotPresent,
                Result.errorFeatureNotPresent => return error.FeatureNotPresent,
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return device;
        }
        pub const EnumerateDeviceLayerPropertiesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn enumerateDeviceLayerProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
            pPropertyCount: *u32,
            pProperties: ?[*]LayerProperties,
        ) EnumerateDeviceLayerPropertiesError!Result {
            const result = self.dispatch.vkEnumerateDeviceLayerProperties(
                physicalDevice,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const EnumerateDeviceExtensionPropertiesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            LayerNotPresent,
            Unknown,
        };
        pub fn enumerateDeviceExtensionProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
            pLayerName: ?[*:0]const u8,
            pPropertyCount: *u32,
            pProperties: ?[*]ExtensionProperties,
        ) EnumerateDeviceExtensionPropertiesError!Result {
            const result = self.dispatch.vkEnumerateDeviceExtensionProperties(
                physicalDevice,
                pLayerName,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorLayerNotPresent => return error.LayerNotPresent,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceSparseImageFormatProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
            format: Format,
            @"type": ImageType,
            samples: SampleCountFlags,
            usage: ImageUsageFlags,
            tiling: ImageTiling,
            pPropertyCount: *u32,
            pProperties: ?[*]SparseImageFormatProperties,
        ) void {
            self.dispatch.vkGetPhysicalDeviceSparseImageFormatProperties(
                physicalDevice,
                format,
                @"type",
                samples.toInt(),
                usage.toInt(),
                tiling,
                pPropertyCount,
                pProperties,
            );
        }
        pub const CreateAndroidSurfaceKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        };
        pub fn createAndroidSurfaceKHR(
            self: Self,
            instance: Instance,
            createInfo: AndroidSurfaceCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateAndroidSurfaceKHRError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateAndroidSurfaceKHR(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorNativeWindowInUseKHR => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub const GetPhysicalDeviceDisplayPropertiesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPhysicalDeviceDisplayPropertiesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            pPropertyCount: *u32,
            pProperties: ?[*]DisplayPropertiesKHR,
        ) GetPhysicalDeviceDisplayPropertiesKHRError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceDisplayPropertiesKHR(
                physicalDevice,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPhysicalDeviceDisplayPlanePropertiesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPhysicalDeviceDisplayPlanePropertiesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            pPropertyCount: *u32,
            pProperties: ?[*]DisplayPlanePropertiesKHR,
        ) GetPhysicalDeviceDisplayPlanePropertiesKHRError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceDisplayPlanePropertiesKHR(
                physicalDevice,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetDisplayPlaneSupportedDisplaysKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getDisplayPlaneSupportedDisplaysKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            planeIndex: u32,
            pDisplayCount: *u32,
            pDisplays: ?[*]DisplayKHR,
        ) GetDisplayPlaneSupportedDisplaysKHRError!Result {
            const result = self.dispatch.vkGetDisplayPlaneSupportedDisplaysKHR(
                physicalDevice,
                planeIndex,
                pDisplayCount,
                pDisplays,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetDisplayModePropertiesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getDisplayModePropertiesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            display: DisplayKHR,
            pPropertyCount: *u32,
            pProperties: ?[*]DisplayModePropertiesKHR,
        ) GetDisplayModePropertiesKHRError!Result {
            const result = self.dispatch.vkGetDisplayModePropertiesKHR(
                physicalDevice,
                display,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const CreateDisplayModeKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            Unknown,
        };
        pub fn createDisplayModeKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            display: DisplayKHR,
            createInfo: DisplayModeCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDisplayModeKHRError!DisplayModeKHR {
            var mode: DisplayModeKHR = undefined;
            const result = self.dispatch.vkCreateDisplayModeKHR(
                physicalDevice,
                display,
                &createInfo,
                pAllocator,
                &mode,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return mode;
        }
        pub const GetDisplayPlaneCapabilitiesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getDisplayPlaneCapabilitiesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            mode: DisplayModeKHR,
            planeIndex: u32,
        ) GetDisplayPlaneCapabilitiesKHRError!DisplayPlaneCapabilitiesKHR {
            var capabilities: DisplayPlaneCapabilitiesKHR = undefined;
            const result = self.dispatch.vkGetDisplayPlaneCapabilitiesKHR(
                physicalDevice,
                mode,
                planeIndex,
                &capabilities,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return capabilities;
        }
        pub const CreateDisplayPlaneSurfaceKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createDisplayPlaneSurfaceKHR(
            self: Self,
            instance: Instance,
            createInfo: DisplaySurfaceCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDisplayPlaneSurfaceKHRError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateDisplayPlaneSurfaceKHR(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn destroySurfaceKHR(
            self: Self,
            instance: Instance,
            surface: SurfaceKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroySurfaceKHR(
                instance,
                surface,
                pAllocator,
            );
        }
        pub const GetPhysicalDeviceSurfaceSupportKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getPhysicalDeviceSurfaceSupportKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            queueFamilyIndex: u32,
            surface: SurfaceKHR,
        ) GetPhysicalDeviceSurfaceSupportKHRError!Bool32 {
            var supported: Bool32 = undefined;
            const result = self.dispatch.vkGetPhysicalDeviceSurfaceSupportKHR(
                physicalDevice,
                queueFamilyIndex,
                surface,
                &supported,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return supported;
        }
        pub const GetPhysicalDeviceSurfaceCapabilitiesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getPhysicalDeviceSurfaceCapabilitiesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            surface: SurfaceKHR,
        ) GetPhysicalDeviceSurfaceCapabilitiesKHRError!SurfaceCapabilitiesKHR {
            var surfaceCapabilities: SurfaceCapabilitiesKHR = undefined;
            const result = self.dispatch.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(
                physicalDevice,
                surface,
                &surfaceCapabilities,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return surfaceCapabilities;
        }
        pub const GetPhysicalDeviceSurfaceFormatsKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getPhysicalDeviceSurfaceFormatsKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            surface: SurfaceKHR,
            pSurfaceFormatCount: *u32,
            pSurfaceFormats: ?[*]SurfaceFormatKHR,
        ) GetPhysicalDeviceSurfaceFormatsKHRError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceSurfaceFormatsKHR(
                physicalDevice,
                surface,
                pSurfaceFormatCount,
                pSurfaceFormats,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPhysicalDeviceSurfacePresentModesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getPhysicalDeviceSurfacePresentModesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            surface: SurfaceKHR,
            pPresentModeCount: *u32,
            pPresentModes: ?[*]PresentModeKHR,
        ) GetPhysicalDeviceSurfacePresentModesKHRError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceSurfacePresentModesKHR(
                physicalDevice,
                surface,
                pPresentModeCount,
                pPresentModes,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub const CreateViSurfaceNNError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        };
        pub fn createViSurfaceNN(
            self: Self,
            instance: Instance,
            createInfo: ViSurfaceCreateInfoNN,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateViSurfaceNNError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateViSurfaceNN(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorNativeWindowInUseKHR => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub const CreateWaylandSurfaceKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createWaylandSurfaceKHR(
            self: Self,
            instance: Instance,
            createInfo: WaylandSurfaceCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateWaylandSurfaceKHRError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateWaylandSurfaceKHR(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceWaylandPresentationSupportKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            queueFamilyIndex: u32,
            display: *wl_display,
        ) Bool32 {
            return self.dispatch.vkGetPhysicalDeviceWaylandPresentationSupportKHR(
                physicalDevice,
                queueFamilyIndex,
                display,
            );
        }
        pub const CreateWin32SurfaceKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createWin32SurfaceKHR(
            self: Self,
            instance: Instance,
            createInfo: Win32SurfaceCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateWin32SurfaceKHRError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateWin32SurfaceKHR(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceWin32PresentationSupportKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            queueFamilyIndex: u32,
        ) Bool32 {
            return self.dispatch.vkGetPhysicalDeviceWin32PresentationSupportKHR(
                physicalDevice,
                queueFamilyIndex,
            );
        }
        pub const CreateXlibSurfaceKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createXlibSurfaceKHR(
            self: Self,
            instance: Instance,
            createInfo: XlibSurfaceCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateXlibSurfaceKHRError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateXlibSurfaceKHR(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceXlibPresentationSupportKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            queueFamilyIndex: u32,
            dpy: *Display,
            visualId: VisualID,
        ) Bool32 {
            return self.dispatch.vkGetPhysicalDeviceXlibPresentationSupportKHR(
                physicalDevice,
                queueFamilyIndex,
                dpy,
                visualId,
            );
        }
        pub const CreateXcbSurfaceKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createXcbSurfaceKHR(
            self: Self,
            instance: Instance,
            createInfo: XcbSurfaceCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateXcbSurfaceKHRError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateXcbSurfaceKHR(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceXcbPresentationSupportKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            queueFamilyIndex: u32,
            connection: *xcb_connection_t,
            visualId: xcb_visualid_t,
        ) Bool32 {
            return self.dispatch.vkGetPhysicalDeviceXcbPresentationSupportKHR(
                physicalDevice,
                queueFamilyIndex,
                connection,
                visualId,
            );
        }
        pub const CreateDirectFbSurfaceEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createDirectFbSurfaceEXT(
            self: Self,
            instance: Instance,
            createInfo: DirectFBSurfaceCreateInfoEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDirectFbSurfaceEXTError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateDirectFBSurfaceEXT(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceDirectFbPresentationSupportEXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            queueFamilyIndex: u32,
            dfb: *IDirectFB,
        ) Bool32 {
            return self.dispatch.vkGetPhysicalDeviceDirectFBPresentationSupportEXT(
                physicalDevice,
                queueFamilyIndex,
                dfb,
            );
        }
        pub const CreateImagePipeSurfaceFUCHSIAError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createImagePipeSurfaceFUCHSIA(
            self: Self,
            instance: Instance,
            createInfo: ImagePipeSurfaceCreateInfoFUCHSIA,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateImagePipeSurfaceFUCHSIAError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateImagePipeSurfaceFUCHSIA(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub const CreateStreamDescriptorSurfaceGGPError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        };
        pub fn createStreamDescriptorSurfaceGGP(
            self: Self,
            instance: Instance,
            createInfo: StreamDescriptorSurfaceCreateInfoGGP,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateStreamDescriptorSurfaceGGPError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateStreamDescriptorSurfaceGGP(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorNativeWindowInUseKHR => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub const CreateScreenSurfaceQNXError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createScreenSurfaceQNX(
            self: Self,
            instance: Instance,
            createInfo: ScreenSurfaceCreateInfoQNX,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateScreenSurfaceQNXError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateScreenSurfaceQNX(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceScreenPresentationSupportQNX(
            self: Self,
            physicalDevice: PhysicalDevice,
            queueFamilyIndex: u32,
            window: *_screen_window,
        ) Bool32 {
            return self.dispatch.vkGetPhysicalDeviceScreenPresentationSupportQNX(
                physicalDevice,
                queueFamilyIndex,
                window,
            );
        }
        pub const CreateDebugReportCallbackEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn createDebugReportCallbackEXT(
            self: Self,
            instance: Instance,
            createInfo: DebugReportCallbackCreateInfoEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDebugReportCallbackEXTError!DebugReportCallbackEXT {
            var callback: DebugReportCallbackEXT = undefined;
            const result = self.dispatch.vkCreateDebugReportCallbackEXT(
                instance,
                &createInfo,
                pAllocator,
                &callback,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return callback;
        }
        pub fn destroyDebugReportCallbackEXT(
            self: Self,
            instance: Instance,
            callback: DebugReportCallbackEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyDebugReportCallbackEXT(
                instance,
                callback,
                pAllocator,
            );
        }
        pub fn debugReportMessageEXT(
            self: Self,
            instance: Instance,
            flags: DebugReportFlagsEXT,
            objectType: DebugReportObjectTypeEXT,
            object: u64,
            location: usize,
            messageCode: i32,
            pLayerPrefix: [*:0]const u8,
            pMessage: [*:0]const u8,
        ) void {
            self.dispatch.vkDebugReportMessageEXT(
                instance,
                flags.toInt(),
                objectType,
                object,
                location,
                messageCode,
                pLayerPrefix,
                pMessage,
            );
        }
        pub const GetPhysicalDeviceExternalImageFormatPropertiesNVError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            FormatNotSupported,
            Unknown,
        };
        pub fn getPhysicalDeviceExternalImageFormatPropertiesNV(
            self: Self,
            physicalDevice: PhysicalDevice,
            format: Format,
            @"type": ImageType,
            tiling: ImageTiling,
            usage: ImageUsageFlags,
            flags: ImageCreateFlags,
            externalHandleType: ExternalMemoryHandleTypeFlagsNV,
        ) GetPhysicalDeviceExternalImageFormatPropertiesNVError!ExternalImageFormatPropertiesNV {
            var externalImageFormatProperties: ExternalImageFormatPropertiesNV = undefined;
            const result = self.dispatch.vkGetPhysicalDeviceExternalImageFormatPropertiesNV(
                physicalDevice,
                format,
                @"type",
                tiling,
                usage.toInt(),
                flags.toInt(),
                externalHandleType.toInt(),
                &externalImageFormatProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorFormatNotSupported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
            return externalImageFormatProperties;
        }
        pub fn getPhysicalDeviceFeatures2(
            self: Self,
            physicalDevice: PhysicalDevice,
            pFeatures: *PhysicalDeviceFeatures2,
        ) void {
            self.dispatch.vkGetPhysicalDeviceFeatures2(
                physicalDevice,
                pFeatures,
            );
        }
        pub fn getPhysicalDeviceProperties2(
            self: Self,
            physicalDevice: PhysicalDevice,
            pProperties: *PhysicalDeviceProperties2,
        ) void {
            self.dispatch.vkGetPhysicalDeviceProperties2(
                physicalDevice,
                pProperties,
            );
        }
        pub fn getPhysicalDeviceFormatProperties2(
            self: Self,
            physicalDevice: PhysicalDevice,
            format: Format,
            pFormatProperties: *FormatProperties2,
        ) void {
            self.dispatch.vkGetPhysicalDeviceFormatProperties2(
                physicalDevice,
                format,
                pFormatProperties,
            );
        }
        pub const GetPhysicalDeviceImageFormatProperties2Error = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            FormatNotSupported,
            Unknown,
        };
        pub fn getPhysicalDeviceImageFormatProperties2(
            self: Self,
            physicalDevice: PhysicalDevice,
            imageFormatInfo: PhysicalDeviceImageFormatInfo2,
            pImageFormatProperties: *ImageFormatProperties2,
        ) GetPhysicalDeviceImageFormatProperties2Error!void {
            const result = self.dispatch.vkGetPhysicalDeviceImageFormatProperties2(
                physicalDevice,
                &imageFormatInfo,
                pImageFormatProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorFormatNotSupported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
        }
        pub fn getPhysicalDeviceQueueFamilyProperties2(
            self: Self,
            physicalDevice: PhysicalDevice,
            pQueueFamilyPropertyCount: *u32,
            pQueueFamilyProperties: ?[*]QueueFamilyProperties2,
        ) void {
            self.dispatch.vkGetPhysicalDeviceQueueFamilyProperties2(
                physicalDevice,
                pQueueFamilyPropertyCount,
                pQueueFamilyProperties,
            );
        }
        pub fn getPhysicalDeviceMemoryProperties2(
            self: Self,
            physicalDevice: PhysicalDevice,
            pMemoryProperties: *PhysicalDeviceMemoryProperties2,
        ) void {
            self.dispatch.vkGetPhysicalDeviceMemoryProperties2(
                physicalDevice,
                pMemoryProperties,
            );
        }
        pub fn getPhysicalDeviceSparseImageFormatProperties2(
            self: Self,
            physicalDevice: PhysicalDevice,
            formatInfo: PhysicalDeviceSparseImageFormatInfo2,
            pPropertyCount: *u32,
            pProperties: ?[*]SparseImageFormatProperties2,
        ) void {
            self.dispatch.vkGetPhysicalDeviceSparseImageFormatProperties2(
                physicalDevice,
                &formatInfo,
                pPropertyCount,
                pProperties,
            );
        }
        pub fn getPhysicalDeviceExternalBufferProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
            externalBufferInfo: PhysicalDeviceExternalBufferInfo,
            pExternalBufferProperties: *ExternalBufferProperties,
        ) void {
            self.dispatch.vkGetPhysicalDeviceExternalBufferProperties(
                physicalDevice,
                &externalBufferInfo,
                pExternalBufferProperties,
            );
        }
        pub fn getPhysicalDeviceExternalSemaphoreProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
            externalSemaphoreInfo: PhysicalDeviceExternalSemaphoreInfo,
            pExternalSemaphoreProperties: *ExternalSemaphoreProperties,
        ) void {
            self.dispatch.vkGetPhysicalDeviceExternalSemaphoreProperties(
                physicalDevice,
                &externalSemaphoreInfo,
                pExternalSemaphoreProperties,
            );
        }
        pub fn getPhysicalDeviceExternalFenceProperties(
            self: Self,
            physicalDevice: PhysicalDevice,
            externalFenceInfo: PhysicalDeviceExternalFenceInfo,
            pExternalFenceProperties: *ExternalFenceProperties,
        ) void {
            self.dispatch.vkGetPhysicalDeviceExternalFenceProperties(
                physicalDevice,
                &externalFenceInfo,
                pExternalFenceProperties,
            );
        }
        pub fn releaseDisplayEXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            display: DisplayKHR,
        ) void {
            const result = self.dispatch.vkReleaseDisplayEXT(
                physicalDevice,
                display,
            );
            switch (result) {
                Result.success => {},
                else => return error.Unknown,
            }
        }
        pub const AcquireXlibDisplayEXTError = error{
            OutOfHostMemory,
            InitializationFailed,
            Unknown,
        };
        pub fn acquireXlibDisplayEXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            dpy: *Display,
            display: DisplayKHR,
        ) AcquireXlibDisplayEXTError!void {
            const result = self.dispatch.vkAcquireXlibDisplayEXT(
                physicalDevice,
                dpy,
                display,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
        }
        pub const GetRandROutputDisplayEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn getRandROutputDisplayEXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            dpy: *Display,
            rrOutput: RROutput,
        ) GetRandROutputDisplayEXTError!DisplayKHR {
            var display: DisplayKHR = undefined;
            const result = self.dispatch.vkGetRandROutputDisplayEXT(
                physicalDevice,
                dpy,
                rrOutput,
                &display,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return display;
        }
        pub const AcquireWinrtDisplayNVError = error{
            OutOfHostMemory,
            DeviceLost,
            InitializationFailed,
            Unknown,
        };
        pub fn acquireWinrtDisplayNV(
            self: Self,
            physicalDevice: PhysicalDevice,
            display: DisplayKHR,
        ) AcquireWinrtDisplayNVError!void {
            const result = self.dispatch.vkAcquireWinrtDisplayNV(
                physicalDevice,
                display,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
        }
        pub const GetWinrtDisplayNVError = error{
            OutOfHostMemory,
            DeviceLost,
            InitializationFailed,
            Unknown,
        };
        pub fn getWinrtDisplayNV(
            self: Self,
            physicalDevice: PhysicalDevice,
            deviceRelativeId: u32,
        ) GetWinrtDisplayNVError!DisplayKHR {
            var display: DisplayKHR = undefined;
            const result = self.dispatch.vkGetWinrtDisplayNV(
                physicalDevice,
                deviceRelativeId,
                &display,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return display;
        }
        pub const GetPhysicalDeviceSurfaceCapabilities2EXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getPhysicalDeviceSurfaceCapabilities2EXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            surface: SurfaceKHR,
            pSurfaceCapabilities: *SurfaceCapabilities2EXT,
        ) GetPhysicalDeviceSurfaceCapabilities2EXTError!void {
            const result = self.dispatch.vkGetPhysicalDeviceSurfaceCapabilities2EXT(
                physicalDevice,
                surface,
                pSurfaceCapabilities,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub const EnumeratePhysicalDeviceGroupsError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            Unknown,
        };
        pub fn enumeratePhysicalDeviceGroups(
            self: Self,
            instance: Instance,
            pPhysicalDeviceGroupCount: *u32,
            pPhysicalDeviceGroupProperties: ?[*]PhysicalDeviceGroupProperties,
        ) EnumeratePhysicalDeviceGroupsError!Result {
            const result = self.dispatch.vkEnumeratePhysicalDeviceGroups(
                instance,
                pPhysicalDeviceGroupCount,
                pPhysicalDeviceGroupProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPhysicalDevicePresentRectanglesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPhysicalDevicePresentRectanglesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            surface: SurfaceKHR,
            pRectCount: *u32,
            pRects: ?[*]Rect2D,
        ) GetPhysicalDevicePresentRectanglesKHRError!Result {
            const result = self.dispatch.vkGetPhysicalDevicePresentRectanglesKHR(
                physicalDevice,
                surface,
                pRectCount,
                pRects,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const CreateIosSurfaceMVKError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        };
        pub fn createIosSurfaceMVK(
            self: Self,
            instance: Instance,
            createInfo: IOSSurfaceCreateInfoMVK,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateIosSurfaceMVKError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateIOSSurfaceMVK(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorNativeWindowInUseKHR => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub const CreateMacOsSurfaceMVKError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        };
        pub fn createMacOsSurfaceMVK(
            self: Self,
            instance: Instance,
            createInfo: MacOSSurfaceCreateInfoMVK,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateMacOsSurfaceMVKError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateMacOSSurfaceMVK(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorNativeWindowInUseKHR => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub const CreateMetalSurfaceEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            NativeWindowInUseKHR,
            Unknown,
        };
        pub fn createMetalSurfaceEXT(
            self: Self,
            instance: Instance,
            createInfo: MetalSurfaceCreateInfoEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateMetalSurfaceEXTError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateMetalSurfaceEXT(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorNativeWindowInUseKHR => return error.NativeWindowInUseKHR,
                else => return error.Unknown,
            }
            return surface;
        }
        pub fn getPhysicalDeviceMultisamplePropertiesEXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            samples: SampleCountFlags,
            pMultisampleProperties: *MultisamplePropertiesEXT,
        ) void {
            self.dispatch.vkGetPhysicalDeviceMultisamplePropertiesEXT(
                physicalDevice,
                samples.toInt(),
                pMultisampleProperties,
            );
        }
        pub const GetPhysicalDeviceSurfaceCapabilities2KHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getPhysicalDeviceSurfaceCapabilities2KHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            surfaceInfo: PhysicalDeviceSurfaceInfo2KHR,
            pSurfaceCapabilities: *SurfaceCapabilities2KHR,
        ) GetPhysicalDeviceSurfaceCapabilities2KHRError!void {
            const result = self.dispatch.vkGetPhysicalDeviceSurfaceCapabilities2KHR(
                physicalDevice,
                &surfaceInfo,
                pSurfaceCapabilities,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub const GetPhysicalDeviceSurfaceFormats2KHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getPhysicalDeviceSurfaceFormats2KHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            surfaceInfo: PhysicalDeviceSurfaceInfo2KHR,
            pSurfaceFormatCount: *u32,
            pSurfaceFormats: ?[*]SurfaceFormat2KHR,
        ) GetPhysicalDeviceSurfaceFormats2KHRError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceSurfaceFormats2KHR(
                physicalDevice,
                &surfaceInfo,
                pSurfaceFormatCount,
                pSurfaceFormats,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPhysicalDeviceDisplayProperties2KHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPhysicalDeviceDisplayProperties2KHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            pPropertyCount: *u32,
            pProperties: ?[*]DisplayProperties2KHR,
        ) GetPhysicalDeviceDisplayProperties2KHRError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceDisplayProperties2KHR(
                physicalDevice,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPhysicalDeviceDisplayPlaneProperties2KHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPhysicalDeviceDisplayPlaneProperties2KHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            pPropertyCount: *u32,
            pProperties: ?[*]DisplayPlaneProperties2KHR,
        ) GetPhysicalDeviceDisplayPlaneProperties2KHRError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceDisplayPlaneProperties2KHR(
                physicalDevice,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetDisplayModeProperties2KHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getDisplayModeProperties2KHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            display: DisplayKHR,
            pPropertyCount: *u32,
            pProperties: ?[*]DisplayModeProperties2KHR,
        ) GetDisplayModeProperties2KHRError!Result {
            const result = self.dispatch.vkGetDisplayModeProperties2KHR(
                physicalDevice,
                display,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetDisplayPlaneCapabilities2KHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getDisplayPlaneCapabilities2KHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            displayPlaneInfo: DisplayPlaneInfo2KHR,
            pCapabilities: *DisplayPlaneCapabilities2KHR,
        ) GetDisplayPlaneCapabilities2KHRError!void {
            const result = self.dispatch.vkGetDisplayPlaneCapabilities2KHR(
                physicalDevice,
                &displayPlaneInfo,
                pCapabilities,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const GetPhysicalDeviceCalibrateableTimeDomainsEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPhysicalDeviceCalibrateableTimeDomainsEXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            pTimeDomainCount: *u32,
            pTimeDomains: ?[*]TimeDomainEXT,
        ) GetPhysicalDeviceCalibrateableTimeDomainsEXTError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceCalibrateableTimeDomainsEXT(
                physicalDevice,
                pTimeDomainCount,
                pTimeDomains,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const CreateDebugUtilsMessengerEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn createDebugUtilsMessengerEXT(
            self: Self,
            instance: Instance,
            createInfo: DebugUtilsMessengerCreateInfoEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDebugUtilsMessengerEXTError!DebugUtilsMessengerEXT {
            var messenger: DebugUtilsMessengerEXT = undefined;
            const result = self.dispatch.vkCreateDebugUtilsMessengerEXT(
                instance,
                &createInfo,
                pAllocator,
                &messenger,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return messenger;
        }
        pub fn destroyDebugUtilsMessengerEXT(
            self: Self,
            instance: Instance,
            messenger: DebugUtilsMessengerEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyDebugUtilsMessengerEXT(
                instance,
                messenger,
                pAllocator,
            );
        }
        pub fn submitDebugUtilsMessageEXT(
            self: Self,
            instance: Instance,
            messageSeverity: DebugUtilsMessageSeverityFlagsEXT,
            messageTypes: DebugUtilsMessageTypeFlagsEXT,
            callbackData: DebugUtilsMessengerCallbackDataEXT,
        ) void {
            self.dispatch.vkSubmitDebugUtilsMessageEXT(
                instance,
                messageSeverity.toInt(),
                messageTypes.toInt(),
                &callbackData,
            );
        }
        pub const GetPhysicalDeviceCooperativeMatrixPropertiesNVError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPhysicalDeviceCooperativeMatrixPropertiesNV(
            self: Self,
            physicalDevice: PhysicalDevice,
            pPropertyCount: *u32,
            pProperties: ?[*]CooperativeMatrixPropertiesNV,
        ) GetPhysicalDeviceCooperativeMatrixPropertiesNVError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceCooperativeMatrixPropertiesNV(
                physicalDevice,
                pPropertyCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPhysicalDeviceSurfacePresentModes2EXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getPhysicalDeviceSurfacePresentModes2EXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            surfaceInfo: PhysicalDeviceSurfaceInfo2KHR,
            pPresentModeCount: *u32,
            pPresentModes: ?[*]PresentModeKHR,
        ) GetPhysicalDeviceSurfacePresentModes2EXTError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceSurfacePresentModes2EXT(
                physicalDevice,
                &surfaceInfo,
                pPresentModeCount,
                pPresentModes,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub const EnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            Unknown,
        };
        pub fn enumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            queueFamilyIndex: u32,
            pCounterCount: *u32,
            pCounters: ?[*]PerformanceCounterKHR,
            pCounterDescriptions: ?[*]PerformanceCounterDescriptionKHR,
        ) EnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHRError!Result {
            const result = self.dispatch.vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(
                physicalDevice,
                queueFamilyIndex,
                pCounterCount,
                pCounters,
                pCounterDescriptions,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            performanceQueryCreateInfo: QueryPoolPerformanceCreateInfoKHR,
        ) u32 {
            var numPasses: u32 = undefined;
            self.dispatch.vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(
                physicalDevice,
                &performanceQueryCreateInfo,
                &numPasses,
            );
            return numPasses;
        }
        pub const CreateHeadlessSurfaceEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createHeadlessSurfaceEXT(
            self: Self,
            instance: Instance,
            createInfo: HeadlessSurfaceCreateInfoEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateHeadlessSurfaceEXTError!SurfaceKHR {
            var surface: SurfaceKHR = undefined;
            const result = self.dispatch.vkCreateHeadlessSurfaceEXT(
                instance,
                &createInfo,
                pAllocator,
                &surface,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return surface;
        }
        pub const GetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNVError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(
            self: Self,
            physicalDevice: PhysicalDevice,
            pCombinationCount: *u32,
            pCombinations: ?[*]FramebufferMixedSamplesCombinationNV,
        ) GetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNVError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(
                physicalDevice,
                pCombinationCount,
                pCombinations,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPhysicalDeviceToolPropertiesEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn getPhysicalDeviceToolPropertiesEXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            pToolCount: *u32,
            pToolProperties: ?[*]PhysicalDeviceToolPropertiesEXT,
        ) GetPhysicalDeviceToolPropertiesEXTError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceToolPropertiesEXT(
                physicalDevice,
                pToolCount,
                pToolProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPhysicalDeviceFragmentShadingRatesKHRError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn getPhysicalDeviceFragmentShadingRatesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            pFragmentShadingRateCount: *u32,
            pFragmentShadingRates: ?[*]PhysicalDeviceFragmentShadingRateKHR,
        ) GetPhysicalDeviceFragmentShadingRatesKHRError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceFragmentShadingRatesKHR(
                physicalDevice,
                pFragmentShadingRateCount,
                pFragmentShadingRates,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPhysicalDeviceVideoCapabilitiesKHRError = error{
            ExtensionNotPresent,
            InitializationFailed,
            FeatureNotPresent,
            FormatNotSupported,
            Unknown,
        };
        pub fn getPhysicalDeviceVideoCapabilitiesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            videoProfile: VideoProfileKHR,
            pCapabilities: *VideoCapabilitiesKHR,
        ) GetPhysicalDeviceVideoCapabilitiesKHRError!void {
            const result = self.dispatch.vkGetPhysicalDeviceVideoCapabilitiesKHR(
                physicalDevice,
                &videoProfile,
                pCapabilities,
            );
            switch (result) {
                Result.success => {},
                Result.errorExtensionNotPresent => return error.ExtensionNotPresent,
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorFeatureNotPresent => return error.FeatureNotPresent,
                Result.errorFormatNotSupported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
        }
        pub const GetPhysicalDeviceVideoFormatPropertiesKHRError = error{
            ExtensionNotPresent,
            InitializationFailed,
            FormatNotSupported,
            Unknown,
        };
        pub fn getPhysicalDeviceVideoFormatPropertiesKHR(
            self: Self,
            physicalDevice: PhysicalDevice,
            videoFormatInfo: PhysicalDeviceVideoFormatInfoKHR,
            pVideoFormatPropertyCount: *u32,
            pVideoFormatProperties: ?[*]VideoFormatPropertiesKHR,
        ) GetPhysicalDeviceVideoFormatPropertiesKHRError!Result {
            const result = self.dispatch.vkGetPhysicalDeviceVideoFormatPropertiesKHR(
                physicalDevice,
                &videoFormatInfo,
                pVideoFormatPropertyCount,
                pVideoFormatProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorExtensionNotPresent => return error.ExtensionNotPresent,
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorFormatNotSupported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
            return result;
        }
        pub const AcquireDrmDisplayEXTError = error{
            InitializationFailed,
            Unknown,
        };
        pub fn acquireDrmDisplayEXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            drmFd: i32,
            display: DisplayKHR,
        ) AcquireDrmDisplayEXTError!void {
            const result = self.dispatch.vkAcquireDrmDisplayEXT(
                physicalDevice,
                drmFd,
                display,
            );
            switch (result) {
                Result.success => {},
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
        }
        pub const GetDrmDisplayEXTError = error{
            InitializationFailed,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getDrmDisplayEXT(
            self: Self,
            physicalDevice: PhysicalDevice,
            drmFd: i32,
            connectorId: u32,
        ) GetDrmDisplayEXTError!DisplayKHR {
            var display: DisplayKHR = undefined;
            const result = self.dispatch.vkGetDrmDisplayEXT(
                physicalDevice,
                drmFd,
                connectorId,
                &display,
            );
            switch (result) {
                Result.success => {},
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return display;
        }
    };
}
pub fn DeviceWrapper(comptime cmds: []const DeviceCommand) type {
    comptime var fields: [cmds.len]std.builtin.TypeInfo.StructField = undefined;
    inline for (cmds) |cmd, i| {
        const PfnType = cmd.PfnType();
        fields[i] = .{
            .name = cmd.symbol(),
            .field_type = PfnType,
            .default_value = null,
            .is_comptime = false,
            .alignment = @alignOf(PfnType),
        };
    }
    const Dispatch = @Type(.{
        .Struct = .{
            .layout = .Auto,
            .fields = &fields,
            .decls = &[_]std.builtin.TypeInfo.Declaration{},
            .is_tuple = false,
        },
    });
    return struct {
        dispatch: Dispatch,

        const Self = @This();
        pub fn load(device: Device, loader: anytype) !Self {
            var self: Self = undefined;
            inline for (std.meta.fields(Dispatch)) |field| {
                const name = @ptrCast([*:0]const u8, field.name ++ "\x00");
                const cmd_ptr = loader(device, name) orelse {
                  std.log.err("could not load {s}", .{name});
                  return error.CommandLoadFailure;
                };
                @field(self.dispatch, field.name) = @ptrCast(field.field_type, cmd_ptr);
            }
            return self;
        }
        pub fn destroyDevice(
            self: Self,
            device: Device,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyDevice(
                device,
                pAllocator,
            );
        }
        pub fn getDeviceQueue(
            self: Self,
            device: Device,
            queueFamilyIndex: u32,
            queueIndex: u32,
        ) Queue {
            var queue: Queue = undefined;
            self.dispatch.vkGetDeviceQueue(
                device,
                queueFamilyIndex,
                queueIndex,
                &queue,
            );
            return queue;
        }
        pub const QueueSubmitError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn queueSubmit(
            self: Self,
            queue: Queue,
            submitCount: u32,
            pSubmits: [*]const SubmitInfo,
            fence: Fence,
        ) QueueSubmitError!void {
            const result = self.dispatch.vkQueueSubmit(
                queue,
                submitCount,
                pSubmits,
                fence,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
        }
        pub const QueueWaitIdleError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn queueWaitIdle(
            self: Self,
            queue: Queue,
        ) QueueWaitIdleError!void {
            const result = self.dispatch.vkQueueWaitIdle(
                queue,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
        }
        pub const DeviceWaitIdleError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn deviceWaitIdle(
            self: Self,
            device: Device,
        ) DeviceWaitIdleError!void {
            const result = self.dispatch.vkDeviceWaitIdle(
                device,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
        }
        pub const AllocateMemoryError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidExternalHandle,
            InvalidOpaqueCaptureAddressKHR,
            Unknown,
        };
        pub fn allocateMemory(
            self: Self,
            device: Device,
            allocateInfo: MemoryAllocateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) AllocateMemoryError!DeviceMemory {
            var memory: DeviceMemory = undefined;
            const result = self.dispatch.vkAllocateMemory(
                device,
                &allocateInfo,
                pAllocator,
                &memory,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                Result.errorInvalidOpaqueCaptureAddressKHR => return error.InvalidOpaqueCaptureAddressKHR,
                else => return error.Unknown,
            }
            return memory;
        }
        pub fn freeMemory(
            self: Self,
            device: Device,
            memory: DeviceMemory,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkFreeMemory(
                device,
                memory,
                pAllocator,
            );
        }
        pub const MapMemoryError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            MemoryMapFailed,
            Unknown,
        };
        pub fn mapMemory(
            self: Self,
            device: Device,
            memory: DeviceMemory,
            offset: DeviceSize,
            size: DeviceSize,
            flags: MemoryMapFlags,
        ) MapMemoryError!?*c_void {
            var ppData: ?*c_void = undefined;
            const result = self.dispatch.vkMapMemory(
                device,
                memory,
                offset,
                size,
                flags.toInt(),
                &ppData,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorMemoryMapFailed => return error.MemoryMapFailed,
                else => return error.Unknown,
            }
            return ppData;
        }
        pub fn unmapMemory(
            self: Self,
            device: Device,
            memory: DeviceMemory,
        ) void {
            self.dispatch.vkUnmapMemory(
                device,
                memory,
            );
        }
        pub const FlushMappedMemoryRangesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn flushMappedMemoryRanges(
            self: Self,
            device: Device,
            memoryRangeCount: u32,
            pMemoryRanges: [*]const MappedMemoryRange,
        ) FlushMappedMemoryRangesError!void {
            const result = self.dispatch.vkFlushMappedMemoryRanges(
                device,
                memoryRangeCount,
                pMemoryRanges,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const InvalidateMappedMemoryRangesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn invalidateMappedMemoryRanges(
            self: Self,
            device: Device,
            memoryRangeCount: u32,
            pMemoryRanges: [*]const MappedMemoryRange,
        ) InvalidateMappedMemoryRangesError!void {
            const result = self.dispatch.vkInvalidateMappedMemoryRanges(
                device,
                memoryRangeCount,
                pMemoryRanges,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getDeviceMemoryCommitment(
            self: Self,
            device: Device,
            memory: DeviceMemory,
        ) DeviceSize {
            var committedMemoryInBytes: DeviceSize = undefined;
            self.dispatch.vkGetDeviceMemoryCommitment(
                device,
                memory,
                &committedMemoryInBytes,
            );
            return committedMemoryInBytes;
        }
        pub fn getBufferMemoryRequirements(
            self: Self,
            device: Device,
            buffer: Buffer,
        ) MemoryRequirements {
            var memoryRequirements: MemoryRequirements = undefined;
            self.dispatch.vkGetBufferMemoryRequirements(
                device,
                buffer,
                &memoryRequirements,
            );
            return memoryRequirements;
        }
        pub const BindBufferMemoryError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidOpaqueCaptureAddressKHR,
            Unknown,
        };
        pub fn bindBufferMemory(
            self: Self,
            device: Device,
            buffer: Buffer,
            memory: DeviceMemory,
            memoryOffset: DeviceSize,
        ) BindBufferMemoryError!void {
            const result = self.dispatch.vkBindBufferMemory(
                device,
                buffer,
                memory,
                memoryOffset,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInvalidOpaqueCaptureAddressKHR => return error.InvalidOpaqueCaptureAddressKHR,
                else => return error.Unknown,
            }
        }
        pub fn getImageMemoryRequirements(
            self: Self,
            device: Device,
            image: Image,
        ) MemoryRequirements {
            var memoryRequirements: MemoryRequirements = undefined;
            self.dispatch.vkGetImageMemoryRequirements(
                device,
                image,
                &memoryRequirements,
            );
            return memoryRequirements;
        }
        pub const BindImageMemoryError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn bindImageMemory(
            self: Self,
            device: Device,
            image: Image,
            memory: DeviceMemory,
            memoryOffset: DeviceSize,
        ) BindImageMemoryError!void {
            const result = self.dispatch.vkBindImageMemory(
                device,
                image,
                memory,
                memoryOffset,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getImageSparseMemoryRequirements(
            self: Self,
            device: Device,
            image: Image,
            pSparseMemoryRequirementCount: *u32,
            pSparseMemoryRequirements: ?[*]SparseImageMemoryRequirements,
        ) void {
            self.dispatch.vkGetImageSparseMemoryRequirements(
                device,
                image,
                pSparseMemoryRequirementCount,
                pSparseMemoryRequirements,
            );
        }
        pub const QueueBindSparseError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn queueBindSparse(
            self: Self,
            queue: Queue,
            bindInfoCount: u32,
            pBindInfo: [*]const BindSparseInfo,
            fence: Fence,
        ) QueueBindSparseError!void {
            const result = self.dispatch.vkQueueBindSparse(
                queue,
                bindInfoCount,
                pBindInfo,
                fence,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
        }
        pub const CreateFenceError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createFence(
            self: Self,
            device: Device,
            createInfo: FenceCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateFenceError!Fence {
            var fence: Fence = undefined;
            const result = self.dispatch.vkCreateFence(
                device,
                &createInfo,
                pAllocator,
                &fence,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return fence;
        }
        pub fn destroyFence(
            self: Self,
            device: Device,
            fence: Fence,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyFence(
                device,
                fence,
                pAllocator,
            );
        }
        pub const ResetFencesError = error{
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn resetFences(
            self: Self,
            device: Device,
            fenceCount: u32,
            pFences: [*]const Fence,
        ) ResetFencesError!void {
            const result = self.dispatch.vkResetFences(
                device,
                fenceCount,
                pFences,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const GetFenceStatusError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn getFenceStatus(
            self: Self,
            device: Device,
            fence: Fence,
        ) GetFenceStatusError!Result {
            const result = self.dispatch.vkGetFenceStatus(
                device,
                fence,
            );
            switch (result) {
                Result.success => {},
                Result.notReady => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub const WaitForFencesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn waitForFences(
            self: Self,
            device: Device,
            fenceCount: u32,
            pFences: [*]const Fence,
            waitAll: Bool32,
            timeout: u64,
        ) WaitForFencesError!Result {
            const result = self.dispatch.vkWaitForFences(
                device,
                fenceCount,
                pFences,
                waitAll,
                timeout,
            );
            switch (result) {
                Result.success => {},
                Result.timeout => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub const CreateSemaphoreError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createSemaphore(
            self: Self,
            device: Device,
            createInfo: SemaphoreCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateSemaphoreError!Semaphore {
            var semaphore: Semaphore = undefined;
            const result = self.dispatch.vkCreateSemaphore(
                device,
                &createInfo,
                pAllocator,
                &semaphore,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return semaphore;
        }
        pub fn destroySemaphore(
            self: Self,
            device: Device,
            semaphore: Semaphore,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroySemaphore(
                device,
                semaphore,
                pAllocator,
            );
        }
        pub const CreateEventError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createEvent(
            self: Self,
            device: Device,
            createInfo: EventCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateEventError!Event {
            var event: Event = undefined;
            const result = self.dispatch.vkCreateEvent(
                device,
                &createInfo,
                pAllocator,
                &event,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return event;
        }
        pub fn destroyEvent(
            self: Self,
            device: Device,
            event: Event,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyEvent(
                device,
                event,
                pAllocator,
            );
        }
        pub const GetEventStatusError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn getEventStatus(
            self: Self,
            device: Device,
            event: Event,
        ) GetEventStatusError!Result {
            const result = self.dispatch.vkGetEventStatus(
                device,
                event,
            );
            switch (result) {
                Result.eventSet => {},
                Result.eventReset => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub const SetEventError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn setEvent(
            self: Self,
            device: Device,
            event: Event,
        ) SetEventError!void {
            const result = self.dispatch.vkSetEvent(
                device,
                event,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const ResetEventError = error{
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn resetEvent(
            self: Self,
            device: Device,
            event: Event,
        ) ResetEventError!void {
            const result = self.dispatch.vkResetEvent(
                device,
                event,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const CreateQueryPoolError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createQueryPool(
            self: Self,
            device: Device,
            createInfo: QueryPoolCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateQueryPoolError!QueryPool {
            var queryPool: QueryPool = undefined;
            const result = self.dispatch.vkCreateQueryPool(
                device,
                &createInfo,
                pAllocator,
                &queryPool,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return queryPool;
        }
        pub fn destroyQueryPool(
            self: Self,
            device: Device,
            queryPool: QueryPool,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyQueryPool(
                device,
                queryPool,
                pAllocator,
            );
        }
        pub const GetQueryPoolResultsError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn getQueryPoolResults(
            self: Self,
            device: Device,
            queryPool: QueryPool,
            firstQuery: u32,
            queryCount: u32,
            dataSize: usize,
            pData: *c_void,
            stride: DeviceSize,
            flags: QueryResultFlags,
        ) GetQueryPoolResultsError!Result {
            const result = self.dispatch.vkGetQueryPoolResults(
                device,
                queryPool,
                firstQuery,
                queryCount,
                dataSize,
                pData,
                stride,
                flags.toInt(),
            );
            switch (result) {
                Result.success => {},
                Result.notReady => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn resetQueryPool(
            self: Self,
            device: Device,
            queryPool: QueryPool,
            firstQuery: u32,
            queryCount: u32,
        ) void {
            self.dispatch.vkResetQueryPool(
                device,
                queryPool,
                firstQuery,
                queryCount,
            );
        }
        pub const CreateBufferError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidOpaqueCaptureAddressKHR,
            Unknown,
        };
        pub fn createBuffer(
            self: Self,
            device: Device,
            createInfo: BufferCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateBufferError!Buffer {
            var buffer: Buffer = undefined;
            const result = self.dispatch.vkCreateBuffer(
                device,
                &createInfo,
                pAllocator,
                &buffer,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInvalidOpaqueCaptureAddressKHR => return error.InvalidOpaqueCaptureAddressKHR,
                else => return error.Unknown,
            }
            return buffer;
        }
        pub fn destroyBuffer(
            self: Self,
            device: Device,
            buffer: Buffer,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyBuffer(
                device,
                buffer,
                pAllocator,
            );
        }
        pub const CreateBufferViewError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createBufferView(
            self: Self,
            device: Device,
            createInfo: BufferViewCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateBufferViewError!BufferView {
            var view: BufferView = undefined;
            const result = self.dispatch.vkCreateBufferView(
                device,
                &createInfo,
                pAllocator,
                &view,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return view;
        }
        pub fn destroyBufferView(
            self: Self,
            device: Device,
            bufferView: BufferView,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyBufferView(
                device,
                bufferView,
                pAllocator,
            );
        }
        pub const CreateImageError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createImage(
            self: Self,
            device: Device,
            createInfo: ImageCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateImageError!Image {
            var image: Image = undefined;
            const result = self.dispatch.vkCreateImage(
                device,
                &createInfo,
                pAllocator,
                &image,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return image;
        }
        pub fn destroyImage(
            self: Self,
            device: Device,
            image: Image,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyImage(
                device,
                image,
                pAllocator,
            );
        }
        pub fn getImageSubresourceLayout(
            self: Self,
            device: Device,
            image: Image,
            subresource: ImageSubresource,
        ) SubresourceLayout {
            var layout: SubresourceLayout = undefined;
            self.dispatch.vkGetImageSubresourceLayout(
                device,
                image,
                &subresource,
                &layout,
            );
            return layout;
        }
        pub const CreateImageViewError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createImageView(
            self: Self,
            device: Device,
            createInfo: ImageViewCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateImageViewError!ImageView {
            var view: ImageView = undefined;
            const result = self.dispatch.vkCreateImageView(
                device,
                &createInfo,
                pAllocator,
                &view,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return view;
        }
        pub fn destroyImageView(
            self: Self,
            device: Device,
            imageView: ImageView,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyImageView(
                device,
                imageView,
                pAllocator,
            );
        }
        pub const CreateShaderModuleError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidShaderNV,
            Unknown,
        };
        pub fn createShaderModule(
            self: Self,
            device: Device,
            createInfo: ShaderModuleCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateShaderModuleError!ShaderModule {
            var shaderModule: ShaderModule = undefined;
            const result = self.dispatch.vkCreateShaderModule(
                device,
                &createInfo,
                pAllocator,
                &shaderModule,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInvalidShaderNV => return error.InvalidShaderNV,
                else => return error.Unknown,
            }
            return shaderModule;
        }
        pub fn destroyShaderModule(
            self: Self,
            device: Device,
            shaderModule: ShaderModule,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyShaderModule(
                device,
                shaderModule,
                pAllocator,
            );
        }
        pub const CreatePipelineCacheError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createPipelineCache(
            self: Self,
            device: Device,
            createInfo: PipelineCacheCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreatePipelineCacheError!PipelineCache {
            var pipelineCache: PipelineCache = undefined;
            const result = self.dispatch.vkCreatePipelineCache(
                device,
                &createInfo,
                pAllocator,
                &pipelineCache,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return pipelineCache;
        }
        pub fn destroyPipelineCache(
            self: Self,
            device: Device,
            pipelineCache: PipelineCache,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyPipelineCache(
                device,
                pipelineCache,
                pAllocator,
            );
        }
        pub const GetPipelineCacheDataError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPipelineCacheData(
            self: Self,
            device: Device,
            pipelineCache: PipelineCache,
            pDataSize: *usize,
            pData: ?*c_void,
        ) GetPipelineCacheDataError!Result {
            const result = self.dispatch.vkGetPipelineCacheData(
                device,
                pipelineCache,
                pDataSize,
                pData,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const MergePipelineCachesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn mergePipelineCaches(
            self: Self,
            device: Device,
            dstCache: PipelineCache,
            srcCacheCount: u32,
            pSrcCaches: [*]const PipelineCache,
        ) MergePipelineCachesError!void {
            const result = self.dispatch.vkMergePipelineCaches(
                device,
                dstCache,
                srcCacheCount,
                pSrcCaches,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const CreateGraphicsPipelinesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidShaderNV,
            Unknown,
        };
        pub fn createGraphicsPipelines(
            self: Self,
            device: Device,
            pipelineCache: PipelineCache,
            createInfoCount: u32,
            pCreateInfos: [*]const GraphicsPipelineCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
            pPipelines: [*]Pipeline,
        ) CreateGraphicsPipelinesError!Result {
            const result = self.dispatch.vkCreateGraphicsPipelines(
                device,
                pipelineCache,
                createInfoCount,
                pCreateInfos,
                pAllocator,
                pPipelines,
            );
            switch (result) {
                Result.success => {},
                Result.pipelineCompileRequiredEXT => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInvalidShaderNV => return error.InvalidShaderNV,
                else => return error.Unknown,
            }
            return result;
        }
        pub const CreateComputePipelinesError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidShaderNV,
            Unknown,
        };
        pub fn createComputePipelines(
            self: Self,
            device: Device,
            pipelineCache: PipelineCache,
            createInfoCount: u32,
            pCreateInfos: [*]const ComputePipelineCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
            pPipelines: [*]Pipeline,
        ) CreateComputePipelinesError!Result {
            const result = self.dispatch.vkCreateComputePipelines(
                device,
                pipelineCache,
                createInfoCount,
                pCreateInfos,
                pAllocator,
                pPipelines,
            );
            switch (result) {
                Result.success => {},
                Result.pipelineCompileRequiredEXT => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInvalidShaderNV => return error.InvalidShaderNV,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetDeviceSubpassShadingMaxWorkgroupSizeHUAWEIResult = struct {
            result: Result,
            maxWorkgroupSize: Extent2D,
        };
        pub const GetDeviceSubpassShadingMaxWorkgroupSizeHUAWEIError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getDeviceSubpassShadingMaxWorkgroupSizeHUAWEI(
            self: Self,
            device: Device,
            renderpass: RenderPass,
        ) GetDeviceSubpassShadingMaxWorkgroupSizeHUAWEIError!GetDeviceSubpassShadingMaxWorkgroupSizeHUAWEIResult {
            var return_values: GetDeviceSubpassShadingMaxWorkgroupSizeHUAWEIResult = undefined;
            const result = self.dispatch.vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI(
                device,
                renderpass,
                &return_values.maxWorkgroupSize,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return_values.result = result;
            return return_values;
        }
        pub fn destroyPipeline(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyPipeline(
                device,
                pipeline,
                pAllocator,
            );
        }
        pub const CreatePipelineLayoutError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createPipelineLayout(
            self: Self,
            device: Device,
            createInfo: PipelineLayoutCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreatePipelineLayoutError!PipelineLayout {
            var pipelineLayout: PipelineLayout = undefined;
            const result = self.dispatch.vkCreatePipelineLayout(
                device,
                &createInfo,
                pAllocator,
                &pipelineLayout,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return pipelineLayout;
        }
        pub fn destroyPipelineLayout(
            self: Self,
            device: Device,
            pipelineLayout: PipelineLayout,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyPipelineLayout(
                device,
                pipelineLayout,
                pAllocator,
            );
        }
        pub const CreateSamplerError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createSampler(
            self: Self,
            device: Device,
            createInfo: SamplerCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateSamplerError!Sampler {
            var sampler: Sampler = undefined;
            const result = self.dispatch.vkCreateSampler(
                device,
                &createInfo,
                pAllocator,
                &sampler,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return sampler;
        }
        pub fn destroySampler(
            self: Self,
            device: Device,
            sampler: Sampler,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroySampler(
                device,
                sampler,
                pAllocator,
            );
        }
        pub const CreateDescriptorSetLayoutError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createDescriptorSetLayout(
            self: Self,
            device: Device,
            createInfo: DescriptorSetLayoutCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDescriptorSetLayoutError!DescriptorSetLayout {
            var setLayout: DescriptorSetLayout = undefined;
            const result = self.dispatch.vkCreateDescriptorSetLayout(
                device,
                &createInfo,
                pAllocator,
                &setLayout,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return setLayout;
        }
        pub fn destroyDescriptorSetLayout(
            self: Self,
            device: Device,
            descriptorSetLayout: DescriptorSetLayout,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyDescriptorSetLayout(
                device,
                descriptorSetLayout,
                pAllocator,
            );
        }
        pub const CreateDescriptorPoolError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            FragmentationEXT,
            Unknown,
        };
        pub fn createDescriptorPool(
            self: Self,
            device: Device,
            createInfo: DescriptorPoolCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDescriptorPoolError!DescriptorPool {
            var descriptorPool: DescriptorPool = undefined;
            const result = self.dispatch.vkCreateDescriptorPool(
                device,
                &createInfo,
                pAllocator,
                &descriptorPool,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorFragmentationEXT => return error.FragmentationEXT,
                else => return error.Unknown,
            }
            return descriptorPool;
        }
        pub fn destroyDescriptorPool(
            self: Self,
            device: Device,
            descriptorPool: DescriptorPool,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyDescriptorPool(
                device,
                descriptorPool,
                pAllocator,
            );
        }
        pub fn resetDescriptorPool(
            self: Self,
            device: Device,
            descriptorPool: DescriptorPool,
            flags: DescriptorPoolResetFlags,
        ) void {
            const result = self.dispatch.vkResetDescriptorPool(
                device,
                descriptorPool,
                flags.toInt(),
            );
            switch (result) {
                Result.success => {},
                else => return error.Unknown,
            }
        }
        pub const AllocateDescriptorSetsError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            FragmentedPool,
            OutOfPoolMemory,
            Unknown,
        };
        pub fn allocateDescriptorSets(
            self: Self,
            device: Device,
            allocateInfo: DescriptorSetAllocateInfo,
            pDescriptorSets: [*]DescriptorSet,
        ) AllocateDescriptorSetsError!void {
            const result = self.dispatch.vkAllocateDescriptorSets(
                device,
                &allocateInfo,
                pDescriptorSets,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorFragmentedPool => return error.FragmentedPool,
                Result.errorOutOfPoolMemory => return error.OutOfPoolMemory,
                else => return error.Unknown,
            }
        }
        pub fn freeDescriptorSets(
            self: Self,
            device: Device,
            descriptorPool: DescriptorPool,
            descriptorSetCount: u32,
            pDescriptorSets: [*]const DescriptorSet,
        ) void {
            const result = self.dispatch.vkFreeDescriptorSets(
                device,
                descriptorPool,
                descriptorSetCount,
                pDescriptorSets,
            );
            switch (result) {
                Result.success => {},
                else => return error.Unknown,
            }
        }
        pub fn updateDescriptorSets(
            self: Self,
            device: Device,
            descriptorWriteCount: u32,
            pDescriptorWrites: [*]const WriteDescriptorSet,
            descriptorCopyCount: u32,
            pDescriptorCopies: [*]const CopyDescriptorSet,
        ) void {
            self.dispatch.vkUpdateDescriptorSets(
                device,
                descriptorWriteCount,
                pDescriptorWrites,
                descriptorCopyCount,
                pDescriptorCopies,
            );
        }
        pub const CreateFramebufferError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createFramebuffer(
            self: Self,
            device: Device,
            createInfo: FramebufferCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateFramebufferError!Framebuffer {
            var framebuffer: Framebuffer = undefined;
            const result = self.dispatch.vkCreateFramebuffer(
                device,
                &createInfo,
                pAllocator,
                &framebuffer,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return framebuffer;
        }
        pub fn destroyFramebuffer(
            self: Self,
            device: Device,
            framebuffer: Framebuffer,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyFramebuffer(
                device,
                framebuffer,
                pAllocator,
            );
        }
        pub const CreateRenderPassError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createRenderPass(
            self: Self,
            device: Device,
            createInfo: RenderPassCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateRenderPassError!RenderPass {
            var renderPass: RenderPass = undefined;
            const result = self.dispatch.vkCreateRenderPass(
                device,
                &createInfo,
                pAllocator,
                &renderPass,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return renderPass;
        }
        pub fn destroyRenderPass(
            self: Self,
            device: Device,
            renderPass: RenderPass,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyRenderPass(
                device,
                renderPass,
                pAllocator,
            );
        }
        pub fn getRenderAreaGranularity(
            self: Self,
            device: Device,
            renderPass: RenderPass,
        ) Extent2D {
            var granularity: Extent2D = undefined;
            self.dispatch.vkGetRenderAreaGranularity(
                device,
                renderPass,
                &granularity,
            );
            return granularity;
        }
        pub const CreateCommandPoolError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createCommandPool(
            self: Self,
            device: Device,
            createInfo: CommandPoolCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateCommandPoolError!CommandPool {
            var commandPool: CommandPool = undefined;
            const result = self.dispatch.vkCreateCommandPool(
                device,
                &createInfo,
                pAllocator,
                &commandPool,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return commandPool;
        }
        pub fn destroyCommandPool(
            self: Self,
            device: Device,
            commandPool: CommandPool,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyCommandPool(
                device,
                commandPool,
                pAllocator,
            );
        }
        pub const ResetCommandPoolError = error{
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn resetCommandPool(
            self: Self,
            device: Device,
            commandPool: CommandPool,
            flags: CommandPoolResetFlags,
        ) ResetCommandPoolError!void {
            const result = self.dispatch.vkResetCommandPool(
                device,
                commandPool,
                flags.toInt(),
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const AllocateCommandBuffersError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn allocateCommandBuffers(
            self: Self,
            device: Device,
            allocateInfo: CommandBufferAllocateInfo,
            pCommandBuffers: [*]CommandBuffer,
        ) AllocateCommandBuffersError!void {
            const result = self.dispatch.vkAllocateCommandBuffers(
                device,
                &allocateInfo,
                pCommandBuffers,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn freeCommandBuffers(
            self: Self,
            device: Device,
            commandPool: CommandPool,
            commandBufferCount: u32,
            pCommandBuffers: [*]const CommandBuffer,
        ) void {
            self.dispatch.vkFreeCommandBuffers(
                device,
                commandPool,
                commandBufferCount,
                pCommandBuffers,
            );
        }
        pub const BeginCommandBufferError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn beginCommandBuffer(
            self: Self,
            commandBuffer: CommandBuffer,
            beginInfo: CommandBufferBeginInfo,
        ) BeginCommandBufferError!void {
            const result = self.dispatch.vkBeginCommandBuffer(
                commandBuffer,
                &beginInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const EndCommandBufferError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn endCommandBuffer(
            self: Self,
            commandBuffer: CommandBuffer,
        ) EndCommandBufferError!void {
            const result = self.dispatch.vkEndCommandBuffer(
                commandBuffer,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const ResetCommandBufferError = error{
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn resetCommandBuffer(
            self: Self,
            commandBuffer: CommandBuffer,
            flags: CommandBufferResetFlags,
        ) ResetCommandBufferError!void {
            const result = self.dispatch.vkResetCommandBuffer(
                commandBuffer,
                flags.toInt(),
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdBindPipeline(
            self: Self,
            commandBuffer: CommandBuffer,
            pipelineBindPoint: PipelineBindPoint,
            pipeline: Pipeline,
        ) void {
            self.dispatch.vkCmdBindPipeline(
                commandBuffer,
                pipelineBindPoint,
                pipeline,
            );
        }
        pub fn cmdSetViewport(
            self: Self,
            commandBuffer: CommandBuffer,
            firstViewport: u32,
            viewportCount: u32,
            pViewports: [*]const Viewport,
        ) void {
            self.dispatch.vkCmdSetViewport(
                commandBuffer,
                firstViewport,
                viewportCount,
                pViewports,
            );
        }
        pub fn cmdSetScissor(
            self: Self,
            commandBuffer: CommandBuffer,
            firstScissor: u32,
            scissorCount: u32,
            pScissors: [*]const Rect2D,
        ) void {
            self.dispatch.vkCmdSetScissor(
                commandBuffer,
                firstScissor,
                scissorCount,
                pScissors,
            );
        }
        pub fn cmdSetLineWidth(
            self: Self,
            commandBuffer: CommandBuffer,
            lineWidth: f32,
        ) void {
            self.dispatch.vkCmdSetLineWidth(
                commandBuffer,
                lineWidth,
            );
        }
        pub fn cmdSetDepthBias(
            self: Self,
            commandBuffer: CommandBuffer,
            depthBiasConstantFactor: f32,
            depthBiasClamp: f32,
            depthBiasSlopeFactor: f32,
        ) void {
            self.dispatch.vkCmdSetDepthBias(
                commandBuffer,
                depthBiasConstantFactor,
                depthBiasClamp,
                depthBiasSlopeFactor,
            );
        }
        pub fn cmdSetBlendConstants(
            self: Self,
            commandBuffer: CommandBuffer,
            blendConstants: [4]f32,
        ) void {
            self.dispatch.vkCmdSetBlendConstants(
                commandBuffer,
                blendConstants,
            );
        }
        pub fn cmdSetDepthBounds(
            self: Self,
            commandBuffer: CommandBuffer,
            minDepthBounds: f32,
            maxDepthBounds: f32,
        ) void {
            self.dispatch.vkCmdSetDepthBounds(
                commandBuffer,
                minDepthBounds,
                maxDepthBounds,
            );
        }
        pub fn cmdSetStencilCompareMask(
            self: Self,
            commandBuffer: CommandBuffer,
            faceMask: StencilFaceFlags,
            compareMask: u32,
        ) void {
            self.dispatch.vkCmdSetStencilCompareMask(
                commandBuffer,
                faceMask.toInt(),
                compareMask,
            );
        }
        pub fn cmdSetStencilWriteMask(
            self: Self,
            commandBuffer: CommandBuffer,
            faceMask: StencilFaceFlags,
            writeMask: u32,
        ) void {
            self.dispatch.vkCmdSetStencilWriteMask(
                commandBuffer,
                faceMask.toInt(),
                writeMask,
            );
        }
        pub fn cmdSetStencilReference(
            self: Self,
            commandBuffer: CommandBuffer,
            faceMask: StencilFaceFlags,
            reference: u32,
        ) void {
            self.dispatch.vkCmdSetStencilReference(
                commandBuffer,
                faceMask.toInt(),
                reference,
            );
        }
        pub fn cmdBindDescriptorSets(
            self: Self,
            commandBuffer: CommandBuffer,
            pipelineBindPoint: PipelineBindPoint,
            layout: PipelineLayout,
            firstSet: u32,
            descriptorSetCount: u32,
            pDescriptorSets: [*]const DescriptorSet,
            dynamicOffsetCount: u32,
            pDynamicOffsets: [*]const u32,
        ) void {
            self.dispatch.vkCmdBindDescriptorSets(
                commandBuffer,
                pipelineBindPoint,
                layout,
                firstSet,
                descriptorSetCount,
                pDescriptorSets,
                dynamicOffsetCount,
                pDynamicOffsets,
            );
        }
        pub fn cmdBindIndexBuffer(
            self: Self,
            commandBuffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            indexType: IndexType,
        ) void {
            self.dispatch.vkCmdBindIndexBuffer(
                commandBuffer,
                buffer,
                offset,
                indexType,
            );
        }
        pub fn cmdBindVertexBuffers(
            self: Self,
            commandBuffer: CommandBuffer,
            firstBinding: u32,
            bindingCount: u32,
            pBuffers: [*]const Buffer,
            pOffsets: [*]const DeviceSize,
        ) void {
            self.dispatch.vkCmdBindVertexBuffers(
                commandBuffer,
                firstBinding,
                bindingCount,
                pBuffers,
                pOffsets,
            );
        }
        pub fn cmdDraw(
            self: Self,
            commandBuffer: CommandBuffer,
            vertexCount: u32,
            instanceCount: u32,
            firstVertex: u32,
            firstInstance: u32,
        ) void {
            self.dispatch.vkCmdDraw(
                commandBuffer,
                vertexCount,
                instanceCount,
                firstVertex,
                firstInstance,
            );
        }
        pub fn cmdDrawIndexed(
            self: Self,
            commandBuffer: CommandBuffer,
            indexCount: u32,
            instanceCount: u32,
            firstIndex: u32,
            vertexOffset: i32,
            firstInstance: u32,
        ) void {
            self.dispatch.vkCmdDrawIndexed(
                commandBuffer,
                indexCount,
                instanceCount,
                firstIndex,
                vertexOffset,
                firstInstance,
            );
        }
        pub fn cmdDrawMultiEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            drawCount: u32,
            pVertexInfo: [*]const MultiDrawInfoEXT,
            instanceCount: u32,
            firstInstance: u32,
            stride: u32,
        ) void {
            self.dispatch.vkCmdDrawMultiEXT(
                commandBuffer,
                drawCount,
                pVertexInfo,
                instanceCount,
                firstInstance,
                stride,
            );
        }
        pub fn cmdDrawMultiIndexedEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            drawCount: u32,
            pIndexInfo: [*]const MultiDrawIndexedInfoEXT,
            instanceCount: u32,
            firstInstance: u32,
            stride: u32,
            pVertexOffset: ?*const i32,
        ) void {
            self.dispatch.vkCmdDrawMultiIndexedEXT(
                commandBuffer,
                drawCount,
                pIndexInfo,
                instanceCount,
                firstInstance,
                stride,
                pVertexOffset,
            );
        }
        pub fn cmdDrawIndirect(
            self: Self,
            commandBuffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            drawCount: u32,
            stride: u32,
        ) void {
            self.dispatch.vkCmdDrawIndirect(
                commandBuffer,
                buffer,
                offset,
                drawCount,
                stride,
            );
        }
        pub fn cmdDrawIndexedIndirect(
            self: Self,
            commandBuffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            drawCount: u32,
            stride: u32,
        ) void {
            self.dispatch.vkCmdDrawIndexedIndirect(
                commandBuffer,
                buffer,
                offset,
                drawCount,
                stride,
            );
        }
        pub fn cmdDispatch(
            self: Self,
            commandBuffer: CommandBuffer,
            groupCountX: u32,
            groupCountY: u32,
            groupCountZ: u32,
        ) void {
            self.dispatch.vkCmdDispatch(
                commandBuffer,
                groupCountX,
                groupCountY,
                groupCountZ,
            );
        }
        pub fn cmdDispatchIndirect(
            self: Self,
            commandBuffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
        ) void {
            self.dispatch.vkCmdDispatchIndirect(
                commandBuffer,
                buffer,
                offset,
            );
        }
        pub fn cmdSubpassShadingHUAWEI(
            self: Self,
            commandBuffer: CommandBuffer,
        ) void {
            self.dispatch.vkCmdSubpassShadingHUAWEI(
                commandBuffer,
            );
        }
        pub fn cmdCopyBuffer(
            self: Self,
            commandBuffer: CommandBuffer,
            srcBuffer: Buffer,
            dstBuffer: Buffer,
            regionCount: u32,
            pRegions: [*]const BufferCopy,
        ) void {
            self.dispatch.vkCmdCopyBuffer(
                commandBuffer,
                srcBuffer,
                dstBuffer,
                regionCount,
                pRegions,
            );
        }
        pub fn cmdCopyImage(
            self: Self,
            commandBuffer: CommandBuffer,
            srcImage: Image,
            srcImageLayout: ImageLayout,
            dstImage: Image,
            dstImageLayout: ImageLayout,
            regionCount: u32,
            pRegions: [*]const ImageCopy,
        ) void {
            self.dispatch.vkCmdCopyImage(
                commandBuffer,
                srcImage,
                srcImageLayout,
                dstImage,
                dstImageLayout,
                regionCount,
                pRegions,
            );
        }
        pub fn cmdBlitImage(
            self: Self,
            commandBuffer: CommandBuffer,
            srcImage: Image,
            srcImageLayout: ImageLayout,
            dstImage: Image,
            dstImageLayout: ImageLayout,
            regionCount: u32,
            pRegions: [*]const ImageBlit,
            filter: Filter,
        ) void {
            self.dispatch.vkCmdBlitImage(
                commandBuffer,
                srcImage,
                srcImageLayout,
                dstImage,
                dstImageLayout,
                regionCount,
                pRegions,
                filter,
            );
        }
        pub fn cmdCopyBufferToImage(
            self: Self,
            commandBuffer: CommandBuffer,
            srcBuffer: Buffer,
            dstImage: Image,
            dstImageLayout: ImageLayout,
            regionCount: u32,
            pRegions: [*]const BufferImageCopy,
        ) void {
            self.dispatch.vkCmdCopyBufferToImage(
                commandBuffer,
                srcBuffer,
                dstImage,
                dstImageLayout,
                regionCount,
                pRegions,
            );
        }
        pub fn cmdCopyImageToBuffer(
            self: Self,
            commandBuffer: CommandBuffer,
            srcImage: Image,
            srcImageLayout: ImageLayout,
            dstBuffer: Buffer,
            regionCount: u32,
            pRegions: [*]const BufferImageCopy,
        ) void {
            self.dispatch.vkCmdCopyImageToBuffer(
                commandBuffer,
                srcImage,
                srcImageLayout,
                dstBuffer,
                regionCount,
                pRegions,
            );
        }
        pub fn cmdUpdateBuffer(
            self: Self,
            commandBuffer: CommandBuffer,
            dstBuffer: Buffer,
            dstOffset: DeviceSize,
            dataSize: DeviceSize,
            pData: *const c_void,
        ) void {
            self.dispatch.vkCmdUpdateBuffer(
                commandBuffer,
                dstBuffer,
                dstOffset,
                dataSize,
                pData,
            );
        }
        pub fn cmdFillBuffer(
            self: Self,
            commandBuffer: CommandBuffer,
            dstBuffer: Buffer,
            dstOffset: DeviceSize,
            size: DeviceSize,
            data: u32,
        ) void {
            self.dispatch.vkCmdFillBuffer(
                commandBuffer,
                dstBuffer,
                dstOffset,
                size,
                data,
            );
        }
        pub fn cmdClearColorImage(
            self: Self,
            commandBuffer: CommandBuffer,
            image: Image,
            imageLayout: ImageLayout,
            color: ClearColorValue,
            rangeCount: u32,
            pRanges: [*]const ImageSubresourceRange,
        ) void {
            self.dispatch.vkCmdClearColorImage(
                commandBuffer,
                image,
                imageLayout,
                &color,
                rangeCount,
                pRanges,
            );
        }
        pub fn cmdClearDepthStencilImage(
            self: Self,
            commandBuffer: CommandBuffer,
            image: Image,
            imageLayout: ImageLayout,
            depthStencil: ClearDepthStencilValue,
            rangeCount: u32,
            pRanges: [*]const ImageSubresourceRange,
        ) void {
            self.dispatch.vkCmdClearDepthStencilImage(
                commandBuffer,
                image,
                imageLayout,
                &depthStencil,
                rangeCount,
                pRanges,
            );
        }
        pub fn cmdClearAttachments(
            self: Self,
            commandBuffer: CommandBuffer,
            attachmentCount: u32,
            pAttachments: [*]const ClearAttachment,
            rectCount: u32,
            pRects: [*]const ClearRect,
        ) void {
            self.dispatch.vkCmdClearAttachments(
                commandBuffer,
                attachmentCount,
                pAttachments,
                rectCount,
                pRects,
            );
        }
        pub fn cmdResolveImage(
            self: Self,
            commandBuffer: CommandBuffer,
            srcImage: Image,
            srcImageLayout: ImageLayout,
            dstImage: Image,
            dstImageLayout: ImageLayout,
            regionCount: u32,
            pRegions: [*]const ImageResolve,
        ) void {
            self.dispatch.vkCmdResolveImage(
                commandBuffer,
                srcImage,
                srcImageLayout,
                dstImage,
                dstImageLayout,
                regionCount,
                pRegions,
            );
        }
        pub fn cmdSetEvent(
            self: Self,
            commandBuffer: CommandBuffer,
            event: Event,
            stageMask: PipelineStageFlags,
        ) void {
            self.dispatch.vkCmdSetEvent(
                commandBuffer,
                event,
                stageMask.toInt(),
            );
        }
        pub fn cmdResetEvent(
            self: Self,
            commandBuffer: CommandBuffer,
            event: Event,
            stageMask: PipelineStageFlags,
        ) void {
            self.dispatch.vkCmdResetEvent(
                commandBuffer,
                event,
                stageMask.toInt(),
            );
        }
        pub fn cmdWaitEvents(
            self: Self,
            commandBuffer: CommandBuffer,
            eventCount: u32,
            pEvents: [*]const Event,
            srcStageMask: PipelineStageFlags,
            dstStageMask: PipelineStageFlags,
            memoryBarrierCount: u32,
            pMemoryBarriers: [*]const MemoryBarrier,
            bufferMemoryBarrierCount: u32,
            pBufferMemoryBarriers: [*]const BufferMemoryBarrier,
            imageMemoryBarrierCount: u32,
            pImageMemoryBarriers: [*]const ImageMemoryBarrier,
        ) void {
            self.dispatch.vkCmdWaitEvents(
                commandBuffer,
                eventCount,
                pEvents,
                srcStageMask.toInt(),
                dstStageMask.toInt(),
                memoryBarrierCount,
                pMemoryBarriers,
                bufferMemoryBarrierCount,
                pBufferMemoryBarriers,
                imageMemoryBarrierCount,
                pImageMemoryBarriers,
            );
        }
        pub fn cmdPipelineBarrier(
            self: Self,
            commandBuffer: CommandBuffer,
            srcStageMask: PipelineStageFlags,
            dstStageMask: PipelineStageFlags,
            dependencyFlags: DependencyFlags,
            memoryBarrierCount: u32,
            pMemoryBarriers: [*]const MemoryBarrier,
            bufferMemoryBarrierCount: u32,
            pBufferMemoryBarriers: [*]const BufferMemoryBarrier,
            imageMemoryBarrierCount: u32,
            pImageMemoryBarriers: [*]const ImageMemoryBarrier,
        ) void {
            self.dispatch.vkCmdPipelineBarrier(
                commandBuffer,
                srcStageMask.toInt(),
                dstStageMask.toInt(),
                dependencyFlags.toInt(),
                memoryBarrierCount,
                pMemoryBarriers,
                bufferMemoryBarrierCount,
                pBufferMemoryBarriers,
                imageMemoryBarrierCount,
                pImageMemoryBarriers,
            );
        }
        pub fn cmdBeginQuery(
            self: Self,
            commandBuffer: CommandBuffer,
            queryPool: QueryPool,
            query: u32,
            flags: QueryControlFlags,
        ) void {
            self.dispatch.vkCmdBeginQuery(
                commandBuffer,
                queryPool,
                query,
                flags.toInt(),
            );
        }
        pub fn cmdEndQuery(
            self: Self,
            commandBuffer: CommandBuffer,
            queryPool: QueryPool,
            query: u32,
        ) void {
            self.dispatch.vkCmdEndQuery(
                commandBuffer,
                queryPool,
                query,
            );
        }
        pub fn cmdBeginConditionalRenderingEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            conditionalRenderingBegin: ConditionalRenderingBeginInfoEXT,
        ) void {
            self.dispatch.vkCmdBeginConditionalRenderingEXT(
                commandBuffer,
                &conditionalRenderingBegin,
            );
        }
        pub fn cmdEndConditionalRenderingEXT(
            self: Self,
            commandBuffer: CommandBuffer,
        ) void {
            self.dispatch.vkCmdEndConditionalRenderingEXT(
                commandBuffer,
            );
        }
        pub fn cmdResetQueryPool(
            self: Self,
            commandBuffer: CommandBuffer,
            queryPool: QueryPool,
            firstQuery: u32,
            queryCount: u32,
        ) void {
            self.dispatch.vkCmdResetQueryPool(
                commandBuffer,
                queryPool,
                firstQuery,
                queryCount,
            );
        }
        pub fn cmdWriteTimestamp(
            self: Self,
            commandBuffer: CommandBuffer,
            pipelineStage: PipelineStageFlags,
            queryPool: QueryPool,
            query: u32,
        ) void {
            self.dispatch.vkCmdWriteTimestamp(
                commandBuffer,
                pipelineStage.toInt(),
                queryPool,
                query,
            );
        }
        pub fn cmdCopyQueryPoolResults(
            self: Self,
            commandBuffer: CommandBuffer,
            queryPool: QueryPool,
            firstQuery: u32,
            queryCount: u32,
            dstBuffer: Buffer,
            dstOffset: DeviceSize,
            stride: DeviceSize,
            flags: QueryResultFlags,
        ) void {
            self.dispatch.vkCmdCopyQueryPoolResults(
                commandBuffer,
                queryPool,
                firstQuery,
                queryCount,
                dstBuffer,
                dstOffset,
                stride,
                flags.toInt(),
            );
        }
        pub fn cmdPushConstants(
            self: Self,
            commandBuffer: CommandBuffer,
            layout: PipelineLayout,
            stageFlags: ShaderStageFlags,
            offset: u32,
            size: u32,
            pValues: *const c_void,
        ) void {
            self.dispatch.vkCmdPushConstants(
                commandBuffer,
                layout,
                stageFlags.toInt(),
                offset,
                size,
                pValues,
            );
        }
        pub fn cmdBeginRenderPass(
            self: Self,
            commandBuffer: CommandBuffer,
            renderPassBegin: RenderPassBeginInfo,
            contents: SubpassContents,
        ) void {
            self.dispatch.vkCmdBeginRenderPass(
                commandBuffer,
                &renderPassBegin,
                contents,
            );
        }
        pub fn cmdNextSubpass(
            self: Self,
            commandBuffer: CommandBuffer,
            contents: SubpassContents,
        ) void {
            self.dispatch.vkCmdNextSubpass(
                commandBuffer,
                contents,
            );
        }
        pub fn cmdEndRenderPass(
            self: Self,
            commandBuffer: CommandBuffer,
        ) void {
            self.dispatch.vkCmdEndRenderPass(
                commandBuffer,
            );
        }
        pub fn cmdExecuteCommands(
            self: Self,
            commandBuffer: CommandBuffer,
            commandBufferCount: u32,
            pCommandBuffers: [*]const CommandBuffer,
        ) void {
            self.dispatch.vkCmdExecuteCommands(
                commandBuffer,
                commandBufferCount,
                pCommandBuffers,
            );
        }
        pub const CreateSharedSwapchainsKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            IncompatibleDisplayKHR,
            DeviceLost,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn createSharedSwapchainsKHR(
            self: Self,
            device: Device,
            swapchainCount: u32,
            pCreateInfos: [*]const SwapchainCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
            pSwapchains: [*]SwapchainKHR,
        ) CreateSharedSwapchainsKHRError!void {
            const result = self.dispatch.vkCreateSharedSwapchainsKHR(
                device,
                swapchainCount,
                pCreateInfos,
                pAllocator,
                pSwapchains,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorIncompatibleDisplayKHR => return error.IncompatibleDisplayKHR,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub const CreateSwapchainKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            SurfaceLostKHR,
            NativeWindowInUseKHR,
            InitializationFailed,
            Unknown,
        };
        pub fn createSwapchainKHR(
            self: Self,
            device: Device,
            createInfo: SwapchainCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateSwapchainKHRError!SwapchainKHR {
            var swapchain: SwapchainKHR = undefined;
            const result = self.dispatch.vkCreateSwapchainKHR(
                device,
                &createInfo,
                pAllocator,
                &swapchain,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                Result.errorNativeWindowInUseKHR => return error.NativeWindowInUseKHR,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return swapchain;
        }
        pub fn destroySwapchainKHR(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroySwapchainKHR(
                device,
                swapchain,
                pAllocator,
            );
        }
        pub const GetSwapchainImagesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getSwapchainImagesKHR(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            pSwapchainImageCount: *u32,
            pSwapchainImages: ?[*]Image,
        ) GetSwapchainImagesKHRError!Result {
            const result = self.dispatch.vkGetSwapchainImagesKHR(
                device,
                swapchain,
                pSwapchainImageCount,
                pSwapchainImages,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const AcquireNextImageKHRResult = struct {
            result: Result,
            imageIndex: u32,
        };
        pub const AcquireNextImageKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            FullScreenExclusiveModeLostEXT,
            Unknown,
        };
        pub fn acquireNextImageKHR(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            timeout: u64,
            semaphore: Semaphore,
            fence: Fence,
        ) AcquireNextImageKHRError!AcquireNextImageKHRResult {
            var return_values: AcquireNextImageKHRResult = undefined;
            const result = self.dispatch.vkAcquireNextImageKHR(
                device,
                swapchain,
                timeout,
                semaphore,
                fence,
                &return_values.imageIndex,
            );
            switch (result) {
                Result.success => {},
                Result.timeout => {},
                Result.notReady => {},
                Result.suboptimalKHR => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorOutOfDateKHR => return error.OutOfDateKHR,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                Result.errorFullScreenExclusiveModeLostEXT => return error.FullScreenExclusiveModeLostEXT,
                else => return error.Unknown,
            }
            return_values.result = result;
            return return_values;
        }
        pub const QueuePresentKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            FullScreenExclusiveModeLostEXT,
            Unknown,
        };
        pub fn queuePresentKHR(
            self: Self,
            queue: Queue,
            presentInfo: PresentInfoKHR,
        ) QueuePresentKHRError!Result {
            const result = self.dispatch.vkQueuePresentKHR(
                queue,
                &presentInfo,
            );
            switch (result) {
                Result.success => {},
                Result.suboptimalKHR => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorOutOfDateKHR => return error.OutOfDateKHR,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                Result.errorFullScreenExclusiveModeLostEXT => return error.FullScreenExclusiveModeLostEXT,
                else => return error.Unknown,
            }
            return result;
        }
        pub const DebugMarkerSetObjectNameEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn debugMarkerSetObjectNameEXT(
            self: Self,
            device: Device,
            nameInfo: DebugMarkerObjectNameInfoEXT,
        ) DebugMarkerSetObjectNameEXTError!void {
            const result = self.dispatch.vkDebugMarkerSetObjectNameEXT(
                device,
                &nameInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const DebugMarkerSetObjectTagEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn debugMarkerSetObjectTagEXT(
            self: Self,
            device: Device,
            tagInfo: DebugMarkerObjectTagInfoEXT,
        ) DebugMarkerSetObjectTagEXTError!void {
            const result = self.dispatch.vkDebugMarkerSetObjectTagEXT(
                device,
                &tagInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdDebugMarkerBeginEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            markerInfo: DebugMarkerMarkerInfoEXT,
        ) void {
            self.dispatch.vkCmdDebugMarkerBeginEXT(
                commandBuffer,
                &markerInfo,
            );
        }
        pub fn cmdDebugMarkerEndEXT(
            self: Self,
            commandBuffer: CommandBuffer,
        ) void {
            self.dispatch.vkCmdDebugMarkerEndEXT(
                commandBuffer,
            );
        }
        pub fn cmdDebugMarkerInsertEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            markerInfo: DebugMarkerMarkerInfoEXT,
        ) void {
            self.dispatch.vkCmdDebugMarkerInsertEXT(
                commandBuffer,
                &markerInfo,
            );
        }
        pub const GetMemoryWin32HandleNVError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getMemoryWin32HandleNV(
            self: Self,
            device: Device,
            memory: DeviceMemory,
            handleType: ExternalMemoryHandleTypeFlagsNV,
            pHandle: *HANDLE,
        ) GetMemoryWin32HandleNVError!void {
            const result = self.dispatch.vkGetMemoryWin32HandleNV(
                device,
                memory,
                handleType.toInt(),
                pHandle,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdExecuteGeneratedCommandsNV(
            self: Self,
            commandBuffer: CommandBuffer,
            isPreprocessed: Bool32,
            generatedCommandsInfo: GeneratedCommandsInfoNV,
        ) void {
            self.dispatch.vkCmdExecuteGeneratedCommandsNV(
                commandBuffer,
                isPreprocessed,
                &generatedCommandsInfo,
            );
        }
        pub fn cmdPreprocessGeneratedCommandsNV(
            self: Self,
            commandBuffer: CommandBuffer,
            generatedCommandsInfo: GeneratedCommandsInfoNV,
        ) void {
            self.dispatch.vkCmdPreprocessGeneratedCommandsNV(
                commandBuffer,
                &generatedCommandsInfo,
            );
        }
        pub fn cmdBindPipelineShaderGroupNV(
            self: Self,
            commandBuffer: CommandBuffer,
            pipelineBindPoint: PipelineBindPoint,
            pipeline: Pipeline,
            groupIndex: u32,
        ) void {
            self.dispatch.vkCmdBindPipelineShaderGroupNV(
                commandBuffer,
                pipelineBindPoint,
                pipeline,
                groupIndex,
            );
        }
        pub fn getGeneratedCommandsMemoryRequirementsNV(
            self: Self,
            device: Device,
            info: GeneratedCommandsMemoryRequirementsInfoNV,
            pMemoryRequirements: *MemoryRequirements2,
        ) void {
            self.dispatch.vkGetGeneratedCommandsMemoryRequirementsNV(
                device,
                &info,
                pMemoryRequirements,
            );
        }
        pub const CreateIndirectCommandsLayoutNVError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createIndirectCommandsLayoutNV(
            self: Self,
            device: Device,
            createInfo: IndirectCommandsLayoutCreateInfoNV,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateIndirectCommandsLayoutNVError!IndirectCommandsLayoutNV {
            var indirectCommandsLayout: IndirectCommandsLayoutNV = undefined;
            const result = self.dispatch.vkCreateIndirectCommandsLayoutNV(
                device,
                &createInfo,
                pAllocator,
                &indirectCommandsLayout,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return indirectCommandsLayout;
        }
        pub fn destroyIndirectCommandsLayoutNV(
            self: Self,
            device: Device,
            indirectCommandsLayout: IndirectCommandsLayoutNV,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyIndirectCommandsLayoutNV(
                device,
                indirectCommandsLayout,
                pAllocator,
            );
        }
        pub fn cmdPushDescriptorSetKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            pipelineBindPoint: PipelineBindPoint,
            layout: PipelineLayout,
            set: u32,
            descriptorWriteCount: u32,
            pDescriptorWrites: [*]const WriteDescriptorSet,
        ) void {
            self.dispatch.vkCmdPushDescriptorSetKHR(
                commandBuffer,
                pipelineBindPoint,
                layout,
                set,
                descriptorWriteCount,
                pDescriptorWrites,
            );
        }
        pub fn trimCommandPool(
            self: Self,
            device: Device,
            commandPool: CommandPool,
            flags: CommandPoolTrimFlags,
        ) void {
            self.dispatch.vkTrimCommandPool(
                device,
                commandPool,
                flags.toInt(),
            );
        }
        pub const GetMemoryWin32HandleKHRError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getMemoryWin32HandleKHR(
            self: Self,
            device: Device,
            getWin32HandleInfo: MemoryGetWin32HandleInfoKHR,
            pHandle: *HANDLE,
        ) GetMemoryWin32HandleKHRError!void {
            const result = self.dispatch.vkGetMemoryWin32HandleKHR(
                device,
                &getWin32HandleInfo,
                pHandle,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const GetMemoryWin32HandlePropertiesKHRError = error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        };
        pub fn getMemoryWin32HandlePropertiesKHR(
            self: Self,
            device: Device,
            handleType: ExternalMemoryHandleTypeFlags,
            handle: HANDLE,
            pMemoryWin32HandleProperties: *MemoryWin32HandlePropertiesKHR,
        ) GetMemoryWin32HandlePropertiesKHRError!void {
            const result = self.dispatch.vkGetMemoryWin32HandlePropertiesKHR(
                device,
                handleType.toInt(),
                handle,
                pMemoryWin32HandleProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub const GetMemoryFdKHRError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getMemoryFdKHR(
            self: Self,
            device: Device,
            getFdInfo: MemoryGetFdInfoKHR,
        ) GetMemoryFdKHRError!c_int {
            var fd: c_int = undefined;
            const result = self.dispatch.vkGetMemoryFdKHR(
                device,
                &getFdInfo,
                &fd,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fd;
        }
        pub const GetMemoryFdPropertiesKHRError = error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        };
        pub fn getMemoryFdPropertiesKHR(
            self: Self,
            device: Device,
            handleType: ExternalMemoryHandleTypeFlags,
            fd: c_int,
            pMemoryFdProperties: *MemoryFdPropertiesKHR,
        ) GetMemoryFdPropertiesKHRError!void {
            const result = self.dispatch.vkGetMemoryFdPropertiesKHR(
                device,
                handleType.toInt(),
                fd,
                pMemoryFdProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub const GetMemoryZirconHandleFUCHSIAError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getMemoryZirconHandleFUCHSIA(
            self: Self,
            device: Device,
            getZirconHandleInfo: MemoryGetZirconHandleInfoFUCHSIA,
            pZirconHandle: *zx_handle_t,
        ) GetMemoryZirconHandleFUCHSIAError!void {
            const result = self.dispatch.vkGetMemoryZirconHandleFUCHSIA(
                device,
                &getZirconHandleInfo,
                pZirconHandle,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const GetMemoryZirconHandlePropertiesFUCHSIAError = error{
            InvalidExternalHandle,
            Unknown,
        };
        pub fn getMemoryZirconHandlePropertiesFUCHSIA(
            self: Self,
            device: Device,
            handleType: ExternalMemoryHandleTypeFlags,
            zirconHandle: zx_handle_t,
            pMemoryZirconHandleProperties: *MemoryZirconHandlePropertiesFUCHSIA,
        ) GetMemoryZirconHandlePropertiesFUCHSIAError!void {
            const result = self.dispatch.vkGetMemoryZirconHandlePropertiesFUCHSIA(
                device,
                handleType.toInt(),
                zirconHandle,
                pMemoryZirconHandleProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub const GetMemoryRemoteAddressNVError = error{
            InvalidExternalHandle,
            Unknown,
        };
        pub fn getMemoryRemoteAddressNV(
            self: Self,
            device: Device,
            memoryGetRemoteAddressInfo: MemoryGetRemoteAddressInfoNV,
        ) GetMemoryRemoteAddressNVError!RemoteAddressNV {
            var address: RemoteAddressNV = undefined;
            const result = self.dispatch.vkGetMemoryRemoteAddressNV(
                device,
                &memoryGetRemoteAddressInfo,
                &address,
            );
            switch (result) {
                Result.success => {},
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
            return address;
        }
        pub const GetSemaphoreWin32HandleKHRError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getSemaphoreWin32HandleKHR(
            self: Self,
            device: Device,
            getWin32HandleInfo: SemaphoreGetWin32HandleInfoKHR,
            pHandle: *HANDLE,
        ) GetSemaphoreWin32HandleKHRError!void {
            const result = self.dispatch.vkGetSemaphoreWin32HandleKHR(
                device,
                &getWin32HandleInfo,
                pHandle,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const ImportSemaphoreWin32HandleKHRError = error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        };
        pub fn importSemaphoreWin32HandleKHR(
            self: Self,
            device: Device,
            importSemaphoreWin32HandleInfo: ImportSemaphoreWin32HandleInfoKHR,
        ) ImportSemaphoreWin32HandleKHRError!void {
            const result = self.dispatch.vkImportSemaphoreWin32HandleKHR(
                device,
                &importSemaphoreWin32HandleInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub const GetSemaphoreFdKHRError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getSemaphoreFdKHR(
            self: Self,
            device: Device,
            getFdInfo: SemaphoreGetFdInfoKHR,
        ) GetSemaphoreFdKHRError!c_int {
            var fd: c_int = undefined;
            const result = self.dispatch.vkGetSemaphoreFdKHR(
                device,
                &getFdInfo,
                &fd,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fd;
        }
        pub const ImportSemaphoreFdKHRError = error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        };
        pub fn importSemaphoreFdKHR(
            self: Self,
            device: Device,
            importSemaphoreFdInfo: ImportSemaphoreFdInfoKHR,
        ) ImportSemaphoreFdKHRError!void {
            const result = self.dispatch.vkImportSemaphoreFdKHR(
                device,
                &importSemaphoreFdInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub const GetSemaphoreZirconHandleFUCHSIAError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getSemaphoreZirconHandleFUCHSIA(
            self: Self,
            device: Device,
            getZirconHandleInfo: SemaphoreGetZirconHandleInfoFUCHSIA,
            pZirconHandle: *zx_handle_t,
        ) GetSemaphoreZirconHandleFUCHSIAError!void {
            const result = self.dispatch.vkGetSemaphoreZirconHandleFUCHSIA(
                device,
                &getZirconHandleInfo,
                pZirconHandle,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const ImportSemaphoreZirconHandleFUCHSIAError = error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        };
        pub fn importSemaphoreZirconHandleFUCHSIA(
            self: Self,
            device: Device,
            importSemaphoreZirconHandleInfo: ImportSemaphoreZirconHandleInfoFUCHSIA,
        ) ImportSemaphoreZirconHandleFUCHSIAError!void {
            const result = self.dispatch.vkImportSemaphoreZirconHandleFUCHSIA(
                device,
                &importSemaphoreZirconHandleInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub const GetFenceWin32HandleKHRError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getFenceWin32HandleKHR(
            self: Self,
            device: Device,
            getWin32HandleInfo: FenceGetWin32HandleInfoKHR,
            pHandle: *HANDLE,
        ) GetFenceWin32HandleKHRError!void {
            const result = self.dispatch.vkGetFenceWin32HandleKHR(
                device,
                &getWin32HandleInfo,
                pHandle,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const ImportFenceWin32HandleKHRError = error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        };
        pub fn importFenceWin32HandleKHR(
            self: Self,
            device: Device,
            importFenceWin32HandleInfo: ImportFenceWin32HandleInfoKHR,
        ) ImportFenceWin32HandleKHRError!void {
            const result = self.dispatch.vkImportFenceWin32HandleKHR(
                device,
                &importFenceWin32HandleInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub const GetFenceFdKHRError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getFenceFdKHR(
            self: Self,
            device: Device,
            getFdInfo: FenceGetFdInfoKHR,
        ) GetFenceFdKHRError!c_int {
            var fd: c_int = undefined;
            const result = self.dispatch.vkGetFenceFdKHR(
                device,
                &getFdInfo,
                &fd,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fd;
        }
        pub const ImportFenceFdKHRError = error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        };
        pub fn importFenceFdKHR(
            self: Self,
            device: Device,
            importFenceFdInfo: ImportFenceFdInfoKHR,
        ) ImportFenceFdKHRError!void {
            const result = self.dispatch.vkImportFenceFdKHR(
                device,
                &importFenceFdInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub const DisplayPowerControlEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn displayPowerControlEXT(
            self: Self,
            device: Device,
            display: DisplayKHR,
            displayPowerInfo: DisplayPowerInfoEXT,
        ) DisplayPowerControlEXTError!void {
            const result = self.dispatch.vkDisplayPowerControlEXT(
                device,
                display,
                &displayPowerInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const RegisterDeviceEventEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn registerDeviceEventEXT(
            self: Self,
            device: Device,
            deviceEventInfo: DeviceEventInfoEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) RegisterDeviceEventEXTError!Fence {
            var fence: Fence = undefined;
            const result = self.dispatch.vkRegisterDeviceEventEXT(
                device,
                &deviceEventInfo,
                pAllocator,
                &fence,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fence;
        }
        pub const RegisterDisplayEventEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn registerDisplayEventEXT(
            self: Self,
            device: Device,
            display: DisplayKHR,
            displayEventInfo: DisplayEventInfoEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) RegisterDisplayEventEXTError!Fence {
            var fence: Fence = undefined;
            const result = self.dispatch.vkRegisterDisplayEventEXT(
                device,
                display,
                &displayEventInfo,
                pAllocator,
                &fence,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return fence;
        }
        pub const GetSwapchainCounterEXTError = error{
            OutOfHostMemory,
            DeviceLost,
            OutOfDateKHR,
            Unknown,
        };
        pub fn getSwapchainCounterEXT(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            counter: SurfaceCounterFlagsEXT,
        ) GetSwapchainCounterEXTError!u64 {
            var counterValue: u64 = undefined;
            const result = self.dispatch.vkGetSwapchainCounterEXT(
                device,
                swapchain,
                counter.toInt(),
                &counterValue,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorOutOfDateKHR => return error.OutOfDateKHR,
                else => return error.Unknown,
            }
            return counterValue;
        }
        pub fn getDeviceGroupPeerMemoryFeatures(
            self: Self,
            device: Device,
            heapIndex: u32,
            localDeviceIndex: u32,
            remoteDeviceIndex: u32,
        ) PeerMemoryFeatureFlags {
            var peerMemoryFeatures: PeerMemoryFeatureFlags = undefined;
            self.dispatch.vkGetDeviceGroupPeerMemoryFeatures(
                device,
                heapIndex,
                localDeviceIndex,
                remoteDeviceIndex,
                &peerMemoryFeatures,
            );
            return peerMemoryFeatures;
        }
        pub const BindBufferMemory2Error = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidOpaqueCaptureAddressKHR,
            Unknown,
        };
        pub fn bindBufferMemory2(
            self: Self,
            device: Device,
            bindInfoCount: u32,
            pBindInfos: [*]const BindBufferMemoryInfo,
        ) BindBufferMemory2Error!void {
            const result = self.dispatch.vkBindBufferMemory2(
                device,
                bindInfoCount,
                pBindInfos,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInvalidOpaqueCaptureAddressKHR => return error.InvalidOpaqueCaptureAddressKHR,
                else => return error.Unknown,
            }
        }
        pub const BindImageMemory2Error = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn bindImageMemory2(
            self: Self,
            device: Device,
            bindInfoCount: u32,
            pBindInfos: [*]const BindImageMemoryInfo,
        ) BindImageMemory2Error!void {
            const result = self.dispatch.vkBindImageMemory2(
                device,
                bindInfoCount,
                pBindInfos,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdSetDeviceMask(
            self: Self,
            commandBuffer: CommandBuffer,
            deviceMask: u32,
        ) void {
            self.dispatch.vkCmdSetDeviceMask(
                commandBuffer,
                deviceMask,
            );
        }
        pub const GetDeviceGroupPresentCapabilitiesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getDeviceGroupPresentCapabilitiesKHR(
            self: Self,
            device: Device,
            pDeviceGroupPresentCapabilities: *DeviceGroupPresentCapabilitiesKHR,
        ) GetDeviceGroupPresentCapabilitiesKHRError!void {
            const result = self.dispatch.vkGetDeviceGroupPresentCapabilitiesKHR(
                device,
                pDeviceGroupPresentCapabilities,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const GetDeviceGroupSurfacePresentModesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getDeviceGroupSurfacePresentModesKHR(
            self: Self,
            device: Device,
            surface: SurfaceKHR,
        ) GetDeviceGroupSurfacePresentModesKHRError!DeviceGroupPresentModeFlagsKHR {
            var modes: DeviceGroupPresentModeFlagsKHR = undefined;
            const result = self.dispatch.vkGetDeviceGroupSurfacePresentModesKHR(
                device,
                surface,
                &modes,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return modes;
        }
        pub const AcquireNextImage2KHRResult = struct {
            result: Result,
            imageIndex: u32,
        };
        pub const AcquireNextImage2KHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            FullScreenExclusiveModeLostEXT,
            Unknown,
        };
        pub fn acquireNextImage2KHR(
            self: Self,
            device: Device,
            acquireInfo: AcquireNextImageInfoKHR,
        ) AcquireNextImage2KHRError!AcquireNextImage2KHRResult {
            var return_values: AcquireNextImage2KHRResult = undefined;
            const result = self.dispatch.vkAcquireNextImage2KHR(
                device,
                &acquireInfo,
                &return_values.imageIndex,
            );
            switch (result) {
                Result.success => {},
                Result.timeout => {},
                Result.notReady => {},
                Result.suboptimalKHR => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorOutOfDateKHR => return error.OutOfDateKHR,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                Result.errorFullScreenExclusiveModeLostEXT => return error.FullScreenExclusiveModeLostEXT,
                else => return error.Unknown,
            }
            return_values.result = result;
            return return_values;
        }
        pub fn cmdDispatchBase(
            self: Self,
            commandBuffer: CommandBuffer,
            baseGroupX: u32,
            baseGroupY: u32,
            baseGroupZ: u32,
            groupCountX: u32,
            groupCountY: u32,
            groupCountZ: u32,
        ) void {
            self.dispatch.vkCmdDispatchBase(
                commandBuffer,
                baseGroupX,
                baseGroupY,
                baseGroupZ,
                groupCountX,
                groupCountY,
                groupCountZ,
            );
        }
        pub const CreateDescriptorUpdateTemplateError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createDescriptorUpdateTemplate(
            self: Self,
            device: Device,
            createInfo: DescriptorUpdateTemplateCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDescriptorUpdateTemplateError!DescriptorUpdateTemplate {
            var descriptorUpdateTemplate: DescriptorUpdateTemplate = undefined;
            const result = self.dispatch.vkCreateDescriptorUpdateTemplate(
                device,
                &createInfo,
                pAllocator,
                &descriptorUpdateTemplate,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return descriptorUpdateTemplate;
        }
        pub fn destroyDescriptorUpdateTemplate(
            self: Self,
            device: Device,
            descriptorUpdateTemplate: DescriptorUpdateTemplate,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyDescriptorUpdateTemplate(
                device,
                descriptorUpdateTemplate,
                pAllocator,
            );
        }
        pub fn updateDescriptorSetWithTemplate(
            self: Self,
            device: Device,
            descriptorSet: DescriptorSet,
            descriptorUpdateTemplate: DescriptorUpdateTemplate,
            pData: *const c_void,
        ) void {
            self.dispatch.vkUpdateDescriptorSetWithTemplate(
                device,
                descriptorSet,
                descriptorUpdateTemplate,
                pData,
            );
        }
        pub fn cmdPushDescriptorSetWithTemplateKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            descriptorUpdateTemplate: DescriptorUpdateTemplate,
            layout: PipelineLayout,
            set: u32,
            pData: *const c_void,
        ) void {
            self.dispatch.vkCmdPushDescriptorSetWithTemplateKHR(
                commandBuffer,
                descriptorUpdateTemplate,
                layout,
                set,
                pData,
            );
        }
        pub fn setHdrMetadataEXT(
            self: Self,
            device: Device,
            swapchainCount: u32,
            pSwapchains: [*]const SwapchainKHR,
            pMetadata: [*]const HdrMetadataEXT,
        ) void {
            self.dispatch.vkSetHdrMetadataEXT(
                device,
                swapchainCount,
                pSwapchains,
                pMetadata,
            );
        }
        pub const GetSwapchainStatusKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            FullScreenExclusiveModeLostEXT,
            Unknown,
        };
        pub fn getSwapchainStatusKHR(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
        ) GetSwapchainStatusKHRError!Result {
            const result = self.dispatch.vkGetSwapchainStatusKHR(
                device,
                swapchain,
            );
            switch (result) {
                Result.success => {},
                Result.suboptimalKHR => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorOutOfDateKHR => return error.OutOfDateKHR,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                Result.errorFullScreenExclusiveModeLostEXT => return error.FullScreenExclusiveModeLostEXT,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetRefreshCycleDurationGOOGLEError = error{
            OutOfHostMemory,
            DeviceLost,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getRefreshCycleDurationGOOGLE(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
        ) GetRefreshCycleDurationGOOGLEError!RefreshCycleDurationGOOGLE {
            var displayTimingProperties: RefreshCycleDurationGOOGLE = undefined;
            const result = self.dispatch.vkGetRefreshCycleDurationGOOGLE(
                device,
                swapchain,
                &displayTimingProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return displayTimingProperties;
        }
        pub const GetPastPresentationTimingGOOGLEError = error{
            OutOfHostMemory,
            DeviceLost,
            OutOfDateKHR,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getPastPresentationTimingGOOGLE(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            pPresentationTimingCount: *u32,
            pPresentationTimings: ?[*]PastPresentationTimingGOOGLE,
        ) GetPastPresentationTimingGOOGLEError!Result {
            const result = self.dispatch.vkGetPastPresentationTimingGOOGLE(
                device,
                swapchain,
                pPresentationTimingCount,
                pPresentationTimings,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                Result.errorOutOfDateKHR => return error.OutOfDateKHR,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdSetViewportWScalingNV(
            self: Self,
            commandBuffer: CommandBuffer,
            firstViewport: u32,
            viewportCount: u32,
            pViewportWScalings: [*]const ViewportWScalingNV,
        ) void {
            self.dispatch.vkCmdSetViewportWScalingNV(
                commandBuffer,
                firstViewport,
                viewportCount,
                pViewportWScalings,
            );
        }
        pub fn cmdSetDiscardRectangleEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            firstDiscardRectangle: u32,
            discardRectangleCount: u32,
            pDiscardRectangles: [*]const Rect2D,
        ) void {
            self.dispatch.vkCmdSetDiscardRectangleEXT(
                commandBuffer,
                firstDiscardRectangle,
                discardRectangleCount,
                pDiscardRectangles,
            );
        }
        pub fn cmdSetSampleLocationsEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            sampleLocationsInfo: SampleLocationsInfoEXT,
        ) void {
            self.dispatch.vkCmdSetSampleLocationsEXT(
                commandBuffer,
                &sampleLocationsInfo,
            );
        }
        pub fn getBufferMemoryRequirements2(
            self: Self,
            device: Device,
            info: BufferMemoryRequirementsInfo2,
            pMemoryRequirements: *MemoryRequirements2,
        ) void {
            self.dispatch.vkGetBufferMemoryRequirements2(
                device,
                &info,
                pMemoryRequirements,
            );
        }
        pub fn getImageMemoryRequirements2(
            self: Self,
            device: Device,
            info: ImageMemoryRequirementsInfo2,
            pMemoryRequirements: *MemoryRequirements2,
        ) void {
            self.dispatch.vkGetImageMemoryRequirements2(
                device,
                &info,
                pMemoryRequirements,
            );
        }
        pub fn getImageSparseMemoryRequirements2(
            self: Self,
            device: Device,
            info: ImageSparseMemoryRequirementsInfo2,
            pSparseMemoryRequirementCount: *u32,
            pSparseMemoryRequirements: ?[*]SparseImageMemoryRequirements2,
        ) void {
            self.dispatch.vkGetImageSparseMemoryRequirements2(
                device,
                &info,
                pSparseMemoryRequirementCount,
                pSparseMemoryRequirements,
            );
        }
        pub fn getDeviceBufferMemoryRequirementsKHR(
            self: Self,
            device: Device,
            info: DeviceBufferMemoryRequirementsKHR,
            pMemoryRequirements: *MemoryRequirements2,
        ) void {
            self.dispatch.vkGetDeviceBufferMemoryRequirementsKHR(
                device,
                &info,
                pMemoryRequirements,
            );
        }
        pub fn getDeviceImageMemoryRequirementsKHR(
            self: Self,
            device: Device,
            info: DeviceImageMemoryRequirementsKHR,
            pMemoryRequirements: *MemoryRequirements2,
        ) void {
            self.dispatch.vkGetDeviceImageMemoryRequirementsKHR(
                device,
                &info,
                pMemoryRequirements,
            );
        }
        pub fn getDeviceImageSparseMemoryRequirementsKHR(
            self: Self,
            device: Device,
            info: DeviceImageMemoryRequirementsKHR,
            pSparseMemoryRequirementCount: *u32,
            pSparseMemoryRequirements: ?[*]SparseImageMemoryRequirements2,
        ) void {
            self.dispatch.vkGetDeviceImageSparseMemoryRequirementsKHR(
                device,
                &info,
                pSparseMemoryRequirementCount,
                pSparseMemoryRequirements,
            );
        }
        pub const CreateSamplerYcbcrConversionError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createSamplerYcbcrConversion(
            self: Self,
            device: Device,
            createInfo: SamplerYcbcrConversionCreateInfo,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateSamplerYcbcrConversionError!SamplerYcbcrConversion {
            var ycbcrConversion: SamplerYcbcrConversion = undefined;
            const result = self.dispatch.vkCreateSamplerYcbcrConversion(
                device,
                &createInfo,
                pAllocator,
                &ycbcrConversion,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return ycbcrConversion;
        }
        pub fn destroySamplerYcbcrConversion(
            self: Self,
            device: Device,
            ycbcrConversion: SamplerYcbcrConversion,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroySamplerYcbcrConversion(
                device,
                ycbcrConversion,
                pAllocator,
            );
        }
        pub fn getDeviceQueue2(
            self: Self,
            device: Device,
            queueInfo: DeviceQueueInfo2,
        ) Queue {
            var queue: Queue = undefined;
            self.dispatch.vkGetDeviceQueue2(
                device,
                &queueInfo,
                &queue,
            );
            return queue;
        }
        pub const CreateValidationCacheEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn createValidationCacheEXT(
            self: Self,
            device: Device,
            createInfo: ValidationCacheCreateInfoEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateValidationCacheEXTError!ValidationCacheEXT {
            var validationCache: ValidationCacheEXT = undefined;
            const result = self.dispatch.vkCreateValidationCacheEXT(
                device,
                &createInfo,
                pAllocator,
                &validationCache,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return validationCache;
        }
        pub fn destroyValidationCacheEXT(
            self: Self,
            device: Device,
            validationCache: ValidationCacheEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyValidationCacheEXT(
                device,
                validationCache,
                pAllocator,
            );
        }
        pub const GetValidationCacheDataEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getValidationCacheDataEXT(
            self: Self,
            device: Device,
            validationCache: ValidationCacheEXT,
            pDataSize: *usize,
            pData: ?*c_void,
        ) GetValidationCacheDataEXTError!Result {
            const result = self.dispatch.vkGetValidationCacheDataEXT(
                device,
                validationCache,
                pDataSize,
                pData,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const MergeValidationCachesEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn mergeValidationCachesEXT(
            self: Self,
            device: Device,
            dstCache: ValidationCacheEXT,
            srcCacheCount: u32,
            pSrcCaches: [*]const ValidationCacheEXT,
        ) MergeValidationCachesEXTError!void {
            const result = self.dispatch.vkMergeValidationCachesEXT(
                device,
                dstCache,
                srcCacheCount,
                pSrcCaches,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn getDescriptorSetLayoutSupport(
            self: Self,
            device: Device,
            createInfo: DescriptorSetLayoutCreateInfo,
            pSupport: *DescriptorSetLayoutSupport,
        ) void {
            self.dispatch.vkGetDescriptorSetLayoutSupport(
                device,
                &createInfo,
                pSupport,
            );
        }
        pub fn getSwapchainGrallocUsageANDROID(
            self: Self,
            device: Device,
            format: Format,
            imageUsage: ImageUsageFlags,
        ) c_int {
            var grallocUsage: c_int = undefined;
            const result = self.dispatch.vkGetSwapchainGrallocUsageANDROID(
                device,
                format,
                imageUsage.toInt(),
                &grallocUsage,
            );
            switch (result) {
                else => return error.Unknown,
            }
            return grallocUsage;
        }
        pub const GetSwapchainGrallocUsage2ANDROIDResult = struct {
            grallocConsumerUsage: u64,
            grallocProducerUsage: u64,
        };
        pub fn getSwapchainGrallocUsage2ANDROID(
            self: Self,
            device: Device,
            format: Format,
            imageUsage: ImageUsageFlags,
            swapchainImageUsage: SwapchainImageUsageFlagsANDROID,
        ) GetSwapchainGrallocUsage2ANDROIDResult {
            var return_values: GetSwapchainGrallocUsage2ANDROIDResult = undefined;
            const result = self.dispatch.vkGetSwapchainGrallocUsage2ANDROID(
                device,
                format,
                imageUsage.toInt(),
                swapchainImageUsage.toInt(),
                &return_values.grallocConsumerUsage,
                &return_values.grallocProducerUsage,
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
            nativeFenceFd: c_int,
            semaphore: Semaphore,
            fence: Fence,
        ) void {
            const result = self.dispatch.vkAcquireImageANDROID(
                device,
                image,
                nativeFenceFd,
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
            waitSemaphoreCount: u32,
            pWaitSemaphores: [*]const Semaphore,
            image: Image,
        ) c_int {
            var nativeFenceFd: c_int = undefined;
            const result = self.dispatch.vkQueueSignalReleaseImageANDROID(
                queue,
                waitSemaphoreCount,
                pWaitSemaphores,
                image,
                &nativeFenceFd,
            );
            switch (result) {
                else => return error.Unknown,
            }
            return nativeFenceFd;
        }
        pub const GetShaderInfoAMDError = error{
            FeatureNotPresent,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getShaderInfoAMD(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            shaderStage: ShaderStageFlags,
            infoType: ShaderInfoTypeAMD,
            pInfoSize: *usize,
            pInfo: ?*c_void,
        ) GetShaderInfoAMDError!Result {
            const result = self.dispatch.vkGetShaderInfoAMD(
                device,
                pipeline,
                shaderStage.toInt(),
                infoType,
                pInfoSize,
                pInfo,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorFeatureNotPresent => return error.FeatureNotPresent,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn setLocalDimmingAMD(
            self: Self,
            device: Device,
            swapChain: SwapchainKHR,
            localDimmingEnable: Bool32,
        ) void {
            self.dispatch.vkSetLocalDimmingAMD(
                device,
                swapChain,
                localDimmingEnable,
            );
        }
        pub const GetCalibratedTimestampsEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getCalibratedTimestampsEXT(
            self: Self,
            device: Device,
            timestampCount: u32,
            pTimestampInfos: [*]const CalibratedTimestampInfoEXT,
            pTimestamps: [*]u64,
        ) GetCalibratedTimestampsEXTError!u64 {
            var maxDeviation: u64 = undefined;
            const result = self.dispatch.vkGetCalibratedTimestampsEXT(
                device,
                timestampCount,
                pTimestampInfos,
                pTimestamps,
                &maxDeviation,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return maxDeviation;
        }
        pub const SetDebugUtilsObjectNameEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn setDebugUtilsObjectNameEXT(
            self: Self,
            device: Device,
            nameInfo: DebugUtilsObjectNameInfoEXT,
        ) SetDebugUtilsObjectNameEXTError!void {
            const result = self.dispatch.vkSetDebugUtilsObjectNameEXT(
                device,
                &nameInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const SetDebugUtilsObjectTagEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn setDebugUtilsObjectTagEXT(
            self: Self,
            device: Device,
            tagInfo: DebugUtilsObjectTagInfoEXT,
        ) SetDebugUtilsObjectTagEXTError!void {
            const result = self.dispatch.vkSetDebugUtilsObjectTagEXT(
                device,
                &tagInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn queueBeginDebugUtilsLabelEXT(
            self: Self,
            queue: Queue,
            labelInfo: DebugUtilsLabelEXT,
        ) void {
            self.dispatch.vkQueueBeginDebugUtilsLabelEXT(
                queue,
                &labelInfo,
            );
        }
        pub fn queueEndDebugUtilsLabelEXT(
            self: Self,
            queue: Queue,
        ) void {
            self.dispatch.vkQueueEndDebugUtilsLabelEXT(
                queue,
            );
        }
        pub fn queueInsertDebugUtilsLabelEXT(
            self: Self,
            queue: Queue,
            labelInfo: DebugUtilsLabelEXT,
        ) void {
            self.dispatch.vkQueueInsertDebugUtilsLabelEXT(
                queue,
                &labelInfo,
            );
        }
        pub fn cmdBeginDebugUtilsLabelEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            labelInfo: DebugUtilsLabelEXT,
        ) void {
            self.dispatch.vkCmdBeginDebugUtilsLabelEXT(
                commandBuffer,
                &labelInfo,
            );
        }
        pub fn cmdEndDebugUtilsLabelEXT(
            self: Self,
            commandBuffer: CommandBuffer,
        ) void {
            self.dispatch.vkCmdEndDebugUtilsLabelEXT(
                commandBuffer,
            );
        }
        pub fn cmdInsertDebugUtilsLabelEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            labelInfo: DebugUtilsLabelEXT,
        ) void {
            self.dispatch.vkCmdInsertDebugUtilsLabelEXT(
                commandBuffer,
                &labelInfo,
            );
        }
        pub const GetMemoryHostPointerPropertiesEXTError = error{
            OutOfHostMemory,
            InvalidExternalHandle,
            Unknown,
        };
        pub fn getMemoryHostPointerPropertiesEXT(
            self: Self,
            device: Device,
            handleType: ExternalMemoryHandleTypeFlags,
            pHostPointer: *const c_void,
            pMemoryHostPointerProperties: *MemoryHostPointerPropertiesEXT,
        ) GetMemoryHostPointerPropertiesEXTError!void {
            const result = self.dispatch.vkGetMemoryHostPointerPropertiesEXT(
                device,
                handleType.toInt(),
                pHostPointer,
                pMemoryHostPointerProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                else => return error.Unknown,
            }
        }
        pub fn cmdWriteBufferMarkerAMD(
            self: Self,
            commandBuffer: CommandBuffer,
            pipelineStage: PipelineStageFlags,
            dstBuffer: Buffer,
            dstOffset: DeviceSize,
            marker: u32,
        ) void {
            self.dispatch.vkCmdWriteBufferMarkerAMD(
                commandBuffer,
                pipelineStage.toInt(),
                dstBuffer,
                dstOffset,
                marker,
            );
        }
        pub const CreateRenderPass2Error = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn createRenderPass2(
            self: Self,
            device: Device,
            createInfo: RenderPassCreateInfo2,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateRenderPass2Error!RenderPass {
            var renderPass: RenderPass = undefined;
            const result = self.dispatch.vkCreateRenderPass2(
                device,
                &createInfo,
                pAllocator,
                &renderPass,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return renderPass;
        }
        pub fn cmdBeginRenderPass2(
            self: Self,
            commandBuffer: CommandBuffer,
            renderPassBegin: RenderPassBeginInfo,
            subpassBeginInfo: SubpassBeginInfo,
        ) void {
            self.dispatch.vkCmdBeginRenderPass2(
                commandBuffer,
                &renderPassBegin,
                &subpassBeginInfo,
            );
        }
        pub fn cmdNextSubpass2(
            self: Self,
            commandBuffer: CommandBuffer,
            subpassBeginInfo: SubpassBeginInfo,
            subpassEndInfo: SubpassEndInfo,
        ) void {
            self.dispatch.vkCmdNextSubpass2(
                commandBuffer,
                &subpassBeginInfo,
                &subpassEndInfo,
            );
        }
        pub fn cmdEndRenderPass2(
            self: Self,
            commandBuffer: CommandBuffer,
            subpassEndInfo: SubpassEndInfo,
        ) void {
            self.dispatch.vkCmdEndRenderPass2(
                commandBuffer,
                &subpassEndInfo,
            );
        }
        pub const GetSemaphoreCounterValueError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn getSemaphoreCounterValue(
            self: Self,
            device: Device,
            semaphore: Semaphore,
        ) GetSemaphoreCounterValueError!u64 {
            var value: u64 = undefined;
            const result = self.dispatch.vkGetSemaphoreCounterValue(
                device,
                semaphore,
                &value,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return value;
        }
        pub const WaitSemaphoresError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn waitSemaphores(
            self: Self,
            device: Device,
            waitInfo: SemaphoreWaitInfo,
            timeout: u64,
        ) WaitSemaphoresError!Result {
            const result = self.dispatch.vkWaitSemaphores(
                device,
                &waitInfo,
                timeout,
            );
            switch (result) {
                Result.success => {},
                Result.timeout => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub const SignalSemaphoreError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn signalSemaphore(
            self: Self,
            device: Device,
            signalInfo: SemaphoreSignalInfo,
        ) SignalSemaphoreError!void {
            const result = self.dispatch.vkSignalSemaphore(
                device,
                &signalInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const GetAndroidHardwareBufferPropertiesANDROIDError = error{
            OutOfHostMemory,
            InvalidExternalHandleKHR,
            Unknown,
        };
        pub fn getAndroidHardwareBufferPropertiesANDROID(
            self: Self,
            device: Device,
            buffer: *const AHardwareBuffer,
            pProperties: *AndroidHardwareBufferPropertiesANDROID,
        ) GetAndroidHardwareBufferPropertiesANDROIDError!void {
            const result = self.dispatch.vkGetAndroidHardwareBufferPropertiesANDROID(
                device,
                buffer,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandleKHR => return error.InvalidExternalHandleKHR,
                else => return error.Unknown,
            }
        }
        pub const GetMemoryAndroidHardwareBufferANDROIDError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getMemoryAndroidHardwareBufferANDROID(
            self: Self,
            device: Device,
            info: MemoryGetAndroidHardwareBufferInfoANDROID,
        ) GetMemoryAndroidHardwareBufferANDROIDError!*AHardwareBuffer {
            var buffer: *AHardwareBuffer = undefined;
            const result = self.dispatch.vkGetMemoryAndroidHardwareBufferANDROID(
                device,
                &info,
                &buffer,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return buffer;
        }
        pub fn cmdDrawIndirectCount(
            self: Self,
            commandBuffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            countBuffer: Buffer,
            countBufferOffset: DeviceSize,
            maxDrawCount: u32,
            stride: u32,
        ) void {
            self.dispatch.vkCmdDrawIndirectCount(
                commandBuffer,
                buffer,
                offset,
                countBuffer,
                countBufferOffset,
                maxDrawCount,
                stride,
            );
        }
        pub fn cmdDrawIndexedIndirectCount(
            self: Self,
            commandBuffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            countBuffer: Buffer,
            countBufferOffset: DeviceSize,
            maxDrawCount: u32,
            stride: u32,
        ) void {
            self.dispatch.vkCmdDrawIndexedIndirectCount(
                commandBuffer,
                buffer,
                offset,
                countBuffer,
                countBufferOffset,
                maxDrawCount,
                stride,
            );
        }
        pub fn cmdSetCheckpointNV(
            self: Self,
            commandBuffer: CommandBuffer,
            pCheckpointMarker: *const c_void,
        ) void {
            self.dispatch.vkCmdSetCheckpointNV(
                commandBuffer,
                pCheckpointMarker,
            );
        }
        pub fn getQueueCheckpointDataNV(
            self: Self,
            queue: Queue,
            pCheckpointDataCount: *u32,
            pCheckpointData: ?[*]CheckpointDataNV,
        ) void {
            self.dispatch.vkGetQueueCheckpointDataNV(
                queue,
                pCheckpointDataCount,
                pCheckpointData,
            );
        }
        pub fn cmdBindTransformFeedbackBuffersEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            firstBinding: u32,
            bindingCount: u32,
            pBuffers: [*]const Buffer,
            pOffsets: [*]const DeviceSize,
            pSizes: ?[*]const DeviceSize,
        ) void {
            self.dispatch.vkCmdBindTransformFeedbackBuffersEXT(
                commandBuffer,
                firstBinding,
                bindingCount,
                pBuffers,
                pOffsets,
                pSizes,
            );
        }
        pub fn cmdBeginTransformFeedbackEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            firstCounterBuffer: u32,
            counterBufferCount: u32,
            pCounterBuffers: [*]const Buffer,
            pCounterBufferOffsets: ?[*]const DeviceSize,
        ) void {
            self.dispatch.vkCmdBeginTransformFeedbackEXT(
                commandBuffer,
                firstCounterBuffer,
                counterBufferCount,
                pCounterBuffers,
                pCounterBufferOffsets,
            );
        }
        pub fn cmdEndTransformFeedbackEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            firstCounterBuffer: u32,
            counterBufferCount: u32,
            pCounterBuffers: [*]const Buffer,
            pCounterBufferOffsets: ?[*]const DeviceSize,
        ) void {
            self.dispatch.vkCmdEndTransformFeedbackEXT(
                commandBuffer,
                firstCounterBuffer,
                counterBufferCount,
                pCounterBuffers,
                pCounterBufferOffsets,
            );
        }
        pub fn cmdBeginQueryIndexedEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            queryPool: QueryPool,
            query: u32,
            flags: QueryControlFlags,
            index: u32,
        ) void {
            self.dispatch.vkCmdBeginQueryIndexedEXT(
                commandBuffer,
                queryPool,
                query,
                flags.toInt(),
                index,
            );
        }
        pub fn cmdEndQueryIndexedEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            queryPool: QueryPool,
            query: u32,
            index: u32,
        ) void {
            self.dispatch.vkCmdEndQueryIndexedEXT(
                commandBuffer,
                queryPool,
                query,
                index,
            );
        }
        pub fn cmdDrawIndirectByteCountEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            instanceCount: u32,
            firstInstance: u32,
            counterBuffer: Buffer,
            counterBufferOffset: DeviceSize,
            counterOffset: u32,
            vertexStride: u32,
        ) void {
            self.dispatch.vkCmdDrawIndirectByteCountEXT(
                commandBuffer,
                instanceCount,
                firstInstance,
                counterBuffer,
                counterBufferOffset,
                counterOffset,
                vertexStride,
            );
        }
        pub fn cmdSetExclusiveScissorNV(
            self: Self,
            commandBuffer: CommandBuffer,
            firstExclusiveScissor: u32,
            exclusiveScissorCount: u32,
            pExclusiveScissors: [*]const Rect2D,
        ) void {
            self.dispatch.vkCmdSetExclusiveScissorNV(
                commandBuffer,
                firstExclusiveScissor,
                exclusiveScissorCount,
                pExclusiveScissors,
            );
        }
        pub fn cmdBindShadingRateImageNV(
            self: Self,
            commandBuffer: CommandBuffer,
            imageView: ImageView,
            imageLayout: ImageLayout,
        ) void {
            self.dispatch.vkCmdBindShadingRateImageNV(
                commandBuffer,
                imageView,
                imageLayout,
            );
        }
        pub fn cmdSetViewportShadingRatePaletteNV(
            self: Self,
            commandBuffer: CommandBuffer,
            firstViewport: u32,
            viewportCount: u32,
            pShadingRatePalettes: [*]const ShadingRatePaletteNV,
        ) void {
            self.dispatch.vkCmdSetViewportShadingRatePaletteNV(
                commandBuffer,
                firstViewport,
                viewportCount,
                pShadingRatePalettes,
            );
        }
        pub fn cmdSetCoarseSampleOrderNV(
            self: Self,
            commandBuffer: CommandBuffer,
            sampleOrderType: CoarseSampleOrderTypeNV,
            customSampleOrderCount: u32,
            pCustomSampleOrders: [*]const CoarseSampleOrderCustomNV,
        ) void {
            self.dispatch.vkCmdSetCoarseSampleOrderNV(
                commandBuffer,
                sampleOrderType,
                customSampleOrderCount,
                pCustomSampleOrders,
            );
        }
        pub fn cmdDrawMeshTasksNV(
            self: Self,
            commandBuffer: CommandBuffer,
            taskCount: u32,
            firstTask: u32,
        ) void {
            self.dispatch.vkCmdDrawMeshTasksNV(
                commandBuffer,
                taskCount,
                firstTask,
            );
        }
        pub fn cmdDrawMeshTasksIndirectNV(
            self: Self,
            commandBuffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            drawCount: u32,
            stride: u32,
        ) void {
            self.dispatch.vkCmdDrawMeshTasksIndirectNV(
                commandBuffer,
                buffer,
                offset,
                drawCount,
                stride,
            );
        }
        pub fn cmdDrawMeshTasksIndirectCountNV(
            self: Self,
            commandBuffer: CommandBuffer,
            buffer: Buffer,
            offset: DeviceSize,
            countBuffer: Buffer,
            countBufferOffset: DeviceSize,
            maxDrawCount: u32,
            stride: u32,
        ) void {
            self.dispatch.vkCmdDrawMeshTasksIndirectCountNV(
                commandBuffer,
                buffer,
                offset,
                countBuffer,
                countBufferOffset,
                maxDrawCount,
                stride,
            );
        }
        pub const CompileDeferredNVError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn compileDeferredNV(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            shader: u32,
        ) CompileDeferredNVError!void {
            const result = self.dispatch.vkCompileDeferredNV(
                device,
                pipeline,
                shader,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const CreateAccelerationStructureNVError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn createAccelerationStructureNV(
            self: Self,
            device: Device,
            createInfo: AccelerationStructureCreateInfoNV,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateAccelerationStructureNVError!AccelerationStructureNV {
            var accelerationStructure: AccelerationStructureNV = undefined;
            const result = self.dispatch.vkCreateAccelerationStructureNV(
                device,
                &createInfo,
                pAllocator,
                &accelerationStructure,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return accelerationStructure;
        }
        pub fn cmdBindInvocationMaskHUAWEI(
            self: Self,
            commandBuffer: CommandBuffer,
            imageView: ImageView,
            imageLayout: ImageLayout,
        ) void {
            self.dispatch.vkCmdBindInvocationMaskHUAWEI(
                commandBuffer,
                imageView,
                imageLayout,
            );
        }
        pub fn destroyAccelerationStructureKHR(
            self: Self,
            device: Device,
            accelerationStructure: AccelerationStructureKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyAccelerationStructureKHR(
                device,
                accelerationStructure,
                pAllocator,
            );
        }
        pub fn destroyAccelerationStructureNV(
            self: Self,
            device: Device,
            accelerationStructure: AccelerationStructureNV,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyAccelerationStructureNV(
                device,
                accelerationStructure,
                pAllocator,
            );
        }
        pub fn getAccelerationStructureMemoryRequirementsNV(
            self: Self,
            device: Device,
            info: AccelerationStructureMemoryRequirementsInfoNV,
            pMemoryRequirements: *MemoryRequirements2KHR,
        ) void {
            self.dispatch.vkGetAccelerationStructureMemoryRequirementsNV(
                device,
                &info,
                pMemoryRequirements,
            );
        }
        pub const BindAccelerationStructureMemoryNVError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn bindAccelerationStructureMemoryNV(
            self: Self,
            device: Device,
            bindInfoCount: u32,
            pBindInfos: [*]const BindAccelerationStructureMemoryInfoNV,
        ) BindAccelerationStructureMemoryNVError!void {
            const result = self.dispatch.vkBindAccelerationStructureMemoryNV(
                device,
                bindInfoCount,
                pBindInfos,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdCopyAccelerationStructureNV(
            self: Self,
            commandBuffer: CommandBuffer,
            dst: AccelerationStructureNV,
            src: AccelerationStructureNV,
            mode: CopyAccelerationStructureModeKHR,
        ) void {
            self.dispatch.vkCmdCopyAccelerationStructureNV(
                commandBuffer,
                dst,
                src,
                mode,
            );
        }
        pub fn cmdCopyAccelerationStructureKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            info: CopyAccelerationStructureInfoKHR,
        ) void {
            self.dispatch.vkCmdCopyAccelerationStructureKHR(
                commandBuffer,
                &info,
            );
        }
        pub const CopyAccelerationStructureKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn copyAccelerationStructureKHR(
            self: Self,
            device: Device,
            deferredOperation: DeferredOperationKHR,
            info: CopyAccelerationStructureInfoKHR,
        ) CopyAccelerationStructureKHRError!Result {
            const result = self.dispatch.vkCopyAccelerationStructureKHR(
                device,
                deferredOperation,
                &info,
            );
            switch (result) {
                Result.success => {},
                Result.operationDeferredKHR => {},
                Result.operationNotDeferredKHR => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdCopyAccelerationStructureToMemoryKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            info: CopyAccelerationStructureToMemoryInfoKHR,
        ) void {
            self.dispatch.vkCmdCopyAccelerationStructureToMemoryKHR(
                commandBuffer,
                &info,
            );
        }
        pub const CopyAccelerationStructureToMemoryKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn copyAccelerationStructureToMemoryKHR(
            self: Self,
            device: Device,
            deferredOperation: DeferredOperationKHR,
            info: CopyAccelerationStructureToMemoryInfoKHR,
        ) CopyAccelerationStructureToMemoryKHRError!Result {
            const result = self.dispatch.vkCopyAccelerationStructureToMemoryKHR(
                device,
                deferredOperation,
                &info,
            );
            switch (result) {
                Result.success => {},
                Result.operationDeferredKHR => {},
                Result.operationNotDeferredKHR => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdCopyMemoryToAccelerationStructureKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            info: CopyMemoryToAccelerationStructureInfoKHR,
        ) void {
            self.dispatch.vkCmdCopyMemoryToAccelerationStructureKHR(
                commandBuffer,
                &info,
            );
        }
        pub const CopyMemoryToAccelerationStructureKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn copyMemoryToAccelerationStructureKHR(
            self: Self,
            device: Device,
            deferredOperation: DeferredOperationKHR,
            info: CopyMemoryToAccelerationStructureInfoKHR,
        ) CopyMemoryToAccelerationStructureKHRError!Result {
            const result = self.dispatch.vkCopyMemoryToAccelerationStructureKHR(
                device,
                deferredOperation,
                &info,
            );
            switch (result) {
                Result.success => {},
                Result.operationDeferredKHR => {},
                Result.operationNotDeferredKHR => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdWriteAccelerationStructuresPropertiesKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            accelerationStructureCount: u32,
            pAccelerationStructures: [*]const AccelerationStructureKHR,
            queryType: QueryType,
            queryPool: QueryPool,
            firstQuery: u32,
        ) void {
            self.dispatch.vkCmdWriteAccelerationStructuresPropertiesKHR(
                commandBuffer,
                accelerationStructureCount,
                pAccelerationStructures,
                queryType,
                queryPool,
                firstQuery,
            );
        }
        pub fn cmdWriteAccelerationStructuresPropertiesNV(
            self: Self,
            commandBuffer: CommandBuffer,
            accelerationStructureCount: u32,
            pAccelerationStructures: [*]const AccelerationStructureNV,
            queryType: QueryType,
            queryPool: QueryPool,
            firstQuery: u32,
        ) void {
            self.dispatch.vkCmdWriteAccelerationStructuresPropertiesNV(
                commandBuffer,
                accelerationStructureCount,
                pAccelerationStructures,
                queryType,
                queryPool,
                firstQuery,
            );
        }
        pub fn cmdBuildAccelerationStructureNV(
            self: Self,
            commandBuffer: CommandBuffer,
            info: AccelerationStructureInfoNV,
            instanceData: Buffer,
            instanceOffset: DeviceSize,
            update: Bool32,
            dst: AccelerationStructureNV,
            src: AccelerationStructureNV,
            scratch: Buffer,
            scratchOffset: DeviceSize,
        ) void {
            self.dispatch.vkCmdBuildAccelerationStructureNV(
                commandBuffer,
                &info,
                instanceData,
                instanceOffset,
                update,
                dst,
                src,
                scratch,
                scratchOffset,
            );
        }
        pub const WriteAccelerationStructuresPropertiesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn writeAccelerationStructuresPropertiesKHR(
            self: Self,
            device: Device,
            accelerationStructureCount: u32,
            pAccelerationStructures: [*]const AccelerationStructureKHR,
            queryType: QueryType,
            dataSize: usize,
            pData: *c_void,
            stride: usize,
        ) WriteAccelerationStructuresPropertiesKHRError!void {
            const result = self.dispatch.vkWriteAccelerationStructuresPropertiesKHR(
                device,
                accelerationStructureCount,
                pAccelerationStructures,
                queryType,
                dataSize,
                pData,
                stride,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub fn cmdTraceRaysKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            raygenShaderBindingTable: StridedDeviceAddressRegionKHR,
            missShaderBindingTable: StridedDeviceAddressRegionKHR,
            hitShaderBindingTable: StridedDeviceAddressRegionKHR,
            callableShaderBindingTable: StridedDeviceAddressRegionKHR,
            width: u32,
            height: u32,
            depth: u32,
        ) void {
            self.dispatch.vkCmdTraceRaysKHR(
                commandBuffer,
                &raygenShaderBindingTable,
                &missShaderBindingTable,
                &hitShaderBindingTable,
                &callableShaderBindingTable,
                width,
                height,
                depth,
            );
        }
        pub fn cmdTraceRaysNV(
            self: Self,
            commandBuffer: CommandBuffer,
            raygenShaderBindingTableBuffer: Buffer,
            raygenShaderBindingOffset: DeviceSize,
            missShaderBindingTableBuffer: Buffer,
            missShaderBindingOffset: DeviceSize,
            missShaderBindingStride: DeviceSize,
            hitShaderBindingTableBuffer: Buffer,
            hitShaderBindingOffset: DeviceSize,
            hitShaderBindingStride: DeviceSize,
            callableShaderBindingTableBuffer: Buffer,
            callableShaderBindingOffset: DeviceSize,
            callableShaderBindingStride: DeviceSize,
            width: u32,
            height: u32,
            depth: u32,
        ) void {
            self.dispatch.vkCmdTraceRaysNV(
                commandBuffer,
                raygenShaderBindingTableBuffer,
                raygenShaderBindingOffset,
                missShaderBindingTableBuffer,
                missShaderBindingOffset,
                missShaderBindingStride,
                hitShaderBindingTableBuffer,
                hitShaderBindingOffset,
                hitShaderBindingStride,
                callableShaderBindingTableBuffer,
                callableShaderBindingOffset,
                callableShaderBindingStride,
                width,
                height,
                depth,
            );
        }
        pub const GetRayTracingShaderGroupHandlesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getRayTracingShaderGroupHandlesKHR(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            firstGroup: u32,
            groupCount: u32,
            dataSize: usize,
            pData: *c_void,
        ) GetRayTracingShaderGroupHandlesKHRError!void {
            const result = self.dispatch.vkGetRayTracingShaderGroupHandlesKHR(
                device,
                pipeline,
                firstGroup,
                groupCount,
                dataSize,
                pData,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const GetRayTracingCaptureReplayShaderGroupHandlesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getRayTracingCaptureReplayShaderGroupHandlesKHR(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            firstGroup: u32,
            groupCount: u32,
            dataSize: usize,
            pData: *c_void,
        ) GetRayTracingCaptureReplayShaderGroupHandlesKHRError!void {
            const result = self.dispatch.vkGetRayTracingCaptureReplayShaderGroupHandlesKHR(
                device,
                pipeline,
                firstGroup,
                groupCount,
                dataSize,
                pData,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const GetAccelerationStructureHandleNVError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getAccelerationStructureHandleNV(
            self: Self,
            device: Device,
            accelerationStructure: AccelerationStructureNV,
            dataSize: usize,
            pData: *c_void,
        ) GetAccelerationStructureHandleNVError!void {
            const result = self.dispatch.vkGetAccelerationStructureHandleNV(
                device,
                accelerationStructure,
                dataSize,
                pData,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
        }
        pub const CreateRayTracingPipelinesNVError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidShaderNV,
            Unknown,
        };
        pub fn createRayTracingPipelinesNV(
            self: Self,
            device: Device,
            pipelineCache: PipelineCache,
            createInfoCount: u32,
            pCreateInfos: [*]const RayTracingPipelineCreateInfoNV,
            pAllocator: ?*const AllocationCallbacks,
            pPipelines: [*]Pipeline,
        ) CreateRayTracingPipelinesNVError!Result {
            const result = self.dispatch.vkCreateRayTracingPipelinesNV(
                device,
                pipelineCache,
                createInfoCount,
                pCreateInfos,
                pAllocator,
                pPipelines,
            );
            switch (result) {
                Result.success => {},
                Result.pipelineCompileRequiredEXT => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInvalidShaderNV => return error.InvalidShaderNV,
                else => return error.Unknown,
            }
            return result;
        }
        pub const CreateRayTracingPipelinesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InvalidOpaqueCaptureAddress,
            Unknown,
        };
        pub fn createRayTracingPipelinesKHR(
            self: Self,
            device: Device,
            deferredOperation: DeferredOperationKHR,
            pipelineCache: PipelineCache,
            createInfoCount: u32,
            pCreateInfos: [*]const RayTracingPipelineCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
            pPipelines: [*]Pipeline,
        ) CreateRayTracingPipelinesKHRError!Result {
            const result = self.dispatch.vkCreateRayTracingPipelinesKHR(
                device,
                deferredOperation,
                pipelineCache,
                createInfoCount,
                pCreateInfos,
                pAllocator,
                pPipelines,
            );
            switch (result) {
                Result.success => {},
                Result.operationDeferredKHR => {},
                Result.operationNotDeferredKHR => {},
                Result.pipelineCompileRequiredEXT => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInvalidOpaqueCaptureAddress => return error.InvalidOpaqueCaptureAddress,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdTraceRaysIndirectKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            raygenShaderBindingTable: StridedDeviceAddressRegionKHR,
            missShaderBindingTable: StridedDeviceAddressRegionKHR,
            hitShaderBindingTable: StridedDeviceAddressRegionKHR,
            callableShaderBindingTable: StridedDeviceAddressRegionKHR,
            indirectDeviceAddress: DeviceAddress,
        ) void {
            self.dispatch.vkCmdTraceRaysIndirectKHR(
                commandBuffer,
                &raygenShaderBindingTable,
                &missShaderBindingTable,
                &hitShaderBindingTable,
                &callableShaderBindingTable,
                indirectDeviceAddress,
            );
        }
        pub fn getDeviceAccelerationStructureCompatibilityKHR(
            self: Self,
            device: Device,
            versionInfo: AccelerationStructureVersionInfoKHR,
        ) AccelerationStructureCompatibilityKHR {
            var compatibility: AccelerationStructureCompatibilityKHR = undefined;
            self.dispatch.vkGetDeviceAccelerationStructureCompatibilityKHR(
                device,
                &versionInfo,
                &compatibility,
            );
            return compatibility;
        }
        pub fn getRayTracingShaderGroupStackSizeKHR(
            self: Self,
            device: Device,
            pipeline: Pipeline,
            group: u32,
            groupShader: ShaderGroupShaderKHR,
        ) DeviceSize {
            return self.dispatch.vkGetRayTracingShaderGroupStackSizeKHR(
                device,
                pipeline,
                group,
                groupShader,
            );
        }
        pub fn cmdSetRayTracingPipelineStackSizeKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            pipelineStackSize: u32,
        ) void {
            self.dispatch.vkCmdSetRayTracingPipelineStackSizeKHR(
                commandBuffer,
                pipelineStackSize,
            );
        }
        pub fn getImageViewHandleNVX(
            self: Self,
            device: Device,
            info: ImageViewHandleInfoNVX,
        ) u32 {
            return self.dispatch.vkGetImageViewHandleNVX(
                device,
                &info,
            );
        }
        pub const GetImageViewAddressNVXError = error{
            OutOfHostMemory,
            Unknown,
            Unknown,
        };
        pub fn getImageViewAddressNVX(
            self: Self,
            device: Device,
            imageView: ImageView,
            pProperties: *ImageViewAddressPropertiesNVX,
        ) GetImageViewAddressNVXError!void {
            const result = self.dispatch.vkGetImageViewAddressNVX(
                device,
                imageView,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorUnknown => return error.Unknown,
                else => return error.Unknown,
            }
        }
        pub const GetDeviceGroupSurfacePresentModes2EXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn getDeviceGroupSurfacePresentModes2EXT(
            self: Self,
            device: Device,
            surfaceInfo: PhysicalDeviceSurfaceInfo2KHR,
        ) GetDeviceGroupSurfacePresentModes2EXTError!DeviceGroupPresentModeFlagsKHR {
            var modes: DeviceGroupPresentModeFlagsKHR = undefined;
            const result = self.dispatch.vkGetDeviceGroupSurfacePresentModes2EXT(
                device,
                &surfaceInfo,
                &modes,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
            return modes;
        }
        pub const AcquireFullScreenExclusiveModeEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn acquireFullScreenExclusiveModeEXT(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
        ) AcquireFullScreenExclusiveModeEXTError!void {
            const result = self.dispatch.vkAcquireFullScreenExclusiveModeEXT(
                device,
                swapchain,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub const ReleaseFullScreenExclusiveModeEXTError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            SurfaceLostKHR,
            Unknown,
        };
        pub fn releaseFullScreenExclusiveModeEXT(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
        ) ReleaseFullScreenExclusiveModeEXTError!void {
            const result = self.dispatch.vkReleaseFullScreenExclusiveModeEXT(
                device,
                swapchain,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorSurfaceLostKHR => return error.SurfaceLostKHR,
                else => return error.Unknown,
            }
        }
        pub const AcquireProfilingLockKHRError = error{
            OutOfHostMemory,
            Timeout,
            Unknown,
        };
        pub fn acquireProfilingLockKHR(
            self: Self,
            device: Device,
            info: AcquireProfilingLockInfoKHR,
        ) AcquireProfilingLockKHRError!void {
            const result = self.dispatch.vkAcquireProfilingLockKHR(
                device,
                &info,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.timeout => return error.Timeout,
                else => return error.Unknown,
            }
        }
        pub fn releaseProfilingLockKHR(
            self: Self,
            device: Device,
        ) void {
            self.dispatch.vkReleaseProfilingLockKHR(
                device,
            );
        }
        pub const GetImageDrmFormatModifierPropertiesEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn getImageDrmFormatModifierPropertiesEXT(
            self: Self,
            device: Device,
            image: Image,
            pProperties: *ImageDrmFormatModifierPropertiesEXT,
        ) GetImageDrmFormatModifierPropertiesEXTError!void {
            const result = self.dispatch.vkGetImageDrmFormatModifierPropertiesEXT(
                device,
                image,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn getBufferOpaqueCaptureAddress(
            self: Self,
            device: Device,
            info: BufferDeviceAddressInfo,
        ) u64 {
            return self.dispatch.vkGetBufferOpaqueCaptureAddress(
                device,
                &info,
            );
        }
        pub fn getBufferDeviceAddress(
            self: Self,
            device: Device,
            info: BufferDeviceAddressInfo,
        ) DeviceAddress {
            return self.dispatch.vkGetBufferDeviceAddress(
                device,
                &info,
            );
        }
        pub const InitializePerformanceApiINTELError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn initializePerformanceApiINTEL(
            self: Self,
            device: Device,
            initializeInfo: InitializePerformanceApiInfoINTEL,
        ) InitializePerformanceApiINTELError!void {
            const result = self.dispatch.vkInitializePerformanceApiINTEL(
                device,
                &initializeInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn uninitializePerformanceApiINTEL(
            self: Self,
            device: Device,
        ) void {
            self.dispatch.vkUninitializePerformanceApiINTEL(
                device,
            );
        }
        pub const CmdSetPerformanceMarkerINTELError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn cmdSetPerformanceMarkerINTEL(
            self: Self,
            commandBuffer: CommandBuffer,
            markerInfo: PerformanceMarkerInfoINTEL,
        ) CmdSetPerformanceMarkerINTELError!void {
            const result = self.dispatch.vkCmdSetPerformanceMarkerINTEL(
                commandBuffer,
                &markerInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const CmdSetPerformanceStreamMarkerINTELError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn cmdSetPerformanceStreamMarkerINTEL(
            self: Self,
            commandBuffer: CommandBuffer,
            markerInfo: PerformanceStreamMarkerInfoINTEL,
        ) CmdSetPerformanceStreamMarkerINTELError!void {
            const result = self.dispatch.vkCmdSetPerformanceStreamMarkerINTEL(
                commandBuffer,
                &markerInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const CmdSetPerformanceOverrideINTELError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn cmdSetPerformanceOverrideINTEL(
            self: Self,
            commandBuffer: CommandBuffer,
            overrideInfo: PerformanceOverrideInfoINTEL,
        ) CmdSetPerformanceOverrideINTELError!void {
            const result = self.dispatch.vkCmdSetPerformanceOverrideINTEL(
                commandBuffer,
                &overrideInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const AcquirePerformanceConfigurationINTELError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn acquirePerformanceConfigurationINTEL(
            self: Self,
            device: Device,
            acquireInfo: PerformanceConfigurationAcquireInfoINTEL,
        ) AcquirePerformanceConfigurationINTELError!PerformanceConfigurationINTEL {
            var configuration: PerformanceConfigurationINTEL = undefined;
            const result = self.dispatch.vkAcquirePerformanceConfigurationINTEL(
                device,
                &acquireInfo,
                &configuration,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return configuration;
        }
        pub const ReleasePerformanceConfigurationINTELError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn releasePerformanceConfigurationINTEL(
            self: Self,
            device: Device,
            configuration: PerformanceConfigurationINTEL,
        ) ReleasePerformanceConfigurationINTELError!void {
            const result = self.dispatch.vkReleasePerformanceConfigurationINTEL(
                device,
                configuration,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const QueueSetPerformanceConfigurationINTELError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn queueSetPerformanceConfigurationINTEL(
            self: Self,
            queue: Queue,
            configuration: PerformanceConfigurationINTEL,
        ) QueueSetPerformanceConfigurationINTELError!void {
            const result = self.dispatch.vkQueueSetPerformanceConfigurationINTEL(
                queue,
                configuration,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub const GetPerformanceParameterINTELError = error{
            TooManyObjects,
            OutOfHostMemory,
            Unknown,
        };
        pub fn getPerformanceParameterINTEL(
            self: Self,
            device: Device,
            parameter: PerformanceParameterTypeINTEL,
        ) GetPerformanceParameterINTELError!PerformanceValueINTEL {
            var value: PerformanceValueINTEL = undefined;
            const result = self.dispatch.vkGetPerformanceParameterINTEL(
                device,
                parameter,
                &value,
            );
            switch (result) {
                Result.success => {},
                Result.errorTooManyObjects => return error.TooManyObjects,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return value;
        }
        pub fn getDeviceMemoryOpaqueCaptureAddress(
            self: Self,
            device: Device,
            info: DeviceMemoryOpaqueCaptureAddressInfo,
        ) u64 {
            return self.dispatch.vkGetDeviceMemoryOpaqueCaptureAddress(
                device,
                &info,
            );
        }
        pub const GetPipelineExecutablePropertiesKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPipelineExecutablePropertiesKHR(
            self: Self,
            device: Device,
            pipelineInfo: PipelineInfoKHR,
            pExecutableCount: *u32,
            pProperties: ?[*]PipelineExecutablePropertiesKHR,
        ) GetPipelineExecutablePropertiesKHRError!Result {
            const result = self.dispatch.vkGetPipelineExecutablePropertiesKHR(
                device,
                &pipelineInfo,
                pExecutableCount,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPipelineExecutableStatisticsKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPipelineExecutableStatisticsKHR(
            self: Self,
            device: Device,
            executableInfo: PipelineExecutableInfoKHR,
            pStatisticCount: *u32,
            pStatistics: ?[*]PipelineExecutableStatisticKHR,
        ) GetPipelineExecutableStatisticsKHRError!Result {
            const result = self.dispatch.vkGetPipelineExecutableStatisticsKHR(
                device,
                &executableInfo,
                pStatisticCount,
                pStatistics,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub const GetPipelineExecutableInternalRepresentationsKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn getPipelineExecutableInternalRepresentationsKHR(
            self: Self,
            device: Device,
            executableInfo: PipelineExecutableInfoKHR,
            pInternalRepresentationCount: *u32,
            pInternalRepresentations: ?[*]PipelineExecutableInternalRepresentationKHR,
        ) GetPipelineExecutableInternalRepresentationsKHRError!Result {
            const result = self.dispatch.vkGetPipelineExecutableInternalRepresentationsKHR(
                device,
                &executableInfo,
                pInternalRepresentationCount,
                pInternalRepresentations,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdSetLineStippleEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            lineStippleFactor: u32,
            lineStipplePattern: u16,
        ) void {
            self.dispatch.vkCmdSetLineStippleEXT(
                commandBuffer,
                lineStippleFactor,
                lineStipplePattern,
            );
        }
        pub const CreateAccelerationStructureKHRError = error{
            OutOfHostMemory,
            InvalidOpaqueCaptureAddressKHR,
            Unknown,
        };
        pub fn createAccelerationStructureKHR(
            self: Self,
            device: Device,
            createInfo: AccelerationStructureCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateAccelerationStructureKHRError!AccelerationStructureKHR {
            var accelerationStructure: AccelerationStructureKHR = undefined;
            const result = self.dispatch.vkCreateAccelerationStructureKHR(
                device,
                &createInfo,
                pAllocator,
                &accelerationStructure,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidOpaqueCaptureAddressKHR => return error.InvalidOpaqueCaptureAddressKHR,
                else => return error.Unknown,
            }
            return accelerationStructure;
        }
        pub fn cmdBuildAccelerationStructuresKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            infoCount: u32,
            pInfos: [*]const AccelerationStructureBuildGeometryInfoKHR,
            ppBuildRangeInfos: [*]const *const AccelerationStructureBuildRangeInfoKHR,
        ) void {
            self.dispatch.vkCmdBuildAccelerationStructuresKHR(
                commandBuffer,
                infoCount,
                pInfos,
                ppBuildRangeInfos,
            );
        }
        pub fn cmdBuildAccelerationStructuresIndirectKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            infoCount: u32,
            pInfos: [*]const AccelerationStructureBuildGeometryInfoKHR,
            pIndirectDeviceAddresses: [*]const DeviceAddress,
            pIndirectStrides: [*]const u32,
            ppMaxPrimitiveCounts: [*]const *const u32,
        ) void {
            self.dispatch.vkCmdBuildAccelerationStructuresIndirectKHR(
                commandBuffer,
                infoCount,
                pInfos,
                pIndirectDeviceAddresses,
                pIndirectStrides,
                ppMaxPrimitiveCounts,
            );
        }
        pub const BuildAccelerationStructuresKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn buildAccelerationStructuresKHR(
            self: Self,
            device: Device,
            deferredOperation: DeferredOperationKHR,
            infoCount: u32,
            pInfos: [*]const AccelerationStructureBuildGeometryInfoKHR,
            ppBuildRangeInfos: [*]const *const AccelerationStructureBuildRangeInfoKHR,
        ) BuildAccelerationStructuresKHRError!Result {
            const result = self.dispatch.vkBuildAccelerationStructuresKHR(
                device,
                deferredOperation,
                infoCount,
                pInfos,
                ppBuildRangeInfos,
            );
            switch (result) {
                Result.success => {},
                Result.operationDeferredKHR => {},
                Result.operationNotDeferredKHR => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn getAccelerationStructureDeviceAddressKHR(
            self: Self,
            device: Device,
            info: AccelerationStructureDeviceAddressInfoKHR,
        ) DeviceAddress {
            return self.dispatch.vkGetAccelerationStructureDeviceAddressKHR(
                device,
                &info,
            );
        }
        pub const CreateDeferredOperationKHRError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn createDeferredOperationKHR(
            self: Self,
            device: Device,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateDeferredOperationKHRError!DeferredOperationKHR {
            var deferredOperation: DeferredOperationKHR = undefined;
            const result = self.dispatch.vkCreateDeferredOperationKHR(
                device,
                pAllocator,
                &deferredOperation,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return deferredOperation;
        }
        pub fn destroyDeferredOperationKHR(
            self: Self,
            device: Device,
            operation: DeferredOperationKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyDeferredOperationKHR(
                device,
                operation,
                pAllocator,
            );
        }
        pub fn getDeferredOperationMaxConcurrencyKHR(
            self: Self,
            device: Device,
            operation: DeferredOperationKHR,
        ) u32 {
            return self.dispatch.vkGetDeferredOperationMaxConcurrencyKHR(
                device,
                operation,
            );
        }
        pub fn getDeferredOperationResultKHR(
            self: Self,
            device: Device,
            operation: DeferredOperationKHR,
        ) Result {
            const result = self.dispatch.vkGetDeferredOperationResultKHR(
                device,
                operation,
            );
            switch (result) {
                Result.success => {},
                Result.notReady => {},
                else => return error.Unknown,
            }
            return result;
        }
        pub const DeferredOperationJoinKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            Unknown,
        };
        pub fn deferredOperationJoinKHR(
            self: Self,
            device: Device,
            operation: DeferredOperationKHR,
        ) DeferredOperationJoinKHRError!Result {
            const result = self.dispatch.vkDeferredOperationJoinKHR(
                device,
                operation,
            );
            switch (result) {
                Result.success => {},
                Result.threadDoneKHR => {},
                Result.threadIdleKHR => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                else => return error.Unknown,
            }
            return result;
        }
        pub fn cmdSetCullModeEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            cullMode: CullModeFlags,
        ) void {
            self.dispatch.vkCmdSetCullModeEXT(
                commandBuffer,
                cullMode.toInt(),
            );
        }
        pub fn cmdSetFrontFaceEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            frontFace: FrontFace,
        ) void {
            self.dispatch.vkCmdSetFrontFaceEXT(
                commandBuffer,
                frontFace,
            );
        }
        pub fn cmdSetPrimitiveTopologyEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            primitiveTopology: PrimitiveTopology,
        ) void {
            self.dispatch.vkCmdSetPrimitiveTopologyEXT(
                commandBuffer,
                primitiveTopology,
            );
        }
        pub fn cmdSetViewportWithCountEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            viewportCount: u32,
            pViewports: [*]const Viewport,
        ) void {
            self.dispatch.vkCmdSetViewportWithCountEXT(
                commandBuffer,
                viewportCount,
                pViewports,
            );
        }
        pub fn cmdSetScissorWithCountEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            scissorCount: u32,
            pScissors: [*]const Rect2D,
        ) void {
            self.dispatch.vkCmdSetScissorWithCountEXT(
                commandBuffer,
                scissorCount,
                pScissors,
            );
        }
        pub fn cmdBindVertexBuffers2EXT(
            self: Self,
            commandBuffer: CommandBuffer,
            firstBinding: u32,
            bindingCount: u32,
            pBuffers: [*]const Buffer,
            pOffsets: [*]const DeviceSize,
            pSizes: ?[*]const DeviceSize,
            pStrides: ?[*]const DeviceSize,
        ) void {
            self.dispatch.vkCmdBindVertexBuffers2EXT(
                commandBuffer,
                firstBinding,
                bindingCount,
                pBuffers,
                pOffsets,
                pSizes,
                pStrides,
            );
        }
        pub fn cmdSetDepthTestEnableEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            depthTestEnable: Bool32,
        ) void {
            self.dispatch.vkCmdSetDepthTestEnableEXT(
                commandBuffer,
                depthTestEnable,
            );
        }
        pub fn cmdSetDepthWriteEnableEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            depthWriteEnable: Bool32,
        ) void {
            self.dispatch.vkCmdSetDepthWriteEnableEXT(
                commandBuffer,
                depthWriteEnable,
            );
        }
        pub fn cmdSetDepthCompareOpEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            depthCompareOp: CompareOp,
        ) void {
            self.dispatch.vkCmdSetDepthCompareOpEXT(
                commandBuffer,
                depthCompareOp,
            );
        }
        pub fn cmdSetDepthBoundsTestEnableEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            depthBoundsTestEnable: Bool32,
        ) void {
            self.dispatch.vkCmdSetDepthBoundsTestEnableEXT(
                commandBuffer,
                depthBoundsTestEnable,
            );
        }
        pub fn cmdSetStencilTestEnableEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            stencilTestEnable: Bool32,
        ) void {
            self.dispatch.vkCmdSetStencilTestEnableEXT(
                commandBuffer,
                stencilTestEnable,
            );
        }
        pub fn cmdSetStencilOpEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            faceMask: StencilFaceFlags,
            failOp: StencilOp,
            passOp: StencilOp,
            depthFailOp: StencilOp,
            compareOp: CompareOp,
        ) void {
            self.dispatch.vkCmdSetStencilOpEXT(
                commandBuffer,
                faceMask.toInt(),
                failOp,
                passOp,
                depthFailOp,
                compareOp,
            );
        }
        pub fn cmdSetPatchControlPointsEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            patchControlPoints: u32,
        ) void {
            self.dispatch.vkCmdSetPatchControlPointsEXT(
                commandBuffer,
                patchControlPoints,
            );
        }
        pub fn cmdSetRasterizerDiscardEnableEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            rasterizerDiscardEnable: Bool32,
        ) void {
            self.dispatch.vkCmdSetRasterizerDiscardEnableEXT(
                commandBuffer,
                rasterizerDiscardEnable,
            );
        }
        pub fn cmdSetDepthBiasEnableEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            depthBiasEnable: Bool32,
        ) void {
            self.dispatch.vkCmdSetDepthBiasEnableEXT(
                commandBuffer,
                depthBiasEnable,
            );
        }
        pub fn cmdSetLogicOpEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            logicOp: LogicOp,
        ) void {
            self.dispatch.vkCmdSetLogicOpEXT(
                commandBuffer,
                logicOp,
            );
        }
        pub fn cmdSetPrimitiveRestartEnableEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            primitiveRestartEnable: Bool32,
        ) void {
            self.dispatch.vkCmdSetPrimitiveRestartEnableEXT(
                commandBuffer,
                primitiveRestartEnable,
            );
        }
        pub const CreatePrivateDataSlotEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn createPrivateDataSlotEXT(
            self: Self,
            device: Device,
            createInfo: PrivateDataSlotCreateInfoEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) CreatePrivateDataSlotEXTError!PrivateDataSlotEXT {
            var privateDataSlot: PrivateDataSlotEXT = undefined;
            const result = self.dispatch.vkCreatePrivateDataSlotEXT(
                device,
                &createInfo,
                pAllocator,
                &privateDataSlot,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
            return privateDataSlot;
        }
        pub fn destroyPrivateDataSlotEXT(
            self: Self,
            device: Device,
            privateDataSlot: PrivateDataSlotEXT,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyPrivateDataSlotEXT(
                device,
                privateDataSlot,
                pAllocator,
            );
        }
        pub const SetPrivateDataEXTError = error{
            OutOfHostMemory,
            Unknown,
        };
        pub fn setPrivateDataEXT(
            self: Self,
            device: Device,
            objectType: ObjectType,
            objectHandle: u64,
            privateDataSlot: PrivateDataSlotEXT,
            data: u64,
        ) SetPrivateDataEXTError!void {
            const result = self.dispatch.vkSetPrivateDataEXT(
                device,
                objectType,
                objectHandle,
                privateDataSlot,
                data,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                else => return error.Unknown,
            }
        }
        pub fn getPrivateDataEXT(
            self: Self,
            device: Device,
            objectType: ObjectType,
            objectHandle: u64,
            privateDataSlot: PrivateDataSlotEXT,
        ) u64 {
            var data: u64 = undefined;
            self.dispatch.vkGetPrivateDataEXT(
                device,
                objectType,
                objectHandle,
                privateDataSlot,
                &data,
            );
            return data;
        }
        pub fn cmdCopyBuffer2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            copyBufferInfo: CopyBufferInfo2KHR,
        ) void {
            self.dispatch.vkCmdCopyBuffer2KHR(
                commandBuffer,
                &copyBufferInfo,
            );
        }
        pub fn cmdCopyImage2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            copyImageInfo: CopyImageInfo2KHR,
        ) void {
            self.dispatch.vkCmdCopyImage2KHR(
                commandBuffer,
                &copyImageInfo,
            );
        }
        pub fn cmdBlitImage2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            blitImageInfo: BlitImageInfo2KHR,
        ) void {
            self.dispatch.vkCmdBlitImage2KHR(
                commandBuffer,
                &blitImageInfo,
            );
        }
        pub fn cmdCopyBufferToImage2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            copyBufferToImageInfo: CopyBufferToImageInfo2KHR,
        ) void {
            self.dispatch.vkCmdCopyBufferToImage2KHR(
                commandBuffer,
                &copyBufferToImageInfo,
            );
        }
        pub fn cmdCopyImageToBuffer2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            copyImageToBufferInfo: CopyImageToBufferInfo2KHR,
        ) void {
            self.dispatch.vkCmdCopyImageToBuffer2KHR(
                commandBuffer,
                &copyImageToBufferInfo,
            );
        }
        pub fn cmdResolveImage2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            resolveImageInfo: ResolveImageInfo2KHR,
        ) void {
            self.dispatch.vkCmdResolveImage2KHR(
                commandBuffer,
                &resolveImageInfo,
            );
        }
        pub fn cmdSetFragmentShadingRateKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            fragmentSize: Extent2D,
            combinerOps: [2]FragmentShadingRateCombinerOpKHR,
        ) void {
            self.dispatch.vkCmdSetFragmentShadingRateKHR(
                commandBuffer,
                &fragmentSize,
                combinerOps,
            );
        }
        pub fn cmdSetFragmentShadingRateEnumNV(
            self: Self,
            commandBuffer: CommandBuffer,
            shadingRate: FragmentShadingRateNV,
            combinerOps: [2]FragmentShadingRateCombinerOpKHR,
        ) void {
            self.dispatch.vkCmdSetFragmentShadingRateEnumNV(
                commandBuffer,
                shadingRate,
                combinerOps,
            );
        }
        pub fn getAccelerationStructureBuildSizesKHR(
            self: Self,
            device: Device,
            buildType: AccelerationStructureBuildTypeKHR,
            buildInfo: AccelerationStructureBuildGeometryInfoKHR,
            pMaxPrimitiveCounts: ?[*]const u32,
            pSizeInfo: *AccelerationStructureBuildSizesInfoKHR,
        ) void {
            self.dispatch.vkGetAccelerationStructureBuildSizesKHR(
                device,
                buildType,
                &buildInfo,
                pMaxPrimitiveCounts,
                pSizeInfo,
            );
        }
        pub fn cmdSetVertexInputEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            vertexBindingDescriptionCount: u32,
            pVertexBindingDescriptions: [*]const VertexInputBindingDescription2EXT,
            vertexAttributeDescriptionCount: u32,
            pVertexAttributeDescriptions: [*]const VertexInputAttributeDescription2EXT,
        ) void {
            self.dispatch.vkCmdSetVertexInputEXT(
                commandBuffer,
                vertexBindingDescriptionCount,
                pVertexBindingDescriptions,
                vertexAttributeDescriptionCount,
                pVertexAttributeDescriptions,
            );
        }
        pub fn cmdSetColorWriteEnableEXT(
            self: Self,
            commandBuffer: CommandBuffer,
            attachmentCount: u32,
            pColorWriteEnables: [*]const Bool32,
        ) void {
            self.dispatch.vkCmdSetColorWriteEnableEXT(
                commandBuffer,
                attachmentCount,
                pColorWriteEnables,
            );
        }
        pub fn cmdSetEvent2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            event: Event,
            dependencyInfo: DependencyInfoKHR,
        ) void {
            self.dispatch.vkCmdSetEvent2KHR(
                commandBuffer,
                event,
                &dependencyInfo,
            );
        }
        pub fn cmdResetEvent2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            event: Event,
            stageMask: PipelineStageFlags2KHR,
        ) void {
            self.dispatch.vkCmdResetEvent2KHR(
                commandBuffer,
                event,
                stageMask,
            );
        }
        pub fn cmdWaitEvents2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            eventCount: u32,
            pEvents: [*]const Event,
            pDependencyInfos: [*]const DependencyInfoKHR,
        ) void {
            self.dispatch.vkCmdWaitEvents2KHR(
                commandBuffer,
                eventCount,
                pEvents,
                pDependencyInfos,
            );
        }
        pub fn cmdPipelineBarrier2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            dependencyInfo: DependencyInfoKHR,
        ) void {
            self.dispatch.vkCmdPipelineBarrier2KHR(
                commandBuffer,
                &dependencyInfo,
            );
        }
        pub const QueueSubmit2KHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn queueSubmit2KHR(
            self: Self,
            queue: Queue,
            submitCount: u32,
            pSubmits: [*]const SubmitInfo2KHR,
            fence: Fence,
        ) QueueSubmit2KHRError!void {
            const result = self.dispatch.vkQueueSubmit2KHR(
                queue,
                submitCount,
                pSubmits,
                fence,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
        }
        pub fn cmdWriteTimestamp2KHR(
            self: Self,
            commandBuffer: CommandBuffer,
            stage: PipelineStageFlags2KHR,
            queryPool: QueryPool,
            query: u32,
        ) void {
            self.dispatch.vkCmdWriteTimestamp2KHR(
                commandBuffer,
                stage,
                queryPool,
                query,
            );
        }
        pub fn cmdWriteBufferMarker2AMD(
            self: Self,
            commandBuffer: CommandBuffer,
            stage: PipelineStageFlags2KHR,
            dstBuffer: Buffer,
            dstOffset: DeviceSize,
            marker: u32,
        ) void {
            self.dispatch.vkCmdWriteBufferMarker2AMD(
                commandBuffer,
                stage,
                dstBuffer,
                dstOffset,
                marker,
            );
        }
        pub fn getQueueCheckpointData2NV(
            self: Self,
            queue: Queue,
            pCheckpointDataCount: *u32,
            pCheckpointData: ?[*]CheckpointData2NV,
        ) void {
            self.dispatch.vkGetQueueCheckpointData2NV(
                queue,
                pCheckpointDataCount,
                pCheckpointData,
            );
        }
        pub const CreateVideoSessionKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            IncompatibleDriver,
            FeatureNotPresent,
            Unknown,
        };
        pub fn createVideoSessionKHR(
            self: Self,
            device: Device,
            createInfo: VideoSessionCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateVideoSessionKHRError!VideoSessionKHR {
            var videoSession: VideoSessionKHR = undefined;
            const result = self.dispatch.vkCreateVideoSessionKHR(
                device,
                &createInfo,
                pAllocator,
                &videoSession,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorIncompatibleDriver => return error.IncompatibleDriver,
                Result.errorFeatureNotPresent => return error.FeatureNotPresent,
                else => return error.Unknown,
            }
            return videoSession;
        }
        pub fn destroyVideoSessionKHR(
            self: Self,
            device: Device,
            videoSession: VideoSessionKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyVideoSessionKHR(
                device,
                videoSession,
                pAllocator,
            );
        }
        pub const CreateVideoSessionParametersKHRError = error{
            InitializationFailed,
            OutOfHostMemory,
            OutOfDeviceMemory,
            TooManyObjects,
            Unknown,
        };
        pub fn createVideoSessionParametersKHR(
            self: Self,
            device: Device,
            createInfo: VideoSessionParametersCreateInfoKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateVideoSessionParametersKHRError!VideoSessionParametersKHR {
            var videoSessionParameters: VideoSessionParametersKHR = undefined;
            const result = self.dispatch.vkCreateVideoSessionParametersKHR(
                device,
                &createInfo,
                pAllocator,
                &videoSessionParameters,
            );
            switch (result) {
                Result.success => {},
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorTooManyObjects => return error.TooManyObjects,
                else => return error.Unknown,
            }
            return videoSessionParameters;
        }
        pub const UpdateVideoSessionParametersKHRError = error{
            InitializationFailed,
            TooManyObjects,
            Unknown,
        };
        pub fn updateVideoSessionParametersKHR(
            self: Self,
            device: Device,
            videoSessionParameters: VideoSessionParametersKHR,
            updateInfo: VideoSessionParametersUpdateInfoKHR,
        ) UpdateVideoSessionParametersKHRError!void {
            const result = self.dispatch.vkUpdateVideoSessionParametersKHR(
                device,
                videoSessionParameters,
                &updateInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorTooManyObjects => return error.TooManyObjects,
                else => return error.Unknown,
            }
        }
        pub fn destroyVideoSessionParametersKHR(
            self: Self,
            device: Device,
            videoSessionParameters: VideoSessionParametersKHR,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyVideoSessionParametersKHR(
                device,
                videoSessionParameters,
                pAllocator,
            );
        }
        pub const GetVideoSessionMemoryRequirementsKHRError = error{
            InitializationFailed,
            Unknown,
        };
        pub fn getVideoSessionMemoryRequirementsKHR(
            self: Self,
            device: Device,
            videoSession: VideoSessionKHR,
            pVideoSessionMemoryRequirementsCount: *u32,
            pVideoSessionMemoryRequirements: ?[*]VideoGetMemoryPropertiesKHR,
        ) GetVideoSessionMemoryRequirementsKHRError!Result {
            const result = self.dispatch.vkGetVideoSessionMemoryRequirementsKHR(
                device,
                videoSession,
                pVideoSessionMemoryRequirementsCount,
                pVideoSessionMemoryRequirements,
            );
            switch (result) {
                Result.success => {},
                Result.incomplete => {},
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return result;
        }
        pub const BindVideoSessionMemoryKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            InitializationFailed,
            Unknown,
        };
        pub fn bindVideoSessionMemoryKHR(
            self: Self,
            device: Device,
            videoSession: VideoSessionKHR,
            videoSessionBindMemoryCount: u32,
            pVideoSessionBindMemories: [*]const VideoBindMemoryKHR,
        ) BindVideoSessionMemoryKHRError!void {
            const result = self.dispatch.vkBindVideoSessionMemoryKHR(
                device,
                videoSession,
                videoSessionBindMemoryCount,
                pVideoSessionBindMemories,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
        }
        pub fn cmdDecodeVideoKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            frameInfo: VideoDecodeInfoKHR,
        ) void {
            self.dispatch.vkCmdDecodeVideoKHR(
                commandBuffer,
                &frameInfo,
            );
        }
        pub fn cmdBeginVideoCodingKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            beginInfo: VideoBeginCodingInfoKHR,
        ) void {
            self.dispatch.vkCmdBeginVideoCodingKHR(
                commandBuffer,
                &beginInfo,
            );
        }
        pub fn cmdControlVideoCodingKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            codingControlInfo: VideoCodingControlInfoKHR,
        ) void {
            self.dispatch.vkCmdControlVideoCodingKHR(
                commandBuffer,
                &codingControlInfo,
            );
        }
        pub fn cmdEndVideoCodingKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            endCodingInfo: VideoEndCodingInfoKHR,
        ) void {
            self.dispatch.vkCmdEndVideoCodingKHR(
                commandBuffer,
                &endCodingInfo,
            );
        }
        pub fn cmdEncodeVideoKHR(
            self: Self,
            commandBuffer: CommandBuffer,
            encodeInfo: VideoEncodeInfoKHR,
        ) void {
            self.dispatch.vkCmdEncodeVideoKHR(
                commandBuffer,
                &encodeInfo,
            );
        }
        pub const CreateCuModuleNVXError = error{
            OutOfHostMemory,
            InitializationFailed,
            Unknown,
        };
        pub fn createCuModuleNVX(
            self: Self,
            device: Device,
            createInfo: CuModuleCreateInfoNVX,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateCuModuleNVXError!CuModuleNVX {
            var module: CuModuleNVX = undefined;
            const result = self.dispatch.vkCreateCuModuleNVX(
                device,
                &createInfo,
                pAllocator,
                &module,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return module;
        }
        pub const CreateCuFunctionNVXError = error{
            OutOfHostMemory,
            InitializationFailed,
            Unknown,
        };
        pub fn createCuFunctionNVX(
            self: Self,
            device: Device,
            createInfo: CuFunctionCreateInfoNVX,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateCuFunctionNVXError!CuFunctionNVX {
            var function: CuFunctionNVX = undefined;
            const result = self.dispatch.vkCreateCuFunctionNVX(
                device,
                &createInfo,
                pAllocator,
                &function,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return function;
        }
        pub fn destroyCuModuleNVX(
            self: Self,
            device: Device,
            module: CuModuleNVX,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyCuModuleNVX(
                device,
                module,
                pAllocator,
            );
        }
        pub fn destroyCuFunctionNVX(
            self: Self,
            device: Device,
            function: CuFunctionNVX,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyCuFunctionNVX(
                device,
                function,
                pAllocator,
            );
        }
        pub fn cmdCuLaunchKernelNVX(
            self: Self,
            commandBuffer: CommandBuffer,
            launchInfo: CuLaunchInfoNVX,
        ) void {
            self.dispatch.vkCmdCuLaunchKernelNVX(
                commandBuffer,
                &launchInfo,
            );
        }
        pub fn setDeviceMemoryPriorityEXT(
            self: Self,
            device: Device,
            memory: DeviceMemory,
            priority: f32,
        ) void {
            self.dispatch.vkSetDeviceMemoryPriorityEXT(
                device,
                memory,
                priority,
            );
        }
        pub const WaitForPresentKHRError = error{
            OutOfHostMemory,
            OutOfDeviceMemory,
            DeviceLost,
            Unknown,
        };
        pub fn waitForPresentKHR(
            self: Self,
            device: Device,
            swapchain: SwapchainKHR,
            presentId: u64,
            timeout: u64,
        ) WaitForPresentKHRError!Result {
            const result = self.dispatch.vkWaitForPresentKHR(
                device,
                swapchain,
                presentId,
                timeout,
            );
            switch (result) {
                Result.success => {},
                Result.timeout => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorOutOfDeviceMemory => return error.OutOfDeviceMemory,
                Result.errorDeviceLost => return error.DeviceLost,
                else => return error.Unknown,
            }
            return result;
        }
        pub const CreateBufferCollectionFUCHSIAError = error{
            OutOfHostMemory,
            InvalidExternalHandle,
            InitializationFailed,
            Unknown,
        };
        pub fn createBufferCollectionFUCHSIA(
            self: Self,
            device: Device,
            createInfo: BufferCollectionCreateInfoFUCHSIA,
            pAllocator: ?*const AllocationCallbacks,
        ) CreateBufferCollectionFUCHSIAError!BufferCollectionFUCHSIA {
            var collection: BufferCollectionFUCHSIA = undefined;
            const result = self.dispatch.vkCreateBufferCollectionFUCHSIA(
                device,
                &createInfo,
                pAllocator,
                &collection,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInvalidExternalHandle => return error.InvalidExternalHandle,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
            return collection;
        }
        pub const SetBufferCollectionBufferConstraintsFUCHSIAError = error{
            InitializationFailed,
            OutOfHostMemory,
            FormatNotSupported,
            Unknown,
        };
        pub fn setBufferCollectionBufferConstraintsFUCHSIA(
            self: Self,
            device: Device,
            collection: BufferCollectionFUCHSIA,
            bufferConstraintsInfo: BufferConstraintsInfoFUCHSIA,
        ) SetBufferCollectionBufferConstraintsFUCHSIAError!void {
            const result = self.dispatch.vkSetBufferCollectionBufferConstraintsFUCHSIA(
                device,
                collection,
                &bufferConstraintsInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorFormatNotSupported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
        }
        pub const SetBufferCollectionImageConstraintsFUCHSIAError = error{
            InitializationFailed,
            OutOfHostMemory,
            FormatNotSupported,
            Unknown,
        };
        pub fn setBufferCollectionImageConstraintsFUCHSIA(
            self: Self,
            device: Device,
            collection: BufferCollectionFUCHSIA,
            imageConstraintsInfo: ImageConstraintsInfoFUCHSIA,
        ) SetBufferCollectionImageConstraintsFUCHSIAError!void {
            const result = self.dispatch.vkSetBufferCollectionImageConstraintsFUCHSIA(
                device,
                collection,
                &imageConstraintsInfo,
            );
            switch (result) {
                Result.success => {},
                Result.errorInitializationFailed => return error.InitializationFailed,
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorFormatNotSupported => return error.FormatNotSupported,
                else => return error.Unknown,
            }
        }
        pub fn destroyBufferCollectionFUCHSIA(
            self: Self,
            device: Device,
            collection: BufferCollectionFUCHSIA,
            pAllocator: ?*const AllocationCallbacks,
        ) void {
            self.dispatch.vkDestroyBufferCollectionFUCHSIA(
                device,
                collection,
                pAllocator,
            );
        }
        pub const GetBufferCollectionPropertiesFUCHSIAError = error{
            OutOfHostMemory,
            InitializationFailed,
            Unknown,
        };
        pub fn getBufferCollectionPropertiesFUCHSIA(
            self: Self,
            device: Device,
            collection: BufferCollectionFUCHSIA,
            pProperties: *BufferCollectionPropertiesFUCHSIA,
        ) GetBufferCollectionPropertiesFUCHSIAError!void {
            const result = self.dispatch.vkGetBufferCollectionPropertiesFUCHSIA(
                device,
                collection,
                pProperties,
            );
            switch (result) {
                Result.success => {},
                Result.errorOutOfHostMemory => return error.OutOfHostMemory,
                Result.errorInitializationFailed => return error.InitializationFailed,
                else => return error.Unknown,
            }
        }
    };
}
