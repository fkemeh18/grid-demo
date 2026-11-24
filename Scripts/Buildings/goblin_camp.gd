class_name GoblinCamp
extends Node2D

@export var _animated_building: AnimatedSprite2D
@export var _flame_animation: AnimatedSprite2D
@export var _bc: BuildingComponent
@export var _asp: AudioStreamPlayer

func _ready():
	_flame_animation.visible = false
	_bc.disabled.connect(_on_disabled)
	_bc.enabled.connect(_on_enabled)

func _on_disabled() -> void:
	_asp.play()
	_animated_building.play("destroyed")
	_flame_animation.visible = true

func _on_enabled() -> void:
	_animated_building.play("default")
	_flame_animation.visible = false
