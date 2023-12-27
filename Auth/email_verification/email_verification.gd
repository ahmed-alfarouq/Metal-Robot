extends Control

@onready var message_label = $CanvasLayer/Message
@onready var time_left_message = $CanvasLayer/TimeLeft
@onready var resend_btn = $CanvasLayer/ResendVerification
@onready var checker_btn = $CanvasLayer/CheckVerification
@onready var resend_timer = $ResendVerificationTimer

func _ready():
	# Connect send_account_verification_email_completed
	Firebase.Auth.send_account_verification_email_completed.connect(email_verification_completed)
	# Connect userdata_received
	Firebase.Auth.userdata_received.connect(email_verification_checking_completed)

func _process(_delta):
	if (not resend_timer.is_stopped() && resend_btn.disabled):
		time_left_message.text = "You can resend the verification email in: " + str(floor(resend_timer.time_left)) + "s"
	else:
		time_left_message.text = ""

func email_verification_completed(message):
	if (message.is_empty()):
		message_label.text = "Verification Email Sent Successfully"
	else:
		message_label.text = "An error occurred. Kindly get in touch with us and provide the following message. \n" + message

func email_verification_checking_completed(user_data):
	if (user_data.email_verified):
		Globals.change_scene("res://menus/main_menu.tscn", "transition")
	else:
		message_label.text = "It seems you haven't verified your email yet. Please go ahead and verify it."

# Signals
func _on_resend_verification_pressed():
	Firebase.Auth.send_account_verification_email()
	resend_btn.disabled = true
	resend_timer.start()


func _on_resend_verification_timeout():
	message_label.text = "If you haven't received the Verification Email, please try resending it."
	resend_btn.disabled = false
	checker_btn.disabled = false


func _on_check_verification_pressed():
	Firebase.Auth.get_user_data()
	checker_btn.disabled = true
