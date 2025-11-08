class_name EnemyWave # <-- Add this line
extends Area2D

@export var speed: float = 75.0
var move_direction: Vector2 = Vector2.ZERO

signal wave_destroyed
# Sprites base color
var my_color: ColorSystem.ColorType

# You can add this back in later!
# @export var explosion_scene: PackedScene 

func _ready():
	add_to_group("enemies") # Good for counting enemies later
	if move_direction != Vector2.ZERO:
		rotation = move_direction.angle()

func _physics_process(delta: float):
	global_position += move_direction * speed * delta

func set_color(new_color: ColorSystem.ColorType):
	my_color = new_color
	modulate = ColorSystem.COLOR_MAP[my_color]

func hit_by_shield(shield_color: ColorSystem.ColorType):
	if my_color == shield_color:
		#if explosion_scene:
			#var explosion = explosion_scene.instantiate()
			#get_parent().add_child(explosion)
			#explosion.global_position = self.global_position
		emit_signal("wave_destroyed")
		
		queue_free()
