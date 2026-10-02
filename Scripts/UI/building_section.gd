class_name BuildingSection
extends PanelContainer

signal select_button_pressed

@export var title_label: Label
@export var cost_label: Label
@export var description_label: Label
@export var select_button: Button

func _ready():
	select_button.pressed.connect(_on_select_button_pressed)

func set_building_section(br: BuildingResource) -> void:
	title_label.text = br.display_name
	cost_label.text = "%s" % br.resource_cost
	description_label.text = br.description

func _on_select_button_pressed() -> void:
	select_button_pressed.emit()
