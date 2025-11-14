extends Node2D

@onready var main_body = $MainBody2

signal game_over

func _ready() -> void:
	main_body.game_over.connect(_on_main_body_game_over)
	

func _on_main_body_game_over():
	self.visible = false
	game_over.emit()
