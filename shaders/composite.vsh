#version 330 compatibility

#include "functions/projection.glsl"

uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 gbufferProjectionMatrix;
uniform sampler2D depthtex0;
uniform float viewWidth;
uniform float viewHeight;

out vec2 texCoord;
out float waterCheck;

void main() {
    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    // gl_Vertex
    vec3 position = vec3(texCoord, texture2D(depthtex0, texCoord));
    position = position * 2.0 - 1.0;
    gl_Position.xyz = position;
    waterCheck = 1.0;
}