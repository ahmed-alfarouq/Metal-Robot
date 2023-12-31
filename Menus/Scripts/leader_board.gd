extends Control


func _on_back_pressed():
	Globals.change_scene("res://menus/main_menu.tscn", "transition")
