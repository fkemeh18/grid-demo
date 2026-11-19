class_name GameCamera
extends Camera2D

const TILE_SIZE := 64
const CAMERA_SPEED = 500
const NOISE_SAMPLE_GROWTH := .1
const MAX_CAMERA_OFFSET: float = 24
const NOISE_FREQUENCY_MULT: float = 100
const SHAKE_DECAY : float = 2.4
const ACTION_PAN_LEFT: StringName = "pan_left"
const ACTION_PAN_RIGHT: StringName = "pan_right"
const ACTION_PAN_UP: StringName = "pan_up"
const ACTION_PAN_DOWN: StringName = "pan_down"

@export var _shake_noise: FastNoiseLite

static var _instance: GameCamera

var _noise_sample: Vector2
var _current_shake_percentage: float

func _notification(what):
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		_instance = self

func _process(delta):
	var movement_vector = Input.get_vector(ACTION_PAN_LEFT, ACTION_PAN_RIGHT,
											 ACTION_PAN_UP, ACTION_PAN_DOWN)
	global_position += movement_vector * CAMERA_SPEED * (delta as float)
	
	var viewport_rect = get_viewport_rect()
	var half_width = viewport_rect.size.x / 2
	var half_height = viewport_rect.size.y / 2
	var x_clamped = clamp(global_position.x,
		limit_left + half_width, limit_right - half_width)
	var y_clamped = clamp(global_position.y,
		limit_top + half_height, limit_bottom - half_height)
	
	global_position = Vector2(x_clamped, y_clamped)
	
	_apply_camera_shake(delta)

static func shake() -> void:
	_instance._current_shake_percentage = 1

func _set_boundary(bounds: Rect2i) -> void:
	limit_left = bounds.position.x * TILE_SIZE
	limit_right = bounds.end.x * TILE_SIZE
	limit_top = bounds.position.y * TILE_SIZE
	limit_bottom = bounds.end.y * TILE_SIZE

func _center_on_pos(pos: Vector2) -> void:
	global_position = pos

func _apply_camera_shake(delta: float) -> void:
	if _current_shake_percentage > 0:
		_noise_sample.x += NOISE_SAMPLE_GROWTH * NOISE_FREQUENCY_MULT * delta
		_noise_sample.y += NOISE_SAMPLE_GROWTH * NOISE_FREQUENCY_MULT * delta
		
		_current_shake_percentage = clamp(
			_current_shake_percentage - (SHAKE_DECAY * delta), 0, 1)
	
	var x_sample = _shake_noise.get_noise_2d(_noise_sample.x, 0)
	var y_sample = _shake_noise.get_noise_2d(0, _noise_sample.y)
	
	offset = Vector2(MAX_CAMERA_OFFSET * x_sample, 
		MAX_CAMERA_OFFSET * y_sample) * _current_shake_percentage
	
	print(offset)
