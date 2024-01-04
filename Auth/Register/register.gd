extends Control
@onready var player_name = %PlayerName
@onready var email = %Email
@onready var password = %Password
@onready var confirm_password = %ConfirmPassword
@onready var error_message = %ErrorMessage
@onready var processing = %Processing
@onready var register_btn = %Register

func _ready():
	# Connect signup signal
	SilentWolf.Auth.sw_registration_complete.connect(_on_registration_complete)

# Singals
func _on_register_pressed():
	if !Globals.valid_player_name(player_name.text):
		error_message.visible = true
		error_message.text = "Player name can't contain spaces"
	else:
		error_message.visible = false
		processing.visible = true
		register_btn.disabled = true
		SilentWolf.Auth.register_player(player_name.text.dedent(), email.text, password.text, confirm_password.text)

func _on_log_in_pressed():
	Globals.change_scene("res://auth/sign_in/sign_in.tscn", "transition")

func _on_password_toggle_toggled(toggled_on):
	password.secret = !toggled_on

func _on_confirm_password_toggle_toggled(toggled_on):
	confirm_password.secret = !toggled_on

func _on_registration_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		Globals.change_scene("res://auth/email_verification/email_verification.tscn", "transition")
	else:
		error_message.visible = true
		processing.visible = false
		register_btn.disabled = false
		error_message.text = str(sw_result.error)
