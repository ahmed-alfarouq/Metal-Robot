class_name Player

extends CharacterBody2D

signal dies
signal start_shooting
signal stop_shooting

@export var pistol_resource: SpriteFrames
@export var flying_speed: int = 200

# On Ready vars
@onready var main = get_node("/root/MainLevel")
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var shooting_timer = $ShootingTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	handle_flying()
	move_and_slide()


# Handle start flying & flying animation
func handle_flying():
	if(Input.is_action_pressed("flying_up") && !main.is_dead):
		velocity.y = -flying_speed
	elif (Input.is_action_pressed("flying_down") && !main.is_dead):
		velocity.y = flying_speed
	else:
		velocity.y = 0

func player_dies():
	main.is_dead = true
	dies.emit()
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_shooting_timer_timeout():
	pass
