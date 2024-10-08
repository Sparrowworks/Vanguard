class_name Payload
extends Area2D

var damage:int
var accuracy:float
var max_spread:int
var p_range:int # to evade warning "The variable "range" has the same name as a built-in function."
var radius:int
var speed:int
var knockback:int
var crit_chance:int

func _configure_payload(dmg, acc, max_sp, rang, rad, spd, kb, cc) -> void:
	damage = dmg
	accuracy = acc
	max_spread = max_sp
	p_range = rang
	radius = rad
	speed = spd
	knockback = kb
	crit_chance = cc
