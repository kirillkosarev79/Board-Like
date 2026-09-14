extends Node2D
@onready var x = get_child(0).position.x
@onready var y = get_child(0).position.y
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(int(Globals.player_amount) -1):
		var a = get_child(0).duplicate()
		add_child(a)
		a.position = Vector2(x+660,y)
		x += 660
	for statbar in get_children():
		statbar.nickname = Globals.bar_colors.keys()[statbar.get_index()]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
