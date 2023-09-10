extends Node

const GUN_ITEM = preload("res://Gun/gun.tscn")
@onready var main = get_node("/root/MainLevel")
@onready var gun_timer = $GunTimer


func _physics_process(_delta):
	gun_timer.wait_time = randi_range(40, 60)
	if (main.is_dead && !gun_timer.is_stopped()):
		gun_timer.stop()

func _on_gun_timer_timeout():
	var screen = get_viewport().get_camera_2d().get_viewport_rect()
	var gun = GUN_ITEM.instantiate()
	add_child(gun)
	
	gun.position.x = screen.end.x - 150
	gun.position.y = screen.get_center().y
	gun_timer.wait_time = randi_range(45, 70)
