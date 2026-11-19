class_name SaveData

var _level_completion_status: Dictionary[String, LevelCompletionData] = {}

func save_level_completion(id: String, completed: bool) -> void:
	if !_level_completion_status.has(id):
		_level_completion_status[id] = LevelCompletionData.new()
	
	_level_completion_status[id].is_completed = completed
