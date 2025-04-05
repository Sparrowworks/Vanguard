class_name RangedStatKit extends WeaponStatKit

## Base [Resource] for [Ranged] stat modifiers.
##
## Holds the values used to increase or decrease [Weapon] stats.
## Used in conjunction with [method Weapon.equip_stat_kit].
## [br]
## [br]To create a new kit (or attachment), create a custom [Resource] and assign it this [Script].
## Fill in the stats and [method Ranged.equip_stat_kit] will take care of the math.

## The amount to increase or decrease [member Ranged.mag_size].
@export var mag_size_modifier: int
## The amount to increase or decrease [member Ranged.max_ammo].
@export var max_ammo_modifier: int
## The amount to increase or decrease [member Ranged.refill_rate_empty].
@export var refill_rate_empty_modifier: float
