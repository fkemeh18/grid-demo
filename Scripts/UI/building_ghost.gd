class_name BuildingGhost
extends Node2D

func _ready():
	pass # Replace with function body.

func _set_invalid() -> void:
	modulate = Color.RED

func _set_valid() -> void:
	modulate = Color.WHITE
