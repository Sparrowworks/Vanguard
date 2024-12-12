class_name Armature
extends Node2D

## Base class for guns
##
## The Armature class represents a weapon system in a 2D game using Godot's Node structure.
## It manages weapon stats such as magazine size, ammo count, reload times, and firing rates.
## This class is designed to handle various weapon functionalities, including shooting and reloading.

@export_group("Gun Stats")
## The maximum number of rounds that can be held in the weapon's magazine.
@export var mag_size:int
## The total amount of ammunition available for the weapon.
@export var max_ammo:int
## The time (in milliseconds) it takes to reload the weapon when there are rounds left in the magazine.
@export var reload_time:float
## Addtional time (in milliseconds) it takes to reload the weapon when the magazine is empty.
@export var reload_time_empty:float
## The rate at which the weapon can fire (in milliseconds between shots).
@export var fire_rate:float
## Defines the reload mode (automatic or manual)
@export_enum("Automatic", "Manual") var reload_mode:int
## Defines the firing mode of the weapon. (Note: it does not have any internal functionality)
@export_enum("Automatic", "Semi", "Burst") var firing_mode:int

@export_group("Gun Emissions")
## Slot for field
@export var field:PackedScene
## Slot for projectile
@export var projectile:PackedScene

## Represents the current state of the weapon.
## It can be one of three states defined in the WEAPON_STATE enum.
var current_state:int = WEAPON_STATE.READY
enum WEAPON_STATE {
	## The weapon is ready to fire or reload.
	READY = 1,
	## The weapon is firing.
	SHOOTING = 2,
	## The weapon is reloading
	RELOADING = 3,
}

## Emitted when the weapon is ready to shoot or reload.
## It Provides information about the current magazine and ammunition count.
signal weapon_ready(mag:int, ammo:int)
## Emitted when the weapon has finished shooting.
## It provides information about the current magazine count.
signal weapon_shot(mag:int)
## Emitted when the weapon has finished reloading
## It provides information about the current magazine and ammunition count.
signal weapon_reloaded(mag:int, ammo:int)

## Used to manage delays between firing and reloading actions.
## Sets current weapon state to READY when it timesout.
var TIMER:Timer
func _ready() -> void:
	current_mag = mag_size
	current_ammo = max_ammo
	print(current_state)

	if (projectile == null):
		printerr("Payload undefined, please set a bullet or a melee weapon")
		return
	TIMER = $Timer
	TIMER.one_shot = true
	weapon_ready.emit(current_mag, current_ammo)

## The shoot() method is responsible for handling the firing mechanism of the weapon.
## If there is no ammunition, it will reload.
## If the weapon is currently firing or reloading, it exits without firing.
func shoot() -> void:
	if (current_state != WEAPON_STATE.READY):
		return
	if (current_mag == 0):
		if (reload_mode == 0):
			reload()
		return

	current_state = WEAPON_STATE.SHOOTING
	TIMER.wait_time = fire_rate
	add_child(projectile.instantiate())
	add_child(field.instantiate())
	current_mag -= 1
	weapon_shot.emit(current_mag)

	TIMER.start()

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
	if (current_mag == mag_size && current_ammo == 0 || current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.RELOADING
	if (current_mag == 0):
		TIMER.wait_time = reload_time + reload_time_empty
	else:
		TIMER.wait_time = reload_time

	var ammo_to_load = min(mag_size - current_mag, current_ammo)
	current_ammo -= ammo_to_load
	current_mag += ammo_to_load
	weapon_reloaded.emit(current_mag, current_ammo)

	TIMER.start()

## A list containing the names of currently equipped modifications
var equipped_kits:Array[String]
## Modifies weapon stats by providing a kit.
func modify_stats(kit:GunKit) -> void:
	for i in equipped_kits:
		if (i == kit.kit_name):
			print("kit already installed")
			return

	equipped_kits.append(kit)
	mag_size *= int(1 + kit.mag_size_modifier / 100)
	max_ammo *= int(1 + kit.max_ammo_modifier / 100)
	reload_time *= (1 + kit.mag_size_modifier / 100)
	reload_time_empty *= (1 + kit.mag_size_modifier / 100)
	fire_rate *= (1 + kit.mag_size_modifier / 100)

## Modifies firing and reloading modes based on the mode name and a number corresponding to the enums
func modify_modes(mode:String, new_mode:int) -> void:
	match mode:
		"reload":
			reload_mode = new_mode
		"firing":
			firing_mode = new_mode
		_:
			printerr("Invalid mode")

func _on_timer_timeout() -> void:
	current_state = WEAPON_STATE.READY
	print(str(current_mag) + " " + str(current_ammo))
	weapon_ready.emit(current_mag, current_ammo)
