extends Node2D



func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")


func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://controls.tscn")
