extends Node

const GROUND = preload("res://ground/ground.tscn")

@export var ground_speed: int = 350

@onready var screen = get_viewport().get_visible_rect()
@onready var main = get_node("/root/MainLevel")
@onready var increase_speed_timer = $IncreaseSpeedTimer
@onready var prev_ground_speed: int = 350
@onready var ground_copy = GROUND.instantiate()
@onready var ground_width = 6400

func _ready():
	call_deferred("add_child", ground_copy)
	ground_copy.position = Vector2(0, screen.size.y - 60)
	
	# Calculate ground width
	if (ground_copy.get_node_or_null("Ground")):
		var ground_child = ground_copy.get_node("Ground")
		ground_width = snapped(ground_child.texture.get_width() * ground_child.scale.x * 2, 0.1)


func _on_remover_body_entered(body):
	if (not main.is_dead):
		ground_copy = GROUND.instantiate()
		call_deferred("add_child", ground_copy, true)
		var position_x = ground_width - 10 + snapped(body.position.x, 0.01) # It's plus because the ground position will be negative
		ground_copy.position = Vector2(position_x, screen.size.y - 60)

func _on_remover_body_exited(body):
	if (body.is_in_group("ground")):
		body.queue_free()


func _on_increase_speed_timer_timeout():
	if (ground_speed < 650):
		ground_speed += 20
	elif (ground_speed >= 650):
		ground_speed += 10
	elif (ground_speed >= 800):
		increase_speed_timer.stop()

func _on_player_start_shooting():
	prev_ground_speed = ground_speed
	ground_speed = 0

	await get_tree().create_timer(0.6).timeout
	ground_speed += 250


func _on_player_stop_shooting():
	ground_speed = 0
	await get_tree().create_timer(0.6).timeout
	ground_speed = prev_ground_speed
