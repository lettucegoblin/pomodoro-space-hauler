extends Node

# Custom signal to notify when routes are generated or updated
signal routes_updated
signal planets_updated

# Array to store the generated routes
var routes = []
@export var planets = []
var all_planets = []

# Generate initial routes when the Routes class is loaded
func _init():
	init_planets()
	generate_galaxy()

func init_planets():
	# Read planets.json from data/planets.json
	var file = FileAccess.open("res://data/planets.json", FileAccess.READ)
	if !file:
		printerr("Error opening file")
		return
	
	var json_string = file.get_as_text()
	print(json_string)
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		print(typeof(data_received))
		if typeof(data_received) == TYPE_DICTIONARY:
			all_planets = data_received["planets"]
		else:
			printerr("Unexpected data")
	else:
		printerr("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		
	file.close()

# Function to generate new routes
func refresh_routes():
	# Clear existing routes
	routes.clear()

	# Generate random routes (example logic)
	for i in range(5): # Generate 5 random routes for now
		var start_planet = all_planets[randi() % all_planets.size()]
		var end_planet = all_planets[randi() % all_planets.size()]
		while end_planet == start_planet: # Ensure start and end are not the same
			end_planet = all_planets[randi() % all_planets.size()]
		
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

func generate_galaxy(num_planets = 5):
	# Clear existing planets
	planets.clear()

	for i in range(num_planets): 
		var planet = all_planets[randi() % all_planets.size()]
		if planet not in planets:
			planets.append(planet)

	# Emit signal to notify any connected nodes that planets have been updated
	emit_signal("planets_updated", planets)

# Function to get current routes
func get_routes():
	return routes
