extends Node2D

@onready var main = get_node("/root/MainLevel")
@onready var player = get_node("/root/MainLevel/Player")

func _process(_delta):
	if (!main.isDead):
		$AnimationPlayer.play("Ground")
	else:
		$AnimationPlayer.pause()


func _on_death_area_body_entered(body):
	if (body.name == "Player"):
		player.playerDies()
