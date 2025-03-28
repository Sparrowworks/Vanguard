class_name Ranged
extends Node2D

## Base class for ranged weapons
##
## The Ranged class represents a weapon system in a 2D game using Godot's Node structure.
## It manages weapon stats such as magazine size, ammo count, reload times, and firing rates.
## This class is designed to handle various weapon functionalities, including shooting and reloading.

## The maximum number of rounds that can be held in the weapon's magazine.
var mag_size:int
## The total amount of ammunition available for the weapon.
var max_ammo:int
## The time (in milliseconds) it takes to reload the weapon when there are rounds left in the magazine.
var reload_time:float
## Addtional time (in milliseconds) it takes to reload the weapon when the magazine is empty.
var reload_time_empty:float
## The rate at which the weapon can fire (in milliseconds between shots).
var fire_rate:float

@export_group("Gun Stats")
## Create a resource that uses RangedStatKit's script and fill it with your desired weapon stats.
## This is the only internal exception where a kit's value replace a weapon stat instead of adding/subtracting
## from it.
@export var base_stats: RangedStatKit:
	set(val):
		if val:
			mag_size = val.mag_size_modifier
			max_ammo = val.max_ammo_modifier
			reload_time = val.reload_time_modifier
			reload_time_empty = val.reload_time_empty_modifier
			fire_rate = val.fire_rate_modifier
			base_stats = val

## Defines the reload mode (automatic or manual)
@export var is_weapon_automatic:bool = true
## Defines the firing mode of the weapon. (Note: it does not have any internal functionality)
## @experimental: This has 0 internal functionality
@export_enum("Auto", "Semi", "Burst") var firing_mode:int

@export_group("Gun Emissions")
## Slot for field
@export var field:PackedScene
## Slot for projectile
@export var projectile:PackedScene

## Emitted when current_state is changed
signal state_updated(new_state: String)

## Represents the current state of the weapon.
## It can be one of three states defined in the WEAPON_STATE enum.
var current_state:int = WEAPON_STATE.INITIALIZE:
	set(val):
		current_state = val
		state_updated.emit(_enum_to_str(current_state))

		match current_state:
			WEAPON_STATE.READY: weapon_ready.emit(current_mag, current_ammo)
			WEAPON_STATE.SHOOTING: weapon_firing.emit()
			WEAPON_STATE.RELOADING: weapon_reloading.emit()
			_: print("Invalid state: %s" %[current_state])

enum WEAPON_STATE {
	## The weapon system is being initialized
	INITIALIZE = 0,
	## The weapon is ready to fire or reload.
	READY = 1,
	## The weapon is firing.
	SHOOTING = 2,
	## The weapon is reloading
	RELOADING = 3,
}

## @experimental: This has 0 internal functionality
enum FIRING_MODE {
	AUTO,
	SEMI,
	BURST,
}

## Emitted when the weapon is ready to shoot or reload.
## It Provides information about the current magazine and ammunition count.
signal weapon_ready(mag:int, ammo:int)
## Emitted when the weapon has started shooting.
signal weapon_firing()
## Emitted when the weapon has started reloading
signal weapon_reloading()
## Emitted when a stat kit has been equipped.
## It provides information about the equipped stat kit.
signal stat_kit_equipped(kit:RangedStatKit)
## Emitted when a stat kit has been unequipped.
## It provides information about the unequipped stat kit.
signal stat_kit_unequipped(kit:RangedStatKit)
## Emitted when an emission kit has been equipped.
## It provides information about the equipped emission kit.
signal emission_kit_equipped(kit:RangedEmissionKit)
## Emitted when a reload mode has been changed.
## It provides information about the old and the new reload modes.
signal reload_mode_changed(old_reload_mode:int, new_reload_mode:int)
## Emitted when a firing mode has been changed.
## It provides information about the old and new firing modes.
signal firing_mode_changed(old_firing_mode:int, new_firing_mode:int)

