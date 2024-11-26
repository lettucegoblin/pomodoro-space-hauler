shader_type canvas_item;

uniform float planet_size : hint_range(0.1, 1.0) = 1.0; // Controls the size of the planet
uniform vec4 planet_color : source_color = vec4(0.0, 0.8, 0.4, 1.0); // RGBA color for the planet land
uniform vec4 water_color : source_color = vec4(0.0, 0.3, 0.8, 1.0); // RGBA color for the water
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Shadow color
uniform float shadow_transparency : hint_range(0.0, 1.0) = 0.5; // Controls shadow transparency
uniform sampler2D noise_texture : hint_normal; // Perlin noise texture input
uniform float land_water_threshold : hint_range(0.0, 1.0) = 0.5; // Threshold for land/water division
uniform vec2 noise_scale = vec2(1.0, 1.0); // Scale for the noise texture
uniform vec2 scroll_direction = vec2(1.0, 0.0); // Direction to move the texture (1, 0) for right, (-1, 0) for left
uniform float scroll_speed : hint_range(0.01, 0.2) = 0.1; // Speed of the texture movement

// Lighting parameters
uniform float light_angle : hint_range(140.0, 220.0) = 180.0; // Light direction angle in degrees
uniform float day_night_cycle_speed : hint_range(0.2, 1.0) = 0.6; // Speed of day/night cycle
uniform float rim_light_intensity : hint_range(0.0, 1.0) = 0.8; // Intensity of the rim light
uniform float thin_rim_intensity : hint_range(0.0, 0.2) = 0.1; // Intensity of the thin rim light

// Helper function to shift the UV and avoid calculations directly at the origin
vec2 shift_uv(vec2 uv, float offset) {
    return uv + vec2(offset); // Shift the UV away from the origin
}

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
        // Shift UV coordinates to avoid issues at origin (0, 0)
        vec2 shifted_uv = shift_uv(uv, 1.0); // Small offset to avoid singularity at the origin

        // Convert the normalized shifted UV coordinates back into [0, 1] range for texture sampling
        vec2 tex_uv = (shifted_uv + 1.0) * 0.5;

        // Apply quadratic warp to the x-coordinate based on the equation x^2 / 10
        tex_uv.y += pow(shifted_uv.x + 0.3, 2.0) / 10.0;

        // Add scrolling based on direction and time
        float offset = TIME * scroll_speed;
        tex_uv += scroll_direction * offset;

        // Wrap the UV coordinates to keep them within [0, 1]
        tex_uv = fract(tex_uv);

        // Sample the noise texture and scale UVs to control how the noise looks
        float noise_value = texture(noise_texture, tex_uv * noise_scale).r;

        // Determine whether the area is land or water based on the threshold
        vec4 final_color = mix(water_color, planet_color, step(land_water_threshold, noise_value));

        // Lighting calculations
        // Convert light_angle from degrees to radians for trigonometric functions
        float light_angle_rad = radians(light_angle);
        // Create a light direction vector using cosine and sine of the angle
        vec2 light_dir = vec2(cos(light_angle_rad), sin(light_angle_rad));

        // Calculate spherical lighting intensity
        float light_intensity = dot(normalize(shifted_uv), light_dir);

        // Apply a curvature effect, but avoid issues at the origin by using shifted UVs
        float curved_shadow = length(shifted_uv);
        light_intensity *= mix(1.0, curved_shadow, 0.6); // Curved shadow effect

        // Add day/night cycle based on time
        float time_offset = sin(TIME * day_night_cycle_speed) + 0.8;
        light_intensity += time_offset;

        // Apply the main rim light (broad, subtle glow)
        float rim_light = smoothstep(0.0, 0.9, light_intensity) * rim_light_intensity;

        // Thin rim light for the bright edge, calculated only at the very outer edge of the planet
        float thin_rim = smoothstep(0.9, 1.0, dist_from_center) * thin_rim_intensity * step(0.0, light_intensity);

        // Blend the shadow with the final color
        vec3 shadow_blend = mix(final_color.rgb, shadow_color.rgb, shadow_transparency * (1.0 - light_intensity));

        // Apply final lighting and shadow (combine rim light and thin rim light)
        final_color.rgb = mix(shadow_blend, final_color.rgb, 0.5) * clamp(light_intensity + rim_light + thin_rim, 0.2, 0.9);

        COLOR = final_color; // Use the final color with lighting applied
    } else {
        discard; // Transparent outside the circle
    }
}
