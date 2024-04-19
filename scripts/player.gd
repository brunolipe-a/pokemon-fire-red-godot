extends CharacterBody2D

const TILE_SIZE := 16 # 16 x  16

enum PlayerState { IDLE, WALKING, TURNING }

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var move_speed := 4 # Velocidade de movimentação em "tiles" por segundo.

var animation_state_machine: AnimationNodeStateMachinePlayback
var current_grid_position := Vector2(0, 0) # Posição atual no "Grid", usada para saber de onde o player estava antes de começar a andar
var player_state := PlayerState.IDLE

var player_direction := Vector2.DOWN:
	set(value):
		player_direction = value
		set_animation_tree_direction(value)

var player_velocity := Vector2.ZERO # Aceleração do player

var is_moving := false
var percent_moved_to_next_tile := 0.0

func _ready() -> void:
	animation_tree.active = true
	animation_state_machine = animation_tree["parameters/playback"]

	animation_tree.animation_player_changed

	#animation_player.animation_finished.connect(on_animation_finished);
	set_animation_tree_direction(Vector2.DOWN)

func _physics_process(delta: float) -> void:
	if player_state == PlayerState.TURNING:
		return

	handle_input()
	move_player(delta)

func handle_input() -> void:
	if not is_moving:
		handle_movement_input()

func handle_movement_input() -> void:
	if player_velocity.x == 0:
		player_velocity.y = Input.get_axis("move_up", "move_down")

	if player_velocity.y == 0:
		player_velocity.x = Input.get_axis("move_left", "move_right")

	if player_velocity != Vector2.ZERO:
		if need_turn():
			player_state = PlayerState.TURNING
			animation_state_machine.travel("Turn")
		else:
			is_moving = true;
			current_grid_position = position

func move_player(delta: float) -> void:
	if player_velocity == Vector2.ZERO:
		animation_state_machine.travel("Idle")
		return

	if player_state == PlayerState.TURNING:
		return

	animation_state_machine.travel("Walk")
	percent_moved_to_next_tile += move_speed * delta

	if percent_moved_to_next_tile >= 0.99:
		position = current_grid_position + TILE_SIZE * player_velocity
		percent_moved_to_next_tile = 0.0
		is_moving = false
	else:
		position = current_grid_position + TILE_SIZE * player_velocity * percent_moved_to_next_tile

func need_turn() -> bool:
	var old_player_direction = player_direction
	player_direction = player_velocity

	return old_player_direction != player_direction

func on_animation_finished(anim_name: String) -> void:
	if anim_name.contains("turn_"):
		player_state = PlayerState.IDLE

func set_animation_tree_direction(vector: Vector2) -> void:
	animation_tree.set("parameters/Idle/blend_position", vector)
	animation_tree.set("parameters/Walk/blend_position", vector)
	animation_tree.set("parameters/Turn/blend_position", vector)
