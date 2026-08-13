class_name GoldMine
extends Node2D

@export var _sprite: Sprite2D
@export var _active_texture: Texture2D

func _ready():
	pass # Replace with function body.

func _set_active() -> void:
	_sprite.texture = _active_texture
