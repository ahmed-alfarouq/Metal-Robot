extends Node2D


@onready var pipeSpawner = get_parent()
@onready var main = get_node("/root/MainLevel")
@onready var player = get_node("/root/MainLevel/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	$TopPipe.position.y += pipeSpawner.pipeGapRange
	$BottomPipe.position.y -= pipeSpawner.pipeGapRange


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!main.isDead):
		position.x -= pipeSpawner.pipeSpeed * delta

func _on_top_pipe_body_entered(body):
	if (body.name == "Player"):
		player.playerDies()

func _on_bottom_pipe_body_entered(body):
	if (body.name == "Player"):
		player.playerDies()

func _on_earn_point_body_entered(body):
	if (body.name == "Player"):
		$Point.play()
		main.score += 1

func _on_detect_remover_area_entered(area):
	if (area.name == "ItemsRemover"):
		queue_free()

func _on_top_pipe_area_entered(area):
	if (area.name == "ShootsDetecter" && main.isShooting):
		$TopPipe.rotation -= deg_to_rad(70)
		$TopPipe.position.y -= 200

func _on_bottom_pipe_area_entered(area):
	if (area.name == "ShootsDetecter" && main.isShooting):
		$BottomPipe.rotation += deg_to_rad(70)
		$BottomPipe.position.y += 200
