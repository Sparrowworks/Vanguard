class_name Armature
extends Node

## Base class for guns
##
## The Armature class represents a weapon system in a 2D game using Godot's Node structure.
## It manages weapon stats such as magazine size, ammo count, reload times, and firing rates.
## This class is designed to handle various weapon functionalities, including shooting and reloading.

@export_group("Weapon Stats")
## The maximum number of rounds that can be held in the weapon's magazine.
@export var mag_size:int
## The total amount of ammunition available for the weapon.
@export var max_ammo:int
## The time (in seconds) it takes to reload the weapon when there are rounds left in the magazine.
@export var reload_time:int
## Addtional time (in seconds) it takes to reload the weapon when the magazine is empty.
@export var reload_time_empty:int
## The rate at which the weapon can fire (in seconds between shots).
@export var fire_rate:int

@export_group("Weapon Emissions")
## Slot for field
@export var field:PackedScene
## Slot for projectile
@export var payload:PackedScene
#@export_enum("Automatic", "Semi", "Burst") var fire_mode:int

## Represents the current state of the weapon. It can be one of three states defined in the WEAPON_STATE enum
var current_state:int = WEAPON_STATE.READY
enum WEAPON_STATE {
	## The weapon is ready to fire.
	READY,
	## The weapon is firing.
	SHOOTING,
	## The weapon is reloading
	RELOADING,
}

## Used to manage delays between firing and reloading actions.
var TIMER:Timer
func _ready() -> void:
	if (payload == null):
		print("Payload undefined, please set a bullet or a melee weapon")
		return
	TIMER = $Timer

func _shoot() -> void:
	if (current_mag == 0):
		_reload()
		return
	if (current_state != WEAPON_STATE.READY):
		return
	
	current_state = WEAPON_STATE.SHOOTING
	TIMER.wait_time = fire_rate
	payload.instantiate()
	current_mag -= 1
	
	TIMER.start()

## The current amount of ammunition available for use.
## Decreases when shots are fired and increases during reloading based on available ammo.
var current_ammo:int = max_ammo
## The number of rounds currently loaded in the weapon's magazine.
## Decreases with each shot fired and increases during reloading
## until it reaches its maximum capacity (mag_size).
var current_mag:int = mag_size
func _reload() -> void:
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
	
	TIMER.start()

func _on_timer_timeout() -> void:
	current_state = WEAPON_STATE.READY
