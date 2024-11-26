extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../OptionsPanelContainer".visible = false
	%WorkSpinBoxMin.value = GameManager.WORK_INTERVAL
	%BreakSpinBoxMin.value = GameManager.BREAK_INTERVAL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	$"../OptionsPanelContainer".visible = !$"../OptionsPanelContainer".visible


func _on_work_spin_box_min_value_changed(value: float) -> void:
	GameManager.WORK_INTERVAL = value


func _on_work_spin_box_sec_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_break_spin_box_min_value_changed(value: float) -> void:
	GameManager.BREAK_INTERVAL = value


func _on_break_spin_box_sec_value_changed(value: float) -> void:
	pass # Replace with function body.
