extends TextureButton
@onready var roll_button = self
@onready var click_sound = $RollButtonPressed
@export var roll = 1
var textures = [load("res://textures/RollButton/Roll1.png"),load("res://textures/RollButton/Roll2.png"),load("res://textures/RollButton/Roll3.png"),load("res://textures/RollButton/Roll4.png"),load("res://textures/RollButton/Roll5.png"),load("res://textures/RollButton/Roll6.png")]
var minidice_textures = [load("res://textures/MiniRoll/MiniRoll1.png"),load("res://textures/MiniRoll/MiniRoll2.png"),load("res://textures/MiniRoll/MiniRoll3.png"),load("res://textures/MiniRoll/MiniRoll4.png"),load("res://textures/MiniRoll/MiniRoll5.png"),load("res://textures/MiniRoll/MiniRoll6.png")]
var minidice_tex = load("res://textures/MiniRoll/MiniRoll.png")
func _on_roll_button_pressed():
	click_sound.play()
	
func roll_dice(final_roll: int, add_dice = 0) -> void:
	var elapsed := 0.0
	var duration := 1.5


	while elapsed < duration:

		texture_disabled = textures[randi_range(0, textures.size() - 1)]


		for i in range(add_dice):
			var minidice = get_child(i + 1)
			minidice.texture = minidice_textures[randi_range(0, minidice_textures.size() - 1)]

		var progress := elapsed / duration
		var delay: float = lerp(0.025, 0.3, progress * progress * progress)

		await get_tree().create_timer(delay).timeout
		elapsed += delay


	var dice_count = add_dice + 1

	if final_roll < dice_count or final_roll > dice_count * 6:
		return

	var rolls: Array[int] = []


	for i in range(dice_count):
		rolls.append(1)

	var points_left = final_roll - dice_count

	while points_left > 0:
		var i = randi_range(0, dice_count - 1)

		if rolls[i] < 6:
			rolls[i] += 1
			points_left -= 1



	var big_roll = rolls[0]
	texture_disabled = textures[big_roll - 1]


	for i in range(add_dice):
		var mini_roll = rolls[i + 1]
		get_child(i + 1).texture = minidice_textures[mini_roll - 1]

	# Optional: verify the result
	var total = 0
	for value in rolls:
		total += value

func _process(delta: float) -> void:
	
	for i in get_children():
			if i is not AudioStreamPlayer:
				if not self.disabled:
					i.texture = minidice_tex
				i.visible = false
	var a = 0
	for i in Globals.playerturn.powers:
		if i == "Dice":
			a += 1
	for i in range(a):
		get_child(i+1).visible = true
