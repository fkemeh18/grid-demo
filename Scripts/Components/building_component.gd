class_name BuildingComponent
extends Node2D

@export var _grid_manager: GridManager
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var build_radius: int

var _title: StringName 

func _ready():
	_title = self.name
	#_title = "BuildingComponent"
	print(_title)
	add_to_group(_title)

func _get_grid_pos() -> Vector2i:
	return _grid_manager._main_tml_.process_mouse_pos(self.global_position)
	
