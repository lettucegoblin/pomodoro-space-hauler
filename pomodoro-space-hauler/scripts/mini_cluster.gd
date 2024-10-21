extends Node2D
class_name BabyPlanetScene
var cluster: Cluster = null
var tiny_baby_planets: Array[Variant] = []

var mini_planet_scene: PackedScene

var speed = 1.0 # Speed of movement along the ring


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mini_planet_scene = preload("res://scenes/baby_planet_scene.tscn")
	$Label.text = cluster.get_name() + ": "
	for planet in cluster.get_planets():
		$Label2.text += planet.get_name() + ", "
	spawn_planets()
	
func spawn_planets() -> void:
	# clear existing planets
	for sprite in tiny_baby_planets:
		sprite.queue_free()
	
	for i in range(cluster.planets.size()):
		var planet = cluster.planets[i]
		var radius = 10 * (i + 1) # Increase the radius for each ring
		create_planet_with_path(radius, planet)


func create_planet_with_path(radius: float, planet: Planet) -> void:
		var ring = Path2D.new()

		ring.set("radius", radius)

		var curve = Curve2D.new()
		var resolution = 360
		for i in range(resolution):
				var angle = 2 * PI * i / resolution
				var x = radius * cos(angle)  #wow ok physics moment doobie doobie doo
				var y = radius * sin(angle)  
				curve.add_point(Vector2(x, y))

		ring.curve = curve
		add_child(ring)

		# Now add PathFollow2D for the planet
		var planet_instance = mini_planet_scene.instantiate()
		#planet_instance.planet = planet

		var path_follower = PathFollow2D.new()
		path_follower.rotates = false

		path_follower.add_child(planet_instance)
		ring.add_child(path_follower)

		path_follower.progress_ratio = randf()

		tiny_baby_planets.append({
			"planet": planet,
			"ring": ring,
			"path_follower": path_follower,
			"radius": radius
		})

		#path_follower.set_offset(randf())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for planet in tiny_baby_planets:
		var ring_speed = planet.radius / 500.0

		if planet.path_follower is PathFollow2D:
			planet.path_follower.progress_ratio += delta * speed * ring_speed


func _on_label_mouse_entered() -> void:
	$Label2.visible = true


func _on_label_mouse_exited() -> void:
	$Label2.visible = false