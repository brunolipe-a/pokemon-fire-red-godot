extends PlayerState

@onready var idle: State = %Idle
@onready var pass_door: State = %PassDoor

func enter(_msg := {}) -> void:
	player.animation_state_machine.travel("Turn")

func on_animation_finished(anim_name: String) -> void:
	if anim_name.contains("turn_"):
		if player.should_go_to_door():
			return state_machine.transition_to(pass_door)
		state_machine.transition_to(idle)

