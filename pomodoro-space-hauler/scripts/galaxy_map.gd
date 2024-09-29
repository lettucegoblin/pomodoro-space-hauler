extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.routes_manager.connect("planets_updated", Callable(self, "_on_planets_updated"))
	#spawn_planets(GameManager.routes_manager.planets)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_planets_updated(updated_planets: Array) -> void:
	# Handle updated planets data
	print("Planets updated:", updated_planets)
	# clear existing planets
	for child in %planets.get_children():
		child.queue_free()
	spawn_planets(updated_planets)

# Spawns planet.tscn instances based on the updated planets data
func spawn_planets(planets_data: Array) -> void:
	# Get the size of the galaxy map container or parent node
	var galaxy_size = get_viewport_rect().size # or self.rect_size if it's a Control node

	for planet_data in planets_data:
		var planet_instance = preload("res://scenes/planet.tscn").instantiate()

		# Randomly position the planet within the bounds of the galaxy map
		var random_x = randi_range(0, galaxy_size.x)
		var random_y = randi_range(0, galaxy_size.y)
		planet_instance.position = Vector2(random_x, random_y)

		%planets.add_child(planet_instance)
