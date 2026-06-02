class_name HighlightTML
extends TileMapLayer


func _update_highlighted_tiles(grid_tile_pos: Vector2i) -> void:
	_clear()
	
	for i in range(grid_tile_pos.x - 3, grid_tile_pos.x + 4):
		for j in range(grid_tile_pos.y - 3, grid_tile_pos.y + 4):
			set_cell(Vector2i(i, j), 0, Vector2i())

func _clear() -> void:
	clear()
