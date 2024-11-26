extends Control

@export var prefix: String = ""
@export var postfix: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.connect("timer_updated", Callable(self, "_on_timer_updated"))
	print("Work UI Ready")
	update_work_label_details()

func update_work_label_details() -> void:
	var current_route = GameManager.get_current_route()
	%HeaderLabel.text = GameManager.pilot_name + " in \n" + GameManager.ship_name + "\n"
	var hauling_str = "Hauling " + current_route.haul + "\n"
	hauling_str += "From " + current_route.starting_planet.get_name() + " to " + current_route.ending_planet.get_name() + "\n"
	hauling_str += "Distance: " + str(current_route.calculate_distance() - 1) + " units"
	%WorkLabelDetails.text = hauling_str

	var current_cluster = GameManager.routes_manager.get_current_cluster()
	# %SystemInfoLabel.text =  cluster name, get_all_special_features()
	%SystemInfoLabel.text = "Current Cluster: " + current_cluster.get_name() + "\n"
	
	var system_str = "Resources: "

	for resource in current_cluster.get_all_resources():
		system_str += resource + ", "
	system_str = system_str.substr(0, system_str.length() - 2)
	
	system_str += "\nSpecial Features: "
	for feature in current_cluster.get_all_special_features():
		system_str += feature + ", "
	system_str = system_str.substr(0, system_str.length() - 2)
	
	system_str += "\nHazards: "
	for hazard in current_cluster.get_all_hazards():
		system_str += hazard + ", "
	system_str = system_str.substr(0, system_str.length() - 2)

	system_str += "\nTrade Goods: "
	for trade_good in current_cluster.get_all_trade_goods():
		system_str += trade_good + ", "
	system_str = system_str.substr(0, system_str.length() - 2)

	%SystemInfoLabel.text += system_str

func _on_timer_updated(time_remaining: int) -> void:
	%TimerDisplay.text = str(time_remaining_formatted(time_remaining))
	
func time_remaining_formatted(time_remaining: int) -> String:
	var time_remaining_f = float(time_remaining)
	var minutes = int(time_remaining_f / 60)
	var seconds = int(time_remaining % 60)

	var minutes_str = str(minutes)
	var seconds_str = str(seconds)

	if minutes < 10:
		minutes_str = "0" + minutes_str
	if seconds < 10:
		seconds_str = "0" + seconds_str

	return prefix + minutes_str + ":" + seconds_str + postfix

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
