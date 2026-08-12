class_name Autoloader
extends Node

enum State{Base, PlacingBuilding}

signal building_placed(bc: BuildingComponent)
signal building_destroyed(bc: BuildingComponent)

const BUILDING_COMPONENT: StringName = "BuildingComponent"

static var _instance: GameEvents:
	get:
		return _instance
	set(value):
		_instance = value


func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self

static func emit_on_building_placed(bc: BuildingComponent) -> void:
	_instance.emit_signal("building_placed", bc)

static func emit_on_building_destroyed(bc: BuildingComponent) -> void:
	_instance.emit_signal("building_destroyed", bc)
