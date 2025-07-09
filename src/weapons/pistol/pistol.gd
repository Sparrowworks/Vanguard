extends Ranged

@onready var extended_mag: RangedStatKit = preload("uid://bgb07ch4jt7vq")
@onready var fast_bullet: RangedEmissionKit = preload("uid://d4jmtu18rfu1w")


func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		attack()

	if Input.is_action_just_pressed("reload"):
		refill()

	if Input.is_action_just_pressed("equip"):
		if has_stat_kit(extended_mag):
			equip_stat_kit(extended_mag)
		else:
			unequip_stat_kit(extended_mag)

#	if Input.is_action_just_pressed("equip_bullet"):
#		equip_emission_kit(fast_bullet)
