extends Control

@onready var email = $Email
@onready var password = $Password
@onready var error_message = $ErrorMessage

func _ready():
	Firebase.Auth.login_succeeded.connect(login_completed)
	Firebase.Auth.login_failed.connect(login_failed)

func _on_sign_in_pressed():
	var result = Globals.email_regex.search(email.text)

	if (email.text.is_empty()):
		error_message.text = "Email can't be empty."
	elif (!result):
		error_message.text = "Please, enter a valid email"
	elif (password.text.is_empty()):
		error_message.text = "Password can't be empty"
	else:
		Firebase.Auth.login_with_email_and_password(email.text, password.text)

func login_completed(auth_info):
	Firebase.Auth.save_auth(auth_info)
	Globals.change_scene("res://menus/main_menu.tscn", "transition")

func login_failed(_code, message):
	if (message == "INVALID_EMAIL"):
		error_message.text = "Please, enter a valid email"
	elif (message == "INVALID_LOGIN_CREDENTIALS"):
		error_message.text = "Invalid Email or Password. Please try again"
	elif (message == "USER_DISABLED"):
		error_message.text = "Access Denied: Your account has been temporarily suspended from the game. \n Please contact support for further information."
	else:
		error_message.text = "Kindly reach out to us and provide the following error message. \n" + message


func _on_forget_password_pressed():
	Globals.change_scene("res://auth/reset_password/reset_password.tscn", "transition")


func _on_create_account_pressed():
	Globals.change_scene("res://auth/sign_up/sign_up.tscn", "transition")
