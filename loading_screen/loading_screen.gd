extends Control

signal safe_to_load

@onready var anim_player1 = $AnimationPlayer
@onready var anim_player2 = $AnimationPlayer2

func _ready():
	anim_player2.play("circle")
	await anim_player1.animation_finished
	anim_player1.play("text")

func go_to_next_scene(callback_function: Callable):
	anim_player1.get_animation("text").loop_mode = Animation.LOOP_NONE
	await anim_player1.animation_finished
	callback_function.call()
	anim_player1.play("fade_out")
	await anim_player1.animation_finished
	queue_free()
