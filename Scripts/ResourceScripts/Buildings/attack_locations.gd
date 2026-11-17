class_name AttackLocations
extends Resource

var _attack_location_data: Dictionary[Vector2i, bool]

func get_attack_location_data() -> Dictionary[Vector2i, bool]:
	var location_data = _attack_location_data
	return location_data

func set_attack_location_data(dict: Dictionary[Vector2i, bool]) -> void:
	_attack_location_data = dict

func is_attack_tile_in_set(tile: Vector2i) -> bool:
	return _attack_location_data.has(tile)
