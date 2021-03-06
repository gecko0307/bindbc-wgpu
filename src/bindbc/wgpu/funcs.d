/*
Copyright (c) 2019-2021 Timur Gafarov.

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/
module bindbc.wgpu.funcs;

import core.stdc.stdint;
import bindbc.wgpu.types;

// this matches the test in wgpu sources guarding x11/wayland fns, which is:
// #[cfg(all(
//     unix,
//     not(target_os = "android"),
//     not(target_os = "ios"),
//     not(target_os = "macos")
// ))]
version(Posix)
{
    version (Android) private enum have_xorg = false;
    else version (OSX) private enum have_xorg = false;
    else version (iOS) private enum have_xorg = false;
    else private enum have_xorg = true;
} else private enum have_xorg = false;

version (OSX) private enum have_metal = true;
else version (iOS) private enum have_metal = true;
else private enum have_metal = false;

__gshared
{
    extern(C) @nogc nothrow:
    
    alias da_wgpuCreateInstance = WGPUInstance function(const(WGPUInstanceDescriptor)* descriptor);
    da_wgpuCreateInstance wgpuCreateInstance;
    
    alias da_wgpuGetProcAddress = WGPUProc function(WGPUDevice device, const(char)* procName);
    da_wgpuGetProcAddress wgpuGetProcAddress;
    
    // Methods of Adapter
    alias da_wgpuAdapterGetProperties = void function(WGPUAdapter adapter, WGPUAdapterProperties* properties);
    da_wgpuAdapterGetProperties wgpuAdapterGetProperties;
    
    alias da_wgpuAdapterRequestDevice = void function(WGPUAdapter adapter, const(WGPUDeviceDescriptor)* descriptor, WGPURequestDeviceCallback callback, void* userdata);
    da_wgpuAdapterRequestDevice wgpuAdapterRequestDevice;
    
    // Methods of Buffer
    alias da_wgpuBufferDestroy = void function(WGPUBuffer buffer);
    da_wgpuBufferDestroy wgpuBufferDestroy;
    
    alias da_wgpuBufferGetConstMappedRange = const(void)* function(WGPUBuffer buffer, size_t offset, size_t size);
    da_wgpuBufferGetConstMappedRange wgpuBufferGetConstMappedRange;
    
    alias da_wgpuBufferGetMappedRange = void* function(WGPUBuffer buffer, size_t offset, size_t size);
    da_wgpuBufferGetMappedRange wgpuBufferGetMappedRange;
    
    alias da_wgpuBufferMapAsync = void function(WGPUBuffer buffer, WGPUMapModeFlags mode, size_t offset, size_t size, WGPUBufferMapCallback callback, void* userdata);
    da_wgpuBufferMapAsync wgpuBufferMapAsync;
    
    alias da_wgpuBufferUnmap = void function(WGPUBuffer buffer);
    da_wgpuBufferUnmap wgpuBufferUnmap;
    
    // Methods of CommandEncoder
    alias da_wgpuCommandEncoderBeginComputePass = WGPUComputePassEncoder function(WGPUCommandEncoder commandEncoder, const(WGPUComputePassDescriptor)* descriptor);
    da_wgpuCommandEncoderBeginComputePass wgpuCommandEncoderBeginComputePass;
    
    alias da_wgpuCommandEncoderBeginRenderPass = WGPURenderPassEncoder function(WGPUCommandEncoder commandEncoder, const(WGPURenderPassDescriptor)* descriptor);
    da_wgpuCommandEncoderBeginRenderPass wgpuCommandEncoderBeginRenderPass;
    
    alias da_wgpuCommandEncoderCopyBufferToBuffer = void function(WGPUCommandEncoder commandEncoder, WGPUBuffer source, ulong sourceOffset, WGPUBuffer destination, ulong destinationOffset, ulong size);
    da_wgpuCommandEncoderCopyBufferToBuffer wgpuCommandEncoderCopyBufferToBuffer;
    
    alias da_wgpuCommandEncoderCopyBufferToTexture = void function(WGPUCommandEncoder commandEncoder, const(WGPUImageCopyBuffer)* source, const(WGPUImageCopyTexture)* destination, const(WGPUExtent3D)* copySize);
    da_wgpuCommandEncoderCopyBufferToTexture wgpuCommandEncoderCopyBufferToTexture;
    
    alias da_wgpuCommandEncoderCopyTextureToBuffer = void function(WGPUCommandEncoder commandEncoder, const(WGPUImageCopyTexture)* source, const(WGPUImageCopyBuffer)* destination, const(WGPUExtent3D)* copySize);
    da_wgpuCommandEncoderCopyTextureToBuffer wgpuCommandEncoderCopyTextureToBuffer;
    
    alias da_wgpuCommandEncoderCopyTextureToTexture = void function(WGPUCommandEncoder commandEncoder, const(WGPUImageCopyTexture)* source, const(WGPUImageCopyTexture)* destination, const(WGPUExtent3D)* copySize);
    da_wgpuCommandEncoderCopyTextureToTexture wgpuCommandEncoderCopyTextureToTexture;
    
    alias da_wgpuCommandEncoderFinish = WGPUCommandBuffer function(WGPUCommandEncoder commandEncoder, const(WGPUCommandBufferDescriptor)* descriptor);
    da_wgpuCommandEncoderFinish wgpuCommandEncoderFinish;
    
    alias da_wgpuCommandEncoderInsertDebugMarker = void function(WGPUCommandEncoder commandEncoder, const(char)* markerLabel);
    da_wgpuCommandEncoderInsertDebugMarker wgpuCommandEncoderInsertDebugMarker;
    
    alias da_wgpuCommandEncoderPopDebugGroup = void function(WGPUCommandEncoder commandEncoder);
    da_wgpuCommandEncoderPopDebugGroup wgpuCommandEncoderPopDebugGroup;
    
    alias da_wgpuCommandEncoderPushDebugGroup = void function(WGPUCommandEncoder commandEncoder, const(char)* groupLabel);
    da_wgpuCommandEncoderPushDebugGroup wgpuCommandEncoderPushDebugGroup;
    
    alias da_wgpuCommandEncoderResolveQuerySet = void function(WGPUCommandEncoder commandEncoder, WGPUQuerySet querySet, uint firstQuery, uint queryCount, WGPUBuffer destination, ulong destinationOffset);
    da_wgpuCommandEncoderResolveQuerySet wgpuCommandEncoderResolveQuerySet;
    
    alias da_wgpuCommandEncoderWriteTimestamp = void function(WGPUCommandEncoder commandEncoder, WGPUQuerySet querySet, uint queryIndex);
    da_wgpuCommandEncoderWriteTimestamp wgpuCommandEncoderWriteTimestamp;
    
    // Methods of ComputePassEncoder
    alias da_wgpuComputePassEncoderBeginPipelineStatisticsQuery = void function(WGPUComputePassEncoder computePassEncoder, WGPUQuerySet querySet, uint queryIndex);
    da_wgpuComputePassEncoderBeginPipelineStatisticsQuery wgpuComputePassEncoderBeginPipelineStatisticsQuery;
    
    alias da_wgpuComputePassEncoderDispatch = void function(WGPUComputePassEncoder computePassEncoder, uint x, uint y, uint z);
    da_wgpuComputePassEncoderDispatch wgpuComputePassEncoderDispatch;
    
    alias da_wgpuComputePassEncoderDispatchIndirect = void function(WGPUComputePassEncoder computePassEncoder, WGPUBuffer indirectBuffer, ulong indirectOffset);
    da_wgpuComputePassEncoderDispatchIndirect wgpuComputePassEncoderDispatchIndirect;
    
    alias da_wgpuComputePassEncoderEndPass = void function(WGPUComputePassEncoder computePassEncoder);
    da_wgpuComputePassEncoderEndPass wgpuComputePassEncoderEndPass;
    
    alias da_wgpuComputePassEncoderEndPipelineStatisticsQuery = void function(WGPUComputePassEncoder computePassEncoder);
    da_wgpuComputePassEncoderEndPipelineStatisticsQuery wgpuComputePassEncoderEndPipelineStatisticsQuery;
    
    alias da_wgpuComputePassEncoderInsertDebugMarker = void function(WGPUComputePassEncoder computePassEncoder, const(char)* markerLabel);
    da_wgpuComputePassEncoderInsertDebugMarker wgpuComputePassEncoderInsertDebugMarker;
    
    alias da_wgpuComputePassEncoderPopDebugGroup = void function(WGPUComputePassEncoder computePassEncoder);
    da_wgpuComputePassEncoderPopDebugGroup wgpuComputePassEncoderPopDebugGroup;
    
    alias da_wgpuComputePassEncoderPushDebugGroup = void function(WGPUComputePassEncoder computePassEncoder, const(char)* groupLabel);
    da_wgpuComputePassEncoderPushDebugGroup wgpuComputePassEncoderPushDebugGroup;
    
    alias da_wgpuComputePassEncoderSetBindGroup = void function(WGPUComputePassEncoder computePassEncoder, uint groupIndex, WGPUBindGroup group, uint dynamicOffsetCount, const(uint)* dynamicOffsets);
    da_wgpuComputePassEncoderSetBindGroup wgpuComputePassEncoderSetBindGroup;
    
    alias da_wgpuComputePassEncoderSetPipeline = void function(WGPUComputePassEncoder computePassEncoder, WGPUComputePipeline pipeline);
    da_wgpuComputePassEncoderSetPipeline wgpuComputePassEncoderSetPipeline;
    
    alias da_wgpuComputePassEncoderWriteTimestamp = void function(WGPUComputePassEncoder computePassEncoder, WGPUQuerySet querySet, uint queryIndex);
    da_wgpuComputePassEncoderWriteTimestamp wgpuComputePassEncoderWriteTimestamp;
    
    // Methods of ComputePipeline
    alias da_wgpuComputePipelineGetBindGroupLayout = WGPUBindGroupLayout function(WGPUComputePipeline computePipeline, uint groupIndex);
    da_wgpuComputePipelineGetBindGroupLayout wgpuComputePipelineGetBindGroupLayout;
    
    // Methods of Device
    alias da_wgpuDeviceCreateBindGroup = WGPUBindGroup function(WGPUDevice device, const(WGPUBindGroupDescriptor)* descriptor);
    da_wgpuDeviceCreateBindGroup wgpuDeviceCreateBindGroup;
    
    alias da_wgpuDeviceCreateBindGroupLayout = WGPUBindGroupLayout function(WGPUDevice device, const(WGPUBindGroupLayoutDescriptor)* descriptor);
    da_wgpuDeviceCreateBindGroupLayout wgpuDeviceCreateBindGroupLayout;
    
    alias da_wgpuDeviceCreateBuffer = WGPUBuffer function(WGPUDevice device, const(WGPUBufferDescriptor)* descriptor);
    da_wgpuDeviceCreateBuffer wgpuDeviceCreateBuffer;
    
    alias da_wgpuDeviceCreateCommandEncoder = WGPUCommandEncoder function(WGPUDevice device, const(WGPUCommandEncoderDescriptor)* descriptor);
    da_wgpuDeviceCreateCommandEncoder wgpuDeviceCreateCommandEncoder;
    
    alias da_wgpuDeviceCreateComputePipeline = WGPUComputePipeline function(WGPUDevice device, const(WGPUComputePipelineDescriptor)* descriptor);
    da_wgpuDeviceCreateComputePipeline wgpuDeviceCreateComputePipeline;
    
    alias da_wgpuDeviceCreateComputePipelineAsync = void function(WGPUDevice device, const(WGPUComputePipelineDescriptor)* descriptor, WGPUCreateComputePipelineAsyncCallback callback, void* userdata);
    da_wgpuDeviceCreateComputePipelineAsync wgpuDeviceCreateComputePipelineAsync;
    
    alias da_wgpuDeviceCreatePipelineLayout = WGPUPipelineLayout function(WGPUDevice device, const(WGPUPipelineLayoutDescriptor)* descriptor);
    da_wgpuDeviceCreatePipelineLayout wgpuDeviceCreatePipelineLayout;
    
    alias da_wgpuDeviceCreateQuerySet = WGPUQuerySet function(WGPUDevice device, const(WGPUQuerySetDescriptor)* descriptor);
    da_wgpuDeviceCreateQuerySet wgpuDeviceCreateQuerySet;
    
    alias da_wgpuDeviceCreateRenderBundleEncoder = WGPURenderBundleEncoder function(WGPUDevice device, const(WGPURenderBundleEncoderDescriptor)* descriptor);
    da_wgpuDeviceCreateRenderBundleEncoder wgpuDeviceCreateRenderBundleEncoder;
    
    alias da_wgpuDeviceCreateRenderPipeline = WGPURenderPipeline function(WGPUDevice device, const(WGPURenderPipelineDescriptor)* descriptor);
    da_wgpuDeviceCreateRenderPipeline wgpuDeviceCreateRenderPipeline;
    
    alias da_wgpuDeviceCreateRenderPipelineAsync = void function(WGPUDevice device, const(WGPURenderPipelineDescriptor)* descriptor, WGPUCreateRenderPipelineAsyncCallback callback, void* userdata);
    da_wgpuDeviceCreateRenderPipelineAsync wgpuDeviceCreateRenderPipelineAsync;
    
    alias da_wgpuDeviceCreateSampler = WGPUSampler function(WGPUDevice device, const(WGPUSamplerDescriptor)* descriptor);
    da_wgpuDeviceCreateSampler wgpuDeviceCreateSampler;
    
    alias da_wgpuDeviceCreateShaderModule = WGPUShaderModule function(WGPUDevice device, const(WGPUShaderModuleDescriptor)* descriptor);
    da_wgpuDeviceCreateShaderModule wgpuDeviceCreateShaderModule;
    
    alias da_wgpuDeviceCreateSwapChain = WGPUSwapChain function(WGPUDevice device, WGPUSurface surface, const(WGPUSwapChainDescriptor)* descriptor);
    da_wgpuDeviceCreateSwapChain wgpuDeviceCreateSwapChain;
    
    alias da_wgpuDeviceCreateTexture = WGPUTexture function(WGPUDevice device, const(WGPUTextureDescriptor)* descriptor);
    da_wgpuDeviceCreateTexture wgpuDeviceCreateTexture;
    
    alias da_wgpuDeviceGetQueue = WGPUQueue function(WGPUDevice device);
    da_wgpuDeviceGetQueue wgpuDeviceGetQueue;
    
    alias da_wgpuDevicePopErrorScope = bool function(WGPUDevice device, WGPUErrorCallback callback, void* userdata);
    da_wgpuDevicePopErrorScope wgpuDevicePopErrorScope;
    
    alias da_wgpuDevicePushErrorScope = void function(WGPUDevice device, WGPUErrorFilter filter);
    da_wgpuDevicePushErrorScope wgpuDevicePushErrorScope;
    
    alias da_wgpuDeviceSetDeviceLostCallback = void function(WGPUDevice device, WGPUDeviceLostCallback callback, void* userdata);
    da_wgpuDeviceSetDeviceLostCallback wgpuDeviceSetDeviceLostCallback;
    
    alias da_wgpuDeviceSetUncapturedErrorCallback = void function(WGPUDevice device, WGPUErrorCallback callback, void* userdata);
    da_wgpuDeviceSetUncapturedErrorCallback wgpuDeviceSetUncapturedErrorCallback;
    
    // Methods of Instance
    alias da_wgpuInstanceCreateSurface = WGPUSurface function(WGPUInstance instance, const(WGPUSurfaceDescriptor)* descriptor);
    da_wgpuInstanceCreateSurface wgpuInstanceCreateSurface;
    
    alias da_wgpuInstanceProcessEvents = void function(WGPUInstance instance);
    da_wgpuInstanceProcessEvents wgpuInstanceProcessEvents;
    
    alias da_wgpuInstanceRequestAdapter = void function(WGPUInstance instance, const(WGPURequestAdapterOptions)* options, WGPURequestAdapterCallback callback, void* userdata);
    da_wgpuInstanceRequestAdapter wgpuInstanceRequestAdapter;
    
    // Methods of QuerySet
    alias da_wgpuQuerySetDestroy = void function(WGPUQuerySet querySet);
    da_wgpuQuerySetDestroy wgpuQuerySetDestroy;
    
    // Methods of Queue
    alias da_wgpuQueueOnSubmittedWorkDone = void function(WGPUQueue queue, ulong signalValue, WGPUQueueWorkDoneCallback callback, void* userdata);
    da_wgpuQueueOnSubmittedWorkDone wgpuQueueOnSubmittedWorkDone;
    
    alias da_wgpuQueueSubmit = void function(WGPUQueue queue, uint commandCount, const(WGPUCommandBuffer)* commands);
    da_wgpuQueueSubmit wgpuQueueSubmit;
    
    alias da_wgpuQueueWriteBuffer = void function(WGPUQueue queue, WGPUBuffer buffer, ulong bufferOffset, const(void)* data, size_t size);
    da_wgpuQueueWriteBuffer wgpuQueueWriteBuffer;
    
    alias da_wgpuQueueWriteTexture = void function(WGPUQueue queue, const(WGPUImageCopyTexture)* destination, const(void)* data, size_t dataSize, const(WGPUTextureDataLayout)* dataLayout, const(WGPUExtent3D)* writeSize);
    da_wgpuQueueWriteTexture wgpuQueueWriteTexture;
    
    // Methods of RenderBundleEncoder
    alias da_wgpuRenderBundleEncoderDraw = void function(WGPURenderBundleEncoder renderBundleEncoder, uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance);
    da_wgpuRenderBundleEncoderDraw wgpuRenderBundleEncoderDraw;
    
    alias da_wgpuRenderBundleEncoderDrawIndexed = void function(WGPURenderBundleEncoder renderBundleEncoder, uint indexCount, uint instanceCount, uint firstIndex, int baseVertex, uint firstInstance);
    da_wgpuRenderBundleEncoderDrawIndexed wgpuRenderBundleEncoderDrawIndexed;
    
    alias da_wgpuRenderBundleEncoderDrawIndexedIndirect = void function(WGPURenderBundleEncoder renderBundleEncoder, WGPUBuffer indirectBuffer, ulong indirectOffset);
    da_wgpuRenderBundleEncoderDrawIndexedIndirect wgpuRenderBundleEncoderDrawIndexedIndirect;
    
    alias da_wgpuRenderBundleEncoderDrawIndirect = void function(WGPURenderBundleEncoder renderBundleEncoder, WGPUBuffer indirectBuffer, ulong indirectOffset);
    da_wgpuRenderBundleEncoderDrawIndirect wgpuRenderBundleEncoderDrawIndirect;
    
    alias da_wgpuRenderBundleEncoderFinish = WGPURenderBundle function(WGPURenderBundleEncoder renderBundleEncoder, const(WGPURenderBundleDescriptor)* descriptor);
    da_wgpuRenderBundleEncoderFinish wgpuRenderBundleEncoderFinish;
    
    alias da_wgpuRenderBundleEncoderInsertDebugMarker = void function(WGPURenderBundleEncoder renderBundleEncoder, const(char)* markerLabel);
    da_wgpuRenderBundleEncoderInsertDebugMarker wgpuRenderBundleEncoderInsertDebugMarker;
    
    alias da_wgpuRenderBundleEncoderPopDebugGroup = void function(WGPURenderBundleEncoder renderBundleEncoder);
    da_wgpuRenderBundleEncoderPopDebugGroup wgpuRenderBundleEncoderPopDebugGroup;
    
    alias da_wgpuRenderBundleEncoderPushDebugGroup = void function(WGPURenderBundleEncoder renderBundleEncoder, const(char)* groupLabel);
    da_wgpuRenderBundleEncoderPushDebugGroup wgpuRenderBundleEncoderPushDebugGroup;
    
    alias da_wgpuRenderBundleEncoderSetBindGroup = void function(WGPURenderBundleEncoder renderBundleEncoder, uint groupIndex, WGPUBindGroup group, uint dynamicOffsetCount, const(uint)* dynamicOffsets);
    da_wgpuRenderBundleEncoderSetBindGroup wgpuRenderBundleEncoderSetBindGroup;
    
    alias da_wgpuRenderBundleEncoderSetIndexBuffer = void function(WGPURenderBundleEncoder renderBundleEncoder, WGPUBuffer buffer, WGPUIndexFormat format, ulong offset, ulong size);
    da_wgpuRenderBundleEncoderSetIndexBuffer wgpuRenderBundleEncoderSetIndexBuffer;
    
    alias da_wgpuRenderBundleEncoderSetPipeline = void function(WGPURenderBundleEncoder renderBundleEncoder, WGPURenderPipeline pipeline);
    da_wgpuRenderBundleEncoderSetPipeline wgpuRenderBundleEncoderSetPipeline;
    
    alias da_wgpuRenderBundleEncoderSetVertexBuffer = void function(WGPURenderBundleEncoder renderBundleEncoder, uint slot, WGPUBuffer buffer, ulong offset, ulong size);
    da_wgpuRenderBundleEncoderSetVertexBuffer wgpuRenderBundleEncoderSetVertexBuffer;
    
    // Methods of RenderPassEncoder
    alias da_wgpuRenderPassEncoderBeginOcclusionQuery = void function(WGPURenderPassEncoder renderPassEncoder, uint queryIndex);
    da_wgpuRenderPassEncoderBeginOcclusionQuery wgpuRenderPassEncoderBeginOcclusionQuery;
    
    alias da_wgpuRenderPassEncoderBeginPipelineStatisticsQuery = void function(WGPURenderPassEncoder renderPassEncoder, WGPUQuerySet querySet, uint queryIndex);
    da_wgpuRenderPassEncoderBeginPipelineStatisticsQuery wgpuRenderPassEncoderBeginPipelineStatisticsQuery;
    
    alias da_wgpuRenderPassEncoderDraw = void function(WGPURenderPassEncoder renderPassEncoder, uint vertexCount, uint instanceCount, uint firstVertex, uint firstInstance);
    da_wgpuRenderPassEncoderDraw wgpuRenderPassEncoderDraw;
    
    alias da_wgpuRenderPassEncoderDrawIndexed = void function(WGPURenderPassEncoder renderPassEncoder, uint indexCount, uint instanceCount, uint firstIndex, int baseVertex, uint firstInstance);
    da_wgpuRenderPassEncoderDrawIndexed wgpuRenderPassEncoderDrawIndexed;
    
    alias da_wgpuRenderPassEncoderDrawIndexedIndirect = void function(WGPURenderPassEncoder renderPassEncoder, WGPUBuffer indirectBuffer, ulong indirectOffset);
    da_wgpuRenderPassEncoderDrawIndexedIndirect wgpuRenderPassEncoderDrawIndexedIndirect;
    
    alias da_wgpuRenderPassEncoderDrawIndirect = void function(WGPURenderPassEncoder renderPassEncoder, WGPUBuffer indirectBuffer, ulong indirectOffset);
    da_wgpuRenderPassEncoderDrawIndirect wgpuRenderPassEncoderDrawIndirect;
    
    alias da_wgpuRenderPassEncoderEndOcclusionQuery = void function(WGPURenderPassEncoder renderPassEncoder);
    da_wgpuRenderPassEncoderEndOcclusionQuery wgpuRenderPassEncoderEndOcclusionQuery;
    
    alias da_wgpuRenderPassEncoderEndPass = void function(WGPURenderPassEncoder renderPassEncoder);
    da_wgpuRenderPassEncoderEndPass wgpuRenderPassEncoderEndPass;
    
    alias da_wgpuRenderPassEncoderEndPipelineStatisticsQuery = void function(WGPURenderPassEncoder renderPassEncoder);
    da_wgpuRenderPassEncoderEndPipelineStatisticsQuery wgpuRenderPassEncoderEndPipelineStatisticsQuery;
    
    alias da_wgpuRenderPassEncoderExecuteBundles = void function(WGPURenderPassEncoder renderPassEncoder, uint bundlesCount, const(WGPURenderBundle)* bundles);
    da_wgpuRenderPassEncoderExecuteBundles wgpuRenderPassEncoderExecuteBundles;
    
    alias da_wgpuRenderPassEncoderInsertDebugMarker = void function(WGPURenderPassEncoder renderPassEncoder, const(char)* markerLabel);
    da_wgpuRenderPassEncoderInsertDebugMarker wgpuRenderPassEncoderInsertDebugMarker;
    
    alias da_wgpuRenderPassEncoderPopDebugGroup = void function(WGPURenderPassEncoder renderPassEncoder);
    da_wgpuRenderPassEncoderPopDebugGroup wgpuRenderPassEncoderPopDebugGroup;
    
    alias da_wgpuRenderPassEncoderPushDebugGroup = void function(WGPURenderPassEncoder renderPassEncoder, const(char)* groupLabel);
    da_wgpuRenderPassEncoderPushDebugGroup wgpuRenderPassEncoderPushDebugGroup;
    
    alias da_wgpuRenderPassEncoderSetBindGroup = void function(WGPURenderPassEncoder renderPassEncoder, uint groupIndex, WGPUBindGroup group, uint dynamicOffsetCount, const(uint)* dynamicOffsets);
    da_wgpuRenderPassEncoderSetBindGroup wgpuRenderPassEncoderSetBindGroup;
    
    alias da_wgpuRenderPassEncoderSetBlendColor = void function(WGPURenderPassEncoder renderPassEncoder, const(WGPUColor)* color);
    da_wgpuRenderPassEncoderSetBlendColor wgpuRenderPassEncoderSetBlendColor;
    
    alias da_wgpuRenderPassEncoderSetIndexBuffer = void function(WGPURenderPassEncoder renderPassEncoder, WGPUBuffer buffer, WGPUIndexFormat format, ulong offset, ulong size);
    da_wgpuRenderPassEncoderSetIndexBuffer wgpuRenderPassEncoderSetIndexBuffer;
    
    alias da_wgpuRenderPassEncoderSetPipeline = void function(WGPURenderPassEncoder renderPassEncoder, WGPURenderPipeline pipeline);
    da_wgpuRenderPassEncoderSetPipeline wgpuRenderPassEncoderSetPipeline;
    
    alias da_wgpuRenderPassEncoderSetScissorRect = void function(WGPURenderPassEncoder renderPassEncoder, uint x, uint y, uint width, uint height);
    da_wgpuRenderPassEncoderSetScissorRect wgpuRenderPassEncoderSetScissorRect;
    
    alias da_wgpuRenderPassEncoderSetStencilReference = void function(WGPURenderPassEncoder renderPassEncoder, uint reference);
    da_wgpuRenderPassEncoderSetStencilReference wgpuRenderPassEncoderSetStencilReference;
    
    alias da_wgpuRenderPassEncoderSetVertexBuffer = void function(WGPURenderPassEncoder renderPassEncoder, uint slot, WGPUBuffer buffer, ulong offset, ulong size);
    da_wgpuRenderPassEncoderSetVertexBuffer wgpuRenderPassEncoderSetVertexBuffer;
    
    alias da_wgpuRenderPassEncoderSetViewport = void function(WGPURenderPassEncoder renderPassEncoder, float x, float y, float width, float height, float minDepth, float maxDepth);
    da_wgpuRenderPassEncoderSetViewport wgpuRenderPassEncoderSetViewport;
    
    alias da_wgpuRenderPassEncoderWriteTimestamp = void function(WGPURenderPassEncoder renderPassEncoder, WGPUQuerySet querySet, uint queryIndex);
    da_wgpuRenderPassEncoderWriteTimestamp wgpuRenderPassEncoderWriteTimestamp;
    
    // Methods of RenderPipeline
    alias da_wgpuRenderPipelineGetBindGroupLayout = WGPUBindGroupLayout function(WGPURenderPipeline renderPipeline, uint groupIndex);
    da_wgpuRenderPipelineGetBindGroupLayout wgpuRenderPipelineGetBindGroupLayout;
    
    // Methods of Surface
    alias da_wgpuSurfaceGetPreferredFormat = void function(WGPUSurface surface, WGPUAdapter adapter, WGPUSurfaceGetPreferredFormatCallback callback, void* userdata);
    da_wgpuSurfaceGetPreferredFormat wgpuSurfaceGetPreferredFormat;
    
    // Methods of SwapChain
    alias da_wgpuSwapChainGetCurrentTextureView = WGPUTextureView function(WGPUSwapChain swapChain);
    da_wgpuSwapChainGetCurrentTextureView wgpuSwapChainGetCurrentTextureView;
    
    alias da_wgpuSwapChainPresent = void function(WGPUSwapChain swapChain);
    da_wgpuSwapChainPresent wgpuSwapChainPresent;
    
    // Methods of Texture
    alias da_wgpuTextureCreateView = WGPUTextureView function(WGPUTexture texture, const(WGPUTextureViewDescriptor)* descriptor);
    da_wgpuTextureCreateView wgpuTextureCreateView;
    
    alias da_wgpuTextureDestroy = void function(WGPUTexture texture);
    da_wgpuTextureDestroy wgpuTextureDestroy;
    
    //
    alias da_wgpuDevicePoll = void function(WGPUDevice device, bool force_wait);
    da_wgpuDevicePoll wgpuDevicePoll;
    
    alias da_wgpuSetLogCallback = void function(WGPULogCallback callback);
    da_wgpuSetLogCallback wgpuSetLogCallback;
    
    alias da_wgpuSetLogLevel = void function(WGPULogLevel level);
    da_wgpuSetLogLevel wgpuSetLogLevel;
    
    alias da_wgpuGetVersion = uint function();
    da_wgpuGetVersion wgpuGetVersion;
    
    alias da_wgpuRenderPassEncoderSetPushConstants = void function(WGPURenderPassEncoder encoder, WGPUShaderStage stages, uint offset, uint sizeBytes, const(void)* data);
    da_wgpuRenderPassEncoderSetPushConstants wgpuRenderPassEncoderSetPushConstants;
}
