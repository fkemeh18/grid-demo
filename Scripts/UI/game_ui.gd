class_name GameUI
extends MarginContainer

signal _pressed_button_type(type: String)

@export var _button_manager: ButtonManager
var _grid_manager: GridManager

func _ready():
	_button_manager._place_tower_button.pressed.connect(
		_button_pressed.bind("tower"), CONNECT_DEFERRED)
	_button_manager._place_village_button.pressed.connect(
		_button_pressed.bind("village"), CONNECT_DEFERRED)

func _button_pressed(button: String):
	_pressed_button_type.emit(button)
	_button_manager._button_pressed(_grid_manager, button)

func _access_gm(gm: GridManager) -> void:
	self._grid_manager = gm
