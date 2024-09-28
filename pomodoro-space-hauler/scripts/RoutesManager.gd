extends Node

# Custom signal to notify when routes are generated or updated
signal routes_updated

# Array to store the generated routes
var routes = []

# Constants
var PLANET_NAMES = []

# Generate initial routes when the Routes class is loaded
func _init():
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
			PLANET_NAMES = data_received["planets"]
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
		var start_planet = PLANET_NAMES[randi() % PLANET_NAMES.size()]
		var end_planet = PLANET_NAMES[randi() % PLANET_NAMES.size()]
		while end_planet == start_planet: # Ensure start and end are not the same
			end_planet = PLANET_NAMES[randi() % PLANET_NAMES.size()]
		
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

# Function to get current routes
func get_routes():
	return routes
