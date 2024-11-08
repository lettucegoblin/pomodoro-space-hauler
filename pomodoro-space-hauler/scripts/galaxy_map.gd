extends Node2D

@export var noise = FastNoiseLite.new()
@onready var camera = %GalaxyMapCamera
@export var block_scroll:bool = false

var zoom_factor = 1.0
var zoom_min = 0.5
var zoom_max = 2.5

# Store whether the mouse is being dragged
var dragging = false
# Store the initial position where the drag started
var drag_start_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	spawn_clusters_universe(GameManager.routes_manager.clusters)
	GameManager.routes_manager.connect("clusters_updated", Callable(self, "_on_clusters_updated"))
	
	#spawn_planets(GameManager.routes_manager.planets)
	

func _on_clusters_updated(updated_clusters: Array) -> void:

	for child in %ClusterContainer.get_children():
		child.queue_free()
	#spawn_clusters(updated_clusters)
	spawn_clusters_universe(updated_clusters)

func spawn_clusters_universe(clusters_data: Array) -> void:
	%UniverseScene.clusters = clusters_data
	%UniverseScene.spawn_clusters_universe()


func spawn_clusters(clusters_data: Array) -> void:
	for i in range(clusters_data.size()):
		var cluster_data = clusters_data[i]
		var cluster_instance = preload("res://scenes/cluster_node.tscn").instantiate()
		cluster_instance._initialize(cluster_data)
		%ClusterContainer.add_child(cluster_instance)

# Handle zooming via mouse wheel or touch input
func _input(event):
	var viewport = get_viewport_rect().size
	var scene_min_x = 0
	var scene_max_x = viewport.x
	var scene_min_y = 0
	var scene_max_y = viewport.y

	if event is InputEventMouseButton:
		# Check if the left mouse button is pressed to start dragging
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging and record the initial position
				dragging = true
				drag_start_position = get_global_mouse_position()
			else:
				# Stop dragging when the button is released
				dragging = false
	if dragging:
		# Calculate the difference between the current and initial drag position
		var drag_offset = drag_start_position - get_global_mouse_position()
		# Adjust the camera position
		camera.position += drag_offset
		# Update the initial position to the new mouse position for continuous dragging
		drag_start_position = get_global_mouse_position()

	if event is InputEventMouseButton and !block_scroll:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Get the mouse position in world coordinates before zooming
			var mouse_world_pos = camera.get_global_mouse_position()
			
			# Adjust zoom factor
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_factor = clamp(zoom_factor - 0.06, zoom_min, zoom_max)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_factor = clamp(zoom_factor + 0.06, zoom_min, zoom_max)
			
			# Update the camera zoom
			camera.zoom = Vector2(zoom_factor, zoom_factor)

			# Calculate the new position to keep the mouse point stable
			var new_mouse_world_pos = camera.get_global_mouse_position()
			camera.position += mouse_world_pos - new_mouse_world_pos

			

	# TODO: Implement pinch zoom for mobile touch events, Need to track touchpoints 
	# Pinch zoom for mobile touch events
	#elif event is InputEventScreenTouch and event.get_index() > 0:
	#	handle_pinch_zoom(event)
	# Optional: Clamp camera position to keep center of scene visible (adjust limits as needed)
	camera.position.x = clamp(camera.position.x, scene_min_x, scene_max_x)
	camera.position.y = clamp(camera.position.y, scene_min_y, scene_max_y)

# Helper function to handle pinch zoom on mobile
func handle_pinch_zoom(event: InputEvent):
	var current_distance = (event.position - event.position_previous).length()
	var scale_change = current_distance * 0.01  # Adjust this factor as necessary
	zoom_factor = clamp(zoom_factor + scale_change, zoom_min, zoom_max)
	camera.zoom = Vector2(zoom_factor, zoom_factor)
