extends Node2D


var gape_decreased: bool = false
var animation_kind

@onready var pipe_spawner = get_parent()
@onready var main = get_node("/root/MainLevel")
@onready var animation = $AnimationPlayer
@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe
@onready var point_sound = $Point

# Called when the node enters the scene tree for the first time.
func _ready():
	var animations = ["up_down", "down_up"]
	animation_kind = animations[randi_range(0, 1)]
	animation.play(animation_kind)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (not main.is_dead):
		position.x -= pipe_spawner.pipe_speed * delta
	elif (main.is_dead):
		# Unlock rotations
		top_pipe.lock_rotation = false
		bottom_pipe.lock_rotation = false
		# Make them fall down
		animation.pause()

# Singals
func _on_earn_point_body_entered(body):
	if (body.name == "Player"):
		point_sound.play()
		main.score += 1
