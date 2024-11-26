extends Control

@onready var spaceship_animation_player: AnimationPlayer = $space_ship/AnimationPlayer
var next_scene_path: String
var current_planet: Planet
var miniClusterOriginalScale = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$space_ship/AnimationSceneTransition/ColorRect.color.a = 255
	GameManager.connect("work_cycle_started", Callable(self, "_on_work_cycle_started"))
	spaceship_animation_player.play("break_cycle_intro")
	spaceship_animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	var current_cluster = GameManager.routes_manager.get_current_cluster()

	GameManager.start_timer()
	# make a MiniCluster
	#var mini_cluster = preload("res://scenes/MiniCluster.tscn").instantiate()
	#mini_cluster.cluster = current_cluster
	#$cluster_container.add_child(mini_cluster)
	##mini_cluster.show_planet_labels(true)

	var planets = current_cluster.get_planets()
	if planets.size() > 0:
		current_planet = current_cluster.get_planets()[0]
		var planet_scene = preload("res://scenes/planet_scene.tscn").instantiate()
		planet_scene.set_planet(current_planet)
		planet_scene.set_large_view(true)
		$planet_container.add_child(planet_scene)
		
	update_job_complete_visibility()
	GameManager.routes_manager.connect("selected_route_updated", Callable(self, "on_selected_route_updated"))

func update_job_complete_visibility() -> void:
	$job_complete.visible = GameManager.get_current_route().completed

func on_selected_route_updated(selected_route_index: int) -> void:
	update_job_complete_visibility()

func _on_work_cycle_started(scene_file_path: String) -> void:
	next_scene_path = scene_file_path
	spaceship_animation_player.play("break_cycle_outro")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "break_cycle_outro" and next_scene_path:
		get_tree().change_scene_to_file(next_scene_path)
	elif anim_name == "break_cycle_intro":
		spaceship_animation_player.play("break_ship_idle")
