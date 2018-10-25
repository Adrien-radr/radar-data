#version 400

layout (vertices=3) out;

in vec3 vPosition[];
out vec3 tcPosition[];

uniform vec3 CameraPosition;

float GetTesselationLevel(float dist0, float dist1)
{
	float avgDist = (dist0 + dist1) / 2.0;
	return max(1.0, min(32.0, 32.0 / sqrt(avgDist)));
}

void main()
{
	tcPosition[gl_InvocationID] = vPosition[gl_InvocationID];

	//if(gl_InvocationID == 0)
	{
		float vDist0 = distance(CameraPosition, tcPosition[0]);
		float vDist1 = distance(CameraPosition, tcPosition[1]);
		float vDist2 = distance(CameraPosition, tcPosition[2]);


		gl_TessLevelOuter[0] = GetTesselationLevel(vDist1, vDist2);
		gl_TessLevelOuter[1] = GetTesselationLevel(vDist0, vDist2);
		gl_TessLevelOuter[2] = GetTesselationLevel(vDist0, vDist1);
		
		gl_TessLevelInner[0] = gl_TessLevelOuter[2];
	}
}