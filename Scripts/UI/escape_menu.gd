class_name EscapeMenu
extends CanvasLayer

const _ESCAPE_MENU_ACTION: StringName = "escape_menu"

@export_custom(PROPERTY_HINT_FILE, ".tscn") var _main_menu_scene_path: String
@export var _options_menu_scene: PackedScene
@export var _margin_container: MarginContainer
@export var _resume_button: Button
@export var _options_button: Button
@export var _main_menu_button: Button

func _ready():
	AudioManagerAutoloader.register_buttons(ButtonMethods.register_buttons([
		_resume_button, _options_button, _main_menu_button]))
	_resume_button.pressed.connect(_on_resume_button_pressed)
	_options_button.pressed.connect(_on_options_button_pressed)
	_main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _unhandled_input(event):
	if event.is_action_pressed(_ESCAPE_MENU_ACTION):
		queue_free()
		get_viewport().set_input_as_handled()

func _on_resume_button_pressed() -> void:
	queue_free()

func _on_options_button_pressed() -> void:
	_margin_container.visible = false
	var options_menu = _options_menu_scene.instantiate() as OptionsMenu
	add_child(options_menu)
	options_menu.done_pressed.connect(_on_options_done_pressed.bind(options_menu))

func _on_options_done_pressed(options_menu: OptionsMenu) -> void:
	_margin_container.visible = true
	options_menu.queue_free()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(_main_menu_scene_path)
