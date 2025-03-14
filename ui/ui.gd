extends CanvasLayer

@onready var ranged_weapon:Node2D = get_parent()

func _ready() -> void:
	ranged_weapon.state_updated.connect(_on_pistol_state_updated)
	ranged_weapon.weapon_ready.connect(_on_pistol_weapon_ready)

func _on_pistol_state_updated(new_state: String) -> void:
	%StateLabel.text = "State: " + new_state

func _on_pistol_weapon_ready(mag: int, ammo: int) -> void:
	%AmmoLabel.text = "Ammo: " + str(mag) + "/" + str(ammo)
