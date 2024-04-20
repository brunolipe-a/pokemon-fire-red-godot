# Verifica caso o "tempo" decorrido em frames está próximo/passou
# da posição do tile map para onde está movendo o personagem.
# Caso sim, move para a posição exata do next_tile.

# Geralmente na movimantação normal de personagem se utiliza:
# position += velocity * delta
#
# Isso faz com que a posição seja a posição anterior do último frame mais um acrecimo da aceleração a depender do delta.
# Porém na movimentação em grid, não podemos utilizar a posição anterior do frame,
# pois a posição final a ser alcançada é a mesma.
#
# Por isso utilizamos a última posição antes de movermos como referencia.
# Já a nossa aceleração (player_velocity) depende do tamanho do TILE_SIZE, pois só podemos andar dentro da grid.
# E como o delta varia com o tempo, calculamos o quando vamos andar proporcionalmente da próxima posição nesse frame.
extends PlayerState


const WALK_SPEED = 4 # Tiles per second
const TILE_SIZE := 16.0 # 16 x  16

@onready var idle: State = %Idle
@onready var pass_door: State = %PassDoor

var percent_moved_to_next_tile := 0.0

func enter(_msg := {}) -> void:
	player.animation_state_machine.travel("Walk_")

func physics_update(delta: float) -> void:
	var is_colliding := _verify_colision()

	if is_colliding:
		player.set_walk_animation_time_scale(0.33)
		state_machine.transition_to(idle)
		return

	player.set_walk_animation_time_scale(1)
	percent_moved_to_next_tile += WALK_SPEED * delta

	var next_tile := TILE_SIZE * player.direction

	if percent_moved_to_next_tile < 0.99:
		if player.should_go_to_door():
			return state_machine.transition_to(pass_door)
		player.position = player.current_grid_position + next_tile * percent_moved_to_next_tile
		return

	player.position = player.current_grid_position + next_tile

	state_machine.transition_to(idle)

func _verify_colision() -> bool:
	player.collision_ray_cast.force_raycast_update()

	return player.collision_ray_cast.is_colliding()

func exit() -> void:
	percent_moved_to_next_tile = 0.0
