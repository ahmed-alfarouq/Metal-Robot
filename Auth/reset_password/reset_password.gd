extends Control

@onready var email = $Email
@onready var error_message = $ErrorMessage
@onready var email_sent_message = $EmailSent
@onready var send_btn = $SendEmail

func _on_send_email_pressed():
	var result = Globals.email_regex.search(email.text)

	if result:
		Firebase.Auth.send_password_reset_email(email.text)
		error_message.text = ""
		email_sent_message.text = "An email has been sent to your inbox with instructions to reset your password."
		send_btn.disabled = true
	elif email.text.is_empty():
		error_message.text = "This field can not be empty."
	else:
		error_message.text = "Please, enter a valid email."


func _on_login_pressed():
	Globals.change_scene("res://auth/sign_in/sign_in.tscn", "transition")
