extends Control

@onready var ranged_weapon:Node2D = get_parent()

func _ready() -> void:
	ranged_weapon.state_updated.connect(_on_pistol_state_updated)
	ranged_weapon.weapon_ready.connect(_on_pistol_weapon_ready)

func _on_pistol_state_updated(state: String) -> void:
	%StateLabel.text = "State: " + state

func _on_pistol_weapon_ready(data: Dictionary) -> void:
	%AmmoLabel.text = "Ammo: " + str(data.get("mag")) + "/" + str(data.get("ammo"))
