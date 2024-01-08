extends Node2D

const SAVE_FILE_PATH = "user://bestscore.save"

@onready var parallax_bg = %ParallaxBG
@onready var main_score = %LevelUI.get_node("%Score")
@onready var is_dead: bool = false
@onready var is_shooting: bool = false
@onready var score: int = 0


var camera: Camera2D
var play_camera_shake: bool = false
var parallax_prev_offset

func _physics_process(_delta):
	if !is_dead:
		main_score.text = str(score)
	
	if play_camera_shake:
		var rng = RandomNumberGenerator.new()
		camera.offset = Vector2(rng.randf_range(-20, 20), rng.randf_range(20, -20))
	
	if Input.is_action_just_pressed("pause"):
		Globals.pause_game()

func shake_camera(shaking_time):
	camera = Camera2D.new()
	var shaking_timer = Timer.new()
	# Change camera anchor mode
	camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	# Make shaking work for one time and set wait time to shaking_time
	shaking_timer.autostart = true
	shaking_timer.one_shot = true
	shaking_timer.wait_time = shaking_time
	# Save parallax offset
	parallax_prev_offset = parallax_bg.scroll_offset
	# Add it to the scene
	call_deferred("add_child", camera, true)
	camera.call_deferred("add_child", shaking_timer, true)
	# Disable shaking after timeout
	shaking_timer.timeout.connect(_on_shaking_timer_timeout)
	# Shake the camera
	play_camera_shake = true


# Signals
func _on_player_dies():
	shake_camera(1)
	parallax_bg.set_process(false)
	Globals.score = score
	if score > Globals.best_score:
		Globals.save_score(score)

func _on_items_remover_body_entered(body):
	if body.get_parent().is_in_group("pipes"):
		body.get_parent().queue_free()

func _on_shaking_timer_timeout():
	# Stop shaking
	play_camera_shake = false
	# Delete the camera
	if has_node("Camera2D"):
		remove_child($Camera2D)
	# Reset offset
	parallax_bg.scroll_offset = parallax_prev_offset

"""
	I use this to remove pipes when they get out of the screen
	there's an issue with this area while detecting pipes
"""
func _on_items_remover_area_entered(area):
	if area.name == "EarnPointArea":
		area.get_parent().queue_free()
