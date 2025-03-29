class_name Hitbox extends Area2D

var hitbox_layer:int = 2
var hitbox_mask:int = 0

func _init() -> void:
	collision_layer = hitbox_layer
	collision_mask = hitbox_mask
