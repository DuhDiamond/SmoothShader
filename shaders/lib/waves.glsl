#ifndef wave_glsl
#define wave_glsl

uniform float frameTimeCounter;
uniform vec3 cameraPosition;

const vec2 dir1 = vec2(0.1, 0.2);
const vec2 dir2 = vec2(-0.3, 0.5);
const vec2 dir3 = vec2(0.6, -0.3);

// time, speed, steepness, amplitude, wavelength
vec3 gerstner(vec3 vertex, vec2 direction, float time, float speed, float steepness, float amplitude, float wavelength) {
    // float displaced_x = (steepness/wavelength) * direction.x * cos(wavelength * dot(direction, vertex.xz) + speed * time);
    // float displaced_z = (steepness/wavelength) * direction.y * cos(wavelength * dot(direction, vertex.xz) + speed * time);
    float displaced_x = 0.0;
    float displaced_z = 0.0;
    float displaced_y = amplitude * sin(wavelength * dot(direction, vertex.xz) + speed * time);
    displaced_y = max(0.0, displaced_y);
    return vec3(displaced_x, displaced_y, displaced_z);
}

vec3 globalDisplacement = vec3(0.0, -0.5, 0.0);

float wave1_speed = 0.5;
float wave1_steepness = 0.3;
float wave1_amplitude = 0.4;
float wave1_wavelength = 2.0;

float wave2_speed = 1.3;
float wave2_steepness = 1.0;
float wave2_amplitude = 0.3;
float wave2_wavelength = 0.5;

float wave3_speed = 0.3;
float wave3_steepness = 0.2;
float wave3_amplitude = 0.5;
float wave3_wavelength = 0.3;

vec3 gerstner_normal(vec3 vertex, vec2 direction, float time, float speed, float steepness, float amplitude, float wavelength) {
    float cosfactor = cos(wavelength * dot(direction, vertex.xz + speed * time));
    float sinfactor = sin(wavelength * dot(direction, vertex.xz + speed * time));
    // float x_normal = -direction.x * wavelength * amplitude * cosfactor;
    // float z_normal = -direction.y * wavelength * amplitude * cosfactor;
    
    float x_normal = 0.0;
    float z_normal = 0.0;
    float y_normal = 1.0 - (steepness/wavelength) * wavelength * amplitude * sinfactor;
    return vec3(x_normal, y_normal, z_normal);
}

#endif