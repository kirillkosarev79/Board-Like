extends Sprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(Globals.player_amount):
		var player = Sprite2D.new()
		add_child(player)
		player.set_script(load("res://player.gd"))
		player.nickname = Globals.bar_colors.keys()[i]
		player.texture = Globals.icons[player.nickname]
		player.position.x = get_node("../Start").position.x
		player.position.y = get_node("../Start").position.y
		player.scale.x = 0.3
		player.scale.y = 0.3
		player.name = Globals.bar_colors.keys()[i]
		player.set_process(true)
		
	Globals.turn = randi_range(0,len(get_children())-1)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(float) -> void:
	for i in get_children():
		Globals.players[i.nickname] = {
		"score": i.level,
		"color": i.modulate}
