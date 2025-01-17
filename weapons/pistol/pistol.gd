extends Ranged

@onready var extended_mag: RangedStatKit = preload("res://weapons/pistol/kits/pistol_extended_mag.tres")
@onready var fast_bullet: RangedEmissionKit = preload("res://weapons/pistol/kits/fast_bullet_update.tres")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()

	if Input.is_action_just_pressed("reload"):
		reload()

	if Input.is_action_just_pressed("equip"):
		if has_stat_kit(extended_mag):
			equip_stat_kit(extended_mag)
		else:
			unequip_stat_kit(extended_mag)

#	if Input.is_action_just_pressed("equip_bullet"):
#		equip_emission_kit(fast_bullet)
