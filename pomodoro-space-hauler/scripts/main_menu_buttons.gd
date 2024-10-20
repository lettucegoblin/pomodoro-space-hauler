extends Control

func _ready() -> void:
	if !GameManager.debug:
		%DebugContainer.hide()
	
func start() -> void:
	get_tree().change_scene_to_file("res://scenes/work_scene.tscn")
	GameManager.start_timer_work()

func _on_start_button_pressed() -> void:
	start()

func _on_galaxy_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/galaxy_map.tscn")
