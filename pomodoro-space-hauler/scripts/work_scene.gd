extends Control

var next_scene_path: String
@onready var transition_anim_player : AnimationPlayer = $AnimationSceneTransition/AnimationPlayer
@onready var spaceship_animation_player : AnimationPlayer = $Node2D/space_ship/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Node2D/space_ship/AnimationSceneTransition/ColorRect.color.a = 255
	GameManager.connect("break_cycle_started", Callable(self, "_on_break_cycle_started"))
	spaceship_animation_player.play("work_cycle_intro")
	spaceship_animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_break_cycle_started(scene_file_path: String) -> void:
	next_scene_path = scene_file_path
	spaceship_animation_player.play("work_cycle_outro")
	#transition_anim_player.play("fade_out")
	

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "work_cycle_outro" and next_scene_path:
		get_tree().change_scene_to_file(next_scene_path)
