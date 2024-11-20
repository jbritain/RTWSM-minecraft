#version 430 compatibility

uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex5;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;

uniform float far;
uniform float centerDepthSmooth;

in vec2 texcoord;

const bool colortex3Clear = false;
const bool colortex4Clear = false;

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 doesntMatter;
layout (rgba8) uniform image2D colorimg3;
layout (r32f) uniform image2D colorimg4;

vec3 projectAndDivide(mat4 projection, vec3 pos){
  vec4 homPos = projection * vec4(pos, 1.0);
  return homPos.xyz / homPos.w;
}

void main() {
  doesntMatter = texture(colortex0, texcoord);

  float depth = texture(depthtex0, texcoord).r;

  if(depth == 1.0){
    return;
  }

  // vec3 centreViewPos = projectAndDivide(gbufferProjectionInverse, vec3(0.5, 0.5, texture(depthtex0, vec2(0.5, 0.5)).r) * 2.0 - 1.0);

  vec3 screenPos = vec3(texcoord, depth);
  vec3 viewPos = projectAndDivide(gbufferProjectionInverse, screenPos * 2.0 - 1.0);
  vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
	vec3 shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
	vec3 shadowScreenPos = (mat3(shadowProjection) * shadowViewPos) * 0.5 + 0.5;

  vec3 normal = normalize(texture(colortex2, screenPos.xy).xyz * 2.0 - 1.0);

  float importance = 1.0;

  // // distance to eye function
  // float dist = clamp(length(viewPos) / far, 0.0, 1.0);
  // importance *= 1.0 - pow(dist, 5.0);

  // // surface normal function
  // float mu = clamp(dot(-normal, normalize(viewPos)), 0.0, 1.0);
  // importance *= 1.0 + mu;

  imageStore(colorimg3, ivec2(shadowScreenPos.xy * 2048), vec4(importance));

  // clear colortex4 while we're here
  imageStore(colorimg4, ivec2(gl_FragCoord.xy), vec4(0.0));
  
}