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
    
    uint winWidth = 1280;
    uint winHeight = 720;
    SDL_Window* sdlWindow = SDL_CreateWindow(toStringz("WGPU"),
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
        winWidth, winHeight,
        SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);
    
    wgpuSetLogLevel(WGPULogLevel.Debug);
    
    SDL_SysWMinfo wmInfo;
    SDL_GetWindowWMInfo(sdlWindow, &wmInfo);
    writeln("Subsystem: ", wmInfo.subsystem);
    WGPUSurface surface = createSurface(wmInfo);
    
    WGPUAdapter adapter;
    WGPURequestAdapterOptions adapterOpts = {
        nextInChain: null,
        compatibleSurface: surface
    };
    wgpuInstanceRequestAdapter(null, &adapterOpts, &requestAdapterCallback, cast(void*)&adapter);
    writeln("Adapter OK");
    
    WGPUDevice device;
    WGPUDeviceExtras deviceExtras = {
        chain: {
            next: null,
            sType: cast(WGPUSType)WGPUNativeSType.DeviceExtras
        },
        maxBindGroups: 1,
        label: "Device",
        tracePath: null,
    };
    WGPUDeviceDescriptor deviceDesc = {
        nextInChain: cast(const(WGPUChainedStruct)*)&deviceExtras,
    };
    wgpuAdapterRequestDevice(adapter, &deviceDesc, &requestDeviceCallback, cast(void*)&device);
    writeln("Device OK");
    
    const(char)* shaderText = readText("data/shader.wgsl").toStringz;
    WGPUShaderModuleWGSLDescriptor wgslDescriptor = {
        chain: {
            next: null,
            sType: WGPUSType.ShaderModuleWGSLDescriptor
        },
        source: shaderText
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
        format: WGPUTextureFormat.BGRA8Unorm,
        blend: &blend,
        writeMask: WGPUColorWriteMask.All
    };
    WGPUFragmentState fs = {
        modul: shaderModule,
        entryPoint: "fs_main",
        targetCount: 1,
        targets: &cts
    };
    WGPURenderPipelineDescriptor rpDesc = {
        label: "Render pipeline",
        layout: pipelineLayout,
        vertex: {
            modul: shaderModule,
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
            format: WGPUTextureFormat.BGRA8Unorm,
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
        
        WGPUTextureView nextTexture = wgpuSwapChainGetCurrentTextureView(swapChain);
        if (!nextTexture)
        {
            writeln("Cannot acquire next swap chain texture");
            break;
        }
        
        WGPUCommandEncoderDescriptor ceDesc = {
            label: "Command Encoder"
        };
        WGPUCommandEncoder encoder = wgpuDeviceCreateCommandEncoder(device, &ceDesc);
        
        WGPURenderPassColorAttachmentDescriptor caDesc = {
            attachment: nextTexture,
            resolveTarget: null,
            loadOp: WGPULoadOp.Clear,
            storeOp: WGPUStoreOp.Store,
            clearColor: WGPUColor(0.5, 0.5, 0.5, 1.0)
        };
        WGPURenderPassDescriptor passDesc = {
            colorAttachments: &caDesc,
            colorAttachmentCount: 1,
            depthStencilAttachment: null
        };
        WGPURenderPassEncoder renderPass = wgpuCommandEncoderBeginRenderPass(encoder, &passDesc);
        
        wgpuRenderPassEncoderSetPipeline(renderPass, pipeline);
        wgpuRenderPassEncoderSetBindGroup(renderPass, 0, bindGroup, 0, null);
        wgpuRenderPassEncoderDraw(renderPass, 3, 1, 0, 0);
        wgpuRenderPassEncoderEndPass(renderPass);
        
        WGPUQueue queue = wgpuDeviceGetQueue(device);
        WGPUCommandBufferDescriptor cmdbufDesc = { label: null };
        WGPUCommandBuffer cmdBuffer = wgpuCommandEncoderFinish(encoder, &cmdbufDesc);
        wgpuQueueSubmit(queue, 1, &cmdBuffer);
        wgpuSwapChainPresent(swapChain);
    }
    
    SDL_Quit();
}

WGPUSurface createSurface(SDL_SysWMinfo wmInfo)
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
            surface = wgpuInstanceCreateSurface(null, &sfd);
        }
        else
        {
            quit("Unsupported subsystem, sorry");
        }
    }
    else version(linux)
    {
        // Needs test!
        if (wmInfo.subsystem == SDL_SYSWM_X11)
        {
            auto x11_display = wmInfo.info.x11.display;
            auto x11_window = wmInfo.info.x11.window;
            WGPUSurfaceDescriptorFromXlib sfdX11 = {
                chain: {
                    next: null,
                    sType: WGPUSType.SurfaceDescriptorFromXlib
                },
                display: x11_display,
                window: x11_window
            };
            WGPUSurfaceDescriptor sfd = {
                label: null,
                nextInChain: cast(const(WGPUChainedStruct)*)&sfdX11
            };
            surface = wgpuInstanceCreateSurface(null, &sfd);
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
        auto m_layer = SDL_RenderGetMetalLayer(renderer);
        
        WGPUSurfaceDescriptorFromMetalLayer sfdMetal = {
            chain: {
                next: null,
                sType: WGPUSType.SurfaceDescriptorFromMetalLayer
            },
            layer: m_layer
        };
        WGPUSurfaceDescriptor sfd = {
            label: null,
            nextInChain: cast(const(WGPUChainedStruct)*)&sfdMetal
        };
        surface = wgpuInstanceCreateSurface(null, &sfd);
        
        SDL_DestroyRenderer(renderer);
    }
    return surface;
}

extern(C)
{
    void requestAdapterCallback(WGPUAdapter result, void* userdata)
    {
        *cast(WGPUAdapter*)userdata = result;
    }

    extern(C) void requestDeviceCallback(WGPUDevice result, void* userdata)
    {
        *cast(WGPUDevice*)userdata = result;
    }
}
