extends Control

# Reference to the GameManager
var game_manager = null

func _ready():
		game_manager = get_node("/root/GameManager")

		# Connect to the routes_updated signal
		var routes_manager = get_node("/root/Routes")
		routes_manager.connect("routes_updated", Callable(self, "_on_routes_updated"))

		# Optionally, get the routes right away when the scene is loaded
		update_job_list(game_manager.get_routes())

# Signal handler when routes are updated
func _on_routes_updated(routes):
		update_job_list(routes)

# Function to populate the job list UI based on available routes
func update_job_list(routes):
		var job_list = $JobList

		# Clear any existing jobs
		job_list.clear()

		# Populate new jobs (route data)
		for route in routes:
				var job_name = route.start_planet + " to " + route.end_planet
				var job_duration = str(route.job_duration) + " Pomodoros"

				# Create job entry
				var job_container = job_list.instance() # Assuming Job is a reusable instance

				# Set the labels and button
				job_container.get_node("JobName").text = job_name
				job_container.get_node("JobDuration").text = job_duration

				# Add the new job entry to the job list
				job_list.add_child(job_container)
