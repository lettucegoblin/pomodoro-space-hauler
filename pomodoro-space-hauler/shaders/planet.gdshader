shader_type canvas_item;

uniform float planet_size : hint_range(0.1, 1.0) = 1.0; // Controls the size of the planet
uniform vec4 planet_color : source_color = vec4(0.0, 0.8, 0.4, 1.0); // RGBA color for the planet

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
        COLOR = planet_color; // Use the uniform color
    } else {
        discard; // Transparent outside the circle
    }
}
