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
@onready var reset_code_container = %ResetCodeContainer
@onready var reset_password_container = %ResetPasswordContainer
@onready var anim_player = %AnimationPlayer

func _ready():
	SilentWolf.Auth.sw_request_password_reset_complete.connect(_on_request_password_complete)
	SilentWolf.Auth.sw_reset_password_complete.connect(_on_reset_password_complete)

func valid_name(n: String):
	if n.find(" ") == 1:
		return false
	return true

func display_error(error):
	if processing.visible:
		processing.visible = false

	if !error_message.visible:
		error_message.visible = true

	error_message.text = error

# Signals
func _on_send_code_pressed():
	if !valid_name(player_name.text):
		display_error("Player name can't contain spaces")
	else:
		processing.visible = true
		error_message.visible = false
		SilentWolf.Auth.request_player_password_reset(player_name.text.dedent())

func _on_request_password_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		anim_player.play("disolve")
		processing.visible = false
		reset_code_container.visible = false
		send_code_btn.visible = false
		await safe_to_load
		reset_password_container.visible = true
		reset_btn.visible = true
	else:
		processing.visible = false
		error_message.visible = true
		error_message.text = sw_result.error

func _on_reset_password_complete(sw_result: Dictionary) -> void:
	if sw_result.success:
		Globals.change_scene("res://auth/sign_in/sign_in.tscn", "transition")
	else:
		display_error(sw_result.error)

func _on_login_pressed():
	Globals.change_scene("res://auth/sign_in/sign_in.tscn", "transition")

func _on_password_toggle_toggled(toggled_on):
	password.secret = !toggled_on

func _on_confirm_password_toggle_toggled(toggled_on):
	confirm_password.secret = !toggled_on

func _on_reset_passowrd_pressed():
	if error_message.visible:
		error_message.visible = false

	processing.visible = true

	SilentWolf.Auth.reset_player_password(
			player_name.text.dedent(),
			code.text,
			password.text,
			confirm_password.text
		)
