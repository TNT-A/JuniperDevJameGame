extends Control

@onready var wheel_texture: TextureRect = $WheelTexture

func _process(delta: float) -> void:
	wheel_texture.rotation_degrees += .10
