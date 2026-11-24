class_name ButtonMethods
extends Node

static func register_buttons(buttons: Array[Button]) -> Dictionary[Button, bool]:
	var buttons_dict: Dictionary[Button, bool]
	for button in buttons:
		buttons_dict[button] = true
	return buttons_dict
