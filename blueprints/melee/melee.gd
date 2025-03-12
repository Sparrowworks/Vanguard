class_name Melee extends Node2D

## Base class for melee weapons
##
## The Melee class represents a weapon system in a 2D game using Godot's Node structure.
## It manages weapon stats such as "INSERT NO DOCUMENTATION HERE".
## This class is designed to handle various weapon functionalities, including attacking and recovering.

var attack_rate:int
var recovery_time:int

## Emitted when current_state is changed
signal state_updated()
## Emitted when current_state is ready
signal weapon_ready()
## Emitted when current_state is attacking
signal weapon_attacking()
## Emitted when current_state is recovering
signal weapon_recovering()

## Represents the current state of the weapon.
## It can be one of the states defined in the WEAPON_STATE enum.
var current_state:int = WEAPON_STATE.INITIALIZE :
	set(val):
		current_state = val
		state_updated.emit(_enum_to_str(current_state))

		match current_state:
			WEAPON_STATE.READY: weapon_ready.emit()
			WEAPON_STATE.ATTACKING: weapon_attacking.emit()
			WEAPON_STATE.RECOVERING: weapon_recovering.emit()
			_: print("Invalid state: %s" %[current_state])

enum WEAPON_STATE {
	## The weapon system is being initialized
	INITIALIZE = 0,
	## The weapon is ready to attack or recover.
	READY = 1,
	## The weapon is attacking.
	ATTACKING = 2,
	## The weapon is recovering.
	RECOVERING = 3,
}

## Used to manage delays between firing and reloading actions.
## Sets current weapon state to READY when it timesout.
var ranged_timer:Timer
func _init() -> void:
	ranged_timer = Timer.new()
	ranged_timer.one_shot = true
	add_child(ranged_timer)
	ranged_timer.timeout.connect(_on_weapon_timer_timeout)

## The shoot() method is responsible for handling the firing mechanism of the weapon.
## If there is no ammunition, it will reload.
## If the weapon is currently firing or reloading, it exits without firing.
func attack() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.ATTACKING
	ranged_timer.wait_time = attack_rate
	ranged_timer.start()

func recover() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.RECOVERING
	ranged_timer.wait_time = recovery_time
	ranged_timer.start()

func _on_weapon_timer_timeout() -> void:
	current_state = WEAPON_STATE.READY

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
