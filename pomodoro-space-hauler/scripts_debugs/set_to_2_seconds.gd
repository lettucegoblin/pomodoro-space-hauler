extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!GameManager.debug):
		$"../FastTimerButton".queue_free()
		queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	GameManager.set_time_remaining(2)


func _on_fast_timer_button_pressed() -> void:
	if GameManager.timer_multiplier == 1.0:
		GameManager.timer_multiplier = 50.0
	else:
		GameManager.timer_multiplier = 1.0


func _on_main_menu_button_pressed() -> void:
	# scene transition
	GameManager.show_main_menu()
