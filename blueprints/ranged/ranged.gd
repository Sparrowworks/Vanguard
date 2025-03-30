class_name Ranged extends Weapon

## Base class for ranged weapons
##
## The Ranged class represents a weapon system in a 2D game using Godot's Node structure.
## It manages weapon stats such as magazine size, ammo count, reload times, and firing rates.
## This class is designed to handle various weapon functionalities, including shooting and reloading.

#region Initiliazation logic
@export_group("Gun Emissions")
## Slot for field
@export var field:PackedScene
## Slot for projectile
@export var projectile:PackedScene

func _ready() -> void:
	current_mag = mag_size
	current_ammo = max_ammo

	if (projectile == null):
		printerr("Undefined Projectile")
		return

	super._ready()
#endregion

#region Ranged functionality
@export_category("Ranged stats")
## The maximum number of rounds that can be held in the weapon's magazine.
@export var max_ammo:int
## The total amount of ammunition available for the weapon.
@export var mag_size:int
## Addtional time (in milliseconds) it takes to reload the weapon when the magazine is empty.
@export var refill_rate_empty:float

## The current amount of ammunition available for use.
## Decreases when reloading based on magazine size and available ammo.
var current_ammo:int
## The number of rounds currently loaded in the weapon's magazine.
## Decreases with each shot fired and increases during reloading
## until it reaches its maximum capacity (mag_size).
var current_mag:int

## The shoot() method is responsible for handling the firing mechanism of the weapon.
## If there is no ammunition, it will reload.
## If the weapon is currently firing or reloading, it exits without firing.
func attack() -> void:
	super.attack()

	add_child(projectile.instantiate())
	add_child(field.instantiate())
	current_mag -= 1

## The reload() method is responsible for reloading the weapon's magazine with ammunition.
## If the magazine is full or there is no ammunition left or the weapon is currently firing or reloading,
## the method will exit without reloading.
func refill() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.REFILLING
	if (current_mag == 0):
		weapon_timer.wait_time = refill_rate + refill_rate_empty
	else:
		weapon_timer.wait_time = refill_rate

	var ammo_to_load = min(mag_size - current_mag, current_ammo)
	current_ammo -= ammo_to_load
	current_mag += ammo_to_load

	weapon_timer.start()
#endregion

#region Stat kit
## Emitted when a stat kit has been equipped.
## It provides information about the equipped stat kit.
signal stat_kit_equipped(kit:RangedStatKit)
## Emitted when a stat kit has been unequipped.
## It provides information about the unequipped stat kit.
signal stat_kit_unequipped(kit:RangedStatKit)

## A list containing the names of currently equipped modifications
var equipped_kits:Array[String]
## Modifies weapon stats by providing a kit.
func equip_stat_kit(kit:RangedStatKit) -> void:
	if has_stat_kit(kit):
		print("kit already installed")
		return

	equipped_kits.append(kit.kit_name)
	mag_size += kit.mag_size_modifier if kit.mag_size_modifier != 0 else mag_size
	max_ammo += kit.max_ammo_modifier if kit.max_ammo_modifier != 0 else max_ammo
	refill_rate += kit.reload_time_modifier if kit.reload_time_modifier != 0 else refill_rate
	refill_rate_empty += kit.reload_time_empty_modifier if kit.reload_time_empty_modifier != 0 else refill_rate_empty
	attack_rate += kit.fire_rate_modifier if kit.fire_rate_modifier != 0 else attack_rate

	stat_kit_equipped.emit(kit)

## Reverses the changes made by equip_kit
func unequip_stat_kit(kit:RangedStatKit) -> void:
	equipped_kits.erase(kit.kit_name)
	mag_size -= kit.mag_size_modifier
	max_ammo -= kit.max_ammo_modifier
	refill_rate -= kit.reload_time_modifier
	refill_rate_empty -= kit.reload_time_empty_modifier
	attack_rate -= kit.fire_rate_modifier

	stat_kit_unequipped.emit(kit)

func has_stat_kit(kit: RangedStatKit) -> bool:
	for kit_equipped in equipped_kits:
		if (kit_equipped == kit.kit_name):
			return true

	return false
#endregion

#region Emission kit
## Emitted when an emission kit has been equipped.
## It provides information about the equipped emission kit.
signal emission_kit_equipped(kit:RangedEmissionKit)

## Changes the weapon's emissions, null variables will be ignored.
func equip_emission_kit(kit:RangedEmissionKit) -> void:
	if (kit.new_projectile != null):
		projectile = kit.new_projectile
	else:
		print("Null projectile detected, New projectile rejected...")

	if (kit.new_field != null):
		field = kit.new_field
	else:
		print("Null field detected, New field rejected...")

	emission_kit_equipped.emit(kit)
#endregion

#region Ranged modes
## Emitted when a reload mode has been changed.
## It provides information about the old and the new reload modes.
signal reload_mode_changed(old_reload_mode:int, new_reload_mode:int)

## Emitted when a firing mode has been changed.
## It provides information about the old and new firing modes.
signal firing_mode_changed(old_firing_mode:int, new_firing_mode:int)

## Defines the firing mode of the weapon. (Note: it does not have any internal functionality)
## @experimental: This has 0 internal functionality
@export_enum("Auto", "Semi", "Burst") var firing_mode:int

## @experimental: This has 0 internal functionality
enum FIRING_MODE {
	AUTO,
	SEMI,
	BURST,
}

## Defines the reload mode (automatic or manual)
@export var is_refill_automatic:bool = true

## Modifies firing and reloading modes based on the mode name and a number corresponding to the enums
func change_modes(mode:String, new_mode:String) -> void:
	match mode:
		"reload":
			var old_mode = is_refill_automatic
			is_refill_automatic = _string_to_enum(new_mode)
			reload_mode_changed.emit(old_mode, new_mode)
		"firing":
			var old_mode = firing_mode
			firing_mode = _string_to_enum(new_mode)
			firing_mode_changed.emit(old_mode, new_mode)
		_:
			printerr("Invalid mode")
#endregion

#region Misc
func _string_to_enum(value:String) -> int:
	match value:
		"AUTOMATIC": return true
		"MANUAL": return false
		"AUTO": return FIRING_MODE.AUTO
		"SEMI": return FIRING_MODE.SEMI
		"BURST": return FIRING_MODE.BURST
		_: print(value + " is invalid")
	return 0
#endregion
