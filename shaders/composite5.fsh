#version 430 compatibility

uniform sampler2D colortex4;

in vec2 texcoord;

/* RENDERTARGETS: 4 */

layout(location = 0) out float prefixSum;

void main() {
  prefixSum = texelFetch(colortex4, ivec2(gl_FragCoord.xy), 0).r;

  prefixSum /= texelFetch(colortex4, ivec2(1023, gl_FragCoord.y), 0).r;

  prefixSum -= (gl_FragCoord.x + 1) / 1024;
}