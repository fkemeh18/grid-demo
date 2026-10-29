class_name BuildingAnimatorComponent
extends Node2D

signal destroy_animation_finished

@export var _mask_texture: Texture2D
@export var _impact_particle_scene: PackedScene
@export var _destroy_particle_scene: PackedScene

var _active_tween: Tween
var _animation_root_node : Node2D
var _animation_height = 300
var _mask_node: Sprite2D

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
	_active_tween.tween_callback(func():
		var impact_particles = _impact_particle_scene.instantiate() as Node2D
		owner.get_parent().add_child(impact_particles)
		impact_particles.global_position = global_position
		)
	_active_tween.tween_property(
		_animation_root_node, "position", Vector2.UP * 16, 0.125
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_active_tween.tween_property(
		_animation_root_node, "position", Vector2.ZERO, 0.1
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func play_destruction_animation() -> void:
	if _animation_root_node == null: return
	if _active_tween != null && _active_tween.is_valid(): _active_tween.kill()
	
	_animation_root_node.position = Vector2.ZERO
	
	_mask_node.texture = _mask_texture
	_mask_node.clip_children = CanvasItem.CLIP_CHILDREN_ONLY
	
	var destroy_particle = _destroy_particle_scene.instantiate() as Node2D
	owner.get_parent().add_child(destroy_particle)
	destroy_particle.global_position = global_position
	
	_active_tween = create_tween()
	_active_tween.tween_property(
		_animation_root_node, "rotation_degrees", -5, 0.1)
	_active_tween.tween_property(
		_animation_root_node, "rotation_degrees", 5, 0.1)
	_active_tween.tween_property(
		_animation_root_node, "rotation_degrees", -2, 0.1)
	_active_tween.tween_property(
		_animation_root_node, "rotation_degrees", 2, 0.1)
	_active_tween.tween_property(
		_animation_root_node, "rotation_degrees", 0, 0.1)
		
	_active_tween.tween_property(
		_animation_root_node, "position", Vector2.DOWN * _animation_height, 0.4
		).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	_active_tween.finished.connect(func(): destroy_animation_finished.emit())

func _setup_nodes() -> void:
	#get sprite
	var sprite_node_list = get_children()
	if sprite_node_list.is_empty(): return
	var sprite_node = sprite_node_list[0] as Node2D
	
	#remove it from tree and alter this node's position
	remove_child(sprite_node)
	position = Vector2(sprite_node.position.x, sprite_node.position.y)
	
	#add mask node to this node
	_mask_node = _mask_node_generator()
	add_child(_mask_node)
	
	#add animation root node and sprite node to the mask node
	#also prepares the sprite node's position
	_animation_root_node = Node2D.new()
	_mask_node.add_child(_animation_root_node)
	_animation_root_node.add_child(sprite_node)
	sprite_node.position = Vector2(0, 0)

func _mask_node_generator() -> Sprite2D:
	var node = Sprite2D.new()
	node.centered = false
	node.offset = Vector2(-160, -256)
	return node
