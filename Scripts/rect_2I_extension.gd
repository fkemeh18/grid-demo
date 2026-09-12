class_name Rect2IExtension
extends Node

static func to_tiles(rect: Rect2i) -> Dictionary[Vector2i, bool]:
	var tiles: Dictionary[Vector2i, bool]
	
#	finds checkable tiles
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			tiles[Vector2i(x, y)] = true
	
	return tiles
