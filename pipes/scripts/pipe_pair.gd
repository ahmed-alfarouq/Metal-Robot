extends Node2D


@onready var pipeSpawner = get_parent()
@onready var main = get_node("/root/MainLevel")

# Called when the node enters the scene tree for the first time.
func _ready():
	$TopPipe.position.y += randf_range(60, 80)
	$BottomPipe.position.y -= randf_range(60, 80)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!main.isDead):
		position.x -= get_parent().pipeSpeed * delta

func _on_top_pipe_body_entered(body):
	if (body.name == "Player"):
		die(body)

func _on_bottom_pipe_body_entered(body):
	if (body.name == "Player"):
		die(body)

func _on_earn_point_body_entered(_body):
	main.score += 1

func _on_detect_area_entered(area):
	if (area.name == "PipeRemover"):
		queue_free()

func die(player):
	player.queue_free()
	pipeSpawner.stop()
	await get_tree().create_timer(0.55).timeout
	main.isDead = true
