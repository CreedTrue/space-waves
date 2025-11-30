extends Node2D

@export var enemy_scene: PackedScene 
@export var auto_shield_scene: PackedScene

# Short pause before waves start spawing
@export var spawn_buffer: float = 50.0

@onready var player = $Player
@onready var spawn_timer = $SpawnTimer
@onready var difficulty_timer = $DifficultyTimer
@onready var score_label = $ScoreLabel
@onready var powerup_ui = $PowerUpUI 
@onready var explosion_bg = $ExplosionBG

var player_time_score: float = 0

# --- NEW STATE VARIABLES ---
var difficulty_level: int = 1
var current_enemy_speed: float = 65.0
var available_colors: Array[ColorSystem.ColorType] = []
var start_time

# --- POWERUP SYSTEM ---
enum PowerupType { SHIELD, BOMB }
var stored_powerups: Array[PowerupType] = []
var max_powerups = 4


func _ready():
	get_tree().paused = false
	# Connect signals
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	difficulty_timer.timeout.connect(_on_difficulty_timer_timeout)
	player.game_over.connect(_on_player_game_over)
	player.power_up_earned.connect(_on_player_powerup_earned)
	player.power_up_progress_set.connect(_on_player_powerup_progress_setup)
	player.power_up_progress_update.connect(_on_player_powerup_progress_update)
	
	# Start the game at level 1
	_set_difficulty(difficulty_level)
	#reset player score when game loads
	start_time = Time.get_unix_time_from_system()
	player_time_score = 0

func _process(delta: float) -> void:
	var current_time = Time.get_unix_time_from_system()
	player_time_score = current_time - start_time
	
	score_label.set_text(str(snapped(player_time_score, 0.01)))
	
	#var autoshields = get_tree().get_nodes_in_group("autoshields") 
	#if autoshields.size() > 1:
		#for autoshield in autoshields:
			#autoshield.get_node("AnimatedSprite2D").modulate = ColorSystem.COLOR_MAP[autoshield.current_color].with_alpha(0.4)
	#
	

# This function runs every 15 seconds (or whatever you set)
func _on_difficulty_timer_timeout():
	difficulty_level += 1
	_set_difficulty(difficulty_level)


# This function holds all your progression logic
func _set_difficulty(level: int):
	print("Advancing to difficulty level ", level)
	match level:
		1:
			# Level 1: Red only, moderate speed
			available_colors = [ColorSystem.ColorType.RED]
			current_enemy_speed = 65.0
			spawn_timer.wait_time = 2.0 # How often to spawn
		2:
			# Level 2: Red and Blue, slightly faster
			available_colors = [ColorSystem.ColorType.BLUE]
			current_enemy_speed = 65.0
			spawn_timer.wait_time = 2.0
		3:
			# Level 3: Green
			available_colors = [ColorSystem.ColorType.GREEN]
			current_enemy_speed = 65.0
			spawn_timer.wait_time = 2.0
		4:
			# Level 4: Red and Green, faster
			available_colors = [ColorSystem.ColorType.RED, ColorSystem.ColorType.GREEN]
			current_enemy_speed = 75.0
			spawn_timer.wait_time = 2.0
		5:
			# Level 5: Red and Blue
			available_colors = [ColorSystem.ColorType.RED, ColorSystem.ColorType.BLUE]
			current_enemy_speed = 75.0
			spawn_timer.wait_time = 2.0
		6:
			# Level 6: All Colors
			available_colors = [ColorSystem.ColorType.RED, ColorSystem.ColorType.BLUE, ColorSystem.ColorType.GREEN]
			current_enemy_speed = 75.0
			spawn_timer.wait_time = 2.0
		_:
			# All levels after 6:
			# Keep all colors, but get faster and spawn faster
			available_colors = [ColorSystem.ColorType.RED, ColorSystem.ColorType.BLUE, ColorSystem.ColorType.GREEN]
			current_enemy_speed += 5.0 # Get 10px faster each level
			spawn_timer.wait_time = max(0.2, spawn_timer.wait_time * 0.95) # 5% faster, but cap at 0.2s


