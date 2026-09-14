extends TextureRect
@export var item_name = ""
@onready var powers_cards = Globals.powers.merged(Globals.cards)
@onready var Tooltip = get_node("../../Tooltip")
@export var shop_type = "Norm"
var player = null
var prices = {
	"Vampire": 3,
	"Lucky Clover": 2,
	"Dice": 4,
	"Caesium-137":4,
	"Reroll": 1,
	"Restart": 1,
	"Rainbow Paint":1,
	"Sleeping Pill":2,
	"Taxes": 3,
	"Crossroad": 2,
	"Conditionning": 3,
	"Safety net":2,
	"Assets":1
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	player = Globals.playerturn
	if self.item_name and shop_type == "Norm":
		self.texture = powers_cards[item_name][0]
		if self.item_name in Globals.cards.keys():
			get_node("Price").text = "Buy [color=white]" + str(Globals.cards[item_name][4]) + " lvl[/color]"
		elif self.item_name in Globals.powers.keys():
			get_node("Price").text = "Buy [color=white]" + str(Globals.powers[item_name][3]) + " lvl[/color]"
	elif self.item_name and shop_type == "Inv":
		self.texture = powers_cards[item_name][0]
		if self.item_name in Globals.cards.keys():
			get_node("Price").text = "Sell for [color=white]" + str(Globals.cards[item_name][4]) + " lvl[/color]"
		elif self.item_name in Globals.powers.keys():
			get_node("Price").text = "Sell for [color=white]" + str(Globals.powers[item_name][3]) + " lvl[/color]"
func pressed():
	if self.shop_type == "Inv":
		
		if item_name in player.powers:
			player.powers.erase(item_name)
		elif item_name in player.cards:
			player.card_amount -= 1
			player.cards.erase(item_name)
		else:player.level -= prices[item_name]

		player.level += prices[item_name]
	else:
		if player.level >= prices[item_name]:
			$Button.disabled = true
			if item_name in Globals.powers.keys():
				player.powers.append(item_name)
			elif item_name in Globals.cards.keys():
				player.card_amount += 1
				get_node("../../Board/Cards").add_card(player, item_name)
			player.level -= prices[item_name]

		else:
			$"../ErrorSound".play()
			$"../LevelDisplay".modulate = Color(0.85, 0.0, 0.0, 1.0)
			var start_pos = $"../LevelDisplay".position.x
			var level_display = $"../LevelDisplay"
			var tween = create_tween()

			for i in range(3):
				tween.tween_property(level_display, "position:x", start_pos + 5.0, 0.1)
				tween.tween_property(level_display, "position:x", start_pos - 5.0, 0.1)

			tween.tween_property(level_display, "position:x", start_pos, 0.1)
			await get_tree().create_timer(0.7).timeout
			$"../LevelDisplay".modulate = Color(1.0, 1.0, 1.0, 1.0)
		


	
	


func mouse_entered():
	if self.item_name in Globals.cards.keys():
		Tooltip.tip(self.item_name, "Card")
	elif self.item_name in Globals.powers.keys():
		Tooltip.tip(self.item_name, "Power")
func mouse_exited():
	Tooltip.visible = false
