extends Control

signal safe_to_load

@onready var anim_player = $AnimationPlayer

func fade_out():
	anim_player.play("fade_out")
	await anim_player.animation_finished
	queue_free()
