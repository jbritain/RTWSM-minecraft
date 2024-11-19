#version 430 compatibility

uniform sampler2D colortex3;

in vec2 texcoord;

/* const int colortex4Format = R32F */

// we say we're gonna write to colortex3 anyway to ensure the pass runs at the correct resolution
/* RENDERTARGETS: 3 */

layout(location = 0) out float importance;
layout (r32ui) uniform uimage2D colorimg4;

void main() {
  importance = texture(colortex3, texcoord).r;

  imageAtomicMax(colorimg4, ivec2(gl_FragCoord.x / 2, 0), floatBitsToUint(importance));
  imageAtomicMax(colorimg4, ivec2(gl_FragCoord.y / 2, 1), floatBitsToUint(importance));
}