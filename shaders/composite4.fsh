#version 430 compatibility

uniform sampler2D colortex4;

in vec2 texcoord;

/* RENDERTARGETS: 4 */

layout(location = 0) out float warping;

void main() {
  int superCell = int(gl_FragCoord.x) % 8; // he he he ha

  int xRelativeToSuperCell = int(gl_FragCoord.x) - (superCell * 8 + 4);
}