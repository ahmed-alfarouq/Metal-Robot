extends Node

const PIPEPAIR = preload("res://pipes/pipe_pair.tscn")
@onready var main = get_node("/root/MainLevel")
@onready var prevPipeSpeed = 200
@onready var pipeSpeed = 200
@onready var pipeGapRange = randf_range(50, 80)
@onready var spawnTimer = $SpawnTimer
@onready var speedTimer = $IncreaseSpeedTimer

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
	spawnTimer.stop()
	speedTimer.stop()

func _on_player_dies():
	stop()


func _on_player_start_shooting():
	prevPipeSpeed = pipeSpeed
	pipeSpeed = 600
	spawnTimer.wait_time = 0.8
	pipeGapRange = randf_range(70, 80)


func _on_player_stop_shooting():
	pipeSpeed = prevPipeSpeed
	spawnTimer.wait_time = 2
	pipeGapRange = randf_range(50, 80)
