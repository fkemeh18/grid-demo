class_name NodeMethods
extends Node

signal _animate_building

static func get_first_node_of_type(node: Node, type: Variant) -> Variant:
	var children = node.get_children()
	
	var first_node = children.filter(func(child): return is_instance_of(child, type)
		).front()
	return first_node
