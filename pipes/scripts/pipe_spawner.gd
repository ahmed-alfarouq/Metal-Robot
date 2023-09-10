extends Node

const PIPEPAIR = preload("res://pipes/pipe_pair.tscn")
@onready var main = get_node("/root/MainLevel")
@onready var prev_pipe_speed = 200
@onready var pipe_speed = 200
@onready var pipe_gap_range = randf_range(40, 80)
@onready var spawn_timer = $SpawnTimer
@onready var speed_timer = $IncreaseSpeedTimer

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
	if (pipe_speed < 450):
		pipe_speed += 20
	elif (pipe_speed >= 450):
		pipe_speed += 2

func stop():
	spawn_timer.stop()
	speed_timer.stop()

func _on_player_dies():
	stop()


func _on_player_start_shooting():
	prev_pipe_speed = pipe_speed
	pipe_speed = 600
	spawn_timer.wait_time = 0.8
	pipe_gap_range = randf_range(70, 80)


func _on_player_stop_shooting():
	pipe_speed = prev_pipe_speed
	spawn_timer.wait_time = 2
	pipe_gap_range = randf_range(40, 80)
