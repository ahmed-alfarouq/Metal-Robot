class_name Player

extends CharacterBody2D

signal dies
signal start_shooting
signal stop_shooting

@export var pistol_resource: SpriteFrames
@export var flying_speed: int = 200

var screaming_collision: CollisionShape2D = CollisionShape2D.new()
var is_shooting: bool
var weapon_info: Dictionary
var weapon_sprites: SpriteFrames
var player_weapon_sprites: SpriteFrames

# On Ready vars
@onready var main = get_node("/root/MainLevel")
@onready var player_animation_sprite: AnimatedSprite2D = $PlayerAnimatedSprite
@onready var weapon: Node2D = $Weapon
@onready var screaming_area: Area2D = $ScreamingArea
@onready var screaming_timer: Timer = $ScreamingTimer
@onready var collision: CollisionShape2D = $Collision
@onready var boom_sound: AudioStreamPlayer2D = $Sounds/Boom

func _ready():
	# Getting current weapon data
	var weapon_name: String = Globals.current_weapon
	var weapons_data: Dictionary = load_weapons_json("res://weapons.json")
	if (weapons_data.has(weapon_name)):
		weapon_info = weapons_data[weapon_name]
		weapon_sprites = load(weapon_info["weapon_sprites_resource"])
		player_weapon_sprites = load(weapon_info["player_weapon_sprites_resource"])
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	handle_flying()
	handle_screaming()
	handle_shooting()
	handle_colliding()

# Handle start flying & flying animation
func handle_flying():
	if(Input.is_action_pressed("fly_up") && !main.is_dead):
		velocity.y = -flying_speed
		player_animation_sprite.flying_up()
	elif (Input.is_action_pressed("fly_down") && !main.is_dead):
		velocity.y = flying_speed
		player_animation_sprite.flying_down()
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
		player_animation_sprite.scream()
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

func handle_shooting():
	if (Input.is_action_pressed("shooting") && not is_shooting):
		is_shooting = true
		weapon.weapon_entered.connect(func(): player_animation_sprite.visible = false)
		weapon.weapon_exited.connect(func(): player_animation_sprite.visible = true)
		weapon.enter(weapon_sprites, weapon_info, player_weapon_sprites)

func handle_colliding():
	var killers = ["TopPipe", "BottomPipe"]
	var collision_count = get_slide_collision_count()
	for i in collision_count:
		var collision_info = get_slide_collision(i)
		var collider = collision_info.get_collider()
		if (killers.has(collider.name)):
			player_dies()

func player_dies():
	# Emit signal
	dies.emit()
	# Delection collision to prevent player from colliding with other objects after death
	collision.queue_free()
	# Set is_dead to true
	main.is_dead = true
	# play animation and sounds
	boom_sound.play()
	player_animation_sprite.boom()
	await player_animation_sprite.animation_finished
	await boom_sound.finished
	# Reset screaming_times
	Globals.screaming_times = 3
	# Take player to the lose menu
	SceneTransition.transition(main, "res://menus/loss_menu.tscn")

func load_weapons_json(file_path: String):
	if (FileAccess.file_exists(file_path)):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_data = JSON.parse_string(data_file.get_as_text())
		
		if (parsed_data is Dictionary):
			return parsed_data
		else:
			ErrorHandler.error("Some thing went wrong, when trying to get weapon data")
			return {}
	else:
		ErrorHandler.error("Weapon data file doesn't exist")
		return {}

# Helping functions
func add_screaming_collision():
	screaming_area.call_deferred("add_child", screaming_collision, true)
	screaming_collision.shape = CircleShape2D.new()
	screaming_collision.position.x = 1175
	screaming_collision.shape.radius = 2260

# Signals
func _on_screaming_area_body_entered(body):
	if (body.is_in_group("pipes")):
		body.set_process(false)
