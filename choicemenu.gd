extends Node
@export var type = ''
@export var powerplayer = ''
@onready var first_row = $Option1
@onready var start_pos = self.position
@onready var background = get_node("ChoiceBack")
signal hidden
var intro_pos = Vector2(self.position.x, self.position.y-500)
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Globals.finished_player and not self.visible:
		await wait_until_hidden()
		powerchoice(Globals.finished_player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func powerchoice(player):
	
	if len(player.powers)>= 6:
		return
	await intro()
	$Title.text = player.name
	powerplayer = player
	get_node('CancelButton').visible = false
	var rows = [first_row]
	rows.append(first_row)
	first_row.hover_scale = Vector2(1.05, 1.05)
	first_row.normal_scale = Vector2(1, 1)
	self.type = 'power'
	var background = get_node("ChoiceBack")
	background.self_modulate = Color(0.397, 0.043, 0.645, 0.78)
	background.visible = true
	for i in range(2):
		var row = first_row.duplicate()
		add_child(row)
		row.position.y = first_row.position.y + (i + 1) * 220
		rows.append(row)
	for option in rows:
		option.visible = true
		option.choice = Globals.powers.keys().pick_random()
		option.self_modulate = Globals.powers[option.choice][2]
		option.get_node('Icon').texture = Globals.powers[option.choice][0]
		option.get_node('Label').text = Globals.powers[option.choice][1]
func pillchoice():
	await intro()
	get_node('CancelButton').visible = true
	$Title.text = Globals.playerturn.name
	self.type = 'pill'
	
	background.self_modulate = Color(0.143, 0.413, 0.245, 1.0)
	background.visible = true
	
	first_row.hover_scale = Vector2(1.05, 0.7)
	first_row.normal_scale = Vector2(1, 0.65)
	var rows = [first_row]

	for i in range(Globals.players.size() - 1):
		var row = first_row.duplicate()
		
		add_child(row)

		# Move each new row below the previous one
		row.position.y = first_row.position.y + (i + 1) * 170

		rows.append(row)

	for i in range(Globals.players.size()):
		var player_name = Globals.players.keys()[i]
		var player_data = Globals.players[player_name]
		var row = rows[i]

		row.get_node("Label").text = player_name
		row.self_modulate = player_data["color"]
		
		
func CrossRoadChoice():
	await intro()
	first_row.visible = false
	background.self_modulate = Color(0.337, 0.337, 0.337, 0.733)
	get_node("2OptionChoice").visible = true
	self.type = "Road"
	$"2OptionChoice/Option1".texture_normal = load("res://textures/RoadLeft.png")
	$"2OptionChoice/Option2".texture_normal = load("res://textures/RoadRight.png")
	$"2OptionChoice/Label".text = "Choose the direction of the tile"
	

func condchoice():
	await intro()
	first_row.visible = false
	background.self_modulate = Color(0.18, 0.49, 0.784, 0.737)
	$SliderChoice.visible = true
	self.type = "Condition"
	$"SliderChoice/HSlider".min_value = 0
	$"SliderChoice/HSlider".max_value = len(Globals.conditions)-1
	$"SliderChoice/Button".text = "Set condition"
	
func intro():
	await wait_until_hidden()
	self.visible = true
	for i in get_children():
		if i != first_row and "Option" in i.name:
			i.queue_free()
	first_row.visible = true
	var tween = create_tween()
	self.position = intro_pos
	self.position = start_pos + Vector2(0, 20)
	self.scale = Vector2(0.95, 0.95)
	self.modulate.a = 0.0

	tween.set_parallel()

	tween.tween_property(self, "position", start_pos, 0.22)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "scale", Vector2.ONE, 0.22)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(self, "modulate:a", 1.0, 0.18)\
		.set_trans(Tween.TRANS_LINEAR)

func wait_until_hidden():
	while self.visible:
		await get_tree().process_frame
		
func pick_random_power() -> String:
	var total_weight := 0
	var weights := {}

	for name in Globals.powers:
		var tier = Globals.powers[name][3]
		var weight = 0

		match tier:
			1:
				weight = 40
			2:
				weight = 30*Globals.round**0.2
			3:
				weight = 20*Globals.round**0.4
			4:
				weight = 10*Globals.round**0.6
			5:
				weight = 5*Globals.round**0.8

		weights[name] = weight
		total_weight += weight

	var roll = randi_range(1, total_weight)

	for name in weights:
		roll -= weights[name]
		if roll <= 0:
			return name

	return ""
