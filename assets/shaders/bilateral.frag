#version 460 core
#include <flutter/runtime_effect.glsl>

// Index 0 & 1 (vec2 takes two slots)
uniform vec2 uSize;
// Index 2
uniform float uSigmaSpatial;
// Index 3
uniform float uSigmaRange;
// Sampler 0
uniform sampler2D uTexture;

out vec4 fragColor;

float gaussian(float x, float sigma) {
    return exp(-(x * x) / (2.0 * sigma * sigma));
}

void main() {
    // Converts the current pixel coordinate to a 0.0 - 1.0 range
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec4 centerCol = texture(uTexture, uv);

    vec3 sum = vec3(0.0);
    float totalWeight = 0.0;
    int radius = 3; // 7x7 kernel

    for (int i = -radius; i <= radius; i++) {
        for (int j = -radius; j <= radius; j++) {
            vec2 offset = vec2(float(i), float(j)) / uSize;
            vec4 neighborCol = texture(uTexture, uv + offset);

            float distSpatial = length(vec2(float(i), float(j)));
            float distRange = length(centerCol.rgb - neighborCol.rgb);

            float weight = gaussian(distSpatial, uSigmaSpatial) *
                           gaussian(distRange, uSigmaRange);

            sum += neighborCol.rgb * weight;
            totalWeight += weight;
        }
    }

    fragColor = vec4(sum / totalWeight, centerCol.a);
}
