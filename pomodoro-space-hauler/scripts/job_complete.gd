extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# %RouteDetailsLabel
	var route_detail_str = GameManager.routes_manager.route_detail_str(GameManager.routes_manager.selected_route_index)
	%RouteDetailsLabel.text = route_detail_str
	%CompletedJobsLabel.text = "Completed Jobs: " + str(GameManager.completed_routes.size())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_choose_new_job_button_pressed() -> void:
	GameManager.ShowRouteManager()
