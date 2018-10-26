#version 420

layout (vertices=1) out;

in gl_PerVertex 
{
	vec4 gl_Position;
} gl_in[];

in vec2 vTexcoord[];

out gl_PerVertex
{
	vec4 gl_Position;
} gl_out[];

out vec2 tcTexcoord[];
out vec2 tcLevelInner[];

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

float GetTesselationLevel(float dist0, float dist1)
{
	float avgDist = (dist0 + dist1) / 2.0;
	return max(1.0, min(32.0, 32.0 / sqrt(avgDist)));
}

void main()
{
	gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
	tcTexcoord[gl_InvocationID] = vTexcoord[gl_InvocationID];

	gl_TessLevelOuter[0] = OuterTessFactor;
	gl_TessLevelOuter[1] = OuterTessFactor;
	gl_TessLevelOuter[2] = OuterTessFactor;
	gl_TessLevelOuter[3] = OuterTessFactor;

	gl_TessLevelInner[0] = InnerTessFactor;
	gl_TessLevelInner[1] = InnerTessFactor;
	tcLevelInner[gl_InvocationID] = vec2(InnerTessFactor);

	//if(gl_InvocationID == 0)
	//{
	//	float vDist0 = distance(CameraPosition, tcPosition[0]);
	//	float vDist1 = distance(CameraPosition, tcPosition[1]);
	//	float vDist2 = distance(CameraPosition, tcPosition[2]);
	//
	//
	//	gl_TessLevelOuter[0] = GetTesselationLevel(vDist1, vDist2);
	//	gl_TessLevelOuter[1] = GetTesselationLevel(vDist0, vDist2);
	//	gl_TessLevelOuter[2] = GetTesselationLevel(vDist0, vDist1);
	//	
	//	gl_TessLevelInner[0] = gl_TessLevelOuter[2];
	//}
}