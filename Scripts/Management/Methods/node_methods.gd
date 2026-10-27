class_name NodeMethods
extends Node

signal _animate_building


static func get_first_node_of_type(node: Variant) -> Variant:
	
	var children
	var first_node
	
	if node is Node: children = node.get_children()
	if !children.is_empty(): first_node = children[0]
	
	return first_node


	
