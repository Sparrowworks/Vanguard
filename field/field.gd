extends Payload

var FIELD:CollisionShape2D
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
