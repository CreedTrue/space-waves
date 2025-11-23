extends Node2D

@onready var main_body = $MainBody2
@onready var place_holder = $PlaceHolder
@onready var shield = $Shield2

signal game_over
signal power_up_earned
signal power_up_progress_set(max)
signal power_up_progress_update(power_up_progress)

func _ready() -> void:
	place_holder.visible = false
	main_body.game_over.connect(_on_main_body_game_over)
	shield.power_up_earned.connect(_on_shield_body_power_up_earned)
	shield.power_up_progress_update.connect(_on_shield_body_power_up_progress_updated)
	shield.power_up_progress_setup.connect(_on_shield_body_power_up_progress_setup)
	

func _on_main_body_game_over():
	main_body.visible = false
	shield.visible = false
	place_holder.visible = true
	
	game_over.emit()

func _on_shield_body_power_up_earned():
	power_up_earned.emit()

func _on_shield_body_power_up_progress_setup(max):
	print("player body progress set:", max)
	power_up_progress_set.emit(max)

func _on_shield_body_power_up_progress_updated(power_up_progress):
	power_up_progress_update.emit(power_up_progress)
