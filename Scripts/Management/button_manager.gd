class_name ButtonManager
extends Node

func _button_pressed(gm: GridManager) -> void:
	gm._cursor_tml._toggle_visibility_on()
	gm._update_highlight_tiles()
