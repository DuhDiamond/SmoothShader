#version 330 compatibility

in vec2 mc_midTexCoord;

uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;

uniform sampler2D gtexture;

out vec2 texCoordF;
out vec2 lmCoordF;
out vec4 fragColourF;
out vec3 normalF;

out vec2 edgeCoordX_l;
out vec2 edgeCoordX_r;
out vec2 edgeCoordY_l;
out vec2 edgeCoordY_r;

void main() {
    texCoordF = (gl_TextureMatrix[0] * (gl_MultiTexCoord0)).xy;
    
    lmCoordF = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    lmCoordF = lmCoordF / (30.0 / 32.0) - (1.0 / 32.0);

    fragColourF = gl_Color;

    normalF = gl_NormalMatrix * gl_Normal;
    normalF = normalize(mat3(gbufferModelViewInverse) * normalF);

    // float distanceFromCamera = distance(worldSpaceVertexPosition, cameraPosition);

    vec2 texSize = 2.0*abs(texCoordF - mc_midTexCoord);
    vec2 offset = vec2(1.0);
    vec2 pixelOffset = 1.0/textureSize(gtexture, 0);

    edgeCoordX_l = texCoordF;
    edgeCoordX_r = texCoordF;
    edgeCoordX_l.x = clamp(texCoordF.x - offset.x*pixelOffset.y, mc_midTexCoord.x - texSize.x/2.0, mc_midTexCoord.x + texSize.x/2.0);
    edgeCoordX_r.x = clamp(texCoordF.x + offset.x*pixelOffset.y, mc_midTexCoord.x - texSize.x/2.0, mc_midTexCoord.x + texSize.x/2.0);

    edgeCoordY_l = texCoordF;
    edgeCoordY_r = texCoordF;
    edgeCoordY_l.y = clamp(texCoordF.y - offset.y*pixelOffset.y, mc_midTexCoord.y - texSize.y/2.0, mc_midTexCoord.y + texSize.y/2.0);
    edgeCoordY_r.y = clamp(texCoordF.y + offset.y*pixelOffset.y, mc_midTexCoord.y - texSize.y/2.0, mc_midTexCoord.y + texSize.y/2.0);

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}