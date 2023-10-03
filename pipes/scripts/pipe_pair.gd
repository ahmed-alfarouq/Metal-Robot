extends Node2D


@onready var pipe_spawner = get_parent()
@onready var main = get_node("/root/MainLevel")
@onready var player
@onready var animation = $AnimationPlayer
@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe

# Called when the node enters the scene tree for the first time.
func _ready():
	# Check if player still in the tree
	if (get_node_or_null("/root/MainLevel/Player")):
		player = get_node("/root/MainLevel/Player")
	
	# Decide the pipe's gap
	top_pipe.position.y += pipe_spawner.pipe_gap_range
	bottom_pipe.position.y -= pipe_spawner.pipe_gap_range

	# Play pipes animation
	animation.play("up_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!main.is_dead):
		position.x -= pipe_spawner.pipe_speed * delta
		# Play pipes animation
		animation.play("up_down")

func _on_top_pipe_body_entered(body):
	if (body.name == "Player" && !main.is_shooting):
		player.player_dies()

func _on_bottom_pipe_body_entered(body):
	if (body.name == "Player" && !main.is_shooting):
		player.player_dies()

func _on_earn_point_body_entered(body):
	if (body.name == "Player"):
		$Point.play()
		main.score += 1

func _on_detect_remover_area_entered(area):
	if (area.name == "ItemsRemover"):
		queue_free()
