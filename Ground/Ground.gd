extends Node2D

@onready var main = get_node("/root/MainLevel")

func _process(_delta):
	if (!main.isDead):
		$AnimationPlayer.play("Ground")
	else:
		$AnimationPlayer.pause()
