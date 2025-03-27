class_name Hurtbox extends Area2D

var hurtbox_layer:int = 0
var hurtbox_mask:int = 2

func _init() -> void:
	collision_layer = hurtbox_layer
	collision_mask = hurtbox_mask

func _ready() -> void:
	area_entered.connect(_on_hurtbox_entered)

func _on_hurtbox_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return

	if owner.has_method("take_damage"):
		owner.take_damage()
