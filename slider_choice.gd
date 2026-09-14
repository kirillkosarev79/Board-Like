extends Node2D
var svalue = 0
@onready var Tiles = get_node("../../Board/Tiles")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	conditionprocess()
	if get_parent().type == 'Condition':
		$Button.pressed.connect(conditionpress)
		
func conditionprocess():
	svalue = roundi($HSlider.value)
	if svalue == 0:
		$HSlider/Label.text = "No condition"
	elif svalue == 1:
		$HSlider/Label.text = (str(svalue)+" Level")
	else:
		$HSlider/Label.text = (str(svalue)+" Levels")
		
func conditionpress():
	self.visible = false
	get_parent().type = null
	get_parent().visible = false
	for i in Tiles.get_children():
		if svalue == 0:
			i.CondCard("No")
		else:
			i.CondCard(str(svalue))
	get_node("../Option1")._delete_card()
