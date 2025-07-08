@tool extends EditorPlugin

const AUTOLOAD_NAME = "Composer"

func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/composer_godot/Composer.gd")

func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
