extends Node

# Custom signal to notify when routes are generated or updated
signal routes_updated
signal clusters_updated

# Array to store the generated routes
var routes = []
var clusters : Array[Cluster] = []
var planetGenerator = null


# Generate initial routes when the Routes class is loaded
func _init():
	planetGenerator = load("res://scripts/PlanetGenerator.gd").new()
	clusters = planetGenerator.generate_clusters()
	generate_galaxy(8, 3)

# Function to generate new routes
func refresh_routes(num_routes = 5):
	# Clear existing routes
	routes.clear()

	# Generate random routes (example logic)
	for i in range(num_routes): # Generate 5 random routes for now
		var start_planet = clusters[randi() % clusters.size()].get_random_planet()
		var end_planet = clusters[randi() % clusters.size()].get_random_planet()
		
		# Each route could be represented as a dictionary with start, end, and distance
		var route = {
			"start_planet": start_planet,
			"end_planet": end_planet,
			"distance": randi() % 500 + 100, # Random distance between 100-600 units
			"job_duration": randi() % 10 + 1  # Random job duration (1-10 pomodoros)
		}
		routes.append(route)

	# Emit signal to notify any connected nodes that routes have been updated
	emit_signal("routes_updated", routes)

func generate_galaxy(num_planets = 5, num_clusters = 3):
	# Clear existing planets
	clusters.clear()
	planetGenerator.num_planets = num_planets
	planetGenerator.num_clusters = num_clusters
	clusters = planetGenerator.generate_clusters()
	
	# Emit signal to notify any connected nodes that planets have been updated
	emit_signal("clusters_updated", clusters)

# Function to get current routes
func get_routes():
	return routes
