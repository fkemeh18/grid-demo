class_name Game
extends Node

@export var _building_scene : PackedScene
@export var _grid_manager: GridManager
@export var _button_manager: ButtonManager

#deals with setting up pressed signal
func _ready():
	_button_manager._place_building_button.pressed.connect(_button_pressed)

#checks and enacts the pressed signal
func _unhandled_input(event):
	if (event.is_action_pressed("left_click") 
		&& _button_manager._place_building_button_active 
		&& (!_grid_manager._is_cell_occupied(_grid_manager._temp_grid_pos))):
		_place_building()

# passes updated mouse_pos to tile map class for tile
func _process(delta):
	if (_button_manager._place_building_button_active 
			&& (_grid_manager._temp_grid_pos != null || 
			_grid_manager._temp_grid_pos != 
			_grid_manager._get_mouse_grid_pos_without_update())):
		_grid_manager._update_highlight_tml(3)

#deals with the placement of sprite "building"
func _place_building() -> void:
	if _grid_manager._temp_grid_pos == null:
		return
	
	var building = _building_scene.instantiate() as Node2D
	add_child(building)
	building.global_position = _grid_manager._temp_grid_pos * 64
	_grid_manager._on_placed_building_()
	_button_manager._place_building_button_active = false

#resolves pressed signal functionality
func _button_pressed():
	if !_button_manager._place_building_button_active:
		_button_manager._place_building_button_active = true
		_grid_manager._main_tml_._toggle_visibility(
			_grid_manager._temp_grid_pos)
