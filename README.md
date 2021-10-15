[![DUB Package](https://img.shields.io/dub/v/bindbc-wgpu.svg)](https://code.dlang.org/packages/bindbc-wgpu)

# bindbc-wgpu
BindBC binding to [gfx-rs/wgpu-native](https://github.com/gfx-rs/wgpu-native). Targets the library at [v0.10.4](https://github.com/gfx-rs/wgpu-native/releases/tag/v0.10.4.1).

> WebGPU is a work-in-progress specification, it is not really usable yet. This binding may be not up to date with latest API revisions.

Usage:
```
"dependencies": {
    "bindbc-wgpu": "0.10.1"
}
```

This repository also includes a simple triangle demo that can be compiled by running 

`dub build --config=demo`

## What is WebGPU?
It is a new low-level graphics and compute API for the Web that works on top of Vulkan, DirectX 12, or Metal. It exposes the generic computational facilities available in today's GPUs in a cross-platform way. 

[wgpu-native](https://github.com/gfx-rs/wgpu) is a native WebGPU implementation written in Rust that compiles to a library with C API, which can be used in any language.
