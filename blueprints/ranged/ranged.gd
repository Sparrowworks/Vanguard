class_name Ranged extends Weapon

## [Weapon] class catered to [Ranged] weapons.
##
## The [Ranged] class handles ammunition management, {RangedStatKit] & [RangedEmissionKit] modification and 
## reload + firing mode alteration.
## [br]It also emits [member current_ammo] and [member current_mag] using [member Weapon.collected_data].

#region Initiliazation logic
@export_category("Gun Emissions")
## Slot for [Field].
@export var field: PackedScene
## Slot for [Projectile].
@export var projectile: PackedScene

## Inherits [method Node2D._enter_tree]
## to setup [member current_mag], [member current_ammo] and [member collected_data].
func _enter_tree() -> void:
# A while back, i tried doing this outside _enter_tree while exporting the max values only to fail.
	current_mag = mag_size
	current_ammo = max_ammo

# Without this, UI will display "NULL/NULL".
	collected_data = {
		"ammo": current_ammo,
		"mag": current_mag,
		}

## Inherits and executes [method Weapon._ready],
## Checks if [member projectile] and [member field] are null.
func _ready() -> void:
# Prevents any instantiation errors.
	if (projectile == null):
		printerr("Undefined Projectile")
		return

	if (field == null):
		printerr("Undefined Field")
		return

	super._ready()
#endregion

#region Ranged functionality
@export_category("Ranged stats")
## The total amount of ammunition available for the weapon.
@export var max_ammo: int
## The maximum number of rounds that can be held in the weapon's magazine.
@export var mag_size: int
## Addtional time (in milliseconds) it takes to reload the weapon when the magazine is empty.
@export var refill_rate_empty: float

## The current amount of ammunition available for use.
var current_ammo: int

## The number of rounds currently loaded in the weapon's magazine.
var current_mag: int

## Overrides [method Weapon.attack]:
## [br] - [code]Cancels[/code] if the [Weapon] is currently [constant Weapon.ATTACKING] 
## [code]or[/code] [constant Weapon.REFILLING],
## [br] - If [member current_ammo] is 0, it will [method refill].
## [br] - Enters [constant Weapon.ATTACKING], spews [class Projectile], [class Field],
## deducts [member current_ammo] by 1 and starts [member Weapon.weapon_timer].
func attack() -> void:
	if (current_state != WEAPON_STATE.READY):
		return

	if (current_mag == 0):
		if (is_refill_automatic):
			refill()
		return

	current_state = WEAPON_STATE.ATTACKING

	weapon_timer.wait_time = attack_rate
	add_child(projectile.instantiate())
	add_child(field.instantiate())
	current_mag -= 1
	weapon_timer.start()

## Overrides [method Weapon.refill]:
## [br][br] - [code]Cancels[/code] if: 
## [br] - [member current_mag] is [member mag_size]
## [br] - [code]OR[/code] [member current_ammo] is ZERO
## [br] - [code]OR[/code] [member Weapon.current_state] is [constant Weapon.ATTACKING]
## [br] - [code]OR[/code] [member Weapon.RELOADING].
## [br] - Switches to [constant Weapon.ATTACKING],
## [br][br]Deducts the appropriate amount from [member current_ammo] and adds it to [member current_mag],
## then starts [member Weapon.weapon_timer].
func refill() -> void:
	if (current_mag == mag_size || current_ammo == 0 || current_state != WEAPON_STATE.READY):
		return

	current_state = WEAPON_STATE.REFILLING
	if (current_mag == 0):
		weapon_timer.wait_time = refill_rate + refill_rate_empty
	else:
		weapon_timer.wait_time = refill_rate

	var ammo_to_load = min(mag_size - current_mag, current_ammo)
	current_ammo -= ammo_to_load
	current_mag += ammo_to_load

	weapon_timer.start()
#endregion

#region Ammunition management
## [member current_ammo] + amount, caps at [member max_ammo]
func give_ammo(amount: int) -> void:
	current_ammo = min(current_ammo + amount, max_ammo)

## [member current_ammo] - amount, caps at 0
func take_ammo(amount: int) -> void:
	current_ammo = max(current_ammo - amount, 0)
#endregion

#region Stat kit
## Emitted when a [RangedStatKit] has been equipped.
signal stat_kit_equipped(kit: RangedStatKit)
## Emitted when a [RangedStatKit] has been un-equipped.
signal stat_kit_unequipped(kit: RangedStatKit)

