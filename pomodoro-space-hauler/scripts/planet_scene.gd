extends Node2D

var planet_data: Planet
@export var planet_color: Color
@export var water_color: Color 
@export var light_angle: float
@export var scroll_speed: float
@export var shader: ShaderMaterial

# Initialize the setters in _ready
func _ready() -> void:
	shader = $Sprite2D.material
	%PlanetName.text = planet_data.get_name()
	#set_planet_color(planet_color)
	#set_water_color(water_color)
	#set_light_angle(light_angle)
	#set_scroll_speed(scroll_speed)

func set_planet(p_planet: Planet) -> void:
	planet_data = p_planet
	%PlanetName.text = p_planet.get_name()
	set_planet_color(p_planet.get_color())
	#set_water_color(p_planet.get_color())
	#set_light_angle(0.0)
	#set_scroll_speed(0.0)

# Setter methods for each shader parameter
func set_planet_color(new_color: Color) -> void:
	$Sprite2D.material.set_shader_parameter("planet_color", new_color)

func set_water_color(new_color: Color) -> void:
	$Sprite2D.material.set_shader_parameter("water_color", new_color)

func set_light_angle(new_angle: float) -> void:
	$Sprite2D.material.set_shader_parameter("light_angle", new_angle)

func set_scroll_speed(new_speed: float) -> void:
	$Sprite2D.material.set_shader_parameter("scroll_speed", new_speed)
