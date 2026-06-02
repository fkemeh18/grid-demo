class_name Game
extends Node

@export var _main_tml_: MainTML
@export var _highlight_tml: HighlightTML
@export var _building_scene : PackedScene
@export var _place_building_button: Button

var _temp_grid_pos: Vector2i
var _place_tile_button_active := false

#deals with setting up pressed signal
func _ready():
	_place_building_button.pressed.connect(_button_pressed)

#checks and enacts the pressed signal
func _unhandled_input(event):
	if (event.is_action_pressed("left_click") && _place_tile_button_active && (
		!_main_tml_._occupied_tile_dict.has(_temp_grid_pos))):
		_place_building()

# passes updated mouse_pos to tile map class for tile
func _process(delta):
	_main_tml_.set_tile(_get_mouse_grid_pos())
	
	if (_place_tile_button_active && (_temp_grid_pos != null || 
			_temp_grid_pos != _get_mouse_grid_pos_without_update())):
		_highlight_tml._update_highlighted_tiles(_temp_grid_pos)

# checks mouse pos and sends it to the tile grid class
func _get_mouse_grid_pos() -> Vector2i:
	_temp_grid_pos = _get_mouse_grid_pos_without_update()
	return _temp_grid_pos

func _get_mouse_grid_pos_without_update() -> Vector2i:
	var mouse_pos = _highlight_tml.get_global_mouse_position()
	return _main_tml_.process_mouse_pos(mouse_pos)

#deals with the placement of sprite "building"
func _place_building() -> void:
	if _temp_grid_pos == null:
		return
	
	var building = _building_scene.instantiate() as Node2D
	add_child(building)
	building.global_position = _temp_grid_pos * 64
	
	_main_tml_._register_built_tile(_temp_grid_pos)
	_main_tml_._toggle_visibility(_temp_grid_pos)
	_highlight_tml._clear()
	_place_tile_button_active = false

#resolves pressed signal functionality
func _button_pressed():
	if !_place_tile_button_active:
		_place_tile_button_active = true
		_main_tml_._toggle_visibility(_temp_grid_pos)
