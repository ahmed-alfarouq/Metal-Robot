class_name RagedWeapon

extends AnimatedSprite2D

var weapon_bullets: int
var weapon_reload_times: int

@onready var weapon = get_parent()

func shooting(bullets, reload_times):
	weapon_bullets = bullets
	weapon_reload_times = reload_times
	for i in bullets:
		play("shooting")
		await animation_finished
		# if i ==  - 1 then reload
		if (i ==  bullets - 1 && weapon_reload_times > 0):
			reload()
		elif (i ==  bullets - 1 && weapon_reload_times == 0):
			weapon.unequip()

func reload():
	weapon.reloading = true
	play("reload")
	await animation_finished
	weapon_reload_times -= 1
	weapon.reloading = false
	shooting(weapon_bullets, weapon_reload_times)
