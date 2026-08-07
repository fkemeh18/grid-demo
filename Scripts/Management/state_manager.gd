class_name StateManager
extends Node

@export var _gm: GridManager

func _change_state(new_state: GameEvents.State,
					 bm: BuildingManager) -> void:
	match bm._curr_state:
		GameEvents.State.Base:
			pass
		GameEvents.State.PlacingBuilding:
			bm._cancel_building()
			bm._building_resource = null
	
	bm._curr_state = new_state
	_gm._curr_state = new_state
	
	match bm._curr_state:
		GameEvents.State.Base:
			pass
		GameEvents.State.PlacingBuilding:
			var building_ghost = (bm._building_ghost_scene.instantiate()
									as BuildingGhost)
			bm._grid_manager._cursor_tml._ghost_cursor = building_ghost
			bm._grid_manager._cursor_tml.add_child(building_ghost)
