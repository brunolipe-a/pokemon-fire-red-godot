class_name Player extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var animation_state_machine: AnimationNodeStateMachinePlayback

var current_grid_position := Vector2(0, 0) # Posição atual no "Grid", usada para saber de onde o player estava antes de começar a andar

var direction := Vector2.DOWN:
	set(value):
		direction = value
		set_animation_tree_direction(value)

func _ready() -> void:
	animation_tree.active = true
	animation_state_machine = animation_tree["parameters/playback"]

	set_animation_tree_direction(direction)

func set_animation_tree_direction(vector: Vector2) -> void:
	animation_tree.set("parameters/Idle/blend_position", vector)
	animation_tree.set("parameters/Walk/blend_position", vector)
	animation_tree.set("parameters/Turn/blend_position", vector)
