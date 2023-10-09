extends AnimatedSprite2D

class_name PLAYER_ANIMATION

var prev_animation_state: String = "flying_up"

func boom():
	play("boom")
	await animation_finished
	queue_free()

func flying_up():
	if (prev_animation_state == "flying_down"):
		play("flying_transition")
		await animation_finished
		play("flying_up")
		prev_animation_state = "flying_up"
	else:
		play("flying_up")

func flying_down():
	if (prev_animation_state == "flying_up"):
		play_backwards("flying_transition")
		await animation_finished
		play("flying_down")
		prev_animation_state = "flying_down"
	else:
		play("flying_down")

func scream():
	play("screaming")
	await animation_finished
	play(prev_animation_state)
