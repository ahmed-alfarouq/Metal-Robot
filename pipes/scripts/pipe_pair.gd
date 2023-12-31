class_name PipePair

extends Node2D

var stop_movement: bool = false
var animation_kind: String
var top_pipe_health = 100
var bottom_pipe_health = 100

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

# Using it when the player dies
func drop_pipes():
	stop_movement = true
	
	# Uncheck rotations and freeze if exist
	if is_instance_valid(top_pipe):
		top_pipe.freeze = false
	
	if is_instance_valid(bottom_pipe):
		bottom_pipe.freeze = false

	# Make them fall down
	animation.pause()

# Using it when the pipe is hit
func take_damage(pipe_name):
	var weapon_damage = Globals.current_weapon_data["damage"]

	animation.pause()

	if pipe_name == "TopPipe" && top_pipe_health > 0:
		top_pipe_health -= weapon_damage
	elif pipe_name == "TopPipe" && top_pipe_health <= 0:
		tween_pipe(top_pipe)
	elif pipe_name == "bottom_pipe" && bottom_pipe_health > 0:
		bottom_pipe_health -= weapon_damage
	elif pipe_name == "bottom_pipe" && bottom_pipe_health <= 0:
		tween_pipe(bottom_pipe)

func tween_pipe(pipe):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR).set_parallel(true)
	# Using bind node to automatically kill Tween when the bound object is freed
	tween.bind_node(pipe)
	pipe.lock_rotation = false
	pipe.freeze = false
	tween.tween_property(pipe, "rotation_degrees", 90, 0.3)
	tween.tween_property(pipe, "position", Vector2(pipe.position.x, 2000), 0.3)
	tween.chain().tween_callback(pipe.queue_free)

# Singals
func _on_earn_point_body_entered(body):
	if body.name == "Player":
		point_sound.play()
		main.score += 1
