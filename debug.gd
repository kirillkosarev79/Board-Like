extends CanvasLayer

@onready var output: RichTextLabel = $Panel/RichTextLabel
@onready var input: LineEdit = $Panel/LineEdit
@onready var players = get_node("../Board/Players").get_children()
var commands = {
	"help": "Show available commands",
	"clear": "Clear the console",
	"recolor": "recolor <color>",
	"paint [id] [tile_name]": 'change a tile to a new one',
	"cond [id] [condition]": "set condition for a tile",
	"add_card [player] [card name]": "give a card to a player",
	"add_power [player] [power name]": "give a power to a player",
	"set_level [player] [level]": "set a player's level",
	"mod [modificator name]": "change round modificator"
}

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB and Globals.console_on:
			self.visible = not self.visible
	
func _ready():
	input.text_submitted.connect(_on_command)
	input.grab_focus()
	print_line("Debug Console")
	print_line("Type 'help' for commands.")


func print_line(text: String):
	output.append_text(text + "\n")


func _on_command(command: String):
	command = command.strip_edges()

	if command == "":
		return

	print_line("> " + command)
	input.clear()


	var parts = command.split(" ", false)


	var cmd = parts[0]


	var args = parts.slice(1)

	match cmd:
		"help":
			for name in commands:
				print_line("/"+ name + " - " + commands[name])

		"clear":
			output.clear()

		"recolor":
			get_node("../Board").recolor()
			
		"paint":
			paint_command(args)
			
		"cond":
			get_node("../Board/Tiles").get_child(int(args[0])).CondCard(args[1])
			get_node("../Board/Tiles").get_child(int(args[0])).emit_signal("pressed")
			print_line(str("Tile ", args[0], " now has ", args[1], ' as condition'))
		
		"add_card":
			var card = " ".join(args.slice(1))
			if not card in Globals.cards:
				print_line("*"+card+"* not found")
				return
			
			for i in players:
				if i.name == args[0]:
					get_node('../Board/Cards').add_card(i,card)
					return
			print_line("Player not found")
		
		"add_power":
			var power = " ".join(args.slice(1))
			if not power in Globals.powers:
				print_line("*"+power+"* not found")
				return
			
			for i in players:
				if i.name == args[0]:
					i.powers.append(power)
					return
			print_line("Player not found")
		
		"set_level":
			for i in players:
				if i.name == args[0]:
					i.level = int(args[1])
		
		"mod":
			if get_node("../Modificators").change_modificator(" ".join(args.slice(0))):
				print_line("Round modificator changed to " + " ".join(args.slice(0)))
			else:
				print_line("Round modificator " + " ".join(args.slice(0)) + " not found")

		_:
			print_line("Unknown command: " + cmd)

func paint_command(args: Array):
	if args.size() < 2:
		print_line("Usage: paint <tile_id> <tile_name>")
		return

	var tile_id = int(args[0])


	var new_tile = " ".join(args.slice(1))

	print_line("Changed tile " + str(tile_id) + " to " + new_tile)

	var tile = get_node("../Board/Tiles").get_children()[tile_id]
	tile.tile_name = new_tile
	tile.update_tile()
	
