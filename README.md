# ztoadz / MTR

this is a toy project to play around with Zig in a real-time graphics context.

to test: `zig test tests/package.zig -lc -lOpenCL --main-pkg-path .`

there are currently 4 or so projects here

- compute rendering backend 'mtr'
- 'toy' application
- model loading library/format
- model converter

This exists as both a rendering backend 'MTR' (Monte Toad Renderer), as well
  as a front-end renderering application. The rendering backend is meant to be
  implementable for any graphics API backend (vulkan, directx, etc), but the
  current rendering backend supports just Vulkan.

This is a compute-based rendering pipeline, and as such no use of the
  rasterization pipeline is used (at least for now). A lot of inspiration is
  taken from nvidia's mesh shaders and ue5's nanite.

The rendering pipeline looks like

## Mesh assembler

  User can fetch attributes from storage buffers and emit them to an
  intermediary buffer, which selects how the triangle will be rasterized
  (micro-rasterizer or tile-based rasterizer).

## Microrasterizer

  Nanite UE5 style rendering. One thread per triangle, iterates the bounds of
    the triangle like traditional scanline rasterization. This renders to a
    visibility buffer with `imageAtomicMax`.

## Tile based rasterizer

  Screen is split into 16x16 bins and triangles are placed into them if they
    are too large for the micro-rasterizer. Instead of iterating the bounds of
    the triangle, the tile is iterated through. Also renders to the same
    visibility buffer.

## Material shader

  Renders the material of the primitives as fragments, by using the depth and
    triangle ID stored in visibility buffer to recompute barycentric UV coords.

Goals to experiment with:

  - MSAA with visibility/deferred rendering
  - Debug interface over Vk
