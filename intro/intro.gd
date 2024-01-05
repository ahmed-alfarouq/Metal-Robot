extends Control

@onready var checking_request = %HTTPRequest
@onready var anim_player = %AnimationPlayer

func _ready():
	anim_player.play("enter_scene")
	await anim_player.animation_finished
	anim_player.play("moving_up_down")

	# Connect _on_checking_completed when testing completed
	checking_request.request_completed.connect(_on_checking_completed)
	SilentWolf.Auth.sw_session_check_complete.connect(_on_session_check_complete)
	checking_request.request("https://google.com")

# Decide what to do based on whether the user is connected to the internet or not
func _on_checking_completed(result, _response_code, _headers, _body):
	match result:
		checking_request.RESULT_SUCCESS:
			SilentWolf.Auth.auto_login_player()
		_:
			Globals.change_scene("res://internet_connection/no_connection.tscn", "transition")

func _on_session_check_complete(sw_result):
	if sw_result == null:
		Globals.change_scene("res://auth/log_in/log_in.tscn", "transition")
	else:
		Globals.player_name = SilentWolf.Auth.logged_in_player
		Globals.load_best_score()
		Globals.change_scene("res://menus/main_menu.tscn", "transition")

func _on_request_timeout():
	checking_request.cancel_request()
	Globals.change_scene("res://internet_connection/no_connection.tscn", "transition")
