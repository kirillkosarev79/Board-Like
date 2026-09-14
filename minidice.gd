extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween := create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.8)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


	
