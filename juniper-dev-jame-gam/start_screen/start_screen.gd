extends Node2D

func _on_button_pressed() -> void:
	$AudioStreamPlayer2D.play()
	var tween = get_tree().create_tween()
	tween.tween_property($ColorRect2, "modulate:a", 1, 1.5)
	await tween.finished
	get_tree().change_scene_to_file("res://game_manager/game_manager.tscn")
