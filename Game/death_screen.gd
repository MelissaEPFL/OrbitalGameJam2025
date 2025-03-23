extends Node2D

func _on_restart_press():
	get_tree().change_scene_to_file("res://main.tscn")
