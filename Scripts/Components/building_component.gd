class_name BuildingComponent
extends Node2D

@export_custom(PROPERTY_HINT_FILE, 
				"*.tres") var building_resource_path: String
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_CHECKED) var building_resource: BuildingResource

var bc_name: StringName

func _ready():
	if building_resource_path != null:
		building_resource = load(building_resource_path) as BuildingResource
	
	bc_name = self.name
	add_to_group(bc_name)
	var emit := func(): GameEvents.emit_on_building_placed(self)
	emit.call_deferred()

func _get_grid_pos(cursor: CursorTML) -> Vector2i:
	return cursor._process_global_pos(self.global_position)

func _get_occupied_cell_positions(
							cursor: CursorTML) -> Dictionary[Vector2i, bool]:
	var tiles: Dictionary[Vector2i, bool]
	var grid_pos = _get_grid_pos(cursor)
	
	for x in range(grid_pos.x, grid_pos.x + building_resource.dimensions.x):
		for y in range(grid_pos.y, grid_pos.y + building_resource.dimensions.y):
			tiles[Vector2i(x,y)] = true
	
	return tiles

func _self_destruct() -> void:
	GameEvents.emit_on_building_destroyed(self)
	owner.queue_free()
