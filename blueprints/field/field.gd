class_name Field extends Hitbox

## The base class for explosions, noise and effect-inducing zones
##
## This script defines a [Field] effect in a 2D game using [Hitbox].
## The [Field] expands over time and fades out after reaching its [member max_radius].

#region Initialization Logic
## A reference to the [Field]'s [CollisionShape2D], used to manipulate [member CollisionShape2D.shape.radius]
var field_collision_shape: CollisionShape2D
## Manages what happens to the [Field] after it has reached [member max_radius].
var field_timer: Timer

func _ready() -> void:
	field_collision_shape = $CollisionShape2D
	field_timer = $Timer

	print("field created")
#endregion

#region Expansion logic
@export_category("Field Stats")
## The maximum [member CollisionShape2D.shape.radius] the [Field] should reach.
@export var max_radius: int
## The speed the [Field] expands to reach its maximum [member radius] (in milliseconds per 1 physics frame).
@export var expansion_speed: float

func _physics_process(delta: float) -> void:
	# Stops physics_process if the timer is working.
	if (field_timer.is_stopped() == false):
		return

	# Activates timer when the max_radius has been reached.
	if (field_collision_shape.shape.radius == max_radius):
		field_timer.start()
		return
	else:
		# Increases CollisionShape2D's shape radius while making sure it does not go above max_radius.
		field_collision_shape.shape.radius = min(
			max_radius, field_collision_shape.shape.radius + expansion_speed * delta)
#endregion

#region Misc
## Determines what happens when [member field_timer] timeouts,
## By default it [method Node2D.queue_free] the [Field].
func on_field_timer_timeout() -> void:
	print("field destroyed")
	queue_free()
#endregion
