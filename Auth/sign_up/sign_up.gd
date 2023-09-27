extends CanvasLayer

@onready var email = $Email
@onready var password = $Password

func _ready():
	# Connect signup signal
	Firebase.Auth.signup_succeeded.connect(signup_completed)
	Firebase.Auth.signup_failed.connect(signup_failed)

func _on_button_pressed():
	Firebase.Auth.signup_with_email_and_password(email.text, password.text)

func signup_completed(auth_info):
	Globals.id_token = auth_info.idtoken

func signup_failed(_code, message):
	if (message == "INVALID_EMAIL"):
		print("Please, enter a valid email")
	elif (message == "MISSING_PASSWORD"):
		print("Password can't be empy")
	elif (message == "WEAK_PASSWORD : Password should be at least 6 characters"):
		print("Password should be at least 6 characters")
	else:
		print(message)
