class_name Hitbox extends Area2D

## Class for detection by [Hurtbox].
##
## Set a predefined [member hitbox_layer] here and assign the same value to [member Hurtbox.hurtbox_mask].

#region Initialisation Logic
## [member CollisionObject2D.collision_layer] used to be detected by [member CollisionObject2D.collision_mask].
@export var hitbox_layer: int = 2
## [member CollisionObject2D.collision_mask] used to detect [member CollisionObject2D.collision_layer].
@export var hitbox_mask: int = 0

## Assigns the exported values to [member CollisionObject2D.collision_layer] and [member CollisionObject2D.collision_mask].
func _init() -> void:
	collision_layer = hitbox_layer
	collision_mask = hitbox_mask
#endregion
