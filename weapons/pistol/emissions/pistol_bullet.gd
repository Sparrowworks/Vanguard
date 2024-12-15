extends Projectile

func _on_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	super._on_timer_timeout()
