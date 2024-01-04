extends Control

var possible_errors = [
	"Unknown error An error occurred (InvalidParameterException) when calling the ConfirmSignUp operation: 1 validation error detected: Value '{code}' at 'confirmationCode' failed to satisfy constraint: Member must satisfy regular expression pattern: [\\S]+",
]

@onready var verif_code = %VerifCode
@onready var error_message = %ErrorMessage
@onready var warning_message = %WarningMessage
@onready var processing = %Processing
@onready var submit_btn = %Submit
@onready var resend_btn = %ResendCode

func _ready():
	SilentWolf.Auth.sw_email_verif_complete.connect(_on_confirmation_complete)
	SilentWolf.Auth.sw_resend_conf_code_complete.connect(_on_resend_code_complete)

# Signals
func _on_submit_pressed():
	var player_name = SilentWolf.Auth.tmp_username
	error_message.visible = false
	processing.visible = true
	submit_btn.disabled = true
	if player_name:
		SilentWolf.Auth.verify_email(player_name, verif_code.text)

func _on_resend_code_pressed():
	resend_btn.disabled = true
	var player_name = SilentWolf.Auth.tmp_username
	if player_name:
		SilentWolf.Auth.resend_conf_code(player_name)

func _on_confirmation_complete(sw_result: Dictionary) -> void:
	var error = sw_result.error
	if sw_result.success:
		processing.visible = false
		warning_message.text = "email verification succeeded!"
		Globals.change_scene("res://menus/main_menu.tscn", "transition")
	elif error.contains("[\\S]+"):
		warning_message.visible = false
		processing.visible = false
		error_message.visible = true
		submit_btn.disabled = false
		error_message.text = "email verification failed: Code can't contain spaces"
	else:
		warning_message.visible = false
		processing.visible = false
		error_message.visible = true
		submit_btn.disabled = false
		error_message.text = "email verification failed: " + error

func _on_resend_code_complete(sw_result: Dictionary) -> void:
	resend_btn.disabled = false
	if sw_result.success:
		warning_message.visible = true
		error_message.visible = false
		warning_message.text = "Code resend successful for player: " + str(SilentWolf.Auth.tmp_username)
	else:
		warning_message.visible = false
		error_message.visible = true
		error_message.text = "Code resend failed for player: " + str(SilentWolf.Auth.tmp_username)
