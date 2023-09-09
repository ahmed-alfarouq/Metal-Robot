extends Node2D

@onready var main = get_node("/root/MainLevel")
@onready var player = get_node("/root/MainLevel/Player")

func _physics_process(delta):
	if(!main.isDead):
		position.x -= 350 * delta

func _on_death_area_body_entered(body):
	if (body.name == "Player"):
		player.playerDies()

