class_name CursorTML
extends TileMapLayer

@export var _ghost_cursor: BuildingGhost
@export var _cursor_sprite: Sprite2D

# changes mouse_pos to Vector2i
func process_mouse_pos() -> Vector2i:
	var grid_pos = local_to_map(to_local(get_global_mouse_position()))
	return grid_pos

func _process_global_pos(pos: Vector2) -> Vector2i:
	return local_to_map(to_local(pos))

# handles tile grid rect location
func set_tile(pos: Vector2i) -> void:
	_ghost_cursor.position = pos * 64

func _toggle_visibility_on() -> void:
	if !is_instance_valid(_ghost_cursor): return
	_ghost_cursor.visible = true

func _toggle_visibility_off() -> void:
	if !is_instance_valid(_ghost_cursor): return
	_ghost_cursor.visible = false
