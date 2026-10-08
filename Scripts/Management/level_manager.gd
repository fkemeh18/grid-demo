class_name LevelManagerAutoloader
extends Node

@export var _level_scenes: Array[PackedScene]

static var _instance: LevelManagerAutoloader:
	get:
		return _instance
	set(value):
		_instance = value

func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self

func change_to_level(level_index: int) -> void:
	if level_index >= _level_scenes.size() || level_index < 0 : return
	
	var level_scene = _level_scenes[level_index]
	get_tree().change_scene_to_packed(level_scene)
