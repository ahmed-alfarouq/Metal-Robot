extends Node2D

var pressed = false
var pos_vector = Vector2(0, 0)

@export var max_length = 12
@export var dead_zone = 5

@onready var joystick_inner = $JoystickInner

func _ready():
	max_length *= scale.x

func _process(delta):
	if pressed:
		if get_global_mouse_position().distance_to(global_position) <= max_length:
			joystick_inner.global_position = get_global_mouse_position()
		else:
			var angle = global_position.angle_to_point(get_global_mouse_position())
			joystick_inner.global_position.x = global_position.x + cos(angle) * max_length
			joystick_inner.global_position.y = global_position.y + sin(angle) * max_length
		calculateVector()
	else:
		joystick_inner.global_position = lerp(joystick_inner.global_position, global_position, delta * 40)
		pos_vector = Vector2(0, 0)

func calculateVector():
	if abs(joystick_inner.global_position.x - global_position.x) >= dead_zone:
		pos_vector.x = (joystick_inner.global_position.x - global_position.x) / max_length

	if abs(joystick_inner.global_position.y - global_position.y) >= dead_zone:
		pos_vector.y = (joystick_inner.global_position.y - global_position.y) / max_length

func _on_button_button_down():
	pressed = true

func _on_button_button_up():
	pressed = false
