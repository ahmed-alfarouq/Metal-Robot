class_name Player

extends CharacterBody2D

signal dies
signal start_shooting
signal stop_shooting

@export var pistol_resource: SpriteFrames
@export var flying_speed: int = 200

var screaming_collision = CollisionShape2D.new()

# On Ready vars
@onready var main = get_node("/root/MainLevel")
@onready var animation = $Player
@onready var screaming_area = $ScreamingArea
@onready var screaming_timer = $ScreamingTimer
@onready var collision = $Collision
@onready var boom_sound = $Sounds/Boom

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	handle_flying()
	handle_screaming()

# Handle start flying & flying animation
func handle_flying():
	if(Input.is_action_pressed("fly_up") && !main.is_dead):
		velocity.y = -flying_speed
		animation.flying_up()
	elif (Input.is_action_pressed("fly_down") && !main.is_dead):
		velocity.y = flying_speed
		animation.flying_down()
	else:
		velocity.y = 0
	move_and_slide()

func handle_screaming():
	if (
		Input.is_action_pressed("screaming") &&
		Globals.screaming_times != 0 &&
		screaming_timer.is_stopped() &&
		not main.is_dead
		):
		var pipe_spawner = main.get_node("Spawners/PipeSpawner")
		# Stop pipe spwaner
		pipe_spawner.stop_spawner()
		# Start screaming timer
		screaming_timer.start()
		add_screaming_collision()
		# Animation
		animation.scream()
		# Shake camera for 1 sec
		main.shake_camera(1)
		# Wait 1 sec before deleting the collision
		await get_tree().create_timer(1).timeout
		if (Globals.screaming_times != 0):
			Globals.screaming_times -= 1
		await screaming_timer.timeout

		# Remove collision when screaming is done
		screaming_area.remove_child(screaming_collision)
		# Increase score
		main.score += 3
		# Restart spawner
		pipe_spawner.spawn_pipes()
		pipe_spawner.start_spawner()
		

func add_screaming_collision():
	screaming_area.call_deferred("add_child", screaming_collision, true)
	screaming_collision.shape = CircleShape2D.new()
	screaming_collision.position.x = 1175
	screaming_collision.shape.radius = 2260

func player_dies():
	# Emit signal
	dies.emit()
	# Delection collision to prevent player from colliding with other objects after death
	collision.queue_free()
	# Set is_dead to true
	main.is_dead = true
	# play animation and sounds
	boom_sound.play()
	animation.boom()
	await animation.animation_finished
	await boom_sound.finished
	# Reset screaming_times
	Globals.screaming_times = 3
	# Take player to the lose menu
	SceneTransition.transition(main, "res://menus/loss_menu.tscn")


func _on_screaming_area_body_entered(body):
	if (body.is_in_group("pipes")):
		body.set_process(false)
