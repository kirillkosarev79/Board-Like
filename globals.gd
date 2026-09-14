extends Node
var round_amount = null
var round = 1
var turn = null
var playerturn = null
var skipping_turn = []
var using_card = ''
var console_on = false
var bonuses = {
	"Next": preload("res://textures/tiles/Arrow.png"),
	"Back": preload("res://textures/tiles/BackArrow.png"),
	"XP": preload("res://textures/tiles/power up.png"),
	"Magnet": preload("res://textures/tiles/magnet/magnet0.png"),
	"Plus Card": preload("res://textures/tiles/plus.png"),
	"Blank Tile": preload("res://textures/tiles/BlankTile.png"),
	"Shop": preload("res://textures/tiles/shop.png"),
	"Again" : preload("res://textures/tiles/again.png"),
	"Inverted Shop": preload("res://textures/tiles/invshop.png")
}

var bonus_tier = {
	"Next": 1,
	"Back": 1,
	"XP": 2,
	"Plus Card": 3,
	"Shop": 3,
	"Magnet": 4,
	"Blank Tile": 5,
	"Again": 4,
	"Inverted Shop": 3
}

var conditions = [
	"No", 
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7"
]

var round_chances = {
	1: {"No": 40, "1": 20, "2": 10, "3": 3},
	2: {"No": 30, "1": 35, "2": 25, "3": 8, "4": 2},
	3: {"No": 15, "1": 20, "2": 30, "3": 25, "4": 8, "5": 2},
	4: {"No": 12, "2": 25, "3": 30, "4": 22, "5": 9, "6": 2},
	5: {"No": 8, "3": 20, "4": 30, "5": 28, "6": 10, "7": 4},
	6: {"No": 6, "4": 18, "5": 28, "6": 30, "7": 12, "8": 6},
	7: {"No": 4, "5": 18, "6": 26, "7": 30, "8": 14, "9": 8},
	8: {"No": 3, "6": 16, "7": 24, "8": 30, "9": 17, "10": 10},
	9: {"No": 2, "7": 16, "8": 24, "9": 30, "10": 20},
	10:{"No": 1, "8": 15, "9": 25, "10": 40}
}

var cards = {
	"Reroll": [
		preload("res://textures/cards/reroll0.png"),
		preload("res://textures/cards/reroll1.png") ,
		"🟢After rolling your dice, click on this card to reroll.",
		'A',
		2
	],
	"Restart": [
		preload("res://textures/cards/restart1.png"),    
		preload("res://textures/cards/restart.png") ,
		"🟢Teleport to start" ,
		'B',
		1
	],
	"Rainbow Paint":[
		preload("res://textures/cards/randomize0.png"),
		preload("res://textures/cards/randomize1.png"),
		"🟢Click on a tile to randomly change it",
		'B',
		1
	],
	"Sleeping Pill":[
		preload("res://textures/cards/sleeppill.png"),
		preload("res://textures/cards/sleeppill.png"),
		"🔴Lose 1 level\n🟢Choose 1 player, this player will skip their next turn",
		'B1',
		3
	],
	"Taxes": [
		preload("res://textures/cards/tax.png"),
		preload("res://textures/cards/tax.png"),
		"🟢Everyone except you looses one level for each power-up and card they have",
		"B",
		4
	],
	"Crossroad": [
		preload("res://textures/cards/Road.png"),
		preload("res://textures/cards/Road.png"),
		"Change any tile to Next or Back",
		"B",
		3
	],
	"Conditionning": [
		preload("res://textures/cards/Conditionning.png"),
		preload("res://textures/cards/Conditionning.png"),
		"Set any condition on a tile of your choice.",
		"B",
		3
	]
	
}
var powers = {
	"Vampire": [
		preload('res://textures/power-ups/Vampire.png'),
		"Vampire. Level up every time you cast a negative effect on your opponents",
		Color(0.104, 0.095, 0.418, 1.0),
		2
	],
	"Lucky Clover": [
		preload('res://textures/power-ups/clover.png'),
		"The lucky clover. You're 15% luckier!",
		Color(0.056, 0.418, 0.116, 1.0),
		1
	],
	"Dice": [
		preload('res://textures/power-ups/dice.png'),
		"An additional dice for your rolls",
		Color(0.285, 0.285, 0.285, 1.0),
		4
	],
	"Caesium-137": [
		preload("res://textures/power-ups/pgun.png"),
		"Caesium-137. Gain 1 level every time you pass through the portals.",
		Color(0.0, 0.625, 0.0, 1.0),
		3
	],
	"Safety net": [
		preload("res://textures/power-ups/net.png"),
		"Increase your minimal level by 1",
		Color(0.192, 0.463, 0.631, 1.0),
		2
	],
	"Assets": [
		preload("res://textures/power-ups/assets.png"),
		"Gain 2 levels if you have 3 cards in the end of the round",
		Color(0.924, 0.657, 0.0, 1.0),
		1
	]
}




var bar_colors = {}
var icons = {}
var moving = false
var dice_canceled = false
var choosing_tile = false
var choosing = null
var finished_player = null
var player_amount = 2
var players: Dictionary = {}

func change_scene(new_scene_path: String):
	var new_scene = load(new_scene_path).instantiate() 
	get_tree().root.add_child(new_scene)             
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()          
	get_tree().current_scene = new_scene  
	

var choice = null

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_node_or_null("/root/CanvasLayer/Board/Players"):
		playerturn = get_node("/root/CanvasLayer/Board/Players").get_children()[turn-1]
	
