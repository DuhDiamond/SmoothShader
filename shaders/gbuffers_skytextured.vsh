#version 330 compatibility

uniform mat4 gbufferModelView;

out vec2 texCoord;
out vec4 glColour;

void main() {
    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    glColour = gl_Color;

    gl_Position = ftransform();
}