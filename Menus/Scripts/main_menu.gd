extends Control

func _ready():
	Firebase.Auth.logged_out.connect(_on_log_out)

func _on_play_pressed():
	Globals.change_scene("res://levels/main_level.tscn", "loading_screen")

func _on_exit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	Globals.change_scene("res://menus/credits.tscn", "transition")

func _on_shop_pressed():
	Globals.change_scene("res://menus/shop.tscn", "transition")

func _on_log_out_pressed():
	Firebase.Auth.logout()

func _on_log_out():
	Globals.change_scene("res://auth/sign_in/sign_in.tscn", "transition")


func _on_ranks_pressed():
	Globals.change_scene("res://menus/leader_board.tscn", "transition")
