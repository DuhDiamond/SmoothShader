#version 330 compatibility

layout (triangles) in;

#include "wave.glsl"

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform vec3 playerLookVector;
uniform sampler2D gtexture;
uniform sampler2D noisetex;

in VS_OUT {
    in vec2 texCoordV;
    in vec2 lmCoordV;
    in vec4 fragColourV;
    in vec3 normalV;
} gs_in[];

vec4 explode(vec3 position, vec3 normal, vec2 texCoord, float i, float j, float n)
{
    vec2 t = (cameraPosition + position).xy;
    vec3 exploded = position + 0.3 * texture(noisetex, t - floor(t)).xyz * normal * vec3(-0.4, 0.7, -0.4);
    return vec4(exploded, 1.0);
} 

out vec2 texCoord;
out vec2 lmCoord;
out vec3 normal;
out vec4 fragColour;

void emitAt(vec3 pos, int a, int b, int n) {
    float i = float(a);
    float j = float(b);
    float iter = float(n);
    float w0 = 1.0 - i/iter - j/iter;
    float w1 = i/iter;
    float w2 = j/iter;

    texCoord = w0 * gs_in[1].texCoordV + w1 * gs_in[0].texCoordV + w2 * gs_in[2].texCoordV;
    lmCoord = w0 * gs_in[1].lmCoordV + w1 * gs_in[0].lmCoordV + w2 * gs_in[2].lmCoordV;
    normal = w0 * gs_in[1].normalV + w1 * gs_in[0].normalV + w2 * gs_in[2].normalV;
    fragColour = w0 * gs_in[1].fragColourV + w1 * gs_in[0].fragColourV + w2 * gs_in[2].fragColourV;
    
    vec4 final = vec4(pos, 1.0);

    if (((a != 0) && (b != 0)) && (i != n) && (j != n)) {
        final = explode(pos, normal, texCoord, i, j, iter);
        // normal = normal + explode(pos, normal, texCoord, i, j, iter).xyz;
    }

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * final;
    EmitVertex();
}

layout (triangle_strip, max_vertices = 64) out;

void main() {
    vec3 v1 = gl_in[0].gl_Position.xyz;
    vec3 v0 = gl_in[1].gl_Position.xyz;
    vec3 v2 = gl_in[2].gl_Position.xyz;

    float iter = 16.0;
    int n = int(sqrt(iter));
    vec3 stepU = (v1.xyz - v0.xyz)/sqrt(iter);
    vec3 stepV = (v2.xyz - v0.xyz)/n;

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            vec3 a = v0 + (i) * stepU + (j) * stepV;
            vec3 b = v0 + (i + 1) * stepU + (j) * stepV;
            vec3 c = v0 + i * stepU + (j + 1) * stepV;
            vec3 d = v0 + (i + 1) * stepU + (j + 1) * stepV;

            emitAt(a, i, j, n);
            emitAt(c, i, j + 1, n);
            emitAt(b, i + 1, j, n);
            EndPrimitive();

            if (j + i < n - 1) {
                emitAt(b, i + 1, j, n);
                emitAt(c, i, j + 1, n);
                emitAt(d, i + 1, j + 1, n);
                EndPrimitive();
            }
        }
    }
}