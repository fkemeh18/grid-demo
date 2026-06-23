class_name BuildingComponent
extends Node2D

@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var build_radius: int

var bc_name: StringName

func _ready():
	bc_name = self.name
	add_to_group(bc_name)
	var emit := func(): GameEvents.emit_on_building_placed(self)
	emit.call_deferred()

func _get_grid_pos(main: MainTML) -> Vector2i:
	return main.process_mouse_pos(self.global_position)
