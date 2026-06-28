extends Control

@export var wheel_resource : WheelResource

@onready var name_label: Label = $CenterContainer/NameLabel
@onready var money_label: Label = $Banner/MoneyLabel
@onready var wheel_texture: TextureRect = $WheelTexture

func _process(delta: float) -> void:
	wheel_texture.rotation_degrees += .50

func _ready() -> void:
	if wheel_resource:
		set_wheel()

func set_wheel():
	wheel_texture.texture = wheel_resource.wheel_texture
	money_label.text = "$" + str(wheel_resource.wheel_price)
	name_label.text = wheel_resource.wheel_name

func _on_button_pressed() -> void:
	SignalBus.wheel_changed.emit(wheel_resource)
	#print("hhahahah")
