extends CharacterBody2D


@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var dead = false
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	velocity.y = ProjectSettings.get_setting("physics/2d/default_gravity")
	rotation = deg_to_rad(5)
	
	if(Input.is_action_pressed("Fly") && !dead):
		velocity.y = -600

	move_and_slide()


func _on_death_area_body_entered(body):
	if (body.name == "Player" && !dead):
		dead = true
		anim.play("Boom")

