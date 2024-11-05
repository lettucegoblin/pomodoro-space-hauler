extends Node2D

var planet: Planet = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_name_label(false)
	$PlanetSprite2D.material = $PlanetSprite2D.material.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_planet(p_planet: Planet) -> void:
	planet = p_planet
	$PlanetNameLabel.text = p_planet.get_name()
	set_planet_color(p_planet.get_color())
	set_planet_pulse_intensity(0.5)
	set_planet_size(p_planet.size)

func show_name_label(visible: bool) -> void:
	$PlanetNameLabel.visible = visible

func set_planet_color(color: Color) -> void:
	# change shader color
	$PlanetSprite2D.material.set_shader_parameter("color", color)
	
func set_planet_pulse_intensity(intensity: float) -> void:
	$PlanetSprite2D.material.set_shader_parameter("pulse_intensity", intensity)

func set_planet_size(size: float) -> void:
	# change normalize size(0.5 to 1.0) to (0.05 to 0.15)
	size = size * 0.1 + 0.05
	$PlanetSprite2D.scale = Vector2(size, size)
