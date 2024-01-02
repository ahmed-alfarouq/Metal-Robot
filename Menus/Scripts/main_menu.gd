extends Control

func _ready():
	SilentWolf.Auth.sw_logout_complete.connect(_on_log_out_complete)

func _on_play_pressed():
	Globals.change_scene("res://levels/main_level.tscn", "loading_screen")

func _on_exit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	Globals.change_scene("res://menus/credits.tscn", "transition")

func _on_shop_pressed():
	Globals.change_scene("res://menus/shop.tscn", "transition")

func _on_log_out_pressed():
	SilentWolf.Auth.logout_player()

func _on_ranks_pressed():
	Globals.change_scene("res://menus/leader_board.tscn", "transition")

func _on_log_out_complete():
	Globals.change_scene("res://auth/sign_in/sign_in.tscn", "transition")
