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
	return cursor.process_mouse_pos(self.global_position)
