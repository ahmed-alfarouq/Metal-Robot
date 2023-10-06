extends Node

const PIPEPAIR = preload("res://pipes/pipe_pair.tscn")


@export var pipe_speed = 350

@onready var main = get_node("/root/MainLevel")
@onready var prev_pipe_speed = 350
@onready var pipe_gap_range = randf_range(90, 110)
@onready var spawn_timer = $SpawnTimer
@onready var speed_timer = $IncreaseSpeedTimer

func _ready():
	spawn_pipes()

func spawn_pipes():
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
		pipe_speed += 20
	elif (pipe_speed >= 650):
		pipe_speed += 10

func stop_spawner():
	spawn_timer.stop()
	speed_timer.stop()

func _on_player_dies():
	stop_spawner()
