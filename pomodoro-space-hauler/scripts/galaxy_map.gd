extends Node2D

@export var noise = FastNoiseLite.new()
@onready var camera = $Camera2D

var zoom_factor = 1.0
var zoom_min = 0.5
var zoom_max = 2.5

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
	$UniverseScene.spawn_clusters_universe()


func spawn_clusters(clusters_data: Array) -> void:
	for i in range(clusters_data.size()):
		var cluster_data = clusters_data[i]
		var cluster_instance = preload("res://scenes/cluster_node.tscn").instantiate()
		cluster_instance._initialize(cluster_data)
		%ClusterContainer.add_child(cluster_instance)

# Handle zooming via mouse wheel or touch input
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_factor = clamp(zoom_factor - 0.1, zoom_min, zoom_max)
			camera.zoom = Vector2(zoom_factor, zoom_factor)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_factor = clamp(zoom_factor + 0.1, zoom_min, zoom_max)
			camera.zoom = Vector2(zoom_factor, zoom_factor)

	# TODO: Implement pinch zoom for mobile touch events, Need to track touchpoints 
	# Pinch zoom for mobile touch events
	#elif event is InputEventScreenTouch and event.get_index() > 0:
	#	handle_pinch_zoom(event)

# Helper function to handle pinch zoom on mobile
func handle_pinch_zoom(event: InputEvent):
	var current_distance = (event.position - event.position_previous).length()
	var scale_change = current_distance * 0.01  # Adjust this factor as necessary
	zoom_factor = clamp(zoom_factor + scale_change, zoom_min, zoom_max)
	camera.zoom = Vector2(zoom_factor, zoom_factor)
