extends AudioStreamPlayer2D
var song  = [preload("res://Sounds/melody1.wav"),preload("res://Sounds/melody2.mp3")]
var songplay = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not self.playing:
		songplay = randi_range(0,len(song)-1)
		self.stream = song[songplay]
		self.play()
