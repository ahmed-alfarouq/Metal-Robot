extends CharacterBody2D

signal dies
signal start_shooting
signal stop_shooting

# On Ready vars
@onready var main = get_node("/root/MainLevel")
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animTree = $AnimationTree
@onready var playerSprite = $Sprite2D

func _ready():
	animTree.active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# Apply gravity when shooting state is not applied
	if (!main.isShooting):
		handleGravity()
		handleFlying()
		flyingLandingAnimation()
		move_and_slide()
	else:
		shootingMovingAnimation()


func handleGravity():
	if(!Input.is_action_pressed("Fly")):
		velocity.y = gravity

	# Rotate player while falling but not more than 15deg
	# And don't rotate it if space bar is pressed because it will cause a shaking state
	if (rad_to_deg(rotation) < 8 && !Input.is_action_pressed("Fly")):
		rotation += deg_to_rad(0.6)


# Handle start flying & flying animation
func handleFlying():
	if(Input.is_action_pressed("Fly") && !main.isDead):
		# Delay flying till start flying amimation finishes
		if (velocity.y == 450):
			velocity.y = 0
			await get_tree().create_timer(0.1).timeout
			velocity.y = -200

		if (rad_to_deg(rotation) > 0):
			rotation -= deg_to_rad(1.5)

# Hanlde animation
func flyingLandingAnimation():
	if (Input.is_action_pressed("Fly") && !main.isDead):
		animTree["parameters/conditions/landing"] = false
		animTree["parameters/conditions/flying"] = true
	elif (Input.is_action_just_released("Fly") && !main.isDead):
		animTree["parameters/conditions/landing"] = true
		animTree["parameters/conditions/flying"] = false

func shootingAnimation(shooting: bool):
	if (shooting):
		# Switch to equip gun then shooting animation
		animTree["parameters/conditions/flying"] = false
		animTree["parameters/conditions/landing"] = false
		animTree["parameters/conditions/equipGun"] = true
	else:
		# Reset animation
		animTree["parameters/conditions/equipGun"] = false
		animTree["parameters/conditions/dropGun"] = true

func shootingMovingAnimation():
	if (position.y > 20):
		position.y -= 1

func toggleShootingEffect(showEffect: bool):
	for shootingEffect in playerSprite.get_children():
		shootingEffect.visible = showEffect

func startShooting():
	# Make player rotation equals 0
	rotation = deg_to_rad(0)

	shootingAnimation(true)

	# Make shooting effects visible after equipGun animation finishes
	await get_tree().create_timer(0.9).timeout
	toggleShootingEffect(true)
	
	start_shooting.emit()
	$ShootingTimer.start()

func stopShooting():
	shootingAnimation(false)

	# Set shooting effect invisible
	toggleShootingEffect(false)
	
	# Set isShooting to false after dropGun animation finishes
	await get_tree().create_timer(0.9).timeout
	main.isShooting = false
	
	stop_shooting.emit()

func playerDies():
	dies.emit()
	main.isDead = true
	animTree["parameters/conditions/dead"] = true

func _on_shooting_timer_timeout():
	stopShooting()
