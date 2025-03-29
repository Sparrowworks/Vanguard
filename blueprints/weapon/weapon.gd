class_name Weapon extends Node

## Base class for all weapons.
##
## The weapon class contains a [url=https://www.youtube.com/watch?v=sNFMdLEVxFo]state machine[/url],
## [Signal] management and basic [Weapon] functionality.

#region State Machine
## Emitted when [member current_state] is changed.
signal state_updated(state: String)
## Emitted when [member current_state] is ready.
signal weapon_ready()
## Emitted when [member current_state] is charging.
signal weapon_charging()
## Emitted when [member current_state] is attacking.
signal weapon_attacking()
## Emitted when [member current_state] is recovering.
signal weapon_recovering()

## A list of possible weapon states.
enum WEAPON_STATE {
	## The [Weapon] system is being initialized.
	INITIALIZE = 0,
	## The [Weapon] is ready (can be toggled to anything below).
	READY = 1,
	## The [Weapon] is charging (ex: charging a rifle).
	CHARGING = 2,
	## The [Weapon] is attacking (ex: shooting).
	ATTACKING = 3,
	## The [Weapon] is recovering (ex: reloading).
	RECOVERING = 4,
}

## Represents the current state of the [Weapon],
## It can be one of the states defined in the [enum WEAPON_STATE].
## [br]Emits two signals, [signal state_updated] and the corresponding [enum WEAPON_STATE]'s signal,
## (if [enum READY] then [signal weapon_ready]).
## [br]Starts off at [enum INITIALIZE].
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
## Used to keep track of how long the [Weapon] stays in one state before resetting to [enum READY]
var weapon_timer: Timer

# Exists so that the user doesn't need to create a timer everytime they make a new weapon!
func _init() -> void:
	weapon_timer = Timer.new()
	weapon_timer.one_shot = true
	add_child(weapon_timer)
	weapon_timer.timeout.connect(on_weapon_timer_timeout)

# Signals it's ready, useful for giving UI stats and all.
func _ready() -> void:
	current_state = WEAPON_STATE.READY
#endregion

#region Weapon Functionality
## Time (in milliseconds) it takes to [method charge] a [Weapon] fully.
var charge_rate: float
## Time (in milliseconds) it takes to finish an [method attack] before making another action.
var attack_rate: float
## Time (in milliseconds) it takes to finish a [method recover] phase.
var recovery_rate: float

## Handles the [Weapon]'s [enum CHARGING] mechanism,
## It will exits without charging if it's not [enum READY] or [enum CHARGING].
func charge() -> void:
	if (current_state != WEAPON_STATE.READY || WEAPON_STATE.CHARGING):
		return

	if (current_state != WEAPON_STATE.CHARGING):
		current_state = WEAPON_STATE.CHARGING
		weapon_timer.wait_time = charge_rate
		weapon_timer.start()

	pass

## Handles the [Weapon]'s [enum ATTACKING] mechanism,
## It will exits without [enum ATTACKING] if it's not [enum READY].
func attack() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.ATTACKING
	weapon_timer.wait_time = attack_rate
	weapon_timer.start()

## Handles the [Weapon]'s [enum RECOVERING] mechanism,
## It will exits without [enum RECOVERING] if it's not [enum READY].
func recover() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.RECOVERING
	weapon_timer.wait_time = recovery_rate
	weapon_timer.start()

## Governs what happens when the [Weapon] finished an action.
## Resets to [enum READY]
func on_weapon_timer_timeout() -> void:
	current_state = WEAPON_STATE.READY
#endregion

#region Misc
# Translates enums to strings, outputs a string.
# Used at current_state setter to emit the state_updated signal.
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
