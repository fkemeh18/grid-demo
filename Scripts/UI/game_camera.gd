class_name GameCamera
extends Camera2D

const TILE_SIZE := 64
const CAMERA_SPEED = 500
const ACTION_PAN_LEFT: StringName = "pan_left"
const ACTION_PAN_RIGHT: StringName = "pan_right"
const ACTION_PAN_UP: StringName = "pan_up"
const ACTION_PAN_DOWN: StringName = "pan_down"

func _process(delta):
	global_position = get_screen_center_position()
	
	var movement_vector = Input.get_vector(ACTION_PAN_LEFT, ACTION_PAN_RIGHT,
											 ACTION_PAN_UP, ACTION_PAN_DOWN)
	global_position += movement_vector * CAMERA_SPEED * (delta as float)

func _set_boundary(bounds: Rect2i) -> void:
	limit_left = bounds.position.x * TILE_SIZE
	limit_right = bounds.end.x * TILE_SIZE
	limit_top = bounds.position.y * TILE_SIZE
	limit_bottom = bounds.end.y * TILE_SIZE

func _center_on_pos(pos: Vector2) -> void:
	global_position = pos
