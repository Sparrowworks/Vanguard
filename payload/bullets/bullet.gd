extends Payload

var TIMER:Timer
func _ready() -> void:
	TIMER = $Timer
	TIMER.wait_time = p_range
	TIMER.start()

var direction:Vector2 = Vector2(1,0)
func _physics_process(delta: float) -> void:
	global_position += direction.rotated(rotation) * speed * delta

func _on_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
