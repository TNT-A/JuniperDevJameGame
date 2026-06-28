extends Node2D

var money_scene : PackedScene = preload("res://win_screen/here_comes_the_money.tscn")
var hovered : bool = false

func _physics_process(delta: float) -> void:
	if $TextureRect.global_position.y > 100:
		$TextureRect.global_position.y -= .4
	if hovered:
		$TextureRect.scale = Vector2(1.1,1.1)

func _on_timer_timeout() -> void:
	create_money()

func create_money():
	var money = money_scene.instantiate()
	money.global_position.x = randf_range(-5, 645)
	money.global_position.y = 400
	add_child(money)

func swap_to_menu():
	$ColorRect2.visible = true
	$AudioStreamPlayer2D.stop()
	await get_tree().create_timer(3.5).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect2/ColorRect3, "modulate:a", 1, 1.5)
	await tween.finished
	get_tree().change_scene_to_file("res://start_screen/start_screen.tscn")

func _on_texture_rect_mouse_entered() -> void:
	hovered = true

func _on_texture_rect_mouse_exited() -> void:
	hovered = false

func _on_button_pressed() -> void:
	swap_to_menu()
