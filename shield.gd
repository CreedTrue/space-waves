extends Area2D

## The shield's maximum rotation speed in radians per second.
@export var max_rotation_speed: float = 5

## How quickly the shield accelerates and decelerates. Higher values are snappier.
@export var acceleration: float = 10.0

var current_rotation_speed: float = 0.0

var current_color: ColorSystem.ColorType

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area):
	# Check if the thing we hit has our "hit_by_shield" function
	if area.has_method("hit_by_shield"):
		# If it does, call it and pass it our current color
		area.hit_by_shield(current_color)

func change_color(new_color: ColorSystem.ColorType):
	current_color = new_color
	# "modulate" tints the shield's sprite
	modulate = ColorSystem.COLOR_MAP[current_color]

func _on_area_exited(area: Area2D) -> void:
	# Check if the thing we hit has our "hit_by_shield" function
	if area.has_method("hit_by_shield"):
		# If it does, call it and pass it our current color
		area.hit_by_shield(current_color)

func _physics_process(delta: float) -> void:
	# 1. Determine the input direction
	var input_direction: float = 0.0
	if Input.is_action_pressed("move_left"):
		input_direction = -1.0
	elif Input.is_action_pressed("move_right"):
		input_direction = 1.0

	# 2. Set the target speed based on input
	var target_rotation_speed = input_direction * max_rotation_speed

	# 3. Smoothly move the current speed towards the target speed
	# lerp() is the key to smoothing. It moves a value towards a target by a weight.
	current_rotation_speed = lerp(current_rotation_speed, target_rotation_speed, acceleration * delta)

	# 4. Apply the smoothed rotation
	# We multiply by delta to make the movement framerate-independent.
	rotate(current_rotation_speed * delta)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("color_1"):
		change_color(ColorSystem.ColorType.RED)

	elif Input.is_action_just_pressed("color_2"):
		change_color(ColorSystem.ColorType.BLUE)

	elif Input.is_action_just_pressed("color_3"):
		change_color(ColorSystem.ColorType.GREEN)
