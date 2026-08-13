class_name HighlightTML
extends TileMapLayer

const IS_BUILDABLE = "is_buildable"
const IS_WOOD = "is_wood"

signal _grid_updated()
signal _resource_tiles_updated(collected_tiles: int)

@export var bc: BuildingComponent

var _valid_buildable_tiles: Dictionary[Vector2i, bool]
var _built_tile_locations: Dictionary[Vector2i, bool]
var _collected_resource_tiles: Dictionary[Vector2i, bool]

func _clear() -> void:
	clear()

func highlight_buildable_tiles() -> void:
	for tile_pos in _valid_buildable_tiles:
		set_cell(tile_pos, 0, Vector2i())

func _get_tiles_in_radius(pos: Vector2i, radius: int,
		filter_func: Callable) -> Dictionary[Vector2i, bool]:
	var resource_tiles: Dictionary[Vector2i, bool]
	
	for i in range(pos.x - radius, pos.x + (radius + 1)):
		for j in range(pos.y - radius, pos.y + (radius + 1)):
			if !filter_func.call(Vector2i(i, j)): continue
			resource_tiles[Vector2i(i, j)] = true
	
	return resource_tiles

func _get_valid_tiles_in_radius(pos: Vector2i, radius: int,
		gm: GridManager) -> Dictionary[Vector2i, bool]:
	return _get_tiles_in_radius(pos, radius,
			Callable(self, "_buildable_tile_filter_fn").bind(gm))

func _get_resource_tiles_in_radius(pos: Vector2i, radius: int,
		gm: GridManager) -> Dictionary[Vector2i, bool]:
	return _get_tiles_in_radius(pos, radius,
			Callable(self, "_resource_tile_filter_fn").bind(gm))

func _buildable_tile_filter_fn(pos: Vector2i, gm: GridManager) -> bool:
	return gm._does_tile_have_custom_data(pos, IS_BUILDABLE)

func _resource_tile_filter_fn(pos: Vector2i, gm: GridManager) -> bool:
	return gm._does_tile_have_custom_data(pos, IS_WOOD)

func _update_valid_buildable_tiles(comp: BuildingComponent, 
									gm: GridManager) -> void:
	_built_tile_locations[comp._get_grid_pos(gm._cursor_tml)] = true
	var grid_tile_pos = comp._get_grid_pos(gm._cursor_tml)
	var radius = comp.building_resource.buildable_radius
	var valid_tiles = _get_valid_tiles_in_radius(grid_tile_pos, radius, gm)
	#var occupied_tiles = _get_occupied_tiles(comp, gm)
	
	_valid_buildable_tiles.merge(valid_tiles)
	
	for existing_bc in _built_tile_locations:
		_valid_buildable_tiles.erase(existing_bc)
	
	_grid_updated.emit()

func _update_collected_resource_tiles(comp: BuildingComponent, 
										gm: GridManager) -> void:
	var grid_tile_pos = comp._get_grid_pos(gm._cursor_tml)
	var radius = comp.building_resource.resource_radius
	var resource_tiles = _get_resource_tiles_in_radius(grid_tile_pos, radius, 
		gm)
	var old_resource_tile_count = _collected_resource_tiles.size()
	
	_collected_resource_tiles.merge(resource_tiles)
	
	if old_resource_tile_count != _collected_resource_tiles.size():
		_resource_tiles_updated.emit(_collected_resource_tiles.size())
	
	_grid_updated.emit()

func highlight_expanded_buildable_tiles(pos: Vector2i, radius: int,
		gm: GridManager) -> void:
	var expanded_tiles = _get_valid_tiles_in_radius(pos, radius, gm)
	var atlas_coords = Vector2i(1, 0)
	
	for tile in _valid_buildable_tiles:
		expanded_tiles.erase(tile)
	for tile in _built_tile_locations:
		expanded_tiles.erase(tile)
	for tile_pos in expanded_tiles:
		set_cell(tile_pos, 0, atlas_coords)

func highlight_resource_tiles(pos: Vector2i, radius: int,
		gm: GridManager) -> void:
	var resource_tiles = _get_resource_tiles_in_radius(pos, radius, gm)
	var atlas_coords = Vector2i(1, 0)
	
	for tile_pos in resource_tiles:
		set_cell(tile_pos, 0, atlas_coords)
