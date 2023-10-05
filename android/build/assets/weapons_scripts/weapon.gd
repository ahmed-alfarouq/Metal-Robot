class_name Weapon

extends Node

signal weapon_entered

@onready var weapon_animation = $WeaponAnim

func _enter(frames_resource: SpriteFrames):
	weapon_animation.sprite_frames = frames_resource
	weapon_entered.emit()
	print("weapong base")

func equip():
	weapon_animation.play("equip")

func drop():
	weapon_animation.play("drop")

func exit():
	weapon_animation.sprite_frames = SpriteFrames
