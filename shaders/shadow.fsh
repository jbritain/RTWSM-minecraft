#version 430 compatibility

uniform sampler2D gtexture;

uniform mat4 shadowModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;

const float sunPathRotation = -40.0;
const int shadowMapResolution = 2048;

in vec2 texcoord;
in vec4 glcolor;
in vec3 shadowViewPos;
in vec3 glnormal;

/*
const int colortex4Format = R32F;
*/

/* RENDERTARGETS: 0,1 */

layout(location = 0) out vec4 color;
layout(location = 1) out float importance;

void main() {
  color = texture(gtexture, texcoord) * glcolor;
  if(color.a < 0.1){
    discard;
  }

  importance = 1.0;
}