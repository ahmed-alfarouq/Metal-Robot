extends Control

@onready var verif_code = %VerifCode
@onready var error_message = %ErrorMessage
@onready var warning_message = %WarningMessage
@onready var processing = %Processing

func _ready():
	SilentWolf.Auth.sw_email_verif_complete.connect(_on_confirmation_complete)
	SilentWolf.Auth.sw_resend_conf_code_complete.connect(_on_resend_code_complete)

# Signals
func _on_submit_pressed():
	var player_name = SilentWolf.Auth.tmp_username
	processing.visible = true
	if player_name:
		SilentWolf.Auth.verify_email(player_name, verif_code.text)

func _on_resend_code_pressed():
	var player_name = SilentWolf.Auth.tmp_username
	if player_name:
		SilentWolf.Auth.resend_conf_code(player_name)

func _on_confirmation_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		processing.visible = false
		warning_message.text = "email verification succeeded!"
		Globals.change_scene("res://menus/main_menu.tscn", "transition")
	else:
		warning_message.visible = false
		error_message.visible = true
		error_message.text = "email verification failed: " + str(sw_result.error)

func _on_resend_code_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		warning_message.visible = true
		error_message.visible = false
		warning_message.text = "Code resend successful for player: " + str(SilentWolf.Auth.tmp_username)
	else:
		warning_message.visible = false
		error_message.visible = true
		error_message.text = "Code resend failed for player: " + str(SilentWolf.Auth.tmp_username)
