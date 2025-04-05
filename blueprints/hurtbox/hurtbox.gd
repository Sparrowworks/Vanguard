class_name Hurtbox extends Area2D

## Class for the detection of [Hitbox]
##
## Whatever you have assigned as [member Hitbox.hitbox_layer] [u]must be[/u] 
## used for [member Hurtbox.hurtbox_mask] to run detection logic

## [member CollisionObject2D.collision_layer] used to be detected by [member CollisionObject2D.collision_mask]
var hurtbox_layer: int = 0
## [member CollisionObject2D.collision_mask] used to detect [member CollisionObject2D.collision_layer]
var hurtbox_mask: int = 2

func _init() -> void:
	collision_layer = hurtbox_layer
	collision_mask = hurtbox_mask

func _ready() -> void:
	area_entered.connect(on_hurtbox_entered)

## Defines what the hurtbox should do when it detects a hitbox
func on_hurtbox_entered(hitbox: Hitbox) -> void:
	if hitbox == null:
		return

	if owner.has_method("take_damage"):
		owner.take_damage()

# Seems random yes, but the only "hitbox" here with a timer is a projectile
		if hitbox.has_node("./Timer"):
			hitbox.queue_free()
