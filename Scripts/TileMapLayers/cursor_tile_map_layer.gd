class_name CursorTML
extends TileMapLayer

@export var _ghost_cursor: Node2D
@export var _cursor_sprite: Sprite2D

#var _visible_tile = false
#var _temp_tile_pos: Vector2i

# changes mouse_pos to Vector2i
func process_mouse_pos(mouse_pos: Vector2) -> Vector2i:
	var grid_pos = local_to_map(to_local(mouse_pos))
	return grid_pos

# handles tile grid rect location
func set_tile(pos: Vector2i) -> void:
	#if tile_checker(pos):
		#set_cell(pos, 1, Vector2i(0, 0))
	if !is_instance_valid(_ghost_cursor): return
	_ghost_cursor.position = pos * 64
	#if pos != _temp_tile_pos:
		#erase_cell(_temp_tile_pos)
		
	#_temp_tile_pos = pos

# Checks conditions for placing tile
#func tile_checker(mouse_pos: Vector2i) -> bool:
	#if ((get_cell_source_id(mouse_pos) == -1) && (
		#get_cell_atlas_coords(mouse_pos) == Vector2i(-1, -1)) 
		##&& (_visible_tile)
		#):
		#return true
	#else:
		#return false

func _toggle_visibility_on() -> void:
	#_visible_tile = true
	if !is_instance_valid(_ghost_cursor): return
	print("yo")
	_ghost_cursor.visible = true

func _toggle_visibility_off() -> void:
	#_visible_tile = false
	if !is_instance_valid(_ghost_cursor): return
	_ghost_cursor.visible = false
	#erase_cell(tile)
