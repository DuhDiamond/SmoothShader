#version 330 compatibility

uniform int worldTime;
uniform sampler2D shadowtex0;
uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform vec3 relativeEyePosition;
uniform float alphaTestRef;

in vec2 edgeCoordX_l;
in vec2 edgeCoordX_r;
in vec2 edgeCoordY_l;
in vec2 edgeCoordY_r;

in vec2 texCoordF;
in vec2 lmCoordF;
in vec4 fragColourF;
in vec3 normalF;

const float heightScale = 2.0;

/* RENDERTARGETS: 0,1,2,3 */
layout (location = 0) out vec4 outColour0;
layout (location = 1) out vec4 lightmapData;
layout (location = 2) out vec4 encodedNormal;
layout (location = 3) out vec3 heightMap;

void main() {
    vec4 textureData = texture(gtexture, texCoordF);

    lightmapData = vec4(lmCoordF, 0.0, 1.0);
    encodedNormal = vec4(normalF * 0.5 + 0.5, 1.0);
    vec4 lightColour = gl_TextureMatrix[1] * vec4(lmCoordF, 0.0, 0.0);

    vec3 colour = texture(gtexture, texCoordF).xyz;

    float transparency = textureData.a;

    if (transparency < alphaTestRef) {
        discard;
    }
    
    vec3 outputColour = colour * fragColourF.xyz;

    outColour0 = vec4(outputColour, transparency);
}