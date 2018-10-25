#version 400

layout (vertices=3) out;

in vec3 vPosition[];
out vec3 tcPosition[];

void main()
{
	tcPosition[gl_InvocationID] = vPosition[gl_InvocationID];

	if(gl_InvocationID == 0)
	{
		gl_TessLevelInner[0] = 8.0;

		gl_TessLevelOuter[0] = 8.0;
		gl_TessLevelOuter[1] = 8.0;
		gl_TessLevelOuter[2] = 8.0;
	}
}