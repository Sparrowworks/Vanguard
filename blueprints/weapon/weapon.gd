class_name Weapon extends Node

## Base class for all weapons
##
## The weapon class contains a state machine, signal management.

#region State Machine
## Emitted when current_state is changed.
signal state_updated(state: String)
## Emitted when current_state is ready.
signal weapon_ready()
## Emitted when current_state is charging.
signal weapon_charging()
## Emitted when current_state is attacking.
signal weapon_attacking()
## Emitted when current_state is recovering.
signal weapon_recovering()

## A list of possible weapon states.
enum WEAPON_STATE {
	## The weapon system is being initialized.
	INITIALIZE = 0,
	## The weapon is ready (can be toggled to anything below).
	READY = 1,
	## The weapon is charging (ex: charging a rifle).
	CHARGING = 2,
	## The weapon is attacking (ex: shooting).
	ATTACKING = 3,
	## The weapon is recovering (ex: reloading).
	RECOVERING = 4,
}

## Represents the current state of the weapon,
## It can be one of the states defined in the WEAPON_STATE enum.
## Emits two signals, state_updated and the corresponding weapon state's signal (if READY then weapon_ready).
var current_state: int = WEAPON_STATE.INITIALIZE:
	set(val):
		current_state = val
		state_updated.emit(_enum_to_str(current_state))

		match current_state:
			WEAPON_STATE.READY: weapon_ready.emit()
			WEAPON_STATE.CHARGING: weapon_charging.emit()
			WEAPON_STATE.ATTACKING: weapon_attacking.emit()
			WEAPON_STATE.RECOVERING: weapon_recovering.emit()
			_: print("Invalid state: %s" %[current_state])
#endregion

#region Initialization logic
## Used to keep track of how long the weapon stays in one state before resetting to READY
var weapon_timer: Timer

func _init() -> void:
	weapon_timer = Timer.new()
	weapon_timer.one_shot = true
	add_child(weapon_timer)
	weapon_timer.timeout.connect(on_weapon_timer_timeout)

func _ready() -> void:
	current_state = WEAPON_STATE.READY
#endregion

#region Weapon Functionality
## Time (in milliseconds) it takes to charge a weapon fully
var charge_rate: float
## Time (in milliseconds) it takes to finish an attack before moving to another action/attack again
var attack_rate: float
## Time (in milliseconds) it takes to finish the recovery phase
var recovery_rate: float

## Handles the weapon's charging mechanism,
## It will exits without charging if it's not READY or CHARGING.
func charge() -> void:
	if (current_state != WEAPON_STATE.READY || WEAPON_STATE.CHARGING):
		return

	if (current_state != WEAPON_STATE.CHARGING):
		current_state = WEAPON_STATE.CHARGING
		weapon_timer.wait_time = charge_rate
		weapon_timer.start()

	pass

## Handles the weapon's attacking mechanism,
## It will exits without attacking if it's not READY.
func attack() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.ATTACKING
	weapon_timer.wait_time = attack_rate
	weapon_timer.start()

## Handles the weapon's recovery mechanism,
## It will exits without recovering if it's not READY.
func recover() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.RECOVERING
	weapon_timer.wait_time = recovery_rate
	weapon_timer.start()

## Governs what happens when the weapon finished an action.
func on_weapon_timer_timeout() -> void:
	current_state = WEAPON_STATE.READY
#endregion

#region Misc
# Translates enums to strings to output a string for the signals
func _enum_to_str(state: int) -> String:
	match state:
		0:
			return "INITILIAZING"
		1:
			return "READY"
		2:
			return "CHARGING"
		3:
			return "ATTACKING"
		4:
			return "RECOVERING"
		_:
			return "ERROR"
#endregion
