extends Node2D
@onready var items = [get_node("Item1"),get_node("Item2"),get_node("Item3")]
var start_pos = self.position
var intro_pos = Vector2(self.position.x, self.position.y-500)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = Globals.playerturn
	$LevelDisplay.text =  "Level: [color=white]" + str(player.level) + "[/color]"
	

func open_shop():
	self.visible = true
	$ColorRect/Label.text = "Shop"
	var tween = create_tween()
	tween.set_parallel()
	self.position = intro_pos
	self.position = start_pos + Vector2(0, 20)
	self.scale = Vector2(0.95, 0.95)
	self.modulate.a = 0.0
	tween.tween_property(self, "position", start_pos, 0.22)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "scale", Vector2.ONE, 0.22)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "modulate:a", 1.0, 0.18)\
		.set_trans(Tween.TRANS_LINEAR)
	for item in items:
		if randf()<0.5: item.item_name = Globals.cards.keys().pick_random()
		else: item.item_name = Globals.powers.keys().pick_random()
		item.shop_type = "Norm"
	
func open_inv_shop():
	self.visible = true
	$ColorRect/Label.text = "Inverted Shop"
	for item in items:
		if randf()<0.5 and Globals.playerturn.powers:
			item.item_name = Globals.playerturn.powers.pick_random()
		else:
			item.item_name = Globals.playerturn.cards.pick_random()
		item.shop_type = "Inv"
	
	var tween = create_tween()
	tween.set_parallel()
	self.position = intro_pos
	self.position = start_pos + Vector2(0, 20)
	self.scale = Vector2(0.95, 0.95)
	self.modulate.a = 0.0
	tween.tween_property(self, "position", start_pos, 0.22)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "scale", Vector2.ONE, 0.22)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "modulate:a", 1.0, 0.18)\
		.set_trans(Tween.TRANS_LINEAR)
	
	
	
func closepressed():
	self.visible = false

func wait_until_hidden():
	while self.visible:
		await get_tree().process_frame
