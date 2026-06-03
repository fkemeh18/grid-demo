class_name ButtonManager
extends Node

@export var _place_building_button: Button

var _place_building_button_active := false

func _place_building() -> void:
	_place_building_button_active = false