## An [Array] containing the [member RangedStatKit.kit_name] of currently equipped modifications.
var equipped_kits: Array[String]

## Uses [method has_stat_kit], Registers [member RangedStatKit.resource_name] in [member equipped_kits],
## Modifies [Weapon] and [Ranged] stats using a [RangedStatKit] and emits [signal stat_kit_equipped].
func equip_stat_kit(kit: RangedStatKit) -> void:
	if has_stat_kit(kit):
		print("kit already installed")
		return

	equipped_kits.append(kit.resource_name)

# RangedStatKit section
	mag_size += kit.mag_size_modifier
	max_ammo += kit.max_ammo_modifier
	refill_rate_empty += kit.refill_rate_empty_modifier

# WeaponStatKit section
	charge_rate += kit.charge_rate_modifier
	attack_rate += kit.attack_rate_modifier
	refill_rate += kit.refill_rate_modifier

	stat_kit_equipped.emit(kit)

## Checks if the [member RangedStatKit.kit_name] is in [member equipped_arrays],
## Returns [code]true[/code] or [code]false[/code].
func has_stat_kit(kit: RangedStatKit) -> bool:
	for kit_equipped in equipped_kits:
		if (kit_equipped == kit.resource_name):
			return true

	return false

## Reverses the changes made by [method equip_stat_kit] and emits [signal stat_kit_unequipped].
func unequip_stat_kit(kit: RangedStatKit) -> void:
	equipped_kits.erase(kit.resource_name)

# RangedStatKit section
	mag_size -= kit.mag_size_modifier
	max_ammo -= kit.max_ammo_modifier
	refill_rate_empty -= kit.refill_rate_empty_modifier

# WeaponStatKit section
	charge_rate -= kit.charge_rate_modifier
	attack_rate -= kit.attack_rate_modifier
	refill_rate -= kit.refill_rate_modifier

	stat_kit_unequipped.emit(kit)
#endregion

#region Emission kit
## Emitted when a [RangedEmissionKit] has been equipped.
signal emission_kit_equipped(kit: RangedEmissionKit)

## Changes [Ranged]'s [member projectile] and [member field], null variables will be ignored.
## [br]Emits [signal emission_kit_equipped].
func equip_emission_kit(kit: RangedEmissionKit) -> void:
	if (kit.new_projectile != null):
		projectile = kit.new_projectile
	else:
		print("Null projectile detected, New projectile rejected...")

	if (kit.new_field != null):
		field = kit.new_field
	else:
		print("Null field detected, New field rejected...")

	emission_kit_equipped.emit(kit)
#endregion

#region Refill mode
## Emitted when [member is_refill_automatic] has been changed.
signal refill_mode_changed(refill_mode: int)

## Defines the refill mode (automatic or manual) and emits [signal refill_mode_changed].
@export var is_refill_automatic: bool = true:
	set(val):
		is_refill_automatic = val
		refill_mode_changed.emit(is_refill_automatic)

## Changes [member is_refill_automatic].
func change_reload_mode(new_setting: bool) -> void:
	is_refill_automatic = new_setting
#endregion

#region Firing mode
## Emitted when [firing_mode] has been changed.
signal firing_mode_changed(new_firing_mode: int)

## A list of possible firing modes used with [member firing_mode]
## [br]@experimental: This has 0 internal functionality.
enum FIRING_MODE {
	## User can [method Weapon.attack()] by holding their button.
	AUTO,
	## User has to press to [method Weapon.attack()].
	SEMI,
	## User presses to [method Weapon.attack()] a few times.
	BURST,
}

## Defines the firing mode of the weapon, emits [signal firing_mode_changed]
## @experimental: This has 0 internal functionality.
@export_enum("Auto", "Semi", "Burst") var current_firing_mode: int:
	set(val):
		current_firing_mode = val
		firing_mode_changed.emit(current_firing_mode)

## Changes [member current_firing_mode].
func change_firing_mode(new_mode: int) -> void:
	current_firing_mode = new_mode
#endregion

#region Misc
## Inherits and executes [method Weapon.on_weapon_timer_timeout] after filling [member Weapon.collected_data].
func on_weapon_timer_timeout() -> void:
	collected_data = {
		"ammo": current_ammo,
		"mag": current_mag,
		}

	super.on_weapon_timer_timeout()
#endregion
