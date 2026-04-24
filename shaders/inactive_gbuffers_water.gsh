#version 330 compatibility

layout (triangles) in;

#include "wave.glsl"

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform vec3 playerLookVector;

in VS_OUT {
    vec2 texCoordV;
    vec2 lmCoordV;
    vec3 normalV;
    vec4 fragColourV;
    flat int waterCheckV;
} gs_in[];

vec4 explode(vec4 position, vec3 normal)
{
    float magnitude = 2.0;
    vec3 direction = normal * ((sin(frameTimeCounter) + 1.0) / 2.0) * magnitude; 
    return position + vec4(direction, 0.0);
} 

out vec2 texCoord;
out vec2 lmCoord;
out vec3 normal;
out vec4 fragColour;
flat out int waterCheck;

layout (triangle_strip, max_vertices = 15) out;

void main() {
    /*
        for (int i = 0; i < 3; i++) {
            texCoord = gs_in[i].texCoordV;
            lmCoord = gs_in[i].lmCoordV;
            normal = gs_in[i].normalV;
            fragColour = gs_in[i].fragColourV;

            gl_Position = gl_in[i].gl_Position;
            EmitVertex();
        }
        */

    // check the first for all

    if (gs_in[0].waterCheckV == 1) {
        vec4 v0 = gl_in[0].gl_Position;
        vec4 v1 = gl_in[1].gl_Position;
        vec4 v2 = gl_in[2].gl_Position;

        for (int i = 0; i < 3; i++) {
            texCoord = gs_in[i].texCoordV;
            lmCoord = gs_in[i].lmCoordV;
            normal = gs_in[i].normalV;
            fragColour = gs_in[i].fragColourV;
            waterCheck = gs_in[i].waterCheckV;

            gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * vec4(worldSpaceVertexPosition + displacement, 1.0);
            EmitVertex();
        }

        EndPrimitive();
    } else {
        for (int i = 0; i < 3; i++) {
            texCoord = gs_in[i].texCoordV;
            lmCoord = gs_in[i].lmCoordV;
            normal = gs_in[i].normalV;
            fragColour = gs_in[i].fragColourV;

            gl_Position = gl_in[i].gl_Position;
            EmitVertex();
        }
        EndPrimitive();

    }
}