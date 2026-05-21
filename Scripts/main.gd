class_name Game
extends Node2D

@export var _grid: TileMapLayer
@export var _building_scene : PackedScene
@export var _place_building_button: Button

func _ready():
	_place_building_button.pressed.connect(_button_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		_place_building()

func _process(delta):
	_grid.set_tile(_get_mouse_grid_pos())

func _get_mouse_grid_pos() -> Vector2i:
	var grid_pos: Vector2i
	var mouse_pos = get_global_mouse_position()
	
	if _grid is TileGrid:
		grid_pos = _grid.process_mouse_pos(mouse_pos)
	
	return grid_pos

func _place_building() -> void:
	var building = _building_scene.instantiate() as Node2D
	add_child(building)
	
	var grid_pos = _get_mouse_grid_pos()
	building.global_position = grid_pos * 64
	
func _button_pressed():
	print("hi")
