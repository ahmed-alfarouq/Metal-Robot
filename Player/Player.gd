extends CharacterBody2D

@onready var main = get_node("/root/MainLevel")
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("Landing")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handleGravity()
	handleFlying()
	move_and_slide()

func handleGravity():
	velocity.y = gravity
	# Rotate player while falling but not more than 15deg
	if (rad_to_deg(rotation) < 15):
		rotation += deg_to_rad(0.6)
	
	if (Input.is_action_just_released("Fly") && !main.isDead):
		anim.play("Landing")
	
func handleFlying():
	# Play start flying animation when player clicks space bar
	if (Input.is_action_just_pressed("Fly") && !main.isDead):
		anim.play("StartFlying")

	# Keep playing flying animation when player clicks space bar
	if(Input.is_action_pressed("Fly") && !main.isDead):
		velocity.y = -400
		if (rad_to_deg(rotation) > 0):
			rotation -= deg_to_rad(1.5)
		anim.play("Flying")

# Destroy player when hitting the ground
func _on_death_area_body_entered(body):
	if (body.name == "Player" && !main.isDead):
		main.isDead = true
		anim.play("Boom")
		await get_tree().create_timer(0.55).timeout
		request_ready()

