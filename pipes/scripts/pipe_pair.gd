extends Node2D


@onready var pipe_spawner = get_parent()
@onready var main = get_node("/root/MainLevel")
@onready var animation = $AnimationPlayer
@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe
@onready var point_sound = $Point

var gape_decreased: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Decide the pipe's gap
	top_pipe.position.y += pipe_spawner.pipe_gap_range
	bottom_pipe.position.y -= pipe_spawner.pipe_gap_range

	# Play pipes animation
	animation.play("up_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not main.is_dead):
		position.x -= pipe_spawner.pipe_speed * delta
	decrease_gap(150, 10)

func decrease_gap(gap: int, score_limit: int):
	# Decrease pipes gap when player gets 30 score
	if (main.score >= score_limit && not gape_decreased):
		pipe_spawner.pipe_gap_range = gap
		gape_decreased = true

func _on_top_pipe_body_entered(body):
	if (body.name == "Player" && not main.is_shooting):
		body.player_dies()
		animation.pause()

func _on_bottom_pipe_body_entered(body):
	if (body.name == "Player" && not main.is_shooting):
		body.player_dies()
		animation.pause()

func _on_earn_point_body_entered(body):
	if (body.name == "Player"):
		point_sound.play()
		main.score += 1
