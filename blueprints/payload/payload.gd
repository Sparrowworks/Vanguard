class_name Payload
extends Area2D

## The base class for all damage-causing object-destroying projectiles
##
## This script serves as a foundation for creating various types of projectiles that can inflict damage on targets within the game.

## A timer used to manage the fate of the projectile after it has reached 0.
var TIMER:Timer
@export_group("Payload Stats")
## Ranges from 0.0 (poor accuracy) to 1.0 (high accuracy), Determines how precisely the projectile will hit its target.
@export var accuracy:float
## Defines the maximum angle of deviation for the projectile when fired at zero accuracy.
@export var max_spread:int
## Specifies how far the projectile can travel before it is considered ineffective or destroyed.
@export var payload_range:int # to evade warning "The variable "range" has the same name as a built-in function."
## The velocity at which the projectile travels in the game world
@export var speed:int

@export_group("Payload Emissions")
## Slot for custom field
@export var field:PackedScene
## Slot for custom payload
@export var payload:PackedScene

## Internal Vector2 pointing to the right along the X-axis
var direction:Vector2 = Vector2(1,0)
func _ready() -> void:
	var spread:float = (1.0 - accuracy) * max_spread
	var random_angle:float = randf_range(-spread, spread)
	var adjusted_angle = rotation + deg_to_rad(random_angle)
	direction = Vector2(cos(adjusted_angle), sin(adjusted_angle)).normalized()

	TIMER = $Timer
	TIMER.wait_time = payload_range
	TIMER.start()

func _physics_process(delta: float) -> void:
	global_position += direction.rotated(rotation) * speed * delta

func _on_timer_timeout() -> void:
	queue_free()
