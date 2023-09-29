extends Control

@onready var animation = $AnimationPlayer
@onready var transition_layer = $CanvasLayer/ColorRect

func change_scene(path: String):
	transition_layer.mouse_filter = MOUSE_FILTER_STOP
	animation.speed_scale = 1.0 / 0.2
	animation.play("disolve")
	await animation.animation_finished
	get_tree().change_scene_to_file(path)
	
	# re-enable mouse interaction before fading back in
	transition_layer.mouse_filter = MOUSE_FILTER_IGNORE
	
	animation.play_backwards("disolve")
