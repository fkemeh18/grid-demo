class_name LevelSelectSection
extends PanelContainer

signal _level_selected(level_index: int)

@export var _level_label: Label
@export var _resource_label: Label
@export var _button: Button

var _level_index

func _ready():
	_button.pressed.connect(_on_button_pressed)

func set_level_resource_info(level_resource: BaseLevelResource) -> void:
	_resource_label.text = "%s" % level_resource.starting_resource_count

func set_level_label(index: int) -> void:
	_level_index = index
	_level_label.text = "level %s" %(index + 1)

func _on_button_pressed() -> void:
	_level_selected.emit(_level_index)
