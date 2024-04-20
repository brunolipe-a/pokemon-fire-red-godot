class_name Player extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_ray_cast: RayCast2D = $CollisionRayCast
@onready var door_ray_cast: RayCast2D = $DoorRayCast

var animation_state_machine: AnimationNodeStateMachinePlayback

var current_grid_position := Vector2(0, 0) # Posição atual no "Grid", usada para saber de onde o player estava antes de começar a andar
var input_enabled := true

var direction := Vector2.DOWN:
	set = _set_direction

func _set_direction(value: Vector2) -> void:
	direction = value
	collision_ray_cast.target_position = value * 8
	door_ray_cast.target_position = value * 8
	set_animation_tree_direction(value)

func _ready() -> void:
	animation_tree.active = true
	animation_state_machine = animation_tree["parameters/playback"]

	set_animation_tree_direction(direction)

func enable() -> void:
	input_enabled = true
	visible = true

func disable() -> void:
	input_enabled = false

func should_go_to_door() -> bool:
	door_ray_cast.force_raycast_update()

	return door_ray_cast.is_colliding()

func set_walk_animation_time_scale(speed: float) -> void:
	animation_tree.set("parameters/Walk_/TimeScale/scale", speed)

func set_animation_tree_direction(vector: Vector2) -> void:
	animation_tree.set("parameters/Idle/blend_position", vector)
	animation_tree.set("parameters/Walk_/BlendSpace2D/blend_position", vector)
	animation_tree.set("parameters/Turn/blend_position", vector)
