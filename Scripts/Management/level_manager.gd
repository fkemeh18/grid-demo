class_name LevelManagerAutoloader
extends Node

@export var _level_scenes: Array[PackedScene]

static var _instance: LevelManagerAutoloader:
	get:
		return _instance
	set(value):
		_instance = value

var _curr_level_index: int

func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self

func change_to_level(level_index: int) -> void:
	if level_index >= _level_scenes.size() || level_index < 0 : return
	
	_curr_level_index = level_index
	var level_scene = _level_scenes[_curr_level_index]
	get_tree().change_scene_to_packed(level_scene)

func change_to_next_level() -> void:
	change_to_level(_curr_level_index + 1)
