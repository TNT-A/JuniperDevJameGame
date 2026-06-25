extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var details_label: Label = $DetailsLabel

@export var rect_color : Color
@export var details : String

func _ready() -> void:
	if rect_color:
		color_rect.color = rect_color
	if details:
		details_label.text = details
