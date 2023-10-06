extends Control


func _on_menu_pressed():
	SceneTransition.transition(self, "res://menus/main_menu.tscn")

func _on_leaderboard_pressed():
	pass

func _on_replay_pressed():
	Globals.change_scene(self, "res://levels/main_level.tscn")
