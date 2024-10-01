extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!GameManager.debug):
		queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	GameManager.set_time_remaining(2)
