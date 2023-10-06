extends Control

@onready var canvas_layer = $CanvasLayer
@onready var animation = $CanvasLayer/AnimationPlayer

func transition(current_scene, next_scene):
	# Enable visibilty
	canvas_layer.visible = true
	# Start loading scene in background
	ResourceLoader.load_threaded_request(next_scene)
	# Play animation
	animation.play("fade_in")
	await animation.animation_finished
	# Destroy current scene
	current_scene.queue_free()
	# Check status
	var status = ResourceLoader.load_threaded_get_status(next_scene, [])
	match status:
		0:
			print("Error: something went wrong!")
		3:
			var packed_scene = ResourceLoader.load_threaded_get(next_scene)
			get_tree().change_scene_to_packed(packed_scene)
			animation.play("fade_out")
	
	# Disable visibility. If it's enabled, the player won't be able to interact with other layers.
	canvas_layer.visible = false
