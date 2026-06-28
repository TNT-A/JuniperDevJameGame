extends Control
class_name Wheel

@onready var wheel_sprite: TextureRect = $WheelSprite
@onready var ticker_sprite: TextureRect = $TickerSprite
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var happy_sound: AudioStreamPlayer2D = $HappySound
@onready var sad_sound: AudioStreamPlayer2D = $SadSound
@onready var ding_sound: AudioStreamPlayer2D = $DingSound

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
	if !spinning and InfoManager.current_money >= price: #wheel cheap enough 
		InfoManager.current_money -= price
		spin_wheel()

func spin_wheel():
	if result_resource:
		wheel_sprite.rotation = 0
		spinning = true
		audio_stream_player_2d.play()
		var rand_oct : int = randi_range(1, 8)
		var result = result_resource.wheel_results[rand_oct - 1]
		var rand_pos : float = randf_range(2, 43)
		var spin_angle : float = (360 * num_spins) + (rand_oct * 45) - rand_pos
		#print(spin_angle, " ", rand_oct)
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_EXPO)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(wheel_sprite, "rotation_degrees", spin_angle, spin_time)
		await tween.finished 
		spinning = false
		trigger_result(result)
		audio_stream_player_2d.stop()
		SignalBus.wheel_spun.emit()

func trigger_result(result : Array):
	if result[0] == "plus":
		InfoManager.current_money += result[1]
		ding_sound.play()
	if result[0] == "minus":
		InfoManager.current_money -= result[1]
		sad_sound.play()
	if result[0] == "mult":
		InfoManager.current_money *= result[1]
		happy_sound.play()
	if result[0] == "div":
		InfoManager.current_money /= result[1]
		sad_sound.play()

func change_wheel():
	if result_resource:
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
