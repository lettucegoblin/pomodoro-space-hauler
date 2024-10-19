extends Node2D

@export var noise = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.routes_manager.connect("clusters_updated", Callable(self, "_on_clusters_updated"))
	spawn_planets(GameManager.routes_manager.planets)
	

func _on_clusters_updated(updated_clusters: Array) -> void:
	# Clear existing planets
	for child in %planets.get_children():
		child.queue_free()
	#spawn_planets(updated_clusters)

# Spawns planet.tscn instances based on the updated planets data
func spawn_planets(planets_data: Array) -> void:
	var galaxy_size = get_viewport_rect().size
	var min_distance = 100.0
	var planet_positions = []

	for i in range(planets_data.size()):
		var planet_data = planets_data[i]
		var planet_instance = preload("res://scenes/planet.tscn").instantiate()

		var random_x = 0.0
		var random_y = 0.0
		var attempts = 0

		while attempts < 100000:
			# Generate random coordinates based on noise
			random_x = (noise.get_noise_2d(i * 10.0, i * 20.0) + 1.0) * 0.5 * galaxy_size.x
			random_y = (noise.get_noise_2d(i * 15.0, i * 25.0) + 1.0) * 0.5 * galaxy_size.y
			
			# Get a noise value to decide if a planet should be placed at this location
			var noise_value = noise.get_noise_2d(random_x, random_y)

			# Only place the planet if the noise value is within a certain range
			if noise_value > -0.2 and noise_value < 0.2:
				var valid_position = true

				# Check if the new position is far enough from existing planets
				for pos in planet_positions:
					if pos.distance_to(Vector2(random_x, random_y)) < min_distance:
						valid_position = false
						break

				if valid_position:
					planet_positions.append(Vector2(random_x, random_y))
					break

			attempts += 1

		planet_instance.position = Vector2(random_x, random_y)
		%planets.add_child(planet_instance)
