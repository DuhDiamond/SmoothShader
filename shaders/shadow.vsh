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

    if (mc_Entity.x == 1) {
        // if water
        vec3 displacement = vec3(0.0, 0.0, 0.0) - cameraPosition;

        displacement += gerstner(gl_Vertex.xyz, dir1, frameTimeCounter, wave1_speed, wave1_steepness, wave1_amplitude, wave1_wavelength);
        displacement += gerstner(gl_Vertex.xyz, dir2, frameTimeCounter, wave2_speed, wave2_steepness, wave2_amplitude, wave2_wavelength);
        displacement += gerstner(gl_Vertex.xyz, dir3, frameTimeCounter, wave3_speed, wave3_steepness, wave3_amplitude, wave3_wavelength);
    
        // gl_Position.xyz += cameraPosition;
        vec4 modifiedPos = vec4(gl_Vertex.xyz + displacement, 1.0);
        vec4 position = shadowProjection * vec4((gl_ModelViewMatrix * modifiedPos).xyz, 1.0);
        gl_Position = position;
        gl_Position.xyz = distortShadowClipPos(gl_Position.xyz);
    } else {
        vec4 position = shadowProjection * vec4((gl_ModelViewMatrix * gl_Vertex).xyz, 1.0);
        // gl_Position = gl_ModelViewMatrix
        gl_Position = position;
        // gl_Position = ftransform();
        gl_Position.xyz = distortShadowClipPos(gl_Position.xyz);
    }
}