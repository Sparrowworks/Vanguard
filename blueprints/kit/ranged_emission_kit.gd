class_name RangedEmissionKit
extends Resource

## Base class for kits related to changing ranged emissions.
##
## To create a new kit (or attachment), create a custom resource and assign it this script.
## Simply add the desired PackedScenes
## Note that null variables will be ignored by "equip_emission_kit()"

@export_group("New Emissions")
## New projectile for a gun
@export var new_projectile:PackedScene
## New field for a gun
@export var new_field:PackedScene
