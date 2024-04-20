extends PlayerState

@onready var idle: State = %Idle

var door: Door
var percent_moved_to_next_tile := 0.0

func enter(_msg := {}) -> void:
	player.animation_state_machine.travel("Walk_")
	door = player.door_ray_cast.get_collider() as Door

	player.set_walk_animation_time_scale(0.25 * door.player_speed)

func physics_update(delta: float) -> void:
	percent_moved_to_next_tile += door.player_speed * delta

	var direction := door.moving_direction if door.moving_direction else player.direction

	var next_tile := 16 * direction

	if percent_moved_to_next_tile < 0.99:
		player.position = player.current_grid_position + next_tile * percent_moved_to_next_tile
		return

	player.position = player.current_grid_position + next_tile

	state_machine.transition_to(idle)

func exit() -> void:
	percent_moved_to_next_tile = 0.0



