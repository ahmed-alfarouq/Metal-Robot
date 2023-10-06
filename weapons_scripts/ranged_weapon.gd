class_name RagedWeapon

extends Weapon

func _shooting(reload_time: float):
	weapon_animation.play("shooting")
	await get_tree().create_timer(reload_time).time_out
	_reload(reload_time)

func _reload(reload_time):
	weapon_animation.play("reload")
	await weapon_animation.animation_finished
	_shooting(reload_time)


