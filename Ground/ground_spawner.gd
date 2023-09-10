extends Node

const Ground = preload("res://Ground/ground.tscn")
@onready var main = get_node("/root/MainLevel")
@onready var prev_ground_speed: int = 200
@onready var ground_speed: int = 200
var ground_copy

func _ready():
	ground_copy = Ground.instantiate()
	add_child(ground_copy)
	
	ground_copy.position.x = 0
	ground_copy.position.y = 750


func _on_remover_body_entered(_body):
	if (!main.is_dead):
		ground_copy = Ground.instantiate()
		call_deferred("add_child", ground_copy)
		ground_copy.position.x = 2450
		ground_copy.position.y = 750


func _on_remover_body_exited(body):
	if (body.is_in_group("ground")):
		body.queue_free()


func _on_increase_speed_timer_timeout():
	if (ground_speed < 450):
		ground_speed += 20
	elif (ground_speed >= 450):
		ground_speed += 2

func _on_player_start_shooting():
	prev_ground_speed = ground_speed
	ground_speed = 600


func _on_player_stop_shooting():
	ground_speed = prev_ground_speed
