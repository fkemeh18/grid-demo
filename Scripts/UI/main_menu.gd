class_name MainMenu
extends Node

@export var _play_button: Button
@export var _options_button: Button
@export var _quit_button: Button

func _ready():
	_play_button.pressed.connect(_on_play_button_pressed)

func _on_play_button_pressed():
	LevelManager._instance.change_to_level(0)
