class_name GameEventsAutoloader
extends Node

enum State{Base, PlacingBuilding}

signal building_placed(bc: BuildingComponent)
signal building_disabled(bc: BuildingComponent)
signal building_enabled(bc: BuildingComponent)
signal building_destroyed(bc: BuildingComponent)

const BUILDING_COMPONENT: StringName = "BuildingComponent"

static var _instance: GameEventsAutoloader:
	get:
		return _instance
	set(value):
		_instance = value


func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self

static func emit_on_building_placed(bc: BuildingComponent) -> void:
	_instance.emit_signal("building_placed", bc)

static func emit_on_building_disabled(bc: BuildingComponent) -> void:
	_instance.emit_signal("building_disabled", bc)

static func emit_on_building_enabled(bc: BuildingComponent) -> void:
	_instance.emit_signal("building_enabled", bc)

static func emit_on_building_destroyed(bc: BuildingComponent) -> void:
	_instance.emit_signal("building_destroyed", bc)
