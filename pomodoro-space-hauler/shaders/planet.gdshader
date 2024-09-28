shader_type canvas_item;

uniform float planet_size : hint_range(0.1, 1.0) = 1.0; // Controls the size of the planet
uniform vec4 planet_color : source_color = vec4(0.0, 0.8, 0.4, 1.0); // RGBA color for the planet land
uniform vec4 water_color : source_color = vec4(0.0, 0.3, 0.8, 1.0); // RGBA color for the water
uniform sampler2D noise_texture : hint_normal; // Perlin noise texture input
uniform float land_water_threshold : hint_range(0.0, 1.0) = 0.5; // Threshold for land/water division
uniform vec2 noise_scale = vec2(5.0, 5.0); // Scale for the noise texture
uniform vec2 scroll_direction = vec2(1.0, 0.0); // Direction to move the texture (1, 0) for right, (-1, 0) for left
uniform float scroll_speed : hint_range(0.0, 10.0) = 1.0; // Speed of the texture movement

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

        // Apply quadratic warp to the x-coordinate based on the equation x^2 / 100
        tex_uv.y += pow(uv.x + 0.3, 2.0) / 10.0;

        // Add scrolling based on direction and time
        float offset = TIME * scroll_speed;
        tex_uv += scroll_direction * offset;

        // Wrap the UV coordinates to keep them within [0, 1]
        tex_uv = fract(tex_uv);

        // Sample the noise texture and scale UVs to control how the noise looks
        float noise_value = texture(noise_texture, tex_uv * noise_scale).r;

        // Determine whether the area is land or water based on the threshold
        vec4 final_color = mix(water_color, planet_color, step(land_water_threshold, noise_value));

        COLOR = final_color; // Use the final color based on noise
    } else {
        discard; // Transparent outside the circle
    }
}
