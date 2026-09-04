class_name BuildingResource
extends Resource

@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var display_name: String
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var dimensions:= Vector2i.ONE
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var buildable_radius: int
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var resource_radius: int
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var resource_cost: int
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var is_deletable: bool = true
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var building_scene: PackedScene
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var sprite_scene: PackedScene
