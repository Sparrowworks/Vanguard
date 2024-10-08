extends Payload

var TIMER:Timer
var direction:Vector2 = Vector2(1,0)
func _ready() -> void:
	var spread:float = (1.0 - accuracy) * max_spread
	var random_angle:float = randf_range(-spread, spread)
	var adjusted_angle = rotation + deg_to_rad(random_angle)
	direction = Vector2(cos(adjusted_angle), sin(adjusted_angle)).normalized()
	
	TIMER = $Timer
	TIMER.wait_time = p_range
	TIMER.start()

func _physics_process(delta: float) -> void:
	global_position += direction.rotated(rotation) * speed * delta

func _on_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
