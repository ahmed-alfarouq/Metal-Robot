extends Control

@onready var verif_code = %VerifCode
@onready var error_message = %ErrorMessage
@onready var alert_message = %AlertMessage
@onready var processing = %Processing
@onready var submit_btn = %Submit
@onready var resend_btn = %ResendCode

func _ready():
	SilentWolf.Auth.sw_email_verif_complete.connect(_on_confirmation_complete)
	SilentWolf.Auth.sw_resend_conf_code_complete.connect(_on_resend_code_complete)

func display_error(error):
	alert_message.visible = false
	processing.visible = false
	submit_btn.disabled = false
	resend_btn.disabled = false
	error_message.visible = true
	error_message.text = error

# Signals
func _on_submit_pressed():
	var player_name = SilentWolf.Auth.tmp_username
	error_message.visible = false
	processing.visible = true
	submit_btn.disabled = true
	resend_btn.disabled = true
	if player_name:
		SilentWolf.Auth.verify_email(player_name, verif_code.text)

func _on_resend_code_pressed():
	submit_btn.disabled = true
	resend_btn.disabled = true
	var player_name = SilentWolf.Auth.tmp_username
	if player_name:
		SilentWolf.Auth.resend_conf_code(player_name)

func _on_confirmation_complete(sw_result: Dictionary) -> void:
	var error = sw_result.error
	if sw_result.success:
		processing.visible = false
		Globals.change_scene("res://menus/main_menu.tscn", "transition")
	elif error.contains("[\\S]+"):
		display_error("email verification failed: Code can't contain spaces")
	elif error.contains("ConfirmationCode, value: 0, valid min length: 1"):
		display_error("Code can't be empty")
	else:
		display_error("email verification failed: " + error)

func _on_resend_code_complete(sw_result: Dictionary) -> void:
	resend_btn.disabled = false
	if sw_result.success:
		alert_message.visible = true
		error_message.visible = false
		submit_btn.disabled = false
		resend_btn.disabled = false
		alert_message.text = "Code resend successful for player: " + SilentWolf.Auth.tmp_username
	else:
		display_error("Code resend failed for player: " + SilentWolf.Auth.tmp_username)
