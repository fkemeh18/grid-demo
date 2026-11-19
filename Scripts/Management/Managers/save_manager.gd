class_name SaveManagerAutoloader
extends Node

const _SAVE_DATA_PATH = "user://saves/save.json"
const _SECURITY_KEY = "xxkqVbfRhftk"

static var _instance: SaveManagerAutoloader:
	get:
		return _instance
	set(value):
		_instance = value

static var save_data := SaveData.new()

func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self
		_load_save_data()

static func save_level_completion(resource: BaseLevelResource) -> void:
	save_data.save_level_completion(resource.level_id, true)
	_write_save_data()

static func _write_save_data() -> void:
#	user:// is for the directory established in project settings -> config -> custom_user_dir_name
#	what comes after is the name of the file we create when saving
	ForgeJSONGD.store_json_file(
		_SAVE_DATA_PATH, ForgeJSONGD.class_to_json(save_data))
	#var data_str = ForgeJSONGD.class_to_json_string(save_data)

static func _load_save_data() -> void:
	if !FileAccess.file_exists(_SAVE_DATA_PATH):
		return
	
	if _save_data_check_is_successful():
		save_data = ForgeJSONGD.json_file_to_class(SaveData, _SAVE_DATA_PATH) as SaveData
	else: print("Save Data is corrupted!")

static func _save_data_check_is_successful() -> bool:
	var file = FileAccess.open(_SAVE_DATA_PATH, FileAccess.READ)
	var json_text = file.get_as_text()
	
	var json = JSON.new()
	var parse_error := json.parse(json_text)
	return parse_error == OK

static func is_level_completed(level_id: String) -> bool:
	var data = save_data._level_completion_status[level_id] if save_data._level_completion_status.has(level_id) else null
	return data.is_completed == true if data != null else false
