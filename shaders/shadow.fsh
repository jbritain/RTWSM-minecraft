#version 430 compatibility

uniform sampler2D gtexture;

uniform mat4 shadowModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;

const float sunPathRotation = -40.0;
const int shadowMapResolution = 2048;

in VertexData {
  vec2 texcoord;
  vec4 glcolor;
  vec3 glnormal;
  flat bool isDistorted;
} vIn;

/*
const int colortex4Format = R32F;
const int colortex5Format = R32F;
*/



/* RENDERTARGETS: 0,1 */

layout(location = 0) out vec4 color;
layout(location = 1) out vec4 normal;
layout (r32ui) uniform uimage2D colorimg5;

void main() {
  if(!vIn.isDistorted){
    if(imageAtomicMin(colorimg5, ivec2(gl_FragCoord.xy), floatBitsToUint(gl_FragCoord.z)) == 0){
      imageStore(colorimg5, ivec2(gl_FragCoord.xy), uvec4(floatBitsToUint(gl_FragCoord.z)));

    } 
    discard;
  }

  color = texture(gtexture, vIn.texcoord) * vIn.glcolor;
  if(color.a < 0.1){
    discard;
  }
}