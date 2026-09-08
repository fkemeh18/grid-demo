class_name BuildingComponent
extends Node2D

@export_custom(PROPERTY_HINT_FILE, 
				"*.tres") var _building_resource_path: String
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_CHECKED) var building_resource: BuildingResource

var _occupied_tiles: Dictionary[Vector2i, bool]
var bc_name: StringName

func _ready():
	if _building_resource_path != null:
		building_resource = load(_building_resource_path) as BuildingResource
	
	bc_name = self.name
	add_to_group(bc_name)
	var emit := func(): GameEvents.emit_on_building_placed(self)
	emit.call_deferred()

#func _initialize(cursor: CursorTML) -> void:
	#_calculate_occupied_cell_positions(cursor)

func _get_grid_pos(cursor: CursorTML) -> Vector2i:
	return cursor._process_global_pos(self.global_position)

func _calculate_occupied_cell_positions(
							cursor: CursorTML) -> void:
	var grid_pos = _get_grid_pos(cursor)
	
	for x in range(grid_pos.x, grid_pos.x + building_resource.dimensions.x):
		for y in range(grid_pos.y, grid_pos.y + building_resource.dimensions.y):
			_occupied_tiles[Vector2i(x,y)] = true
	

func _get_occupied_cell_positions() -> Dictionary[Vector2i, bool]:
	var tiles := _occupied_tiles
	return tiles

func is_tile_in_built_area(tile: Vector2i) -> bool:
	return _occupied_tiles.has(tile)

func _self_destruct() -> void:
	GameEvents.emit_on_building_destroyed(self)
	owner.queue_free()
