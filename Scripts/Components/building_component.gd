class_name BuildingComponent
extends Node2D

@export_custom(PROPERTY_HINT_FILE, 
				"*.tres") var _building_resource_path: String
@export_custom(PROPERTY_HINT_NONE,"", 
				PROPERTY_USAGE_CHECKED) var building_resource: BuildingResource
@export var _animator_component: BuildingAnimatorComponent

var _occupied_tiles: Dictionary[Vector2i, bool]
var bc_name: StringName
var _is_being_destroyed_currently: bool

func _ready():
	if _building_resource_path != null:
		building_resource = load(_building_resource_path) as BuildingResource
	
	if _animator_component != null:
		_animator_component.destroy_animation_finished.connect(
			_on_destroy_animation_finished)
	
	bc_name = self.name
	add_to_group(bc_name)
	var emit := func(): GameEvents.emit_on_building_placed(self)
	emit.call_deferred()

static func get_valid_building_components(node: Node
									) -> Array[BuildingComponent]:
	var bc_dict: Dictionary[BuildingComponent, bool]
	var bc_array: Array[BuildingComponent]
	var building_components = node.get_tree().get_nodes_in_group(
		GameEventsAutoloader.BUILDING_COMPONENT)
	bc_array.assign(building_components)
	
	var building_comps = bc_array.filter(func(building_comp):
		return !building_comp._is_being_destroyed_currently)
	return building_comps

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

func _on_destroy_animation_finished() -> void:
	owner.queue_free()

func _self_destruct() -> void:
	_is_being_destroyed_currently = true
	GameEvents.emit_on_building_destroyed(self)
	
	if _animator_component != null:
		_animator_component.play_destruction_animation()
	
	if _animator_component == null:
		owner.queue_free()
