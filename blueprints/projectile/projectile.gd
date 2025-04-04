class_name Projectile
extends Hitbox

## The base class for all damage-causing object-destroying projectiles
##
## This script serves as a foundation for creating various types of projectiles.

## A timer used to manage the fate of the projectile after it has reached 0.
var TIMER:Timer
@export_group("Projectile Stats")
## Ranges from 0.0 (poor accuracy) to 1.0 (high accuracy),
## Determines how precisely the projectile will hit its target.
@export var accuracy:float
## Defines the maximum angle of deviation for the projectile when fired at zero accuracy.
@export var max_spread:int
## Determines for how long the projectile remains in the world (in seconds)
@export var lifespan:int
## The velocity at which the projectile travels in the game world
@export var speed:int

@export_group("Projectile Emissions")
## Slot for custom field
@export var field:PackedScene
## Slot for custom projectile
@export var projectile:PackedScene

## Internal Vector2 pointing to the right along the X-axis
var direction:Vector2 = Vector2(1,0)
func _ready() -> void:
	var spread:float = (1.0 - accuracy) * max_spread
	var random_angle:float = randf_range(-spread, spread)
	var adjusted_angle = rotation + deg_to_rad(random_angle)
	direction = Vector2(cos(adjusted_angle), sin(adjusted_angle)).normalized()

	TIMER = $Timer
	TIMER.one_shot = true
	TIMER.wait_time = lifespan
	TIMER.start()

func _physics_process(delta: float) -> void:
	global_position += direction.rotated(rotation) * speed * delta

func _on_timer_timeout() -> void:
	queue_free()
