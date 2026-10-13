class_name LevelCompleteScreen
extends CanvasLayer

@export var _next_level_button: Button

func _ready():
	_next_level_button.pressed.connect(_on_next_level_button_pressed)

func _on_next_level_button_pressed() -> void:
	LevelManagerAutoloader._instance.change_to_next_level()
