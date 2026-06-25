extends Resource
class_name WheelResource

@export var wheel_texture : Texture = preload("res://sprites/wheel placeholder.png")
@export var wheel_details_texture : Texture 

@export var wheel_name : String = "Basic Wheel"
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
