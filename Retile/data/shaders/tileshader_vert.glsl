#define PROCESSING_TEXTURE_SHADER

uniform mat4 transform;
uniform mat4 texMatrix;
uniform sampler2D texture;
// uniform sampler2D tileTexture;

attribute vec4 vertex;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
	gl_Position = transform * vertex;

	vertColor = color;
	vertTexCoord = texMatrix * vec4(texCoord, 1.0, 1.0);
}