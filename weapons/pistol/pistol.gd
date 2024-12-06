extends Armature

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()

	if Input.is_action_just_pressed("reload"):
		reload()
