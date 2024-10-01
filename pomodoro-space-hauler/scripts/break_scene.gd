extends Control

var animation_player: AnimationPlayer
var next_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.connect("work_cycle_started", Callable(self, "_on_work_cycle_started"))
	animation_player = $space_ship.animationPlayer
	animation_player.play("break_cycle_intro")
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_work_cycle_started(scene_file_path: String) -> void:
	next_scene_path = scene_file_path
	change_animation("work_cycle_outro")

func change_animation(animation_name: String) -> void:
	if animation_player:
		animation_player.play(animation_name)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "work_cycle_outro" and next_scene_path:
		get_tree().change_scene_to_file(next_scene_path)
