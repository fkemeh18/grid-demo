class_name ButtonManager
extends Node

func _create_building_sections(game_ui: GameUI, gm: GridManager) -> void:
	for resource in game_ui._building_resources:
		var building_section = game_ui._building_section.instantiate() as BuildingSection
		game_ui.building_section_container.add_child(building_section)
		building_section.set_building_section(resource)
		#print(building_section.text)
		
		building_section.select_button_pressed.connect(
									_button_pressed.bind(resource, game_ui, gm))

func _button_pressed(button: BuildingResource,
						game_ui: GameUI, gm: GridManager) -> void:
	game_ui._pressed_button_type.emit(button)
	gm._cursor_tml._toggle_visibility_on()
	gm._update_highlight_tiles()
