extends TextureButton
@export var condition = null
@export var tile_name : String
@onready var Tooltip = get_node('../../../Tooltip')
var normal_scale := Vector2.ONE
var hover_scale := Vector2(1.05, 1.05)
var BlankTileCandidate = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(tile_clicked)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	$Label.position = Vector2(100,120)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(float) -> void:
	if self.condition and self.condition != "No":
		$Label.text = self.condition
	else:
		$Label.text = ''
func tile_clicked():
	if Globals.choosing_tile:
		var base = Globals.bonuses.values().pick_random()
		var base_img = base.get_image()
		var overlay_tex = null
		self.condition = Globals.conditions.pick_random()
		if self.condition:
			overlay_tex = load("res://textures/conditions/cond 1.png")


		if overlay_tex:
			var overlay_img = overlay_tex.get_image()
			var overlay_size = overlay_img.get_size()
			var offset = Vector2(
				(base_img.get_width() - overlay_size.x) / 2,
				(base_img.get_height() - overlay_size.y) / 2
			)
			base_img.blend_rect(overlay_img, Rect2(Vector2.ZERO, overlay_size), offset)
		self.texture_normal = ImageTexture.create_from_image(base_img)
		Globals.choosing_tile = false
		
		
func _on_mouse_entered():
	Tooltip.tip(self.tile_name, "Tile")
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





func CrossRoadRight():
	self.disabled = false
	await self.pressed
	for i in get_parent().get_children():
		i.disabled = true
	self.tile_name = "Next"
	update_tile()

func CrossRoadLeft():
	self.disabled = false
	await self.pressed
	for i in get_parent().get_children():
		i.disabled = true
	self.tile_name = "Back"
	update_tile()
	
func CondCard(newcondition):
	self.disabled = false
	await self.pressed
	for i in get_parent().get_children():
		i.disabled = true
	self.condition = newcondition
	update_tile()
	
func update_tile():
	var base = Globals.bonuses[self.tile_name].get_image()
	var overlay = null
	if self.condition != "No":
		overlay = load("res://textures/conditions/cond 1.png")
	if overlay:
		var offset = Vector2(
				(base.get_width() - overlay.get_size().x) / 2,
				(base.get_height() - overlay.get_size().y) / 2
			)
		base.blend_rect(overlay.get_image(), Rect2(Vector2.ZERO, overlay.get_size()), offset)
	self.texture_normal = ImageTexture.create_from_image(base)
	

func pick_random_condition() -> String:
	var table = Globals.round_chances.get(min(Globals.round, 10), Globals.round_chances[10])

	var total := 0
	for weight in table.values():
		total += weight

	var roll = randi() % total
	var current := 0

	for condition in table.keys():
		current += table[condition]
		if roll < current:
			return condition

	return "No"
