#version 330 compatibility

uniform int renderStage;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 skyColor;
uniform vec3 fogColor;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform vec2 gl_FragCoord;

in vec4 glColour;

/* RENDERTARGETS: 0 */
layout (location = 0) out vec4 colour;

float fogify(float x, float w) {
    return w / (x*x + w);
}

vec3 calcSkyColour(vec3 pos) {
    float upDot = dot(pos, gbufferModelView[1].xyz);
    return mix(skyColor, fogColor, fogify(max(upDot, 0.0), 0.25));
}

vec3 screenToView(vec3 screenPos) {
    vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
    vec4 tmp = gbufferProjectionInverse * ndcPos;
    return tmp.xyz / tmp.w;
}

void main() {
    if (renderStage == MC_RENDER_STAGE_STARS) {
        colour = glColour;
    } else {
        vec3 pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
        colour = vec4(calcSkyColour(normalize(pos)), 1.0);
    }
}