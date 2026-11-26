class_name OptionsManagerAutoloader
extends Node

static func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index))

static func set_bus_volume_percent(bus_name: String,
									volume_percent: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index,
									linear_to_db(volume_percent))

static func toggle_window_mode() -> void:
	if is_fullscreen():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

static func is_fullscreen() -> bool:
	return DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
