class_name Game
extends Node

@export var _tower_resource: BuildingResource
@export var _village_resource: BuildingResource
@export var _grid_manager: GridManager
@export var _button_manager: ButtonManager
@export var _y_sort_root: Node2D

var _building_resource: BuildingResource

#deals with setting up pressed signal
func _ready():
	_button_manager._place_tower_button.pressed.connect(
		_button_pressed.bind("tower"))
	_button_manager._place_village_button.pressed.connect(
		_button_pressed.bind("village"))

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
			&& _button_manager._active_button_checker() 
			&& (_grid_manager._temp_grid_pos != null 
			|| _grid_manager._temp_grid_pos != 
			_grid_manager._get_mouse_grid_pos_without_update())):
		_grid_manager._update_expanded_tiles(_grid_manager._temp_grid_pos, 
			_building_resource.buildable_radius)

#deals with the placement of sprite "building"
func _place_building() -> void:
	var building: Node2D
	
	if _grid_manager._temp_grid_pos == null: return
	
	building = _building_resource.building_scene.instantiate() as Node2D
	_button_manager._building_placed(_button_manager._current_building_type)
	
	_y_sort_root.add_child(building)
	building.global_position = _grid_manager._temp_grid_pos * 64

	_grid_manager._highlight_tml._clear()
	_grid_manager._main_tml_._toggle_visibility_off(
		_grid_manager._temp_grid_pos)

#resolves pressed signal functionality
func _button_pressed(button: String):
	_button_manager._button_pressed(_grid_manager, button)
	
	match button:
		"tower":
			_building_resource = _tower_resource
		"village":
			_building_resource = _village_resource
