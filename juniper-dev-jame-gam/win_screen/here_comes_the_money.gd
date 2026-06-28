extends Control

func _process(delta: float) -> void:
	position.y -= 1
	if position.y <= -500:
		queue_free()
