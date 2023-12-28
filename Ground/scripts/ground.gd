extends Node2D

@onready var main = get_node("/root/MainLevel")
@onready var ground_spawner = get_parent()

func _physics_process(delta):
	if not main.is_dead:
		position.x -= ground_spawner.ground_speed * delta

func _on_death_area_body_entered(body):
	if body.name == "Player" && not main.is_shooting:
		body.player_dies()

