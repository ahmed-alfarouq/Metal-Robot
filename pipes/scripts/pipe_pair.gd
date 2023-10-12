class_name PipePair

extends Node2D

var stop_movement: bool = false
var animation_kind: String

@onready var main = get_node("/root/MainLevel")
@onready var pipe_spawner: Node = get_parent()
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var top_pipe: RigidBody2D = $TopPipe
@onready var bottom_pipe: RigidBody2D = $BottomPipe
@onready var point_area: Area2D = $EarnPointArea
@onready var point_sound: AudioStreamPlayer2D = $Point

func connect_area():
	# Connect point area
	point_area.body_entered.connect(_on_earn_point_body_entered)

# Called when the node enters the scene tree for the first time.
func play_animation():
	# Decide which animation should work
	var animations = ["up_down", "down_up"]
	animation_kind = animations[randi_range(0, 1)]
	animation.play(animation_kind)

func drop_pipes():
	stop_movement = true
	
	# Uncheck rotations and freeze
	# Check first if it does exist, because sometimes we remove one of them such as fire_pipes
	if (is_instance_valid(top_pipe)):
		top_pipe.lock_rotation = false
		top_pipe.freeze = false
	
	if (is_instance_valid(bottom_pipe)):
		bottom_pipe.lock_rotation = false
		bottom_pipe.freeze = false

	# Make them fall down
	animation.pause()

# Singals
func _on_earn_point_body_entered(body):
	if (body.name == "Player"):
		point_sound.play()
		main.score += 1
