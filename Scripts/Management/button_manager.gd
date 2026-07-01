class_name ButtonManager
extends Node

@export var _place_tower_button: Button
@export var _place_village_button: Button

var _current_building_type: String
var _place_tower_button_active := false
var _place_village_button_active := false

func _button_pressed(gm: GridManager, button_type: String) -> void:
	match button_type:
		"tower" when not _place_tower_button_active:
			_resolve_button_pressed(gm, button_type)
			_place_tower_button_active = true
		"village" when not _place_village_button_active:
			_resolve_button_pressed(gm, button_type)
			_place_village_button_active = true

func _building_placed(button: String) -> void:
	match button:
		"tower":
			_place_tower_button_active = false
		"village":
			_place_village_button_active = false
		_:
			_deactivate_all_placement_buttons()

func _deactivate_all_placement_buttons() -> void:
	_place_tower_button_active = false
	_place_village_button_active = false

func _resolve_button_pressed(gm: GridManager, type: String) -> void:
	_deactivate_all_placement_buttons()
	_current_building_type = type
	
	gm._main_tml_._toggle_visibility_on(gm._temp_grid_pos)
	gm._update_highlight_tiles()
