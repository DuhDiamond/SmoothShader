#version 330 compatibility

uniform sampler2D gtexture;

/* DRAWBUFFERS: 0 */
layout (location = 0) out vec4 outColour0;

in vec2 texCoord;
in vec3 terrainColour;
in vec4 shadowColour;

void main() {
    vec4 outputColourData = texture(gtexture, texCoord);
    vec3 outputColour = outputColourData.rgb * terrainColour;
    float transparency = outputColourData.a;


    if (transparency < 0.1) {
        discard;
    }

    outColour0 = vec4(outputColour, transparency);
}