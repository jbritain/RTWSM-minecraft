#version 430 compatibility

uniform sampler2D lightmap;
uniform sampler2D gtexture;
uniform sampler2D shadowtex0;

uniform float alphaTestRef = 0.1;

uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 glcolor;

in vec3 viewPos;
in vec3 glnormal;

/* RENDERTARGETS: 0,1,2 */
layout(location = 0) out vec4 color;
layout(location = 1) out vec4 unshadedColor;
layout(location = 2) out vec4 normal;

vec3 getShadowNDCPos(vec3 viewPos){
	vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
	vec3 shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
	vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);
	return shadowClipPos.xyz / shadowClipPos.w;
}

void main() {
	color = texture(gtexture, texcoord) * glcolor;

	unshadedColor = color;

	color *= texture(lightmap, lmcoord);
	if (color.a < alphaTestRef) {
		discard;
	}

	vec3 shadowPos = getShadowNDCPos(viewPos) * 0.5 + 0.5;

	if(clamp(shadowPos.xy, 0.0, 1.0) != shadowPos.xy){
		return;
	}

	float shadow = step(shadowPos.z - 0.00002, texture(shadowtex0, shadowPos.xy).r);
	color.rgb *= shadow * 0.7 + 0.3;

	normal.rgb = glnormal * 0.5 + 0.5;
}