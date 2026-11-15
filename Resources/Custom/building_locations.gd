class_name BuildingLocations
extends Resource

var _building_location_data: Dictionary[Vector2i, bool]

func get_building_location_data() -> Dictionary[Vector2i, bool]:
	var location_data = _building_location_data
	return location_data

func set_building_location_data(dict: Dictionary[Vector2i, bool]) -> void:
	_building_location_data = dict

func is_tile_in_set(tile: Vector2i) -> bool:
	return _building_location_data.has(tile)
