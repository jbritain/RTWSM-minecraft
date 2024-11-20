#version 430 compatibility

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;
uniform sampler2D colortex5;

uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor1;

in vec2 texcoord;

layout(location = 0) out vec4 color;

vec2 linearstep(float edge0, float edge1, vec2 x)
{
    return  clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
}


void main() {


  vec2 shadowmapcoord = linearstep(0.75, 1.0, texcoord);
  if(texcoord.x > 0.75 && texcoord.y > 0.75){
    color.r = texture(shadowtex0, shadowmapcoord).r;
    color.g = 0.0;//texture(colortex5, shadowmapcoord).r * texture(colortex3, shadowmapcoord).r;
    color.b = 0.0;//texture(colortex3, shadowmapcoord).r;
  } else if(texcoord.x > 0.75 && texcoord.y > 0.7){
    color.r = texelFetch(colortex4, ivec2(shadowmapcoord.x * 1024, 0), 0).r;
    color.b = -color.r;
  } else if (texcoord.y > 0.75 && texcoord.x > 0.7) {
    color.r = texelFetch(colortex4, ivec2(shadowmapcoord.y * 1024, 0), 0).r;
    color.b = -color.r;
  } else {
    color = texture(colortex0, texcoord);
  }
}