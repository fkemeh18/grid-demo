class_name CursorAutoloader
extends CanvasLayer

@export var cursor_sprite: Sprite2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta):
	cursor_sprite.global_position = cursor_sprite.get_global_mouse_position()
