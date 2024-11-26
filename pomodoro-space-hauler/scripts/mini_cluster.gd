extends Node2D
class_name BabyPlanetScene
var cluster: Cluster = null
var tiny_baby_planets: Array[Variant] = []

var  mini_planet_scene: PackedScene
var is_destination: bool = false
var set_is_destination: bool = false

var speed = 1.0 # Speed of movement along the ring


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mini_planet_scene = preload("res://scenes/baby_planet_scene.tscn")
	$Label.text = cluster.get_name()
	for planet in cluster.get_planets():
		$Label2.text += "Planets: \n" + planet.get_name() + ", "
	if $Label2.text != "":
		$Label2.text = $Label2.text.left($Label2.text.length() - 2)
	spawn_planets()
	GameManager.routes_manager.connect("selected_route_updated", Callable(self, "on_selected_route_updated"))
	
func show_planet_labels(show: bool) -> void:
	for planet in tiny_baby_planets:
		planet.planet_instance.show_name_label(show)

func on_selected_route_updated(selected_route_index: int) -> void:
	if selected_route_index == -1: 
		return
	if cluster == GameManager.routes_manager.routes[selected_route_index].ending_cluster():
		is_destination = true
	else:
		is_destination = false

	
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
		planet_instance.set_planet(planet)

		var path_follower = PathFollow2D.new()
		path_follower.rotates = false

		path_follower.add_child(planet_instance)
		ring.add_child(path_follower)

		path_follower.progress_ratio = randf()

		tiny_baby_planets.append({
			"planet": planet,
			"planet_instance": planet_instance,
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

	$FlagSprite2D.visible = is_destination



func _on_label_mouse_entered() -> void:
	show_planet_labels(true)
	#$Label2.visible = true


func _on_label_mouse_exited() -> void:
	show_planet_labels(false)
	#$Label2.visible = false


func _on_label_gui_input(event: InputEvent) -> void:
	print("label gui event") # Replace with function body.
