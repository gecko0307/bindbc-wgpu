/*
Copyright (c) 2019-2022 Timur Gafarov.

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
module main;

import core.stdc.stdlib;
import std.stdio;
import std.conv;
import std.math;
import std.random;
import std.string;
import std.file: readText;

import bindbc.wgpu;
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

void quit(string message = "")
{
    if (message.length)
        writeln(message);
    core.stdc.stdlib.exit(1);
}

void main(string[] args)
{
    auto wgpuSupport = loadWGPU();
    writeln("wgpuSupport: ", wgpuSupport);
    
    auto sdlSupport = loadSDL();
    writeln("sdlSupport: ", sdlSupport);
    
    if (loader.errors.length)
    {
        writeln("Loader errors:");
        foreach(info; loader.errors)
        {
            writeln(to!string(info.error), ": ", to!string(info.message));
        }
    }
    
    version(OSX)
    {
        SDL_SetHint(SDL_HINT_RENDER_DRIVER, toStringz("metal"));
    }
    
    if (SDL_Init(SDL_INIT_EVERYTHING) == -1)
        quit("Error: failed to init SDL: " ~ to!string(SDL_GetError()));

    wgpuSetLogLevel(WGPULogLevel.Trace);
    wgpuSetLogCallback(&logCallback, null);

    WGPUInstanceDescriptor instanceDesc;
    WGPUInstance instance = wgpuCreateInstance(&instanceDesc);
    
    uint winWidth = 1280;
    uint winHeight = 720;
    SDL_Window* sdlWindow = SDL_CreateWindow(toStringz("WGPU"),
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
        winWidth, winHeight,
        SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
    
    SDL_SysWMinfo wmInfo;
    SDL_GetWindowWMInfo(sdlWindow, &wmInfo);
    writeln("Subsystem: ", wmInfo.subsystem);
    WGPUSurface surface = createSurface(instance, wmInfo);
    
    WGPUAdapter adapter;
    WGPURequestAdapterOptions adapterOpts = {
        nextInChain: null,
        compatibleSurface: surface
    };
    wgpuInstanceRequestAdapter(instance, &adapterOpts, &requestAdapterCallback, cast(void*)&adapter);
    writeln("Adapter OK");
    
    WGPUDevice device;
    WGPUDeviceExtras deviceExtras = {
        chain: {
            next: null,
            sType: cast(WGPUSType)WGPUNativeSType.DeviceExtras
        },
        // nativeFeatures: WGPUNativeFeature.TEXTURE_ADAPTER_SPECIFIC_FORMAT_FEATURES,
        // label: "Device",
        tracePath: null,
    };
    WGPURequiredLimits limits = {
        nextInChain: null,
        limits: {
            maxBindGroups: 1
        }
    };
    WGPUDeviceDescriptor deviceDesc = {
        nextInChain: cast(const(WGPUChainedStruct)*)&deviceExtras,
        requiredFeaturesCount: 0,
        requiredFeatures: null,
        requiredLimits: &limits
    };
    
    wgpuAdapterRequestDevice(adapter, &deviceDesc, &requestDeviceCallback, cast(void*)&device);
    writeln("Device OK");
    
    const(char)* shaderText = readText("data/shader.wgsl").toStringz;
    WGPUShaderModuleWGSLDescriptor wgslDescriptor = {
        chain: {
            next: null,
            sType: WGPUSType.ShaderModuleWGSLDescriptor
        },
        code: shaderText
    };
    WGPUShaderModuleDescriptor shaderSource = {
        nextInChain: cast(const(WGPUChainedStruct)*)&wgslDescriptor,
        label: toStringz("shader.wgsl")
    };
    WGPUShaderModule shaderModule = wgpuDeviceCreateShaderModule(device, &shaderSource);
    writeln("Shader OK");
    
    WGPUBindGroupLayoutDescriptor bglDesc = {
        label: "bind group layout",
        entries: null,
        entryCount: 0
    };
    WGPUBindGroupLayout bindGroupLayout = wgpuDeviceCreateBindGroupLayout(device, &bglDesc);
    WGPUBindGroupDescriptor bgDesc = {
        label: "bind group",
        layout: bindGroupLayout,
        entries: null,
        entryCount: 0
    };
    WGPUBindGroup bindGroup = wgpuDeviceCreateBindGroup(device, &bgDesc);
    WGPUBindGroupLayout[1] bindGroupLayouts = [ bindGroupLayout ];
    writeln("Bind group OK");
    
    WGPUPipelineLayoutDescriptor plDesc = {
        bindGroupLayouts: bindGroupLayouts.ptr,
        bindGroupLayoutCount: bindGroupLayouts.length
    };
    WGPUPipelineLayout pipelineLayout = wgpuDeviceCreatePipelineLayout(device, &plDesc);
    writeln("Pipeline layout OK");
    
    WGPUTextureFormat swapChainFormat = wgpuSurfaceGetPreferredFormat(surface, adapter);
    writeln(swapChainFormat);
    
    WGPUBlendState blend = {
        color: {
            srcFactor: WGPUBlendFactor.One,
            dstFactor: WGPUBlendFactor.Zero,
            operation: WGPUBlendOperation.Add
        },
        alpha: {
            srcFactor: WGPUBlendFactor.One,
            dstFactor: WGPUBlendFactor.Zero,
            operation: WGPUBlendOperation.Add
        }
    };
    WGPUColorTargetState cts = {
        format: swapChainFormat,
        blend: &blend,
        writeMask: WGPUColorWriteMask.All
    };
    WGPUFragmentState fs = {
        module_: shaderModule,
        entryPoint: "fs_main",
        targetCount: 1,
        targets: &cts
    };
    WGPURenderPipelineDescriptor rpDesc = {
        label: "Render pipeline",
        layout: pipelineLayout,
        vertex: {
            module_: shaderModule,
            entryPoint: "vs_main",
            bufferCount: 0,
            buffers: null
        },
        primitive: {
            topology: WGPUPrimitiveTopology.TriangleList,
            stripIndexFormat: WGPUIndexFormat.Undefined,
            frontFace: WGPUFrontFace.CCW,
            cullMode: WGPUCullMode.None
        },
        multisample: {
            count: 1, 
            mask: ~0,
            alphaToCoverageEnabled: false
        },
        fragment: &fs,
        depthStencil: null
    };
    WGPURenderPipeline pipeline = wgpuDeviceCreateRenderPipeline(device, &rpDesc);
    writeln("Render pipeline OK");
    
    WGPUSwapChain createSwapChain(uint w, uint h) {
        WGPUSwapChainDescriptor swcDesc = {
            usage: WGPUTextureUsage.RenderAttachment,
            format: swapChainFormat,
            width: w,
            height: h,
            presentMode: WGPUPresentMode.Fifo
        };
        return wgpuDeviceCreateSwapChain(device, surface, &swcDesc);
    }

    WGPUSwapChain swapChain = createSwapChain(winWidth, winHeight);
    
    bool running = true;
    while(running)
    {
        SDL_Event event;
        while(SDL_PollEvent(&event))
        {
            switch (event.type)
            {
                case SDL_WINDOWEVENT:
                    if (event.window.event == SDL_WINDOWEVENT_SIZE_CHANGED)
                    {
                        winWidth = event.window.data1;
                        winHeight = event.window.data2;
                        writeln(winWidth, "x", winHeight);
                        swapChain = createSwapChain(winWidth, winHeight);
                    }
                    break;
                case SDL_KEYUP:
                    const key = event.key.keysym.scancode;
                    if (key == 41) // Esc
                    {
                        running = false;
                    }
                    break;
                case SDL_QUIT:
                    running = false;
                    break;
                default:
                    break;
            }
        }
        
        // wgpu crashes when rendering to minimized window
        auto winFlags = SDL_GetWindowFlags(sdlWindow);
        auto isMinimized = winFlags & SDL_WINDOW_MINIMIZED;
        if (isMinimized)
            continue;
        
        WGPUTextureView nextTextureView = wgpuSwapChainGetCurrentTextureView(swapChain);
        if (!nextTextureView)
            continue;
        
        WGPUCommandEncoderDescriptor ceDesc = {
            label: "Command Encoder"
        };
        WGPUCommandEncoder encoder = wgpuDeviceCreateCommandEncoder(device, &ceDesc);
        
        WGPURenderPassColorAttachment colorAttachment = {
            view: nextTextureView,
            resolveTarget: null,
            loadOp: WGPULoadOp.Clear,
            storeOp: WGPUStoreOp.Store,
            clearValue: WGPUColor(0.5, 0.5, 0.5, 1.0)
        };
        WGPURenderPassDescriptor passDesc = {
            colorAttachments: &colorAttachment,
            colorAttachmentCount: 1,
            depthStencilAttachment: null
        };
        WGPURenderPassEncoder renderPass = wgpuCommandEncoderBeginRenderPass(encoder, &passDesc);
        
        wgpuRenderPassEncoderSetPipeline(renderPass, pipeline);
        wgpuRenderPassEncoderSetBindGroup(renderPass, 0, bindGroup, 0, null);
        wgpuRenderPassEncoderDraw(renderPass, 3, 1, 0, 0);
        wgpuRenderPassEncoderEnd(renderPass);
        
        WGPUQueue queue = wgpuDeviceGetQueue(device);
        WGPUCommandBufferDescriptor cmdbufDesc = { label: null };
        WGPUCommandBuffer cmdBuffer = wgpuCommandEncoderFinish(encoder, &cmdbufDesc);
        wgpuQueueSubmit(queue, 1, &cmdBuffer);
        wgpuSwapChainPresent(swapChain);
    }
    
    SDL_Quit();
}

WGPUSurface createSurface(WGPUInstance instance, SDL_SysWMinfo wmInfo)
{
    WGPUSurface surface;
    version(Windows)
    {
        if (wmInfo.subsystem == SDL_SYSWM_WINDOWS)
        {
            auto win_hwnd = wmInfo.info.win.window;
            auto win_hinstance = wmInfo.info.win.hinstance;
            WGPUSurfaceDescriptorFromWindowsHWND sfdHwnd = {
                chain: {
                    next: null,
                    sType: WGPUSType.SurfaceDescriptorFromWindowsHWND
                },
                hinstance: win_hinstance,
                hwnd: win_hwnd
            };
            WGPUSurfaceDescriptor sfd = {
                label: null,
                nextInChain: cast(const(WGPUChainedStruct)*)&sfdHwnd
            };
            surface = wgpuInstanceCreateSurface(instance, &sfd);
        }
        else
        {
            quit("Unsupported subsystem, sorry");
        }
    }
    else version(linux)
    {
        // Needs test!
        // System might use XCB so SDL_SysWMinfo will contain subsystem SDL_SYSWM_UNKNOWN. Although, X11 still can be used to craete surface
        if (wmInfo.subsystem == SDL_SYSWM_WAYLAND)
        {
            // TODO: support Wayland
            quit("Unsupported subsystem, sorry");
        }
        else if (true)//wmInfo.subsystem == SDL_SYSWM_X11)
        {
            auto x11_display = wmInfo.info.x11.display;
            auto x11_window = wmInfo.info.x11.window;
            WGPUSurfaceDescriptorFromXlibWindow sfdX11 = {
                chain: {
                    next: null,
                    sType: WGPUSType.SurfaceDescriptorFromXlibWindow
                },
                display: x11_display,
                window: x11_window
            };
            WGPUSurfaceDescriptor sfd = {
                label: null,
                nextInChain: cast(const(WGPUChainedStruct)*)&sfdX11
            };
            surface = wgpuInstanceCreateSurface(instance, &sfd);
        }
        else
        {
            quit("Unsupported subsystem, sorry");
        }
    }
    else version(OSX)
    {
        // Needs test!
        SDL_Renderer* renderer = SDL_CreateRenderer(window.sdlWindow, -1, SDL_RENDERER_PRESENTVSYNC);
        auto metalLayer = SDL_RenderGetMetalLayer(renderer);
        
        WGPUSurfaceDescriptorFromMetalLayer sfdMetal = {
            chain: {
                next: null,
                sType: WGPUSType.SurfaceDescriptorFromMetalLayer
            },
            layer: metalLayer
        };
        WGPUSurfaceDescriptor sfd = {
            label: null,
            nextInChain: cast(const(WGPUChainedStruct)*)&sfdMetal
        };
        surface = wgpuInstanceCreateSurface(instance, &sfd);
        
        SDL_DestroyRenderer(renderer);
    }
    return surface;
}

extern(C)
{
    void logCallback(WGPULogLevel level, const(char)* msg, void* user_data)
    {
        const (char)[] level_message;
        switch(level)
        {
            case WGPULogLevel.Off:level_message = "off";break;
            case WGPULogLevel.Error:level_message = "error";break;
            case WGPULogLevel.Warn:level_message = "warn";break;
            case WGPULogLevel.Info:level_message = "info";break;
            case WGPULogLevel.Debug:level_message = "debug";break;
            case WGPULogLevel.Trace:level_message = "trace";break;
            default: level_message = "-";
        }
        writeln("WebGPU ", level_message, ": ",  to!string(msg));
    }

    void requestAdapterCallback(WGPURequestAdapterStatus status, WGPUAdapter adapter, const(char)* message, void* userdata)
    {
        if (status == WGPURequestAdapterStatus.Success)
            *cast(WGPUAdapter*)userdata = adapter;
        else
        {
            writeln(status);
            writeln(to!string(message));
        }
    }

    void requestDeviceCallback(WGPURequestDeviceStatus status, WGPUDevice device, const(char)* message, void* userdata)
    {
        if (status == WGPURequestDeviceStatus.Success)
            *cast(WGPUDevice*)userdata = device;
        else
        {
            writeln(status);
            writeln(to!string(message));
        }
    }
}
