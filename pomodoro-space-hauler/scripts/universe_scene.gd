extends Node2D

class_name UniverseScene

var rings: Array[Variant] = []

var mini_cluster_scene: PackedScene
var speed = 0.05 # Speed of movement along the ring

@onready var center_of_universe = $CenterOfUniverse # A node that acts as the center

# You can set the mini-cluster PackedScene in the editor or load it dynamically
func _ready():
	# set the center of the universe at the center of the viewport
	center_of_universe.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	mini_cluster_scene = preload("res://scenes/MiniCluster.tscn")
	spawn_rings()

func create_ring_with_path(radius: float, num_clusters: int):
		var ring = Path2D.new()
		ring.position = center_of_universe.position

		ring.set("radius", radius)
		

		# Create a curve for the Path2D
		var curve = Curve2D.new()
		var resolution = 360
		for i in range(resolution):
				var angle = 2 * PI * i / resolution
				var x = radius * cos(angle)
				var y = radius * sin(angle)
				curve.add_point(Vector2(x, y))
		
		ring.curve = curve
		add_child(ring)

		# Now add PathFollow2D for each mini-cluster
		for i in range(num_clusters):
				var cluster_instance = mini_cluster_scene.instantiate()
				var path_follower = PathFollow2D.new()

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

# Call this to dynamically spawn rings
func spawn_rings():
	create_ring_with_path(100, 5)
	create_ring_with_path(200, 10)
	create_ring_with_path(300, 15)


func _physics_process(delta):
	for ring in rings:
		var ring_speed = ring.radius / 500.0 # Adjust the speed based on the position along the path

		for follower in ring.ring.get_children():
			if follower is PathFollow2D:
				follower.progress_ratio += delta * speed * ring_speed # Move the mini-cluster along the path
