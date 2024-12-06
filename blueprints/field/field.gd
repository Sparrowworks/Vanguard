class_name Field
extends Area2D

## The base class for explosions, noise and effect-inducing zones
##
## This script defines a field effect in a 2D game using Godot's Area2D node.
## The field expands over time and fades out after reaching its maximum radius.
## It can be used for various gameplay mechanics, such as damage zones or area effects.

@export_group("Field Stats")
## The maximum radius the field can reach.
@export var radius:int
## How quickly the field expands to reach its maximum radius (in milliseconds per 1 physics frame).
@export var propagation_speed: float
## The duration (in milliseconds) it takes for the field to fade away after reaching its full radius.
@export var field_fade_time: float

@export_group("Field Emissions")
## Slot for custom field
@export var field:PackedScene
## Slot for custom projectile
@export var projectile:PackedScene

## A reference to the collision shape of the field, used to determine its size and detect overlaps with other objects.
var FIELD:CollisionShape2D
## Manages the fading out of the field after it has reached its maximum size.
var TIMER:Timer

func _ready() -> void:
	FIELD = $CollisionShape2D
	TIMER = $Timer
	TIMER.one_shot = true

	TIMER.wait_time = field_fade_time

func _physics_process(delta: float) -> void:
	if (FIELD.shape.radius == radius && TIMER.time_left <= 0):
		TIMER.start()
		return

	FIELD.shape.radius = min(radius, FIELD.shape.radius + propagation_speed * delta)

func _on_timer_timeout() -> void:
	print("done")
	queue_free()
