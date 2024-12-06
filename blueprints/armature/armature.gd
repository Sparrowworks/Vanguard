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
## The time (in seconds) it takes to reload the weapon when there are rounds left in the magazine.
@export var reload_time:float
## Addtional time (in seconds) it takes to reload the weapon when the magazine is empty.
@export var reload_time_empty:float
## The rate at which the weapon can fire (in seconds between shots).
@export var fire_rate:float

@export_group("Gun Emissions")
## Slot for field
@export var field:PackedScene
## Slot for projectile
@export var projectile:PackedScene
#@export_enum("Automatic", "Semi", "Burst") var fire_mode:int

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

	if (projectile == null):
		print("Payload undefined, please set a bullet or a melee weapon")
		return
	TIMER = $Timer
	weapon_ready.emit(current_mag, current_ammo)

## The shoot() method is responsible for handling the firing mechanism of the weapon.
## If there is no ammunition, it will reload.
## If the weapon is currently firing or reloading, it exits without firing.
func shoot() -> void:
	if (current_mag == 0):
		reload()
		return
	if (current_state != WEAPON_STATE.READY):
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

func _on_timer_timeout() -> void:
	current_state = WEAPON_STATE.READY
	weapon_ready.emit(current_mag, current_ammo)
