extends Camera2D

@export_category("Defaults")
@export var base_zoom : Vector2 = Vector2(1.0, 1.0)
@export_category("Tween")
@export var zoom_position : Vector2 = Vector2(320.0, 180.0) # this variable should be where the computer screen is
@export var zoom_amount : Vector2 = Vector2(2.0, 2.0) # how much we have to zoom to make the computer fullscreen
@export var zoom_speed : float = 0.5
var is_zoomed_in : bool = false
var tween : Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_zoomed_in:
		position = Vector2(320.0 + (get_global_mouse_position().x / 25), 180.0 + (get_global_mouse_position().y / 25))
	
	if Input.is_action_just_pressed("camera_zoom"):
		_camera_control()

func _camera_control() -> void:
	if tween:
		tween.kill() # prevents tweens from overlapping
	if is_zoomed_in:
		tween = create_tween()
		tween.tween_property(self, "zoom", base_zoom, zoom_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	else:
		tween = create_tween().set_parallel(true)
		tween.tween_property(self, "zoom", zoom_amount, zoom_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "position", zoom_position, zoom_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	is_zoomed_in = !is_zoomed_in
