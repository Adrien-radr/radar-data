#version 420

layout (location=0) in vec3 position;

out gl_PerVertex 
{
	vec4 gl_Position;
};

out vec2 vTexcoord;
out vec3 vCubeFace;

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

void main()
{
	int vPerFace = GridW * GridH;
	int face = gl_InstanceID / vPerFace;

	vCubeFace = vec3((face == 0 ? 1 : 0) - (face == 1 ? 1 : 0),
					 (face == 2 ? 1 : 0) - (face == 3 ? 1 : 0),
					 (face == 4 ? 1 : 0) - (face == 5 ? 1 : 0));


	int iz = gl_InstanceID / (GridW*GridH);
	int rest = gl_InstanceID % (GridW*GridH);
	int ix = rest % GridW;
	int iy = rest / GridH;

	vTexcoord = vec2(float(ix) / float(GridW), float(iy) / float(GridH));

	vec3 gPos = vec3(float(ix)*TileSize.x, 0.0f, float(iy)*TileSize.z);
	
	vec3 org = Origin + vec3(GridW*TileSize.x) * max(vCubeFace,vec3(0));

	vCubeFace = abs(vCubeFace);
	vec3 vPosition = org+ vec3( (vCubeFace.y + vCubeFace.z)*gPos.x,
								vCubeFace.x*gPos.x + vCubeFace.z*gPos.z,
								(vCubeFace.y + vCubeFace.x)*gPos.z);

	gl_Position = vec4(vPosition, 1.0f);
}