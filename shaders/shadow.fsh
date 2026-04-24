#version 330 compatibility

const int shadowMapResolution = 2048;
const float shadowDistanceRenderMul = 1.0;

uniform sampler2D gtexture;

in vec2 texCoord;
in vec4 glColour;

layout (location = 0) out vec4 shadowColour;

void main() {
    shadowColour = texture(gtexture, texCoord) * glColour;
    if (shadowColour.a < 0.1) {
        discard;
    }
}