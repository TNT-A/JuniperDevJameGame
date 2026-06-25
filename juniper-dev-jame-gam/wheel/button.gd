extends Button

@export var wheel_resource : Resource

func _on_pressed() -> void:
	SignalBus.wheel_changed.emit(wheel_resource)
