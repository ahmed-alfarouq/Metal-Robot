extends Node

@onready var main = get_node("/root/MainLevel")
const Ground = preload("res://Ground/ground.tscn")
var groundCopy

func _ready():
	groundCopy = Ground.instantiate()
	add_child(groundCopy)
	
	groundCopy.position.x = 0
	groundCopy.position.y = 750


func _on_remover_body_entered(_body):
	if (!main.isDead):
		groundCopy = Ground.instantiate()
		call_deferred("add_child", groundCopy)
		groundCopy.position.x = 2450
		groundCopy.position.y = 750


func _on_remover_body_exited(body):
	if (body.is_in_group("ground")):
		body.queue_free()

