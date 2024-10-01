extends Control

var animation_player: AnimationPlayer
var next_scene_path: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.connect("break_cycle_started", Callable(self, "_on_break_cycle_started"))
	animation_player = $Node2D/space_ship.animationPlayer
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_break_cycle_started(scene_file_path: String) -> void:
	next_scene_path = scene_file_path
	change_animation("break_cycle")

func change_animation(animation_name: String) -> void:
	if animation_player:
		animation_player.play(animation_name)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "break_cycle" and next_scene_path:
		get_tree().change_scene_to_file(next_scene_path)
