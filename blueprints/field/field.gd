extends Area2D

@export_group("Field Stats")
@export var radius:int
@export var propagation_speed:float # speed at which a field expands and reaches its max radius
@export var field_fade_time:int # time it takes for the field to be removed once it reached its full radius

@export_group("Field Emissions")
@export var field:PackedScene
@export var payload:PackedScene

var FIELD:CollisionShape2D
var TIMER:Timer
func _ready() -> void:
	FIELD = $CollisionShape2D
	TIMER = $Timer
	TIMER.wait_time = field_fade_time

func _physics_process(delta: float) -> void:
	if (TIMER.wait_time < field_fade_time):
		return
	
	FIELD.shape.radius = min(radius, FIELD.shape.radius + propagation_speed * delta)
	
	if (field_fade_time == radius):
		TIMER.start()

func _on_timer_timeout() -> void:
	queue_free()
