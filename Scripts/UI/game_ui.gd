class_name GameUI
extends CanvasLayer

signal _waiting_on_main
signal _pressed_button_type(resource: BuildingResource)

@export var _button_manager: ButtonManager
@export var _building_resources: Array[BuildingResource]
@export var building_section_container: VBoxContainer
@export var _building_section: PackedScene
var _grid_manager: GridManager

func _ready():
	_waiting_on_main.emit.call_deferred()

func _create_building_sections() -> void:
	_button_manager._create_building_sections(self, _grid_manager)

func _access_gm(gm: GridManager) -> void:
	self._grid_manager = gm
