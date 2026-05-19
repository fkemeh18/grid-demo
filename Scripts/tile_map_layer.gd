class_name TileGrid
extends TileMapLayer

var temp_tile_pos = Vector2i(0, 0)

func process_mouse_pos(mouse_pos: Vector2) -> Vector2i:
	var grid_pos = local_to_map(to_local(mouse_pos))
	return grid_pos
	
func set_tile(pos: Vector2i) -> void:
	if tile_checker(pos):
		#print("I'm here!")
		set_cell(pos, 1, Vector2i(0, 0))
	if pos != temp_tile_pos:
		set_cell(temp_tile_pos, -1, Vector2i(-1, -1))
		
	temp_tile_pos = pos
		
func tile_checker(mouse_pos: Vector2i) -> bool:
	if (get_cell_source_id(mouse_pos) == -1) && (
		get_cell_atlas_coords(mouse_pos) == Vector2i(-1, -1)):
		return true
	else:
		return false
