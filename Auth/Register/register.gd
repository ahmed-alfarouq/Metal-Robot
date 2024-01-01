extends Control
@onready var player_name = %PlayerName
@onready var email = %Email
@onready var password = %Password
@onready var confirm_password = %ConfirmPassword
@onready var error_message = %ErrorMessage
@onready var processing = %Processing

func _ready():
	# Connect signup signal
	SilentWolf.Auth.sw_registration_complete.connect(_on_registration_complete)

func _on_registration_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		Globals.change_scene("res://auth/email_verification/email_verification.tscn", "transition")
	else:
		error_message.visible = true
		processing.visible = false
		error_message.text = str(sw_result.error)

# Singals
func _on_register_pressed():
	if player_name.text.find(" ") == 1:
		error_message.visible = true
		error_message.text = "Player name can't contain spaces"
	else:
		error_message.visible = false
		processing.visible = true
		SilentWolf.Auth.register_player(player_name.text, email.text, password.text, confirm_password.text)

func _on_log_in_pressed():
	Globals.change_scene("res://auth/sign_in/sign_in.tscn", "transition")

func _on_password_toggle_toggled(toggled_on):
	password.secret = !toggled_on

func _on_confirm_password_toggle_toggled(toggled_on):
	confirm_password.secret = !toggled_on
