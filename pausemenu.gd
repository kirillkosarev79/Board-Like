extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			self.visible = true
			get_node("../Settings").visible = false
			
			
func continue_pressed():
	self.visible = false

func settings_pressed():
	get_node("../Settings").visible = true

func main_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
