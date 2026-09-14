extends CheckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_pressed = Globals.console_on


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if button_pressed:
		Globals.console_on = true
	else:
		Globals.console_on = false
