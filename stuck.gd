extends Control 
@onready var label_start_pos = $Label.global_position 
@onready var statbars = get_node("../Board/Stats").get_children() 
# Called when the node enters the scene tree for the first time. 
func _ready() -> void: 
	pass
	# Called every frame. 'delta' is the elapsed time since the previous frame. 
func _process(delta: float) -> void: 
	pass 
	
func stuck(player):
	var statbar = null 
	for i in statbars: 
		if i.nickname == player.name: 
			statbar = i 
	self.visible = true 
	get_node("SFX").playing = true 
	$Label.global_position = label_start_pos+Vector2(-30,-100) 
	var tween = get_tree().create_tween() 
	tween.tween_property($Label, "global_position", label_start_pos, 0.1) 
	await get_tree().create_timer(1).timeout 
	tween = get_tree().create_tween() 
	var target_size = $Label.size * 0.3
	var target_pos = statbar.global_position - (target_size / 2.0) + Vector2(10,35)

	tween = get_tree().create_tween()
	tween.set_parallel(true)

	tween.tween_property($Label, "scale", Vector2(0.3, 0.3), 1)
	tween.tween_property($Label, "global_position", target_pos, 1.0)

	await tween.finished
	
	Globals.playerturn.stuck = true
