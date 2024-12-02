class_name Armature
extends Node

@export_group("Weapon Stats")
@export var mag_size:int
@export var max_ammo:int
@export var reload_time:int
@export var reload_time_empty:int
@export var fire_rate:int
@export var recoil:int

@export_group("Weapon Emissions")
@export var field:PackedScene
@export var payload:PackedScene # Place a bullet, melee weapon ext...
@export_enum("Automatic", "Semi", "Burst") var fire_mode:int

var current_state:int = WEAPON_STATE.READY
enum WEAPON_STATE {
	READY,
	SHOOTING,
	RELOADING,
}

var TIMER:Timer
func _ready() -> void:
	if (payload == null):
		print("Payload undefined, please set a bullet or a melee weapon")
		return
	TIMER = $Timer

func _shoot() -> void:
	if (current_mag == 0):
		_reload()
	if (current_state != WEAPON_STATE.READY):
		return
	
	current_state = WEAPON_STATE.SHOOTING
	TIMER.wait_time = fire_rate
	payload.instantiate()
	current_mag -= 1
	
	TIMER.start()

var current_ammo:int = max_ammo
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
