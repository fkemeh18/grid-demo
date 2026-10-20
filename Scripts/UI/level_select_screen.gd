class_name LevelSelectScreen
extends MarginContainer

signal _return_button_pressed

@export var _level_select_section_scene: PackedScene
@export var _grid_container: GridContainer
@export var _return_button: Button

func _ready():
	var level_resources = LevelManager.get_level_resource()
	
	for i in level_resources.size():
		var level_resource = level_resources[i]
		var level_select_section = (
				_level_select_section_scene.instantiate() as LevelSelectSection)
		_grid_container.add_child(level_select_section)
		level_select_section.set_level_resource_info(level_resource)
		level_select_section.set_level_label(i)
		level_select_section._level_selected.connect(_on_level_selected)
	
	_return_button.pressed.connect(_on_return_button_pressed)

func _on_level_selected(level_index) -> void:
	LevelManagerAutoloader._instance.change_to_level(level_index)

func _on_return_button_pressed() -> void:
	_return_button_pressed.emit()
