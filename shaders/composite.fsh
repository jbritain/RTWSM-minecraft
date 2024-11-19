#version 430 compatibility

uniform sampler2D shadowtex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;

in vec2 texcoord;

const bool colortex3Clear = false;

/* RENDERTARGETS: 3 */
layout(location = 0) out float importance;

vec3 projectAndDivide(mat4 projection, vec3 pos){
  vec4 homPos = projection * vec4(pos, 1.0);
  return homPos.xyz / homPos.w;
}

void main() {
  importance = 0.0;
  float maxImportance = 0.0; // we use this to put the importance in the 0-1 range

  float shadowDepth = texture(shadowtex0, texcoord).r;

  vec3 shadowScreenPos = vec3(texcoord, shadowDepth);
  vec3 shadowNDCPos = shadowScreenPos * 2.0 - 1.0;
  vec3 shadowViewPos = projectAndDivide(shadowProjectionInverse, shadowNDCPos);
  vec3 feetPlayerPos = (shadowModelViewInverse * vec4(shadowViewPos, 1.0)).xyz;
  vec3 viewPos = (gbufferModelView * vec4(feetPlayerPos, 1.0)).xyz;
  vec3 NDCPos = projectAndDivide(gbufferProjection, viewPos);
  vec3 screenPos = NDCPos * 0.5 + 0.5;

  vec3 unshadedColor = texture(colortex1, screenPos.xy).rgb;
  vec3 normal = texture(colortex2, screenPos.xy).xyz * 2.0 - 1.0;

  //======================BACKWARD ANALYSIS=========================//

  // desired view function
  if(clamp(NDCPos, vec3(0.0), vec3(1.0)) == NDCPos){
    importance += 1.0;
  }
  maxImportance += 1.0;

  // distance to eye function
  importance += 1.0 - abs(screenPos.z);
  maxImportance += 1.0;

  // surface normal function
  importance += 1.0 + clamp(dot(-normal, normalize(viewPos)), 0.0, 1.0);
  maxImportance += 2.0;

  importance /= maxImportance;
}