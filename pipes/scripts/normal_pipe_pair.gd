extends PipePair

func _ready():
	connect_area()
	play_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not main.is_dead && not stop_movement:
		position.x -= pipe_spawner.pipe_speed * delta
	elif main.is_dead:
		drop_pipes()
