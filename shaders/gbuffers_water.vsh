#version 400 compatibility

#include "/lib/waves.glsl"

in vec2 mc_Entity;
uniform int blockEntityId;
uniform mat4 gbufferModelViewInverse;
uniform vec3 playerPos;
uniform sampler2D depthtex0;
uniform sampler2D lightmap;

out vec2 texCoordV;
out vec2 lmCoordV;
out vec4 fragColourV;
out vec3 normalV;
flat out int waterCheckV;

void main() {
    texCoordV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmCoordV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    normalV = gl_NormalMatrix * gl_Normal;
    normalV = mat3(gbufferModelViewInverse) * normalV;

    fragColourV = vec4(gl_Color.xyz, 1.0);

    if (mc_Entity.x == 1) {
        waterCheckV = 1;
        gl_Position = vec4(cameraPosition + gl_Vertex.xyz, 1.0);
    } else {
        waterCheckV = 0;
        gl_Position = vec4(gl_Vertex.xyz, 1.0);
    }
}