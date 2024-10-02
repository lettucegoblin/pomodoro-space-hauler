extends Control

@onready var spaceship_animation_player: AnimationPlayer = $space_ship/AnimationPlayer
var next_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$space_ship/AnimationSceneTransition/ColorRect.color.a = 255
	GameManager.connect("work_cycle_started", Callable(self, "_on_work_cycle_started"))
	spaceship_animation_player.play("break_cycle_intro")
	spaceship_animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_work_cycle_started(scene_file_path: String) -> void:
	next_scene_path = scene_file_path
	spaceship_animation_player.play("break_cycle_outro")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "break_cycle_outro" and next_scene_path:
		get_tree().change_scene_to_file(next_scene_path)
	elif anim_name == "break_cycle_intro":
		spaceship_animation_player.play("break_ship_idle")
