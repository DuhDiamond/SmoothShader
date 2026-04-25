#version 400 compatibility

uniform int renderStage;
uniform float alphaTestRef;
uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D depthtex0;
uniform mat4 gbufferModelViewInverse;

in vec2 texCoordF;
in vec2 lmCoordF;
in vec4 fragColourF;
in vec3 normalF;
flat in int waterCheckF;

/* RENDERTARGETS: 0,1,2 */
layout (location = 0) out vec4 waterColour;
layout (location = 1) out vec4 lightmapData;
layout (location = 2) out vec4 encodedNormal;

void main() {
    if (waterCheckF == 1) {
        // if water
        waterColour = texture(gtexture, texCoordF) * fragColourF;
        waterColour *= texture(lightmap, lmCoordF);
        lightmapData = vec4(lmCoordF, 0.0, 1.0);
        encodedNormal = vec4(normalize(normalF) * 0.5 + 0.5, 1.0);
    } else if (waterCheckF == 0) {
        // if not water
        waterColour = texture(gtexture, texCoordF) * fragColourF;
        waterColour *= texture(lightmap, lmCoordF);
        lightmapData = vec4(lmCoordF, 0.0, 1.0);
        encodedNormal = vec4(normalize(normalF) * 0.5 + 0.5, 1.0);
    } else {
        // if on border of water (interpolated value)
        waterColour = texture(gtexture, texCoordF) * fragColourF;
        waterColour *= texture(lightmap, lmCoordF);
        lightmapData = vec4(lmCoordF, 0.0, 1.0);
        encodedNormal = vec4(normalize(normalF) * 0.5 + 0.5, 1.0);
    }
}