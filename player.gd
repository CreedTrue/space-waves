extends Node2D

@onready var main_body = $MainBody2
@onready var place_holder = $PlaceHolder
@onready var shield = $Shield2

signal game_over

func _ready() -> void:
	place_holder.visible = false
	main_body.game_over.connect(_on_main_body_game_over)
	

func _on_main_body_game_over():
	main_body.visible = false
	shield.visible = false
	place_holder.visible = true
	
	game_over.emit()
