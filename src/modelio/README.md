# MTR model IO

This is an 'intermediate' scene format used to describe the surfaces of
  a collection of models. Similar to obj, stl, gltf, etc. It is mostly inspired
  by GLTF, the most significant difference is that this is meant to be exposed
  by a single loader/API, performing the necessary loading & format conversions
  through options & callbacks.

Of course since it's WIP everything is subject to change

The primary use-case for this is such that all mesh data is conformant within a
  scene; for example we would prefer to waste additional memory having the
  entire scene use RGB16 format even if parts of it would only use RGB8

glTF conventially allows you to have multiple buffers to load from. For MTR,
everything is stored into a single buffer so you will only need to worry about
'views' into them. The size of the file is negligible as well so many parts
are collapsed/removed to provide less overall complexity, at the cost of
an additional amount of redundant information stored.

# File Format

The file format is in JSON, and there is also a general-purpose utility script
  that can port most files to MTR. each node can have extension used to extend
  the format w/ callbacks

{
  "version": "0",
  "extension": [],
  "cameras": [
    {"view-matrix": [...]},
  ],
  "lights": [
    {
      "type": "directional", # also point
      "origin": [5, 5, 5],
      "direction": [1.0, 0.0, 0.0],
    },
  ],
  "images": [
    "whatever.ppm",
  ],
  "scene": [
    0 # top level nodes
  ],
  "nodes": {
    "children": [1, 2, ...],
    "model-matrix": [...],
    "attribute-elements": 120,
    "material": {
      "diffuse-texture": { # specular, occlusion, emissive, metallicRoughness
        "index": 0,
      },
      "diffuse-factor": [ 1.0, 1.0, 1.0, 1.0 ],
      "diffuse-linearize": false, # whether to linearize (pow 2.2) image
      "normal-texture": {
        "index": 1,
      },
      # although extension is avail everywhere, it will probably be must
      # useful here
      "extension": {},
    },
    "indices": {
      "format": "r32",
      "byte-offset": 0,
    },
    "attributes": [
      {
        "type": "origin", # uv-coord, normal
        "format": "rgb16",
        "byte-offset": 0,
        "byte-stride": 0, # if 0 assume sizeof format
      },
    ],
  }
}

# API
