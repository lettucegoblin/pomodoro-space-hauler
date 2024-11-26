extends Control

func _ready() -> void:
	if !GameManager.debug:
		%DebugContainer.hide()
	GameManager.HideRouteManager()
	
func start() -> void:
	GameManager.reset_game()
	GameManager.ShowRouteManager()
	#get_tree().change_scene_to_file("res://scenes/work_scene.tscn")
	#GameManager.start_work()
	

func _on_start_button_pressed() -> void:
	start()

func _on_galaxy_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/galaxy_map.tscn")


func _on_route_manage_button_pressed() -> void:
	GameManager.ShowRouteManager()
	#get_tree().change_scene_to_file("res://scenes/route_management.tscn")
