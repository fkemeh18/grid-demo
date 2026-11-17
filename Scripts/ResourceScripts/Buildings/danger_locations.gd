class_name DangerLocations
extends Resource

var _danger_location_data: Dictionary[Vector2i, bool]

func get_danger_location_data() -> Dictionary[Vector2i, bool]:
	var location_data = _danger_location_data
	return location_data

func set_danger_location_data(dict: Dictionary[Vector2i, bool]) -> void:
	_danger_location_data = dict

func is_danger_tile_in_set(tile: Vector2i) -> bool:
	return _danger_location_data.has(tile)
