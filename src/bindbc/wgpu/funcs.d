/*
Copyright (c) 2019-2024 Timur Gafarov.

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
import bindbc.wgpu.types2;

/*
 * Function definitions from webgpu.h
 */

__gshared
{
    WGPUProcCreateInstance wgpuCreateInstance;
    WGPUProcGetProcAddress wgpuGetProcAddress;
    
    // Methods of Adapter
    WGPUProcAdapterEnumerateFeatures wgpuAdapterEnumerateFeatures;
    WGPUProcAdapterGetLimits wgpuAdapterGetLimits;
    WGPUProcAdapterGetInfo wgpuAdapterGetInfo;
    WGPUProcAdapterHasFeature wgpuAdapterHasFeature;
    WGPUProcAdapterRequestDevice wgpuAdapterRequestDevice;
    WGPUProcAdapterReference wgpuAdapterReference;
    WGPUProcAdapterRelease wgpuAdapterRelease;
    
    // Procs of AdapterInfo
    WGPUProcAdapterInfoFreeMembers wgpuAdapterInfoFreeMembers;

    // Methods of BindGroup
    WGPUProcBindGroupSetLabel wgpuBindGroupSetLabel;
    WGPUProcBindGroupReference wgpuBindGroupReference;
    WGPUProcBindGroupRelease wgpuBindGroupRelease;
    
    // Methods of BindGroupLayout
    WGPUProcBindGroupLayoutSetLabel wgpuBindGroupLayoutSetLabel;
    WGPUProcBindGroupLayoutReference wgpuBindGroupLayoutReference;
    WGPUProcBindGroupLayoutRelease wgpuBindGroupLayoutRelease;
    
    // Methods of Buffer
    WGPUProcBufferDestroy wgpuBufferDestroy;
    WGPUProcBufferGetConstMappedRange wgpuBufferGetConstMappedRange;
    WGPUProcBufferGetMapState wgpuBufferGetMapState;
    WGPUProcBufferGetMappedRange wgpuBufferGetMappedRange;
    WGPUProcBufferGetSize wgpuBufferGetSize;
    WGPUProcBufferGetUsage wgpuBufferGetUsage;
    WGPUProcBufferMapAsync wgpuBufferMapAsync;
    WGPUProcBufferSetLabel wgpuBufferSetLabel;
    WGPUProcBufferUnmap wgpuBufferUnmap;
    WGPUProcBufferReference wgpuBufferReference;
    WGPUProcBufferRelease wgpuBufferRelease;
    
    // Methods of CommandBuffer
    WGPUProcCommandBufferSetLabel wgpuCommandBufferSetLabel;
    WGPUProcCommandBufferReference wgpuCommandBufferReference;
    WGPUProcCommandBufferRelease wgpuCommandBufferRelease;

    // Methods of CommandEncoder
    WGPUProcCommandEncoderBeginComputePass wgpuCommandEncoderBeginComputePass;
    WGPUProcCommandEncoderBeginRenderPass wgpuCommandEncoderBeginRenderPass;
    WGPUProcCommandEncoderClearBuffer wgpuCommandEncoderClearBuffer;
    WGPUProcCommandEncoderCopyBufferToBuffer wgpuCommandEncoderCopyBufferToBuffer;
    WGPUProcCommandEncoderCopyBufferToTexture wgpuCommandEncoderCopyBufferToTexture;
    WGPUProcCommandEncoderCopyTextureToBuffer wgpuCommandEncoderCopyTextureToBuffer;
    WGPUProcCommandEncoderCopyTextureToTexture wgpuCommandEncoderCopyTextureToTexture;
    WGPUProcCommandEncoderFinish wgpuCommandEncoderFinish;
    WGPUProcCommandEncoderInsertDebugMarker wgpuCommandEncoderInsertDebugMarker;
    WGPUProcCommandEncoderPopDebugGroup wgpuCommandEncoderPopDebugGroup;
    WGPUProcCommandEncoderPushDebugGroup wgpuCommandEncoderPushDebugGroup;
    WGPUProcCommandEncoderResolveQuerySet wgpuCommandEncoderResolveQuerySet;
    WGPUProcCommandEncoderSetLabel wgpuCommandEncoderSetLabel;
    WGPUProcCommandEncoderWriteTimestamp wgpuCommandEncoderWriteTimestamp;
    WGPUProcCommandEncoderReference wgpuCommandEncoderReference;
    WGPUProcCommandEncoderRelease wgpuCommandEncoderRelease;
    
    // Methods of ComputePassEncoder
    WGPUProcComputePassEncoderDispatchWorkgroups wgpuComputePassEncoderDispatchWorkgroups;
    WGPUProcComputePassEncoderDispatchWorkgroupsIndirect wgpuComputePassEncoderDispatchWorkgroupsIndirect;
    WGPUProcComputePassEncoderEnd wgpuComputePassEncoderEnd;
    WGPUProcComputePassEncoderInsertDebugMarker wgpuComputePassEncoderInsertDebugMarker;
    WGPUProcComputePassEncoderPopDebugGroup wgpuComputePassEncoderPopDebugGroup;
    WGPUProcComputePassEncoderPushDebugGroup wgpuComputePassEncoderPushDebugGroup;
    WGPUProcComputePassEncoderSetBindGroup wgpuComputePassEncoderSetBindGroup;
    WGPUProcComputePassEncoderSetLabel wgpuComputePassEncoderSetLabel;
    WGPUProcComputePassEncoderSetPipeline wgpuComputePassEncoderSetPipeline;
    WGPUProcComputePassEncoderReference wgpuComputePassEncoderReference;
    WGPUProcComputePassEncoderRelease wgpuComputePassEncoderRelease;
    
    // Methods of ComputePipeline
    WGPUProcComputePipelineGetBindGroupLayout wgpuComputePipelineGetBindGroupLayout;
    WGPUProcComputePipelineSetLabel wgpuComputePipelineSetLabel;
    WGPUProcComputePipelineReference wgpuComputePipelineReference;
    WGPUProcComputePipelineRelease wgpuComputePipelineRelease;
    
    // Methods of Device
    WGPUProcDeviceCreateBindGroup wgpuDeviceCreateBindGroup;
    WGPUProcDeviceCreateBindGroupLayout wgpuDeviceCreateBindGroupLayout;
    WGPUProcDeviceCreateBuffer wgpuDeviceCreateBuffer;
    WGPUProcDeviceCreateCommandEncoder wgpuDeviceCreateCommandEncoder;
    WGPUProcDeviceCreateComputePipeline wgpuDeviceCreateComputePipeline;
    WGPUProcDeviceCreateComputePipelineAsync wgpuDeviceCreateComputePipelineAsync;
    WGPUProcDeviceCreatePipelineLayout wgpuDeviceCreatePipelineLayout;
    WGPUProcDeviceCreateQuerySet wgpuDeviceCreateQuerySet;
    WGPUProcDeviceCreateRenderBundleEncoder wgpuDeviceCreateRenderBundleEncoder;
    WGPUProcDeviceCreateRenderPipeline wgpuDeviceCreateRenderPipeline;
    WGPUProcDeviceCreateRenderPipelineAsync wgpuDeviceCreateRenderPipelineAsync;
    WGPUProcDeviceCreateSampler wgpuDeviceCreateSampler;
    WGPUProcDeviceCreateShaderModule wgpuDeviceCreateShaderModule;
    WGPUProcDeviceCreateTexture wgpuDeviceCreateTexture;
    WGPUProcDeviceDestroy wgpuDeviceDestroy;
    WGPUProcDeviceEnumerateFeatures wgpuDeviceEnumerateFeatures;
    WGPUProcDeviceGetLimits wgpuDeviceGetLimits;
    WGPUProcDeviceGetQueue wgpuDeviceGetQueue;
    WGPUProcDeviceHasFeature wgpuDeviceHasFeature;
    WGPUProcDevicePopErrorScope wgpuDevicePopErrorScope;
    WGPUProcDevicePushErrorScope wgpuDevicePushErrorScope;
    //WGPUProcDeviceSetDeviceLostCallback wgpuDeviceSetDeviceLostCallback;
    WGPUProcDeviceSetLabel wgpuDeviceSetLabel;
    WGPUProcDeviceReference wgpuDeviceReference;
    WGPUProcDeviceRelease wgpuDeviceRelease;
    
    // Methods of Instance
    WGPUProcInstanceCreateSurface wgpuInstanceCreateSurface;
    WGPUProcInstanceHasWGSLLanguageFeature wgpuInstanceHasWGSLLanguageFeature;
    WGPUProcInstanceProcessEvents wgpuInstanceProcessEvents;
    WGPUProcInstanceRequestAdapter wgpuInstanceRequestAdapter;
    WGPUProcInstanceReference wgpuInstanceReference;
    WGPUProcInstanceRelease wgpuInstanceRelease;
    
    // Methods of PipelineLayout
    WGPUProcPipelineLayoutSetLabel wgpuPipelineLayoutSetLabel;
    WGPUProcPipelineLayoutReference wgpuPipelineLayoutReference;
    WGPUProcPipelineLayoutRelease wgpuPipelineLayoutRelease;
    
    // Methods of QuerySet
    WGPUProcQuerySetDestroy wgpuQuerySetDestroy;
    WGPUProcQuerySetGetCount wgpuQuerySetGetCount;
    WGPUProcQuerySetGetType wgpuQuerySetGetType;
    WGPUProcQuerySetSetLabel wgpuQuerySetSetLabel;
    WGPUProcQuerySetReference wgpuQuerySetReference;
    WGPUProcQuerySetRelease wgpuQuerySetRelease;
    
    // Methods of Queue
    WGPUProcQueueOnSubmittedWorkDone wgpuQueueOnSubmittedWorkDone;
    WGPUProcQueueSetLabel wgpuQueueSetLabel;
    WGPUProcQueueSubmit wgpuQueueSubmit;
    WGPUProcQueueWriteBuffer wgpuQueueWriteBuffer;
    WGPUProcQueueWriteTexture wgpuQueueWriteTexture;
    WGPUProcQueueReference wgpuQueueReference;
    WGPUProcQueueRelease wgpuQueueRelease;
    
    // Methods of RenderBundleEncoder
    WGPUProcRenderBundleSetLabel wgpuRenderBundleSetLabel;
    WGPUProcRenderBundleReference wgpuRenderBundleReference;
    WGPUProcRenderBundleRelease wgpuRenderBundleRelease;
    
    // Methods of RenderBundleEncoder
    WGPUProcRenderBundleEncoderDraw wgpuRenderBundleEncoderDraw;
    WGPUProcRenderBundleEncoderDrawIndexed wgpuRenderBundleEncoderDrawIndexed;
    WGPUProcRenderBundleEncoderDrawIndexedIndirect wgpuRenderBundleEncoderDrawIndexedIndirect;
    WGPUProcRenderBundleEncoderDrawIndirect wgpuRenderBundleEncoderDrawIndirect;
    WGPUProcRenderBundleEncoderFinish wgpuRenderBundleEncoderFinish;
    WGPUProcRenderBundleEncoderInsertDebugMarker wgpuRenderBundleEncoderInsertDebugMarker;
    WGPUProcRenderBundleEncoderPopDebugGroup wgpuRenderBundleEncoderPopDebugGroup;
    WGPUProcRenderBundleEncoderPushDebugGroup wgpuRenderBundleEncoderPushDebugGroup;
    WGPUProcRenderBundleEncoderSetBindGroup wgpuRenderBundleEncoderSetBindGroup;
    WGPUProcRenderBundleEncoderSetIndexBuffer wgpuRenderBundleEncoderSetIndexBuffer;
    WGPUProcRenderBundleEncoderSetLabel wgpuRenderBundleEncoderSetLabel;
    WGPUProcRenderBundleEncoderSetPipeline wgpuRenderBundleEncoderSetPipeline;
    WGPUProcRenderBundleEncoderSetVertexBuffer wgpuRenderBundleEncoderSetVertexBuffer;
    WGPUProcRenderBundleEncoderReference wgpuRenderBundleEncoderReference;
    WGPUProcRenderBundleEncoderRelease wgpuRenderBundleEncoderRelease;

    // Methods of RenderPassEncoder
    WGPUProcRenderPassEncoderBeginOcclusionQuery wgpuRenderPassEncoderBeginOcclusionQuery;
    WGPUProcRenderPassEncoderDraw wgpuRenderPassEncoderDraw;
    WGPUProcRenderPassEncoderDrawIndexed wgpuRenderPassEncoderDrawIndexed;
    WGPUProcRenderPassEncoderDrawIndexedIndirect wgpuRenderPassEncoderDrawIndexedIndirect;
    WGPUProcRenderPassEncoderDrawIndirect wgpuRenderPassEncoderDrawIndirect;
    WGPUProcRenderPassEncoderEnd wgpuRenderPassEncoderEnd;
    WGPUProcRenderPassEncoderEndOcclusionQuery wgpuRenderPassEncoderEndOcclusionQuery;
    WGPUProcRenderPassEncoderExecuteBundles wgpuRenderPassEncoderExecuteBundles;
    WGPUProcRenderPassEncoderInsertDebugMarker wgpuRenderPassEncoderInsertDebugMarker;
    WGPUProcRenderPassEncoderPopDebugGroup wgpuRenderPassEncoderPopDebugGroup;
    WGPUProcRenderPassEncoderPushDebugGroup wgpuRenderPassEncoderPushDebugGroup;
    WGPUProcRenderPassEncoderSetBindGroup wgpuRenderPassEncoderSetBindGroup;
    WGPUProcRenderPassEncoderSetBlendConstant wgpuRenderPassEncoderSetBlendConstant;
    WGPUProcRenderPassEncoderSetIndexBuffer wgpuRenderPassEncoderSetIndexBuffer;
    WGPUProcRenderPassEncoderSetLabel wgpuRenderPassEncoderSetLabel;
    WGPUProcRenderPassEncoderSetPipeline wgpuRenderPassEncoderSetPipeline;
    WGPUProcRenderPassEncoderSetScissorRect wgpuRenderPassEncoderSetScissorRect;
    WGPUProcRenderPassEncoderSetStencilReference wgpuRenderPassEncoderSetStencilReference;
    WGPUProcRenderPassEncoderSetVertexBuffer wgpuRenderPassEncoderSetVertexBuffer;
    WGPUProcRenderPassEncoderSetViewport wgpuRenderPassEncoderSetViewport;
    WGPUProcRenderPassEncoderReference wgpuRenderPassEncoderReference;
    WGPUProcRenderPassEncoderRelease wgpuRenderPassEncoderRelease;

    // Methods of RenderPipeline
    WGPUProcRenderPipelineGetBindGroupLayout wgpuRenderPipelineGetBindGroupLayout;
    WGPUProcRenderPipelineSetLabel wgpuRenderPipelineSetLabel;
    WGPUProcRenderPipelineReference wgpuRenderPipelineReference;
    WGPUProcRenderPipelineRelease wgpuRenderPipelineRelease;

    // Methods of Sampler
    WGPUProcSamplerSetLabel wgpuSamplerSetLabel;
    WGPUProcSamplerReference wgpuSamplerReference;
    WGPUProcSamplerRelease wgpuSamplerRelease;

    // Methods of ShaderModule
    WGPUProcShaderModuleGetCompilationInfo wgpuShaderModuleGetCompilationInfo;
    WGPUProcShaderModuleSetLabel wgpuShaderModuleSetLabel;
    WGPUProcShaderModuleReference wgpuShaderModuleReference;
    WGPUProcShaderModuleRelease wgpuShaderModuleRelease;

    // Methods of Surface
    WGPUProcSurfaceConfigure wgpuSurfaceConfigure;
    WGPUProcSurfaceGetCapabilities wgpuSurfaceGetCapabilities;
    WGPUProcSurfaceGetCurrentTexture wgpuSurfaceGetCurrentTexture;
    WGPUProcSurfacePresent wgpuSurfacePresent;
    WGPUProcSurfaceSetLabel wgpuSurfaceSetLabel;
    WGPUProcSurfaceUnconfigure wgpuSurfaceUnconfigure;
    WGPUProcSurfaceReference wgpuSurfaceReference;
    WGPUProcSurfaceRelease wgpuSurfaceRelease;

    // Methods of SurfaceCapabilities
    WGPUProcSurfaceCapabilitiesFreeMembers wgpuSurfaceCapabilitiesFreeMembers;

    // Methods of Texture
    WGPUProcTextureCreateView wgpuTextureCreateView;
    WGPUProcTextureDestroy wgpuTextureDestroy;
    WGPUProcTextureGetDepthOrArrayLayers wgpuTextureGetDepthOrArrayLayers;
    WGPUProcTextureGetDimension wgpuTextureGetDimension;
    WGPUProcTextureGetFormat wgpuTextureGetFormat;
    WGPUProcTextureGetHeight wgpuTextureGetHeight;
    WGPUProcTextureGetMipLevelCount wgpuTextureGetMipLevelCount;
    WGPUProcTextureGetSampleCount wgpuTextureGetSampleCount;
    WGPUProcTextureGetUsage wgpuTextureGetUsage;
    WGPUProcTextureGetWidth wgpuTextureGetWidth;
    WGPUProcTextureSetLabel wgpuTextureSetLabel;
    WGPUProcTextureReference wgpuTextureReference;
    WGPUProcTextureRelease wgpuTextureRelease;

    // Methods of TextureView
    WGPUProcTextureViewSetLabel wgpuTextureViewSetLabel;
    WGPUProcTextureViewReference wgpuTextureViewReference;
    WGPUProcTextureViewRelease wgpuTextureViewRelease;

    //
    WGPUProcGenerateReport wgpuGenerateReport;
    WGPUProcInstanceEnumerateAdapters wgpuInstanceEnumerateAdapters;
    WGPUProcQueueSubmitForIndex wgpuQueueSubmitForIndex;
    WGPUProcDevicePoll wgpuDevicePoll;
    WGPUProcSetLogCallback wgpuSetLogCallback;
    WGPUProcSetLogLevel wgpuSetLogLevel;
    WGPUProcGetVersion wgpuGetVersion;
    WGPUProcRenderPassEncoderSetPushConstants wgpuRenderPassEncoderSetPushConstants;
    WGPUProcRenderPassEncoderMultiDrawIndirect wgpuRenderPassEncoderMultiDrawIndirect;
    WGPUProcRenderPassEncoderMultiDrawIndexedIndirect wgpuRenderPassEncoderMultiDrawIndexedIndirect;
    WGPUProcRenderPassEncoderMultiDrawIndirectCount wgpuRenderPassEncoderMultiDrawIndirectCount;
    WGPUProcRenderPassEncoderMultiDrawIndexedIndirectCount wgpuRenderPassEncoderMultiDrawIndexedIndirectCount;
    WGPUProcComputePassEncoderBeginPipelineStatisticsQuery wgpuComputePassEncoderBeginPipelineStatisticsQuery;
    WGPUProcComputePassEncoderEndPipelineStatisticsQuery wgpuComputePassEncoderEndPipelineStatisticsQuery;
    WGPUProcRenderPassEncoderBeginPipelineStatisticsQuery wgpuRenderPassEncoderBeginPipelineStatisticsQuery;
    WGPUProcRenderPassEncoderEndPipelineStatisticsQuery wgpuRenderPassEncoderEndPipelineStatisticsQuery;
}
