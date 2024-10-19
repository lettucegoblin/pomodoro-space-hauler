class_name Cluster

var name: String = ""
var planets: Array[Planet] = []
var neighbors: Array[Cluster] = []  # Neighbors of this cluster

func _init(name: String, planets: Array[Planet] = []):
	self.name = name
	self.planets = planets
	print("Cluster initialized: " + name)

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
