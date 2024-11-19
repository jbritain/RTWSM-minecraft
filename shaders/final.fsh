#version 430 compatibility

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D colortex4;

uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor1;

in vec2 texcoord;

layout(location = 0) out vec4 color;

void main() {


  vec2 shadowmapcoord = smoothstep(0.75, 1.0, texcoord);
  if(texcoord.x > 0.75 && texcoord.y > 0.75){
    color.r = texture(shadowtex0, shadowmapcoord).r;
    color.g = 0.0;
    color.b = texture(colortex3, shadowmapcoord).r;
  } else if(texcoord.x > 0.75 && texcoord.y > 0.7){
    color.g = texelFetch(colortex4, ivec2(shadowmapcoord.x * 1024, 0), 0).r;
  } else if (texcoord.y > 0.75 && texcoord.x > 0.7) {
    color.g = texelFetch(colortex4, ivec2(shadowmapcoord.y * 1024, 0), 0).r;
  } else {
    color = texture(colortex0, texcoord);
  }

  
}