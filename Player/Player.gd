extends CharacterBody2D

signal dies
signal start_shooting
signal stop_shooting

# On Ready vars
@onready var main = get_node("/root/MainLevel")
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim_tree = $AnimationTree
@onready var player_sprite = $Sprite2D
@onready var shooting_timer = $ShootingTimer

func _ready():
	anim_tree.active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	# Apply gravity when shooting state is not applied
	if (!main.is_shooting):
		handle_gravity()
		handle_flying()
		flying_landing_animation()
		move_and_slide() 


func handle_gravity():
	if(!Input.is_action_pressed("Fly")):
		velocity.y = gravity

	# Rotate player while falling but not more than 15deg
	# And don't rotate it if space bar is pressed because it will cause a shaking state
	if (rad_to_deg(rotation) < 8 && !Input.is_action_pressed("Fly")):
		rotation += deg_to_rad(0.6)


# Handle start flying & flying animation
func handle_flying():
	if(Input.is_action_pressed("Fly") && !main.is_dead):
		# Delay flying till start flying amimation finishes
		if (velocity.y == 450):
			velocity.y = 0
			await get_tree().create_timer(0.1).timeout
			velocity.y = -200

		if (rad_to_deg(rotation) > 0):
			rotation -= deg_to_rad(1.5)

# Hanlde animation
func flying_landing_animation():
	if (Input.is_action_pressed("Fly") && !main.is_dead):
		anim_tree["parameters/conditions/landing"] = false
		anim_tree["parameters/conditions/flying"] = true
	elif (Input.is_action_just_released("Fly") && !main.is_dead):
		anim_tree["parameters/conditions/landing"] = true
		anim_tree["parameters/conditions/flying"] = false

func shooting_animation(shooting: bool):
	if (shooting):
		# Switch to equip gun then shooting animation
		anim_tree["parameters/conditions/dropGun"] = false
		anim_tree["parameters/conditions/flying"] = false
		anim_tree["parameters/conditions/landing"] = false
		anim_tree["parameters/conditions/equipGun"] = true
	else:
		# Reset animation
		anim_tree["parameters/conditions/equipGun"] = false
		anim_tree["parameters/conditions/dropGun"] = true

func moving_while_shooting():
	var tween
	var distance_to_top = abs( self.position.y - 15 )
	var distance_to_bottom = abs( self.position.y - 450 )
	
	if (distance_to_bottom < distance_to_top):
		tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(self, "position", Vector2(self.position.x, 450), 2.5)
		tween.tween_property(self, "position", Vector2(self.position.x, 15), 2.5)
		tween.tween_property(self, "position", Vector2(self.position.x, 450), 2.5)
		tween.tween_property(self, "position", Vector2(self.position.x, 120), 2.5)
	else:
		tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(self, "position", Vector2(self.position.x, 15), 2.5)
		tween.tween_property(self, "position", Vector2(self.position.x, 450), 2.5)
		tween.tween_property(self, "position", Vector2(self.position.x, 15), 2.5)
		tween.tween_property(self, "position", Vector2(self.position.x, 120), 2.5)

func toggle_shooting_effect(show_effect: bool):
	for shooting_effect in player_sprite.get_children():
		shooting_effect.visible = show_effect

func handle_start_shooting():
	start_shooting.emit()
	main.is_shooting = true
	# Make player rotation equals 0
	rotation = deg_to_rad(0)

	shooting_animation(true)

	# Make shooting effects visible after equipGun animation finishes
	await get_tree().create_timer(0.9).timeout
	toggle_shooting_effect(true)
	
	moving_while_shooting()
	shooting_timer.start()

func handle_stop_shooting():
	stop_shooting.emit()
	shooting_animation(false)

	# Set shooting effect invisible
	toggle_shooting_effect(false)
	
	# Set is_shooting to false after dropGun animation finishes
	await get_tree().create_timer(0.9).timeout
	main.is_shooting = false
	shooting_timer.stop()

func player_dies():
	dies.emit()
	main.is_dead = true
	anim_tree["parameters/conditions/dead"] = true
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_shooting_timer_timeout():
	handle_stop_shooting()
