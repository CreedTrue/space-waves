# PowerupUI.gd
extends CanvasLayer

@onready var container = $IconContainer

# We need textures for the UI. Drag your icon images here in the Inspector.
@export var shield_icon: Texture2D
@export var bomb_icon: Texture2D

func update_icons(powerup_list: Array):
	# 1. Clear current icons
	for child in container.get_children():
		child.queue_free()
	
	# 2. Rebuild the list based on the array from World
	for type in powerup_list:
		var icon = TextureRect.new()
		
		# Assuming 0 is Shield, 1 is Bomb (matches the Enum in World)
		if type == 0: 
			icon.texture = shield_icon
		elif type == 1:
			icon.texture = bomb_icon
			
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		icon.custom_minimum_size = Vector2(40, 40) # Size of icons
		container.add_child(icon)
