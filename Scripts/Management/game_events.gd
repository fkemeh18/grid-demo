class_name Autoloader
extends Node

static var _instance: GameEvents:
	get:
		return _instance
	set(value):
		_instance = value

signal building_placed(bc: BuildingComponent)

func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self

static func emit_on_building_placed(bc: BuildingComponent) -> void:
	_instance.emit_signal("building_placed", bc)
