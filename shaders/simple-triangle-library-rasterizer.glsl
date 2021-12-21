// library to share between the two rasterizers (tiled/micro - rasterizer)
// must define triangleIdToEmitId

struct TriangleInfo {
  vec4 screenV0;
  vec4 screenV1;
  vec4 screenV2;
};

TriangleInfo GatherTriangleInfo(
  const uint32_t triangleId,
  const ivec2 viewportDim
) {
  const vec4 v0 = intermediaryAttributes[0+6*triangleId];
  const vec4 v1 = intermediaryAttributes[1+6*triangleId];
  const vec4 v2 = intermediaryAttributes[2+6*triangleId];

  TriangleInfo triangle;

  triangle.screenV0 = v0;
  triangle.screenV1 = v1;
  triangle.screenV2 = v2;

  #define toScreen(v) v.xy = (viewportDim * v.xy);

  toScreen(triangle.screenV0);
  toScreen(triangle.screenV1);
  toScreen(triangle.screenV2);

  #undef toScreen

  return triangle;
}

float computeTriangleDepthAtUv(const TriangleInfo tri, const vec2 uv) {
  const mat3 tris = (
    inverse(mat3(tri.screenV0.xyz, tri.screenV1.xyz, tri.screenV2.xyz))
  );
  const vec3 uvw = vec3(uv, 1.0f);

  // interpolate barycentric coordinate of screen
  vec3 bcScreen = tris * uvw;

  if (!(bcScreen.x >= 0.0f && bcScreen.y >= 0.0f && bcScreen.z >= 0.0f))
    return 0.0f;

  // normalize
  bcScreen /= dot(bcScreen, vec3(1.0f));

  // apply barycentric coords to clip space to apply perspective projection
  vec3 bcClip = bcScreen / vec3(tri.screenV0.w, tri.screenV1.w, tri.screenV2.w);

  return 1.0f/dot(bcClip, vec3(tri.screenV0.z, tri.screenV1.z, tri.screenV2.z));
}
