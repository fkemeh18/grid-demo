class_name BuildingManager
extends Node

@export var _grid_manager: GridManager
@export var _game_ui: GameUI
@export var _y_sort_root: Node2D
@export var _building_ghost_scene: PackedScene

var _building_resource: BuildingResource
var _base_resource_count:= 4
var _curr_resource_count: int
var _used_resource_count: int

var _available_resource_count = func() -> int: 
	return _base_resource_count + _curr_resource_count - _used_resource_count

func _ready():
	_grid_manager._highlight_tml._resource_tiles_updated.connect(
		_on_resource_tiles_updated)
	_game_ui._pressed_button_type.connect(_change_building)

func _unhandled_input(event):
	if !is_instance_valid(_grid_manager._cursor_tml._ghost_cursor): return
	
	if (event.is_action_pressed("left_click") 
			&& _building_resource != null
			&& _grid_manager._cursor_tml._ghost_cursor.visible
			&& (_grid_manager._is_cell_currently_buildable(
				_grid_manager._temp_grid_pos))
			&& _available_resource_count.call() >= _building_resource.resource_cost):
		_place_building()

# passes updated mouse_pos to tile map class for tile
func _process(delta):
	if (_building_resource != null 
			&& (_game_ui._button_manager._active_button_checker())
			&& (_grid_manager._temp_grid_pos != null 
			|| _grid_manager._temp_grid_pos != 
			_grid_manager._get_mouse_grid_pos_without_update())):
		_grid_manager._highlight_tml._clear()
		_grid_manager._update_expanded_tiles(_grid_manager._temp_grid_pos, 
			_building_resource.buildable_radius)
		_grid_manager._update_resource_tiles(_grid_manager._temp_grid_pos, 
			_building_resource.resource_radius)

#deals with the placement of sprite "building"
func _place_building() -> void:
	var building: Node2D
	
	if _grid_manager._temp_grid_pos == null: return
	
	building = _building_resource.building_scene.instantiate() as Node2D
	_game_ui._button_manager._building_placed(
		_game_ui._button_manager._current_building_type)
	
	_y_sort_root.add_child(building)
	building.global_position = _grid_manager._temp_grid_pos * 64

	_grid_manager._highlight_tml._clear()
	_grid_manager._cursor_tml._toggle_visibility_off()
	
	_used_resource_count += _building_resource.resource_cost
	#print(_used_resource_count)
	#print(_available_resource_count.call())
	_grid_manager._cursor_tml._ghost_cursor.queue_free()

func _on_resource_tiles_updated(count: int):
	_curr_resource_count = count
	#print(_curr_resource_count)

func _change_building(resource: BuildingResource):
	if is_instance_valid(_grid_manager._cursor_tml._ghost_cursor): 
		_grid_manager._cursor_tml._ghost_cursor.queue_free()
	
	var building_ghost = _building_ghost_scene.instantiate() as Node2D
	_grid_manager._cursor_tml._ghost_cursor = building_ghost
	_grid_manager._cursor_tml.add_child(building_ghost)
	var building_ghost_sprite = resource.sprite_scene.instantiate() as Sprite2D
	_grid_manager._cursor_tml._cursor_sprite = building_ghost_sprite
	_grid_manager._cursor_tml._ghost_cursor.add_child(building_ghost_sprite)
	
	_building_resource = resource
	_game_ui._access_gm(_grid_manager)
