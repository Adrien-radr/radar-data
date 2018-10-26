#version 420

layout (location=0) in vec3 position;

out gl_PerVertex 
{
	vec4 gl_Position;
};

out vec2 vTexcoord;

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

void main()
{
	int ix = gl_InstanceID % GridW;
	int iy = gl_InstanceID / GridH;

	vTexcoord = vec2(float(ix) / float(GridW), float(iy) / float(GridH));
	vec3 vPosition = vec3(float(ix)*TileSize.x, 0.0f, float(iy)*TileSize.z);
	gl_Position = vec4(vPosition, 1.0f);
}