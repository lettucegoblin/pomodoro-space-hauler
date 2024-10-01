shader_type canvas_item;

uniform float threshold : hint_range(0.0, 1.0) = 0.3; // Controls how smooth or steep the gradient steps are
uniform float step_width : hint_range(1.0, 100.0) = 20.0; // Controls the number of steps

void fragment() {
    // Get the color from the texture or gradient
    vec4 color = texture(TEXTURE, UV);
    
    // Calculate the luminance (brightness) of the color
    float luminance = dot(color.rgb, vec3(0.3, 0.59, 0.11)); // Standard luminance calculation
    
    // Apply the pixel stepping effect to the luminance
    float stepped_luminance = floor(luminance * step_width) / step_width;

    // Mix the original color with the stepped luminance based on the threshold
    color.rgb = mix(color.rgb, vec3(stepped_luminance), threshold);
    
    // Output the final color
    COLOR = color;
}
