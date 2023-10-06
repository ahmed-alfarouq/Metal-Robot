extends Control

func _on_back_pressed():
	SceneTransition.transition(self, "res://menus/main_menu.tscn")
