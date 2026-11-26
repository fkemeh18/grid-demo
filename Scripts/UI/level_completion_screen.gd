class_name LevelCompleteScreen
extends CanvasLayer

const _FINAL_LEVEL_BUTTON_TEXT = "Return to Main Menu"

@export_custom(PROPERTY_HINT_FILE, ".tscn") var _main_menu_scene_path: String
@export var _next_level_button: Button

func _ready():
	AudioManagerAutoloader.play_victory()
	
	if LevelManager.is_last_level():
		_next_level_button.text = _FINAL_LEVEL_BUTTON_TEXT
	
	_next_level_button.pressed.connect(_on_next_level_button_pressed)

func _on_next_level_button_pressed() -> void:
	if !LevelManager.is_last_level():
		LevelManagerAutoloader.change_to_next_level()
	else:
		get_tree().change_scene_to_file(_main_menu_scene_path)
