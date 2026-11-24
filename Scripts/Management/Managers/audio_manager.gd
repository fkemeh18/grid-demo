class_name AudioManagerAutoloader
extends Node

@export var _music_asp: AudioStreamPlayer
@export var _explosion_asp: AudioStreamPlayer
@export var _click_asp: AudioStreamPlayer
@export var _victory_asp: AudioStreamPlayer

static var _instance: AudioManagerAutoloader

func _ready():
	_music_asp.finished.connect(_on_music_finished)

func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self

static func play_building_destruction() -> void:
	_instance._explosion_asp.play()

static func play_victory() -> void:
	_instance._victory_asp.play()

static func register_buttons(buttons: Dictionary[Button, bool]) -> void:
	for button in buttons:
		button.pressed.connect(_instance._on_button_pressed)

func _on_button_pressed() -> void:
	_click_asp.play()

func _on_music_finished() -> void:
	get_tree().create_timer(5).timeout.connect(_on_music_delay_timer_complete)

func _on_music_delay_timer_complete() -> void:
	_music_asp.play()
