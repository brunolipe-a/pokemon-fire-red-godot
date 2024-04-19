extends PlayerState

const WALK_SPEED = 4 # Tiles per second
const TILE_SIZE := 16 # 16 x  16

var percent_moved_to_next_tile := 0.0

func enter(_msg := {}) -> void:
	player.animation_state_machine.travel("Walk")

func physics_update(delta: float) -> void:
	percent_moved_to_next_tile += WALK_SPEED * delta

	var next_tile := TILE_SIZE * player.direction

	# Verifica caso o "tempo" decorrido em frames está próximo/passou
	# da posição do tile map para onde está movendo o personagem.
	# Caso sim, move para a posição exata do next_tile.
	if percent_moved_to_next_tile < 0.99:
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
		player.position = player.current_grid_position + next_tile * percent_moved_to_next_tile
		return

	player.position = player.current_grid_position + next_tile
	state_machine.transition_to("Idle")

func exit() -> void:
	percent_moved_to_next_tile = 0.0
