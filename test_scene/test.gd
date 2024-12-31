extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _on_pistol_mag_updated(new_amount: int, max_amount: int) -> void:
	%MagLabel.text = "Mag: " + str(new_amount) + "/" + str(max_amount)


func _on_pistol_ammo_updated(new_amount: int, max_amount: int) -> void:
	%AmmoLabel.text = "Reserve: " + str(new_amount) + "/" + str(max_amount)


func _on_pistol_state_updated(new_state: String) -> void:
	%StateLabel.text = "State: " + new_state
