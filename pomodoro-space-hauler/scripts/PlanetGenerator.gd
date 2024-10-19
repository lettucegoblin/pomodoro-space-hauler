extends Node

class_name PlanetGenerator

# Random number generator
var rng = RandomNumberGenerator.new()

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
func generate_planets(cluster: Cluster, count : int) -> void:
	# Distribute planets among clusters
	var planet_names = random_items(planet_data["planet_names"], count)
	for planet_name in planet_names:
		var planet = Planet.new(planet_name, cluster.get_name())
		planet.resources = random_items(planet_data["resources"], rng.randi_range(1, max_resources_per_planet))
		planet.special_features = random_items(planet_data["special_features"], rng.randi_range(1, max_features_per_planet))
		planet.hazards = random_items(planet_data["hazards"], rng.randi_range(0, max_hazards_per_planet))
		planet.trade_goods = random_items(planet_data["trade_goods"], rng.randi_range(1, max_trade_goods_per_planet))
		cluster.add_planet(planet)

# Generate clusters based on distribution
func generate_clusters() -> Array[Cluster]:
	var clusters: Array[Cluster] = []
	var min_per_cluster = int(num_planets / num_clusters)
	var extra_planets = num_planets % num_clusters

	var clusters_names = random_items(planet_data["cluster_names"], num_clusters)

	for i in range(num_clusters):
		var num_planets_in_cluster = min_per_cluster + (1 if extra_planets > 0 else 0)
		extra_planets -= 1
		var cluster_name = clusters_names[i]
		var cluster = Cluster.new(cluster_name)

		generate_planets(cluster, num_planets_in_cluster)

		clusters.append(cluster)

	return clusters

# Helper functions to grab random items from the lists
func random_item(array: Array) -> String:
	return array[rng.randi_range(0, array.size() - 1)]

func random_items(array: Array, count: int) -> Array:
	var selected = []
	for i in range(count):
		var item = random_item(array)
		if item not in selected:
			selected.append(item)
	return selected

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
