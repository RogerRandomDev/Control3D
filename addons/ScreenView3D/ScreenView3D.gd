@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("ScreenView","res://addons/ScreenView3D/root.gd")


func _exit_tree():
	remove_autoload_singleton("ScreenView")
