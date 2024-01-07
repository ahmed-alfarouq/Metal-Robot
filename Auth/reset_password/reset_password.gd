extends Control

# emitted when it's safe to show fields
signal safe_to_load

@onready var player_name = %PlayerName
@onready var password = %Password
@onready var confirm_password = %ConfirmPassword
@onready var code = %Code
@onready var error_message = %ErrorMessage
@onready var processing = %Processing
@onready var send_code_btn = %SendCode
@onready var reset_btn = %ResetPassowrd
@onready var login_btn = %Login
@onready var reset_code_container = %ResetCodeContainer
@onready var reset_password_container = %ResetPasswordContainer
@onready var anim_player = %AnimationPlayer

func _ready():
	SilentWolf.Auth.sw_request_password_reset_complete.connect(_on_request_password_complete)
	SilentWolf.Auth.sw_reset_password_complete.connect(_on_reset_password_complete)

func display_error(error):
	processing.visible = false
	error_message.visible = true
	login_btn.disabled = false
	send_code_btn.disabled = false
	reset_btn.disabled = false
	error_message.text = error

# Signals
func _on_send_code_pressed():
	send_code_btn.disabled = true
	login_btn.disabled = true

	if !Globals.valid_player_name(player_name.text):
		display_error("Player name can't contain spaces.")
	else:
		processing.visible = true
		error_message.visible = false
		SilentWolf.Auth.request_player_password_reset(player_name.text.dedent().to_upper())

func _on_reset_passowrd_pressed():
	reset_btn.disabled = true
	if error_message.visible:
		error_message.visible = false

	processing.visible = true

	SilentWolf.Auth.reset_player_password(
			player_name.text.dedent().to_upper(),
			code.text,
			password.text,
			confirm_password.text
		)

func _on_login_pressed():
	Globals.change_scene("res://auth/log_in/log_in.tscn", "transition")

func _on_password_toggle_toggled(toggled_on):
	password.secret = !toggled_on

func _on_confirm_password_toggle_toggled(toggled_on):
	confirm_password.secret = !toggled_on

func _on_request_password_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		anim_player.play("disolve")
		processing.visible = false
		reset_code_container.visible = false
		send_code_btn.visible = false
		login_btn.disabled = false
		await safe_to_load
		reset_password_container.visible = true
		reset_btn.visible = true
	else:
		send_code_btn.disabled = false
		login_btn.disabled = false
		processing.visible = false
		error_message.visible = true
		error_message.text = sw_result.error

func _on_reset_password_complete(sw_result: Dictionary) -> void:
	var error = sw_result.error
	if sw_result.success:
		Globals.change_scene("res://auth/log_in/log_in.tscn", "transition")
	elif error.contains("Password must have numeric characters"):
		display_error("Password must have at least one number")
	elif error.contains("Password must have uppercase characters"):
		display_error("Password must have at least one uppercase character")
	else:
		display_error(error)
