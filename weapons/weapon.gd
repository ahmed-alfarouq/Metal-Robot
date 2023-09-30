extends Node

class_name Weapon

@export var sprites: SpriteFrames

func _ready():
	_shooting()

func _equip(anim_ame: String, weapon_name: String, bullets: int):
	pass

func _drop():
	pass

func _shooting():
	var i: int = 0
	while i <= sprites.get_frame_count("default"):
		$weapon_sprite.texture = sprites.get_frame_texture("default", i)
		i += 1
		await get_tree().create_timer(0.5).timeout

func _reaload():
	pass

# Enter the weapon state
func _enter():
	pass

# Exit the weapon state
func _exit():
	pass
