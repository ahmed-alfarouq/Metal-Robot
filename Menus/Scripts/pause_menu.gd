extends CanvasLayer

func _on_resume_pressed():
	get_tree().paused = false
	queue_free()

func _on_options_pressed():
	pass # Replace with function body.

func _on_to_main_menu_pressed():
	get_tree().paused = false
	Globals.change_scene("res://menus/main_menu.tscn", "transition")
	queue_free()

func _on_quit_pressed():
	get_tree().quit()
