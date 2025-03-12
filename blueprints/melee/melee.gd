class_name Melee extends Node2D

signal state_updated()
signal weapon_ready()
signal weapon_attacking()
signal weapon_recovering()

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
