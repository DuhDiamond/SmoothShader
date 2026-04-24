#version 330 compatibility

out vec2 texCoord;

out float waterCheck;

void main() {
    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
    waterCheck = 1.0;
}