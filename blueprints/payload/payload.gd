class_name Payload
extends Area2D

var TIMER:Timer
@export_group("Payload Stats")
@export var accuracy:float # 1.0 very accurate / 0.0 complete trash
@export var max_spread:int # the maximum angle in which the bullet the launched when at 0 accuracy
@export var payload_range:int # to evade warning "The variable "range" has the same name as a built-in function."
@export var speed:int

@export_group("Payload Emissions")
@export var field:PackedScene
@export var payload:PackedScene

func _ready() -> void:
	TIMER = $Timer
	TIMER.wait_time = payload_range
	TIMER.start()
