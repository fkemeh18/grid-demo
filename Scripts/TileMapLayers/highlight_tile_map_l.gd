class_name HighlightTML
extends TileMapLayer

const IS_BUILDABLE = "is_buildable"
const IS_WOOD = "is_wood"
const IS_IGNORED = "is_ignored"

signal _grid_updated()
signal _resource_tiles_updated(collected_tiles: int)

@export var bc: BuildingComponent

var _green_atlas_coords = Vector2i(1, 0)
var _danger_atlas_coords = Vector2i(2,0) #here
var _all_tiles_in_buildable_radius: Dictionary[Vector2i, bool]
var _valid_buildable_tiles: Dictionary[Vector2i, bool]
var _valid_attack_tiles: Dictionary[Vector2i, bool]
var _built_tile_locations: Dictionary[Vector2i, bool]
var _built_attack_tiles: Dictionary[Vector2i, bool]
var _collected_resource_tiles: Dictionary[Vector2i, bool]
var _danger_occupied_tiles: Dictionary[Vector2i, bool]

var _return_all_tiles = func(pos: Rect2i) -> Dictionary[Vector2i, bool]: 
	var dict : Dictionary[Vector2i, bool] = {Vector2i(0, 0): true}
	return dict

func _clear() -> void:
	clear()

func highlight_buildable_tiles(is_attack_tiles: bool, gm: GridManager) -> void:
	for tile_pos in gm._get_buildable_tile_dict(is_attack_tiles):
		set_cell(tile_pos, 0, Vector2i())

func highlight_expanded_buildable_tiles(pos: Rect2i, radius: int,
		gm: GridManager) -> void:
	var expanded_tiles = _get_valid_tiles_in_radius(pos, radius, gm)
	var gold_mine_pos = GridMethods.check_for_gold_mine_pos(pos, radius, gm)
	
	if !gold_mine_pos.is_empty():
		expanded_tiles.merge(gold_mine_pos)
	
	for tile in _valid_buildable_tiles:
		expanded_tiles.erase(tile)
	for tile in _built_tile_locations:
		expanded_tiles.erase(tile)
	
	for tile_pos in expanded_tiles:
		set_cell(tile_pos, 0, _green_atlas_coords)

func highlight_attack_tiles(pos: Rect2i, radius: int, gm: GridManager) -> void:
	var attack_tiles = _get_valid_tiles_in_radius(pos, radius, gm)
	
	for tile in _valid_attack_tiles:
		attack_tiles.erase(tile)
	
	for tile_pos in attack_tiles:
		set_cell(tile_pos, 0, _green_atlas_coords)

func highlight_resource_tiles(pos: Rect2i, radius: int,
		gm: GridManager) -> void:
	var resource_tiles = _get_resource_tiles_in_radius(pos, radius, gm)
	
	var available_resource_tiles = (GridMethods.exclude_collected_tiles(
						resource_tiles, _collected_resource_tiles))
	
	for tile_pos in available_resource_tiles:
		set_cell(tile_pos, 0, _green_atlas_coords)

func highlight_danger_occupied_tiles() -> void:
	for tile_pos in _danger_occupied_tiles:
		set_cell(tile_pos, 0, _danger_atlas_coords)

func _get_tiles_in_radius(pos: Rect2i, radius: int,
		filter_func: Callable) -> Dictionary[Vector2i, bool]:
	var tiles = GridMethods.get_tiles_in_radius(pos, radius, filter_func)
	return tiles

func _get_valid_tiles_in_radius(pos: Rect2i, radius: int,
		gm: GridManager) -> Dictionary[Vector2i, bool]:
	return _get_tiles_in_radius(pos, radius,
			Callable(self, "_buildable_tile_filter_fn").bind(gm))

func _get_resource_tiles_in_radius(pos: Rect2i, radius: int,
		gm: GridManager) -> Dictionary[Vector2i, bool]:
	return _get_tiles_in_radius(pos, radius,
			Callable(self, "_resource_tile_filter_fn").bind(gm))

