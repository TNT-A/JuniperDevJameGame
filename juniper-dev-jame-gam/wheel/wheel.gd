extends Control
class_name Wheel

@onready var wheel_sprite: TextureRect = $WheelSprite
@onready var ticker_sprite: TextureRect = $TickerSprite

@export var num_spins : int = 6
@export var spin_time : float = 5
@export var result_resource : WheelResource

var spinning : bool = false
var hovered : bool = false
var has_sound : bool = false

var price : int = 0
var results : Array[Array] = [
	
]

func _ready() -> void:
	if result_resource:
		change_wheel()

func _process(delta: float) -> void:
	var wheel_rot = int(wheel_sprite.rotation_degrees)
	if hovered == true and Input.is_action_just_pressed("Click"):
		check_spin()
	if wheel_rot % 45 >= -5 and wheel_rot % 45 <= 5:
		ticker_sprite.rotation_degrees = lerp(ticker_sprite.rotation_degrees, -60.0, .8)
	else:
		ticker_sprite.rotation_degrees = lerp(ticker_sprite.rotation_degrees, 0.0, .08)
	if !spinning:
		wheel_sprite.rotation_degrees += .25

func check_spin():
	if !spinning: #wheel cheap enough + unlocked 
		spin_wheel()

func spin_wheel():
	wheel_sprite.rotation = 0
	spinning = true
	var rand_oct : int = randi_range(1, 8)
	var rand_pos : float = randf_range(2, 43)
	var spin_angle : float = (360 * num_spins) + (rand_oct * 45) - rand_pos
	print(spin_angle, " ", rand_oct)
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(wheel_sprite, "rotation_degrees", spin_angle, spin_time)
	await tween.finished 
	spinning = false
	SignalBus.wheel_spun.emit()

func change_wheel():
	wheel_sprite.texture = result_resource.wheel_texture
	results = result_resource.wheel_results
	price = result_resource.wheel_price
	has_sound = result_resource.has_sound
	num_spins = result_resource.num_spins
	spin_time = result_resource.spin_time
	#To be implemented, will change wheel results, sprites, etc based on the current resource

func _on_wheel_sprite_mouse_entered() -> void:
	hovered = true

func _on_wheel_sprite_mouse_exited() -> void:
	hovered = false
