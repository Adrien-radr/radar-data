#version 400

layout (location=0) in vec3 position;

out vec3 vPosition;

uniform mat4 ModelMatrix;

void main()
{
	vPosition = (ModelMatrix * vec4(position, 1.0)).xyz;
	//gl_Position = vec4(position, 1.0f);
}