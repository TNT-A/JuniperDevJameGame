extends Camera2D
class_name ScreenShake

var trauma = 0.0
var shake_amount = 0.5
 
func _process(delta):
	if trauma > 0:
		var shake_offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		position += shake_offset
		trauma -= delta * 0.5  # Decrease trauma over time

func shake(intensity: float, shake_a):
	shake_amount = shake_a
	trauma += intensity
