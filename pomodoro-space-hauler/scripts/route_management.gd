extends Control
	
var block_scroll_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_routes_updated(GameManager.routes_manager.routes)
	GameManager.routes_manager.connect("routes_updated", Callable(self, "on_routes_updated"))


func sort_by_distance(a, b):
	if a.calculate_distance() > b.calculate_distance():
		return true
	return false


func on_routes_updated(routes: Array) -> void:
	%RouteItemList.clear()
	# Sort the routes by distance
	routes.sort_custom(sort_by_distance)

	for route in routes:
		print(route.calculate_distance())
		var route_string = route.starting_cluster().get_name() + "("  +route.starting_planet.get_name() + ")" + " -> " + route.ending_cluster().get_name() + "(" + route.ending_planet.get_name() + ")"

		%RouteItemList.add_item(route_string)

func _on_route_item_list_mouse_entered() -> void:
	%galaxy_map.block_scroll = true


func _on_route_item_list_mouse_exited() -> void:
	%galaxy_map.block_scroll = false

func update_label_with_selected_route(index: int) -> void:
	%DistanceLabel.text = "Distance: " + str(GameManager.routes_manager.routes[index].calculate_distance())

func enable_StartRouteButton() -> void:
	%StartRouteButton.disabled = false

func _on_route_item_list_item_selected(index: int) -> void:
	GameManager.routes_manager.routes[index].print_route()
	GameManager.routes_manager.set_selected_route(index)
	update_label_with_selected_route(index)
	enable_StartRouteButton()


func _on_start_route_button_pressed() -> void:
	print("Start Route Button Pressed")
	GameManager.routes_manager.start_selected_route()
