class_name EnemyWave 
extends Area2D

@export var speed: float = 75.0
var move_direction: Vector2 = Vector2.ZERO

signal wave_destroyed

# Sprites base color
var my_color: ColorSystem.ColorType
var damage = 100

# 1. Drag your enemy_explosion.tscn file here in the Inspector
@export var explosion_scene: PackedScene 

func _ready():
	add_to_group("enemies")
	if move_direction != Vector2.ZERO:
		rotation = move_direction.angle()

func _physics_process(delta: float):
	global_position += move_direction * speed * delta

func set_color(new_color: ColorSystem.ColorType):
	my_color = new_color
	# This tints the enemy sprite
	modulate = ColorSystem.COLOR_MAP[my_color]

# Call this function when the logic determines the enemy should die
func hit_by_shield(shield_color: ColorSystem.ColorType):
	if my_color == shield_color:
		spawn_explosion()
		emit_signal("wave_destroyed")
		queue_free()

func hit_by_player_body():
	spawn_explosion()
	spawn_explosion()
	emit_signal("wave_destroyed")
	queue_free()

func spawn_explosion():
	if explosion_scene:
		# 1. Create the instance
		var explosion = explosion_scene.instantiate()
		
		# 2. Add it to the PARENT (the world), not the enemy
		# If we added it to 'self', it would vanish when we queue_free()
		get_parent().add_child(explosion)
		
		# 3. Move it to the enemy's current location
		explosion.global_position = global_position
		
		# 4. Apply the enemy's color to the particles
		# Assuming your ColorSystem returns a standard Godot Color
		explosion.modulate = ColorSystem.COLOR_MAP[my_color]
