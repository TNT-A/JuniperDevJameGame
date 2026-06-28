extends Resource
class_name WheelResource

@export var wheel_texture : Texture = preload("res://sprites/wheel placeholder.png")
@export var wheel_details_texture : Texture 

@export var detail_texture_1 : Texture = preload("res://sprites/red_chip.png")
@export var detail_texture_2 : Texture = preload("res://sprites/blue_chip.png")
@export var detail_texture_3 : Texture = preload("res://sprites/blank_chip.png")
@export var detail_texture_4 : Texture = preload("res://sprites/blank_chip.png")

@export var detail_info_1 : String = " = +2$"
@export var detail_info_2 : String = " = -1$"
@export var detail_info_3 : String = ""
@export var detail_info_4 : String = ""

@export_multiline var wheel_name : String
@export var wheel_price : int = 1
@export var num_spins : int = 6
@export var spin_time : float = 5.0

@export var has_sound : bool = false
@export var sound_strenth : int = 1

@export var wheel_results : Array[Array] = [
	["plus", 2],
	["minus", 1],
	["plus", 2],
	["minus", 1],
	["mult", 2],
	["minus", 1],
	["plus", 2],
	["minus", 1],
]
