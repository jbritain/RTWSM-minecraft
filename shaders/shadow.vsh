#version 430 compatibility

out vec2 texcoord;
out vec4 glcolor;
out vec3 shadowViewPos;
out vec3 glnormal;
out vec3 undistortedScreenPos;

void main() {
  texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  glcolor = gl_Color;

  gl_Position = ftransform();
  shadowViewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;



  glnormal = gl_NormalMatrix * gl_Normal;
}