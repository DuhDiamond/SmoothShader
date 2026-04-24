#version 330 compatibility

#include "/lib/distort.glsl"

#include "/lib/waves.glsl"

uniform mat4 shadowProjection;
uniform mat4 shadowModelView;
uniform vec4 shadowClipPos;
uniform int blockEntityId;
uniform sampler2D depthtex0;
in vec2 mc_Entity;

out vec2 texCoord;
out vec4 glColour;

void main() {
    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    glColour = gl_Color;

    vec4 position = gl_Vertex;

    if (mc_Entity.x == 1) {
        // if water
        vec3 worldSpaceVertexPosition = gl_Vertex.xyz;

        vec3 displacement = globalDisplacement;

        globalDisplacement += gerstner(worldSpaceVertexPosition, dir1, frameTimeCounter, wave1_speed, wave1_steepness, wave1_amplitude, wave1_wavelength);
        globalDisplacement += gerstner(worldSpaceVertexPosition, dir2, frameTimeCounter, wave2_speed, wave2_steepness, wave2_amplitude, wave2_wavelength);
        globalDisplacement += gerstner(worldSpaceVertexPosition, dir3, frameTimeCounter, wave3_speed, wave3_steepness, wave3_amplitude, wave3_wavelength);
    
        position.xyz += globalDisplacement;
    }

    gl_Position = gl_ProjectionMatrix * (vec4((gl_ModelViewMatrix * vec4(position.xyz, 1.0)).xyz, 1.0));
    gl_Position.xyz = distortShadowClipPos(gl_Position.xyz);
}