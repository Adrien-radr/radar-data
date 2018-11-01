#version 420

//in vec4 tePositionEye;

in vec3 teNormal;
in vec3 tePosition;

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
#if 0
	float len = max(0,length(gNormal));
	vec3 N = normalize(gNormal);

	float lineWidth = 0.7; 
	float featherWidth = 1.0 - lineWidth;

	float lw = max(0, -len+lineWidth);
	if(lw > 0) lw = 1;
	float feather = (featherWidth - max(0, len - lineWidth))/featherWidth;
#endif
	float len = length(tePosition);
	float lenCol = 0.5 + 0.5*10*(teNormal.z-1.0);
	color = vec4(sqrt(teNormal.x),teNormal.y,0.8*lenCol*lenCol,1);
}