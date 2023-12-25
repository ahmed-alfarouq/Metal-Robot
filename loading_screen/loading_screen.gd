extends Control

signal safe_to_load

@onready var transition_and_text_anim = $TransitionTextAnimation
@onready var circle_anim = $CircleAnimation

func _ready():
	circle_anim.play("circle")
	await transition_and_text_anim.animation_finished
	transition_and_text_anim.play("text")

func go_to_next_scene(callback_function: Callable):
	transition_and_text_anim.get_animation("text").loop_mode = Animation.LOOP_NONE
	await transition_and_text_anim.animation_finished

	# Change scene
	callback_function.call()

	# Animation Out
	transition_and_text_anim.play("fade_out")
	await transition_and_text_anim.animation_finished
	queue_free()
