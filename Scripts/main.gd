class_name Game
extends Node2D

@export var grid: TileMapLayer

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	
	if grid is TileGrid:
		var grid_pos = grid.process_mouse_pos(mouse_pos)
		grid.set_tile(grid_pos)
		
	
