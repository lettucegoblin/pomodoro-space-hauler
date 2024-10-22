extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_routes_updated(GameManager.routes_manager.routes)
	GameManager.routes_manager.connect("routes_updated", Callable(self, "on_routes_updated"))
	pass # Replace with function body.

func on_routes_updated(routes: Array) -> void:
	%RouteItemList.clear()
	for route in routes:
		print(route)
		var route_string = route.starting_cluster().get_name() + " -> " + route.ending_cluster().get_name()

		%RouteItemList.add_item(route_string)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
