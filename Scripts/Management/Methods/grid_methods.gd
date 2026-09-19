class_name GridMethods
extends Node

#
# GRID MANAGER METHODS
#
static func to_tiles(rect: Rect2i) -> Dictionary[Vector2i, bool]:
	var tiles: Dictionary[Vector2i, bool]
	
#	finds checkable tiles
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			tiles[Vector2i(x, y)] = true
	
	return tiles

static func get_first_tml(tile_list: Array[Vector2i],
							gm: GridManager) -> TileMapLayer:
#	checks for the layer of the first checkable tile 
	var first_tml_dict = gm._get_tile_custom_data(tile_list[0],
												gm._highlight_tml.IS_BUILDABLE)
	return first_tml_dict.keys().front()

static func get_is_area_valid(gm: GridManager,
							tile_list: Array[Vector2i],
							target_elevation_layer: ElevationLayer) -> bool:
	var is_area_valid = tile_list.all(func(tile_pos): 
#		checks the tilemaplayer of each tile
		var valid_dict = gm._get_tile_custom_data(tile_pos,
												gm._highlight_tml.IS_BUILDABLE)
		var valid_tml = valid_dict.keys().front()
		
#		finds the associated elevation layer of that tilemaplayer
		var elevation_layer = gm._tile_map_elevations[valid_tml]
		
#		passes for the tile if builidable is true for it on that layer,
		return (valid_dict[valid_tml]
#		if the tile is valid for building at that location,
				&& gm._highlight_tml._valid_buildable_tiles.has(tile_pos)
#		and if the elevation level is the same as the target elevation
				&& elevation_layer == target_elevation_layer))
	
	return is_area_valid

static func refresh_grids(gm: GridManager) -> void:
	gm._highlight_tml._built_tile_locations.clear()
	gm._highlight_tml._valid_buildable_tiles.clear()
	gm._highlight_tml._collected_resource_tiles.clear()

static func get_other_building_components(bc: BuildingComponent,
							building_nodes: Array) -> Array[BuildingComponent]:
	var buildings: Array[BuildingComponent]
	buildings.assign(building_nodes)
	
	return buildings.filter(func(building): return building != bc)

static func update_tiles_for_other_bcs(buildings: Array[BuildingComponent], 
										gm: GridManager) -> void:
	for building in buildings:
		gm._highlight_tml._update_valid_buildable_tiles(building, gm)
		gm._highlight_tml._update_collected_resource_tiles(building, gm)

static func emit_tile_updates(gm: GridManager) -> void:
	gm._highlight_tml._resource_tiles_updated.emit(
					gm._highlight_tml._collected_resource_tiles.size())
	gm._highlight_tml._grid_updated.emit()

static func get_layer_list(curr_layer: Node2D,
				gm: GridManager) -> Dictionary[TileMapLayer, bool]:
	var layer_list: Dictionary[TileMapLayer, bool]
	var children = curr_layer.get_children()
	children.reverse()
	
	for child_layer in children:
		if child_layer is Node2D:
			var child_node: Node2D = child_layer
			layer_list.merge(gm._get_all_tile_map_layers(child_node))
	
	if curr_layer is TileMapLayer:
		var layer: TileMapLayer = curr_layer
		layer_list[layer] = true
	
	return layer_list

#
# HIGHLIGHT TML METHODS
#
static func get_tiles_in_radius(pos: Rect2i, radius: int,
		filter_func: Callable) -> Dictionary[Vector2i, bool]:
	var tiles: Dictionary[Vector2i, bool]
	var rect_2F = Rect2(pos.position, pos.size)
	var tile_area_center = rect_2F.get_center()
	var radius_mod = max(rect_2F.size.x, rect_2F.size.y) / 2
	
	for i in range(pos.position.x - radius, pos.end.x + (radius + 1)):
		for j in range(pos.position.y - radius, pos.end.y + (radius + 1)):
			var tile_pos = Vector2i(i, j)
			var custom_data = filter_func.call(Rect2i(tile_pos, pos.size))
			var data_key = custom_data.keys()
			if data_key.size() != 0:
				if ((!is_tile_inside_circle(tile_area_center, tile_pos, radius + radius_mod )) || !(custom_data.get(data_key[0]))): continue
				tiles[tile_pos] = true
	
	return tiles

static func is_tile_inside_circle(center_pos: Vector2, tile_pos: Vector2,
							radius: float) -> bool:
	var distance_x = center_pos.x - (tile_pos.x + .5)
	var distance_y = center_pos.y - (tile_pos.y + .5)
	var distance_squared = (distance_x * distance_x) + (distance_y * distance_y)
	return distance_squared <= radius * radius
