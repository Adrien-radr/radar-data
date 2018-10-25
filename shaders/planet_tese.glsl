#version 400

layout (triangles, equal_spacing, ccw) in;

in vec3 tcPosition[];
out vec3 tePosition;

uniform mat4 ProjMatrix;
uniform mat4 ViewMatrix;

void main()
{
	tePosition = vec3(0,0,0);
	tePosition += gl_TessCoord.x * tcPosition[0];
	tePosition += gl_TessCoord.y * tcPosition[1];
	tePosition += gl_TessCoord.z * tcPosition[2];

	gl_Position = ProjMatrix * ViewMatrix * vec4(tePosition, 1.0);
}