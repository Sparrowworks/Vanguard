class_name RangedEmissionKit extends Resource

## Base [Resource] for [Ranged] emissions.
##
## To create a new kit (or attachment), create a custom [Resource] and assign it this [Script]
## and add the new [PackedScene]s.
## [br][br]Null variables are ignored by [method Ranged.equip_emission_kit].

## New [Projectile] for [member Ranged.projectile]
@export var new_projectile: PackedScene
## New [Field] for [member Ranged.field]
@export var new_field: PackedScene
