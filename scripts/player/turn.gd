extends PlayerState

func enter(_msg := {}) -> void:
	player.animation_state_machine.travel("Turn")

func on_animation_finished(anim_name: String) -> void:
	if anim_name.contains("turn_"):
		state_machine.transition_to("Idle")

