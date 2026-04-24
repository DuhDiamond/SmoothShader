#version 330 compatibility

uniform sampler2D gtexture;
uniform float alphaTestRef;

in vec2 texCoord;
in vec4 glColour;

/* RENDERTARGETS: 0 */
layout (location = 0) out vec4 colour;

void main() {
    colour = texture(gtexture, texCoord) * glColour;
    if (colour.a < alphaTestRef) {
        discard;
    }
}