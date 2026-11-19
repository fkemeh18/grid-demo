class_name SaveManagerAutoloader
extends Node

static var _instance: SaveManagerAutoloader:
	get:
		return _instance
	set(value):
		_instance = value

func _ready():
	#var save_data = SaveData.new()
	#save_data.save_level_completion("random", true)
	#var data_str = ForgeJSONGD.class_to_json_string(save_data)
	var data = '{"_level_completion_status":{"random":{"is_completed":true}}}'
	var save_data = ForgeJSONGD.json_string_to_class(SaveData, data) as SaveData
	
	for key in save_data._level_completion_status.keys():
		print(key)
		print(save_data._level_completion_status[key].is_completed)

func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self
