extends Node2D

var cluster: Cluster = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = cluster.get_name()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
