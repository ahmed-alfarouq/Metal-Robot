extends Control


func _on_menu_pressed():
	Globals.change_scene("res://menus/main_menu.tscn", "transition")

func _on_leaderboard_pressed():
	pass

func _on_replay_pressed():
	Globals.change_scene("res://levels/main_level.tscn", "loading_screen")
