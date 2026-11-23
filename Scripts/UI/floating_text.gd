class_name FloatingText
extends Node2D

func set_text(text: String) -> void:
	(get_node("%Label") as Label).text = text
