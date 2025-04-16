class_name Projectile extends Hitbox

## The base class for all damage-causing object-destroying [Projectile]s.
##
## This script serves as a foundation for creating various types of [Projectile]s.

#region Initialisation Logic
@export_category("Projectile Stats")
## Determines how precisely the [Projectile] will hit its target,
## Ranges from 0.0 (poor accuracy) to 1.0 (high accuracy).
@export var accuracy: float
## Defines the maximum angle of deviation for the [Projectile] when fired at zero [member accuracy].
@export var max_spread: int
## The velocity at which the [Projectile] travels in the game world.
@export var speed: int

## The direction the [Projectile] will point at when shot,
## by default it points to the right along the X-axis.
var direction: Vector2 = Vector2(1,0)

## [method Node2D._enter_tree], calculates the angle of spread to face a [member direction].
func _enter_tree() -> void:
	var spread: float = (1.0 - accuracy) * max_spread
	direction = direction.rotated(deg_to_rad(randf_range(-spread, spread))).normalized()
#endregion

#region Projectile Behavior
@export_category("Projectile Emissions")
## Slot for custom [Field].
@export var field: PackedScene
## Slot for custom [Projectile].
@export var projectile: PackedScene

## Returns direction * speed.
var velocity: Vector2:
	get:
		return direction * speed

## [method Node2D._physics_process], Moves the [Projectile] 
## using it's [member global_position] at a [member direction] * [member speed] * delta.
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
#endregion

#region Misc
## Activates when [member projectile_timer] emits [signal Timer.timeout],
## Executes [method queue_free].
func on_projectile_timer_timeout() -> void:
	queue_free()
#endregion
