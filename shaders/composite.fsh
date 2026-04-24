#version 330 compatibility

#include "lib/distort.glsl"

in vec2 texCoord;

uniform int blockEntityId;
uniform sampler2D depthtex0;
uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D gtexture;

uniform vec3 sunPosition;
uniform int worldTime;
uniform float viewHeight;
uniform float viewWidth;
uniform sampler2D shadowtex0;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

const vec3 blocklightColour = vec3(1.0, 0.5, 0.08);
const vec3 skylightColour = vec3(0.05, 0.15, 0.3);
const vec3 sunlightColour = vec3(1.0);
const vec3 ambientColour = vec3(0.1);
uniform vec3 shadowLightPosition;

vec3 projectAndDivide(mat4 projectionMatrix, vec3 position) {
    vec4 homPos = projectionMatrix * vec4(position, 1.0);
    return homPos.xyz / homPos.w;
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
    gridCoord.x -= mod(gridCoord.x, 20.0 / viewWidth);
    gridCoord.y -= mod(gridCoord.y, 20.0 / viewHeight);

    float depth = texture(depthtex0, texCoord).r;
    
    /*
    if (depth == 1.0) {
        return;
    }
    */


    vec3 sunDirection = 0.01 * sunPosition;
    float timeColour = derivativeOfSigmoid(worldTime);
    colour = texture(colortex0, texCoord);
    colour.rgb = pow(colour.rgb, vec3(2.2));

    vec3 NDCPos = vec3(texCoord.xy, depth) * 2.0 - 1.0;
    vec3 viewPos = projectAndDivide(gbufferProjectionInverse, NDCPos);
    vec3 feetPlayerPos = (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
    vec3 shadowViewPos = (shadowModelView * vec4(feetPlayerPos, 1.0)).xyz;
    vec4 shadowClipPos = shadowProjection * vec4(shadowViewPos, 1.0);
    shadowClipPos.z -= 0.001;
    shadowClipPos.xyz = distortShadowClipPos(shadowClipPos.xyz);
    vec3 shadowNDCPos = shadowClipPos.xyz / shadowClipPos.w;
    vec3 shadowScreenPos = shadowNDCPos * 0.5 + 0.5;

    float shadow = step(shadowScreenPos.z, texture(shadowtex0, shadowScreenPos.xy).r);

    vec2 lightmap = texture(colortex1, texCoord).rg; // only need r and g components
    vec3 encodedNormal = texture(colortex2, texCoord).rgb;
    vec3 normal = normalize((encodedNormal - 0.5) * 2.0); // converting back and normalizing to ensure it's unit length

    vec3 blocklight = lightmap.r * blocklightColour;
    vec3 skylight = lightmap.g * skylightColour;
    vec3 ambient = ambientColour;

    vec3 lightVector = normalize(shadowLightPosition);
    vec3 worldLightVector = mat3(gbufferModelViewInverse) * lightVector;
    vec3 sunlight = sunlightColour * clamp(dot(worldLightVector, normal), 0.0, 1.0) * shadow;

    colour.rgb *= blocklight + skylight + ambient + sunlight;
}