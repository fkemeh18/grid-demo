class_name ResourceIndicator
extends Node2D

@export var _animated_sprite: AnimatedSprite2D

var _tween: Tween

func _ready():
	var intensity = 4
	var duration = randf_range(.475, .525)
	
	_tween = create_tween()
	_tween.set_loops()
	_tween.tween_property(_animated_sprite, "position", Vector2.UP * intensity, duration
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(_animated_sprite, "position", Vector2.DOWN * intensity, duration
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func destroy() -> void:
	if _tween != null && _tween.is_valid():
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_interval(randf_range(.1, .3))
	_tween.tween_property(_animated_sprite, "scale", Vector2.ZERO, 0.3
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	_tween.parallel().tween_property(_animated_sprite, "position", Vector2.UP * 32, 0.3
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	_tween.tween_callback(func(): queue_free())
	
