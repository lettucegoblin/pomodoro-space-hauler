extends Control

@export var prefix: String = ""
@export var postfix: String = ""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.connect("timer_updated", Callable(self, "_on_timer_updated"))
	

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
