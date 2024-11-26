extends Node

# Custom signal to notify when routes are generated or updated
signal routes_updated
signal clusters_updated
signal selected_route_updated

# Array to store the generated routes
var routes: Array[Route] = []
var all_possible_routes: Array[Route] = []
var clusters: Array[Cluster] = []
var planetGenerator:PlanetGenerator = null
var selected_route_index: int = -1
var num_planets = 20
var num_clusters = 15
var num_routes = 5

var ship_position_index_on_route: int = 0

# Generate initial routes when the Routes class is loaded
func _init():
	planetGenerator = load("res://scripts/PlanetGenerator.gd").new()
	generate_galaxy(num_planets, num_clusters)
	refresh_routes(num_routes)
	
# Function to generate new routes
func refresh_routes(num_routes = 5):
	# Clear existing routes
	routes.clear()
	var r = GameManager.random_items(all_possible_routes, num_routes)
	for route in r:
		routes.append(route as Route)

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

func set_selected_route(selected_route: int):
	ship_position_index_on_route = 0
	selected_route_index = selected_route
	emit_signal("selected_route_updated", selected_route_index)

func get_current_cluster() -> Cluster:
	if selected_route_index >= 0 and selected_route_index < routes.size():
		var route = routes[selected_route_index]
		var path = route.find_path_between_planets(route.starting_planet, route.ending_planet)
		if path.size() > 0 && ship_position_index_on_route < path.size():
			return path[ship_position_index_on_route]
	return null

func route_detail_str(index: int) -> String:
	var route = routes[index]
	return route.starting_planet.get_name() + " -> " + route.ending_planet.get_name() + " (" + str(GameManager.routes_manager.ship_position_index_on_route) + '/' + str(route.calculate_distance()) + " units)"

func start_selected_route():
	# change the scene to the main game scene
	if GameManager.current_interval == GameManager.WORK_INTERVAL:
		GameManager.start_work() # we're at the main menu, need to start work
	
	GameManager.HideRouteManager()
	#GameManager.transition_to_scene("res://scenes/work_scene.tscn")

func get_all_planets() -> Array[Planet]:
		var all_planets: Array[Planet] = []
		for cluster in clusters:
				all_planets.append_array(cluster.get_planets())
		return all_planets

func get_current_route() -> Route:
	if selected_route_index >= 0 and selected_route_index < routes.size():
		return routes[selected_route_index]
	return null

func generate_all_unique_routes() -> Array[Route]:
		var all_planets = get_all_planets()
		all_possible_routes = []
		
		# Generate all unique planet-to-planet routes (permutations)
		for i in range(all_planets.size()):
				for j in range(i + 1, all_planets.size()):
						var start_planet = all_planets[i]
						var end_planet = all_planets[j]

						if start_planet.cluster == end_planet.cluster:
							continue # Skip routes between planets in the same cluster
						
						# Create a new Route and add it to the routes list
						var route = Route.new()
						route.starting_planet = start_planet
						route.ending_planet = end_planet
						route.haul = str(randi_range(1, 10)) + " tons of " + route.starting_planet.get_random_trade_good()
						all_possible_routes.append(route)
		
		return all_possible_routes

# Function to get current routes
func get_routes():
	return routes
