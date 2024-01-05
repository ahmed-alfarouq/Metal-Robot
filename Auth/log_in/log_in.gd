extends Control

@onready var player_name = %PlayerName
@onready var password = %Password
@onready var error_message = %ErrorMessage
@onready var processing = %Processing
@onready var login_btn = %LogIn

func _ready():
	SilentWolf.Auth.sw_login_complete.connect(_on_login_complete)

# Signals
func _on_login_pressed():
	processing.visible = true
	error_message.visible = false
	login_btn.disabled = true

	if !Globals.valid_player_name(player_name.text):
		error_message.visible = true
		error_message.text = "Player name can't contain spaces"
	else:
		SilentWolf.Auth.login_player(player_name.text.dedent(), password.text, true)

func _on_forget_password_pressed():
	Globals.change_scene("res://auth/reset_password/reset_password.tscn", "transition")

func _on_create_account_pressed():
	Globals.change_scene("res://auth/register/register.tscn", "transition")

func _on_password_toggle_toggled(toggled_on):
	password.secret = !toggled_on

func _on_login_complete(sw_result: Dictionary) -> void:
	login_btn.disabled = false
	var error = sw_result.error
	if sw_result.success:
		Globals.player_name = SilentWolf.Auth.logged_in_player
		Globals.load_best_score()
		Globals.change_scene("res://menus/main_menu.tscn", "transition")
	elif error.contains("User is not confirmed"):
		SilentWolf.Auth.tmp_username = player_name.text.dedent()
		Globals.change_scene("res://auth/email_verification/email_verification.tscn", "transition")
	elif error.contains("Missing required parameter USERNAME"):
		processing.visible = false
		error_message.visible = true
		error_message.text = "Error: Player name can't be empty"
	elif error.contains("Missing required parameter PASSWORD"):
		processing.visible = false
		error_message.visible = true
		error_message.text = "Error: Password can't be empty"
	else:
		processing.visible = false
		error_message.visible = true
		error_message.text = "Error: " + error
