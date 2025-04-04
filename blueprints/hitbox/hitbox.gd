class_name Hitbox extends Area2D

## Class for detection by [Hurtbox]
##
## Set a predefined [member Hitbox.hitbox_layer] here and assign the same value to [member Hurtbox.hurtbox_mask]

## [member CollisionObject2D.collision_layer] used to be detected by [member CollisionObject2D.collision_mask]
@export var hitbox_layer:int = 2
## [member CollisionObject2D.collision_mask] used to detect [member CollisionObject2D.collision_layer]
@export var hitbox_mask:int = 0

func _init() -> void:
	collision_layer = hitbox_layer
	collision_mask = hitbox_mask
