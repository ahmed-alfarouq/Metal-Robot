extends ParallaxBackground

@onready var main = get_node("/root/MainLevel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_instance_valid(main) && not main.is_dead):
		scroll_offset.x -= 200 * delta
