extends HSlider

@onready var volume_label = $VolumeLabel

var master_bus: int


func _ready() -> void:
	master_bus = AudioServer.get_bus_index("Master")

	volume_label.visible = false


	var current_db := AudioServer.get_bus_volume_db(master_bus)

	if current_db <= -80.0:
		value = 0.0
	else:
		value = db_to_linear(current_db) * 100.0

	update_volume(value)


func _on_value_changed(new_value: float) -> void:
	update_volume(new_value)


func update_volume(new_value: float) -> void:

	volume_label.text = str(int(new_value))


	volume_label.position.x = new_value * 6.44 + 3.0 * (new_value / 100.0) - 15.0


	var volume := new_value / 100.0


	if volume <= 0.0:
		AudioServer.set_bus_volume_db(master_bus, -80.0)
	else:
		AudioServer.set_bus_volume_db(master_bus, linear_to_db(volume))


func drag() -> void:
	volume_label.visible = true


func notdrag(_value_changed: bool) -> void:
	volume_label.visible = false
