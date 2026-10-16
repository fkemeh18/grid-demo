class_name BaseLevelResource
extends Resource

@export_custom(PROPERTY_HINT_FILE, 
				"*.tscn") var level_scene_path: String
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var level_id: String
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_DEFAULT) var starting_resource_count: int = 2
