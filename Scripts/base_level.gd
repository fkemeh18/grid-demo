class_name BaseLevel
extends Node

@export var _building_manager: BuildingManager
@export var _grid_manager: GridManager
@export var _game_camera: GameCamera
@export var _base_building: Node2D
@export var _gold_mine: GoldMine
@export var _level_completed_screen_scene: PackedScene
@export var _level_resource: BaseLevelResource

var _is_complete: bool

func _ready():
	_building_manager._game_ui._waiting_on_main.connect(_main_is_ready)
	_building_manager.set_starting_resource_count(
										_level_resource.starting_resource_count)
	_building_manager._emit_available_resource_count_changed()
	
	_grid_manager.set_gold_mine_pos(_grid_manager._cursor_tml
					._process_global_pos(_gold_mine.global_position))
	_grid_manager._highlight_tml._grid_updated.connect(_on_grid_updated)
	
	_game_camera._set_boundary(_grid_manager._base_terrain_tml.get_used_rect())
	_game_camera._center_on_pos(_base_building.global_position)

func _main_is_ready():
	_building_manager._game_ui._create_building_sections()

func _show_level_complete() -> void:
	_is_complete = true
	SaveManager.save_level_completion(_level_resource)
	
	var level_complete_screen = (
		_level_completed_screen_scene.instantiate() as LevelCompleteScreen)
	
	add_child(level_complete_screen)
	_gold_mine._set_active()
	_building_manager._game_ui.hide_UI()

func _on_grid_updated() -> void:
	if _is_complete: return
	var _gold_mine_pos = _grid_manager._cursor_tml._process_global_pos(
							_gold_mine.global_position)
	
	if _grid_manager._is_cell_in_view_of_a_building(_gold_mine_pos):
		_show_level_complete()
