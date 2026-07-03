class_name HighlightTML
extends TileMapLayer

@export var bc: BuildingComponent

var _valid_buildable_tiles: Dictionary[Vector2i, bool]
var _built_tile_locations: Dictionary[Vector2i, bool]

func _clear() -> void:
	clear()

func highlight_buildable_tiles() -> void:
	for tile_pos in _valid_buildable_tiles:
		set_cell(tile_pos, 0, Vector2i())

func _get_valid_tiles_in_radius(pos: Vector2i, radius: int, 
								gm: GridManager) -> Dictionary[Vector2i, bool]:
	var valid_tiles: Dictionary[Vector2i, bool]
	
	for i in range(pos.x - radius, pos.x + (radius + 1)):
		for j in range(pos.y - radius, pos.y + (radius + 1)):
			if !gm._is_terrain_buildable(Vector2i(i, j)): continue
			valid_tiles[Vector2i(i, j)] = true

	return valid_tiles

func _update_valid_buildable_tiles(comp: BuildingComponent, 
									gm: GridManager) -> void:
	var grid_tile_pos = comp._get_grid_pos(gm._main_tml_)
	var radius = comp.building_resource.buildable_radius
	var valid_tiles = _get_valid_tiles_in_radius(grid_tile_pos, radius, gm)
	var occupied_tiles = _get_occupied_tiles(comp, gm)
	
	_valid_buildable_tiles.merge(valid_tiles)
	
	for existing_bc in occupied_tiles:
		_valid_buildable_tiles.erase(existing_bc)

func highlight_expanded_buildable_tiles(pos: Vector2i, radius: int, 
											gm: GridManager) -> void:
	_clear()
	highlight_buildable_tiles()
	
	var expanded_tiles = _get_valid_tiles_in_radius(pos, radius, gm)
	var atlas_coords = Vector2i(1, 0)
	
	for tile in _valid_buildable_tiles:
		expanded_tiles.erase(tile)
	
	for tile in _built_tile_locations:
		expanded_tiles.erase(tile)
	
	for tile_pos in expanded_tiles:
		set_cell(tile_pos, 0, atlas_coords)

func _get_occupied_tiles(bc: BuildingComponent, 
							gm: GridManager) -> Dictionary[Vector2i, bool]:
	var building_components: Array[BuildingComponent]
	
	for node in get_tree().get_nodes_in_group(bc.bc_name):
		building_components.append(node as BuildingComponent)
	
	for tile in building_components:
		_built_tile_locations[tile._get_grid_pos(gm._main_tml_)] = true
	
	return _built_tile_locations
