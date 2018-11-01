#version 420
#define BASELINE 0

layout(triangles, invocations = 1) in;
#if BASELINE
layout(triangle_strip, max_vertices = 3) out;
#else
layout(triangle_strip, max_vertices = 12) out;
#endif


in gl_PerVertex {
    vec4 gl_Position;
} gl_in[];

in vec3 teNormal[];
in vec3 tePosition[];

out gl_PerVertex
{
	vec4 gl_Position;
};

out vec3 gNormal;
out vec3 gPosition;

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

void EmitV(in int idx, in vec3 disp, in vec3 nrm)
{
	gl_Position = gl_in[idx].gl_Position - vec4(disp, 0);
	gPosition = tePosition[idx];
	gNormal = nrm;
	EmitVertex();	
}

void main()
{
#if BASELINE
	gNormal = teNormal[0];
	gl_Position = gl_in[0].gl_Position;
	EmitVertex();
	gNormal = teNormal[0];
	gl_Position = gl_in[1].gl_Position;
	EmitVertex();
	gNormal = teNormal[0];
	gl_Position = gl_in[2].gl_Position;
	EmitVertex();
#else
	vec3 p0 = gl_in[0].gl_Position.xyz/gl_in[0].gl_Position.w;
	vec3 p1 = gl_in[1].gl_Position.xyz/gl_in[1].gl_Position.w;
	vec3 p2 = gl_in[2].gl_Position.xyz/gl_in[2].gl_Position.w;

	vec3 line0 = normalize(p1 - p0);
	vec3 line1 = normalize(p2 - p1);
	vec3 line2 = normalize(p0 - p2);
	
	float lineWidth = 0.007;
	float hLineWidth = 0.5 * lineWidth;

	vec3 n0 = vec3(line0.y, -line0.x, 0);
	vec3 n1 = vec3(line1.y, -line1.x, 0);
	vec3 n2 = vec3(line2.y, -line2.x, 0);
	vec3 n0_ = normalize(n2 + n0);
	vec3 n1_ = normalize(n0 + n1);
	vec3 n2_ = normalize(n1 + n2);

	vec3 disp0 = n0 * p0.z * hLineWidth;
	vec3 disp1 = n1 * p1.z * hLineWidth;
	vec3 disp2 = n2 * p2.z * hLineWidth;
	
	EmitV(0, -disp0, -n0_);
	EmitV(0, disp0, n0_);
	EmitV(1, -disp0, -n0_);
	EmitV(1, disp0, n0_);
	EmitV(1, -disp1, -n1_);
	EmitV(1, disp1, n1_);
	EmitV(2, -disp1, -n1_);
	EmitV(2, disp1, n1_);
	EmitV(2, -disp2, -n2_);
	EmitV(2, disp2, n2_);
	EmitV(0, -disp2, -n2_);
	EmitV(0, disp2, n2_);

#endif
	EndPrimitive();
}