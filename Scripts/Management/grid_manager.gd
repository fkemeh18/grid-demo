class_name GridManager
extends Node

@export var _main_tml_: MainTML
@export var _highlight_tml: HighlightTML
@export var _base_terrain_tml: TileMapLayer

var _temp_grid_pos: Vector2i
var player_placed_building = false

func _ready():
	GameEvents._instance.building_placed.connect(_on_placed_building)
	#print(player_placed_building)

func _process(delta):
	_main_tml_.set_tile(_get_mouse_grid_pos())
	
func _get_mouse_grid_pos() -> Vector2i:
	_temp_grid_pos = _get_mouse_grid_pos_without_update()
	return _temp_grid_pos

func _get_mouse_grid_pos_without_update() -> Vector2i:
	var mouse_pos = _highlight_tml.get_global_mouse_position()
	return _main_tml_.process_mouse_pos(mouse_pos)

func _is_terrain_buildable(pos: Vector2i) -> bool:
	var custom_terrain_data = _base_terrain_tml.get_cell_tile_data(pos)
	
	if custom_terrain_data == null: return false
	
	return custom_terrain_data.get_custom_data("buildable") as bool

func _is_cell_currently_buildable(pos: Vector2i) -> bool:
	return _highlight_tml._valid_buildable_tiles.has(pos)

func _on_placed_building(bc: BuildingComponent) -> void:
	_highlight_tml._update_valid_buildable_tiles(bc, self)

func _update_highlight_tml() -> void:
	_highlight_tml.highlight_buildable_tiles()

func _player_pressed() -> void:
	player_placed_building = true
