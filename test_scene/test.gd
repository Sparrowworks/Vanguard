extends Node2D

func _init() -> void:
	Composer.root = self

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			Composer.load_scene("res://test_scene/test_ranged/test_ranged.tscn")
		1:
			Composer.load_scene("res://test_scene/test_melee/test_melee.tscn")
		_:
			print("Invalid parameter, how did this get here???")
