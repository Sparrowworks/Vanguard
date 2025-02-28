extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_pistol_state_updated(new_state: String) -> void:
	%StateLabel.text = "State: " + new_state

func _on_pistol_weapon_ready(mag: int, ammo: int) -> void:
	%AmmoLabel.text = "Ammo: " + str(mag) + "/" + str(ammo)
