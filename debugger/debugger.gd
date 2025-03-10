extends Node

@onready var ranged_list : Array[Node] = get_tree().get_nodes_in_group("ranged")

func _ready() -> void:
	connect_signals(ranged_list)
	print("Debugger ready")

func connect_signals(ranged_weapons:Array[Node]) -> void:
	for ranged in ranged_weapons:
		ranged.weapon_ready.connect(debug_weapon_ready)
		ranged.weapon_firing.connect(debug_weapon_firing)
		ranged.weapon_reloading.connect(debug_weapon_reloading)
		ranged.state_updated.connect(debug_state_updated)
		ranged.stat_kit_equipped.connect(debug_stat_kit_equipped)
		ranged.stat_kit_unequipped.connect(debug_stat_kit_unequipped)
		ranged.emission_kit_equipped.connect(debug_emission_kit_equipped)
		ranged.reload_mode_changed.connect(debug_reload_mode_changed)
		ranged.firing_mode_changed.connect(debug_firing_mode_changed)
		ranged.ranged_timer.timeout.connect(debug_ranged_weapons_timeout)

func debug_weapon_ready(mag:int, ammo:int) -> void:
	print("Weapon ready! Mag: %d, Ammo: %d" % [mag,ammo])

func debug_weapon_firing() -> void:
	print("Started shooting")

func debug_weapon_reloading() -> void:
	print("Started reloading")

func debug_state_updated(new_state: String) -> void:
	print("Weapon state changed to %s" % [new_state])

func debug_stat_kit_equipped(kit:RangedStatKit) -> void:
	print(
		"Stat kit Equipped!
		Name: %s, Magazine: %d, Ammo: %d, ReloadTime: %f, ReloadTimeEmpty: %f, Firerate: %f" %
		[
			kit.kit_name, kit.mag_size_modifier, kit.max_ammo_modifier,
			kit.reload_time_modifier, kit.reload_time_empty_modifier, kit.fire_rate_modifier,
		]
	)

func debug_stat_kit_unequipped(kit:RangedStatKit) -> void:
	print(
		"Stat kit Un-Equipped!
		Name: %s, Magazine: %d, Ammo: %d, ReloadTime: %f, ReloadTimeEmpty: %f, Firerate: %f" %
		[
			kit.kit_name, kit.mag_size_modifier, kit.max_ammo_modifier,
			kit.reload_time_modifier, kit.reload_time_empty_modifier, kit.fire_rate_modifier,
		]
	)

func debug_emission_kit_equipped(kit:RangedEmissionKit) -> void:
	print(
		"Emission kit Equipped!
		Name: %s" % [kit.resource_name]
	)

func debug_reload_mode_changed(old_reload_mode:int, new_reload_mode:int) -> void:
	print("Reload mode changed from %d to %d" % [old_reload_mode, new_reload_mode])

func debug_firing_mode_changed(old_firing_mode:int, new_firing_mode:int) -> void:
	print("Firing mode changed from %d to %d" % [old_firing_mode, new_firing_mode])

func debug_ranged_weapons_timeout() -> void:
	print("Timer ended")
