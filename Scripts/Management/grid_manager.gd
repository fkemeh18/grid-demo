class_name GridManager
extends Node

@export var _cursor_tml: CursorTML
@export var _highlight_tml: HighlightTML
@export var _base_terrain_tml: TileMapLayer
@export var building_area_resource: BuildingLocations

var _hovered_rect_pos: Rect2i = Rect2i(Vector2i.ZERO, Vector2i.ONE)
var _all_tile_map_layers: Dictionary[TileMapLayer, bool]
var _tile_map_elevations: Dictionary[TileMapLayer,ElevationLayer]
var building_to_buildable_tiles: Dictionary[BuildingComponent, BuildingLocations]

func _ready():
	GameEventsAutoloader._instance.building_placed.connect(_on_placed_building)
	GameEventsAutoloader._instance.building_disabled.connect(_on_disabled_building)
	GameEventsAutoloader._instance.building_enabled.connect(_on_enabled_building)
	GameEventsAutoloader._instance.building_destroyed.connect(_on_destroyed_building)
	_all_tile_map_layers = _get_all_tile_map_layers(_base_terrain_tml)
	_map_layers_to_elevations()

func _get_mouse_grid_pos() -> Rect2i:
	_hovered_rect_pos.position = _get_mouse_grid_pos_without_update()
	return _hovered_rect_pos

func _get_mouse_grid_pos_without_update() -> Vector2i:
	return _cursor_tml.process_mouse_pos()

func get_mouse_grid_pos_with_dimension_offset(dimensions: Vector2) -> Vector2i:
	var mouse_grid_pos = _cursor_tml.get_mouse_pos() / 64
	mouse_grid_pos -= (dimensions / 2)
	mouse_grid_pos = mouse_grid_pos.round()
	return Vector2i(mouse_grid_pos.x as int, mouse_grid_pos.y as int)

func _get_tile_custom_data(pos: Vector2i,
						data_name: String) -> Dictionary[TileMapLayer,bool]:
	var custom_data: Dictionary[TileMapLayer, bool]
	for layer in _all_tile_map_layers:
		var custom_terrain_data = layer.get_cell_tile_data(pos)
		if (custom_terrain_data == null || custom_terrain_data.get_custom_data(
					_highlight_tml.IS_IGNORED)): continue
		
		custom_data[layer] = custom_terrain_data.get_custom_data(
													data_name) as bool
		return custom_data
	
	return {}

func _is_cell_in_view_of_a_building(pos: Vector2i) -> bool:
	return _highlight_tml._all_tiles_in_buildable_radius.has(pos)

func _is_area_currently_buildable(pos: Rect2i, is_attack_tiles: bool) -> bool:
	var tiles := GridMethods.to_tiles(pos)
	
#	stops if there are no checkable tiles
	if tiles.is_empty(): return false
	
	var tile_list = tiles.keys()
	var first_tml = GridMethods.get_first_tml(tile_list, self)
	
#	gets the elevation of the layer of the first checkable tile
	var target_elevation_layer = (_tile_map_elevations.get(first_tml) if first_tml != null else null) # Ternary operator
	
	var temp_tiles = _get_buildable_tile_dict(is_attack_tiles)
	var tiles_to_check = temp_tiles.duplicate()
	if is_attack_tiles:
		for tile in _highlight_tml._built_tile_locations:
			tiles_to_check.erase(tile)
	
	var is_area_valid = GridMethods.get_is_area_valid(self, tile_list,
										target_elevation_layer, tiles_to_check)
	return is_area_valid

func can_destroy_building(bc: BuildingComponent) -> bool:
	if bc.building_resource.buildable_radius > 0:
		return (!will_destroying_building_isolate_other_buildings(bc)
					&& is_building_network_connected(bc))
	return true

func will_destroying_building_isolate_other_buildings(
								condemned_building: BuildingComponent) -> bool:
	#checks each other established building...
	var dependent_buildings = BuildingComponent.get_friendly_building_components(
		self).filter(func(other_building): 
		if other_building == condemned_building: return false
		if other_building.building_resource.is_base: return false
		
		#for their location tiles...
		var tile_dict = GridMethods.to_tiles(other_building.get_tile_area(self))
		var tile_array = tile_dict.keys()
		#and checks those tiles...
		var any_tile_in_radius = tile_array.any(func(tile): 
			var tile_resource = building_to_buildable_tiles[condemned_building]
			#for if they are in the target building's buildable range
			return tile_resource.get_building_location_data().has(tile)
			)
		return any_tile_in_radius
		)
		
	var all_buildings_still_valid = dependent_buildings.all(func(dependent_building):
		#gets list of tiles this building is occupying...
		var tiles_dict = GridMethods.to_tiles(dependent_building.get_tile_area(self))
		var tiles_for_building = tiles_dict.keys()
		var buildings_to_check = building_to_buildable_tiles.keys().filter(
				func(key): return key != condemned_building && key != dependent_building
			)
		#iterates through them...
		return tiles_for_building.all(func(tile): 
			#making sure the tiles tied to the main building are exempt...
			var tile_is_in_set = buildings_to_check.any(func(building):
				#and checks if the tile is in the other buildings' set
				var resource = building_to_buildable_tiles[building]
				return resource.is_tile_in_set(tile)
				)
			return tile_is_in_set
			)
		)
	if !all_buildings_still_valid:
		return true
	
	return false

