extends Control


func _on_try_again_pressed():
	SceneTransition.transition(self, "res://internet_connection/check_connection.tscn")
