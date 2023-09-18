extends Node

const PIPEPAIR = preload("res://pipes/pipe_pair.tscn")
@onready var main = get_node("/root/MainLevel")
@onready var prev_pipe_speed = 200
@onready var pipe_speed = 200
@onready var pipe_gap_range = randf_range(50, 80)
@onready var spawn_timer = $SpawnTimer
@onready var speed_timer = $IncreaseSpeedTimer

func _ready():
	spawn_pipes()

func spawn_pipes():
	var screen = get_viewport().get_camera_2d().get_viewport_rect()
	var pipe = PIPEPAIR.instantiate()
	add_child(pipe, true)
	
	# Determine pipes position
	pipe.position.x = screen.end.x + 30
	pipe.position.y = randf_range(130, -130)

func _on_spawn_timer_timeout():
	spawn_pipes()

func _on_increase_speed_timer_timeout():
	if (pipe_speed < 450):
		pipe_speed += 20
	elif (pipe_speed >= 450):
		pipe_speed += 2

func stop_spawner():
	spawn_timer.stop()
	speed_timer.stop()

func _on_player_dies():
	stop_spawner()


func _on_player_start_shooting():
	prev_pipe_speed = pipe_speed

	# Stop all pipe while equiping gun
	pipe_speed = 0
	stop_spawner()
	spawn_timer.stop()
	await get_tree().create_timer(0.6).timeout

	# Increase pipes speed and count while shooting, decrease the gap between pipes, and restart spawning them
	pipe_speed = 600
	spawn_timer.wait_time = 0.8
	spawn_timer.start()
	pipe_gap_range = randf_range(70, 80)


func _on_player_stop_shooting():
	# Stop all pipe while droping gun
	pipe_speed = 0
	stop_spawner()
	spawn_timer.stop()
	await get_tree().create_timer(0.6).timeout

	# Reset everything
	pipe_speed = prev_pipe_speed
	spawn_timer.wait_time = 2
	spawn_timer.start()
	pipe_gap_range = randf_range(50, 80)
	
	# Add a pipe to prevent a big gap between pipes
	await get_tree().create_timer(0.9).timeout
	spawn_pipes()
