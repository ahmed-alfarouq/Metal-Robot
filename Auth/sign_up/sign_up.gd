extends CanvasLayer

@onready var email = $Email
@onready var password = $Password
@onready var error_message = $ErrorMessage

func _ready():
	# Connect signup signal
	Firebase.Auth.send_account_verification_email_completed.connect(email_verification_completed)
	Firebase.Auth.signup_succeeded.connect(signup_completed)
	Firebase.Auth.signup_failed.connect(signup_failed)

func _on_button_pressed():
	var result = Globals.email_regex.search(email.text)

	if (email.text.is_empty()):
		error_message.text = "Email can't be empty."
	elif (!result):
		error_message.text = "Please, enter a valid email"
	elif (password.text.is_empty()):
		error_message.text = "Password can't be empty"
	elif (password.text.length() < 6):
		error_message.text = "Password should be at least 6 characters"
	else:
		Firebase.Auth.signup_with_email_and_password(email.text, password.text)

func signup_completed(auth_info):
	Firebase.Auth.save_auth(auth_info)
	Firebase.Auth.send_account_verification_email()

func signup_failed(_code, message):
	if (message == "INVALID_EMAIL"):
		error_message.text = "Please, enter a valid email"

	elif (message == "EMAIL_EXISTS"):
		error_message.text = "The email already exists."
	else:
		error_message.text = "Kindly reach out to us and provide the following error message. \n" + message

func email_verification_completed(message):
	if (message.is_empty()):
		SceneTransition.transition("res://auth/email_verification/email_verification.tscn")
	else:
		error_message.text = "An error occurred. Kindly get in touch with us and provide the following message. \n" + message

# Singals

func _on_log_in_pressed():
	SceneTransition.transition("res://auth/sign_in/sign_in.tscn")
