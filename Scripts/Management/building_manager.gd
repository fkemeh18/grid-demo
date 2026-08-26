class_name BuildingManager
extends Node

const ACTION_LEFT_CLICK: StringName = "left_click"
const ACTION_CANCEL: StringName = "cancel"
const ACTION_RIGHT_CLICK: StringName = "right_click"

@export var _grid_manager: GridManager
@export var _state_manager: StateManager
@export var _game_ui: GameUI
@export var _y_sort_root: Node2D
@export var _building_ghost_scene: PackedScene
@export var _base_resource_count: int

var _building_resource: BuildingResource
var _curr_resource_count: int
var _used_resource_count: int
var _curr_state: GameEvents.State

var _available_resource_count = func() -> int: 
	return _base_resource_count + _curr_resource_count - _used_resource_count

func _ready():
	_grid_manager._highlight_tml._resource_tiles_updated.connect(
		_on_resource_tiles_updated)
	_game_ui._pressed_button_type.connect(_change_building)

func _unhandled_input(event):
	match(_curr_state):
		GameEvents.State.Base:
			if event.is_action_pressed(ACTION_RIGHT_CLICK):
				_destroy_building()
		GameEvents.State.PlacingBuilding:
			if (event.is_action_pressed(ACTION_CANCEL)):
				_state_manager._change_state(GameEvents.State.Base, self)
			elif (event.is_action_pressed(ACTION_LEFT_CLICK) 
					&& _building_resource != null
					&& _grid_manager._cursor_tml._ghost_cursor.visible
					&& _is_building_placable(_grid_manager._temp_grid_pos)):
				_place_building()
		_:
			pass

# passes updated mouse_pos to tile map class for tile
func _process(delta):
	if (_grid_manager._temp_grid_pos != 
				_grid_manager._get_mouse_grid_pos_without_update()):
		_grid_manager._get_mouse_grid_pos()
		_update_grid_pos()

func _update_grid_pos() -> void:
	match _curr_state:
		GameEvents.State.Base:
			pass
		GameEvents.State.PlacingBuilding:
			_update_grid_display()

func _update_grid_display() -> void:
	_grid_manager._update_grid()
	
	if _is_building_placable(_grid_manager._temp_grid_pos):
		_grid_manager._update_expanded_tiles(_grid_manager._temp_grid_pos, 
			_building_resource.buildable_radius)
		_grid_manager._update_resource_tiles(_grid_manager._temp_grid_pos, 
			_building_resource.resource_radius)
		_grid_manager._cursor_tml._ghost_cursor._set_valid()
	else: _grid_manager._cursor_tml._ghost_cursor._set_invalid()

func _is_building_placable(pos: Vector2i) -> bool:
	return (_grid_manager._is_cell_currently_buildable(pos)
			&& (_available_resource_count.call() 
			>= _building_resource.resource_cost))

#deals with the placement of sprite "building"
func _place_building() -> void:
	var building = _building_resource.building_scene.instantiate() as Node2D
	_y_sort_root.add_child(building)
	building.global_position = _grid_manager._temp_grid_pos * 64
	
	_used_resource_count += _building_resource.resource_cost
	_state_manager._change_state(GameEvents.State.Base, self)

func _cancel_building() -> void:
	_grid_manager._highlight_tml._clear()
	
	if is_instance_valid(_grid_manager._cursor_tml._ghost_cursor):
		_grid_manager._cursor_tml._ghost_cursor.queue_free()

func _destroy_building() -> void:
	var buildings = (get_tree().get_nodes_in_group(
					GameEvents.BUILDING_COMPONENT) as Array[BuildingComponent])
	var target_building = buildings.filter(func(building): 
		return (building._get_grid_pos(_grid_manager._cursor_tml) 
		== _grid_manager._temp_grid_pos)).front()
	
	if target_building == null: return
	
	_used_resource_count -= target_building.building_resource.resource_cost
	
	target_building._self_destruct()
	print(_available_resource_count.call())

func _on_resource_tiles_updated(count: int):
	_curr_resource_count = count

func _change_building(resource: BuildingResource):
	_state_manager._change_state(GameEvents.State.PlacingBuilding, self)
	var building_ghost_sprite = resource.sprite_scene.instantiate() as Sprite2D
	_grid_manager._cursor_tml._cursor_sprite = building_ghost_sprite
	_grid_manager._cursor_tml._ghost_cursor.add_child(building_ghost_sprite)
	
	_building_resource = resource
	_game_ui._access_gm(_grid_manager)
	_update_grid_display()
