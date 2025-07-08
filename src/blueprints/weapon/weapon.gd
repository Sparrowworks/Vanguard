class_name Weapon extends Node

## Base class for all weapons.
##
## The weapon class contains a [url=https://www.youtube.com/watch?v=sNFMdLEVxFo]state machine[/url],
## [Signal] management and basic [Weapon] functionality.

#region State Machine
## Emitted when [member current_state] is [b]changed[/b].
signal state_updated(state: String)
## Emitted when [member current_state] is [constant READY].
signal weapon_ready(data: Dictionary)
## Emitted when [member current_state] is [constant CHARGING].
signal weapon_charging(data: Dictionary)
## Emitted when [member current_state] is [constant ATTACKING].
signal weapon_attacking(data: Dictionary)
## Emitted when [member current_state] is [constant REFILLING].
signal weapon_refilling(data: Dictionary)
## Emitted when [member current_state] is [constant OVERHEATED].
signal weapon_overheated(data: Dictionary)

## A list of possible weapon states, used with [member current_state].
enum WEAPON_STATE {
	## The [Weapon] system is being initialized.
	INITIALIZE = 0,
	## The [Weapon] is ready and can be toggled to any state below.
	READY = 1,
	## The [Weapon] is charging (e.g. charging a rifle).
	CHARGING = 2,
	## The [Weapon] is attacking (e.g. shooting).
	ATTACKING = 3,
	## The [Weapon] is refilling (e.g. reloading).
	REFILLING = 4,
	## The [Weapon] has overheated (e.g you used a minigun too much).
	OVERHEATED = 5,
}

## Represents the current state of the [Weapon],
## It can be one of the states defined in the [enum WEAPON_STATE].
## [br][br]Emits two signals, [signal state_updated] and the corresponding [enum WEAPON_STATE]'s signal,
## (if [constant READY] then [signal weapon_ready]).
## [br]Starts off at [constant INITIALIZE], switches to [constant READY] when [method _ready]
## [br]Nullifies [member collected_data] after [Signal] emission.
var current_state: int = WEAPON_STATE.INITIALIZE:
	set(val):
		current_state = val
		state_updated.emit(_enum_to_str(current_state))

		match current_state:
			WEAPON_STATE.READY: weapon_ready.emit(collected_data)
			WEAPON_STATE.CHARGING: weapon_charging.emit(collected_data)
			WEAPON_STATE.ATTACKING: weapon_attacking.emit(collected_data)
			WEAPON_STATE.REFILLING: weapon_refilling.emit(collected_data)
			WEAPON_STATE.OVERHEATED: weapon_overheated.emit(collected_data)
			_: print("Invalid state: %s" %[current_state])

		collected_data = {}

## Enables data trasmission over built-in signals through [member current_state],
## gets nullified after being emitted.
## [br]Set it up yourself through any class that extends [Weapon].
var collected_data: Dictionary
#endregion

#region Initialization logic
## Used to keep track of how long the [Weapon] stays in one state
## before [code]resetting[/code] to [constant READY].
var weapon_timer: Timer

## Inherits [method Node2D._init], used to create a [Timer]
## and connect it's [signal Timer.timeout] to [method on_weapon_timer_timeout].
func _init() -> void:
	weapon_timer = Timer.new()
	weapon_timer.one_shot = true
	add_child(weapon_timer)
	weapon_timer.timeout.connect(on_weapon_timer_timeout)

## Inherits [method Node2D._ready], Sets [member current_state] to [constant READY].
func _ready() -> void:
	current_state = WEAPON_STATE.READY
#endregion

#region Weapon Functionality
@export_category("Weapon stats")
## Time (in milliseconds) it takes to [method charge] a [Weapon] fully.
@export var charge_rate: float
## Time (in milliseconds) it takes to finish an [method attack] before making another action.
@export var attack_rate: float
## Time (in milliseconds) it takes to [method refill].
@export var refill_rate: float

## Sets [member current_state] to [constant CHARGING],
## Handles the [Weapon]'s [constant CHARGING] mechanism.
## [br][br]Sets [member weapon_timer] to [member charge_rate] and [method Timer.start].
## [br][code]Exits[/code] without charging if it's not [constant READY] or [constant CHARGING].
func charge() -> void:
	if (current_state != WEAPON_STATE.READY || current_state != WEAPON_STATE.CHARGING):
		return

	if (current_state != WEAPON_STATE.CHARGING):
		current_state = WEAPON_STATE.CHARGING
		weapon_timer.wait_time = charge_rate
		weapon_timer.start()

## Sets [member current_state] to [constant ATTACKING],
## Handles the [Weapon]'s [constant ATTACKING] mechanism.
## [br][br]Sets [member weapon_timer] to [member attack_rate] and [method Timer.start].
## [br][code]Exits[/code] without [constant ATTACKING] if it's not [constant READY].
func attack() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.ATTACKING
	weapon_timer.wait_time = attack_rate
	weapon_timer.start()

## Sets [member current_state] to [constant REFILLING],
## Handles the [Weapon]'s [constant REFILLING] mechanism.
## [br][br]Sets [member weapon_timer] to [member refill_rate] and [method Timer.start].
## [br][code]Exits[/code] without [constant REFILLING] if it's not [constant READY].
func refill() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.REFILLING
	weapon_timer.wait_time = refill_rate
	weapon_timer.start()

## Governs what happens when the [Weapon] finished an action.
## [code]Resets[/code] to [constant READY].
func on_weapon_timer_timeout() -> void:
	current_state = WEAPON_STATE.READY
#endregion

#region Misc
## Takes a [enum weapon_state] constant and [code]returns[/code] it as a string,
## Used at [member current_state] to emit [signal state_updated].
func _enum_to_str(state: int) -> String:
	match state:
		0:
			return "INITIALIZING"
		1:
			return "READY"
		2:
			return "CHARGING"
		3:
			return "ATTACKING"
		4:
			return "REFILLING"
		5:
			return "OVERHEATED"
		_:
			return "ERROR"
#endregion
