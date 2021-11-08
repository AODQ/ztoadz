# ztoadz / MTR

this is just a toy project to play around with Zig in a real-time graphics
context.

to test: `zig test tests/package.zig -lc -lOpenCL --main-pkg-path .`


This exists as both a rendering backend 'MTR' (Monte Toad Renderer), as well
  as a front-end renderering application. The rendering backend is meant to be
  implementable for any graphics API backend (vulkan, directx, etc), but the
  current rendering backend is an OpenCL3.0 software-based rasterizer.

Like a lot of other graphics APIs, it's meant to bridge the gap between
  low-level APIs and OpenGL. Instead of taking the HW-rasterize approach many
  other APIs do, this takes a more general-compute approach, however you could
  probably implement a rasterized backend as well.


- Mapping
  Buffers and images may be mapped to memory, as long as the following is true:

    * the underlying heap region's visibility is not deviceOnly
    * the underlying heap region's visibility is hostVisible or hostWritable

  There is no way to map as both read/write. As well, if the heap region
    visibility is hostVisible, the mapping will be read-only by the host, while a
    hostWritable means the mapping will be write-only. The implementation may
    choose to invalidate the underlying region on a write-only mapping.
