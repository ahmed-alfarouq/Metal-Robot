extends Node

var id_token: String = ""

# Regex
@onready var email_regex = RegEx.new()

func _ready():
	email_regex.compile("(^[a-zA-Z0-9_.+-]+[a-zA-Z0-9]+@[a-zA-Z0-9]+\\.[a-zA-Z]+$)")

	# If user is signed in load the data
	Firebase.Auth.check_auth_file()
