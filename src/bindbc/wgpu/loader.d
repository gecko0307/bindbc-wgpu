/*
Copyright (c) 2019-2023 Timur Gafarov.

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
module bindbc.wgpu.loader;

import core.stdc.stdint;
import bindbc.loader;
import bindbc.wgpu.types;
import bindbc.wgpu.funcs;

enum WGPUSupport
{
    noLibrary,
    badLibrary,
    wgpu019
}

private
{
    SharedLib lib;
    WGPUSupport loadedVersion;
}

void unloadWGPU()
{
    if (lib != invalidHandle)
    {
        lib.unload();
    }
}

WGPUSupport loadedWGPUVersion()
{
    return loadedVersion;
}

bool isWGPULoaded()
{
    return lib != invalidHandle;
}

WGPUSupport loadWGPU()
{
    version(Windows)
    {
        const(char)[][1] libNames =
        [
            "wgpu_native.dll"
        ];
    }
    else version(OSX)
    {
        const(char)[][1] libNames =
        [
            "libwgpu_native.dylib"
        ];
    }
    else version(Posix)
    {
        const(char)[][2] libNames =
        [
            "libwgpu_native.so",
            "/usr/local/lib/libwgpu_native.so",
        ];
    }
    else static assert(0, "libwgpu is not yet supported on this platform.");
    
    WGPUSupport ret;
    foreach(name; libNames)
    {
        ret = loadWGPU(name.ptr);
        if (ret != WGPUSupport.noLibrary)
            break;
    }
    return ret;
}

WGPUSupport loadWGPU(const(char)* libName)
{
    lib = load(libName);
    if(lib == invalidHandle)
    {
        return WGPUSupport.noLibrary;
    }
    
    auto errCount = errorCount();
    loadedVersion = WGPUSupport.badLibrary;
    
    import std.algorithm.searching: startsWith;
    static foreach(symbol; __traits(allMembers, bindbc.wgpu.funcs))
    {
        static if (symbol.startsWith("wgpu"))
            lib.bindSymbol(
                cast(void**)&__traits(getMember, bindbc.wgpu.funcs, symbol),
                __traits(getMember, bindbc.wgpu.funcs, symbol).stringof);
    }
    
    loadedVersion = WGPUSupport.wgpu019;
    
    if (errorCount() != errCount)
        return WGPUSupport.badLibrary;
    
    return loadedVersion;
}
