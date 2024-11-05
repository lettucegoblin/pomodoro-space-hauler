shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float pulse_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {

	if (COLOR.a < 0.1) {
		discard;
	}
	float pulse = abs(sin(TIME)) * pulse_intensity;
	vec3 c = color.rgb + pulse;
	COLOR = vec4(c.rgb, 1.0);
}

