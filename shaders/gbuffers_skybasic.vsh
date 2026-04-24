#version 330 compatibility

uniform vec3 relativeEyePosition;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;

out vec4 glColour;

void main() {
    glColour = gl_Color;

    gl_Position = ftransform();
}