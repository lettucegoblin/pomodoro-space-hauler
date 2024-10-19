extends Node

class_name PlanetGenerator


# Data from JSON
var planet_data = {
	"planet_names": [],
	"cluster_names": [],
	"resources": [],
	"special_features": [],
	"hazards": [],
	"trade_goods": []
}

# Parameters
@export var num_planets = 10
@export var num_clusters = 3
@export var cluster_distribution = 1.0
@export var max_resources_per_planet = 3
@export var max_features_per_planet = 2
@export var max_hazards_per_planet = 1
@export var max_trade_goods_per_planet = 2

const PLANET_FILE = "res://data/planet_generation.json"

# Load planet data from JSON
func _init():
	var json = JSON.new()
	var file = FileAccess.open(PLANET_FILE, FileAccess.READ)
	if file:
		planet_data = json.parse_string(file.get_as_text())
		if planet_data == null:
			print("Error parsing JSON file.")
			
	else:
		print("JSON file not found.")
	file.close()


# Planet generation
func generate_planets(cluster: Cluster, count: int) -> void:
	# Distribute planets among clusters
	var planet_names = GameManager.random_items(planet_data["planet_names"], count)
	for planet_name in planet_names:
		var planet = Planet.new(planet_name, cluster)
		planet.resources = GameManager.random_items(planet_data["resources"], GameManager.rng.randi_range(1, max_resources_per_planet))
		planet.special_features = GameManager.random_items(planet_data["special_features"], GameManager.rng.randi_range(1, max_features_per_planet))
		planet.hazards = GameManager.random_items(planet_data["hazards"], GameManager.rng.randi_range(0, max_hazards_per_planet))
		planet.trade_goods = GameManager.random_items(planet_data["trade_goods"], GameManager.rng.randi_range(1, max_trade_goods_per_planet))
		cluster.add_planet(planet)

# Generate clusters based on distribution
func generate_clusters() -> Array[Cluster]:
	var clusters: Array[Cluster] = []
	var min_per_cluster = int(num_planets / num_clusters)
	var extra_planets = num_planets % num_clusters

	var cluster_names = GameManager.random_items(planet_data["cluster_names"], num_clusters)

	# Create the clusters
	for i in range(num_clusters):
		var num_planets_in_cluster = min_per_cluster + (1 if extra_planets > 0 else 0)
		extra_planets -= 1
		var cluster_name = cluster_names[i]
		var cluster = Cluster.new(cluster_name)
		generate_planets(cluster, num_planets_in_cluster)
		clusters.append(cluster)

	# Connect the clusters to form a graph
	connect_clusters(clusters)

	return clusters
# Ensure all clusters are connected and placed in a 2D grid
func connect_clusters(clusters: Array[Cluster]) -> void:
		var grid_size = int(ceil(sqrt(clusters.size()))) # Determine the grid dimensions (as square as possible)
		var grid  = [] #Array[Array[Cluster]]

		# Initialize the 2D array (grid)
		for i in range(grid_size):
				grid.append([])

		# Populate the grid with clusters
		var index = 0
		for i in range(grid_size):
				for j in range(grid_size):
						if index < clusters.size():
								grid[i].append(clusters[index])
								index += 1
						else:
								grid[i].append(null) # Fill with null if clusters are fewer than grid cells

		# Connect clusters within the grid
		for i in range(grid_size):
				for j in range(grid_size):
						var cluster = grid[i][j]
						if cluster == null:
								continue

						# Connect to the cluster on the right
						if j + 1 < grid_size and grid[i][j + 1] != null:
								var right_cluster = grid[i][j + 1]
								cluster.add_neighbor(right_cluster)
								right_cluster.add_neighbor(cluster)

						# Connect to the cluster below
						if i + 1 < grid_size and grid[i + 1][j] != null:
								var down_cluster = grid[i + 1][j]
								cluster.add_neighbor(down_cluster)
								down_cluster.add_neighbor(cluster)
		Cluster.CLUSTERGRID = grid

# Ensure all clusters are connected
func connect_clusters_old(clusters: Array[Cluster]) -> void:
	var unconnected_clusters = clusters.duplicate()
	var connected_clusters: Array[Cluster] = []

	# Pick the first cluster and add it to the connected list
	var current_cluster = unconnected_clusters.pop_front()
	connected_clusters.append(current_cluster)

	# Use a loop to connect all clusters
	while unconnected_clusters.size() > 0:
			# Pick a random cluster from the connected set
			var random_connected_cluster = connected_clusters[GameManager.rng.randi_range(0, connected_clusters.size() - 1)]

			# Pick a random unconnected cluster
			var random_unconnected_cluster = unconnected_clusters.pop_front()

			# Connect the clusters
			random_connected_cluster.add_neighbor(random_unconnected_cluster)
			random_unconnected_cluster.add_neighbor(random_connected_cluster)

			# Add the newly connected cluster to the list of connected clusters
			connected_clusters.append(random_unconnected_cluster)

	# Optionally, create additional random connections between clusters
	for i in range(clusters.size()):
			var cluster_a = clusters[i]
			var cluster_b = clusters[GameManager.rng.randi_range(0, clusters.size() - 1)]
			if cluster_a != cluster_b and not cluster_a.is_connected_to(cluster_b):
					cluster_a.add_neighbor(cluster_b)
					cluster_b.add_neighbor(cluster_a)


# Configurable parameters for the generator
func set_num_planets(value: int):
	num_planets = value

func set_num_clusters(value: int):
	num_clusters = value

func set_cluster_distribution(value: float):
	cluster_distribution = clamp(value, 0.0, 1.0)

func set_max_resources(value: int):
	max_resources_per_planet = value

func set_max_features(value: int):
	max_features_per_planet = value

func set_max_hazards(value: int):
	max_hazards_per_planet = value

func set_max_trade_goods(value: int):
	max_trade_goods_per_planet = value