## Used to manage delays between firing and reloading actions.
## Sets current weapon state to READY when it timesout.
var ranged_timer:Timer
func _init() -> void:
	ranged_timer = Timer.new()
	ranged_timer.one_shot = true
	add_child(ranged_timer)
	ranged_timer.timeout.connect(_on_timer_timeout)

func _ready() -> void:
	current_mag = mag_size
	current_ammo = max_ammo

	if (projectile == null):
		printerr("Undefined Projectile")
		return

	current_state = WEAPON_STATE.READY

## The shoot() method is responsible for handling the firing mechanism of the weapon.
## If there is no ammunition, it will reload.
## If the weapon is currently firing or reloading, it exits without firing.
func shoot() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	if (current_mag == 0):
		if (is_weapon_automatic):
			reload()
		return

	current_state = WEAPON_STATE.SHOOTING
	ranged_timer.wait_time = fire_rate
	add_child(projectile.instantiate())
	add_child(field.instantiate())
	current_mag -= 1

	ranged_timer.start()

## The current amount of ammunition available for use.
## Decreases when reloading based on magazine size and available ammo.
var current_ammo:int
## The number of rounds currently loaded in the weapon's magazine.
## Decreases with each shot fired and increases during reloading
## until it reaches its maximum capacity (mag_size).
var current_mag:int
## The reload() method is responsible for reloading the weapon's magazine with ammunition.
## If the magazine is full or there is no ammunition left or the weapon is currently firing or reloading,
## the method will exit without reloading.
func reload() -> void:
	if (current_mag == mag_size || current_ammo == 0 || current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.RELOADING
	if (current_mag == 0):
		ranged_timer.wait_time = reload_time + reload_time_empty
	else:
		ranged_timer.wait_time = reload_time

	var ammo_to_load = min(mag_size - current_mag, current_ammo)
	current_ammo -= ammo_to_load
	current_mag += ammo_to_load

	ranged_timer.start()

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
	reload_time += kit.reload_time_modifier if kit.reload_time_modifier != 0 else reload_time
	reload_time_empty += kit.reload_time_empty_modifier if kit.reload_time_empty_modifier != 0 else reload_time_empty
	fire_rate += kit.fire_rate_modifier if kit.fire_rate_modifier != 0 else fire_rate

	stat_kit_equipped.emit(kit)

## Reverses the changes made by equip_kit
func unequip_stat_kit(kit:RangedStatKit) -> void:
	equipped_kits.erase(kit.kit_name)
	mag_size -= kit.mag_size_modifier
	max_ammo -= kit.max_ammo_modifier
	reload_time -= kit.reload_time_modifier
	reload_time_empty -= kit.reload_time_empty_modifier
	fire_rate -= kit.fire_rate_modifier

	stat_kit_unequipped.emit(kit)

func has_stat_kit(kit: RangedStatKit) -> bool:
	for kit_equipped in equipped_kits:
		if (kit_equipped == kit.kit_name):
			return true

	return false

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

## Modifies firing and reloading modes based on the mode name and a number corresponding to the enums
func change_modes(mode:String, new_mode:String) -> void:
	match mode:
		"reload":
			var old_mode = is_weapon_automatic
			is_weapon_automatic = _string_to_enum(new_mode)
			reload_mode_changed.emit(old_mode, new_mode)
		"firing":
			var old_mode = firing_mode
			firing_mode = _string_to_enum(new_mode)
			firing_mode_changed.emit(old_mode, new_mode)
		_:
			printerr("Invalid mode")

func _enum_to_str(state: int) -> String:
	match state:
		1:
			return "READY"
		2:
			return "SHOOTING"
		3:
			return "RELOADING"
		_:
			return "ERROR"

func _string_to_enum(value:String) -> int:
	match value:
		"AUTOMATIC": return true
		"MANUAL": return false
		"AUTO": return FIRING_MODE.AUTO
		"SEMI": return FIRING_MODE.SEMI
		"BURST": return FIRING_MODE.BURST
		_: print(value + " is invalid")
	return 0

func _on_timer_timeout() -> void:
	current_state = WEAPON_STATE.READY
