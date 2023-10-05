extends Node2D

@onready var main = get_node("/root/MainLevel")
@onready var player = get_node("/root/MainLevel/Player")
@onready var gun_spawner: Node = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!main.is_dead):
		position.x -= gun_spawner.gun_speed * delta


func _on_detect_remover_area_entered(area):
	if (area.name == "ItemsRemover"):
		queue_free()


func _on_detect_remover_body_entered(body):
	if (body.name == "Player"):
		player.handle_start_shooting()
		queue_free()
		
