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

out gl_PerVertex
{
	vec4 gl_Position;
};

out vec3 gNormal;

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
	gNormal = teNormal[0];
//	vec3 tmp = cross(normalize(gl_in[0]
#if BASELINE
	gl_Position = gl_in[0].gl_Position;
	EmitVertex();
	gl_Position = gl_in[1].gl_Position;
	EmitVertex();
	gl_Position = gl_in[2].gl_Position;
	EmitVertex();
#else
	vec3 p0 = gl_in[0].gl_Position.xyz/gl_in[0].gl_Position.w;
	vec3 p1 = gl_in[1].gl_Position.xyz/gl_in[1].gl_Position.w;
	vec3 p2 = gl_in[2].gl_Position.xyz/gl_in[2].gl_Position.w;

	vec3 line0 = normalize(p1 - p0);
	vec3 line1 = normalize(p2 - p1);
	vec3 line2 = normalize(p0 - p2);
	
	float lineWidth = 0.005;
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
	
	gl_Position = gl_in[0].gl_Position - vec4(disp0, 0);
	gNormal = -n0_;
	EmitVertex();								
	gl_Position = gl_in[0].gl_Position + vec4(disp0, 0);
	gNormal = n0_;
	EmitVertex();								
	gl_Position = gl_in[1].gl_Position - vec4(disp0, 0);
	gNormal = -n0_;
	EmitVertex();								
	gl_Position = gl_in[1].gl_Position + vec4(disp0, 0);
	gNormal = n0_;
	EmitVertex();								
	gl_Position = gl_in[1].gl_Position - vec4(disp1, 0);
	gNormal = -n1_;
	EmitVertex();								
	gl_Position = gl_in[1].gl_Position + vec4(disp1, 0);
	gNormal = n1_;
	EmitVertex();								
	gl_Position = gl_in[2].gl_Position - vec4(disp1, 0);
	gNormal = -n1_;
	EmitVertex();								
	gl_Position = gl_in[2].gl_Position + vec4(disp1, 0);
	gNormal = n1_;
	EmitVertex();								
	gl_Position = gl_in[2].gl_Position - vec4(disp2, 0);
	gNormal = -n2_;
	EmitVertex();								
	gl_Position = gl_in[2].gl_Position + vec4(disp2, 0);
	gNormal = n2_;
	EmitVertex();								
	gl_Position = gl_in[0].gl_Position - vec4(disp2, 0);
	gNormal = -n2_;
	EmitVertex();								
	gl_Position = gl_in[0].gl_Position + vec4(disp2, 0);
	gNormal = n2_;
	EmitVertex();
#endif
	EndPrimitive();
}