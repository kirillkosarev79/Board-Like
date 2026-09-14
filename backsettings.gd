extends ColorRect

@export var colors: Array[Color] = [
	Color("#181923"),
	Color('#292d41'),
	Color("#38405d"),
	Color("#4c546d"),
	Color("#6f687a")
	
]

@export var transition_time := 2.0

var current_color_index := 0
var next_color_index := 1
var timer := 0.0


func _process(delta):
	timer += delta

	var progress = timer / transition_time
	progress = smoothstep(0.0, 1.0, progress)

	color = colors[current_color_index].lerp(
		colors[next_color_index],
		progress
	)

	if timer >= transition_time:
		timer = 0.0
		current_color_index = next_color_index
		next_color_index = (next_color_index + 1) % colors.size()
