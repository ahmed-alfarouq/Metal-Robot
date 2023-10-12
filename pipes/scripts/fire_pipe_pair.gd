extends PipePair

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_area()
	play_animation()

	# Remove on of the pipes
	var choices = ["top", "bottom"]

	if (choices.pick_random() == "top"):
		remove_pipe("top")
		return
	
	remove_pipe("bottom")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not main.is_dead && not stop_movement):
		position.x -= pipe_spawner.pipe_speed * delta
	elif (main.is_dead):
		drop_pipes()

"""
	Reminder I do this because there's a bug with animator player
	when I try to remove a track, it removes it from future pipes too
"""
func remove_pipe(pipe: String):
	var top_collision = top_pipe.get_node("PipeCollision")
	var top_fire = top_pipe.get_node("Fire")
	var bottom_collision = bottom_pipe.get_node("PipeCollision")
	var bottom_fire = bottom_pipe.get_node("Fire")
	
	if (pipe == "top"):
		top_pipe.visible = false
		top_collision.queue_free()
		top_fire.queue_free()
		return

	bottom_pipe.visible = false
	bottom_collision.queue_free()
	bottom_fire.queue_free()

# Signals
func _on_fire_area_body_entered(body):
	if (body.name == "Player"):
		body.player_dies()
