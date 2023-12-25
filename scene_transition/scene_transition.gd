extends Control

signal safe_to_load

@onready var layer = $CanvasLayer
@onready var animation = $CanvasLayer/AnimationPlayer

func _ready():
	animation.play("fade_in")
	await animation.animation_finished

func go_to_next_scene(callback_function: Callable):
	# Change Scene
	callback_function.call()

	# Animation Out
	animation.play("fade_out")
	await animation.animation_finished
