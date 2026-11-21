class_name ResourceManager
extends Node

@export var _grid_manager: GridManager
@export var _resource_indicator_scene: PackedScene

var _indicated_tiles: Dictionary[Vector2i, bool]
var _tiles_to_resource_indicator: Dictionary[Vector2i, ResourceIndicator]

func _ready():
	_grid_manager._highlight_tml._resource_tiles_updated.connect(
		_on_resource_tiles_updated)

func _update_indicators(
		new_indicated_tiles: Dictionary[Vector2i, bool],
		to_remove_tiles: Dictionary[Vector2i, bool]) -> void:
	for new_tile in new_indicated_tiles:
		var indicator = _resource_indicator_scene.instantiate() as ResourceIndicator
		add_child(indicator)
		indicator.global_position = new_tile * 64
		_tiles_to_resource_indicator[new_tile] = indicator
	
	for target_tile in to_remove_tiles:
		var indicator = _tiles_to_resource_indicator[target_tile] if _tiles_to_resource_indicator.has(target_tile) else null
		if is_instance_valid(indicator):
			indicator.destroy()
		_tiles_to_resource_indicator.erase(target_tile)

func _handle_resource_tile_updated() -> void:
	var current_resource_tiles = _grid_manager.get_collected_resource_tiles()
	var newly_indicated_tiles = current_resource_tiles.duplicate()
	var to_remove_tiles = _indicated_tiles.duplicate()
	
	#removes old indicated tiles from all current resource tiles 
	for tile in _indicated_tiles:
		newly_indicated_tiles.erase(tile)
	
	#removes current tiles from indicated tiles
	for tile in current_resource_tiles:
		to_remove_tiles.erase(tile)
	
	_indicated_tiles = current_resource_tiles
	_update_indicators(newly_indicated_tiles, to_remove_tiles)

func _on_resource_tiles_updated(_tiles: int) -> void:
	_handle_resource_tile_updated.call_deferred()
