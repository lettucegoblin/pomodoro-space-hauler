extends Node2D

var planet_data: Planet
@export var planet_color: Color
@export var water_color: Color 
@export var light_angle: float
@export var scroll_speed: float
@export var shader: ShaderMaterial
@export var large_view: bool = false

func set_large_view(is_large: bool) -> void:
	if is_large:
		scale = Vector2(8, 8)
	else:
		scale = Vector2(1, 1)

# Initialize the setters in _ready
func _ready() -> void:
	shader = $Sprite2D.material
	#debug()
	%PlanetName.text = planet_data.get_name()
	
	#set_planet_color(planet_color)
	#set_water_color(water_color)
	#set_light_angle(light_angle)
	#set_scroll_speed(scroll_speed)

func debug() -> void:
	print("Planet Scene Debug")
	planet_data = Planet.new("Test Planet", null)
	planet_data.resources = ["Test Resource"]
	planet_data.special_features = ["Test Feature"]
	planet_data.hazards = ["Test Hazard"]
	planet_data.trade_goods = ["Test Trade Good"]
	# from hex ffff00
	planet_data.color = Color("ffff00")
	planet_data.size = 1.0
	set_planet(planet_data)

func set_planet(p_planet: Planet) -> void:
	planet_data = p_planet
	%PlanetName.text = p_planet.get_name()
	planet_color = p_planet.get_color()
	set_planet_color(p_planet.get_color())
	# Generate and set an accent color for water
	var accent_water_color := Color(planet_color)
	accent_water_color = hue_shift(accent_water_color, 0.06) # Shift the hue by 0.1 (36 degrees)
	accent_water_color = accent_water_color.darkened(0.2)
	
	print("accent_water_color ", accent_water_color.to_html())
	
	
	set_water_color(accent_water_color)

	# set shadow color to a darker version of the planet color
	var shadow_color := Color(planet_color)
	shadow_color = hue_shift(shadow_color, 0.5) # Shift the hue by 0.5 (180 degrees)
	shadow_color = Color.from_hsv(shadow_color.h, shadow_color.s, 0.2)
	set_shadow_color(shadow_color)
	print("shadow_color ", shadow_color.to_html())

	# set planet size
	set_planet_size(p_planet.get_size())

	#set_water_color(p_planet.get_color())
	#set_light_angle(0.0)
	#set_scroll_speed(0.0)

func hue_shift(color: Color, shift: float) -> Color:
	var h = color.h
	var s = color.s
	var v = color.v
	
	h += shift
	if h > 1.0:
		h -= 1.0
	elif h < 0.0:
		h += 1.0
	return Color.from_hsv(h, s, v)
	
func get_accent_color(base_color: Color) -> Color:
	var accent_color := base_color.lightened(0.1)  # Lighten the color by 20%
	accent_color.s -= 0.2    # Reduce saturation for a more subtle tone
	return accent_color

# Setter methods for each shader parameter
func set_planet_color(new_color: Color) -> void:
	$Sprite2D.material.set_shader_parameter("planet_color", new_color)

func set_shadow_color(new_color: Color) -> void:
	$Sprite2D.material.set_shader_parameter("shadow_color", new_color)

func set_water_color(new_color: Color) -> void:
	$Sprite2D.material.set_shader_parameter("water_color", new_color)

func set_light_angle(new_angle: float) -> void:
	$Sprite2D.material.set_shader_parameter("light_angle", new_angle)

func set_scroll_speed(new_speed: float) -> void:
	$Sprite2D.material.set_shader_parameter("scroll_speed", new_speed)

func set_planet_size(new_size: float) -> void:
	$Sprite2D.material.set_shader_parameter("planet_size", new_size)
