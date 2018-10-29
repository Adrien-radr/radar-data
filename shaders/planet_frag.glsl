#version 420

//in vec4 tePositionEye;
in vec3 teNormal;

out vec4 color;

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
	color = vec4(0.05,0.05,0.05,1);
}