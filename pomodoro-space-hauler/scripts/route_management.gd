extends Control
	
var block_scroll_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_routes_updated(GameManager.routes_manager.routes)
	GameManager.routes_manager.connect("routes_updated", Callable(self, "on_routes_updated"))
	GameManager.HideRouteManager()

func sort_by_distance(a, b):
	if a.calculate_distance() > b.calculate_distance():
		return true
	return false
	
func showModal() -> void:
	var canvas_layers = get_tree().get_nodes_in_group("RouteCanvasLayers")
	for canvas_layer in canvas_layers:
		# hide the route manager
		if GameManager.has_license:
			if canvas_layer == $LicenseCanvasLayer:
				canvas_layer.hide()
				continue
		canvas_layer.show()
	resetZoom()
	%galaxy_map/%GalaxyMapCamera.enabled = true
	GameManager.routes_manager.set_selected_route(-1)
		
func hideModal() -> void:
	var canvas_layers = get_tree().get_nodes_in_group("RouteCanvasLayers")
	for canvas_layer in canvas_layers:
		# hide the route manager
		canvas_layer.hide()
	resetZoom()
	%galaxy_map/%GalaxyMapCamera.enabled = false
	# unselect the selected route
	%RouteItemList.deselect_all()
	%DistanceLabel.text = "Distance: "
	%StartRouteButton.disabled = true

func resetZoom() -> void:
	%galaxy_map/%GalaxyMapCamera.zoom = Vector2(1, 1)

func on_routes_updated(routes: Array) -> void:
	%RouteItemList.clear()
	# Sort the routes by distance
	routes.sort_custom(sort_by_distance)

	for route in routes:
		print(route.calculate_distance())
		# 
		var route_string = route.starting_cluster().get_name() + "(" + route.starting_planet.get_name() + ")" + " -> " + route.ending_cluster().get_name() + "(" + route.ending_planet.get_name() + ")"
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
	#GameManager.routes_manager.start_selected_route()
	GameManager.start_work()
	GameManager.HideRouteManager()

func _on_closed_button_pressed() -> void:
	GameManager.HideRouteManager()


func _on_sign_license_button_pressed() -> void:
	GameManager.pilot_name = %CaptainNameTextEdit.text
	GameManager.ship_name = %ShipNameTextEdit.text
	GameManager.has_license = true
	$LicenseCanvasLayer.hide()
	pass # Replace with function body.
