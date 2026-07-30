class_name Game
extends Node

@export var _building_manager: BuildingManager

func _ready():
	_building_manager._game_ui._waiting_on_main.connect(_main_is_ready)

func _main_is_ready():
	_building_manager._game_ui._create_building_buttons()
