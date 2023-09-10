extends Node2D


@onready var pipe_spawner = get_parent()
@onready var main = get_node("/root/MainLevel")
@onready var player = get_node("/root/MainLevel/Player")
@onready var top_pipe = $TopPipe
@onready var bottom_pipe = $BottomPipe

# Called when the node enters the scene tree for the first time.
func _ready():
	top_pipe.position.y += pipe_spawner.pipe_gap_range
	bottom_pipe.position.y -= pipe_spawner.pipe_gap_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!main.is_dead):
		position.x -= pipe_spawner.pipe_speed * delta

func _on_top_pipe_body_entered(body):
	if (body.name == "Player" && !main.is_shooting):
		player.player_dies()

func _on_bottom_pipe_body_entered(body):
	if (body.name == "Player" && !main.is_shooting):
		player.player_dies()

func _on_earn_point_body_entered(body):
	if (body.name == "Player"):
		$Point.play()
		main.score += 1

func _on_detect_remover_area_entered(area):
	if (area.name == "ItemsRemover"):
		queue_free()

func _on_top_pipe_area_entered(area):
	if (area.name == "ShootsDetecter" && main.is_shooting):
		var tween = get_tree().create_tween()
		tween.tween_property(top_pipe, "rotation", deg_to_rad(-50), 0.2)
		tween.tween_property(top_pipe, "position", Vector2(top_pipe.position.x, top_pipe.position.y - 600), 0.2)

func _on_bottom_pipe_area_entered(area):
	if (area.name == "ShootsDetecter" && main.is_shooting):
		var tween = get_tree().create_tween()
		tween.tween_property(bottom_pipe, "rotation", deg_to_rad(50), 0.2)
		tween.tween_property(bottom_pipe, "position", Vector2(bottom_pipe.position.x, bottom_pipe.position.y + 600), 0.2)
