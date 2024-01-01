extends Control

@onready var player_name = %PlayerName
@onready var password = %Password
@onready var error_message = %ErrorMessage
@onready var processing = %Processing

func _ready():
	SilentWolf.Auth.sw_login_complete.connect(_on_login_complete)

# Signals
func _on_login_pressed():
	processing.visible = true
	error_message.visible = false
	SilentWolf.Auth.login_player(player_name.text, password.text, true)

func _on_forget_password_pressed():
	Globals.change_scene("res://auth/reset_password/reset_password.tscn", "transition")

func _on_create_account_pressed():
	Globals.change_scene("res://auth/sign_up/sign_up.tscn", "transition")

func _on_password_toggle_toggled(toggled_on):
	password.secret = !toggled_on

func _on_login_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		Globals.change_scene("res://menus/main_menu.tscn", "transition")
	else:
		processing.visible = false
		error_message.visible = true
		error_message.text = "Error: " + str(sw_result.error)
