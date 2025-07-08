extends Sprite2D

var anim_player: AnimationPlayer

func _ready() -> void:
	anim_player = $AnimationPlayer

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		anim_player.play("attack")
