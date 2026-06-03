class_name HighlightTML
extends TileMapLayer

func update_highlighted_tiles(grid_tile_pos: Vector2i, radius: int, 
		occupied_tiles: GridManager) -> void:
	_clear()
	
	for i in range(grid_tile_pos.x - radius, grid_tile_pos.x + (radius + 1)):
		for j in range(grid_tile_pos.y - radius, grid_tile_pos.y + (radius + 1)):
			if occupied_tiles._is_cell_occupied(Vector2i(i, j)): continue
			set_cell(Vector2i(i, j), 0, Vector2i())

func _clear() -> void:
	clear()
