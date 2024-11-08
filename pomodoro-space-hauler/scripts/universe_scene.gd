extends Node2D

class_name UniverseScene

var rings: Array[Variant] = []

var mini_cluster_scene: PackedScene
var speed = 0.05 # Speed of movement along the ring
var clusters: Array[Cluster] = []
var selected_route_index: int = -1
var path_lines: Array[Line2D] = []

@onready var center_of_universe = $CenterOfUniverse # A node that acts as the center  (ps- there is no real center of the universe since every point can be considered the center of the universe - prove me wrong)

# You can set the mini-cluster PackedScene in the editor or load it dynamically
func _ready():
	# set the center of the universe at the center of the viewport
	center_of_universe.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	mini_cluster_scene = preload("res://scenes/MiniCluster.tscn")
	# subscribe to selected_clusters_updated
	GameManager.routes_manager.connect("selected_route_updated", Callable(self, "on_selected_route_updated"))
	#spawn_test_rings()

func on_selected_route_updated(_selected_route: int) -> void:
	selected_route_index = _selected_route
	

# use Cluster.CLUSTERGRID wplhich is a 2d array of clusters to create rings
# clusters in the same row are on the same ring
func spawn_clusters_universe() -> void:
	# Clear existing rings
	for ring in rings:
		ring.ring.queue_free()

	for i in range(Cluster.CLUSTERGRID.size()):
		var cluster_row: Array[Cluster] = Cluster.GET_CLUSTERGRID_ROW(i)
		var num_clusters = cluster_row.size()
		var radius = 100 * (i + 1) # Increase the radius for each ring
		create_ring_with_path(radius, cluster_row, num_clusters)

func create_ring_with_path(radius: float, cluster_row: Array[Cluster], num_clusters: int) -> void:
		var ring = Path2D.new()
		
		# add line2d to show the path
		var line = Line2D.new()
		ring.add_child(line)
		
		
		ring.position = center_of_universe.position

		ring.set("radius", radius)
		
		# Create a curve for the Path2D
		var curve = Curve2D.new()
		var points = []
		var resolution = 360
		for i in range(resolution):
				var angle = 2 * PI * i / resolution
				var x = radius * cos(angle)  #wow ok physics moment doobie doobie doo
				var y = radius * sin(angle)
				curve.add_point(Vector2(x, y))
				points.append(Vector2(x, y))
		
		ring.curve = curve
		add_child(ring)

		line.default_color = Color(1, 1, 1)
		line.width = 1
		line.points = points


		# Now add PathFollow2D for each mini-cluster
		for i in range(num_clusters):
				if(cluster_row[i] == null):
						continue
				var cluster_instance = mini_cluster_scene.instantiate()
				cluster_instance.cluster = cluster_row[i]
				
				cluster_row[i].mini_cluster_instance = cluster_instance
				
				var path_follower = PathFollow2D.new()   # PathFollow2D is a node that follows a path
				path_follower.rotates = false

				# Place the mini-cluster along the path
				
				path_follower.add_child(cluster_instance)
				ring.add_child(path_follower)
				path_follower.progress_ratio = float(i) / float(num_clusters) # Distribute evenly along the path
				print(float(i) / float(num_clusters))
		rings.append({
				"ring": ring,
				"num_clusters": num_clusters,
				"radius": radius
		})

func clear_lines() -> void:
	for line in path_lines:
		line.queue_free()
	path_lines.clear()


func draw_line_between_clusters(delta: float, cluster1: Cluster, cluster2: Cluster) -> void:
	# Draw the line between clusters with the animated gradient
	var line = Line2D.new()

	line.width = 1
	line.points = [
		cluster1.mini_cluster_instance.global_position, 
		cluster1.mini_cluster_instance.global_position / 2 + cluster2.mini_cluster_instance.global_position / 2,
		cluster2.mini_cluster_instance.global_position
		]
	
	var gradient = Gradient.new()
	var color_val = (sin(time_passed * 5.2) + 1) / 2  # oscillates between 0 and 1
	var phase_shift = 2 * PI / 3  # A phase shift to create the rotating effect

	# Define each color phase based on shifted sine waves
	var red = (sin(time_passed * 5.2) + 1) / 2
	var yellow = (sin(time_passed * 5.2 + phase_shift) + 1) / 2
	var green = (sin(time_passed * 5.2 + 2 * phase_shift) + 1) / 2

	# Organize the colors based on the rotation effect you want
	gradient.colors = PackedColorArray([
		Color(red, yellow, 0),    # First gradient point: red, yellow, green
		Color(green, red, 0),     # Second gradient point: green, red, yellow
		Color(yellow, green, 0),  # Third gradient point: yellow, green, red
	])

	gradient.offsets = PackedFloat32Array([0.0, 0.5, 1.0])

	line.gradient = gradient
	path_lines.append(line)
	add_child(line)

func draw_route_path(delta: float) -> void:
	var route = GameManager.routes_manager.routes[selected_route_index]
	var path = route.find_path_between_planets(route.starting_planet, route.ending_planet)
	if path.size() >= 1:
		for i in range(path.size() - 1):
			var cluster1 = path[i]
			var cluster2 = path[i + 1]
			draw_line_between_clusters(delta, cluster1, cluster2)
			if i == path.size() - 2:
				cluster2.mini_cluster_instance.set_is_destination = true

var time_passed = 0.0

func _physics_process(delta):
	time_passed += delta
	clear_lines()
	for ring in rings:
		var ring_speed = ring.radius / 500.0 # Adjust the speed based on the position along the path

		for follower in ring.ring.get_children():
			if follower is PathFollow2D:
				follower.progress_ratio += delta * speed * ring_speed # Move the mini-cluster along the path

	if selected_route_index >= 0:
		draw_route_path(delta)
	
