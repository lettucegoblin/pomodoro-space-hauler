extends Sprite2D

@export var planet_color: Color = Color(0.0, 0.8, 0.4, 1.0)
@export var water_color: Color = Color(0.0, 0.3, 0.8, 1.0)
@export var light_angle: float = 180.0
@export var scroll_speed: float = 0.1

# Initialize the setters in _ready
func _ready() -> void:
	set_planet_color(planet_color)
	set_water_color(water_color)
	set_light_angle(light_angle)
	set_scroll_speed(scroll_speed)

# Setter methods for each shader parameter
func set_planet_color(new_color: Color) -> void:
	material.set_shader_parameter("planet_color", new_color)

func set_water_color(new_color: Color) -> void:
	material.set_shader_parameter("water_color", new_color)

func set_light_angle(new_angle: float) -> void:
	material.set_shader_parameter("light_angle", new_angle)

func set_scroll_speed(new_speed: float) -> void:
	material.set_shader_parameter("scroll_speed", new_speed)
