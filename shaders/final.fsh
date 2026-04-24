#version 330 compatibility

in vec2 texCoord;

uniform sampler2D colortex0;
uniform vec3 sunPosition;
uniform int worldTime;
uniform float viewHeight;
uniform float viewWidth;
uniform vec3 playerLookVector;
uniform mat4 gbufferModelView;

in vec3 heightMap;

uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;

uniform sampler2D depthtex0;
uniform sampler2D shadowtex0;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

const float heightScale = 1.0;

/*
const int colortex0Format = RGB16;
*/

vec2 ParallaxMapping(vec2 texCoords, vec3 viewDir, vec3 heightMap) {
    vec2 p = viewDir.xy / viewDir.z * (heightMap.x * heightScale);
    return texCoords - p;
}

/* RENDERTARGETS: 0 */
layout (location = 0) out vec4 colour;

float derivativeOfSigmoid(float x) {
    // Time representing length of a day
    float peakOfDay = 23999/2;
    // Gaussian centered at peakOfDay, and stretching out from 0 to peakOfDay*2
    float a = 2 * (x - peakOfDay) / (peakOfDay);
    return pow(2.718, -(a * a));
}

void main() {

    vec2 gridCoord = texCoord;
    // gridCoord.x -= mod(gridCoord.x, 6.0 / viewWidth);
    // gridCoord.y -= mod(gridCoord.y, 6.0 / viewHeight);

    vec3 sunDirection = 0.01 * sunPosition;
    float timeColour = derivativeOfSigmoid(worldTime);

    vec3 heightMap = texture(colortex3, texCoord).rgb;

    vec3 viewDir = playerLookVector;
    vec2 mappedCoord = ParallaxMapping(texCoord, viewDir, heightMap);

    colour = texture(colortex0, texCoord);
    
    colour.rgb = pow(colour.rgb, vec3(1/2.2));
}