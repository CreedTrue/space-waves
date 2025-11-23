extends GPUParticles2D

func _ready():
	emitting = true
	# Clean up the node once the particles finish playing
	finished.connect(queue_free)
