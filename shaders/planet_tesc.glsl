#version 420
#define LOD 1
#define QUADSPHERE_PARAM 0
#define MAX_TESS 16.0

layout (vertices=1) out;

in gl_PerVertex 
{
	vec4 gl_Position;
} gl_in[];

in vec2 vTexcoord[];
in vec3 vCubeFace[];

out gl_PerVertex
{
	vec4 gl_Position;
} gl_out[];

out vec2 tcTexcoord[];
out vec2 tcLevelInner[];
out vec3 tcCubeFace[];

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

float GetTesselationLevel(float dist0, float dist1)
{
	float avgDist = (dist0 + dist1) / 2.0;
//	return max(1.0, min(MAX_TESS, MAX_TESS / (avgDist*avgDist*avgDist*avgDist)));
	return max(1.0, min(MAX_TESS, MAX_TESS / exp(1.0*avgDist)));
}

float GetRadiusTessLevel(float theta)
{
	float th = max(0.0, theta);
	return max(1.0, MAX_TESS * max(0.0, th*th));
}

void main()
{
	vec4 position = gl_in[gl_InvocationID].gl_Position;
	gl_out[gl_InvocationID].gl_Position = position;
	tcTexcoord[gl_InvocationID] = vTexcoord[gl_InvocationID];
	tcCubeFace[gl_InvocationID] = vCubeFace[gl_InvocationID];

	#if LOD
		vec3 v0 = gl_in[0].gl_Position.xyz;
		vec3 cf = vCubeFace[0];
		vec3 v1 = v0 + vec3((cf.y+cf.z)*TileSize.x, cf.x*TileSize.x, 0);
		vec3 v2 = v0 + vec3((cf.y+cf.z)*TileSize.x, cf.x*TileSize.x+cf.z*TileSize.y, (cf.y+cf.x)*TileSize.y);
		vec3 v3 = v0 + vec3(0, cf.z*TileSize.y, (cf.y+cf.x)*TileSize.y);

		#if QUADSPHERE_PARAM
			// TODO - this keeps the parameterization as Cube faces
			// ultimately we want the LOD to be dependent on the distance of the camera to the spherical terrain

			float d0 = distance(CameraPosition, v0);
			float d1 = distance(CameraPosition, v1);
			float d2 = distance(CameraPosition, v2);
			float d3 = distance(CameraPosition, v3);

			gl_TessLevelOuter[0] = GetTesselationLevel(d3, d0);
			gl_TessLevelOuter[1] = GetTesselationLevel(d0, d1);
			gl_TessLevelOuter[2] = GetTesselationLevel(d1, d2);
			gl_TessLevelOuter[3] = GetTesselationLevel(d2, d3);
		#else
			// just tesselate where the camera is around the planet depending on the angle
			// between camera and vertex relative to the origin
			vec3 StaticPosition = vec3(0,1,0);
			vec3 OrbitPosition = normalize(vec3(cos(Time), sin(-Time*0.3)*cos(Time*0.5), sin(Time)));
			vec3 UsedPosition = StaticPosition;

			float radius = length(UsedPosition);
			vec3 dir = UsedPosition / radius;

			vec3 v0_d = normalize(v0);
			vec3 v1_d = normalize(v1);
			vec3 v2_d = normalize(v2);
			vec3 v3_d = normalize(v3);

			float th0 = dot(v0_d, dir);
			float th1 = dot(v1_d, dir);
			float th2 = dot(v2_d, dir);
			float th3 = dot(v3_d, dir);

			gl_TessLevelOuter[0] = GetRadiusTessLevel(th0);
			gl_TessLevelOuter[1] = GetRadiusTessLevel(th1);
			gl_TessLevelOuter[2] = GetRadiusTessLevel(th2);
			gl_TessLevelOuter[3] = GetRadiusTessLevel(th3);
		#endif

		gl_TessLevelInner[0] = 0.5 * (gl_TessLevelOuter[1] + gl_TessLevelOuter[3]);
		gl_TessLevelInner[1] = 0.5 * (gl_TessLevelOuter[0] + gl_TessLevelOuter[2]);
		tcLevelInner[gl_InvocationID] = vec2(gl_TessLevelInner[0], gl_TessLevelInner[1]);
	#else
		float oTessLvl = OuterTessFactor;
		float iTessLvl = InnerTessFactor;

		gl_TessLevelOuter[0] = oTessLvl;
		gl_TessLevelOuter[1] = oTessLvl;
		gl_TessLevelOuter[2] = oTessLvl;
		gl_TessLevelOuter[3] = oTessLvl;
		
		gl_TessLevelInner[0] = iTessLvl;
		gl_TessLevelInner[1] = iTessLvl;
		tcLevelInner[gl_InvocationID] = vec2(iTessLvl);
	#endif
}