# This function just spawns. It uses the state variables from above.
func _on_spawn_timer_timeout():
	# 1. Get camera and screen boundaries (Your code was perfect)
	var camera = get_viewport().get_camera_2d()
	if not camera: return
	var viewport_size = get_viewport_rect().size
	var cam_transform = camera.get_global_transform()
	var view_top_left = cam_transform.origin - (viewport_size / 2.0) / camera.zoom
	var view_rect = Rect2(view_top_left, viewport_size / camera.zoom)

	# 2. Pick a random edge (Your code was perfect)
	var edge = randi() % 4
	var spawn_position = Vector2()
	match edge:
		0: # Top
			spawn_position.x = randf_range(view_rect.position.x - spawn_buffer, view_rect.end.x + spawn_buffer)
			spawn_position.y = view_rect.position.y - spawn_buffer
		1: # Bottom
			spawn_position.x = randf_range(view_rect.position.x - spawn_buffer, view_rect.end.x + spawn_buffer)
			spawn_position.y = view_rect.end.y + spawn_buffer
		2: # Left
			spawn_position.x = view_rect.position.x - spawn_buffer
			spawn_position.y = randf_range(view_rect.position.y - spawn_buffer, view_rect.end.y + spawn_buffer)
		3: # Right
			spawn_position.x = view_rect.end.x + spawn_buffer
			spawn_position.y = randf_range(view_rect.position.y - spawn_buffer, view_rect.end.y + spawn_buffer)

	# 3. Instance the enemy
	if not enemy_scene:
		print("Error: Enemy scene is not set in the MainWorld script.")
		return
	
	# We cast to "EnemyWave" (the class_name) for type safety
	var enemy = enemy_scene.instantiate() as EnemyWave
	if not enemy: return # Failed to instance

	# 4. Set its position and direction
	enemy.global_position = spawn_position
	var direction_to_player = (player.global_position - enemy.global_position).normalized()
	enemy.move_direction = direction_to_player
	
	# --- SET PROPERTIES BASED ON CURRENT DIFFICULTY ---
	
	# A. Pick a random color from the *available* colors
	var random_color = available_colors.pick_random()
	enemy.set_color(random_color)
	
	# B. Set the speed
	enemy.speed = current_enemy_speed

	# 5. Add it to the scene
	add_child(enemy)

func _on_player_game_over():
	print("main game over called")
	# Make the game over logic here. Probably freeze the waves and have the main player body explode?
	get_tree().paused = true
	ScoreSystem.TIME_SURVIVIED = player_time_score
	ScoreSystem.WAVES_BLOCKED = player.shield.waves_blocked
	print("Time set too:", ScoreSystem.TIME_SURVIVIED, "Waves blocked set too:", ScoreSystem.WAVES_BLOCKED)
	get_tree().change_scene_to_file("res://game_over.tscn")
	

# POWERUP SYSTEM
func _unhandled_input(event):
	if event.is_action_pressed("use_powerup"):
		activate_next_powerup()

# TODO: Create the func for setting the max progress and the progress update func
func _on_player_powerup_progress_setup(max):
	print("Progress set:", max)
	powerup_ui.get_node("ProgressBar").max_value = max

func _on_player_powerup_progress_update(progress):
	print("Progress updated:", progress)
	powerup_ui.get_node("ProgressBar").value = progress

# 1. REWARD LOGIC
func _on_player_powerup_earned():
	if stored_powerups.size() >= max_powerups:
		return # Inventory full
	
	# Pick 0 (Shield) or 1 (Bomb)
	var new_powerup = [PowerupType.SHIELD, PowerupType.SHIELD, PowerupType.BOMB].pick_random()
	stored_powerups.append(new_powerup)
	
	print("Added powerup: ", new_powerup)
	powerup_ui.update_icons(stored_powerups)

# 2. ACTIVATION LOGIC
func activate_next_powerup():
	if stored_powerups.is_empty():
		return
	
	# Pop the first item (FIFO - First In, First Out)
	var powerup_to_use = stored_powerups.pop_front()
	powerup_ui.update_icons(stored_powerups) # Update UI immediately
	
	match powerup_to_use:
		PowerupType.SHIELD:
			cast_shield_powerup()
		PowerupType.BOMB:
			cast_bomb_powerup()

# 3. EFFECTS
func cast_bomb_powerup():
	print("BOOM! Screen cleared.")
	$"/root/AudioMangerScene".play_audio_2d("big_explosion")
	# Get all enemies currently in the scene
	# Note: Ensure your Enemy script has "class_name EnemyWave" or is in a group "enemies"
	var enemies = get_tree().get_nodes_in_group("enemies") 
	
	for enemy in enemies:
		# Optional: Add an explosion effect scene here
		enemy.queue_free()
	flash_explosion()

func flash_explosion():
	explosion_bg.self_modulate.a = 1.0
	
	var tween = create_tween()
	
	# TRANS_CUBIC makes the value change non-linearly (more natural light decay)
	# EASE_OUT means it changes fast at the start and slows down at the end
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(explosion_bg, "self_modulate:a", 0.0, 0.8)
	

	
func cast_shield_powerup():
	print("Shield Activated!")
	$"/root/AudioMangerScene".play_audio_2d("shield_buzz_start")
	# Determine what the shield does. 
	# Example: access the player's shield and make it huge or invincible
	if player.has_node("Shield2"):
		#var shield = player.get_node("Shield2")
		# Example custom function you'd write in your Shield script:
		# shield.activate_super_mode(5.0) # Lasts 5 seconds
		var auto_shield_instance = auto_shield_scene.instantiate()
		var shield_color = player.get_node("Shield2").current_color
		var new_modulate_color =  ColorSystem.COLOR_MAP[shield_color]
		new_modulate_color.a = 0.4
		auto_shield_instance.current_color = shield_color
		auto_shield_instance.get_node("AnimatedSprite2D").modulate = new_modulate_color
		add_child(auto_shield_instance)
