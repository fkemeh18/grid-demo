class_name GridManager
extends Node

@export var _main_tml_: MainTML
@export var _highlight_tml: HighlightTML
@export var _base_terrain_tml: TileMapLayer

var _temp_grid_pos: Vector2i

func _process(delta):
	_main_tml_.set_tile(_get_mouse_grid_pos())
	
func _get_mouse_grid_pos() -> Vector2i:
	_temp_grid_pos = _get_mouse_grid_pos_without_update()
	return _temp_grid_pos

func _get_mouse_grid_pos_without_update() -> Vector2i:
	var mouse_pos = _highlight_tml.get_global_mouse_position()
	return _main_tml_.process_mouse_pos(mouse_pos)

func _is_cell_occupied(pos: Vector2i) -> bool:
	var custom_data = _base_terrain_tml.get_cell_tile_data(pos)
	
	if custom_data == null: 
		#print("problem 1")
		return true
	
	if !custom_data.get_custom_data("buildable") as bool: 
		print("problem 2")
		return true
	
	return _main_tml_._occupied_tile_dict.has(pos)

func _on_placed_building_() -> void:
	_main_tml_._register_built_tile(_temp_grid_pos)
	_main_tml_._toggle_visibility(_temp_grid_pos)
	_highlight_tml._clear()

func _update_highlight_tml(radius: int) -> void:
	_highlight_tml.update_highlighted_tiles(_temp_grid_pos, 
		radius, self)
