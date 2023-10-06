extends Node

const PIPEPAIR = preload("res://pipes/pipe_pair.tscn")


@export var pipe_speed = 400

@onready var main = get_node("/root/MainLevel")
@onready var prev_pipe_speed = 400
@onready var pipe_gap_range
@onready var spawn_timer = $SpawnTimer
@onready var increase_speed_timer = $IncreaseSpeedTimer

func _ready():
	spawn_pipes()

func spawn_pipes():
	pipe_gap_range = randi_range(130, 160)
	var screen = get_viewport().get_visible_rect()
	var pipe = PIPEPAIR.instantiate()
	add_child(pipe, true)
	
	# Determine pipes position
	pipe.position.x = screen.end.x + 200
	pipe.position.y = (screen.size.y / 2) - randi_range(20, 40)

func _on_spawn_timer_timeout():
	spawn_pipes()

func _on_increase_speed_timer_timeout():
	if (pipe_speed < 650):
		pipe_speed += 30
	elif (pipe_speed >= 650):
		pipe_speed += 20
		if (spawn_timer.wait_time == 1.8):
			spawn_timer.wait_time = 1.5
	elif (pipe_speed >= 800):
		increase_speed_timer.stop()
		if (spawn_timer.wait_time == 1.5):
			spawn_timer.wait_time = 1

func stop_spawner():
	spawn_timer.stop()
	increase_speed_timer.stop()

func start_spawner():
	spawn_timer.start()
	increase_speed_timer.start()

func _on_player_dies():
	stop_spawner()
