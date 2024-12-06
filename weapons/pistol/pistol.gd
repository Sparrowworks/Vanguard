extends Armature

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()
	elif Input.is_action_just_pressed("reload"):
		reload()
