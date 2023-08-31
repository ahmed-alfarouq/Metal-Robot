extends Node2D

@onready var main = get_node("/root/MainLevel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!main.isDead):
		position.x -= 150 * delta


func _on_detect_remover_area_entered(area):
	if (area.name == "ItemsRemover"):
		queue_free()


func _on_detect_remover_body_entered(body):
	if (body.name == "Player"):
		queue_free()
