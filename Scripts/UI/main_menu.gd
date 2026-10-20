class_name MainMenu
extends Node

@export var _main_menu_container: Control
@export var _level_select_screen: LevelSelectScreen
@export var _play_button: Button
@export var _options_button: Button
@export var _quit_button: Button

func _ready():
	_main_menu_container.visible = true
	_level_select_screen.visible = false
	_play_button.pressed.connect(_on_play_button_pressed)
	_quit_button.pressed.connect(_quit_game)
	_level_select_screen._return_button_pressed.connect(
		_on_level_select_return_button_pressed)

func _on_play_button_pressed():
	_main_menu_container.visible = false
	_level_select_screen.visible = true

func _on_level_select_return_button_pressed():
	_main_menu_container.visible = true
	_level_select_screen.visible = false

func _quit_game() -> void:
	get_tree().quit()
