class_name Cluster

var name: String = ""
var planets: Array[Planet] = []
var neighbors: Array[Cluster] = []  # Neighbors of this cluster
var mini_cluster_instance: BabyPlanetScene = null

static var CLUSTERGRID = [] # 2D array of clusters

static func GET_CLUSTERGRID_ROW(i: int) -> Array[Cluster]:
	var row: Array[Cluster] = []
	for cluster in CLUSTERGRID[i]:
		row.append(cluster)
	return row as Array[Cluster]


func _init(name: String, planets: Array[Planet] = []):
	self.name = name
	self.planets = planets
	print("Cluster initialized: " + name)

func get_all_resources() -> Array[String]:
	var all_resources: Array[String] = []
	for planet in planets:
		all_resources.append_array(planet.get_resources())
	return all_resources

func get_all_special_features() -> Array[String]:
	var all_special_features: Array[String] = []
	for planet in planets:
		all_special_features.append_array(planet.get_special_features())
	return all_special_features

func get_all_hazards() -> Array[String]:
	var all_hazards: Array[String] = []
	for planet in planets:
		all_hazards.append_array(planet.get_hazards())
	return all_hazards

func get_all_trade_goods() -> Array[String]:
	var all_trade_goods: Array[String] = []
	for planet in planets:
		all_trade_goods.append_array(planet.get_trade_goods())
	return all_trade_goods





func add_planet(planet: Planet):
	planets.append(planet)

func get_planets() -> Array[Planet]:
	return planets

func get_name():
	return name

# Add a neighboring cluster
func add_neighbor(neighbor: Cluster):
	if neighbor not in neighbors:
		neighbors.append(neighbor)

# Return the list of neighbors
func get_neighbors():
	return neighbors

# Check if this cluster is connected to another cluster
func is_connected_to(cluster: Cluster) -> bool:
	return cluster in neighbors
