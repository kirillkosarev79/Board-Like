extends Control
@onready var player_panel = $Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.bar_colors = {}
	if Globals.player_amount == 2:
		var new_panel = player_panel.duplicate()
		new_panel.position = player_panel.position + Vector2(900,0)
		add_child(new_panel)
	elif Globals.player_amount == 3:
		var new_panel1 = player_panel.duplicate()
		var new_panel2 = player_panel.duplicate()
		new_panel1.position = player_panel.position + Vector2(900,-300)
		player_panel.position += Vector2(0,-300)
		add_child(new_panel1)
		new_panel2.position += Vector2(450, 200)
		add_child(new_panel2)
	elif Globals.player_amount == 4:
		var new_panel1 = player_panel.duplicate()
		var new_panel2 = player_panel.duplicate()
		var new_panel3 = player_panel.duplicate()
		new_panel1.position = player_panel.position + Vector2(900,0)
		player_panel.position += Vector2(0,-300)
		new_panel1.position +=Vector2(0,-300)
		add_child(new_panel1)
		new_panel2.position += Vector2(0, 200)
		new_panel3.position += Vector2(900, 200)
		add_child(new_panel2)
		add_child(new_panel3)
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var a = 0
	for i in get_children():
		if "Panel" in i.name:
			if i.get_node("CheckButton").button_pressed:
				a+=1
			

	if a == Globals.player_amount:
		var nicknames = []
	
		for i in get_children():
			if "Panel" in i.name:
				if not i.get_node("OptionButton").get_item_icon(i.get_node("OptionButton").selected):
					$Label.visible = true
					$Label.text = "Pick an icon!"
					return
				var nickname = i.get_node("Label").text

				if nickname in nicknames:
					$Label.visible = true
					$Label.text = "Nicknames must be unique!"
					return

				nicknames.append(nickname)

				Globals.bar_colors[nickname] = i.get_node("ColorPickerButton").color
				Globals.icons[nickname] = i.get_node("OptionButton").get_item_icon(
					i.get_node("OptionButton").selected
				)

		get_tree().change_scene_to_file("res://board.tscn")
		
		
		
func return_pressed():
	get_tree().change_scene_to_file("res://chooseplayers.tscn")
