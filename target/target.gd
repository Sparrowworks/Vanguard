extends Label

@onready var target_timer: Timer = $Timer

var hitcount: int

func take_damage():
	hitcount += 1
	target_timer.start()
	text = "Ow! you hit me %d times" %[hitcount]
	print("Ow! you hit me %d times" %[hitcount])

func _on_timer_timeout() -> void:
	text = "imagine something you hate so much. now hit this."