func _buildable_tile_filter_fn(pos: Rect2i,
							gm: GridManager) -> Dictionary[TileMapLayer, bool]:
	return gm._get_tile_custom_data(pos.position, IS_BUILDABLE)

func _resource_tile_filter_fn(pos: Rect2i,
							gm: GridManager) -> Dictionary[TileMapLayer, bool]:
	return gm._get_tile_custom_data(pos.position, IS_WOOD)

func _update_valid_buildable_tiles(comp: BuildingComponent, 
									gm: GridManager) -> void:
	comp._calculate_occupied_cell_positions(gm._cursor_tml)
	_built_tile_locations.merge(comp._get_occupied_cell_positions())
	
	var grid_rect_pos = comp.get_tile_area(gm)
	var radius = comp.building_resource.buildable_radius
	
	if comp.building_resource.buildable_radius > 0:
		var all_tiles = _get_tiles_in_radius(grid_rect_pos, radius, 
											_return_all_tiles)
		_all_tiles_in_buildable_radius.merge(all_tiles)
		
		var valid_tiles = _get_valid_tiles_in_radius(grid_rect_pos, radius, gm)
		
		var new_building_location := gm.building_area_resource.duplicate(true)
		new_building_location.set_building_location_data(valid_tiles)
		gm.building_to_buildable_tiles[comp] = new_building_location
		
		_valid_buildable_tiles.merge(valid_tiles)
	
	for existing_bc in _built_tile_locations:
		_valid_buildable_tiles.erase(existing_bc)
	
	_valid_attack_tiles.merge(_valid_buildable_tiles)
	
	for danger_tile in _danger_occupied_tiles:
		_valid_buildable_tiles.erase(danger_tile)
	
	_grid_updated.emit()

func _update_collected_resource_tiles(comp: BuildingComponent, 
										gm: GridManager) -> void:
	var grid_rect_pos = comp.get_tile_area(gm)
	var radius = comp.building_resource.resource_radius
	var resource_tiles = _get_resource_tiles_in_radius(grid_rect_pos, radius, 
		gm)
	var old_resource_tile_count = _collected_resource_tiles.size()
	
	_collected_resource_tiles.merge(resource_tiles)
	
	if old_resource_tile_count != _collected_resource_tiles.size():
		_resource_tiles_updated.emit(_collected_resource_tiles.size())
	
	_grid_updated.emit()

func _update_attack_tiles(comp: BuildingComponent, gm: GridManager) -> void:
	if !(comp.building_resource.is_attack_building()): return
	
	var grid_rect_pos = comp.get_tile_area(gm)
	var radius = comp.building_resource.attack_radius
	var attack_tiles = _get_tiles_in_radius(grid_rect_pos, radius, 
											_return_all_tiles)
	
	var new_attack_location = gm.attack_area_resource.duplicate(true)
	new_attack_location.set_attack_location_data(attack_tiles)
	gm.attack_building_to_attacked_tiles[comp] = new_attack_location
	
	_built_attack_tiles.merge(attack_tiles)

func _update_danger_occupied_tiles(comp: BuildingComponent, 
									gm: GridManager) -> void:
	#gets goblin camp's location tiles and adds them to built locations
	comp._calculate_occupied_cell_positions(gm._cursor_tml)
	_built_tile_locations.merge(comp._get_occupied_cell_positions())
	
	if comp.building_resource.is_danger_building():
		#gets the rect and radius of camp and finds associated tiles from them
		var grid_rect_pos = comp.get_tile_area(gm)
		var radius = comp.building_resource.danger_radius
		var tiles_in_radius = _get_valid_tiles_in_radius(grid_rect_pos, radius, gm)
		
		var new_danger_location := gm.danger_area_resource.duplicate(true)
		new_danger_location.set_danger_location_data(tiles_in_radius)
		gm.danger_building_to_blocked_tiles[comp] = new_danger_location
		
		if !comp._is_disabled:
			_danger_occupied_tiles.merge(tiles_in_radius)
			
			for built_tile in _built_tile_locations:
				_danger_occupied_tiles.erase(built_tile)
