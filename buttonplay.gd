extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_play():
	Globals.player_amount = int(round(get_parent().get_node('Playeramount').value))
	Globals.round_amount = int(round(get_parent().get_node('Roundamount').value / 5.0) * 5)
	get_tree().change_scene_to_file("res://profiles.tscn")
