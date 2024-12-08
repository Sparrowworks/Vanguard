class_name ProjectileKit
extends Resource

## Base class for projectile modifications.
##
## To create a new kit (or attachment), create a custom resource and assign it this script.
## Simply write a percentage and modify_stats will take care of the math,
## your only limitation is how much the float type can handle.

## The percentage by which to increase or decrease the accuracy of the projectile.
@export var accuracy_modifier:float
## The percentage by which to increase or decrease the maximum angle of deviation.
@export var max_spread_modifier:float
## The percentage by which to increase or decrease the time the projectile remains in the world.
@export var lifespan_modifier:float
## The percentage by which to increase or decrease the speed of the projectile.
@export var speed_modifier:float
## The percentage by which to alter the direction of the bullet on the X axis.
@export var x_axis_modifier:float
## The percentage by which to alter the direction of the bullet on the Y axis.
@export var y_axis_modifier:float
