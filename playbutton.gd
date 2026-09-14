extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var label = Label.new()
	label.text  = "Play"
	label.size = self.size
	label.horizontal_alignment = 3
	label.vertical_alignment = 3
	add_child(label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
