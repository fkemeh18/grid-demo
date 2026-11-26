class_name MainMenu
extends Node

@export var _main_menu_container: Control
@export var _level_select_screen: LevelSelectScreen
@export var _options_menu: PackedScene
@export var _play_button: Button
@export var _options_button: Button
@export var _quit_button: Button

func _ready():
	AudioManagerAutoloader.register_buttons(ButtonMethods.register_buttons([
		_play_button, _options_button, _quit_button]))
	_main_menu_container.visible = true
	_level_select_screen.visible = false
	_play_button.pressed.connect(_on_play_button_pressed)
	_options_button.pressed.connect(_on_options_button_pressed)
	_quit_button.pressed.connect(_quit_game)
	_level_select_screen._return_button_pressed.connect(
		_on_level_select_return_button_pressed)

func _on_play_button_pressed():
	_main_menu_container.visible = false
	_level_select_screen.visible = true

func _on_level_select_return_button_pressed():
	_main_menu_container.visible = true
	_level_select_screen.visible = false

func _on_options_button_pressed():
	_main_menu_container.visible = false
	var options_menu = _options_menu.instantiate() as OptionsMenu
	add_child(options_menu)
	options_menu.done_pressed.connect(_on_options_done_pressed.bind(options_menu))

func _on_options_done_pressed(options_menu: OptionsMenu) -> void:
	options_menu.queue_free()
	_main_menu_container.visible = true

func _quit_game() -> void:
	get_tree().quit()
