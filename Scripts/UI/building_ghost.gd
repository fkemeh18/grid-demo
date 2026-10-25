class_name BuildingGhost
extends Node2D

@export var _building_boundary_TL: Node2D
@export var _building_boundary_TR: Node2D
@export var _building_boundary_BL: Node2D
@export var _building_boundary_BR: Node2D
@export var _sprite_root: Node2D
@export var _vertical_root: Node2D

var _sprite_tween: Tween

func _ready():
	var vertical_tween = create_tween()
	vertical_tween.set_loops()
	vertical_tween.tween_property(
		_vertical_root, "position", Vector2.DOWN * 7, 0.25
		).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	vertical_tween.tween_property(
		_vertical_root, "position", Vector2.UP * 7, 0.25
		).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)

func set_dimensions(area: Vector2i) -> void:
	_building_boundary_TR.position = area * Vector2i(64, 0)
	_building_boundary_BL.position = area * Vector2i(0, 64)
	_building_boundary_BR.position = area * Vector2i(64, 64)

func add_sprite_node(sprite_node: Node2D) -> void:
	_vertical_root.add_child(sprite_node)

func play_hover_animation() -> void:
	if _sprite_tween != null && _sprite_tween.is_valid(): _sprite_tween.kill()
	
	_sprite_tween = create_tween()
	_sprite_tween.tween_property(_sprite_root, "global_position",
									global_position, 0.3).set_trans(
									Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _set_invalid() -> void:
	modulate = Color.RED
	_vertical_root.modulate = modulate

func _set_valid() -> void:
	modulate = Color.WHITE
	_vertical_root.modulate = modulate
