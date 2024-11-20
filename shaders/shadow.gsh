#version 430 compatibility

uniform sampler2D colortex4;

layout(triangles) in;
layout(triangle_strip, max_vertices = 6) out;

in VertexData {
  vec2 texcoord;
  vec4 glcolor;
  vec3 glnormal;
} vIn[];

out VertexData {
  vec2 texcoord;
  vec4 glcolor;
  vec3 glnormal;
  flat bool isDistorted;
} vOut;

void main() {
  
  vOut.isDistorted = true;
  // distorted shadow map
  for (int i = 0; i < 3; ++i) {
    vOut.texcoord = vIn[i].texcoord;
    vOut.glcolor = vIn[i].glcolor;

    gl_Position = gl_in[i].gl_Position;

    vec2 screenPos = gl_Position.xy * 0.5 + 0.5;

    vec2 warp = vec2(
      texelFetch(colortex4, ivec2(screenPos.x * 1024, 0), 0).r,
      texelFetch(colortex4, ivec2(screenPos.y * 1024, 1), 0).r
    );

    screenPos += warp;
    gl_Position.xy = screenPos.xy * 2.0 - 1.0;

    EmitVertex();
  }
  EndPrimitive();

  vOut.isDistorted = false;
  // undistorted shadow map
  for (int i = 0; i < 3; ++i) {
    vOut.texcoord = vIn[i].texcoord;
    vOut.glcolor = vIn[i].glcolor;


    gl_Position = gl_in[i].gl_Position;
    EmitVertex();
  }
  EndPrimitive();
}