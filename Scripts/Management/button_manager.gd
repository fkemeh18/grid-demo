class_name ButtonManager
extends Node

var _current_building_type: String
var _place_tower_button_active := false
var _place_village_button_active := false

func _button_pressed(gm: GridManager, button_type: String) -> void:
	match button_type:
		"Tower" when not _place_tower_button_active:
			_resolve_button_pressed(gm, button_type)
			_place_tower_button_active = true
		"Village" when not _place_village_button_active:
			_resolve_button_pressed(gm, button_type)
			_place_village_button_active = true

func _building_placed(button: String) -> void:
	match button:
		"Tower":
			_place_tower_button_active = false
		"Village":
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

func _active_button_checker() -> bool:
	match _current_building_type:
		"Tower": return _place_tower_button_active
		"Village": return _place_village_button_active
		_: return false
	
