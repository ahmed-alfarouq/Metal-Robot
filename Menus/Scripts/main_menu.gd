extends Control

func _ready():
	Firebase.Auth.logged_out.connect(_on_log_out)

func _on_play_pressed():
	Globals.change_scene(self, "res://levels/main_level.tscn")

func _on_exit_pressed():
	get_tree().quit()


func _on_credits_pressed():
	SceneTransition.transition("res://credits/credits.tscn")


func _on_log_out_pressed():
	Firebase.Auth.logout()

func _on_log_out():
	SceneTransition.transition("res://auth/sign_in/sign_in.tscn")