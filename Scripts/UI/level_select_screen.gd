class_name LevelSelectScreen
extends MarginContainer

signal _return_button_pressed

const _PAGE_SIZE := 6

@export var _level_select_section_scene: PackedScene
@export var _grid_container: GridContainer
@export var _return_button: Button
@export var _prev_page_button: Button
@export var _next_page_button: Button

var _page_index: int
var _max_page_index: int
var _level_resources: Array[BaseLevelResource]

func _ready():
	AudioManagerAutoloader.register_buttons(ButtonMethods.register_buttons([
		_return_button, _prev_page_button, _next_page_button]))
	
	_level_resources = LevelManager.get_level_resource()
	_return_button.pressed.connect(_on_return_button_pressed)
	_prev_page_button.pressed.connect(_on_page_changed.bind(-1))
	_next_page_button.pressed.connect(_on_page_changed.bind(1))
	
	_max_page_index = _level_resources.size() / _PAGE_SIZE
	_show_page()

func _show_page() -> void:
	_update_button_visibility()
	
	for child in _grid_container.get_children():
		child.queue_free()
	
	var start_index = _PAGE_SIZE * _page_index
	var end_index = min(start_index + _PAGE_SIZE, _level_resources.size())
	
	for i in range(start_index, end_index):
		var level_resource = _level_resources[i]
		var level_select_section = (
				_level_select_section_scene.instantiate() as LevelSelectSection)
		_grid_container.add_child(level_select_section)
		level_select_section.set_level_resource_info(level_resource)
		level_select_section.set_level_label(i)
		level_select_section._level_selected.connect(_on_level_selected)

func _update_button_visibility() -> void:
	_prev_page_button.disabled = _page_index <= 0
	_prev_page_button.modulate = Color.TRANSPARENT if _page_index <= 0 else Color.WHITE
	_next_page_button.disabled = _page_index >= _max_page_index
	_next_page_button.modulate = Color.TRANSPARENT if _page_index >= _max_page_index else Color.WHITE

func _on_level_selected(level_index) -> void:
	LevelManagerAutoloader._instance.change_to_level(level_index)

func _on_return_button_pressed() -> void:
	_return_button_pressed.emit()

func _on_page_changed(change: int) -> void:
	_page_index += change
	_show_page()
