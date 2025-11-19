extends Node2D

@onready var main_body = $MainBody2
@onready var place_holder = $PlaceHolder
@onready var shield = $Shield2

signal game_over
signal power_up_earned

func _ready() -> void:
	place_holder.visible = false
	main_body.game_over.connect(_on_main_body_game_over)
	shield.power_up_earned.connect(_on_shield_body_power_up_earned)
	

func _on_main_body_game_over():
	main_body.visible = false
	shield.visible = false
	place_holder.visible = true
	
	game_over.emit()

func _on_shield_body_power_up_earned():
	power_up_earned.emit()
