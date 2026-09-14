extends Control
var player = null
var card = null
var abil = null
var description_label = null
		
func _ready() -> void:
	player = get_node('../Players').get_child(Globals.turn -1)
	await get_tree().process_frame
	for player in get_node('../Players').get_children():
		
		for i in range(player.card_amount):
			card = get_child(i)
			abil = pick_random_card()
			player.cards.append(abil)
			card.texture_normal = Globals.cards[abil][0]


			
					
func _process(_delta: float) -> void:
	player = get_node('../Players').get_child(Globals.turn - 1)

	for i in range(get_child_count()):
		card = get_child(i)

		if i < player.cards.size():
			var ability = player.cards[i]

			if ability != "None":
				card.visible = true
				card.disabled = false
				card.ability_name = ability
				card.texture_normal = Globals.cards[card.ability_name][0]

			else:
				card.visible = false
				card.disabled = true
		else:
			card.visible = false
			card.disabled = true

	
	
	

	
	
func update_cards():
	player = get_node('../Players').get_child(Globals.turn - 1)

	for i in range(get_child_count()):
		card = get_child(i)

		if i < player.cards.size():
			var ability = player.cards[i]

			if ability != "None":
				card.visible = true
				card.disabled = false
				card.ability_name = ability
			else:
				card.visible = false
				card.disabled = true
		else:
			card.visible = false
			card.disabled = true

func add_card(player, card):
	if card is int:
		for i in range(card):
			var abil = pick_random_card()
			var idx = player.cards.find("None")
			if idx != -1:
				player.cards[idx] = abil
			else:
				player.cards.append(abil)
				update_cards()
				player.card_amount += 1
	elif card is String:
		var idx = player.cards.find("None")
		if idx != -1:
			player.cards[idx] = card
		else:
			player.cards.append(card)
			update_cards()
			player.card_amount += 1
			
func pick_random_card() -> String:
	var total_weight := 0
	var weights := {}

	for name in Globals.cards:
		var tier = Globals.cards[name][4]
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
	
	
