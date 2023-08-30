extends CharacterBody2D

signal player_dies

# On Ready vars
@onready var main = get_node("/root/MainLevel")
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animTree = $AnimationTree
@onready var landingSound = $Landing

func _ready():
	animTree.active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Apply gravity when shooting state is not applied
	if (!main.isShooting):
		handleGravity()

	handleFlying()
	handleAnimation()
	move_and_slide()


func handleGravity():
	velocity.y = gravity
	# Rotate player while falling but not more than 15deg
	# And don't rotate it if space bar is pressed because it will cause a shaking state
	if (rad_to_deg(rotation) < 8 && !Input.is_action_pressed("Fly")):
		rotation += deg_to_rad(0.6)


# Handle start flying & flying animation
func handleFlying():
	if(Input.is_action_pressed("Fly") && !main.isDead):
		velocity.y = -200
		if (rad_to_deg(rotation) > 0):
			rotation -= deg_to_rad(1.5)

# Hanlde animation
func handleAnimation():
	if (Input.is_action_pressed("Fly") && !main.isDead):
		animTree["parameters/conditions/landing"] = false
		animTree["parameters/conditions/flying"] = true
	elif (Input.is_action_just_released("Fly") && !main.isDead):
		animTree["parameters/conditions/landing"] = true
		animTree["parameters/conditions/flying"] = false
		if (Input.is_action_just_released("Fly")):
			landingSound.play()


func playerDies():
	player_dies.emit()
	main.isDead = true
	animTree["parameters/conditions/dead"] = true


# Destroy player when hitting the ground
func _on_death_area_body_entered(body):
	if (body.name == "Player"):
		playerDies()

