extends Panel

func _ready() -> void:
	var first_row = $Score
	var rows = [first_row]


	var players = Globals.players.keys()
	players.sort_custom(func(a, b):
		return Globals.players[a]["score"] > Globals.players[b]["score"]
	)

	for i in range(players.size() - 1):
		var row = first_row.duplicate()
		add_child(row)


		row.position.y = first_row.position.y + (i + 1) * 110

		rows.append(row)


	for i in range(players.size()):
		var player_name = players[i]
		var player_data = Globals.players[player_name]
		var row = rows[i]

		row.get_node("Nickname").text = player_name
		row.get_node("Level").text = str(player_data["score"])
		row.self_modulate = player_data["color"]


func _process(delta: float) -> void:
	pass
