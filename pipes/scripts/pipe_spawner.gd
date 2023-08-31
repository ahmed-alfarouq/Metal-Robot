extends Node

const PIPEPAIR = preload("res://pipes/pipe_pair.tscn")
@onready var main = get_node("/root/MainLevel")
@onready var pipeSpeed = 200

func _ready():
	spawnPipe()

func spawnPipe():
	var screen = get_viewport().get_camera_2d().get_viewport_rect()
	var pipe = PIPEPAIR.instantiate()
	add_child(pipe, true)
	
	# Determine pipes position
	pipe.position.x = screen.end.x + 30
	pipe.position.y = randf_range(130, -130)

func _on_spawn_timer_timeout():
	spawnPipe()

func _on_increase_speed_timer_timeout():
	if (pipeSpeed < 450):
		pipeSpeed += 20
	elif (pipeSpeed >= 450):
		pipeSpeed += 2

func stop():
	$SpawnTimer.stop()
	$IncreaseSpeedTimer.stop()

func _on_player_dies():
	stop()
