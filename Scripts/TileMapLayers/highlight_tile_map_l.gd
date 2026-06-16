class_name HighlightTML
extends TileMapLayer

@export var bc: BuildingComponent

func _clear() -> void:
	clear()

func highlight_buildable_tiles(gm: GridManager) -> void:
	_clear()
	
	var building_components: Array[BuildingComponent]

#	here
	for node in get_tree().get_nodes_in_group(bc.name):
		building_components.append(node)

	for building_component in building_components:
		_update_highlighted_tiles(
			building_component._get_grid_pos(gm._main_tml_), 
			building_component.build_radius, gm)

func _update_highlighted_tiles(grid_tile_pos: Vector2i, radius: int, 
		occupied_tiles: GridManager) -> void:
	#_clear()
	
	for i in range(grid_tile_pos.x - radius, grid_tile_pos.x + (radius + 1)):
		for j in range(grid_tile_pos.y - radius, grid_tile_pos.y + (radius + 1)):
			if occupied_tiles._is_cell_occupied(Vector2i(i, j)): continue
			set_cell(Vector2i(i, j), 0, Vector2i())
