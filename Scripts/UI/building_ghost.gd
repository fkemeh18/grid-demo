class_name BuildingGhost
extends Node2D

@export var _building_boundary_TL: Node2D
@export var _building_boundary_TR: Node2D
@export var _building_boundary_BL: Node2D
@export var _building_boundary_BR: Node2D

func set_dimensions(area: Vector2i) -> void:
	_building_boundary_TR.position = area * Vector2i(64, 0)
	_building_boundary_BL.position = area * Vector2i(0, 64)
	_building_boundary_BR.position = area * Vector2i(64, 64)
	

func _set_invalid() -> void:
	modulate = Color.RED

func _set_valid() -> void:
	modulate = Color.WHITE
