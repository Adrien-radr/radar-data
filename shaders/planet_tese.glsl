#version 420
#define PI 3.14157
layout (quads, fractional_even_spacing, cw) in;

in gl_PerVertex
{
	vec4 gl_Position;
} gl_in[];

in vec2 tcTexcoord[];
in vec3 tcCubeFace[];

out gl_PerVertex
{
	vec4 gl_Position;
};

out vec3 teNormal;
out vec3 tePosition;

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
	int GridD;
};

uniform mat4 ProjMatrix;


void main()
{
	vec3 pos = tePosition = gl_in[0].gl_Position.xyz;
	vec2 gPos = gl_TessCoord.xy * TileSize.xz;

	// Translate vertex according to per-cubeface grid parameterization
	vec3 cf = tcCubeFace[0];
	pos += vec3((cf.y+cf.z)*gPos.x, cf.x*gPos.x+cf.z*gPos.y, (cf.y+cf.x)*gPos.y);

	tePosition = normalize(pos);
	vec2 sph = vec2(acos(tePosition.y/
						 sqrt(tePosition.y*tePosition.y + tePosition.x*tePosition.x + tePosition.z*tePosition.z)),
					atan(tePosition.z, tePosition.x));
	tePosition += tePosition * 0.05 * sin(2.f*PI*Time+8.f*sph.x+4.f*sph.y);

	float sx = sph.x/(PI);
	float sy = (sph.y+PI)/(2.0*PI);
	vec3 col = vec3(sx, 1.f - sx, length(tePosition));
	teNormal = col;

	gl_Position = ProjMatrix * ViewMatrix * vec4(tePosition, 1.0);
}