func is_building_network_connected(bc: BuildingComponent) -> bool:
	#gets the first building that is labled as a base building from an array of all buildings in the level
	var base_building = bc.get_valid_building_components(self
		).filter(func(building): return building.building_resource.is_base
		).front()
	var visited_buildings: Dictionary[BuildingComponent, bool]
	visit_all_connected_buildings(base_building, bc, visited_buildings)
	
	#gets number of towers and other expansion buildings currently available in the level
	var total_buildings_to_visit = BuildingComponent.get_valid_building_components(
		self).filter(func(visitable_building): 
			return (visitable_building.building_resource.is_expansion_building()
			&& visitable_building != bc)).size()
	
	return total_buildings_to_visit == visited_buildings.size()

func visit_all_connected_buildings(root_building: BuildingComponent,
				excluded_building: BuildingComponent,
				visited_buildings: Dictionary[BuildingComponent, bool]) -> void:
	var dependent_buildings_array = BuildingComponent.get_friendly_building_components(self
		).filter(func(other_building): 
			#only check buildings that expand the buildable areas
			if !other_building.building_resource.is_expansion_building(): return false
			if visited_buildings.has(other_building): return false
			
			var tile_dict = GridMethods.to_tiles(other_building.get_tile_area(self))
			var tile_array = tile_dict.keys()
			#and checks those tiles...
			var any_tile_in_radius = tile_array.all(func(tile): 
				var tile_resource = building_to_buildable_tiles[root_building]
				#for if they are in the target building's buildable range
				return tile_resource.get_building_location_data().has(tile)
				)
			return other_building != excluded_building && any_tile_in_radius
			)
	
	var dependent_buildings: Dictionary[BuildingComponent, bool]
	for dependent_building in dependent_buildings_array.duplicate():
		dependent_buildings[dependent_building] = true
	
	visited_buildings.merge(dependent_buildings)
	
	for dependent_building in dependent_buildings:
		visit_all_connected_buildings(
			dependent_building, excluded_building,visited_buildings)

func _update_building_component_grid_state(bc: BuildingComponent) -> void:
	_highlight_tml._update_goblin_occupied_tiles(bc, self)
	_highlight_tml._update_valid_buildable_tiles(bc, self)
	_highlight_tml._update_collected_resource_tiles(bc, self)
	_highlight_tml._update_attack_tiles(bc, self)

func _on_placed_building(bc: BuildingComponent) -> void:
	_update_building_component_grid_state(bc)
	_check_destruction_of_goblin_camps()

func _on_disabled_building(_bc: BuildingComponent) -> void:
	_refresh_grid()

func _on_enabled_building(bc: BuildingComponent) -> void:
	_update_building_component_grid_state(bc)

func _on_destroyed_building(_bc: BuildingComponent) -> void:
	_refresh_grid()

func _check_destruction_of_goblin_camps():
	var danger_buildings := BuildingComponent.get_danger_building_component(self)
	
	for building in danger_buildings:
		var tile_area = building.get_tile_area(self)
		var is_inside_attack_tile = (GridMethods.to_tiles(tile_area)
			.keys().any(func(tile): 
				return _highlight_tml._built_attack_tiles.has(tile)))
		
		if is_inside_attack_tile:
			building.disable()
		else:
			building.enable()

func _recalculate_goblin_occupied_tiles() -> void:
	_highlight_tml._goblin_occupied_tiles.clear()
	var danger_buildings := BuildingComponent.get_danger_building_component(self)
	
	for building in danger_buildings:
		_highlight_tml._update_goblin_occupied_tiles(building, self)

func _update_grid(is_attack_tiles: bool) -> void:
	_highlight_tml._clear()
	
	if is_attack_tiles:
		_highlight_tml.highlight_goblin_occupied_tiles()
		_update_highlight_tiles(true)
	else:
		_update_highlight_tiles(false)
		_highlight_tml.highlight_goblin_occupied_tiles()

func _update_highlight_tiles(is_attack_tiles: bool) -> void:
	_highlight_tml.highlight_buildable_tiles(is_attack_tiles, self)

func _update_expanded_tiles(pos: Rect2i, radius: int) -> void:
	_highlight_tml.highlight_expanded_buildable_tiles(pos, radius, self)

func _update_resource_tiles(pos: Rect2i, radius: int) -> void:
	_highlight_tml.highlight_resource_tiles(pos, radius, self)

func _refresh_grid() -> void:
	GridMethods.refresh_grids(self)
	
	var buildings = BuildingComponent.get_valid_building_components(self)
	
	GridMethods.update_tiles_for_other_bcs(buildings, self)
	_check_destruction_of_goblin_camps()
	GridMethods.emit_tile_updates(self)

func _get_all_tile_map_layers(
		current_layer: Node2D) -> Dictionary[TileMapLayer, bool]:
	var layer_list = GridMethods.get_layer_list(current_layer, self)
	return layer_list

func _get_buildable_tile_dict(is_attack_tiles: bool
								) -> Dictionary[Vector2i,bool]:
	var dict = (_highlight_tml._valid_buildable_tiles 
		if is_attack_tiles == false else _highlight_tml._valid_attack_tiles)
	return dict

func _map_layers_to_elevations() -> void:
	for layer in _all_tile_map_layers:
		var elevation_layer: ElevationLayer
		var start_node : Node = layer
		
		while true:
			var parent = start_node.get_parent()
			elevation_layer = parent as ElevationLayer
			start_node =  parent
			
			if elevation_layer != null || start_node == null : break
		
		_tile_map_elevations[layer] = elevation_layer
