#version 430 compatibility

uniform sampler2D colortex4;

in vec2 texcoord;

/* RENDERTARGETS: 4 */

layout(location = 0) out float prefixSum;

void main() {
  prefixSum = 0.0;

  for(int i = 0; i < gl_FragCoord.x; i++){
    prefixSum += texelFetch(colortex4, ivec2(i, gl_FragCoord.y), 0).r;
  }
}