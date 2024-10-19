extends Node

# Custom signal to notify when routes are generated or updated
signal routes_updated
signal clusters_updated

# Array to store the generated routes
var routes: Array[Route] = []
var all_possible_routes: Array[Route] = []
var clusters: Array[Cluster] = []
var planetGenerator:PlanetGenerator = null


# Generate initial routes when the Routes class is loaded
func _init():
	planetGenerator = load("res://scripts/PlanetGenerator.gd").new()
	generate_galaxy(8, 10)
	refresh_routes(len(all_possible_routes))
	
	

# Function to generate new routes
func refresh_routes(num_routes = 5):
	# Clear existing routes
	routes.clear()
	var r = GameManager.random_items(all_possible_routes, num_routes)
	for route in r:
		routes.append(route as Route)
	for route in routes:
		route.print_route()
		print("")

	# Generate random routes (example logic)
	# for route in routes:
	# 	var start_planet = clusters[randi() % clusters.size()].get_random_planet()
	# 	var end_planet = clusters[randi() % clusters.size()].get_random_planet()
		
	# 	# Each route could be represented as a dictionary with start, end, and distance
	# 	var route = {
	# 		"start_planet": start_planet,
	# 		"end_planet": end_planet,
	# 		"distance": randi() % 500 + 100, # Random distance between 100-600 units
	# 		"job_duration": randi() % 10 + 1 # Random job duration (1-10 pomodoros)
	# 	}
	# 	routes.append(route)

	# Emit signal to notify any connected nodes that routes have been updated
	emit_signal("routes_updated", routes)

func generate_galaxy(num_planets = 5, num_clusters = 3):
	# Clear existing planets
	clusters.clear()
	planetGenerator.num_planets = num_planets
	planetGenerator.num_clusters = num_clusters
	clusters = planetGenerator.generate_clusters()
	generate_all_unique_routes()
	
	# Emit signal to notify any connected nodes that planets have been updated
	emit_signal("clusters_updated", clusters)



func get_all_planets() -> Array[Planet]:
		var all_planets: Array[Planet] = []
		for cluster in clusters:
				all_planets.append_array(cluster.get_planets())
		return all_planets

func generate_all_unique_routes() -> Array[Route]:
		var all_planets = get_all_planets()
		all_possible_routes = []
		
		# Generate all unique planet-to-planet routes (permutations)
		for i in range(all_planets.size()):
				for j in range(i + 1, all_planets.size()):
						var start_planet = all_planets[i]
						var end_planet = all_planets[j]
						
						# Create a new Route and add it to the routes list
						var route = Route.new()
						route.starting_planet = start_planet
						route.ending_planet = end_planet
						all_possible_routes.append(route)
		
		return all_possible_routes


# Function to get current routes
func get_routes():
	return routes
