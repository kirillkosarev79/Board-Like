extends Sprite2D
@export var nickname : String
@export var level : int
@onready var Tooltip = get_node("../../../Tooltip")
var col = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	for i in get_children():
		if "Power" in i.name:
			i.mouse_entered.connect(_on_mouse_entered.bind(i))
			i.mouse_exited.connect(_on_mouse_exited)
		elif "Card" in i.name:
			i.mouse_entered.connect(_on_mouse_enteredc.bind(i))
			i.mouse_exited.connect(_on_mouse_exitedc)
	col = Globals.bar_colors[self.nickname]
	self_modulate = col
	get_child(1).text = self.nickname
	get_child(1).self_modulate = col+Color(0.329, 0.329, 0.329, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	for player in get_node("../../Players").get_children():
		if player.nickname == self.nickname:
			get_child(0).text = (str(player.level))
			get_child(0).self_modulate =Color(0.0, 3.887, 1.631, 1.0)
			
			player.modulate = self.self_modulate
			for i in range(player.cards.size()):
				var card = player.cards[i]
				var icon = get_child(i + 2)

				if card == "None":
					icon.texture = null
					icon.name = " "
				elif icon is TextureRect:
					icon.texture = Globals.cards[card][0]
					icon.name = card
			for i in range(player.powers.size()):
				var power = player.powers[i]
				get_child(i + 5).texture_normal = Globals.powers[power][0]
				get_child(i + 5).name = power
			if player.stuck:
				self_modulate = col * Color(0.307, 0.307, 0.307, 1.0)
			else:
				self_modulate = col
				
				
				

				
func _on_mouse_entered(power_node):
	var a = power_node.name
	if not a in Globals.powers.keys():
		a = ""
		for i in str(power_node.name):
			if not i.is_valid_int():
				a += i
	if a in Globals.powers.keys():
		Tooltip.tip(a, "Power")

func _on_mouse_exited():
	Tooltip.visible = false

func _on_mouse_enteredc(card_node):
	var a = card_node.name
	if not a in Globals.cards.keys():
		a = ""
		for i in str(card_node.name):
			if not i.is_valid_int():
				a += i
	if a in Globals.cards.keys():
		Tooltip.tip(a, "Card")

func _on_mouse_exitedc():
	Tooltip.visible = false
