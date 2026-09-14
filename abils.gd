extends TextureButton
@export var ability_name : String
@onready var player = ''
@onready var rollbutton = get_node("../../RollButton")
@onready var LevelManager = get_node("../../../LevelManager")
@onready var Tooltip = get_node("../../../Tooltip")
var normal_scale := Vector2.ONE
var hover_scale := Vector2(1.05, 1.05)


func _ready() -> void:
	await get_tree().process_frame
	self.visible = false
	self.disabled = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)



func _process(delta: float) -> void:
	var mouse_over = get_global_rect().has_point(get_global_mouse_position())

	if ability_name == 'None' or ability_name == null:
		self.visible = false
	else:
		if not Globals.cards.has(ability_name):
			return

		var ti = Globals.cards[ability_name][3]

		player = Globals.playerturn
		if ti == "A" and not get_node("../../MainButton").disabled:
			self.disabled = false
		elif ti == 'B' and not Globals.moving and get_node("../../MainButton").disabled:
			self.disabled = false
		elif ti == 'B1' and not Globals.moving and get_node("../../MainButton").disabled and player.level > 0:
			self.disabled = false
		else:
			self.disabled = true

	
	
func _card_cliked():
	if self.ability_name == "Restart":
		player.player_pos = 0
		player.position.x = get_node("../../Start").position.x
		player.position.y =  get_node("../../Start").position.y
		_delete()
	if self.ability_name == "Reroll":
		Globals.dice_canceled = true
		_delete()
	if self.ability_name == "Rainbow Paint":
		Globals.choosing_tile = true
		_delete()
	if self.ability_name == "Sleeping Pill":
		get_node('../../../ChoiceMenu').pillchoice()
	if self.ability_name == "Taxes":
		LevelManager.tax(player)
		_delete()
	if self.ability_name == "Crossroad":
		get_node("../../../ChoiceMenu").CrossRoadChoice()
	if self.ability_name == "Conditionning":
		get_node("../../../ChoiceMenu").condchoice()
	Globals.using_card = self.name
func _delete():
	if player.cards.find(self.ability_name) != -1:
		player.cards[player.cards.find(self.ability_name)] = "None"
	
	
func _on_mouse_entered():
	Tooltip.tip(self.ability_name, "Card")
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", hover_scale, 0.12)

func _on_mouse_exited():
	Tooltip.visible = false
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", normal_scale, 0.12)
