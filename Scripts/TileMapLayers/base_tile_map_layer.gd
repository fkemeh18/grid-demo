class_name MainTML
extends TileMapLayer

var _visible_tile = false
var _temp_tile_pos: Vector2i
var _occupied_tile_dict: Dictionary[Vector2i, bool]

# changes mouse_pos to Vector2i
func process_mouse_pos(mouse_pos: Vector2) -> Vector2i:
	var grid_pos = local_to_map(to_local(mouse_pos))
	return grid_pos

# handles tile grid rect
func set_tile(pos: Vector2i) -> void:
	if tile_checker(pos):
		set_cell(pos, 1, Vector2i(0, 0))
	if pos != _temp_tile_pos:
		erase_cell(_temp_tile_pos)
		
	_temp_tile_pos = pos

# Checks conditions for placing tile
func tile_checker(mouse_pos: Vector2i) -> bool:
	if (get_cell_source_id(mouse_pos) == -1) && (
		get_cell_atlas_coords(mouse_pos) == Vector2i(-1, -1)) && (
			_visible_tile):
		return true
	else:
		return false

# change visibility
func _toggle_visibility(tile: Vector2i) -> void:
	match _visible_tile:
		true:
			_visible_tile = false
			_clear_tile(tile)
		false:
			_visible_tile = true

# clears tile
func _clear_tile(tile: Vector2i) -> void:
	erase_cell(tile)

func _register_built_tile(tile_pos: Vector2i) -> void:
	_occupied_tile_dict.set(tile_pos, true)
