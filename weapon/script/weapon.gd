class_name Weapon
extends Node

signal weapon_entered
signal weapon_exited
signal weapon_unequiped

var weapon_info: Dictionary

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var weapon_sprite: AnimatedSprite2D = $WeaponSprite
@onready var raycast: RayCast2D = $RayCast2D


func _process(_delta):
	if (raycast.is_colliding()):
		print("Colliding")

func enter(weapon_sprites: SpriteFrames, weapon_data: Dictionary, player_sprites: SpriteFrames):
	weapon_info = weapon_data
	# Add animation
	player_sprite.sprite_frames = player_sprites
	weapon_sprite.sprite_frames = weapon_sprites
	# Show sprites
	player_sprite.visible = true
	weapon_sprite.visible = true
	# Enable raycast
	raycast.enabled = true
	# Emit signal
	weapon_entered.emit()
	# Equip weapon
	equip()

func equip():
	# Play equip animation
	weapon_sprite.play("equip")
	player_sprite.play("equip")

	# You can wait for one of them because they take the same time
	await weapon_sprite.animation_finished

	# Start shooting after equiping finishes
	player_sprite.shooting(weapon_info["bullets"], weapon_info["reload_times"])
	weapon_sprite.shooting(weapon_info["bullets"], weapon_info["reload_times"])

func unequip():
	weapon_sprite.play("unequip")
	player_sprite.play("unequip")

	# You can wait for one of them because they take the same time
	await weapon_sprite.animation_finished
	exit()

func exit():
	# Hide sprites
	player_sprite.visible = false
	weapon_sprite.visible = false
	# Disable raycast
	raycast.enabled = false
	weapon_exited.emit()
