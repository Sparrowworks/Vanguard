class_name Hurtbox extends Area2D

## Class for the detection of [Hitbox].
##
## Assign [member Hitbox.hitbox_layer] to [member Hurtbox.hurtbox_mask] to run detection logic.

#region Initialization Logic
## [member CollisionObject2D.collision_layer] used to be detected by [member CollisionObject2D.collision_mask].
var hurtbox_layer: int = 0
## [member CollisionObject2D.collision_mask] used to detect [member CollisionObject2D.collision_layer].
var hurtbox_mask: int = 2

## Assigns the exported values to [member collision_layer] and [member collision_mask].
func _init() -> void:
	collision_layer = hurtbox_layer
	collision_mask = hurtbox_mask

## Connects [signal area_entered] to [method on_hurtbox_entered].
func _ready() -> void:
	area_entered.connect(on_hurtbox_entered)
#endregion

#region Detection Logic
## Activates when [signal area_entered] is emitted by detecting a [member Hitbox.collision_layer],
## Checks if the [Hitbox] contains [method take_damage] and executes it.
## [br][br][code]return[/code] if [Hitbox] is [code]null[/code]  
func on_hurtbox_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return

	if owner.has_method("take_damage"):
		owner.take_damage()

# Seems random yes, but the only "hitbox" here with a timer is a projectile.
		if hitbox.has_node("./Timer"):
			hitbox.queue_free()
#endregion
