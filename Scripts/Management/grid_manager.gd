class_name GridManager
extends Node

@export var _cursor_tml: CursorTML
@export var _highlight_tml: HighlightTML
@export var _base_terrain_tml: TileMapLayer

var _hovered_rect_pos: Rect2i = Rect2i(Vector2i.ZERO, Vector2i.ONE)
var _all_tile_map_layers: Dictionary[TileMapLayer, bool]
var _curr_state = GameEvents.State.Base

func _ready():
	GameEvents._instance.building_placed.connect(_on_placed_building)
	GameEvents._instance.building_destroyed.connect(_on_destroyed_building)
	_all_tile_map_layers = _get_all_tile_map_layers(_base_terrain_tml)

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
func _does_tile_have_custom_data(pos: Vector2i, data_name: String) -> bool:
	for layer in _all_tile_map_layers:
		var custom_terrain_data = layer.get_cell_tile_data(pos)
		if (custom_terrain_data == null || custom_terrain_data.get_custom_data(
					_highlight_tml.IS_IGNORED)): continue
		return custom_terrain_data.get_custom_data(data_name) as bool
	
	return false

func _is_cell_currently_buildable(pos: Vector2i) -> bool:
	#print(_highlight_tml._valid_buildable_tiles.has(pos))
	return _highlight_tml._valid_buildable_tiles.has(pos)

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
		base_layer: TileMapLayer) -> Dictionary[TileMapLayer, bool]:
	var layer_list: Dictionary[TileMapLayer, bool]
	var children = base_layer.get_children()
	children.reverse()
	
	for child_layer in children:
		if child_layer is TileMapLayer:
			layer_list.merge(_get_all_tile_map_layers(child_layer))
	
	layer_list[base_layer] = true
	return layer_list
