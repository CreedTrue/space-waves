extends Node2D



func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_back_button_button_down() -> void:
	$"/root/AudioMangerScene".play_audio_omni("button_chip") # Replace with function body.


func _on_button_pressed() -> void:
	OS.shell_open("https://www.douglovelock.com/") # Replace with function body.


func _on_button_2_pressed() -> void:
	OS.shell_open("https://tiny-crystal.itch.io/") # Replace with function body.
