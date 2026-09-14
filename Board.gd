extends Node2D





@onready var children = $Tiles.get_children()
@onready var rollbutton = $RollButton
@onready var mainbutton = $MainButton
@onready var LevelManager = get_node("../LevelManager")
@onready var VFX = get_node("VFX")
@onready var player_list = $Players.get_children()
@onready var Stuck = get_node("../Stuck")
var stuck_counter := 0
var last_loop_tile := ""
var portal_teleporting = false
var player
var target = null
signal player_reached_target
signal recoloring
var speed = 400
var dice : float
var start = true
var turn_again = false



func _ready():
	
	randomize() 
	recolor()
func _process(delta):
	
	
	player = Globals.playerturn

	if Globals.moving:
		move_player(delta)
func _on_roll_button_pressed():
	VFX.play_effect_cursor()
	$Portal.portal_on = true
	rollbutton.disabled = true


	
	var dice_amount = 1
	for i in player.powers:
		if i == 'Dice':
			dice_amount += 1
	dice = 0
	for i in range(dice_amount):
		dice += randi_range(1,6)
	await rollbutton.roll_dice(dice,dice_amount-1)
	mainbutton.disabled = false
	await mainbutton.pressed
	mainbutton.disabled = true
	
	if Globals.dice_canceled:
		dice = 0
		Globals.dice_canceled = false
		for i in range(10):
			await get_tree().create_timer(0.1).timeout
		for i in range(dice_amount):
			i = randi_range(1,6)
			dice += i
		
	if get_node("../Modificators").current_mod == "Half dice" and dice > 1:
		dice = floor(dice/2)
	player.player_pos += dice

	if player.player_pos <= children.size():
		target = children[player.player_pos-1]
		Globals.moving = true
		await self.player_reached_target
		await handle_bonus()
		if not turn_again:
			next_turn()
		else:
			next_turn(true)
		turn_again = false
	else:
		target = $FinalTile
		Globals.moving = true
		await self.player_reached_target
		await get_tree().create_timer(3).timeout
		Globals.round += 1
		if Globals.round <= Globals.round_amount:
			recolor()
			
		else:
			get_tree().change_scene_to_file("res://scoreboard.tscn")
	
func next_turn(again = false):
	if again:
		$TurnChangeAnim/TurnChangeLabel.text = player.nickname + "'s turn"
		$TurnChangeAnim.play("turn_change")
		rollbutton.disabled = false
		return
	var not_stuck = false
	var count = $Players.get_child_count()

	for i in range(count):
	
		Globals.turn += 1
		if Globals.turn > count:
			Globals.turn = 1

	
		player = $Players.get_child(Globals.turn - 1)

		
		if player.name in Globals.skipping_turn:
			Globals.skipping_turn.erase(player.name)
			continue

	
		if player.stuck:
			continue

		
		not_stuck = true
		break

	if not_stuck:
		$TurnChangeAnim/TurnChangeLabel.text = player.nickname + "'s turn"
		$TurnChangeAnim.play("turn_change")
		rollbutton.disabled = false
	else:
		
		for p in $Players.get_children():
			p.position = $Start.position
			p.player_pos = 0
			p.stuck = false

		Globals.round += 1

		if Globals.round <= Globals.round_amount:
			recolor()
		else:
			get_tree().change_scene_to_file("res://scoreboard.tscn")



