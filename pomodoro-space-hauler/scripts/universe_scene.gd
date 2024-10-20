extends Node2D

class_name UniverseScene

var rings: Array[Variant] = []

var mini_cluster_scene: PackedScene
var speed = 0.05 # Speed of movement along the ring
var clusters: Array[Cluster] = []

@onready var center_of_universe = $CenterOfUniverse # A node that acts as the center  (ps- there is no real center of the universe since every point can be considered the center of the universe - prove me wrong)

# You can set the mini-cluster PackedScene in the editor or load it dynamically
func _ready():
	# set the center of the universe at the center of the viewport
	center_of_universe.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	mini_cluster_scene = preload("res://scenes/MiniCluster.tscn")
	#spawn_test_rings()

# use Cluster.CLUSTERGRID which is a 2d array of clusters to create rings
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


func _physics_process(delta):
	for ring in rings:
		var ring_speed = ring.radius / 500.0 # Adjust the speed based on the position along the path

		for follower in ring.ring.get_children():
			if follower is PathFollow2D:
				follower.progress_ratio += delta * speed * ring_speed # Move the mini-cluster along the path