class_name BuildingManager
extends Node

signal available_resource_count_changed(available_resource_count: int)

const ACTION_LEFT_CLICK: StringName = "left_click"
const ACTION_CANCEL: StringName = "cancel"
const ACTION_RIGHT_CLICK: StringName = "right_click"

@export var _grid_manager: GridManager
@export var _state_manager: StateManager
@export var _game_ui: GameUI
@export var _y_sort_root: Node2D
@export var _building_ghost_scene: PackedScene

var _building_resource: BuildingResource
var _base_resource_count: int
var _curr_resource_count: int
var _used_resource_count: int
var _curr_state: GameEventsAutoloader.State

var _available_resource_count = func() -> int: 
	return _base_resource_count + _curr_resource_count - _used_resource_count

func _ready():
	_grid_manager._highlight_tml._resource_tiles_updated.connect(
		_on_resource_tiles_updated)
	_game_ui._pressed_button_type.connect(_change_building)

func _unhandled_input(event):
	match(_curr_state):
		GameEventsAutoloader.State.Base:
			if event.is_action_pressed(ACTION_RIGHT_CLICK):
				_destroy_building()
		GameEventsAutoloader.State.PlacingBuilding:
			if (event.is_action_pressed(ACTION_CANCEL)):
				_state_manager._change_state(GameEventsAutoloader.State.Base, self)
			elif (event.is_action_pressed(ACTION_LEFT_CLICK) 
					&& _building_resource != null
					&& _grid_manager._cursor_tml._ghost_cursor.visible
					&& _is_building_placable(_grid_manager._hovered_rect_pos)):
				_place_building()
		_:
			pass

# passes updated mouse_pos to tile map class for tile
func _process(delta):
	var mouse_pos
	
	match _curr_state:
		GameEventsAutoloader.State.Base:
			mouse_pos = _grid_manager._get_mouse_grid_pos_without_update()
		GameEventsAutoloader.State.PlacingBuilding:
			mouse_pos = _grid_manager.get_mouse_grid_pos_with_dimension_offset(
									_grid_manager._cursor_tml.ghost_dimensions)
			_grid_manager._cursor_tml.set_tile(
											Rect2i(mouse_pos, Vector2i()))
	
	var root_cell = _grid_manager._hovered_rect_pos.position
	
	if (root_cell != mouse_pos):
		_grid_manager._hovered_rect_pos.position = mouse_pos
		_update_grid_pos()

func set_starting_resource_count(count: int) -> void:
	_base_resource_count = count

func _emit_available_resource_count_changed() -> void:
	available_resource_count_changed.emit(_available_resource_count.call())

func _update_grid_pos() -> void:
	match _curr_state:
		GameEventsAutoloader.State.Base:
			pass
		GameEventsAutoloader.State.PlacingBuilding:
			_update_grid_display()

func _update_grid_display() -> void:
	_grid_manager._update_grid()
	
	if _is_building_placable(_grid_manager._hovered_rect_pos):
		_grid_manager._update_expanded_tiles(_grid_manager._hovered_rect_pos, 
			_building_resource.buildable_radius)
		_grid_manager._update_resource_tiles(_grid_manager._hovered_rect_pos, 
			_building_resource.resource_radius)
		_grid_manager._cursor_tml._ghost_cursor._set_valid()
	else: _grid_manager._cursor_tml._ghost_cursor._set_invalid()
	
	_grid_manager._cursor_tml._ghost_cursor.play_hover_animation()

func _is_building_placable(pos: Rect2i) -> bool:
	
	var all_tiles_buildable = _grid_manager._is_area_currently_buildable(pos)
	
	return all_tiles_buildable && (_available_resource_count.call() 
			>= _building_resource.resource_cost)

#deals with the placement of sprite "building"
func _place_building() -> void:
	var building = _building_resource.building_scene.instantiate() as Node2D
	_y_sort_root.add_child(building)
	building.global_position = _grid_manager._hovered_rect_pos.position * 64
	
	_used_resource_count += _building_resource.resource_cost
	_state_manager._change_state(GameEventsAutoloader.State.Base, self)
	available_resource_count_changed.emit(_available_resource_count.call())

func _cancel_building() -> void:
	_grid_manager._highlight_tml._clear()
	
	if is_instance_valid(_grid_manager._cursor_tml._ghost_cursor):
		_grid_manager._cursor_tml._ghost_cursor.queue_free()

func _destroy_building() -> void:
	var root_cell = _grid_manager._hovered_rect_pos.position
	
	var temp_buildings = get_tree().get_nodes_in_group(
					GameEventsAutoloader.BUILDING_COMPONENT)
	var buildings: Array[BuildingComponent]
	
	buildings.assign(temp_buildings)
	
	var target_building
	var target_building_array = buildings.filter(func(building): 
		return (building.building_resource.is_deletable
				&& building.is_tile_in_built_area(root_cell)))
	
	if !target_building_array.is_empty():
		target_building = target_building_array.front()
	else: return
	
	_used_resource_count -= target_building.building_resource.resource_cost
	
	if target_building.building_resource.display_name != "Base":
		target_building._self_destruct()
		available_resource_count_changed.emit(_available_resource_count.call())

func _on_resource_tiles_updated(count: int):
	_curr_resource_count = count
	available_resource_count_changed.emit(_available_resource_count.call())

func _change_building(resource: BuildingResource):
	_state_manager._change_state(GameEventsAutoloader.State.PlacingBuilding, self)
	_grid_manager._hovered_rect_pos.size = resource.dimensions
	
	var building_ghost_sprite = resource.sprite_scene.instantiate() as Sprite2D
	_grid_manager._cursor_tml._cursor_sprite = building_ghost_sprite
	_grid_manager._cursor_tml._ghost_cursor.add_sprite_node(
														building_ghost_sprite)
	_grid_manager._cursor_tml._ghost_cursor.set_dimensions(resource.dimensions)
	_grid_manager._cursor_tml.ghost_dimensions = resource.dimensions
	
	_building_resource = resource
	_update_grid_display()