func recolor():
				
	for i in $Players.get_children():
		i.stuck = false
		i.position = Vector2( get_node("Start").position.x, get_node("Start").position.y)
		i.player_pos = 0
	
	get_node("../Modificators").new_round()
	Globals.finished_player = player
	for tile in children:
		if tile.BlankTileCandidate:
			get_node('../ChoiceMenu').powerchoice(tile.BlankTileCandidate)
			tile.BlankTileCandidate = null
		$FlipSound.play()
		var index = children.find(tile)
		var target_pos = Vector2(index * 200 + 400, get_node("Start").position.y)
		if index >= 9:
			target_pos.y = $Portal/PortalExit.position.y
			target_pos.x = (index - 9) * 200 + 525
		
		var tile_name = pick_random_bonus()
		while get_node("../Modificators").current_mod == "Action Time":
			if tile_name == "Next" or tile_name == "Back":
				tile_name = pick_random_bonus()
			else: break
		tile.tile_name = tile_name
		var base = Globals.bonuses[tile_name]
		var base_img = base.get_image()
		var overlay_tex = null
		tile.condition = null
		if tile_name != "Blank Tile" and get_node("../Modificators").current_mod != "No conditions":
			tile.condition = $"Tiles/Tile1".pick_random_condition()
			if tile.condition != "No" and tile.condition != null:
				overlay_tex = load("res://textures/conditions/cond 1.png")
		
		if overlay_tex:
			var overlay_img = overlay_tex.get_image()
			var overlay_size = overlay_img.get_size()
			var offset = Vector2(
				(base_img.get_width() - overlay_size.x) / 2,
				(base_img.get_height() - overlay_size.y) / 2
			)
			base_img.blend_rect(overlay_img, Rect2(Vector2.ZERO, overlay_size), offset)
		
		tile.texture_normal = ImageTexture.create_from_image(base_img)
		tile.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		tile.set_size(tile.texture_normal.get_size())

		tile.set_anchors_preset(Control.PRESET_TOP_LEFT)
		tile.size_flags_horizontal = 0
		tile.size_flags_vertical = 0
		tile.custom_minimum_size = Vector2.ZERO

		var tex_size = tile.texture_normal.get_size()
		var final_pos = target_pos - tex_size / 2


		tile.position = final_pos + Vector2(0, -150)
		tile.scale = Vector2(0.8, 0.8)

		
		$FlipSound.pitch_scale = randf_range(0.95, 1.05)
		$FlipSound.play()

		var tween = create_tween()
		tween.set_parallel(true)

		tween.tween_property(
			tile,
			"position",
			final_pos,
			0.2
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

		tween.tween_property(
			tile,
			"scale",
			Vector2.ONE,
			0.2
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

		await tween.finished
	rollbutton.disabled = false
	emit_signal("recoloring")



func handle_bonus():
	VFX.play_effect_at(target)

	if target == $FinalTile:
		return
	if not target.tile_name:
		return
	if target.condition != null:
		if int(target.condition) > player.level:
			return

	
	if target.tile_name != "Next" and target.tile_name != "Back":
		stuck_counter = 0
		last_loop_tile = ""

	# Next
	if target.tile_name == "Next":
		if last_loop_tile == "Back":
			stuck_counter += 1
		else:
			stuck_counter = 1
		last_loop_tile = "Next"

		if stuck_counter >= 4:
			stuck_counter = 0
			last_loop_tile = ""
			await Stuck.stuck(player)
			return

		player.player_pos += 1
		target.texture_normal = preload("res://textures/tiles/Arrow on.png")

		if player.player_pos <= children.size():
			target = children[player.player_pos - 1]
			Globals.moving = true
			await self.player_reached_target
			await handle_bonus()
		else:
			target = $FinalTile
			Globals.moving = true
			await self.player_reached_target
			await get_tree().create_timer(3).timeout
			for player in $Players.get_children():
				player.position = Vector2(get_node("Start").position.x, get_node("Start").position.y)
				player.player_pos = 0
			Globals.round += 1
			if Globals.round <= Globals.round_amount:
				recolor()
			else:
				get_tree().change_scene_to_file("res://scoreboard.tscn")
		return

	# Back
	if target.tile_name == "Back":
		if last_loop_tile == "Next":
			stuck_counter += 1
		else:
			stuck_counter = 1
		last_loop_tile = "Back"

		if stuck_counter >= 4:
			stuck_counter = 0
			last_loop_tile = ""
			await Stuck.stuck(player)
			return

		player.player_pos -= 1

		if player.player_pos != 0:
			target = children[player.player_pos - 1]
			Globals.moving = true
			await self.player_reached_target
			await handle_bonus()
			return
		else:
			player.player_pos = 0
			target = $Start
			Globals.moving = true
			await self.player_reached_target
			return

	# Magnet
	if target.tile_name == "Magnet":
		speed = 800
		if randf() < 0.5 and "Lucky Clover" not in player.powers or "Lucky Clover" in player.powers and randf() < 0.65:
			target.texture_normal = preload("res://textures/tiles/magnet/magnet1.png")
			target = $FinalTile
			Globals.moving = true
			await self.player_reached_target
			await get_tree().create_timer(3).timeout
			for player in $Players.get_children():
				player.position = Vector2(get_node("Start").position.x, get_node("Start").position.y)
				player.player_pos = 0
			Globals.round += 1
			if Globals.round <= Globals.round_amount:
				recolor()
				for i in player_list:
					if "Assets" in i.powers and len(i.cards) == 3:
						LevelManager.increase_level(i, 2)
			else:
				get_tree().change_scene_to_file("res://scoreboard.tscn")
		else:
			target.texture_normal = preload("res://textures/tiles/magnet/magnet2.png")
			player.player_pos = 0
			target = $Start
			Globals.moving = true
			await self.player_reached_target
		speed = 400
		return

	# XP
	if target.tile_name == "XP":
		target.texture_normal = preload("res://textures/tiles/power up on.png")
		LevelManager.level_up(player, 1)
		return

	# Plus Card
	if target.tile_name == "Plus Card" and player.card_amount < 4 and player.cards.size() < 4:
		$Cards.add_card(player, 1)
		target.texture_normal = preload("res://textures/tiles/plus on.png")

	# Blank Tile
	if target.tile_name == "Blank Tile":
		target.self_modulate = player.modulate
		target.BlankTileCandidate = player
		return

	# Shop
	if target.tile_name == "Shop":
		get_node("../Shop").open_shop()
		await get_node("../Shop").wait_until_hidden()
	#Again	
	if target.tile_name == "Again":
		turn_again = true
			
	# Inverted Shop
	if target.tile_name == "Inverted Shop":
		get_node("../Shop").open_inv_shop()
		await get_node("../Shop").wait_until_hidden()
			




func move_player(delta):
	if target == null:
		return
	
	
	var target_center: Vector2
	if target.get_parent() == $Tiles:  
		target_center = target.position + target.size / 2
	else:
		target_center = target.position
	
	var diff_x = target_center.x - player.position.x
	

	if abs(player.position.y - target_center.y) < 5:
		if abs(diff_x) < 1:
			player.position.x = target_center.x
			player.position.y = target_center.y  
			Globals.moving = false
			emit_signal("player_reached_target")
		else:
			player.position.x += clamp(diff_x, -speed * delta, speed * delta)
	

	elif player.position.y < target_center.y:
		player.position.x += clamp($Portal/PortalEntrance.position.x - player.position.x, -speed * delta, speed * delta)
		if player.position.distance_to($Portal/PortalEntrance.position) < 2:
			teleport_from_entrance()
	else:
		player.position.x += clamp($Portal/PortalExit.position.x - player.position.x, -speed * delta, speed * delta)
		if player.position.distance_to($Portal/PortalExit.position) < 2:
			teleport_from_exit()

func teleport_from_entrance():
	if portal_teleporting:
		return
	portal_teleporting = true
	
	$Portal.portal_on = false
	for i in range(3):
		player.scale /= 1.1
		await get_tree().create_timer(0.1).timeout
	
	player.position = $Portal/PortalExit.position
	VFX.play_effect_at($Portal/PortalExit)
	
	for i in player.powers:
		if i == "Caesium-137":
			LevelManager.level_up(player,1)
	
	for i in range(3):
		player.scale *= 1.1
		await get_tree().create_timer(0.1).timeout
	
	portal_teleporting = false
	

func teleport_from_exit():
	if portal_teleporting:
		return
	portal_teleporting = true
	
	$Portal.portal_on = false
	for i in range(3):
		player.scale /= 1.1
		await get_tree().create_timer(0.1).timeout
	
	player.position = $Portal/PortalEntrance.position
	
	for i in player.powers:
		if i == "Caesium-137":
			LevelManager.level_up(player,1)
	
	for i in range(3):
		player.scale *= 1.1
		await get_tree().create_timer(0.1).timeout
	
	portal_teleporting = false

	
func pick_random_bonus() -> String:
	var total_weight := 0
	var weights := {}

	for name in Globals.bonus_tier:
		var tier = Globals.bonus_tier[name]
		var weight = 0

		match tier:
			1:
				weight = 40
			2:
				weight = 30*Globals.round**0.2
			3:
				weight = 20*Globals.round**0.4
			4:
				weight = 10*Globals.round**0.6
			5:
				weight = 5*Globals.round**0.8

		weights[name] = weight
		total_weight += weight

	var roll = randi_range(1, total_weight)

	for name in weights:
		roll -= weights[name]
		if roll <= 0:
			return name

	return ""
	
	
