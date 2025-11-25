extends Button


func _on_pressed() -> void:
	print("reset button pressed")
	get_tree().change_scene_to_file("res://world.tscn")
