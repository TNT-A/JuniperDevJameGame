extends Control
class_name DetailPanel

@onready var chip_texture: TextureRect = $ChipTexture
@onready var details_label: Label = $DetailsLabel

@export var slot : int = 0
@export var wheel_resource : WheelResource

func _ready() -> void:
	set_resource()

func set_resource():
	if wheel_resource:
		chip_texture.texture = wheel_resource.get("detail_texture_" + str(slot))
		details_label.text = wheel_resource.get("detail_info_" + str(slot))
