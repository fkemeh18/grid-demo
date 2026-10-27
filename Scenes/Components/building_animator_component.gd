class_name BuildingAnimatorComponent
extends Node2D

var _active_tween: Tween
var _animation_root_node : Node2D

func _ready():
	_setup_nodes()
	

func play_in_animation() -> void:
	if _animation_root_node == null: return
	if _active_tween != null && _active_tween.is_valid(): _active_tween.kill()
	
	_active_tween = create_tween()
	_active_tween.tween_property(
		_animation_root_node, "position", Vector2.ZERO, 0.275
		).from(Vector2.UP * 128).set_trans(Tween.TRANS_QUAD
		).set_ease(Tween.EASE_IN)
	_active_tween.tween_property(
		_animation_root_node, "position", Vector2.UP * 16, 0.125
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_active_tween.tween_property(
		_animation_root_node, "position", Vector2.ZERO, 0.1
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _setup_nodes() -> void:
	#get sprite
	var sprite_node_list = get_children()
	if sprite_node_list.is_empty(): return
	var sprite_node = sprite_node_list[0] as Node2D
	
	#remove it from tree and alter this node's position
	remove_child(sprite_node)
	position = Vector2(position.x, sprite_node.position.y)
	
	#add animation root node and sprite node to this node as child & grandchild
	#also prepares the sprite node's position
	_animation_root_node = Node2D.new()
	add_child(_animation_root_node)
	_animation_root_node.add_child(sprite_node)
	sprite_node.position = Vector2(sprite_node.position.x, 0)
