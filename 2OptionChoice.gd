extends Node2D
@onready var Tiles = get_node("../../Board/Tiles")
@onready var VFX = get_node("../../Board/VFX")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().type == 'Road' and not $Option1.is_connected("pressed", roadpressleft):
		$Option1.pressed.connect(roadpressleft)
		$Option2.pressed.connect(roadpressright)

func roadpressleft():
	VFX.play_effect_cursor()
	self.visible = false
	get_parent().type = null
	get_parent().visible = false
	for i in Tiles.get_children():
		i.CrossRoadLeft()
	get_node("../Option1")._delete_card()
	
func roadpressright():
	VFX.play_effect_cursor()
	self.visible = false
	get_parent().type = null
	get_parent().visible = false
	for i in Tiles.get_children():
		i.CrossRoadRight()
	get_node("../Option1")._delete_card()
	
