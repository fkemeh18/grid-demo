class_name GridManager
extends Node

@export var _main_tml_: MainTML
@export var _highlight_tml: HighlightTML
@export var _base_terrain_tml: TileMapLayer

var _temp_grid_pos: Vector2i
var _all_tile_map_layers: Dictionary[TileMapLayer, bool]

func _ready():
	GameEvents._instance.building_placed.connect(_on_placed_building)
	_all_tile_map_layers = _get_all_tile_map_layers(_base_terrain_tml)

func _process(delta):
	_main_tml_.set_tile(_get_mouse_grid_pos())
	
func _get_mouse_grid_pos() -> Vector2i:
	_temp_grid_pos = _get_mouse_grid_pos_without_update()
	return _temp_grid_pos

func _get_mouse_grid_pos_without_update() -> Vector2i:
	var mouse_pos = _highlight_tml.get_global_mouse_position()
	return _main_tml_.process_mouse_pos(mouse_pos)

func _does_tile_have_custom_data(pos: Vector2i, data_name: String) -> bool:
	for layer in _all_tile_map_layers:
		var custom_terrain_data = layer.get_cell_tile_data(pos)
		if custom_terrain_data == null: continue
		return custom_terrain_data.get_custom_data(data_name) as bool
	
	return false

func _is_cell_currently_buildable(pos: Vector2i) -> bool:
	return _highlight_tml._valid_buildable_tiles.has(pos)

func _on_placed_building(bc: BuildingComponent) -> void:
	_highlight_tml._update_valid_buildable_tiles(bc, self)

func _update_highlight_tiles() -> void:
	_highlight_tml.highlight_buildable_tiles()

func _update_expanded_tiles(pos: Vector2i, radius: int) -> void:
	_highlight_tml.highlight_expanded_buildable_tiles(pos, radius, self)

func _update_resource_tiles(pos: Vector2i, radius: int) -> void:
	_highlight_tml.highlight_resource_tiles(pos, radius, self)

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
