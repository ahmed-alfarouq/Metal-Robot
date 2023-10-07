extends Control

var user_connected = false

@onready var checking_request = %HTTPRequest
@onready var checking_connection_label = %CheckingConnection


# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect _on_checking_completed when testing completed
	checking_request.request_completed.connect(_on_checking_completed)
	# Connect userdata_received
	Firebase.Auth.userdata_received.connect(establish_user_direction)
	# Connect userdata_deleted
	Firebase.Auth.userdata_deleted.connect(change_scene_to_login)
	# Connect user_not_loggedin
	Firebase.Auth.user_not_loggedin.connect(change_scene_to_login)
	# Check if player connected to the internet
	checking_request.request("https://google.com")

# Establish user direction depending on user data
func establish_user_direction(user_data):
	if user_connected && not Firebase.Auth.is_logged_in():
		SceneTransition.transition(self, "res://auth/sign_in/sign_in.tscn")
	elif user_connected && not user_data.email_verified:
		SceneTransition.transition(self, "res://auth/email_verification/email_verification.tscn")
	else:
		SceneTransition.transition(self, "res://menus/main_menu.tscn")

# Change scene to login if there's no user data
func change_scene_to_login():
	SceneTransition.transition(self, "res://auth/sign_in/sign_in.tscn")

# Decide what to do based on whether the user is connected to the internet or not
func _on_checking_completed(result, _response_code, _headers, _body):
	match result:
		checking_request.RESULT_SUCCESS:
			# If the player is connected to the internet, get user data.
			Firebase.Auth.get_user_data()
			user_connected = true
		_:
			SceneTransition.transition(self, "res://internet_connection/no_connection.tscn")

func _on_request_timeout():
	checking_connection_label.text = "Time out"
	checking_request.cancel_request()
	SceneTransition.transition(self, "res://internet_connection/no_connection.tscn")
