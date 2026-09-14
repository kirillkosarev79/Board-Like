extends Control
@export var current_mod = "psaifk"

var modificators = {
	"Double XP": load("res://textures/modificators/x2.png"),
	"No conditions": load("res://textures/modificators/nocond.png"),
	"Half dice": load("res://textures/modificators/halfdice.png"),
	"Action Time": load("res://textures/modificators/action.png")
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_mod:
		$TextureRect.texture = modificators[current_mod]
	else:
		$TextureRect.texture = null
	
func on_mouse_entered():
	get_node("../Tooltip").tip(current_mod, "Modificator")
func on_mouse_exited():
	get_node("../Tooltip").visible = false
	
	
	
func new_round():
	if not Globals.round == 1:
		current_mod = modificators.keys().pick_random()
	else:
		current_mod = null	
		
		
func change_modificator(mod_name):
	if mod_name in modificators.keys() or not mod_name:
		current_mod = mod_name
		return true
	return false
