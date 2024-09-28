extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start() # TODO: Remove this


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	# navigate to the job selection screen
	start()
	
func start() -> void:
	get_tree().change_scene_to_file("res://scenes/job_selection.tscn")
