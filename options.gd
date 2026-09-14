extends TextureButton
@export var choice = ""
@export var normal_scale := Vector2.ONE
@export var hover_scale := Vector2(1.05, 1.05)
@onready var LevelManager = get_node("../../LevelManager")
var player = ''


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = Globals.playerturn

	if get_parent().type == 'pill':
		if is_connected("pressed", powerpress):
			pressed.disconnect(powerpress)
		if not is_connected("pressed", pillpress):
			pressed.connect(pillpress)

	elif get_parent().type == 'power':
		if is_connected("pressed", pillpress):
			pressed.disconnect(pillpress)
		if not is_connected("pressed", powerpress):
			pressed.connect(powerpress)
	
	get_node("Label").scale = Vector2(1,1)
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", normal_scale, 0.12)
	


func _ready():
	mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", hover_scale, 0.12)

func powerpress():
	get_parent().powerplayer.powers.append(self.choice)
	if get_parent().powerplayer == Globals.finished_player:
		Globals.finished_player = null
	get_parent().powerplayer = ''
	get_parent().visible = false
func pillpress():
	_delete_card()
	if not 'Vampire' in player.powers:
		LevelManager.level_down(player, 1)
	Globals.skipping_turn.append(self.get_node('Label').text)
	get_parent().visible = false

func _delete_card():
	if player.cards.find(get_node('../../Board/Cards').get_node(NodePath(Globals.using_card)).ability_name) != -1:
		player.cards[player.cards.find(get_node('../../Board/Cards').get_node(NodePath(Globals.using_card)).ability_name)] = "None"
	get_node('../../Board/Cards').get_node(NodePath(Globals.using_card)).ability_name = 'None'
	player.card_amount -= 1
