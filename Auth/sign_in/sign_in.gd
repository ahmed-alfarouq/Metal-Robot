extends CanvasLayer

@onready var email = $Email
@onready var password = $Password

func _ready():
	Firebase.Auth.login_succeeded.connect(login_completed)
	Firebase.Auth.login_failed.connect(login_failed)

func _on_sign_in_pressed():
	Firebase.Auth.login_with_email_and_password(email.text, password.text)

func login_completed(auth_info):
	if (!Firebase.Auth.check_auth_file()):
		Firebase.Auth.save_auth(auth_info)
	else:
		print(Firebase.Auth.load_auth())

func login_failed(_code, message):
	if (message == "INVALID_EMAIL"):
		print("Please, enter a valid email")
	elif (message == "MISSING_PASSWORD"):
		print("Password can't be empy")
	elif (message == "INVALID_LOGIN_CREDENTIALS"):
		print("Invalid Email or Password. Please try again")
	elif (message == "USER_DISABLED"):
		print("Access Denied: Your account has been temporarily suspended from the game. Please contact support for further information.")
	else:
		print(message)
