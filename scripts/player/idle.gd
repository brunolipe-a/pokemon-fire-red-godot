extends PlayerState

@onready var walk: State = %Walk
@onready var turn: State = %Turn

func physics_update(_delta: float) -> void:
	_capture_move_input()

func _capture_move_input() -> void:
	var new_player_direction = Vector2.ZERO

	new_player_direction.y = Input.get_axis("move_up", "move_down")

	if new_player_direction.y == 0:
		new_player_direction.x = Input.get_axis("move_left", "move_right")

	# Caso não haja input, seta animação como Idle
	# e não atualiza a direção do olhar do personagem
	if new_player_direction == Vector2.ZERO:
		return _set_idle_animation()

	var is_facing_other_direction = player.direction != new_player_direction

	player.direction = new_player_direction

	if is_facing_other_direction:
		return state_machine.transition_to(turn)

	state_machine.transition_to(walk)

func _set_idle_animation() -> void:
	var anim_name := player.animation_state_machine.get_current_node()

	if anim_name != "Idle":
		player.animation_state_machine.travel("Idle")

func exit() -> void:
	player.current_grid_position = player.position
