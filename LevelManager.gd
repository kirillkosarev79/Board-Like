extends Node
@onready var player_list = get_node('../Board/Players').get_children()
var min_lvl = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for player in player_list:
		min_lvl = 0
		for i in player.powers:
			if i == "Safety net":
				min_lvl += 1
		if player.level < min_lvl: player.level = min_lvl
func tax(user):
	for player in player_list:
		if player != user:
			var total = 0
			for i in player.powers:
				total += 1
			total += player.card_amount
			player.level -= total
			if player.level < 0: player.level = 0
		if "Vampire" in user.powers: level_up(user,1)

func level_up(player, amount):
	if get_node("../Modificators").current_mod == "Double XP":
		player.level += amount*2
	else:
		player.level += amount

func level_down(player, amount):
	player.level -= amount
