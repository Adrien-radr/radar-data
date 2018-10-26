#version 420
#define PI 3.14157
layout (quads, fractional_even_spacing, cw) in;

in gl_PerVertex
{
	vec4 gl_Position;
} gl_in[];

in vec2 tcTexcoord[];
//in vec2 tcLevelInner[];

out gl_PerVertex
{
	vec4 gl_Position;
};

//out vec4 tePositionEye;
out vec3 teNormal;

layout(std140, binding=1) uniform Params
{
	mat4 ModelMatrix;
	mat4 ViewMatrix;
	vec3 CameraPosition;
	float OuterTessFactor;
	vec3 TileSize;
	float InnerTessFactor;
	vec3 Origin;
	float Time;
	int GridW;
	int GridH;
};

uniform mat4 ProjMatrix;


void main()
{
	vec3 tePosition = gl_in[0].gl_Position.xyz;
	tePosition.xz += gl_TessCoord.xy * TileSize.xz;


	float xydep = 1.5;
	float scale = 0.2;
	tePosition.y += scale *(sin(0.4*xydep*tePosition.x+Time*1.1) * 
							sin(1.4*xydep*tePosition.z+Time*0.01)*
							sin(0.2*xydep*tePosition.x*tePosition.z+Time)   );

//	tePositionEye = ViewMatrix * vec4(tePosition, 1.0);
	vec2 uv = tePosition.xz;//gl_TessCoord.xy/TileSize.xz;//tcTexcoord[0];// + (vec2(1.0/GridW, 1.0/GridH) * gl_TessCoord.xy);	
	teNormal = vec3(uv,(tePosition.y));//tcLevelInner[0].x);

	gl_Position = ProjMatrix * ViewMatrix * vec4(tePosition, 1.0);
}