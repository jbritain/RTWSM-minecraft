#version 430 compatibility

uniform sampler2D colortex3;

in vec2 texcoord;

/* RENDERTARGETS: 3 */

layout(location = 0) out float importance;

void main() {
  importance = 0.0;
}