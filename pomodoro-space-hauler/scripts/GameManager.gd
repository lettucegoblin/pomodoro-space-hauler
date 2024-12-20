extends Node

# Custom signals for communication between scenes
signal work_cycle_started
signal break_cycle_started
signal timer_updated
signal job_completed

# Constants for work and break intervals
var WORK_INTERVAL = 25
var BREAK_INTERVAL = 5
const BREAK_SCENE = "res://scenes/break_scene.tscn"
const WORK_SCENE = "res://scenes/work_scene.tscn"
const JOB_COMPLETE_SCENE = "res://scenes/job_complete.tscn"
const MAIN_MENU_SCENE = "res://scenes/main_menu.tscn"

# Variables to track game state
var current_job = null
var timer_running = false
var time_remaining = 0
var current_interval = WORK_INTERVAL
var total_cycles = 0
var completed_cycles = 0
var completed_routes = []
var routes_manager = null
var planetGenerator = null

var timer_multiplier : float = 1.0

var has_license : bool = false
var pilot_name : String = "Bonnie"
var ship_name : String = "The Little Comet"

# Random number generator
var rng = RandomNumberGenerator.new()


# Probably dont need to export with a headless script but whatever
@export var debug: bool = true

func reset_game():
	# Reset the game state
	current_job = null
	timer_running = false
	time_remaining = 0
	current_interval = WORK_INTERVAL
	total_cycles = 0
	completed_cycles = 0
	completed_routes = []
	has_license = false
	pilot_name = "Bonnie"
	ship_name = "The Little Comet"
	rng = RandomNumberGenerator.new()

func workLabelDetails():
	# Pilot name, ship name 
	# hauling, from, to, distance
	# current system info
	var current_route = get_current_route()
	var str = pilot_name + " in " + ship_name + "\n"
	str += "Hauling " + current_route.haul + "\n"
	str += "From " + current_route.starting_planet.get_name() + " to " + current_route.ending_planet.get_name() + "\n"
	str += "Distance: " + str(current_route.calculate_distance() - 1) + " units"
	return str

func show_main_menu():
	# Transition to the main menu scene
	transition_to_scene(MAIN_MENU_SCENE)

# Hide route manager autoload instance
func HideRouteManager():
	# loop over all RouteCanvasLayers in global groups
	RouteManagementInstance.hideModal()

func ShowRouteManager():
	# loop over all RouteCanvasLayers in global groups
	RouteManagementInstance.showModal()

func _ready():
	# Initialize the routes manager
	routes_manager = load("res://scripts/RoutesManager.gd").new()
	routes_manager.connect("routes_updated", Callable(self, "_on_routes_updated"))

func start_timer_work():
	current_interval = WORK_INTERVAL
	total_cycles = 2
	time_remaining = WORK_INTERVAL * 60
	timer_running = true # TODO: Have a proper start/stop

# Example handler for when routes are updated (optional)
func _on_routes_updated(updated_routes):
	#print("Routes updated:", updated_routes)
	pass

# Function to get routes from the routes manager
func get_routes():
	return routes_manager.get_routes()

func complete_cycle():
	# Handle completion of work/break cycle
	if current_interval == WORK_INTERVAL:
		completed_cycles += 1
		# get distance of current route
		var distance = get_current_route().calculate_distance()
		# get current position on route
		var position = routes_manager.ship_position_index_on_route

		if position + 1 >= distance:
			get_current_route().completed = true
			# Job is complete
			completed_routes.append(get_current_route())
			emit_signal("job_completed", current_job)
			start_break()
			#transition_to_scene(JOB_COMPLETE_SCENE)
		else:
			# Move to the next position on the route
			routes_manager.ship_position_index_on_route += 1
			start_break() # Start a break cycle
	else: # Break cycle
		if not get_current_route().completed: # If the job is not complete
			start_work()

func start_break():
	# Start a break cycle
	current_interval = BREAK_INTERVAL
	time_remaining = current_interval * 60
	
	emit_signal("break_cycle_started", BREAK_SCENE)
	#transition_to_scene("res://scenes/break_scene.tscn")

func start_timer():
	# Start the timer
	timer_running = true

func start_work():
	# Start a work cycle
	current_interval = WORK_INTERVAL
	completed_cycles = 0
	time_remaining = current_interval * 60
	emit_signal("work_cycle_started", WORK_SCENE)
	transition_to_scene("res://scenes/work_scene.tscn")

func get_current_route():
	# Return the current route data
	return routes_manager.routes[routes_manager.selected_route_index]

func transition_to_scene(scene_name):
	# Transition to the specified scene
	get_tree().change_scene_to_file(scene_name)

func pause_timer():
	# Pause the timer
	timer_running = false

func resume_timer():
	# Resume the timer
	timer_running = true

func save_game_state():
	# Save the current state to a file
	var save_data = {
		"current_job": current_job,
		"current_route": get_current_route(),
		"time_remaining": time_remaining,
		"completed_cycles": completed_cycles
	}
	var file = FileAccess.open("user://save_game.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()

func load_game_state():
	# Load the saved game state
	var file = FileAccess.open("user://save_game.json", FileAccess.READ)
	if file:		
		var json = JSON.new()
		var json_result = json.parse(file.get_as_text())
		if json_result.error == OK:
			var save_data = json_result.result
			current_job = save_data.current_job
			#current_route = save_data.current_route
			time_remaining = save_data.time_remaining
			completed_cycles = save_data.completed_cycles
		file.close()

func _process(delta):
	# Update the timer if it is running
	if timer_running:
		time_remaining -= delta * timer_multiplier
		# Emit signal to update any timer display in the UI
		emit_signal("timer_updated", time_remaining)
		if time_remaining <= 0:
			timer_running = false
			complete_cycle()

func set_time_remaining(time: int):
	time_remaining = time
	emit_signal("timer_updated", time_remaining)


# Helper functions to grab random items from the lists
func random_item(array: Array):
	return array[rng.randi_range(0, array.size() - 1)]

func random_items(array: Array, count: int):
	var selected = []
	var collisons = 0
	while selected.size() < count:
		var item = random_item(array)
		if item not in selected:
			selected.append(item)
		else:
			collisons += 1
		if collisons > 100:
			printerr("Broke after 100 tries")  #oof
			break
	return selected
