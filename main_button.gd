extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _main_button_pressed():
	self.disabled = true
	
