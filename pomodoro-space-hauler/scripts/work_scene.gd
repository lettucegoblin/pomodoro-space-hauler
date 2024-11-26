extends Control

var next_scene_path: String
@onready var transition_anim_player : AnimationPlayer = $AnimationSceneTransition/AnimationPlayer
@onready var spaceship_animation_player : AnimationPlayer = $Node2D/space_ship/AnimationPlayer

var miniClusterOriginalScale = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Node2D/space_ship/AnimationSceneTransition/ColorRect.color.a = 255
	GameManager.connect("break_cycle_started", Callable(self, "_on_break_cycle_started"))
	spaceship_animation_player.play("work_cycle_intro")
	spaceship_animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

	GameManager.routes_manager.get_current_route().print_route()
	var current_cluster = GameManager.routes_manager.get_current_cluster()
	# make a MiniCluster
	var mini_cluster = preload("res://scenes/MiniCluster.tscn").instantiate()
	mini_cluster.cluster = current_cluster
	$cluster_container.add_child(mini_cluster)
	mini_cluster.show_planet_labels(true)
	miniClusterOriginalScale = mini_cluster.scale * 2.0
	GameManager.connect("timer_updated", Callable(self, "_on_timer_updated"))
	GameManager.start_timer()

func _on_timer_updated(time_remaining: int) -> void:
	# scale mini cluster to 0
	var _scale = miniClusterOriginalScale * (float(time_remaining) / (GameManager.current_interval * 60))
	$cluster_container.scale = _scale


func _on_break_cycle_started(scene_file_path: String) -> void:
	next_scene_path = scene_file_path
	spaceship_animation_player.play("work_cycle_outro")
	#transition_anim_player.play("fade_out")
	

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "work_cycle_outro" and next_scene_path:
		get_tree().change_scene_to_file(next_scene_path)
	elif anim_name == "work_cycle_intro":
		spaceship_animation_player.play("ship_shake")
