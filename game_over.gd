extends Node2D

@onready var time_output = $GameOverUI/VBoxContainer/TimeOutputLabel
@onready var waves_output = $GameOverUI/VBoxContainer/WavesOutputLabel

func _ready() -> void:
	time_output.set_text(str(snapped(ScoreSystem.TIME_SURVIVIED, 0.01)))
	waves_output.set_text(str(ScoreSystem.WAVES_BLOCKED))
	


func _on_restart_button_pressed() -> void:
	print("reset button pressed")
	get_tree().change_scene_to_file("res://world.tscn")
