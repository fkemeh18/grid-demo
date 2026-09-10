class_name GridManager
extends Node

@export var _cursor_tml: CursorTML
@export var _highlight_tml: HighlightTML
@export var _base_terrain_tml: TileMapLayer

var _curr_state = GameEvents.State.Base
var _hovered_rect_pos: Rect2i = Rect2i(Vector2i.ZERO, Vector2i.ONE)
var _all_tile_map_layers: Dictionary[TileMapLayer, bool]
var _tile_map_elevations: Dictionary[TileMapLayer,ElevationLayer]

func _ready():
	GameEvents._instance.building_placed.connect(_on_placed_building)
	GameEvents._instance.building_destroyed.connect(_on_destroyed_building)
	_all_tile_map_layers = _get_all_tile_map_layers(_base_terrain_tml)
	_map_layers_to_elevations()

func _process(delta):
	match _curr_state:
		GameEvents.State.Base:
			pass
		GameEvents.State.PlacingBuilding:
			_cursor_tml.set_tile(_get_mouse_grid_pos())

func _get_mouse_grid_pos() -> Rect2i:
	_hovered_rect_pos.position = _get_mouse_grid_pos_without_update()
	return _hovered_rect_pos

func _get_mouse_grid_pos_without_update() -> Vector2i:
	return _cursor_tml.process_mouse_pos()

#not here
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

func _is_cell_currently_buildable(pos: Vector2i) -> bool:
	return _highlight_tml._valid_buildable_tiles.has(pos)

func _is_area_currently_buildable(pos: Rect2i) -> bool:
	var tiles: Dictionary[Vector2i, bool]
	
#	finds checkable tiles
	for x in range(pos.position.x, pos.end.x):
		for y in range(pos.position.y, pos.end.y):
			tiles[Vector2i(x, y)] = true
	
#	stops if there are no checkable tiles
	if tiles.is_empty(): return false
	
#	checkable tiles in array form
	var tile_list = tiles.keys()
#	checks for the layer of the first checkable tile 
	var first_tml_dict = _get_tile_custom_data(
								tile_list[0], _highlight_tml.IS_BUILDABLE)
	var first_tml = first_tml_dict.keys().front()
#	gets the elevation of the layer of the first checkable tile
	var target_elevation_layer = _tile_map_elevations.get(first_tml)
	
#	final check
	var is_area_valid = tile_list.all(func(tile_pos): 
#		checks the tilemaplayer of each tile
		var valid_dict = _get_tile_custom_data(tile_pos, _highlight_tml.IS_BUILDABLE)
		var valid_tml = valid_dict.keys().front()
#		finds the associated elevation layer of that tilemaplayer
		var elevation_layer = _tile_map_elevations[valid_tml]

#		passes for the tile if builidable is true for it on that layer,
		return (valid_dict[valid_tml]
#		if the tile is valid for building at that location,
				&& _highlight_tml._valid_buildable_tiles.has(tile_pos)
#		and if the elevation level is the same as the target elevation
				&& elevation_layer == target_elevation_layer))
	
	return is_area_valid

func _on_placed_building(bc: BuildingComponent) -> void:
	_highlight_tml._update_valid_buildable_tiles(bc, self)
	_highlight_tml._update_collected_resource_tiles(bc, self)

func _on_destroyed_building(bc: BuildingComponent) -> void:
	_refresh_grid(bc)

func _update_grid() -> void:
	_highlight_tml._clear()
	_update_highlight_tiles()

func _update_highlight_tiles() -> void:
	_highlight_tml.highlight_buildable_tiles()

func _update_expanded_tiles(pos: Rect2i, radius: int) -> void:
	_highlight_tml.highlight_expanded_buildable_tiles(pos, radius, self)

func _update_resource_tiles(pos: Rect2i, radius: int) -> void:
	_highlight_tml.highlight_resource_tiles(pos, radius, self)

func _refresh_grid(excluded_bc: BuildingComponent) -> void:
	_highlight_tml._built_tile_locations.clear()
	_highlight_tml._valid_buildable_tiles.clear()
	_highlight_tml._collected_resource_tiles.clear()
	
	var buildings = (get_tree().get_nodes_in_group(
					GameEvents.BUILDING_COMPONENT) as Array[BuildingComponent])
	buildings = buildings.filter(func(building): return building != excluded_bc)
	
	for building in buildings:
		_highlight_tml._update_valid_buildable_tiles(building, self)
		_highlight_tml._update_collected_resource_tiles(building, self)
	
	_highlight_tml._resource_tiles_updated.emit(
					_highlight_tml._collected_resource_tiles.size())
	_highlight_tml._grid_updated.emit()

func _get_all_tile_map_layers(
		current_layer: Node2D) -> Dictionary[TileMapLayer, bool]:
	var layer_list: Dictionary[TileMapLayer, bool]
	var children = current_layer.get_children()
	children.reverse()
	
	for child_layer in children:
		if child_layer is Node2D:
			var child_node: Node2D = child_layer
			layer_list.merge(_get_all_tile_map_layers(child_node))
	
	if current_layer is TileMapLayer:
		var layer: TileMapLayer = current_layer
		layer_list[layer] = true
	
	return layer_list

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
