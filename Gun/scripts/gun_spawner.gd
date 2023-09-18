extends Node

const GUN_ITEM = preload("res://Gun/gun.tscn")
@onready var main = get_node("/root/MainLevel")
@onready var gun_timer = $GunTimer
var gun_speed = 250

func _ready():
	#gun_timer.wait_time = randf_range(40, 60)
	gun_timer.start()

func _physics_process(_delta):
	if (main.is_dead && !gun_timer.is_stopped()):
		gun_timer.stop()

func _on_gun_timer_timeout():
	# To reset the timer wait time
	gun_timer.stop()
	gun_timer.wait_time = randf_range(45, 70)
	gun_timer.start()
	
	# Add a new gun item
	var screen = get_viewport().get_camera_2d().get_viewport_rect()
	var gun = GUN_ITEM.instantiate()
	add_child(gun)
	
	gun.position.x = screen.end.x - 150
	gun.position.y = screen.get_center().y
	print(gun_timer.wait_time)


func _on_speed_timer_timeout():
	if (gun_speed < 450):
		gun_speed += 20
	elif (gun_speed >= 450):
		gun_speed += 2
