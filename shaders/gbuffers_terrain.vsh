#version 430 compatibility

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;

out vec3 viewPos;
out vec3 glnormal;

void main() {
	gl_Position = ftransform();

	viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;

	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
	glnormal = gl_NormalMatrix * gl_Normal;
}