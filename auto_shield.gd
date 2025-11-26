extends Node2D

@onready var despawn_timer = $DespawnTimer
var current_color


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		if area.my_color == current_color:
			# delete wave
			area.hit_by_shield(current_color)


func _on_despawn_timer_timeout() -> void:
	#when timer ends delete yourself
	self.queue_free()
