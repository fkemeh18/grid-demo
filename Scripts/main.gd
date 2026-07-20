class_name Game
extends Node

@export var _game_ui: GameUI
@export var _grid_manager: GridManager
@export var _y_sort_root: Node2D

var _building_resource: BuildingResource

#deals with setting up pressed signal
func _ready():
	_game_ui._pressed_button_type.connect(_change_building)
	_game_ui._waiting_on_main.connect(_main_is_ready)
	
	_grid_manager._highlight_tml._resource_tiles_updated.connect(
		_on_resource_tiles_updated)

#checks and enacts the pressed signal
func _unhandled_input(event):
	if (event.is_action_pressed("left_click") 
			&& _grid_manager._main_tml_._visible_tile
			&& (_grid_manager._is_cell_currently_buildable(
				_grid_manager._temp_grid_pos))):
		_place_building()

# passes updated mouse_pos to tile map class for tile
func _process(delta):
	if (_building_resource != null 
			&& _game_ui._button_manager._active_button_checker() 
			&& (_grid_manager._temp_grid_pos != null 
			|| _grid_manager._temp_grid_pos != 
			_grid_manager._get_mouse_grid_pos_without_update())):
		_grid_manager._highlight_tml._clear()
		_grid_manager._update_expanded_tiles(_grid_manager._temp_grid_pos, 
			_building_resource.buildable_radius)
		_grid_manager._update_resource_tiles(_grid_manager._temp_grid_pos, 
			_building_resource.resource_radius)

#deals with the placement of sprite "building"
func _place_building() -> void:
	var building: Node2D
	
	if _grid_manager._temp_grid_pos == null: return
	
	building = _building_resource.building_scene.instantiate() as Node2D
	_game_ui._button_manager._building_placed(
		_game_ui._button_manager._current_building_type)
	
	_y_sort_root.add_child(building)
	building.global_position = _grid_manager._temp_grid_pos * 64

	_grid_manager._highlight_tml._clear()
	_grid_manager._main_tml_._toggle_visibility_off(
		_grid_manager._temp_grid_pos)

#resolves pressed signal functionality
func _change_building(resource: BuildingResource):
	_ui_button_pressed()
	_building_resource = resource

func _on_resource_tiles_updated(resource_count: int) -> void:
	print(resource_count)

func _ui_button_pressed() -> void:
	_game_ui._access_gm(_grid_manager)

func _main_is_ready():
	_game_ui._create_building_buttons()
