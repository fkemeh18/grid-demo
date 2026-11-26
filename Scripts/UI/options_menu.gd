class_name OptionsMenu
extends CanvasLayer

signal done_pressed

const _MUSIC_BUS_NAME = "Music"
const _SFX_BUS_NAME = "SFX"

@export var _music_label: Label
@export var _sfx_label: Label
@export var _music_down_button: Button
@export var _music_up_button: Button
@export var _sfx_down_button: Button
@export var _sfx_up_button: Button
@export var _window_button: Button
@export var _done_button: Button


func _ready():
	AudioManagerAutoloader.register_buttons(ButtonMethods.register_buttons([
		_music_down_button, _music_up_button, _sfx_down_button, _sfx_up_button, 
		_window_button, _done_button]))
	_update_display()
	_music_up_button.pressed.connect(_change_bus_volume.bind(_MUSIC_BUS_NAME, .1))
	_music_down_button.pressed.connect(_change_bus_volume.bind(_MUSIC_BUS_NAME, -.1))
	_sfx_up_button.pressed.connect(_change_bus_volume.bind(_SFX_BUS_NAME, .1))
	_sfx_down_button.pressed.connect(_change_bus_volume.bind(_SFX_BUS_NAME, -.1))
	_window_button.pressed.connect(_on_window_button_pressed)
	_done_button.pressed.connect(_on_done_button_pressed)

func _update_display() -> void:
	_music_label.text = str(int(roundf(OptionsManagerAutoloader.get_bus_volume_percent(_MUSIC_BUS_NAME) * 10)))
	_sfx_label.text = str(int(roundf(OptionsManagerAutoloader.get_bus_volume_percent(_SFX_BUS_NAME) * 10)))
	_window_button.text = _set_window_button_text()

func _set_window_button_text() -> String:
	return "Fullscreen" if OptionsManagerAutoloader.is_fullscreen() else "Windowed"

func _change_bus_volume(bus_name: String, change: float) -> void:
	var bus_volume_percent = OptionsManagerAutoloader.get_bus_volume_percent(bus_name)
	bus_volume_percent = clampf(bus_volume_percent + change, 0, 1)
	OptionsManagerAutoloader.set_bus_volume_percent(bus_name, bus_volume_percent)
	_update_display()

func _on_window_button_pressed() -> void:
	OptionsManagerAutoloader.toggle_window_mode()
	_update_display()

func _on_done_button_pressed() -> void:
	done_pressed.emit()
