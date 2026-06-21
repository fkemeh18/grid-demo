class_name HighlightTML
extends TileMapLayer

@export var bc: BuildingComponent

var _valid_buildable_tiles: Dictionary[Vector2i, bool]

func _clear() -> void:
	clear()

func highlight_buildable_tiles() -> void:
	for tile_pos in _valid_buildable_tiles:
		set_cell(tile_pos, 0, Vector2i())

func _update_valid_buildable_tiles(comp: BuildingComponent, 
									gm: GridManager) -> void:
	
	var grid_tile_pos = comp._get_grid_pos(gm._main_tml_)
	var radius = comp.build_radius

	for i in range(grid_tile_pos.x - radius, grid_tile_pos.x + (radius + 1)):
		for j in range(grid_tile_pos.y - radius, grid_tile_pos.y + (radius + 1)):
			if !gm._is_terrain_buildable(Vector2i(i, j)): continue
			#set_cell(Vector2i(i, j), 0, Vector2i())
			_valid_buildable_tiles.set(Vector2i(i, j), true)

	_valid_buildable_tiles.erase(comp._get_grid_pos(gm._main_tml_))
