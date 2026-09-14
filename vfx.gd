extends GPUParticles2D
var effect_colors = {
	"RollButton": Color(0.794, 0.0, 0.0, 1.0),
	"PortalEntrance": Color(0.142, 0.0, 0.988, 1.0),
	"PortalExit": Color(0.142, 0.0, 0.988, 1.0),
	"XP": Color(0.721, 0.496, 0.011, 1.0),
	"Next": Color(0.265, 0.552, 0.0, 1.0),
	"Back": Color(0.597, 0.073, 0.597, 1.0),
	"Plus Card": Color(0.608, 0.347, 0.2, 1.0),
	"Magnet": Color(0.834, 0.016, 0.187, 1.0),
	"Shop": Color(0.54, 0.287, 0.093, 1.0)
}
func _ready():
	emitting = false
	one_shot = true
	z_index = 99
func _process(delta: float) -> void:
	self.emitting = false
	self.visible = false
	
	

		


func play_effect_cursor():
	var clone: GPUParticles2D = duplicate()
	clone.set_script(null)
	clone.visible = true
	get_parent().add_child(clone)
	clone.global_position = get_global_mouse_position()
	clone.texture = load("res://textures/minidice.png")
	clone.restart()
	clone.emitting = true

	get_tree().create_timer(clone.lifetime + 0.1).timeout.connect(clone.queue_free)
	
func play_effect_at(node):
	var size := Vector2.ZERO
	var center := Vector2.ZERO

	if node is Control:
		size = node.size
		center = node.global_position + size / 2.0 - Vector2(0, 5)
		var tween = node.create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(node, "scale", Vector2(1.2, 1.2), 0.12)
		tween.tween_property(node, "scale", Vector2.ONE, 0.08)
	elif node is Sprite2D and node.texture:
		var rect = node.get_rect()
		var corners := [
			node.to_global(rect.position),
			node.to_global(rect.position + Vector2(rect.size.x, 0)),
			node.to_global(rect.position + Vector2(0, rect.size.y)),
			node.to_global(rect.position + rect.size)
		]


		var min_pos = corners[0]
		var max_pos = corners[0]

		for p in corners:
			min_pos = min_pos.min(p)
			max_pos = max_pos.max(p)

		size = max_pos - min_pos
		center = (min_pos + max_pos) / 2.0

	var color := Color.WHITE
	if effect_colors.has(node.name):
		color = effect_colors[node.name]
	elif effect_colors.has(node.tile_name):
		color = effect_colors[node.tile_name]

	spawn_side(center, size, Vector2(0, -1), color)
	spawn_side(center, size, Vector2(0, 1), color)
	spawn_side(center, size, Vector2(-1, 0), color)
	spawn_side(center, size, Vector2(1, 0), color)


func spawn_side(center: Vector2, size: Vector2, direction: Vector2, color: Color):
	var effect: GPUParticles2D = duplicate()
	effect.set_script(null)
	effect.process_material = effect.process_material.duplicate()

	get_tree().current_scene.add_child(effect)

	effect.self_modulate = color
	effect.scale = Vector2.ONE / 2

	var material := effect.process_material as ParticleProcessMaterial

	if material:
		material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
		material.spread = 0.0
		material.direction = Vector3(direction.x, direction.y, 0)

		if direction.y != 0:
			material.emission_box_extents = Vector3(size.x*2 / 2.0, 1.0, 0.0)
		else:
			material.emission_box_extents = Vector3(1.0, size.y / 2.0, 0.0)

	var inset := 3.0 

	var edge_offset := Vector2(
		size.x * 0.5 * abs(direction.x),
		size.y * 0.5 * abs(direction.y)
	)


	if direction.y > 0:
		edge_offset.y -= 30.0
	elif direction.x != 0:
		edge_offset.y -= 30.0

	effect.global_position = center + direction * edge_offset - direction * inset
	effect.visible = true
	effect.restart()
	effect.emitting = true
	effect.finished.connect(effect.queue_free)
