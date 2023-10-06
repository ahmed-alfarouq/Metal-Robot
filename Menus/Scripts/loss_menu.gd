extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_pressed():
	SceneTransition.transition(self, "res://menus/main_menu.tscn")

func _on_leaderboard_pressed():
	pass

func _on_replay_pressed():
	Globals.change_scene(self, "res://levels/main_level.tscn")
