class_name BuildingAnimatorComponent
extends Node2D

var _active_tween: Tween

func _ready():
	play_in_animation()

func play_in_animation() -> void:
	if _active_tween != null && _active_tween.is_valid(): _active_tween.kill()
