extends Melee

@onready var animation_player = $AnimationPlayer

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		animation_player.play("sword_attack")
