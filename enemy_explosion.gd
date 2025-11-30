extends GPUParticles2D

func _ready():
	$"/root/AudioMangerScene".play_audio_2d("wave_explosion")
	emitting = true
	
	# Clean up the node once the particles finish playing
	finished.connect(queue_free)
