class_name Weapon

@export_group("Weapon Stats")
@export var fire_rate:int
@export var mag_size:int
@export var max_ammo:int
@export var reload_time:int
@export var accuracy:int
@export var recoil:int
@export var has_silencer:bool
@export_enum("Automatic", "Semi", "Burst") var fire_mode:int

var payload:Payload
@export_group("Payload Stats")
@export_enum("Projectile", "Melee") var payload_type:int
@export var damage:int
@export var Brange:int # to evade warning "The variable "range" has the same name as a built-in function."
@export var knockback:int
@export var crit_chance:int

var current_ammo:int = max_ammo
var current_mag:int = mag_size
var current_state:int = WEAPON_STATE.READY
enum WEAPON_STATE {
	READY,
	SHOOTING,
	RELOADING,
}
