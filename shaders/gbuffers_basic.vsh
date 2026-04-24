#version 330 compatibility

uniform mat4 gbufferModelView;

out vec2 texCoord;
out vec3 terrainColour;

void main() {
    terrainColour = gl_Color.rgb;
    texCoord = gl_MultiTexCoord0.xy;

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}