class_name Weapon
extends Node

signal weapon_entered
signal weapon_exited
signal weapon_unequiped

var weapon_info: Dictionary
var reloading: bool = false
var equiping: bool = false
var unequiping: bool = false

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var weapon_sprite: AnimatedSprite2D = $WeaponSprite
@onready var raycast: RayCast2D = $RayCast2D


func _physics_process(_delta):
	if (raycast.is_colliding()):
		var pipes = ["TopPipe", "BottomPipe"]
		var collider = raycast.get_collider()
	
		# if collider name matches,then take damage
		if (
			is_instance_valid(collider) &&
			pipes.has(collider.name) &&
			not reloading &&
			not equiping &&
			not unequiping
			):
			collider.get_parent().take_damage(collider.name)


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
	equiping = true
	# Play equip animation
	weapon_sprite.play("equip")
	player_sprite.play("equip")

	# You can wait for one of them because they take the same time
	await weapon_sprite.animation_finished
	equiping = false
	# Start shooting after equiping finishes
	player_sprite.shooting(weapon_info["bullets"], weapon_info["reload_times"])
	weapon_sprite.shooting(weapon_info["bullets"], weapon_info["reload_times"])

func unequip():
	unequiping = true
	player_sprite.play("unequip")

	# You can wait for one of them because they take the same time
	await player_sprite.animation_finished
	unequiping = false
	exit()

func exit():
	# Hide sprites
	player_sprite.visible = false
	weapon_sprite.visible = false

	# Disable raycast
	raycast.enabled = false
	weapon_exited.emit()

func _on_player_dies():
	queue_free()
	weapon_exited.emit()
