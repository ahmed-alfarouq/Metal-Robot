extends Node2D


var gape_decreased: bool = false

@onready var pipe_spawner = get_parent()
@onready var main = get_node("/root/MainLevel")
@onready var animation = $AnimationPlayer
@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe
@onready var point_sound = $Point

# Called when the node enters the scene tree for the first time.
func _ready():
	# Play animation
	var animations = ["up_down", "down_up"]
	var animation_kind = animations[randi_range(0, 1)]
	animation.play(animation_kind)

	# Decide the pipe's gap
	top_pipe.position.y += pipe_spawner.pipe_gap_range
	bottom_pipe.position.y -= pipe_spawner.pipe_gap_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not main.is_dead):
		position.x -= pipe_spawner.pipe_speed * delta

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
