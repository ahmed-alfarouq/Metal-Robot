extends Node

const GUN_ITEM = preload("res://Gun/gun.tscn")
@onready var main = get_node("/root/MainLevel")

func _physics_process(_delta):
	if (main.isDead && !$GunTimer.is_stopped()):
		$GunTimer.stop()
		print("Stoped")

func _on_gun_timer_timeout():
	var screen = get_viewport().get_camera_2d().get_viewport_rect()
	var gun = GUN_ITEM.instantiate()
	add_child(gun)
	
	gun.position.x = screen.end.x - 30
	gun.position.y = screen.get_center().y
