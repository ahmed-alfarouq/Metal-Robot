extends Control


func _on_try_again_pressed():
	Globals.change_scene("res://internet_connection/check_connection.tscn", "transition")
