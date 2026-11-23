class_name ErrorManager
extends Node

@export var _floating_text_scene: PackedScene

static var _instance: ErrorManager

func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self

static func show_message(message: String) -> void:
	var floating_text = _instance._floating_text_scene.instantiate(
			) as FloatingText
	_instance.add_child(floating_text)
	floating_text.set_text(message)
	floating_text.global_position = floating_text.get_global_mouse_position()
