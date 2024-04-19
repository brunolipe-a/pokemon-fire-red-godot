extends PlayerState

func physics_update(_delta: float) -> void:
	_capture_move_input()

func _capture_move_input() -> void:
	var player_direction = Vector2.ZERO

	player_direction.y = Input.get_axis("move_up", "move_down")

	if player_direction.y == 0:
		player_direction.x = Input.get_axis("move_left", "move_right")

	# Caso não haja input, seta animação como Idle
	# e não atualiza a direção do olhar do personagem
	if player_direction == Vector2.ZERO:
		return _set_idle_animation()

	var old_direction = player.direction

	player.direction = player_direction

	var is_facing_other_direction = old_direction != player_direction

	if is_facing_other_direction:
		return state_machine.transition_to("Turn")

	state_machine.transition_to("Walk")

func _set_idle_animation() -> void:
	var anim_name := player.animation_state_machine.get_current_node()

	if anim_name != "Idle":
		player.animation_state_machine.travel("Idle")

func exit() -> void:
	player.current_grid_position = player.position
