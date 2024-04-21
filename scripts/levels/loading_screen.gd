class_name LoadingScreen extends Node2D

signal transition_in_complete

@onready var anim_player: AnimationPlayer = %AnimationPlayer

var starting_animation_name: String

func start_transition(animation_name: String) -> void:
	if !anim_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"

	starting_animation_name = animation_name

	anim_player.play(animation_name)
	await anim_player.animation_finished


func finish_transition() -> void:
	var ending_animation_name: String = starting_animation_name.replace("to", "from")

	if !anim_player.has_animation(ending_animation_name):
		push_warning("'%s' animation does not exist" % ending_animation_name)
		ending_animation_name = "fade_from_black"

	anim_player.play(ending_animation_name)
	await anim_player.animation_finished

	queue_free()
