class_name BuildingComponent
extends Node2D

@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var build_radius: int

func _ready():
	add_to_group(self.name)
	GameEvents.emit_on_building_placed(self)

func _get_grid_pos(main: MainTML) -> Vector2i:
	return main.process_mouse_pos(self.global_position)
