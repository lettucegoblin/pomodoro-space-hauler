extends Node

# Custom signals for communication between scenes
signal work_cycle_started
signal break_cycle_started
signal timer_updated
signal job_completed

# Constants for work and break intervals
const WORK_INTERVAL = 25
const BREAK_INTERVAL = 5

# Variables to track game state
var current_job = null
var current_route = null
var timer_running = false
var time_remaining = 0
var current_interval = WORK_INTERVAL
var total_cycles = 0
var completed_cycles = 0
@export var routes_manager = null

func _ready():
	# Initialize the routes manager
	routes_manager = load("res://scripts/RoutesManager.gd").new()
	
	routes_manager.connect("routes_updated", Callable(self, "_on_routes_updated"))

	# You could refresh routes at the start or during specific actions
	routes_manager.refresh_routes()


# Example handler for when routes are updated (optional)
func _on_routes_updated(updated_routes):
	print("Routes updated:", updated_routes)

# Function to get routes from the routes manager
func get_routes():
	return routes_manager.get_routes()

func start_job(job_data):
	# Start a new job with the given data
	current_job = job_data
	current_route = job_data.route # Assuming job_data has a route
	completed_cycles = 0
	total_cycles = job_data.cycles # Assuming job_data has a total number of cycles
	timer_running = true
	current_interval = WORK_INTERVAL
	time_remaining = current_interval * 60
	# Emit a signal to notify that a work cycle has started
	emit_signal("work_cycle_started", current_job)
	# Transition to work scene
	transition_to_scene("res://scenes/work_scene.tscn")

func complete_cycle():
	# Handle completion of work/break cycle
	if current_interval == WORK_INTERVAL:
		current_interval = BREAK_INTERVAL
		emit_signal("break_cycle_started", current_job)
	else:
		completed_cycles += 1
		current_interval = WORK_INTERVAL
		emit_signal("work_cycle_started", current_job)

	time_remaining = current_interval * 60

	# If the job is completed, emit a job completed signal
	if completed_cycles >= total_cycles:
		emit_signal("job_completed", current_job)
		timer_running = false
		# Optionally, transition to a "job complete" scene or return to the job selection screen
		transition_to_scene("res://scenes/job_complete.tscn")
	else:
		# Transition to the appropriate scene based on the interval
		if current_interval == WORK_INTERVAL:
			transition_to_scene("res://scenes/work_scene.tscn")
		else:
			transition_to_scene("res://scenes/break_scene.tscn")

func get_current_route():
	# Return the current route data
	return current_route

func transition_to_scene(scene_name):
	# Transition to the specified scene
	get_tree().change_scene(scene_name)

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
		"current_route": current_route,
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
			current_route = save_data.current_route
			time_remaining = save_data.time_remaining
			completed_cycles = save_data.completed_cycles
		file.close()



func _process(delta):
	# Update the timer if it is running
	if timer_running:
		time_remaining -= delta
		# Emit signal to update any timer display in the UI
		emit_signal("timer_updated", time_remaining)
		if time_remaining <= 0:
			timer_running = false
			complete_cycle()
