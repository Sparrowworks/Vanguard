class_name WeaponStatKit extends Resource

## Base [Resource] for [Weapon] stat modifiers.
##
## Holds the values used to increase or decrease [Weapon] stats.
## Used in conjunction with [method Weapon.equip_stat_kit].
## [br][br]To create a new kit (or attachment), create a custom [Resource] and assign it this [Script].
## Fill in the stats and [method Weapon.equip_stat_kit] will take care of the math.

## The amount to increase or decrease [member Weapon.charge_rate]
@export var charge_rate_modifier: float
## The amount to increase or decrease [member Weapon.attack_rate]
@export var attack_rate_modifier: float
## The amount to increase or decrease [member Weapon.refill_rate]
@export var refill_rate_modifier: float
