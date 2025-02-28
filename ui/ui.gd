extends CanvasLayer

func _on_pistol_state_updated(new_state: String) -> void:
	%StateLabel.text = "State: " + new_state

func _on_pistol_weapon_ready(mag: int, ammo: int) -> void:
	%AmmoLabel.text = "Ammo: " + str(mag) + "/" + str(ammo)
