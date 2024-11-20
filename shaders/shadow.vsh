#version 430 compatibility

out VertexData {
  vec2 texcoord;
  vec4 glcolor;
  vec3 glnormal;
} vOut;

void main() {
  vOut.texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
  vOut.glcolor = gl_Color;

  gl_Position = ftransform();
  vOut.glnormal = gl_NormalMatrix * gl_Normal;
}