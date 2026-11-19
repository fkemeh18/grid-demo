class_name SettingsManagerAutoloader
extends Node

func _ready():
	RenderingServer.set_default_clear_color(Color("47aba9"))
	get_viewport().get_window().min_size = Vector2i(1280, 720)
