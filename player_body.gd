extends Area2D

var player_health = 500
var max_health = 1000
var base_recovery_rate = 1
@onready var health_label = $HealthLabel

func _ready() -> void:
	health_label.set_text(str(player_health))

func _process(delta: float) -> void:
	if (player_health < max_health):
		player_health += (base_recovery_rate * delta)
		health_label.set_text(str(ceil(int(player_health))))
		

func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("enemies"):
		print("Hit by enemy wave")
		enemy_hit(area.damage)
	
	area.queue_free()


func enemy_hit(damage):
	player_health -= damage
	if player_health < 0:
		player_health = 0
		#Player dead send end game signal
	
	health_label.set_text(str(ceil(int(player_health))))
