extends Control

func _ready():
	SilentWolf.Auth.sw_logout_complete.connect(_on_log_out_complete)
	SilentWolf.Auth.sw_session_check_complete.connect(_on_session_check_complete)
	SilentWolf.Auth.auto_login_player()
	await SilentWolf.Auth.auto_login_player().sw_session_check_complete

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

func _on_session_check_complete(sw_result):
	if sw_result == null:
		Globals.change_scene("res://auth/sign_in/sign_in.tscn", "transition")
	else:
		print(SilentWolf.Auth.logged_in_player)
