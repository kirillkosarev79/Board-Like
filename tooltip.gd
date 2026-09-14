extends PanelContainer
@onready var Tooltip = get_node('MarginContainer/VBoxContainer')
@onready var Name = get_node('MarginContainer/VBoxContainer/Name')
@onready var Type = get_node('MarginContainer/VBoxContainer/Type')
@onready var Tier = get_node("MarginContainer/VBoxContainer/Tier")
@onready var Description = get_node('MarginContainer/VBoxContainer/Description')
var style := get_theme_stylebox("panel").duplicate() as StyleBoxFlat
var width := size.x
var tooltip_rect := self.get_global_rect()
var viewport_rect := Rect2(Vector2.ZERO, get_viewport_rect().size)

var tile_descriptions = {
	"XP": "🟢Gain 1 level",
	"Plus Card": "🟢Get a card",
	"Blank Tile":"🟢Blank Tile takes the color of the last player that stepped on it. At the end of the round get a power-up for every Blank Tile with your color",
	"Magnet": "🔴50% chance to be attracted to the start\n🟢50% chance to be attracted to finish",
	"Next": "Skip to the next tile",
	"Back": "Go to the previous tile",
	"Shop": "🟢Buy items for levels",
	"Again": "🟢It's your turn again!",
	"Inverted Shop": "🟢Sell items for levels"
}

var power_descriptions = {
	"Vampire": "🟢Gain 1 level when casting a negative effect on any player:\n-Sleeping Pill\n-Taxes",
	"Lucky Clover": "🟢+15% points to your advantage in any luck-based events:\n-Magnet",
	"Dice": "🟢Rolls an additional dice",
	"Caesium-137": "🟢Gains 1 level every time after passing through a portal in any direction",
	"Safety net": "Increase your minimal level by 1",
	"Assets": "Gain 2 levels if you have 3 cards by the end of the round"
}

var modificator_descriptions = {
	"Double XP": "Gain twice as much XP as you would normally",
	"Half dice": "All dice rolls are divided by 2",
	"No conditions": "All tiles are free!",
	"Action Time": "No Next and Back tiles"
}

var tier_colors = {
	1: Color(0.318, 0.318, 0.318, 1.0),
	2: Color(0.27, 0.553, 0.834, 1.0),
	3: Color(0.233, 0.674, 0.0, 1.0),
	4: Color(1.0, 0.0, 0.0, 1.0),
	5: Color(0.891, 0.709, 0.0, 1.0)
}

func _ready() -> void:
	self.z_index = 100
	style.bg_color = Color(0.0, 0.0, 0.0, 0.745)
	style.border_width_right = 3
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_bottom = 3
	add_theme_stylebox_override("panel", style)


var OFFSET := Vector2(10, 10)

func _process(_delta):
	if not visible:
		return

	var mouse_pos := get_viewport().get_mouse_position()
	var viewport_size := get_viewport_rect().size

	if mouse_pos.y + tooltip_rect.size.y + 10 > viewport_size.y:
		OFFSET = Vector2(10, -tooltip_rect.size.y - 75)
	else:
		OFFSET = Vector2(10, 10)

	global_position = mouse_pos + OFFSET
		
func tip(name, type):
	if not name:
		return
	self.visible = true
	Name.text = name
	Type.text = type
	Description.text = "*no description*"
	if type == "Tile": 
		if tile_descriptions[name]: Description.text = tile_descriptions[name]
		Tier.text = ("Tier " + str(Globals.bonus_tier[name]))
		Tier.add_theme_color_override("font_color", tier_colors[Globals.bonus_tier[name]])
		style.border_color = Color(0.758, 0.62, 0.0, 1.0)
	if type == "Card": 
		Tier.text = ("Tier " + str(Globals.cards[name][4]))
		Tier.add_theme_color_override("font_color", tier_colors[Globals.cards[name][4]])
		if Globals.cards[name][2]: Description.text = Globals.cards[name][2]
		style.border_color = Color(0.252, 0.304, 0.858, 1.0)
	if type == "Power":
		Tier.text = ("Tier " + str(Globals.powers[name][3]))
		Tier.add_theme_color_override("font_color", tier_colors[Globals.powers[name][3]])
		if power_descriptions[name]: Description.text = power_descriptions[name]
		style.border_color = Color(0.235, 0.538, 0.19, 1.0)
	if type == "Modificator":
		Tier.text = ""
		Description.text = modificator_descriptions[name]
		style.border_color = Color(0.487, 0.003, 0.87, 1.0)
	add_theme_stylebox_override("panel", style)
	await get_tree().process_frame
	reset_size()
	size.x = width
