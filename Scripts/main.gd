class_name Game
extends Node2D

@export var _tile_grid: TileMapLayer
@export var _building_scene : PackedScene
@export var _place_building_button: Button

var _temp_pos: Vector2i

#deals with setting up pressed signal
func _ready():
	_place_building_button.pressed.connect(_button_pressed)

#checks and enacts the pressed signal
func _unhandled_input(event):
	if (event.is_action_pressed("left_click") && _tile_grid._visible_tile):
		_place_building()

# passes updated mouse_pos to tile map class for tile
func _process(delta):
	_tile_grid.set_tile(_get_mouse_grid_pos())

# checks mouse pos and sends it to the tile grid class
func _get_mouse_grid_pos() -> Vector2i:
	var grid_pos: Vector2i
	var mouse_pos = get_global_mouse_position()
	
	if _tile_grid is TileGrid:
		grid_pos = _tile_grid.process_mouse_pos(mouse_pos)
		_temp_pos = grid_pos
	
	return grid_pos

#deals with the placement of sprite "building"
func _place_building() -> void:
	var building = _building_scene.instantiate() as Node2D
	add_child(building)
	
	var grid_pos = _get_mouse_grid_pos()
	building.global_position = grid_pos * 64
	
	_tile_grid._toggle_visibility(_temp_pos)

#resolves pressed signal functionality
func _button_pressed():
	_tile_grid._toggle_visibility(_temp_pos)
