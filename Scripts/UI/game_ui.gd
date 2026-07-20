class_name GameUI
extends MarginContainer

signal _waiting_on_main
signal _pressed_button_type(resource: BuildingResource)

@export var _button_manager: ButtonManager
@export var _building_resources: Array[BuildingResource]
@export var _hbox_container: HBoxContainer
var _grid_manager: GridManager

func _ready():
	_waiting_on_main.emit.call_deferred()

func _create_building_buttons() -> void:
	for resource in _building_resources:
		var building_button = Button.new()
		building_button.text = "Place %s" %[resource.display_name]
		_hbox_container.add_child(building_button)
		print(building_button.text)
		
		building_button.pressed.connect(_button_pressed.bind(resource))

func _button_pressed(button: BuildingResource):
	_pressed_button_type.emit(button)
	_button_manager._button_pressed(_grid_manager, button.display_name)

func _access_gm(gm: GridManager) -> void:
	self._grid_manager = gm
