extends Armature

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		_shoot()
	elif Input.is_action_just_pressed("reload"):
		_reload()
