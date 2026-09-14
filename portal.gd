extends Node2D

@export var portal_on = true
signal escaped_portal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	get_node("PortalEntrance").position.y = get_node("../Players").get_child(0).position.y
	if not $PortalEntrance.is_playing():
		$PortalEntrance.play("spin")
		$PortalExit.play("spin")

func _process(delta: float) -> void:
	if portal_on:
		await get_tree().create_timer(5).timeout
		portal_on = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
