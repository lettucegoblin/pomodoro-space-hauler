shader_type canvas_item;

uniform float planet_size : hint_range(0.1, 1.0) = 1.0; // Controls the size of the planet
uniform vec4 planet_color : source_color = vec4(0.0, 0.8, 0.4, 1.0); // RGBA color for the planet land
uniform vec4 water_color : source_color = vec4(0.0, 0.3, 0.8, 1.0); // RGBA color for the water
uniform sampler2D noise_texture : hint_normal; // Perlin noise texture input
uniform float land_water_threshold : hint_range(0.0, 1.0) = 0.5; // Threshold for land/water division
uniform vec2 noise_scale = vec2(5.0, 5.0); // Scale for the noise texture

void fragment() {
    // UV coordinates to center the circle
    vec2 uv = UV;
    uv = uv * 2.0 - 1.0; // Normalize UV to [-1, 1]

    // Calculate distance from the center
    float dist_from_center = length(uv);

    // Set the radius based on the planet_size uniform
    float radius = planet_size;

    // Draw a circle: inside the radius is the planet, outside is transparent
    if (dist_from_center < radius) {
        // Convert the normalized UV coordinates back into [0, 1] range for texture sampling
        vec2 tex_uv = (uv + 1.0) * 0.5;

        // Sample the noise texture and scale UVs to control how the noise looks
        float noise_value = texture(noise_texture, tex_uv * noise_scale).r;

        // Determine whether the area is land or water based on the threshold
        vec4 final_color = mix(water_color, planet_color, step(land_water_threshold, noise_value));

        COLOR = final_color; // Use the final color based on noise
    } else {
        discard; // Transparent outside the circle
    }
}
