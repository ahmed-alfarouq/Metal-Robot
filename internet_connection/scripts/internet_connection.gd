extends CanvasLayer

@onready var checking_request = $HTTPRequest
@onready var no_connection_container = %NoConnectionContainer
@onready var no_connection_label = %NoConnection
@onready var checking_connection_label = %CheckingConnection
@onready var animation = $AnimationPlayer

var user_connected = false


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
	# Wait for 0.5s
	await get_tree().create_timer(0.5).timeout
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
		checking_request.RESULT_CANT_RESOLVE:
			no_connection_label.text = "Connection Error: It seems you're not currently connected to the internet. Please establish a connection and try again."
			show_no_connection(true)
		_:
			no_connection_label.text = "Oops! It seems there's an issue with your internet connection."
			show_no_connection(true)

# Show error if the user isn't connected
func show_no_connection(visibility_state: bool):
	animation.play("disolve")
	await animation.animation_finished

	checking_connection_label.visible = !visibility_state
	no_connection_container.visible = visibility_state

	await get_tree().create_timer(0.2).timeout
	animation.play_backwards("disolve")

# Signals
func _on_try_again_pressed():
	show_no_connection(false)
	await get_tree().create_timer(0.5).timeout
	checking_request.request("https://google.com")

func _on_request_timeout():
	checking_request.cancel_request()
	show_no_connection(true)
